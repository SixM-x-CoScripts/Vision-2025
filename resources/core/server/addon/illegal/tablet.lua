--[[local livraison = {}
local veh = {
    "pony",
    "burrito",
    "burrito3",
    "rumpo2",
    "youga2",
    "granger",
    "baller",
    "landstalker",
    "moonbeam",
    "moonbeam2",
    "bobcatxl",
    "cavalcade"
}

RegisterNetEvent("core:NotificationStart")
AddEventHandler("core:NotificationStart", function(token, crew, pos)
    if CheckPlayerToken(source, token) then
        TriggerClientEvent('core:NotificationStart', -1, crew, pos)
    end
end)
RegisterNetEvent("core:StartMission")
AddEventHandler("core:StartMission", function(token, pos)
    if CheckPlayerToken(source, token) then
        for k, v in pairs(livraison) do
            local hour = os.date("%H:%M")
            if tostring(v.time) == tostring(hour) then
                TriggerClientEvent('core:StartMission', -1, v, pos)

            end
        end
    end
end)
local WebHook = 'https://discord.com/api/webhooks/1046093551123042364/CyVw2hCYzUDByaMKG8H3f1kwCiyvIk5EW_b7MyXy3UsiAvvI-D9RygaL2N8GGP2HoFt6'

function DiscordDebug(color, name, message, footer)
    local embed = {
        {
            ['color']       = color,
            ['title']       = '**' .. name .. '**',
            ['description'] = message,
            ['footer']      = {
                ['text'] = footer,
            },
        }
    }
    PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embed })
        , { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("core:Addlivraison")
AddEventHandler("core:Addlivraison", function(token, time, item, quantity, price, rank, crew, pos)
    local source = source
    if CheckPlayerToken(source, token) then
        if json.encode(livraison) == "[]" then
            table.insert(livraison, {
                id = source,
                time = time,
                item = item,
                quantity = quantity,
                price = price,
                rank = rank,
                crew = crew,
                pos = pos
            })
            SendDiscordLog("tablet", source, string.sub(GetDiscord(source), 9, -1),
                GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), crew,
                item .. " " .. quantity)
            DiscordDebug(16753920, "DEBUG",
                "Pos : x : " ..
                pos.x .. " y : " .. pos.y .. " z : " .. pos.z ..
                "\n Crew : " .. crew .. "\n Commande : " .. item .. " " .. quantity, "\n Temps : " .. time)
            return
        else
            for k, v in pairs(livraison) do
                if v.time == time and v.crew == crew then
                    TriggerClientEvent("core:ShowAdvancedNotification", source, "Simeon", "",
                        "Votre crew a déjà une livraison à cette heure ci", "CHAR_CASTRO", "CHAR_CASTRO")
                    return
                else
                    table.insert(livraison, {
                        id = source,
                        time = time,
                        item = item,
                        quantity = quantity,
                        price = price,
                        rank = rank,
                        crew = crew,
                        pos = pos
                    })
                    SendDiscordLog("tablet", source, string.sub(GetDiscord(source), 9, -1),
                        GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), crew,
                        item .. " " .. quantity)
                    DiscordDebug(16753920, "DEBUG",
                        "Pos : x : " ..
                        pos.x ..
                        " y : " .. pos.y .. " z : " .. pos.z ..
                        "\n Crew : " .. crew .. "\n Commande : " .. item .. " " .. quantity, "\n Temps : " .. time)
                    return
                end
            end
        end
    end
end)

CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(1)
    end
    RegisterServerCallback("core:getHoraireTablette", function(source, horaire, crew)
        for k, v in pairs(livraison) do
            if v.time == horaire and v.crew == crew then
                TriggerClientEvent("core:ShowAdvancedNotification", source, "Simeon", "",
                    "Votre crew a déjà une livraison à cette heure ci", "CHAR_CASTRO", "CHAR_CASTRO")
                return false
            end
        end
        return true
    end)
end)
local commande = false
Citizen.CreateThread(function()
    while true do
        Wait(1 * 50000) -- 50 seconds
        local hour = os.date("%H:%M")
        local numberToRemove = {}
        for k, v in pairs(livraison) do
            if tostring(v.time) == tostring(hour) then
                commande = false
                TriggerClientEvent("core:StartMission", -1, v)                
                TriggerClientEvent("core:StartMissionBlips", -1, v)
                for key, value in pairs(players) do
                    if GetPlayer(key):getCrew() == v.crew then
                        if not commande then
                            commande = true
                            TriggerClientEvent("core:NotifAndSpawnTablet", key, v)
                            TriggerEvent("core:startLivraison", v)
                        end
                    end
                end
                --for i = 1, #livraison do
                --    print(i, k)
                --    if i == k then
                --        table.remove(livraison, i)
                --    end
                --end
                table.insert(numberToRemove, k)
            end
        end
        for k, v in pairs(numberToRemove) do
            for kk, vv in pairs(livraison) do
                if(vv.time == hour) then
                    table.remove(livraison, kk)
                end
            end
        end
    end
end)

RegisterNetEvent("core:startLivraison")
AddEventHandler("core:startLivraison", function(data)
    local vehs = math.random(1, #veh)
    local pos = data.pos
    local veh = CreateVehicle(GetHashKey(veh[vehs]), pos.x, pos.y, pos.z, pos.w, true, true)
    while not DoesEntityExist(veh) do
        Wait(1)
    end
    SetVehicleDoorsLocked(veh, 1)
    -- Onesync vehicle exist for everyone
    SetEntityDistanceCullingRadius(veh, 9999.9)
    local plate = GetVehicleNumberPlateText(veh)
    local index = GetVehicleIndexFromPlate(plate)
    vehicle:new({
        plate = plate,
        owner = nil,
        name = veh[vehs],
        props = json.encode({}),
        garage = nil,
        stored = 1,
        vente = nil,
        coowner = json.encode({}),
        job = nil,
        inventory = json.encode({}),
        mileage = 0,
        fuel = 100,
        body = json.encode({}),
        currentPlate = plate
    })
    AddItemToInventoryVehicleStaff(plate, data.item, tonumber(data.quantity), {})
    MarkVehicleAsNotSaved(index, plate)
    Wait(1000)
    SetVehicleDoorsLocked(veh, 1)
end)]]