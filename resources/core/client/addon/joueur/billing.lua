--[[local inChoice = false

local function billingChoice(society, amount, reason, source)
    local timer = GetGameTimer() + 10000
    inChoice = true
    while inChoice do
        if GetGameTimer() > timer then
            -- ShowNotification("~r~Le délai de facturation est dépassé")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Le délai de facturation ~s est dépassé"
            })

            inChoice = false
            return
        elseif IsControlJustPressed(0, 246) then
            TriggerServerEvent('core:BillingAccept', society, amount, reason, source)
            if society == 'lspd' then TriggerServerEvent("core:penalty", amount, reason, source, p:getPos(), 'acceptée') end
            -- ShowNotification("~g~Vous avez payé la facture")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s payé ~c la facture"
            })

            inChoice = false
            return
        elseif IsControlJustPressed(0, 311) then
            if society == 'lspd' then TriggerServerEvent("core:penalty", amount, reason, source, p:getPos(), 'refusée') end
            -- ShowNotification("~r~Vous avez refusé la facture")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s refusé ~c la facture"
            })

            inChoice = false
            return
        end
        Wait(0)
    end
end

RegisterNetEvent("core:sendBillingChoice")
AddEventHandler("core:sendBillingChoice", function(society, amount, reason, source)
    billingChoice(society, amount, reason, source)
end)]]