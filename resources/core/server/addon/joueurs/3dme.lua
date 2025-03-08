-- Pre-load the language
local lang = Languages[Config.language]

local function antiRpSex(source, text)
    if GetPlayer(source):getPermission() >= 5 then
        return false
    end

    local banned_words = {
        "suce", "bite", "sex", "cochonne", "baise", "chatte", "viol", "fellation", "bande", "mouille"
    }

    for i = 1, #banned_words do
        if string.match(text, banned_words[i]) then
            DropPlayer(source, "Frérot? Tu es cringe arrête ça vas trouver un travail ou une meuf")
            return true
        end
    end

    return false
end


RegisterNetEvent("core:sendtext", function(players, texttosend)

    if string.match(texttosend, "src=") then
        DropPlayer(source, "Bah alors mon loulou t'essaye de faire quoi la?")
    else
        local source = source
        SendDiscordLog("3DME", source, string.sub(GetDiscord(source), 9, -1),
                GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), texttosend)
        TriggerClientEvents("3dme:shareDisplay", players, texttosend, source)
    end
end)

RegisterNetEvent("core:dev:sendtext", function(playerId, players, text)
    print("core:dev:sendtext " .. playerId .. " " .. text)

    if string.match(text, "src=") then
        DropPlayer(source, "Bah alors mon loulou t'essaye de faire quoi la?")
    else
        local source = source

        if antiRpSex(source, text) then
            return
        end

        SendDiscordLog(
            "3DME", 
            playerId, 
            string.sub(GetDiscord(playerId), 9, -1),
            GetPlayer(playerId):getLastname() .. " " .. GetPlayer(playerId):getFirstname(), 
            text .. " - Forced by dev tools from player " .. source
        )
        TriggerClientEvents("3dme:shareDisplay", players, text, playerId)
    end

end)