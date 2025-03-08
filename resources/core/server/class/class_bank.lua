
Bank = {
    CreatePlayerCommonAccount = function(playerid)
        local libre = false
        local account_number = math.random(100, 999) .. "-" .. math.random(100, 999)
        MySQL.Async.execute('INSERT IGNORE INTO bank (player, account_number, balance, common) VALUES (@player, @account_number, @balance, @common)'
            , {
                ['player'] = playerid,
                ['account_number'] = account_number,
                ['balance'] = 1000,
                ['common'] = 1,
            }, function(affectedRows)
                if affectedRows > 0 then
                    CorePrint("Compte n°" .. account_number .. " pour le joueur n°" .. playerid .. " créé")
                end
        end)
    end,

    CreateSocietyCommonAccount = function(societyid)
        local libre = false
        local account_number = math.random(100, 999) .. "-" .. math.random(100, 999)
        MySQL.Async.execute('INSERT IGNORE INTO bank (society, account_number, balance, common) VALUES (@society, @account_number, @balance, @common)'
            , {
                ['society'] = societyid,
                ['account_number'] = account_number,
                ['balance'] = 0,
                ['common'] = 0,
            }, function(affectedRows)
                if affectedRows > 0 then
                    CorePrint("Compte n°" .. account_number .. " pour l'entreprise n°" .. societyid .. " créé")
                end
        end)
    end,

    GetPlayerCommonAccount = function(playerid)
        local id = GetPlayer(playerid):getId()
        local commonAccount = MySQL.Sync.fetchAll("SELECT account_number , balance FROM bank WHERE player = @id AND common = 1", { ['@id'] = id })
        if commonAccount[1] == nil then
            Bank.CreatePlayerCommonAccount(playerid)
            Wait(100)
            commonAccount = MySQL.Sync.fetchAll("SELECT account_number , balance FROM bank WHERE player = @id AND common = 1", { ['@id'] = id })
        end
        return commonAccount[1]
    end,

    GetPlayerAccountNumber = function(account_number)
        local commonAccount = MySQL.Sync.fetchAll("SELECT id , balance FROM bank WHERE account_number = @account_number AND common = 1", { ['@account_number'] = account_number })
        return commonAccount[1]
    end,

    GetAccountSocietyNumber = function(account_number)
        local societyAccount = MySQL.Sync.fetchAll("SELECT * FROM bank WHERE account_number = @account_number AND common = 0", { ['@account_number'] = account_number })
        return societyAccount[1]
    end,

    GetAllPlayerAccount = function(playerid)
        local id = GetPlayer(playerid):getId()
        local playerAccount = MySQL.Sync.fetchAll("SELECT * FROM bank WHERE player = @id", { ['@id'] = id })
        return playerAccount
    end,

    GetAccountSociety = function(playerid, souciety)
        local society = GetSocietyId(souciety)
        local playerAccount = nil
        if jobs[GetPlayer(playerid):getJob()].grade[GetPlayer(playerid):getJobGrade()].gestion then
            playerAccount = MySQL.Sync.fetchAll("SELECT * FROM bank WHERE society = @id", { ['@id'] = society })
            return playerAccount
        end
        return playerAccount
    end,

    GetSocietyAccountWithName = function(society)
        local society = GetSocietyId(society)
        local playerAccount = MySQL.Sync.fetchAll("SELECT * FROM bank WHERE society = @id", { ['@id'] = society })
        return playerAccount
    end,

    GetPlayerCommonAccountBalance = function(playerid)
        local id = GetPlayer(playerid):getId()
        local commonAccount = MySQL.Sync.fetchAll("SELECT * FROM bank WHERE player = @id AND common = 1", { ['@id'] = id })
        if commonAccount[1].balance ~= nil then
            return commonAccount[1].balance
        end
    end,

    setMoneyAccount = function(account_number, amount)
        if type(amount) == "number" then
            MySQL.Async.execute("UPDATE bank SET balance = @balance WHERE account_number = @account_number", {
                ['@account_number'] = account_number,
                ['@balance'] = amount,
            },
            function(affectedRows)
                print("Compte n°" .. account_number .. " mis a jour (" .. amount .. "$)")
            end)
        end
    end,

    CreatePlayerTransaction = function(source, target, amount)
        local srcAccount = Bank.GetPlayerCommonAccount(source)
        if type(amount) == "number" then
            local srcBalanceAccount = Bank.GetPlayerCommonAccountBalance(source)
            if srcBalanceAccount >= amount then
                local targetAccount = Bank.GetPlayerCommonAccount(target)
                if targetAccount ~= nil then
                    if srcAccount.account_number ~= targetAccount.account_number then
                        targetAccount.balance = targetAccount.balance + amount
                        srcAccount.balance = srcAccount.balance - amount
                        Bank.setMoneyAccount(srcAccount.account_number, srcAccount.balance)
                        Bank.setMoneyAccount(targetAccount.account_number, targetAccount.balance)
                    end
                end
            end
        end
    end,
}
