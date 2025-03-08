RegisterNetEvent("emotes:AskForSharedEmote")
AddEventHandler("emotes:AskForSharedEmote", function(player, emote)
    local source = source
    TriggerClientEvent("emotes:AskForSharedEmote", player, emote, source)
end)

RegisterNetEvent("emotes:AcceptSharedEmote")
AddEventHandler("emotes:AcceptSharedEmote", function(emote, player)
    TriggerClientEvent("emotes:PlaySharedEmote", player, emote, 1, source)
    TriggerClientEvent("emotes:PlaySharedEmote", source, emote, 2, player)
end)

RegisterNetEvent("emotes:StopEmote")
AddEventHandler("emotes:StopEmote", function(player)
    TriggerClientEvent("emotes:StopEmote", player)
end)

RegisterNetEvent("emotes:CloneEmote")
AddEventHandler("emotes:CloneEmote", function(player)
    local _src = source
    TriggerClientEvent("emotes:RequestCloneEmote", player, _src)
end)

RegisterNetEvent("emotes:GiveEmoteCloned")
AddEventHandler("emotes:GiveEmoteCloned", function(player, emote)
    TriggerClientEvent("emotes:PlayEmote", player, emote)
end)