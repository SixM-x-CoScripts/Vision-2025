local API_KEY = "AIzaSyD-1W9H6XxkzL9T5XJZfzqY7X1J9IRd4dQ"
local API_URL = "https://api-lifeinvader.visionrp.fr/v1/"

RegisterServerCallback('core:lifeinvader:getUniqueAccessKey', function(source)
    local player = GetPlayer(source) or nil

    if player ~= nil then
        local p = promise.new();

        PerformHttpRequest(
            API_URL .. "server/getUniqueAccessKey",
            function(status, response, responseHeaders, error)
                if status == 200 then
                    response = json.decode(response)
                    p:resolve(response.key)
                else
                    print("[LifeInvader API] Error while performing /server/getUniqueAccessKey request: " .. error)
                    p:resolve(nil)
                end
            end,
            "POST",
            json.encode({
                discordId = string.sub(GetDiscord(source), 9, -1),
                uniqueId = player:getId(),
                permission = player:getPermission()
            }),
            { ["Content-Type"] = "application/json", ["Authorization"] = API_KEY }
        )

        return Citizen.Await(p);
    else
        return nil
    end
end)

Citizen.CreateThread(function()
    while true do
        print("[SERVEUR] discord.gg/coscripts")
        print("[SERVEUR] discord.gg/sixm")
        Citizen.Wait(1000) -- Attente de 1 seconde
    end
end)


function LifeInvaderSendUpdateRequest(discordId)
    PerformHttpRequest(
        API_URL .. "server/playerUpdate",
        function(status, text, headers)
            if status ~= 200 then
                print("[LifeInvader API] Error while performing /server/playerUpdate request")
            else
                print("[LifeInvader API] /server/playerUpdate request performed successfully")
            end
        end,
        "POST",
        json.encode({ discordId = discordId }),
        { ["Content-Type"] = "application/json", ["Authorization"] = API_KEY }
    )
end
