function openMenuTerrioire(variation)
    closeUI()
    if variation == nil then
        variation = "global"
    end
    local val1 = GetZoneByPlayer()
    printDev("val1", val1)
    if val1 ~= nil then
        local valZone = GetZoneByName(val1)
        printDev("valZone", valZone)
        if not valZone then
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'êtes dans aucune zone"
            })
            return
        end
        if variation == "global" then
            myTable = valZone.global
        elseif variation == "mois" then
            myTable = valZone.month
        elseif variation == "semaine" then
            myTable = valZone.week
        end

        local resultTable = getTopFiveTerritoire(myTable)
        local DataToSend = {
            crews_over = variation,
            revendication= 100,
            crew= "BLS",
        }
        DataToSend.crews = resultTable
        DataToSend.zone = val1
        if valZone.inSouth == true then
            DataToSend.location = "Los Santos"
        else
            DataToSend.location = "Blaine County"
        end
        SendNUIMessage({
            type = 'openWebview',
            name = 'MenuTerritoire',
            data = DataToSend
        })
    else
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes dans aucune zone"
        })
    end
end

RegisterNUICallback("MenuTerritoireOver", function(data)
    closeUI()
    openMenuTerrioire(data.over)
end)

local InsideTerritoireSteal = false
local CanTakeTerritoire = false
local TimeBlock = 300
CreateThread(function()
    while true do 
        Wait(1000)
        if InsideTerritoireSteal then
            TimeBlock = TimeBlock - 1
            if TimeBlock <= 0 then 
                InsideTerritoireSteal = false
            end
        else
            Wait(5000)
        end
    end
end)

RegisterNUICallback("MenuTerritoireSubmit", function(data)
    RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1)
    local zone = GetZoneByName(GetZoneByPlayer())
    if next(zone) and zone.global[1] then
        if p:getCrew() ~= zone.global[1].leader then
            local HasThisZoneBeenTaken = TriggerServerCallback("core:hasZoneBeenTaken", GetZoneByPlayer())
            local InsideZone = true
            if not HasThisZoneBeenTaken then
                if RequestScriptAudioBank("DLC_GTAO/MUGSHOT_ROOM", false, -1) then
                    PlaySoundFrontend(-1, "Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS", true)
                end
                --PlaySoundFrontend(-1, 'DLC_VW_CONTINUE', 'dlc_vw_table_games_frontend_sounds', true)
                InsideTerritoireSteal = true
                exports['vNotif']:createNotification({
                    type = "ILLEGAL",
                    name = "Revendication",
                    label = GetZoneByPlayer(),
                    labelColor = MyCrewColor or "#10A8D1",
                    logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719957442744320image.webp",
                    mainMessage = "Attendez 5 minutes dans cette zone pour la revendiquer ! Le leader peut être prévenu",
                    duration = 10,
                })
                ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), 1, 14, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                CreateThread(function()
                    local timer = 1
                    while true do 
                        Wait(1)
                        DrawSpecialText("Revendication dans ".. tostring(disp_time(TimeBlock)), 1, 0.025)
                        timer += 1
                        if timer == 500 then 
                            local territoire = zone.zone
                            local pX, pY, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
                            if not isPlayerInsideZone(territoire, pX, pY) then
                                InsideZone = false
                            end
                            timer = 1
                        end
                        if not InsideZone then 
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous avez quitté la zone, la revendication est annulé"
                            })
                            CanTakeTerritoire = false
                            break
                        end
                        if not InsideTerritoireSteal then 
                            CanTakeTerritoire = true
                        end
                        if CanTakeTerritoire then 
                            exports['vNotif']:createNotification({
                                type = "ILLEGAL",
                                name = "Revendication",
                                label = GetZoneByPlayer(),
                                labelColor = MyCrewColor or "#10A8D1",
                                logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719957442744320image.webp",
                                mainMessage = "Votre crew revendique la zone " .. GetZoneByPlayer() .. " !",
                                duration = 10,
                            })
                            ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), 100, 15, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                            break
                        end
                    end
                    InsideTerritoireSteal = false
                    CanTakeTerritoire = false
                end)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Cette zone à déjà été revendiqué récemment"
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez pas revendiquer votre propre zone"
            })
        end
    else
        exports['vNotif']:createNotification({
            type = "ILLEGAL",
            name = "Revendication",
            label = GetZoneByPlayer(),
            labelColor = MyCrewColor or "#10A8D1",
            logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/11871954819531448521187719957442744320image.webp",
            mainMessage = "Votre crew revendique la zone " .. GetZoneByPlayer(),
            duration = 10,
        })
        ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), 100, 14, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
    end
    -- GDT à faire 
end)

-- RegisterCommand("t", function(_, args)
--     print(json.encode(crewTab))
--     ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), 10, 5, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
-- end)

-- RegisterCommand("Notif", function(_, args)
--     DonneLaNotif(1, "Test", "#F3F049")
-- end)


-- RegisterCommand("a", function(_, args)
--    crewTab[args[1]] = true
--    ActionInTerritoire(args[1], GetZoneByPlayer(), 100, args[2], coordsIsInSouth(GetEntityCoords(PlayerPedId())))
-- end)