Citizen.CreateThread(function()
    while true do
        Wait(15 * 60000) -- 15 min ( Chiffre avant le *)
        for a,ply in pairs(GetPlayers()) do
            ply = tonumber(ply)
            local player = GetPlayer(ply)
            if player then
                local job = player:getJob() or "aucun"
                local grade = player:getJobGrade() or 1
                local sub = player:getSubscription() or 0
                local salaire
                local service = getOnDuty(job)
                local hour = os.date("%H")
                local double = false
                if tonumber(hour) >= 11 and tonumber(hour) <= 16 then
                    double = true
                elseif tonumber(hour) >= 22 and tonumber(hour) <= 3 then
                    double = true
                end
                if service ~= nil and service ~= false and job ~= "aucun" then
                    for k, v in pairs(service) do
                        if k == ply then
                            if jobs ~= nil and json.encode(jobs) ~= "[]" and jobs[job] then
                                salaire = jobs[job].grade[grade].salaire
                                salaire = salaire * 3
                                if double then
                                    salaire = salaire * 2
                                end
                                if sub == 1 then 
                                    salaire = salaire*1.25
                                end
                                if sub == 2 then 
                                    salaire = salaire*2
                                end
                                bankPlayerUpdate(ply, "add", salaire, "player")
                                TriggerClientEvent("__atoshi::createNotification", ply, {
                                    type = 'DOLLAR',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Vous avez été payé ~s " .. salaire .. "$"
                                })
                            end
                        end
                    end
                end

                if job and string.lower(job) == "aucun" then 
                    salaire = 150
                    if sub == 1 then 
                        salaire = salaire*1.25
                    end
                    if sub == 2 then 
                        salaire = salaire*2
                    end
                    -- New notif
                    bankPlayerUpdate(ply, "add", salaire, "player")
                    TriggerClientEvent("__atoshi::createNotification", ply, {
                        type = 'ILLEGAL',
                        name = "BANQUE",
                        label = "Aide de l'état",
                        labelColor = "#0E8313",
                        logo = "https://ih1.redbubble.net/image.875935494.5004/st,small,507x507-pad,600x600,f8f8f8.webp",
                        mainMessage = "Vous avez reçu une aide de l'état de " .. salaire .. "$",
                        duration = 10,
                    })
                end
            end
        end
    end
end)
