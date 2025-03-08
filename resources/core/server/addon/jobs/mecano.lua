local commande = {}
local myCommande = {}


RegisterNetEvent('core:removeCommandeMecano')
AddEventHandler('core:removeCommandeMecano', function(token, id, job)
    local src = source
    if CheckPlayerToken(src, token) then
        for i = 1, #commande do
            if i == id then
                table.remove(commande, id)
                TriggerClientEvents('core:GetCommandeMecano', GetAllJobsIds(job), commande)
            end
        end

    else
        --Ac Event
    end
end)

RegisterNetEvent('core:addCommandeMecano')
AddEventHandler('core:addCommandeMecano', function(token, plate, veh, props)
    local src = source
    if CheckPlayerToken(src, token) then
        table.insert(commande, { plate = plate, name = veh, props = props })
        -- TriggerClientEvent('core:GetCommandeMecano', -1, commande)
    else
        --Ac Event
    end
end)

-- RegisterNetEvent('core:GetCommandeMecano')
-- AddEventHandler('core:GetCommandeMecano', function(token)
--     local src = source
--     if CheckPlayerToken(src, token) then
--         TriggerClientEvent('core:GetCommandeMecano', -1, commande)
--     else
--         --Ac Event
--     end
-- end)

CreateThread(function ()
    while RegisterServerCallback == nil do Wait(1) end

    RegisterServerCallback("core:GetCommandeMecanoCb", function(source, token)
        if CheckPlayerToken(source, token) then
            return commande
        end
    end)

    RegisterServerCallback("core:buyCommande", function(source, token)
        if CheckPlayerToken(source, token) then
            local removed = RemoveMoneyToSociety(5000, GetPlayer(source):getJob())
            if removed then
                --[[TriggerClientEvent("core:ShowNotification", source, "~g~Vous avez payé la commande")]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous avez payé la commande"
                })
            else
                --[[TriggerClientEvent("core:ShowNotification", source, "~r~Votre entreprise n'a pas assez d'argent pour payer la commande")]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Votre entreprise n'a pas assez d'argent pour payer la commande"
                })
            end
            return removed
        end
    end)
end)

-- RegisterNetEvent('core:re')
-- AddEventHandler('core:addCommandeMecano', function(token, id, plate, veh, props)
--     local src = source
--     if CheckPlayerToken(src, token) then
--         table.insert(commande, { plate = plate, name = veh, props = props })
--         TriggerClientEvent('core:GetCommandeMecano', -1, commande)
--     else
--         --Ac Event
--     end
-- end)
