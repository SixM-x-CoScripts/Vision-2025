RegisterNetEvent("emotes:AskForSharedEmote")
AddEventHandler("emotes:AskForSharedEmote", function(emote, player)
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 5,
        content = "Appuyer sur ~K Y pour accepter l'animation ~s".. emote[3]
    })
    CreateThread(function()
        local timeout = GetGameTimer() + 5000
        while GetGameTimer() < timeout do
            if IsControlJustPressed(0, 246) then
                TriggerServerEvent("emotes:AcceptSharedEmote", emote, player)
                return
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent("emotes:PlaySharedEmote")
AddEventHandler("emotes:PlaySharedEmote", function(emote, role, player)
    if role == 1 then
        PlaySharedEmote(emote, player)
    elseif role == 2 then
        emote = EmotesList.Shared[emote[4]]
        PlaySharedEmote(emote, player)
    end
end)

RegisterNetEvent("emotes:StopEmote")
AddEventHandler("emotes:StopEmote", function()
    StopEmote()
end)

RegisterCommand("e", function(source, args)
    local emote = args[1]
    if emote == nil then
        return
    end
    if emote == "c" then 
        StopEmote()
    end
    -- find the emote in all emotes
    for _, emoteList in pairs(EmotesList) do
        for emoteName, emoteItem in pairs(emoteList) do
            if emoteName == emote then
                emote = emoteItem
                break
            end
        end
    end

    if emote == nil then
        return
    end

    PlayEmote(emote)
end)

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

RegisterCommand("walk", function(source, args)
    if not args[1] then return end 
    local arg = firstToUpper(args[1])
    if EmotesList.Walks[arg] then 
        RequestWalking(EmotesList.Walks[arg][1])
        SetPedMovementClipset(GetPlayerPed(-1), EmotesList.Walks[arg][1], 0.2)
        SetResourceKvp('demarcheVision',tostring(EmotesList.Walks[arg][1]))
    end
end)

RegisterCommand("nearby", function(source, args)
    if not args[1] then return end 
    local arg = args[1]
    if not EmotesList.Shared[arg] then return end
    local player = exports["core"]:ChoicePlayersInZone(3.0, true)
    if player ~= nil then
        TriggerServerEvent("emotes:AskForSharedEmote", GetPlayerServerId(player), EmotesList.Shared[arg])
    end
end)

RegisterNetEvent("emotes:RequestCloneEmote")
AddEventHandler("emotes:RequestCloneEmote", function(player)
    local emotes = GetCurrentEmote()
    if emotes == nil then
        return
    end
    TriggerServerEvent("emotes:GiveEmoteCloned", player, emotes)
end )

RegisterNetEvent("emotes:PlayEmote")
AddEventHandler("emotes:PlayEmote", function(emote)
    PlayEmote(emote)
end)

CreateThread(function()
    while not HasModelLoaded(GetEntityModel(PlayerPedId())) do Wait(500) end
    Wait(250)
    local demarche = GetResourceKvpString('demarcheVision')
    GetFavoriteEmotesFromCache()
    if demarche then 
        RequestWalking(demarche)
        SetPedMovementClipset(GetPlayerPed(-1), demarche, 0.2)
    end
end)