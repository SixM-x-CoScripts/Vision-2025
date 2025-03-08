RegisterNetEvent('core:MarketBuy')
AddEventHandler('core:MarketBuy', function(token, item, amount, price)
    local source = source
    if CheckPlayerToken(source, token) then
        if CanInventoryTakeItem(GetPlayer(source):getInventaire(), "money", price) then
            local removed = false
            for key, value in pairs(GetPlayer(source):getInventaire()) do
                if value.name == "money" then
                    removed = RemoveItemFromInventory(source, 'money', tonumber(amount), value.metadatas)
                end
            end
            if removed then
                --RefreshPlayerData(source)
                MarkPlayerDataAsNonSaved(source)
            else
                local account = Bank.GetAllPlayerAccount(source)
                for k, v in pairs(account) do
                    if (v.balance - amount) > 0 then
                        local balance = v.balance
                        local result = balance - amount
                        TriggerClientEvent("core:updateBankPhoneValue", source, result)
                        bankPlayerUpdate(source, "remove", amount, "player")
                        --Bank.setMoneyAccount(v.account_number, result)
                        removed = true
                    else
                        removed = false
                    end
                end
            end
            if removed then 
                for k, v in pairs(GetPlayer(source):getInventaire()) do
                    if not DoesPlayerHaveItemCount(source, item, amount) then
                        GiveItemToPlayer(source, item, amount, {})

                        return
                    elseif v.name == "money" and v.name == item then
                        GiveItemToPlayer(source, item, amount, v.metadatas)
                        return
                    elseif v.name == item and v.metadatas ~= nil and v.item ~= "outfit" then
                        GiveItemToPlayer(source, item, amount, v.metadatas)
                        return
                    elseif v.name == item and v.metadatas == nil and v.item ~= "outfit" then
                        metadatas = {}
                        GiveItemToPlayer(source, item, amount, metadatas)
                        return
                    elseif v.name ~= item and v.item ~= "outfit" then
                        metadatas = {}
                        GiveItemToPlayer(source, item, amount, metadatas)
                        return
                    elseif v.name == item and v.item == "outfit" then
                        GiveItemToPlayer(source, item, amount, {})
                    end
                end


                --[[TriggerClientEvent("core:ShowNotification", source,
                    "Tu viens d'acheter ~b~" .. amount .. " ~g~" .. GetPlayer(source):getInventaire()[item].label)]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Tu viens d'acheter ~s " .. amount .. " " .. GetPlayer(source):getInventaire()[item].label
                })
            end

        else
            --[[TriggerClientEvent("core:ShowNotification", source, "Tu n'as pas assez d'argent sur toi.")]]
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Tu n'as pas assez d'argent sur toi."
            })
        end
    end
end)
