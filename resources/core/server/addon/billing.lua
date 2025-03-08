RegisterServerCallback("core:BillingAccept", function(target, society, amount, reason, src, receipt)
    local src = src
    local target = target
    if src == nil then 
        src = source
    end

    if amount == nil then
        amount = 0
    end

    if amount < 0 then
        TriggerClientEvent('core:ShowNotification', src, "montant negatif nt")
        TriggerClientEvent('core:ShowNotification', target, "montant negatif nt")
        return false
    end
    if DoesPlayerHaveItemCount(target, "money", amount) then
        SendDiscordLog("facture", src, string.sub(GetDiscord(src), 9, -1), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
            target, string.sub(GetDiscord(target), 9, -1), GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(),
            amount, society)
        if society == 'lspd' or society == 'lssd' then 
            SendDiscordLog("penalty", src, string.sub(GetDiscord(src), 9, -1), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
            target, string.sub(GetDiscord(target), 9, -1), GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(),
            amount, society, reason)
        end
        if amount >= 50000 then
            SendDiscordLog("factureIRS", src, string.sub(GetDiscord(src), 9, -1), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
            target, string.sub(GetDiscord(target), 9, -1), GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname(),
            amount, society)
        end
        for key, value in pairs(GetPlayer(target):getInventaire()) do
            if value.name == "money" then
                if RemoveItemToPlayer(target, "money", amount, value.metadatas) then
                    if society == "justice" or society == "player" then
                        bankPlayerUpdate(target, "add", amount, "player")
                        -- local account = getBankPlayerFromSrc(target)
                        -- for k, v in pairs(account) do
                        --     local balance = v.balance
                        --     local result = balance + amount
                        --     Bank.setMoneyAccount(v.account_number, result)
                        -- end
                    else
                        AddMoneyToSociety(amount, society)
                    end
                    --[[TriggerClientEvent('core:ShowNotification', target,
                        "Vous avez payé ~g~$" .. amount .. "~s~ pour ~r~" .. reason .. "~s~.")]]
                    TriggerClientEvent("__atoshi::createNotification", target, {
                        type = 'DOLLAR',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez payé ~s $" .. amount
                    })
                    --[[TriggerClientEvent('core:ShowNotification', src, "La facture a été payée.")]]
                    TriggerClientEvent("__atoshi::createNotification", src, {
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s La facture a été payée."
                    })
                    return true
                else
                    --[[TriggerClientEvent('core:ShowNotification', target, "Erreur lors de la transaction.")]]
                    TriggerClientEvent("__atoshi::createNotification", target, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Erreur lors de la transaction."
                    })
                    --[[TriggerClientEvent('core:ShowNotification', src, "La facture n'a pas été payée.")]]
                    TriggerClientEvent("__atoshi::createNotification", src, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s La facture n'a pas été payée."
                    })
                    return false
                end
            end
        end
    else
        local account = getBankPlayerFromSrc(target)
        if account ~= nil then
            if account.balance - amount > 0 then
                local balance = account.balance
                local result1 = balance - amount
                if society == "player" then
                    bankPlayerUpdate(src, "add", amount, "player")
                    -- local accounts = getBankPlayerFromSrc(src)
                    -- for key, value in pairs(accounts) do
                    --     local balance = value.balance
                    --     local result = balance + amount
                    --     Bank.setMoneyAccount(value.account_number, result)
                    -- end
                else
                    AddMoneyToSociety(amount, society)
                end
                bankPlayerUpdate(target, "remove", amount, "player")
                --Bank.setMoneyAccount(v.account_number, result1)
                
                --[[TriggerClientEvent('core:ShowNotification', target,
                    "Vous avez payé ~g~$" .. amount .. "~s~ pour ~r~" .. reason .. "~s~.")]]
                TriggerClientEvent("__atoshi::createNotification", target, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez payé ~s $" .. amount
                })
                --[[TriggerClientEvent('core:ShowNotification', src, "La facture a été payée.")]]
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s La facture a été payée."
                })
                return true
            else
                --[[TriggerClientEvent('core:ShowNotification', src, "Vous n'avez ~r~pas assez d'argent~s~.")]]
                TriggerClientEvent("__atoshi::createNotification", target, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous n'avez pas assez d'argent"
                })
                --[[TriggerClientEvent('core:ShowNotification', src, "Le client n'a pas assez d'argent.")]]
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le client n'a pas assez d'argent"
                })
                return false
            end
        else
        end
    end
    return false
end)

-----

RegisterServerCallback("core:SendMoneyFromEnterpriseToEntreprise", function(target, society, amount, src, receipt)
    local src = src
    local target = target

    -- print(GetPlayer(target):getJob())

    local targetsociety = GetPlayer(target):getJob()

    -- local account = getBankJobFromName(society)
	-- local societyAccount = getBankJobFromName(targetsociety)

    if targetsociety == society then
        
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Une facture a ta propre entreprise ?"
        })

        return true

    elseif targetsociety ~= society then

        if bankPlayerUpdate(target, "remove", amount, "society") then
            if bankPlayerUpdate(src, "add", amount, "society") then
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "L'entreprise" .. targetsociety .. "a payé ~s $" .. amount
                })
                TriggerClientEvent("__atoshi::createNotification", target, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Votre entreprise a payé ~s $" .. amount .. "à l'entreprise" .. society
                })
            else
                bankPlayerUpdate(target, "add", amount, "society")
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "L'entreprise" .. targetsociety .. "a eu un probleme vous avez été remboursé de ~s $" .. amount
                })
                TriggerClientEvent("__atoshi::createNotification", target, {
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Votre entreprise n'as pas payé ~s $" .. amount .. "à l'entreprise" .. society
                })
            end
        else
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s La societé n'a pas assez d'argent"
            })
            TriggerClientEvent("__atoshi::createNotification", target, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Votre societé n'a pas assez d'argent"
            })
        end

        -- for key, valueS in pairs(societyAccount) do
        --     bankPlayerUpdate(target, "add", amount, "society")
        --     if valueS.balance - amount > 0 then
        --         local SBalance = valueS.balance
        --         local result = SBalance - amount

        --         -- print('Argent entreprise avant : '..SBalance.. ' | Après : '..result)
                
        --         Bank.setMoneyAccount(valueS.account_number, result)

        --         for key, valueC in pairs(account) do
        --             local balance = valueC.balance
        --             local client = balance + amount
        --             Bank.setMoneyAccount(valueC.account_number, client)

        --             print('Argent entreprise avant : '..balance.. ' | Après : '..client)

        --             --[[TriggerClientEvent('core:ShowNotification', src,
        --                 "Vous avez payé ~g~$" .. amount .. "~s~ pour ~r~" .. reason .. "~s~.")]]
                    
        --         end
        --     else
        --         --[[TriggerClientEvent('core:ShowNotification', src, "Vous n'avez ~r~pas assez d'argent~s~.")]]
                
        --     end
        -- end
        return true
    end
end)

-----

-- ["pawnshop_sendmoney"] = {
--     --hook = "https://discord.com/api/webhooks/1145679679760650271/jthc9EKqBz7mf2Cc_LwoZMv707-h6plWlAG5RNwuZk6rwvZCjfmpglV3sHIG-cY1FwxV",--
--     hook = "https://discord.com/api/webhooks/1212114520487759962/c2mTtlEfU_TYcJgcQ4NWQK6nd_mkGDtFSIAmG5li0c0qrmpVsUBvi7_Fqk-4ftsuFIhO",
--     color = 0xff7f00,
--     title = "Pawnshop Envoie d'Argent",
--     text = "Discord de l'employé : <@%s>\nNom Prénom RP employé : `%s`\nMontant envoyé : `%s`\nRaison : `%s`\nDiscord du joueur : <@%s>\nNom Prénom RP joueur : `%s`",
-- },

-- SendDiscordLog("killSuicide", source, string.sub(GetDiscord(source), 9, -1), src:getLastname() .. " ".. src:getFirstname(), posVictime)


RegisterNetEvent("core:SendMoneyFromEnterprise")
AddEventHandler("core:SendMoneyFromEnterprise", function(token, target, society, amount, reason)
    local src = source
    local target = target

    if bankPlayerUpdate(src, "remove", amount, "society") then
        if bankPlayerUpdate(target, "add", amount, "player") then
            TriggerClientEvent("__atoshi::createNotification", target, {
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "L'entreprise" .. society .. "a envoyé ~s $" .. amount .. " ~c pour ~s " .. reason
            })
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Votre entreprise a payé ~s $" .. amount
            })
            
            SendDiscordLog("pawnshop_sendmoney", src, string.sub(GetDiscord(src), 9, -1), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), amount, reason, string.sub(GetDiscord(target), 9, -1), GetPlayer(target):getLastname() .. " " .. GetPlayer(target):getFirstname())
        else
            bankPlayerUpdate(src, "add", amount, "society")
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Le joueur a eu un probleme vous avez été remboursé de ~s $" .. amount
            })
            TriggerClientEvent("__atoshi::createNotification", target, {
                type = 'DOLLAR',
                -- duration = 5, -- In seconds, default:  4
                content = "Votre a eu un probleme vous n'avez pas recu ~s $" .. amount
            })
        end
    else
        TriggerClientEvent("__atoshi::createNotification", target, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s La societé n'a pas assez d'argent"
        })
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Votre societé n'a pas assez d'argent"
        })
    end
    return true
end)

RegisterNetEvent("core:sendbilling")
AddEventHandler("core:sendbilling", function(token, target, society, amount, reason)
    local source = source
    if CheckPlayerToken(source, token) then
        TriggerClientEvent("__atoshi::createNotification", target, {
            type = 'DOLLAR',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez reçu une facture de ~s " .. amount .. "$ ~c pour ~s " .. reason
        })
        TriggerClientEvent("__atoshi::createNotification", target, {
            type = 'VERT',
            duration = 10, -- In seconds, default:  4
            content = "Appuyer sur ~K Y pour ~s payer la facture"
        })

        TriggerClientEvent("__atoshi::createNotification", target, {
            type = 'ROUGE',
            duration = 10, -- In seconds, default:  4
            content = "Appuyer sur ~K K pour ~s refuser de payer"
        })

        TriggerClientEvent('core:sendBillingChoice', target, society, amount, reason, source)
    else

    end
end)


RegisterNetEvent("core:pay")
AddEventHandler("core:pay", function(token, amount)
    local source = source
    if CheckPlayerToken(source, token) then
        for key, value in pairs(GetPlayer(source):getInventaire()) do
            if value.name == "money" then
                if RemoveItemToPlayer(source, "money", amount, value.metadatas) then
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'DOLLAR',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez payé ~s $" .. amount
                    })
                else
                    TriggerClientEvent("__atoshi::createNotification", source, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous n'avez pas assez d'argent"
                    })
                end
            end
        end
    end
end)