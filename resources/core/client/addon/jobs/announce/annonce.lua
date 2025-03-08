local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function CreateJobAnnonce()
    local preset = nil
    if p:getJob() == "lspd" then
        preset = "LSPD"
    elseif p:getJob() == "lsfd" then
        preset = "LSFD"
    elseif p:getJob() == "lssd" then
        preset = "LSSD"
    elseif p:getJob() == "ems" then
        preset = "SAMS"
    elseif p:getJob() == "gcp" then
        preset = "GCP"
    elseif p:getJob() == "g6" then
        preset = "G6"
    elseif p:getJob() == "usmc" then
        preset = "USMC"
    elseif p:getJob() == "bcms" then
        preset = "SAMS"
    elseif p:getJob() == "cayoems" then
        preset = "CAYOEMS"
    elseif p:getJob() == "gouv" then
        preset = "GOUV"
    elseif p:getJob() == "justice" then
        preset = "JUSTICE"
    elseif p:getJob() == "usss" then
        preset = "USSS"
    end
    printDev(jobs[p:getJob()].label, "https://assets-vision-fa.cdn.purplemaze.net/https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/"..string.lower(p:getJob())..".webp")
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CardNewsSocietyCreate',
        data = {
            name_society = jobs[p:getJob()].label,
            logo_society = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/"..string.lower(p:getJob())..".webp",
            preset = preset
        }
    }))
end

RegisterCommand('getjob', function() print(p:getJob()) end, false)
RegisterCommand('getvip', function() print(p:getSubscription()) end, false)
RegisterCommand('getcrew', function() print(p:getCrew()) end, false)
RegisterCommand('getpremium', function() 
    local premium = p:getSubscription() >= 1 and "Actif " .. "("..p:getSubscription()..")" or "Inactif"
    print("Votre abonnement premium est " .. premium)
    exports['vNotif']:createNotification({
        type = 'VERT',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre abonnement premium est " .. premium
    })

end, false)


RegisterCommand('addpremium', function(source, args) 
    if p:getPermission() >= 5 then
        TriggerServerEvent("core:staffActionLog", token, "/addpremium")
        p:setSubscription(1)
        SetPremiumKey()
        TriggerServerEvent("core:staff:setSubscription", 1)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Permissions manquantes"
        })
    end
end, false)

RegisterCommand('addpremium+', function(source, args) 
    if p:getPermission() >= 5 then
        TriggerServerEvent("core:staffActionLog", token, "/addpremium")
        p:setSubscription(2)
        SetPremiumKey()
        TriggerServerEvent("core:staff:setSubscription", 2)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Permissions manquantes"
        })
    end
end, false)

RegisterCommand('rmpremium', function(source, args) 
    if p:getPermission() >= 5 then
        TriggerServerEvent("core:staffActionLog", token, "/rmpremium")
        p:setSubscription(0)
        TriggerServerEvent("core:staff:setSubscription", 0)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Permissions manquantes"
        })
    end
end, false)

RegisterNUICallback("notificationCreateSociety_callback", function (data, cb)
    TriggerServerEvent("core:jobannonce:sendNotif", token, data)

    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)


AddEventHandler("jobAnnonce:ShowInfoNotif")
RegisterNetEvent("jobAnnonce:ShowInfoNotif", function(data)
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CardNewsSocietyShow',
        data = {
            name = data.name_entreprise_notif,
            logo = data.logo_entreprise_notif,
            phone = data.telephone_notif,
            message = data.message_notif,
            typeannonce = data.choiceType_notif,
        }
    }))
    Wait(100)
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, false)
end)