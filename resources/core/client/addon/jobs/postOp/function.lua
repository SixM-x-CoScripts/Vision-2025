PostOP = {}
PostOP.Duty = false
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
function DutyPostOP()
    if PostOP.Duty then
        TriggerServerEvent("core:DutyOff", pJob)
        -- ShowNotification("Vous avez ~r~quitté~s~ votre service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté ~c votre service"
        })
        
        PostOP.Duty = false
        Wait(5000)
    else
        TriggerServerEvent("core:DutyOn", pJob)
        -- ShowNotification("Vous avez ~g~pris~s~ votre service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s pris ~c votre service"
        })

        PostOP.Duty = true
        Wait(5000)
    end
end

function FacturePostOPCivil()
    if PostOP.Duty then
        openRadial = false
        closeUI()
        TriggerEvent("nuiPapier:client:startCreation", 2)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service"
        })
    end
end

function FacturePostOPEntreprise()
    if PostOP.Duty then
        openRadial = false
        closeUI()
        TriggerEvent("nuiPapier:client:startCreation", 7)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous devez ~s prendre votre service"
        })
    end
end


--[[ function FacturePostOP(entity)
    local billing_price = 0
    local billing_reason = ""
    local player = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(player)
    local price = KeyboardImput("Entrez le prix")
    if price and type(tonumber(price)) == "number" then
        billing_price = tonumber(price)
    end
    local reason = KeyboardImput("Entrez la raison")
    if reason ~= nil then
        billing_reason = tostring(reason)
    end

    if entity == nil then
        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer ~= nil and closestDistance < 1.5 then
            TriggerServerEvent("core:sendbilling", token, GetPlayerServerId(closestPlayer), p:getJob(), billing_price,
                billing_reason)
        end
    else
        TriggerServerEvent("core:sendbilling", token, sID, p:getJob(), billing_price, billing_reason)
        -- ShowNotification("Facturation envoyée \n Prix : ~g~" .. billing_price .. "~s~$ \n Raison : " .. billing_reason)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
        })

    end
end ]]