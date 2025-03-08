RegisterNUICallback("Wallet", function(data, cb)
    local action = data.action

    if action == "getBalance" then
        lib.TriggerCallback("phone:wallet:getBalance", cb)
    elseif action == "getTransactions" then
        lib.TriggerCallback("phone:wallet:getTransactions", cb, data.page, data.recent)
    elseif action == "doesNumberExist" then
        lib.TriggerCallback("phone:wallet:doesNumberExist", cb, data.number)
    elseif action == "sendPayment" then
        lib.TriggerCallback("phone:wallet:sendPayment", cb, {
            amount = data.amount,
            phoneNumber = data.number
        })
    end
end)

RegisterNetEvent("phone:wallet:addTransaction", function(transaction)
    debugprint("phone:wallet:addTransaction:", transaction)

    SendReactMessage("wallet:addTransaction", transaction)
end)
