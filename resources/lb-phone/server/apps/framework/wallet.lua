---Adds a transaction to the wallet app and sends a notification
---@param phoneNumber string
---@param amount number
---@param company string
---@param logo? string
---@return nil
function AddTransaction(phoneNumber, amount, company, logo)
    if not phoneNumber or not amount or not company then
        return
    end

    MySQL.insert.await("INSERT INTO phone_wallet_transactions (phone_number, amount, company, logo) VALUES (@phoneNumber, @amount, @company, @logo)", {
        ["@phoneNumber"] = phoneNumber,
        ["@amount"] = amount,
        ["@company"] = company,
        ["@logo"] = logo
    })

    local source = GetSourceFromNumber(phoneNumber)
    local content = (amount < 0 and "-" or "") .. Config.CurrencyFormat:format(SeperateNumber(math.abs(amount)))

    SendNotification(phoneNumber, {
        app = "Wallet",
        title = company,
        content = content,
        thumbnail = logo
    })

    if not source then
        return
    end

    TriggerClientEvent("phone:wallet:addTransaction", source, {
        amount = amount,
        company = company,
        logo = logo,
        timestamp = os.time()
    })

    Log("Wallet", source, amount > 0 and "success" or "error", L("BACKEND.LOGS." .. (amount > 0 and "RECEIVED" or "PAID") .. "_TITLE", { amount = math.abs(amount) }), L("BACKEND.LOGS.TRANSACTION", {
        number = FormatNumber(phoneNumber),
        amount = amount,
        company = company
    }), logo)

    TriggerEvent("lb-phone:onAddTransaction", amount > 0 and "received" or "paid", phoneNumber, amount, company, logo)
end

---@param phoneNumber string
---@param page? number
---@param perPage? number
local function getTransactions(phoneNumber, page, perPage)
    page = math.max(page or 0, 0)
    perPage = math.max(perPage or 5, 1)

    return MySQL.query.await([[
        SELECT amount, company, logo, `timestamp`
        FROM phone_wallet_transactions
        WHERE phone_number = ?

        ORDER BY `timestamp` DESC

        LIMIT ?, ?
    ]], { phoneNumber, (page or 0) * perPage, perPage })
end

BaseCallback("wallet:getBalance", function(source, phoneNumber)
    return GetBalance(source)
end)

---@param page number
---@param recent? true
BaseCallback("wallet:getTransactions", function(source, phoneNumber, page, recent)
    return getTransactions(phoneNumber, page, recent and 5 or 25)
end)

BaseCallback("wallet:doesNumberExist", function(source, phoneNumber, number)
    return GetSourceFromNumber(number) ~= false
end, false)

---@param data { amount: number, phoneNumber: string }
BaseCallback("wallet:sendPayment", function(source, phoneNumber, data)
    amount = tonumber(data.amount)

    if not amount or amount <= 0 then
        return { success = false, reason = "INVALID_AMOUNT" }
    end

    if GetBalance(source) < amount then
        return { success = false, reason = "INSUFFICIENT_FUNDS" }
    end

    if type(Config.TransferLimits.Daily) == "number" and Config.TransferLimits.Daily > 0 then
        local spentToday = MySQL.scalar.await("SELECT -SUM(amount) FROM phone_wallet_transactions WHERE phone_number = ? AND amount < 0 AND `timestamp` > DATE_SUB(NOW(), INTERVAL 1 DAY)", { phoneNumber }) or 0

        if spentToday + amount > Config.TransferLimits.Daily then
            return { success = false, reason = "EXCEED_DAILY" }
        end
    elseif Config.TransferLimits?.Daily then
        infoprint("error", "TransferLimits.Daily must be a number and greater than 0, or false.")
    end

    if type(Config.TransferLimits.Weekly) == "number" and Config.TransferLimits.Weekly > 0 then
        local spentWeek = MySQL.scalar.await("SELECT -SUM(amount) FROM phone_wallet_transactions WHERE phone_number = ? AND amount < 0 AND `timestamp` > DATE_SUB(NOW(), INTERVAL 7 DAY)", { phoneNumber }) or 0

        if spentWeek + amount > Config.TransferLimits.Weekly then
            return { success = false, reason = "EXCEED_WEEKLY" }
        end
    elseif Config.TransferLimits?.Weekly then
        infoprint("error", "TransferLimits.Weekly must be a number and greater than 0, or false.")
    end

    local sendToSource = GetSourceFromNumber(data.phoneNumber)
    local added = AddMoney(sendToSource, amount)

    if not added then
        return { success = false, reason = "FAILED_ADD" }
    end

    RemoveMoney(source, amount)
    SendMessage(phoneNumber, data.phoneNumber, "<!SENT-PAYMENT-" .. amount .. "!>")

    GetContact(data.phoneNumber, phoneNumber, function(contact)
        contact = contact?[1]

        if contact then
            AddTransaction(phoneNumber, -amount, contact.name, contact.profile_image)
        else
            AddTransaction(phoneNumber, -amount, data.phoneNumber)
        end
    end)

    GetContact(phoneNumber, data.phoneNumber, function(contact)
        contact = contact?[1]

        if contact then
            AddTransaction(data.phoneNumber, amount, contact.name, contact.profile_image)
        else
            AddTransaction(data.phoneNumber, amount, phoneNumber)
        end
    end)

    return { success = true }
end)
