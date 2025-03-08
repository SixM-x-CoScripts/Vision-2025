function fouille(entity)

    local players = NetworkGetPlayerIndexFromPed(entity)
    local sID = GetPlayerServerId(players)

    -- print(sID .. "|" .. players)

    if entity == nil then
        local player, dst = GetClosestPlayer()

        if dst ~= nil and dst <= 2.0 then

            if not IsEntityPlayingAnim(entity, "random@mugging3", "handsup_standing_base", 49) then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s La personne ne lève pas les mains"
                })
                return
            end

            local data = TriggerServerCallback("core:GetIdentityPlayer", token, GetPlayerServerId(player))

            OpenInventoryPolicePlayer(GetPlayerServerId(player), data)
        else
            -- ShowNotification("Aucun joueur à proximité")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun joueur à proximité"
            })
        end
    else

        if not IsEntityPlayingAnim(entity, "random@mugging3", "handsup_standing_base", 49) then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s La personne ne lève pas les mains"
            })
            return
        end

        local data = TriggerServerCallback("core:GetIdentityPlayer", token, sID)
        OpenInventoryPolicePlayer(sID, data)

    end

end