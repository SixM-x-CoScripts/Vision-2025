---------------------------------------------------------------
-- Variables
---------------------------------------------------------------
local CachedPianos = {}
local PlayerPocketPianoCount = {}
local ESX = nil
local QBCore = nil
---------------------------------------------------------------
-- FrameWork stuff
---------------------------------------------------------------
-- only if the script is on standalone, we shall allow to place it anywhere.
if Config.FrameWork == 0 then
    RegisterCommand("piano", function(source, args, rawCommand)
        if source ~= 0 then
            if PlayerPocketPianoCount[source] == nil then
                PlayerPocketPianoCount[source] = Config.DefaultPocketPianoCount
            end

            if PlayerPocketPianoCount[source] == 0 then
                TriggerClientEvent(TriggerName("ShowHelpNotification"), source, _U("not enough pianos"))
            else
                PlayerPocketPianoCount[source] = PlayerPocketPianoCount[source] - 1
                TriggerClientEvent(TriggerName("PlacePianoDown"), source)
            end
        end
    end, false)
end

if Config.FrameWork == 1 then
    TriggerEvent(Config.ESX, function(obj) ESX = obj end)

    ESX.RegisterUsableItem("piano", function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem("piano", 1)

        TriggerClientEvent(TriggerName("PlacePianoDown"), source)
    end)
end

if Config.FrameWork == 2 then
    QBCore = exports["qb-core"].GetCoreObject()

    QBCore.Functions.CreateUseableItem("piano", function(source)
        local qbPlayer = QBCore.Functions.GetPlayer(source)
        qbPlayer.Functions.RemoveItem("piano", 1, false)

        TriggerClientEvent(TriggerName("PlacePianoDown"), source)
    end)
end
---------------------------------------------------------------
-- Events
---------------------------------------------------------------
RegisterNetEvent(TriggerName("SetActivePiano"), function(netID, status)
    CachedPianos[netID] = status
    TriggerClientEvent(TriggerName("FetchCache"), -1, CachedPianos)
end)

RegisterNetEvent(TriggerName("CanPlayPiano"), function(netID)
    if CachedPianos[netID] == false then
        CachedPianos[netID] = true
        TriggerClientEvent(TriggerName("CanPlayPiano"), source, netID)
    end
end)

RegisterNetEvent(TriggerName("PickUpPiano"), function(netID)
    local source = source
    if CachedPianos[netID] == false then
        CachedPianos[netID] = nil
        local entity = NetworkGetEntityFromNetworkId(netID)
        if DoesEntityExist(entity) then
            if Config.FrameWork == 0 then
                DeleteEntity(entity)

                if PlayerPocketPianoCount[source] == nil then
                    PlayerPocketPianoCount[source] = Config.DefaultPocketPianoCount
                end

                PlayerPocketPianoCount[source] = PlayerPocketPianoCount[source] + 1
            end

            if Config.FrameWork == 1 then
                local xPlayer = ESX.GetPlayerFromId(source)

                if xPlayer.canCarryItem == nil then
                    xPlayer.canCarryItem = function(item, amount)
                        local xItem = xPlayer.getInventoryItem(item, amount)
                        if xItem then
                            return xItem.limit >= (xItem.count + amount)
                        end
                        return false
                    end
                end

                if xPlayer.canCarryItem("piano", 1) then

                    DeleteEntity(entity)

                    xPlayer.addInventoryItem("piano", 1)
                end
            end

            if Config.FrameWork == 2 then
                local qbPlayer = QBCore.Functions.GetPlayer(source)
                if qbPlayer.Functions.AddItem("piano", 1, false) then
                    DeleteEntity(entity)
                end
            end

            TriggerClientEvent(TriggerName("FetchCache"), -1, CachedPianos)
        end
    end
end)

RegisterNetEvent(TriggerName("FetchCache"), function()
    TriggerClientEvent(TriggerName("FetchCache"), source, CachedPianos)
end)

RegisterNetEvent(TriggerName("DeleteFromCache"), function(netID)
    CachedPianos[netID] = nil
end)