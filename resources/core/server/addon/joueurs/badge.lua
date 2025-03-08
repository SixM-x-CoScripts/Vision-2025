RegisterServerEvent("core:UseBadge")
AddEventHandler("core:UseBadge", function(token, service, name, matricule, grade, photo, divisions, target)
    local src = source
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:UseBadge", target, service, name, matricule, grade, photo, divisions)
    end
end)

RegisterServerEvent("core:sendHeadshot")
AddEventHandler("core:sendHeadshot", function(token, base64, data, name)
    local src = source
    if CheckPlayerToken(src, token) then
        base64 = base64:gsub('"', '')
        local url = nil
        PerformHttpRequest("https://cdn.sacul.cloud/vision-mugshot/FA", function(err, result, headers)
            if err ~= 200 then
                print("HTTP request failed with error code: " .. err)
                return
            end

            local response = json.decode(result)
            if not response or not response.url then
                print("Failed to decode response or missing URL")
                return
            end

            url = response.url

            local badge = {
                service = data.service,
                name = name,
                matricule = data.matricule,
                grade = data.grade,
                photo = url,
                divisions = data.divisions
            }

            GiveItemToPlayer(src, 
            "badge_"..data.service,
            1,
            badge)
        end, 'POST', json.encode({ file = base64 }), { ['Content-Type'] = 'application/json' })
    else
        print("Player token check failed for player ID: " .. src)
    end
end)