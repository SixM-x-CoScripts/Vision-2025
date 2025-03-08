PawnShop = {}
PawnShop.Duty = false
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
function DutyPawnShop()
    if PawnShop.Duty then
        TriggerServerEvent("core:DutyOff", pJob)
        -- ShowNotification("Vous avez ~r~quitté~s~ votre service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté ~c votre service"
        })
        
        PawnShop.Duty = false
        Wait(5000)
    else
        TriggerServerEvent("core:DutyOn", pJob)
        -- ShowNotification("Vous avez ~g~pris~s~ votre service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s pris ~c votre service"
        })

        PawnShop.Duty = true
        Wait(5000)
    end
end

function FacturePawnShop(entity)
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
            TriggerServerEvent("core:sendbilling", token, GetPlayerServerId(closestPlayer), p:getJob(), billing_price,
                billing_reason)
        end
    else
        TriggerServerEvent("core:sendbilling", token, sID, p:getJob(), billing_price, billing_reason)
        -- ShowNotification("Facturation envoyée \n Prix : ~g~" .. billing_price .. "~s~$ \n Raison : " .. billing_reason)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
        })

    end
end

function SendMoneyPawnShop(entity)
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

    if entity ~= nil then

        TriggerServerEvent("core:SendMoneyFromEnterprise", token, sID, p:getJob(), billing_price, billing_reason)
        -- ShowNotification("Argent envoyé \n Prix : ~g~" .. billing_price .. "~s~$ \n Raison : " .. billing_reason)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Argent envoyé \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
        })

    end
end

local inChoice = false
local selectedPlayer = nil

local function StartChoicePlayer(players)
    selectedPlayer = nil

    -- New notif
    exports['aHUD']:toggleHotkeys(true)
    
    local timer = GetGameTimer() + 10000
    while inChoice do
        if next(players) then
            local mCoors = GetEntityCoords(GetPlayerPed(players[1]))
            DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255,
                255, 120, 0, 1, 2, 0, nil, nil, 0)
            if GetGameTimer() > timer then
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le délai a été dépassé"
                })

                inChoice = false
                exports['aHUD']:toggleHotkeys(false)
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
                -- ShowNotification("~r~Vous avez annulé")

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

            exports['aHUD']:toggleHotkeys(false)
            selectedPlayer = nil
            inChoice = false
            return
        end
        Wait(0)
    end
    exports['aHUD']:toggleHotkeys(false)
end

function ChangePropertyCar(entity)
    if PawnShop.Duty then
        if entity ~= nil then
            local canGo = true
            local name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(entity)))
            for k, v in pairs(concessSud.vehicle) do
                for j,x in pairs(concessSud.vehicle[k]) do
                    if k == "Premium" then
                        if x.name == name then 
                            canGo = false
                        end
                    end
                end
            end
            if not canGo then                             
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Impossible de changer de propriétaire d'un véhicule premium !"
                }) 
                return 
            end
            local plate = all_trim(GetVehicleNumberPlateText(entity))
            local player = GetAllPlayersInArea(p:pos(), 3.0)
            for k, v in pairs(player) do
                if v == PlayerId() then
                    --table.remove(player, k)
                end
            end

            if player ~= nil then
                if next(player) then
                    inChoice = true
                    StartChoicePlayer(player)
                    if selectedPlayer ~= nil then
                        local change = TriggerServerCallback("core:ChangePropertyCar", token, plate, string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(entity))), vehicle.getProps(entity),
                            GetPlayerServerId(selectedPlayer), "individuel")
                        if change then
                            -- ShowNotification("Vous venez de changer le propriétaire du véhicule")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous venez de ~s changer le propriétaire ~c du véhicule"
                            })

                        else
                            -- ShowNotification("ChangePropertyCar() - PTDRRR T'es qui ?")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s ChangePropertyCar()"
                            })

                        end
                    end
                end
            end

        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })

    end
end

function ChangePropertyCarCrew(entity)
    if PawnShop.Duty then
        if entity ~= nil then
            local canGo = true
            local name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(entity)))
            for k, v in pairs(concessSud.vehicle) do
                for j,x in pairs(concessSud.vehicle[k]) do
                    if k == "Premium" then
                        if x.name == name then 
                            canGo = false
                        end
                    end
                end
            end
            if not canGo then                             
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Impossible de changer de propriétaire d'un véhicule premium !"
                }) 
                return 
            end
            local plate = all_trim(GetVehicleNumberPlateText(entity))
            local player = GetAllPlayersInArea(p:pos(), 3.0)
            for k, v in pairs(player) do
                if v == PlayerId() then
                    --table.remove(player, k)
                end
            end

            if player ~= nil then
                if next(player) then
                    inChoice = true
                    StartChoicePlayer(player)
                    if selectedPlayer ~= nil then
                        local change = TriggerServerCallback("core:ChangePropertyCar", token, plate, string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(entity))), vehicle.getProps(entity),
                            GetPlayerServerId(selectedPlayer), "crew")
                        if change then
                            -- ShowNotification("Vous venez de changer le propriétaire du véhicule")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous venez de ~s changer le propriétaire ~c du véhicule"
                            })

                        else
                            -- ShowNotification("ChangePropertyCarCrew() - PTDRRR T'es qui ?")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s ChangePropertyCarCrew()"
                            })

                        end
                    end
                end
            end

        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })

    end
end

function ChangePropertyCarJOb(entity)
    if PawnShop.Duty then
        if entity ~= nil then
            local canGo = true
            local name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(entity)))
            for k, v in pairs(concessSud.vehicle) do
                for j,x in pairs(concessSud.vehicle[k]) do
                    if k == "Premium" then
                        if x.name == name then 
                            canGo = false
                        end
                    end
                end
            end
            if not canGo then                             
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Impossible de changer de propriétaire d'un véhicule premium !"
                }) 
                return 
            end
            local plate = all_trim(GetVehicleNumberPlateText(entity))
            local player = GetAllPlayersInArea(p:pos(), 3.0)
            for k, v in pairs(player) do
                if v == PlayerId() then
                    --table.remove(player, k)
                end
            end

            if player ~= nil then
                if next(player) then
                    inChoice = true
                    StartChoicePlayer(player)
                    if selectedPlayer ~= nil then
                        local change = TriggerServerCallback("core:ChangePropertyCar", token, plate, string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(entity))), vehicle.getProps(entity),
                        GetPlayerServerId(selectedPlayer), "job")
                        if change then
                            -- ShowNotification("Vous venez de changer le propriétaire du véhicule")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous venez de ~s changer le propriétaire ~c du véhicule"
                            })
                        else
                            -- ShowNotification("ChangePropertyCarJOb() - PTDRRR T'es qui ?")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s ChangePropertyCarJOb()"
                            })
                        end
                    end
                end
            end
        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })
    end
end

function AddCoOwnerCar(entity)
    if PawnShop.Duty then
        if entity ~= nil then
            local plate = all_trim(GetVehicleNumberPlateText(entity))
            local player = GetAllPlayersInArea(p:pos(), 3.0)
            for k, v in pairs(player) do
                if v == PlayerId() then
                    --table.remove(player, k)
                end
            end

            if player ~= nil then
                if next(player) then
                    inChoice = true
                    StartChoicePlayer(player)
                    if selectedPlayer ~= nil then
                        local change = TriggerServerCallback("core:AddCoOwners", token, plate,
                            GetPlayerServerId(selectedPlayer))
                        if change then
                            -- ShowNotification("Vous venez d'ajouter un co-propriétaire")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous venez ~s d'ajouter un co-propriétaire"
                            })
                        else
                            -- ShowNotification("AddCoOwnerCar() - PTDRRR T'es qui ?")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~c AddCoOwnerCar()"
                            })
                        end
                    end
                end
            end

        end
    else
        -- ShowNotification("Vous n'êtes pas en service")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'êtes ~s pas en service"
        })
    end
end

while RegisterClientCallback == nil do
    Wait(0)
end
RegisterClientCallback("core:AcceptChangeCar", function()
    local timer = GetGameTimer() + 10000
    local good = false

    -- ShowNotification("Appuyez sur ~g~Y~s~ pour accepter le changement de propriétaire \nAppuyez sur ~r~N~s~ pour l'ignorer")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K Y pour ~s accepter ~c le double des clés"
    })
    
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyez sur ~K N pour ~s l'ignorer"
    })


    while true do
        if GetGameTimer() > timer then
            -- ShowNotification("Vous avez ignoré la demande")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s ignoré ~c la demande"
            })

            return good
        elseif IsControlJustPressed(0, 246) then
            -- ShowNotification("~r~Vous avez accepté la demande")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s accepté ~c la demande"
            })

            good = true
            return good
        elseif IsControlJustPressed(0, 306) then
            -- ShowNotification("~r~Vous avez refusé la demande")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s refusé ~c la demande"
            })

            return good
        end
        Wait(0)
    end

end)

RegisterClientCallback("core:AddCoOwner", function()
    local timer = GetGameTimer() + 10000
    local good = false

    -- ShowNotification("Appuyez sur ~g~Y~s~ pour accepter le double des clés \nAppuyez sur ~r~N~s~ pour l'ignorer")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K Y pour ~s accepter ~c le double des clés"
    })
    
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyez sur ~K N pour ~s l'ignorer"
    })


    while true do
        if GetGameTimer() > timer then
            -- ShowNotification("Vous avez ignoré la demande")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s ignoré ~c la demande"
            })

            return good
        elseif IsControlJustPressed(0, 246) then
            -- ShowNotification("~r~Vous avez accepté la demande")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s accepté ~c la demande"
            })

            good = true
            return good
        elseif IsControlJustPressed(0, 306) then
            -- ShowNotification("~r~Vous avez refusé la demande")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s refusé ~c la demande"
            })

            return good
        end
        Wait(0)
    end

end)

function InfoVehPawnshop(entity)
    local textChar = "Pawnshop"
    local char = "PAWNSHOP"
    local oldPlate = TriggerServerCallback("core:getOriginPlate", all_trim(GetVehicleNumberPlateText(entity)))
    ShowAdvancedNotification(textChar,
        "Véhicule : " .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))),
        "\nPlaque~b~ : " .. all_trim(GetVehicleNumberPlateText(entity))
        .. "\nPlaque originel~b~ : " .. oldPlate
        .. "\n~s~Carrosserie : ~b~" ..
        math.round(GetVehicleBodyHealth(entity) / 10, 2) .. "~s~%"
        .. "\nÉtat moteur : ~b~" .. math.round(GetVehicleEngineHealth(entity) / 10, 2) .. "~s~%"
        .. "\nEssence : ~o~" .. math.round(GetVehicleFuelLevel(entity), 2) .. "~s~%", char, char)

    -- show advanced notification with engine, brakes, transmission, turbo, suspension stats
    local moteurstats = GetVehicleMod(entity, 11)
    if moteurstats == -1 then
        moteurstats = "Non installé"
    else
        moteurstats = "Niveau " .. moteurstats
    end
    local freinstats = GetVehicleMod(entity, 12)
    if freinstats == -1 then
        freinstats = "Non installé"
    else
        freinstats = "Niveau " .. freinstats
    end
    local transmissionstats = GetVehicleMod(entity, 13)
    if transmissionstats == -1 then
        transmissionstats = "Non installé"
    else
        transmissionstats = "Niveau " .. transmissionstats
    end
    local suspensionstats = GetVehicleMod(entity, 15)
    if suspensionstats == -1 then
        suspensionstats = "Non installé"
    else
        suspensionstats = "Niveau " .. suspensionstats
    end
    local turbostats = IsToggleModOn(entity, 18)
    if not turbostats then
        turbostats = "Non installé"
    else
        turbostats = "Installé"
    end

    ShowAdvancedNotification(textChar,
        "Véhicule : " .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(entity))),
        "~s~Moteur : ~b~ " ..
        moteurstats ..
        "~s~\nFreins : ~b~ " ..
        freinstats ..
        "~s~\nTransmission : ~b~ " ..
        transmissionstats ..
        "~s~\nSuspension : ~b~ " ..
        suspensionstats ..
        "~s~\nTurbo : ~b~" ..
        turbostats, char, char)
end

function HookVehiclePawnshop()
    CreateThread(function()
        vehicleThieft = nil
        local vehicle, dst = GetClosestVehicle(p:pos())
        local random = math.random(0, 100)

        if dst < 1.5 then
            local seat = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
            for i = -1, seat - 2 do
                if not IsVehicleSeatFree(vehicle, i) then
                    -- ShowNotification("~r~Il y a quelqu'un dans le vehicule")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Il y a quelqu'un dans le vehicule"
                    })

                    return
                end
            end
            RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
            while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
                Wait(0)
            end
            p:PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1)
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Progressbar',
                data = {
                    text = "Crochetage en cours...",
                    time = 10,
                }
            }))
            RemoveAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
            Wait(10000)
            ClearPedTasks(p:ped())
            NetworkRequestControlOfEntity(vehicle)
            SetVehicleDoorsLocked(vehicle, 0)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            SetVehicleUndriveable(vehicle, true)
            -- ShowNotification("~g~Vous avez crocheté le vehicule")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s crocheté le vehicule"
            })

        else
            local randomAlarm = math.random(0, 100)
            if randomAlarm < 10 then
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, 30000)
            end
            -- ShowNotification("~r~Vous n'êtes pas à proximité d'un véhicule")
        end
    end)
end

function GetVehiclePlatePawnshop(target)
    local entity
    local dst
    if entity ~= nil then
        entity = entity
        dst = 0
    else
        entity, dst = GetClosestVehicle(p:pos())
    end
    local plate = all_trim(GetVehicleNumberPlateText(entity))
    local result = TriggerServerCallback("core:CheckVehiclePlate", plate)

    if result then
        -- ShowNotification("Le véhicule appartient a Mr/Mme ~g~" .. result.nom .. " " .. result.prenom)

        -- New notif 
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Le véhicule ~s appartient ~c a Mr/Mme ~s" .. result.nom .. " " .. result.prenom
        })

    end
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7pawnshop ^3loaded")
end)