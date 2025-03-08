Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    
    SetDiscordAppId(1140671762779082822)
    SetDiscordRichPresenceAsset("visionlogo")
    SetDiscordRichPresenceAssetText("discord.gg/visionrp")

    SetDiscordRichPresenceAction(0, "Jouer", "fivem://connect/cfx.re/join/rky7g8")
    SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/visionrp")
    
    while true do 
        SetRichPresence("Vision - "..GlobalState["nbJoueur"].. " joueurs connectés")
        Wait(15000)
    end
end)