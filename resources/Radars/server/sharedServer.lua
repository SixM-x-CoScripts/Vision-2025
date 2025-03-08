function takeMoney(source, amount) -- method to take money
    print("TakeMoney", amount)
    local bank = exports.core:getMoneyPhone(source)
        if (bank.balance - amount) >= 0 then
            TriggerEvent("core:removeMoneyAccount", "putaintelephonedemerdeatoutmomentonestbaiser", source, amount)
        end
    TriggerEvent("core:addMoneyGouv", "putaintelephonedemerdeatoutmomentonestbaiser", amount)
end

RegisterNetEvent('Radars:takeMoney')
AddEventHandler("Radars:takeMoney", function(amount)
    takeMoney(source, amount)
end)

RegisterNetEvent('Radars:sendLog')
AddEventHandler("Radars:sendLog", function(amount, carModel, numberplate, radarName, catchSpeed, maxSpeed, webhook)
    local name = "radar"
    local message = "Nom du radar: " .. radarName .. "\nPlaque/model: " .. numberplate .. "/" .. carModel .. "\nVitesse max: " .. maxSpeed .. "\nVitesse flashé: " .. catchSpeed .. "\nMontant de l'amende: " .. amount .. "$"
    local color = 0x135DD8
    local footer = os.date("%Y/%m/%d %X")
    sendLog(name, message, color, footer, webhook)
end)

function isInService(source, job)
    local onDuty = exports.core:getOnDuty(job)
    local status = false
    if #onDuty > 0 then
        for k, v in pairs(onDuty) do
            if k == source then status = true break end
        end
    end
    print("Status: ", status)
    TriggerClientEvent("Radars:isInService", source, status)
end

RegisterNetEvent('Radars:isInService')
AddEventHandler("Radars:isInService", function(job)
    isInService(source, job)
end)