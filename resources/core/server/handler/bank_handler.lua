local function LoadAllBank() -- done
    MySQL.Async.fetchAll('SELECT * FROM bank WHERE society IS NULL', {}, function(result)
        local bank
        for k, v in pairs(result) do
            bank = bankPlayer:new(v)
        end
    end)
    MySQL.Async.fetchAll('SELECT bank.*, society.name AS name FROM bank LEFT JOIN society ON bank.society = society.id WHERE player IS NULL', {}, function(result)
        local bank
        for k, v in pairs(result) do
            bank = bankJob:new(v)
        end
    end)
    CorePrint("Tous les comptes bancaire de la bdd ont été load.")
end

MySQL.ready(function()
    Wait(1000)
    -- Delete les doubles comptes des joueurs
    MySQL.Async.execute([[
        DELETE FROM bank
        WHERE player IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM (
                SELECT player, MAX(balance) AS max_balance
                FROM bank
                WHERE player IS NOT NULL
                GROUP BY player
            ) AS c2
            WHERE bank.player = c2.player
            AND bank.balance < c2.max_balance
        );
    ]])
    Wait(1000)
    LoadAllBank()
end)

function bankAccountExist(account)
    for k, v in pairs(GetAllBankPlayer()) do
        if v.account_number == account then return true end
    end
    for k, v in pairs(GetAllBankJob()) do
        if v.account_number == account then return true end
    end
    return false
end

local function getCategory(amount)
    amount = tonumber(amount)
    if amount < 5000 then
        return "Vert"
    elseif amount < 20000 then
        return "Jaune"
    elseif amount < 50000 then
        return "Orange"
    else
        return "Rouge"
    end
end

function bankPlayerUpdate(src, action, amount, accountOrigin)
    local account
    if accountOrigin == "player" then
        account = getBankPlayerFromSrc(src)
    else
        account = getBankJobFromSrc(src)
    end
    if account == nil then return false end
    local result = account.balance + amount
    if action == "remove" then 
        result = account.balance - amount
        if result < 0 then 
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas assez d'argent"
            })
            return false 
        end
    end
    if accountOrigin == "player" then
        GetBankPlayer(account.id):setBankPlayerBalance(result)
        TriggerClientEvent("core:updateBankPhoneValue", src, result)
    else
        TriggerEvent("core:UpdateJobBank", account.name, amount, action)
        GetBankJob(account.id):setBankJobBalance(result)
    end
    return true
end

function bankAccountUpdate(account_number, action, amount, accountOrigin)
    local account
    if accountOrigin == "player" then
        account = getBankPlayerFromAccount(account_number)
    else
        account = getBankJobFromAccount(account_number)
    end
    if account == nil then return false end
    local result = account.balance + amount
    if action == "remove" then 
        result = account.balance - amount
        if result < 0 then 
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas assez d'argent"
            })
            return false 
        end
    end
    if accountOrigin == "player" then
        GetBankPlayer(account.id):setBankPlayerBalance(result)
        account:newTransaction("Virement", tonumber(amount))
    else
        TriggerEvent("core:UpdateJobBank", account.name, amount, action)
        GetBankJob(account.id):setBankJobBalance(result)
    end
    return true
end

function bankJobUpdateFromName(name, action, amount, src)
    
    local account = getBankJobFromName(name)

    if account == nil then return false end
    local result = account.balance + amount
    if action == "remove" then 
        result = account.balance - amount
        if result < 0 then 
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s La societe n'a pas assez d'argent"
            })
            return false 
        end
    elseif action == "resetJob" then 
        result = amount
    end
    TriggerEvent("core:UpdateJobBank", name, amount, action)
    GetBankJob(account.id):setBankJobBalance(result)
    return true
end


function CreateAccountPlayer(playerId)  
    local account_number = math.random(100, 999) .. "-" .. math.random(100, 999)
    while bankAccountExist(account_number) do
        account_number = math.random(100, 999) .. "-" .. math.random(100, 999)
    end
    
        local new = bankPlayer:new({
            id = MySQL.Sync.insert('INSERT INTO bank (player, account_number, balance, common) VALUES (@player, @account_number, @balance, @common)'
                , {
                    ['player'] = playerId,
                    ['account_number'] = account_number,
                    ['balance'] = 1000,
                    ['common'] = 1,
                }, function(result)
                end),
            player = playerId,
            account_number = account_number,
            balance = 1000,
        })
        CorePrint("Compte n°" .. account_number .. " pour le joueur n°" .. playerId .. " créé")
end

function CreateAccountJob(societyId, name)
    local account_number = math.random(100, 999) .. "-" .. math.random(100, 999)
    while bankAccountExist(account_number) do
        account_number = math.random(100, 999) .. "-" .. math.random(100, 999)
    end
    
        local new = bankJob:new({
        id = MySQL.Sync.insert('INSERT INTO bank (society, account_number, balance, common) VALUES (@society, @account_number, @balance, @common)'
            , {
                ['society'] = societyId,
                ['account_number'] = account_number,
                ['balance'] = 15000,
                ['common'] = 1,
            }, function()
            end),
        society = societyId,
        account_number = account_number,
        balance = 15000,
        name = name,
    })
    CorePrint("Compte n°" .. account_number .. " pour l'entreprise n°" .. societyId .. " créé")
end

-- RegisterNetEvent("core:bankPlayerUpdate") --done
-- AddEventHandler("core:bankPlayerUpdate", function(timeC, secu, token, action, money)
--     local src = source
--     local amount = tonumber(money)
--     if CheckTrigger(src, timeC, secu, "core:bankPlayerUpdate") then
--         if CheckPlayerToken(src, token) then
--             bankPlayerUpdate(src, action, amount, "player")
--         else

--         end
--     end
-- end)

RegisterNetEvent("core:bankPlayerUpdatePhone") --done
AddEventHandler("core:bankPlayerUpdatePhone", function(token, source, action, money)
    local src = source
    local amount = tonumber(money)
    if token == "putaintelephonedemerdeatoutmomentonestbaiser" then
        bankPlayerUpdate(src, action, amount, "player")
    else

    end
end)

RegisterNetEvent('core:bankAtmUpdate') --done
AddEventHandler("core:bankAtmUpdate", function(token, id, amount, action)
    local src = source
    local id = id
    local amount = tonumber(amount)
    if CheckPlayerToken(src, token) then
        local accountOrigin = "player"
        local account = GetBankPlayer(tonumber(id))
        if account == nil then
            account = GetBankJob(tonumber(id))
            accountOrigin = "job"
        end
        if action == "add" then 
            if DoesPlayerHaveItemCount(src, "money", tonumber(amount))then
                for key, value in pairs(GetPlayer(src):getInventaire()) do
                    if value.name == "money" then
                        if RemoveItemToPlayer(src, "money", tonumber(amount), value.metadatas) then
                            bankPlayerUpdate(src, action, amount, accountOrigin)
                            account:newTransaction("Dépôt", amount)
                            --toredo
                            TriggerClientEvent('core:GetAllInformation', src, getBankPlayerFromSrc(src), GetPlayer(src):getId(), GetPlayer(src):getLastname(), GetPlayer(src):getFirstname())
                            TriggerClientEvent("__atoshi::createNotification", src, {
                                type = 'VERT',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous venez de déposer ~s " .. tonumber(amount) .. "$ ~c sur votre compte !"
                            })
                            TriggerClientEvent("core:updateBankPhoneValue", src, result)
                            SendDiscordLog("deposit", src, string.sub(GetDiscord(src), 9, -1),
                                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                                account.account_number, tonumber(amount), getCategory(amount))
                            if amount >= 50000 then
                                SendDiscordLog("depositIRS", src, string.sub(GetDiscord(src), 9, -1),
                                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                                account.account_number, tonumber(amount), getCategory(amount))
                            end
                        end
                    end

                end

            else
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous n'avez pas assez d'argent"
                })
            end
        else
             if bankPlayerUpdate(src, action, amount, accountOrigin) then
                AddItemToInventory(src, "money", amount, {})
                account:newTransaction("Retrait", -amount)
                --toredo
                TriggerClientEvent('core:GetAllInformation', src, getBankPlayerFromSrc(src), GetPlayer(src):getId(), GetPlayer(src):getLastname(), GetPlayer(src):getFirstname())
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous venez de récupérer ~s " .. tonumber(amount) .. "$ ~c de votre compte !"
                })
                TriggerClientEvent("core:updateBankPhoneValue", src, result)
                SendDiscordLog("withdraw", src, string.sub(GetDiscord(src), 9, -1),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                    account.account_number, tonumber(amount), getCategory(amount))
                if amount >= 50000 then
                    SendDiscordLog("withdrawIRS", src, string.sub(GetDiscord(src), 9, -1),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                    account.account_number, tonumber(amount), getCategory(amount))
                end
            end
        end
    else
        -- TODO: Ac detection
    end
end)

RegisterNetEvent('core:bank_Transfer') -- done
AddEventHandler("core:bank_Transfer", function(token, id, account_number, amount)
    local src = source
    local id = id
    if CheckPlayerToken(src, token) then
        local accountOriginFrom = "player"
        local accountFrom = GetBankPlayer(tonumber(id))
        if accountFrom == nil then
            accountFrom = GetBankJob(tonumber(id))
            accountOriginFrom = "job"
        end
        local accountOriginTo = "player"
        local accountTo = getBankPlayerFromAccount(account_number)
        if accountTo == nil then
            accountTo = getBankJobFromAccount(account_number)
            accountOriginTo = "job"
        end
        if accountFrom and accountTo then
            if bankPlayerUpdate(src, "remove", tonumber(amount), accountOriginFrom) then
                if bankAccountUpdate(account_number, "add", tonumber(amount), accountOriginTo) then
                    accountFrom:newTransaction("Virement", tonumber(-amount))
                    TriggerClientEvent('core:GetAllInformation', src, getBankPlayerFromSrc(src), GetPlayer(src):getId(), GetPlayer(src):getLastname(), GetPlayer(src):getFirstname())
                    TriggerClientEvent("__atoshi::createNotification", src, {
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Virement de ~s " .. tonumber(amount) .. "$ ~c effectué sur le compte n° ~s" .. account_number
                    })
                else
                    bankPlayerUpdate(src, "add", tonumber(amount), accountOriginFrom)
                        TriggerClientEvent("__atoshi::createNotification", src, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Une erreur a eu lieu sur le compte du destinataire !"
                    })
                    return
                end
            else
                TriggerClientEvent("__atoshi::createNotification", src, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Une erreur a eu lieu sur votre compte !"
                })
                return
            end
            SendDiscordLog("transfer", src, string.sub(GetDiscord(src), 9, -1),
                GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                accountFrom.account_number, account_number, tonumber(amount))
            if tonumber(amount) >= 50000 then
                SendDiscordLog("transferIRS", src, string.sub(GetDiscord(src), 9, -1),
                    GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(),
                    accountFrom.account_number, account_number, tonumber(amount))
            end
            return
        else
            TriggerClientEvent("__atoshi::createNotification", src, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Veuillez saisir un bon numéro de compte !"
            })
        end
    else
        -- TODO: Ac detection
    end
end)

RegisterNetEvent('core:GetAllInformation')
AddEventHandler('core:GetAllInformation', function(token)
    local src = source
    if CheckPlayerToken(src, token) then
        local accounts = {}
        local account = getBankPlayerFromSrc(src)
        table.insert(accounts, account)
        if jobs[GetPlayer(src):getJob()].grade[GetPlayer(src):getJobGrade()].gestion then
            local bank = getBankJobFromSrc(src)
            if bank ~= nil and GetPlayer(src):getJob() ~= "aucun" and GetPlayer(src):getJob() ~= "Aucun" then
                table.insert(accounts, bank)
            end
        end
        TriggerClientEvent('core:GetAllInformation', src, accounts, GetPlayer(src):getId(),
            GetPlayer(src):getLastname(), GetPlayer(src):getFirstname())
    else

    end
end)

-- Loops

Citizen.CreateThread(function()  -- done
    local bank
    while true do
        Wait(70000)
        bank = GetAllBankJob()
        for k, v in pairs(bank) do
            if v.needSave then
                v:saveBankJob()
                Wait(1000)
            end
        end
        bank = GetAllBankPlayer()
        for k, v in pairs(bank) do
            if v.needSave then
                v:saveBankPlayer()
                Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(100) end

    RegisterServerCallback("core:getCompanyBalance", function(source, token)
        if CheckPlayerToken(source, token) then
            local account = getBankJobFromSrc(source)
            if account ~= nil then
                return account.balance
            else
                return 0
            end
        else
            -- TODO: Ac detection
        end
    end)
end)

CreateThread(function()
    while RegisterServerCallback == nil do Wait(1) end
    RegisterServerCallback("core:getTransaction", function(source)
        --return exports["lb-phone"]:GetTransaction(source) ntm lb-phone
        --return {}
        return getBankPlayerFromSrc(source):getTransactions()
    end)
    RegisterServerCallback("core:getTransactionByJob", function(source)
        --return exports["lb-phone"]:GetTransaction(source) ntm lb-phone
        --return {}
        if GetPlayer(source):getJob() == "aucun" then 
            return {}
        end
        return getBankJobFromName(GetPlayer(source):getJob()):getTransactions()
    end)
end)

-- export

exports("getMoneyPhone", function(source)
    return getBankPlayerFromSrc(source)
end)

--ressource stop

function BankOnServerShutdown()
    CorePrint("Resource stopping, saving bank.")
    local bank
    bank = GetAllBankJob()
    for k, v in pairs(bank) do
        v:saveBankJob()
    end
    bank = GetAllBankPlayer()
    for k, v in pairs(bank) do
        v:saveBankPlayer()
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        BankOnServerShutdown()
    end
end)

AddEventHandler("txAdmin:events:serverShuttingDown", function(resource)
    BankOnServerShutdown()
end)