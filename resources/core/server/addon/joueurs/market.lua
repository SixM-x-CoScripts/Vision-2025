RegisterNetEvent("core:marketBuyItem")
AddEventHandler("core:marketBuyItem", function(time, secu, item, price, quantity)
    local source = source
    if CheckTrigger(source, time, secu, "core:marketBuyItem"..item.." "..quantity) then
        if CanInventoryTakeItem(source, item, quantity, {}) then
            for k, v in pairs(GetPlayer(source):getInventaire()) do
                if v.name == "money" then
                    if RemoveItemFromInventory(source, "money", price * quantity, v.metadatas) then
                        for key, value in pairs(GetPlayer(source):getInventaire()) do
                            if not DoesPlayerHaveItemCount(source, item, quantity) then
                                GiveItemToPlayer(source, item, quantity, {})

                                --[[ Ancienne notification
                                TriggerClientEvent("core:ShowNotification", source,
                                    "~g~Tu as acheté x" .. quantity ..
                                    " ~o~" .. getItemLabel(item) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")
                                --]]

                                -- New notif
                                TriggerClientEvent("__atoshi::createNotification", source, {
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Tu as acheté ~s x" .. quantity .. " " .. getItemLabel(item) .. "~c pour ~s$" .. price * quantity .. " "
                                })

                                return
                            elseif value.name == "money" and value.name == item then
                                GiveItemToPlayer(source, item, quantity, value.metadatas)

                                --[[ Ancienne notification
                                TriggerClientEvent("core:ShowNotification", source,
                                    "~g~Tu as acheté x" .. quantity ..
                                    " ~o~" .. getItemLabel(item) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")
                                --]]

                                -- New notif
                                TriggerClientEvent("__atoshi::createNotification", source, {
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Tu as acheté ~s x" .. quantity .. " " .. getItemLabel(item) .. "~c pour ~s$" .. price * quantity .. " "
                                })
                                return
                            elseif value.name == item and value.metadatas ~= nil then
                                GiveItemToPlayer(source, item, quantity, value.metadatas)


                                --[[ Ancienne notification
                                TriggerClientEvent("core:ShowNotification", source,
                                    "~g~Tu as acheté x" .. quantity ..
                                    " ~o~" .. getItemLabel(item) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")
                                --]]

                                -- New notif
                                TriggerClientEvent("__atoshi::createNotification", source, {
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Tu as acheté ~s x" .. quantity .. " " .. getItemLabel(item) .. "~c pour ~s$" .. price * quantity .. " "
                                })
                                    
                                return
                            elseif value.name == item and value.metadatas == nil then
                                metadatas = {}
                                GiveItemToPlayer(source, item, quantity, metadatas)

                                --[[ Ancienne notification
                                TriggerClientEvent("core:ShowNotification", source,
                                    "~g~Tu as acheté x" .. quantity ..
                                    " ~o~" .. getItemLabel(item) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")
                                --]]

                                -- New notif
                                TriggerClientEvent("__atoshi::createNotification", source, {
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Tu as acheté ~s x" .. quantity .. " " .. getItemLabel(item) .. "~c pour ~s$" .. price * quantity .. " "
                                })

                                return
                            elseif value.name ~= item then
                                metadatas = {}
                                GiveItemToPlayer(source, item, quantity, metadatas)

                                --[[ Ancienne notification
                                TriggerClientEvent("core:ShowNotification", source,
                                    "~g~Tu as acheté x" .. quantity ..
                                    " ~o~" .. getItemLabel(item) .. "~s~ pour ~g~$" .. price * quantity .. "~s~")
                                --]]

                                -- New notif
                                TriggerClientEvent("__atoshi::createNotification", source, {
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Tu as acheté ~s x" .. quantity .. " " .. getItemLabel(item) .. "~c pour ~s$" .. price * quantity .. " "
                                })

                                return
                            end
                        end

                    else
                        -- TriggerClientEvent("core:ShowNotification", source, "Vous n'avez ~r~pas assez d'argent~s~.")

                        -- New notif
                        TriggerClientEvent("__atoshi::createNotification", source, {
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous n'avez ~s pas assez d'argent."
                        })

                    end

                end
            end
        else
            -- TriggerClientEvent("core:ShowNotification", source, "~r~Tu n'as pas assez de place dans ton inventaire")

            -- New notif
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Tu n'as pas ~s assez de place ~c dans ton inventaire ."
            })

        end
    end
end)

CreateThread(function ()
    while RegisterServerCallback == nil do Wait(0) end
    RegisterServerCallback("core:buycoiffure", function (source, token, price)
        if CheckPlayerToken(source, token) then 
            if RemoveItemFromInventory(source, "money", price, {}) then
                -- TriggerClientEvent("core:ShowNotification", source, "Vous avez payé ~g~" .. price .. "~s~$")

                -- New notif
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez payé ~s " .. price .. "$"
                })

                return true
            else
                --TriggerClientEvent("core:ShowNotification", source, "Vous n'avez ~r~pas assez d'argent~s~.")

                -- New notif
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous n'avez pas assez d'argent"
                })
                
                return false
            end
        end
    end)
end)