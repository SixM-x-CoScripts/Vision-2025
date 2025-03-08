Config.LogWebhook = ""

function SendDiscordMessage(name, message)
    local footer = "rcore:discord | rcore.cz"
    local color = 56108
    local embeds = {
        {
            ["title"] = name,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }

    PerformHttpRequest(Config.LogWebhook, function(err, text, headers) end, 'POST', json.encode({ username = name, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

function PerformedDiscordMessage(source, data)
    local rock, steam = PlayerIdentifier(source, "license:"), PlayerIdentifier(source, "steam:")
    SendDiscordMessage("Quelqu'un joue de la radio !", string.format("Player ID: %s\nPlayer name: %s\nIs playing music: %s\nOn position: %s\nPlayer identifier (rockstar): %s\nPlayer identifier (steam): %s", source, GetPlayerName(source), data.url, GetEntityCoords(GetPlayerPed(source)), rock, steam))
end