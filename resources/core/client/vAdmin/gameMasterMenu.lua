local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "vision", "Banner_Administration")
local second = RageUI.CreateSubMenu(main, "", "Action disponible", 0.0, 0.0, "vision", "Banner_Administration")
local open, checked, checked2 = false, false, false
local token = nil
local InActionZone = false
local distance = 0.0

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

main.Closed = function()
    RageUI.Visible(main, false)
    RageUI.Visible(second, false)
    open = false
end

function OpenGMmenu()
    if open then
        open = false
        RageUI.Visible(main, false)
        RageUI.Visible(second, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Checkbox("Mode Game Master", nil, checked, {}, {
                        onChecked = function()
                            TriggerServerEvent("core:acteurLog", token, "/gm", "Active le mode GameMaster")
                        end,
                        onUnChecked = function()
                            TriggerServerEvent("core:acteurLog", token, "/gm", "Désactive le mode GameMaster")
                        end,
                        onSelected = function(i)
                            checked = i;
                        end
                    })
                    if checked then
                        RageUI.Separator("↓ ~r~Action Monde~s~ ↓")
                        RageUI.Button("Spawn Véhicule", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local spawnName = KeyboardImput("Entrer un nom de véhicule")
                                -- logs
                                SpawnCar(spawnName)
                            end
                        })
                        RageUI.Button("Supprimer Véhicule", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local veh, dst = GetClosestVehicle()
                                if dst <= 6.0 then
                                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                                    TriggerServerEvent("DeleteEntity", token, { VehToNet(veh) })
                                    TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(veh)), VehToNet(veh))
                                    -- DeleteEntity(veh)
                                else
                                    -- ShowNotification("Aucun véhicule proche")
                        
                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "~s Aucun véhicule proche"
                                    })
                        
                                end
                            end
                        })
                        RageUI.Button("Réparer le Véhicule", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                --logs
                                SetVehicleFixed(p:currentVeh())
                                SetVehicleBodyHealth(p:currentVeh(), 1000.0)
                                SetVehicleEngineHealth(p:currentVeh(), 1000.0)
                                SetVehicleDirtLevel(p:currentVeh(), 0.0)
                            end
                        })
                        RageUI.Button("Ouvrir le menu props", false, { RightLabel = ">>" }, true, {
                            onSelected = function()

                            end
                        })
                        RageUI.Button("Ouvrir le menu zone vehicule (pas opti)", nil, { RightLabel = ">>" }, true, {
                            onSelected = function()

                            end
                        }, second)
                        RageUI.Separator("↓ ~r~Action Joueur~s~ ↓")
                        RageUI.Button("Choisir un ped", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local ped = KeyboardImput("Entrer un nom de ped")
                                local player = GetPlayerServerId(PlayerId())
                                TriggerServerEvent("core:acteurLog", token, "/setped", "Soi-même ** - Ped : **" .. ped)
                                TriggerServerEvent("core:setPedStaff", token, player, ped)
                            end
                        })
                        RageUI.Button("Se téléporter sur un joueur", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local player2 = KeyboardImput("Entrer un id de joueur")
                                TriggerServerEvent("core:acteurLog", token, "/goto", player2)
                                TriggerServerEvent("core:GotoBring", token, nil, tonumber(player2))
                            end
                        })
                        RageUI.Button("Téléporter un joueur sur moi", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local player3 = KeyboardImput("Entrer un id de joueur")
                                TriggerServerEvent("core:acteurLog", token, "/bring", player3)
                                TriggerServerEvent("core:GotoBring", token, tonumber(player3), nil)
                            end
                        })
                        RageUI.Button("Réanimer un joueur", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local player4 = KeyboardImput("Entrer un id de joueur")
                                TriggerServerEvent("core:acteurLog", token, "/revive", player4)
                                TriggerServerEvent("core:RevivePlayer", token, player4)
                            end
                        })
                        RageUI.Button("Se téléporter sur le marker", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                TriggerServerEvent("core:acteurLog", token, "TP sur le point", "Soi-même")
                                GotoMarker()
                            end
                        })
                    end
                end)

                RageUI.IsVisible(second, function()
                    RageUI.Button("Taille de la zone", false, { RightLabel = distance }, not InActionZone, {
                        onSelected = function()
                            distance = KeyboardImput("Entrer une taille de zone")
                            distance = distance + .0
                        end
                    })
                    if not InActionZone then 
                        RageUI.Checkbox("Afficher la zone", nil, checked2, {}, {
                            onSelected = function(i)
                                checked2 = i;
                            end
                        })
                    end
                    RageUI.Button("Ajouter la zone", false, { RightLabel = ">>" }, not InActionZone, {
                        onSelected = function()
                            if distance ~= nil then
                                RageUI.CloseAll()
                                open = false
                                checked2 = false
                                TriggerServerEvent("core:acteurLog", token, "Ajout d'une zone", "Pos : " .. p:pos() .. " - Taille : " .. distance)
                                InActionZone = true
                                CreateClientZone(p:pos(), distance)
                            end
                        end
                    })
                    RageUI.Button("Supprimer la zone", false, { RightLabel = ">" }, InActionZone, {
                        onSelected = function()
                            InActionZone = false
                        end
                    })
                    if checked2 then
                        DrawMarker(1, p:pos() + vector3(0.0, 0.0, -1000.0), 0.0, 0.0, 0.0, 0.0, 0.0, .0, distance + .0, distance + .0, 10000.0, 20, 192, 255, 70, 0, 0, 2, 0, 0, 0, 0)
                    end
                end)
                Wait(0)
            end
        end)
    end
end

function CreateClientZone(pos, radius)
    while InActionZone do 
        local vehicles = GetAllVehicleInArea(pos, radius+.0)
        for _, vehicle in ipairs(vehicles) do
            if GetPedInVehicleSeat(vehicle, -1) ~= 0 and not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteEntity(vehicle)
            end
        end
        Wait(0)
    end
end
