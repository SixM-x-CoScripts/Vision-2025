-- this is just some stupid stuff that i thought it would be cool to have.
-- what it does? It will load/unload music depends on item you have in inventory.
_MusicList = {}

_ItemList = {
    --["item_name"] = "name of the other item in array",
    ["musicdesk1"] = "Never gonna givey you up!",
    ["musicdesk2"] = "He's a Pirate",
    ["musicdesk3"] = "Ra-Ra-Rasputin",
    ["musicdesk4"] = "Revenge",
}

if Config.FrameWork == 2 then
    local QB = exports["qb-core"].GetCoreObject()

    RegisterNetEvent(TriggerName("PreOpenEvent"))
    AddEventHandler(TriggerName("PreOpenEvent"), function()
        UpdateMusic()
    end)

    function UpdateMusic()
        for k, v in pairs(_ItemList) do
            TriggerEvent(TriggerName("RemoveMusicTemplate"), v)
        end
        Wait(33)
        for k, v in ipairs(QB.Functions.GetPlayerData().items or {}) do
            if v.amount > 0 then
                if _ItemList[v.name] then
                    TriggerEvent(TriggerName("AddMusicTemplate"), _ItemList[v.name], _MusicList[_ItemList[v.name]])
                end
            end
        end
    end
end

if Config.FrameWork == 1 then
    local PlayerData = {}
    local ESX = nil

    CreateThread(function()
        while ESX == nil do
            Wait(10)
            TriggerEvent(Config.ESX, function(obj) ESX = obj end)
        end

        if ESX.IsPlayerLoaded() then
            PlayerData = ESX.GetPlayerData()
            UpdateMusic()
        end
    end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
        UpdateMusic()
    end)

    function UpdateMusic()
        for k, v in pairs(_ItemList) do
            TriggerEvent(TriggerName("RemoveMusicTemplate"), v)
        end
        PlayerData = ESX.GetPlayerData()
        Wait(33)
        for k, v in ipairs(PlayerData.inventory or {}) do
            if v.count > 0 then
                if _ItemList[v.name] then
                    TriggerEvent(TriggerName("AddMusicTemplate"), _ItemList[v.name], _MusicList[_ItemList[v.name]])
                end
            end
        end
    end

    RegisterNetEvent('esx:removeInventoryItem')
    AddEventHandler('esx:removeInventoryItem', UpdateMusic)

    RegisterNetEvent('esx:addInventoryItem')
    AddEventHandler('esx:addInventoryItem', UpdateMusic)
end