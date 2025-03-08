--RegisterCommand("testgps", function()
--    TriggerEvent("core:useGps")
--end)

local allPosGps = {}
hasGPS = false
NeedToHideGps = false

function forceHideRadar()
    DisplayRadar(false)
    NeedToHideGps = true
    TriggerEvent("hud:toggleui", false)
    TriggerEvent("__atoshi::disableNotifications", false)
end


function openRadarProperly()
    if hasGPS then
        DisplayRadar(true)
        TriggerEvent("hud:toggleui", true)
        TriggerEvent("__atoshi::disableNotifications", true)
    end
    NeedToHideGps = false
end

PlayerInUI = false
RegisterNetEvent("PlayerInUI", function(value)
    PlayerInUI = value
end)

--CreateThread(function()
--    while true do 
--        Wait(5000)
--        local gpsstate = TriggerServerCallback("core:hasgps")
--        if gpsstate then 
--            if NeedToHideGps == false then
--                DisplayRadar(true)
--                hasGPS = true
--            else
--                DisplayRadar(false)
--            end
--        else
--            DisplayRadar(false)
--            hasGPS = false
--        end
--    end
--end)

CreateThread(function()
    local gpsstate = false
    while not p do Wait(1) end
    while true do 
        Wait(5000)
        for k, v in pairs(p:getInventaire()) do
            if v.name == "gps" then
                gpsstate = true
                if NeedToHideGps == false then
                    DisplayRadar(true)
                    hasGPS = true
                else
                    DisplayRadar(false)
                end
            end
        end
        if not gpsstate then
            DisplayRadar(false)
            hasGPS = false
        end
        gpsstate = false
    end
end)

local inChoice = false
local selectedPlayer = nil
local function StartChoicePlayer(players)
    selectedPlayer = nil
    local timer = GetGameTimer() + 10000
    if #players == 1 and players[1] == PlayerId() then 
        -- ShowNotification("~r~Il n'y a personne autour de vous")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Il n'y a personne autour de vous"
        })

        inChoice = false
        return
    end
    -- ShowNotification(
    --    "Appuyez sur ~g~E~s~ pour valider\nAppuyez sur ~b~L~s~ pour changer de cible\nAppuyez sur ~r~X~s~ pour annuler")

    -- New notif
    exports['aHUD']:toggleHotkeys(true)

    while inChoice do
        if next(players) then
            if players[1] == PlayerId() then 
                table.remove(players, 1)
                if next(players) then
                    timer = GetGameTimer() + 10000
                end                
            end
            local mCoors = GetEntityCoords(GetPlayerPed(players[1]))
            DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255,
                255, 120, 0, 1, 2, 0, nil, nil, 0)
            if GetGameTimer() > timer then
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le délai est dépassé"
                })

                exports['aHUD']:toggleHotkeys(false)
                inChoice = false
                return
            elseif IsControlJustPressed(0, 51) then -- E
                selectedPlayer = players[1]
                inChoice = false
                exports['aHUD']:toggleHotkeys(false)
                return
            elseif IsControlJustPressed(0, 182) then -- L
                table.remove(players, 1)
                if next(players) then
                    timer = GetGameTimer() + 10000
                end
            elseif IsControlJustPressed(0, 73) then -- X
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s annulé"
                })
                exports['aHUD']:toggleHotkeys(false)

                selectedPlayer = nil
                inChoice = false
                return
            end
        else
            -- ShowNotification("~r~Il n'y a personne autour de vous")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Il n'y a personne autour de vous"
            })

            selectedPlayer = nil
            inChoice = false
            return
        end
        Wait(0)
    end
    exports['aHUD']:toggleHotkeys(false)
end

RegisterNetEvent("core:useGps", function()
    local Waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(Waypoint) then
        local waypointCoords = GetBlipInfoIdCoord(Waypoint)
        local player = GetAllPlayersInArea(p:pos(), 3.0)
        if player ~= nil then
            if next(player) then
                inChoice = true
                StartChoicePlayer(player)
                if selectedPlayer ~= nil then
                    TriggerServerEvent("core:SendCoordsToPly", {x= waypointCoords["x"], y= waypointCoords["y"]}, GetPlayerServerId(selectedPlayer))
                end                
            end
        end
    else
        -- ShowNotification("Vous n'avez pas sélectionné de point GPS.")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous n'avez pas sélectionné de point GPS."
        })

    end
end)

RegisterNetEvent("core:SendGpsCoordsToPly", function(coords, time)
    CreateThread(function()
        local timer = GetGameTimer() + 10000
        -- ShowNotification("Vous avez reçu un point GPS\nAppuyez sur ~g~E~s~ pour valider\nAppuyez sur ~r~X~s~ pour annuler")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 10, -- In seconds, default:  4
            content = "Vous avez ~s reçu ~c un ~s point GPS"
        })

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            duration = 10, -- In seconds, default:  4
            content = "Appuyer sur ~K E pour ~s valider"
        })

        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 10, -- In seconds, default:  4
            content = "Appuyez sur ~K X pour ~s annuler"
        })


        while true do
            Wait(1)
            if GetGameTimer() > timer then
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le délai est dépassé"
                })

                table.insert(allPosGps, {time = time, x= coords.x, y = coords.y})
                break
            elseif IsControlJustPressed(0, 51) then -- E
                -- ShowNotification("~g~Un point GPS a été placé.")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Un point GPS a été ~s placé."
                })

                SetNewWaypoint(coords.x, coords.y)
                table.insert(allPosGps, {time = time, x= coords.x, y = coords.y})
                break
            elseif IsControlJustPressed(0, 73) then -- X
                -- ShowNotification("~r~Vous avez refusé le point GPS")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s refusé ~c le point GPS"
                })

                break
            end
        end
    end)
end)

local gpsmenu = RageUI.CreateMenu("GPS", "Historique des points GPS")
local gpsopen = false
gpsmenu.Closed = function()
    gpsopen = false
end

RegisterCommand("gps", function()
    if not allPosGps or not next(allPosGps) then
        -- ShowNotification("~r~Vous n'avez pas d'ancien point GPS partagé.")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas ~s d'ancien point GPS ~s partagé."
        })

    else
        CreateThread(function()
            gpsopen = true
            RageUI.Visible(gpsmenu, not RageUI.Visible(gpsmenu))
            while gpsopen do 
                Wait(1)
                RageUI.IsVisible(gpsmenu, function()
                    for k,v in pairs(allPosGps) do 
                        RageUI.Button(k .. " - Point GPS du " .. v.time, false, {}, true, {
                            onSelected = function()
                                SetNewWaypoint(v.x, v.y)
                                -- ShowNotification("~g~Un point GPS a été placé.")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Un point GPS a été ~s placé."
                                })


                            end
                        })
                    end
                end)
            end
        end)
    end
end)