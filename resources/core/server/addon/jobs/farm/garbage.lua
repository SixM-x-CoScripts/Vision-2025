local garbageDuty = {}

RegisterNetEvent("core:eboueurEndDuty")
AddEventHandler("core:eboueurEndDuty", function(time, secu, totalMoney)
    local _totalMoney = tonumber(totalMoney)
    local paid = false
    local source = source
    if _totalMoney == 0 then 
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous n'avez rien ramassé"
        })
        return 
    end
    if CheckTrigger(source, time, secu, "core:eboueurEndDuty : "..totalMoney.."$") then
        for k,v in pairs(garbageDuty) do
            if v == GetPlayer(source):getId() then
                table.remove(garbageDuty, k)
                break
            end
        end
        if _totalMoney == 0 then
            --[[TriggerClientEvent("core:ShowNotification", source, "~r~Vous n'avez rien ramassé~s~")]]
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez rien ramassé"
            })
            return
        end
        for key, value in pairs(GetPlayer(source):getInventaire()) do
            if value.name == "money" then
                GiveItemToPlayer(source, "money", _totalMoney, value.metadatas)
                --[[TriggerClientEvent('core:ShowNotification', source, "Vous avez gagné ~g~" .. _totalMoney .. "$~s~.")]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez gagné ~s " .. _totalMoney .. "$"
                })
                paid = true
                return
            end
        end
        if not paid then
            GiveItemToPlayer(source, "money", _totalMoney, {})
            --[[TriggerClientEvent('core:ShowNotification', source, "Vous avez gagné ~g~" .. _totalMoney .. "$~s~.")]]
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez gagné ~s " .. _totalMoney .. "$"
            })
            paid = true
        end
    else
        --TODO: Ac detection
    end
end)

RegisterNetEvent("core:eboueurStartDuty")
AddEventHandler("core:eboueurStartDuty", function(token)
    if CheckPlayerToken(source, token) then
        table.insert(garbageDuty, GetPlayer(source):getId())
    end
end)

CreateThread(function ()
    while RegisterServerCallback == nil do Wait(1) end

    RegisterServerCallback("core:getIfAlrdyTakeService", function (source, token)
        if CheckPlayerToken(source, token) then
            for k,v in pairs(garbageDuty) do
                if v == GetPlayer(source):getId() then
                    return true
                end
            end
            return false
        else

        end
    end)
end)