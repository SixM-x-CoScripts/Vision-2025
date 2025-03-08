bankJob = {
    id = 0, ---@private
    society = nil, ---@private
    account_number = "", ---@private
    balance = 0, ---@private
    common = 0, ---@private
    name = "", ---@private
    needSave = false, ---@private
    transactions = {}, ---@private
}

bankJob.__index = bankJob

local classBankJob = {} ---@type bankJob

---@return bankJob
function GetBankJob(id)
    return classBankJob[id]
end

--@return bankJob
function GetAllBankJob()
    return classBankJob
end

function RemoveBankJob(id)
    classBankJob[id] = nil
end


---@return bankJob
function bankJob:new(data)
    local self = setmetatable({}, bankJob)
    self.id = data.id
    self.society = data.society
    self.account_number = data.account_number
    self.common = 0
    self.balance = data.balance
    self.name = data.name
    self.needSave = false

    --CorePrint("Le compte de societe " .. self.account_number .."/".. self.id .. " a été chargé pour " .. self.name)
    -- print(data.id, json.encode(self))
    classBankJob[data.id] = self
    return self
end

--vehicles methods

function bankJob:getBankJobId()
    return self.id
end

function bankJob:getBankJobSociety()
    return self.society
end

function bankJob:getTransactions()
    return self.transactions
end

function bankJob:newTransaction(sender, amount)
    table.insert(self.transactions, {id = self.id, label = sender, amount = amount})
end

function bankJob:getBankJobAccount()
    return self.account_number
end

function bankJob:getBankJobBalance()
    return self.balance
end

---@private
function bankJob:setBankJobBalance(balance)
    self:setNeedSave(true)
    self.balance = balance
end

function bankJob:getBankJobName()
    return self.name
end

---@private
function bankJob:setNeedSave(needSave)
    self.needSave = needSave
end

function bankJob:getNeedSave()
    return self.needSave
end

--bankJob functions

function bankJob:saveBankJob()
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

function getBankJobFromSrc(src)
    if src == nil or not GetPlayer(src) then return nil end
    local playerJob = GetPlayer(src):getJob()
    for k, v in pairs(GetAllBankJob()) do
        if v.name == playerJob then return classBankJob[v.id] end
    end
    return nil
end

function getBankJobFromName(name)
    for k, v in pairs(GetAllBankJob()) do
        if v.name == name then return classBankJob[v.id] end
    end
    return nil
end

function getBankJobFromAccount(account)
    for k, v in pairs(GetAllBankJob()) do
        if v.account_number == account then return classBankJob[v.id] end
    end
    return nil
end