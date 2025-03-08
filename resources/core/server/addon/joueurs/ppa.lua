RegisterServerEvent("core:UsePPA")
AddEventHandler("core:UsePPA", function(token, name, residence, address, occupation, business, issuer, photo, target)
    local src = source
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("core:UsePPA", target, name, residence, address, occupation, business, issuer, photo)
    end
end)

RegisterServerEvent("core:sendPPAHeadshot")
AddEventHandler("core:sendPPAHeadshot", function(token, base64, data, name)
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

            local ppa = {
                name = name,
                residence = data.residence,
                address = data.address,
                occupation = data.occupation,
                business = data.business,
                issuer = data.issuer,
                photo = url
            }

            GiveItemToPlayer(src, 
            "ppa",
            1,
            ppa)
        end, 'POST', json.encode({ file = base64 }), { ['Content-Type'] = 'application/json' })
    else
        print("Player token check failed for player ID: " .. src)
    end
end)