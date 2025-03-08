local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function GetNumberDuty(job)
    return GlobalState['serviceCount_' .. job] or 0
end

function GetNumberDuties(table)
    local total = 0
    for k,v in pairs(table) do 
        if GlobalState['serviceCount_' .. v] then 
            total = total + GlobalState['serviceCount_' .. v]
        end
    end
    return total
end

function CheckJobLimit()
    if p:getSubscription() >= 1 then
        return true
    else
        local checkTr = TriggerServerCallback("core:getInterimJobLimit")
        if checkTr and checkTr >= 5 then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous avez atteint la limite de missions (4/4), débloquez plus de missions avec le premium"
            })
            return false
        else
            return true
        end
    end
end