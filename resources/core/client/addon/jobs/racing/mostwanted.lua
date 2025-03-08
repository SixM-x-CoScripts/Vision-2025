local peds = nil
local inService = false
function LoadMostWanted()
    if pJob ~= "mostwanted" then
        return
    end

    local token = nil

    TriggerEvent("core:RequestTokenAcces", "core", function(t)
        token = t
    end)

    function MostWantedFacture(entity)
        local billing_price = 0
        local billing_reason = ""
        local player = NetworkGetPlayerIndexFromPed(entity)
        local sID = GetPlayerServerId(player)
        local price = KeyboardImput("Entrez le prix")
        if price and type(tonumber(price)) == "number" then
            billing_price = tonumber(price)
        end
        local reason = KeyboardImput("Entrez la raison")
        if reason ~= nil then
            billing_reason = tostring(reason)
        end

        if entity == nil then
            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= nil and closestDistance < 1.5 then
                TriggerServerEvent('core:sendbilling', token, GetPlayerServerId(closestPlayer),
                    p:getJob(), billing_price, billing_reason)
            end
        else
            TriggerServerEvent('core:sendbilling', token, sID,
                p:getJob(), billing_price, billing_reason)
            -- Ancienne notification    
            -- ShowNotification("Facturation envoyée \n Prix : ~g~" ..
            --    billing_price .. "~s~$ \n Raison : " .. billing_reason)

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
            })

        end
    end

    CreateThread(function()
        while zone == nil do Wait(1) end

        zone.addZone( "MostWanted_service", vector3(153.44534301758, -3014.4367675781, 6.040892124176),
            "Appuyer sur ~INPUT_CONTEXT~ pour prendre/quitter votre service",
            function()
                if not inService then
                    -- ShowNotification("~g~Vous avez pris votre service")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez ~s pris ~c votre service"
                    })

                    TriggerServerEvent('core:DutyOn', 'mostwanted')
                    inService = true
                    Wait(5000)
                else
                    -- ShowNotification("~r~Vous avez quitté votre service")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez ~s quitté ~c votre service"
                    })

                    TriggerServerEvent('core:DutyOff', 'mostwanted')
                    inService = false
                    Wait(5000)
                end
            end,
            true,
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170-- Alpha
        )

        zone.addZone( "coffre", vector3(146.68508911133, -3007.6682128906, 6.0408911705017),
            "~INPUT_CONTEXT~ Intéragir",
            function()
                if inService then
                    OpenInventorySocietyMenu()
                else
                    -- ShowNotification("~r~Vous n'êtes pas en service")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous n'êtes ~s pas en service"
                    })

                end
            end,
            true,
            25, -- Id / type du marker
            0.6, -- La taille
            { 51, 204, 255 }, -- RGB
            170-- Alpha
        )
    end)
end

-- -1169.7506103516, -894.67706298828, 13.662619590759, 32.937435150146
function UnLoadMostWanted()
    zone.removeZone("MostWanted_service")
end
