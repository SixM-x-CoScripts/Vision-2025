-- Get open companies
local lastRefresh = 0
local refreshInterval = 60 -- refresh at most once every 60 seconds

lib.RegisterCallback("phone:services:getOnline", function(_, cb)
    if (lastRefresh + refreshInterval) < os.time() and RefreshCompanies then
        RefreshCompanies()
        lastRefresh = os.time()
    end

    cb(Config.Companies.Services)
end)

local allowedCompanies = {}

for i = 1, #Config.Companies.Services do
    allowedCompanies[Config.Companies.Services[i].job] = true
end

-- Messages
local function getChannel(company, phoneNumber)
    local channel = MySQL.scalar.await("SELECT id FROM phone_services_channels WHERE company = ? AND phone_number = ?", { company, phoneNumber })

    if channel then
        return channel
    end

    local id = GenerateId("phone_services_channels", "id")

    MySQL.update.await("INSERT INTO phone_services_channels (id, company, phone_number) VALUES (?, ?, ?)", { id, company, phoneNumber })

    return id
end

---@param job string
BaseCallback("services:getChannelId", function (source, phoneNumber, job)
    return getChannel(job, phoneNumber)
end)

---@param channelId string
---@param company string
---@param message string
---@param anonymous? boolean
BaseCallback("services:sendMessage", function(source, phoneNumber, channelId, company, message, anonymous)
    if not company or not allowedCompanies[company] then
        debugprint("company not allowed", company, allowedCompanies)
        return
    end

    if anonymous then
        phoneNumber = L("BACKEND.SERVICES.ANONYMOUS")
        channelId = getChannel(company, phoneNumber)
    end

    debugprint("phone:services:sendMessage, company:", company, " message:", message)

    if not channelId then
        channelId = getChannel(company, phoneNumber)
    end

    local contacter = MySQL.scalar.await("SELECT phone_number FROM phone_services_channels WHERE id = ?", { channelId })
    local isContacter = contacter == phoneNumber
    local x, y

    if isContacter then
        local coords = GetEntityCoords(GetPlayerPed(source))

        x = coords.x
        y = coords.y
    end

    local messageId = GenerateId("phone_services_messages", "id")
    MySQL.update.await([[
        INSERT INTO phone_services_messages (id, channel_id, sender, message, x_pos, y_pos)
        VALUES (@id, @channelId, @sender, @message, @xPos, @yPos)
    ]], {
        ["@id"] = messageId,
        ["@channelId"] = channelId,
        ["@sender"] = phoneNumber,
        ["@message"] = message,
        ["@xPos"] = x,
        ["@yPos"] = y
    })

    TriggerClientEvent("phone:services:newMessage", -1, {
        channelId = channelId,
        id = messageId,
        sender = phoneNumber,
        content = message,
        x = x,
        y = y
    })

    if isContacter then -- if it was sent by the original contacter, alert all employees
        local employees = GetEmployees(company)

        for i = 1, #employees do
            local employeeNumber = GetEquippedPhoneNumber(employees[i])

            if not employeeNumber then
                goto continue
            end

            SendNotification(employeeNumber, {
                source = employees[i],

                app = "Services",
                title = L("BACKEND.SERVICES.NEW_MESSAGE"),
                content = message
            })

            ::continue::
        end
    else
        -- alert the contacter
        SendNotification(contacter, {
            app = "Services",
            title = L("BACKEND.SERVICES.NEW_MESSAGE"),
            content = message
        })
    end

    Log("Services", source, "info", L("BACKEND.LOGS.NEW_SERVICE_TITLE"), L("BACKEND.LOGS.NEW_SERVICE_CONTENT", {
        sender = FormatNumber(phoneNumber),
        channel = company,
        message = message
    }))

    MySQL.update("UPDATE phone_services_channels SET last_message = SUBSTRING(?, 1, 50) WHERE id = ?", { message, channelId })

    return messageId
end)

---@param page? number
BaseCallback("services:getRecentMessages", function(source, phoneNumber, page)
    return MySQL.query.await([[
        SELECT id, phone_number, company, company, last_message, `timestamp`
        FROM phone_services_channels
        WHERE phone_number = ? OR company = ?
        ORDER BY `timestamp` DESC
        LIMIT ?, ?
    ]], { phoneNumber, GetJob(source), (page or 0) * 25, 25 })
end)

---@param channelId string
---@param page? number
BaseCallback("services:getMessages", function(source, phoneNumber, channelId, page)
    return MySQL.query.await([[
        SELECT id, sender, message, x_pos, y_pos, `timestamp`
        FROM phone_services_messages
        WHERE channel_id = ?
        ORDER BY `timestamp` DESC
        LIMIT ?, ?
    ]], { channelId, (page or 0) * 25, 25 })
end)

---@param channelId string
BaseCallback("services:deleteChannel", function(source, phoneNumber, channelId)
    if not Config.Companies.DeleteConversations then
        return false
    end

    local success = MySQL.update.await("DELETE FROM phone_services_channels WHERE id = ? AND company = ?", { channelId, GetJob(source) }) > 0

    if not success then
        return false
    end

    TriggerClientEvent("phone:services:channelDeleted", -1, channelId)

    return true
end, false)

---@param company string
---@return { firstname: string, lastname: string, grade: string, number?: string, online: boolean }[] employees
BaseCallback("services:getEmployees", function(source,eNumber, company)
    if not Config.Companies.SeeEmployees or Config.Companies.SeeEmployees == "none" or not allowedCompanies[company] or not GetAllEmployees then
        return {}
    end

    if Config.Companies.SeeEmployees == "employees" and GetJob(source) ~= company then
        return {}
    end

    ---@type { firstname: string, lastname: string, grade: string, number?: string, online: boolean }[]
    local employees = GetAllEmployees(company)

    for i = 1, #employees do
        local employee = employees[i]

        employee.online = employee.number and GetSourceFromNumber(employee.number) ~= nil or false
    end

    return employees
end, {})
