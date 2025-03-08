bankPlayer = {
    id = 0, ---@private
    player = nil, ---@private
    account_number = "", ---@private
    balance = 1, ---@private
    common = 1, ---@private
    needSave = false, ---@private
    transactions = {}, ---@private
}

bankPlayer.__index = bankPlayer

local classBankPlayer = {} ---@type bank

---@return bank
function GetBankPlayer(id)
    return classBankPlayer[id]
end

--@return bank
function GetAllBankPlayer()
    return classBankPlayer
end

function RemoveBankPlayer(id)
    classBankPlayer[id] = nil
end

---@return bankPlayer
function bankPlayer:new(data)
    local self = setmetatable({}, bankPlayer)
    self.id = data.id
    self.player = data.player
    self.account_number = data.account_number
    self.common = 1
    self.balance = data.balance
    self.needSave = false
    if not self.player then print(data.account_number) end
    --CorePrint("Le compte personel " .. self.account_number .."/".. self.id .. " a été chargé pour " .. self.player)
    --print(data.id, json.encode(self))
    classBankPlayer[data.id] = self
    return self
end

--vehicles methods

function bankPlayer:getBankPlayerId()
    return self.id
end

function bankPlayer:getTransactions()
    return self.transactions
end

function bankPlayer:newTransaction(sender, amount)
    table.insert(self.transactions, {id = self.id, label = sender, amount = amount})
end

function bankPlayer:getBankPlayer()
    return self.player
end

function bankPlayer:getBankPlayerAccount()
    return self.account_number
end

function bankPlayer:getBankPlayerBalance()
    return self.balance
end

---@private
function bankPlayer:setBankPlayerBalance(balance)
    self:setNeedSave(true)
    self.balance = balance
end

---@private
function bankPlayer:setNeedSave(needSave)
    self.needSave = needSave
end

function bankPlayer:getNeedSave()
    return self.needSave
end
--bankPlayer functions

function bankPlayer:saveBankPlayer()
    MySQL.Async.execute("UPDATE bank SET balance = @balance WHERE account_number = @account_number", {
            ['@account_number'] = self.account_number,
            ['@balance'] = self.balance,
        },
        function(affectedRows)
            self:setNeedSave(false)
            print("Compte n°" .. self.account_number .. " mis a jour (" .. self.balance .. "$)")
        end
    )
end

function getBankPlayerFromSrc(src)
    local playerId = GetPlayer(src) and GetPlayer(src):getId() or nil
    for k, v in pairs(GetAllBankPlayer()) do
        if tonumber(v.player) == tonumber(playerId) then return classBankPlayer[v.id] end
    end
    return nil
end

function getBankPlayerBalanceFromSrc(src)
    local playerId = GetPlayer(src):getId()
    for k, v in pairs(GetAllBankPlayer()) do
        if v.player == playerId then return classBankPlayer[v.id].balance end
    end
    return nil
end

function getBankPlayerFromAccount(account)
    for k, v in pairs(GetAllBankPlayer()) do
        if v.account_number == account then return classBankPlayer[v.id] end
    end
    return nil
end