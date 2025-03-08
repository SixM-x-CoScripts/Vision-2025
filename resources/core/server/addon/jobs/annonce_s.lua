local AntiSpam = {}
AddEventHandler("core:jobannonce:sendNotif")
RegisterNetEvent("core:jobannonce:sendNotif", function(token, data)
    if CheckPlayerToken(source, token) then
        if AntiSpam[data.name_entreprise_notif] == true then
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                content = "~s Tu dois attendre 10 min avant de faire une nouvelle annonce !"
            })
        else
            SendDiscordLog("entreprise", source, string.sub(GetDiscord(source), 9, -1), GetPlayer(source):getLastname() .. " ".. GetPlayer(source):getFirstname(), GetPlayer(source):getJob(), json.encode(data))
            
            TriggerClientEvent("__atoshi::createNotification", -1, {
                type = 'JOB',
                name = data.name_entreprise_notif,
                logo = data.logo_entreprise_notif,
                phone = data.telephone_notif,
                content = data.message_notif,
                typeannonce = data.choiceType_notif,
                duration = 10,
            })

            AntiSpam[data.name_entreprise_notif] = true
            SetTimeout(1000 * 60 * 10, function()
                AntiSpam[data.name_entreprise_notif] = false
            end)
        end
    end
end)