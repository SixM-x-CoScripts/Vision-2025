local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function ChangePlate()
    local vehicles, dist = GetClosestVehicle(p:pos())
    if #(p:pos() - GetWorldPositionOfEntityBone(vehicles, GetEntityBoneIndexByName(vehicles, "bodyshell"))) <= 3 then        
        local DataPlaque = {
            header = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuPlaque/banner.webp',
            current = GetVehicleNumberPlateText(vehicles),
            message = 'Premium',
        }
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuPlaque',
            data = DataPlaque
        }))
        --local newPlate = KeyboardImput("Changement de plaque")
        --print('oncar', newPlate, newPlate:match("%W"))
        --if newPlate ~= nil and newPlate ~= "" and #newPlate <= 8 then
        --    if newPlate:match("%W") == nil then
        --        if not TriggerServerCallback("core:plateExist", newPlate) then
        --            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicles)))
        --            local changePlate = TriggerServerCallback("core:ChangePlateVeh", vehicle.getProps(vehicles).plate, string.upper(newPlate), model)
        --            print("change", changePlate)
        --            RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        --            while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
        --                Wait(0)
        --            end
        --            -- if changePlate then
        --            p:PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1)
        --            SendNuiMessage(json.encode({
        --                type = 'openWebview',
        --                name = 'Progressbar',
        --                data = {
        --                    text = "Changement en cours...",
        --                    time = 8,
        --                }
        --            }))
        --            Modules.UI.RealWait(8000)
        --            ClearPedTasks(p:ped())
        --            TriggerServerEvent("core:RemoveItemToInventory", token, "plate", 1, {})
        --            vehicle.setProps(vehicles, { plate = string.upper(newPlate) })
        --            TriggerServerEvent("core:SetPropsVeh", token, string.upper(newPlate),
        --                vehicle.getProps(vehicles))
        --            -- ShowNotification("La plaque d'immatriculation a bien été changée")
--
        --            -- New notif
        --            exports['vNotif']:createNotification({
        --                type = 'VERT',
        --                -- duration = 5, -- In seconds, default:  4
        --                content = "La plaque d'immatriculation a ~s bien été changée"
        --            })
--
        --            -- end
        --        else
        --            exports['vNotif']:createNotification({
        --                type = 'ROUGE',
        --                -- duration = 5, -- In seconds, default:  4
        --                content = "La plaque d'immatriculation ~s existe deja"
        --            })
        --        end
        --    else
        --        exports['vNotif']:createNotification({
        --            type = 'ROUGE',
        --            -- duration = 5, -- In seconds, default:  4
        --            content = "La plaque d'immatriculation ~s comporte des caractères spéciaux"
        --        })
        --    end
        --else
        --    -- ShowNotification("La plaque d'immatriculation doit contenir entre 1 et 8 caractères")
--
        --    -- New notif
        --    exports['vNotif']:createNotification({
        --        type = 'ROUGE',
        --        -- duration = 5, -- In seconds, default:  4
        --        content = "La plaque d'immatriculation doit contenir ~s entre 1 et 8 caractères"
        --    })
--
        --end
    end
end

function IsMyVehicle(plate)
    local plateOrigin = TriggerServerCallback("core:getOriginPlate", plate)
    if plateOrigin == nil then print("erreur avec une plaque ouvrez un ticket pour prestor le bg") end
    return TriggerServerCallback("core:IsOwnerOfCar", plateOrigin)
end

local spam = false
RegisterNUICallback("menuPlaque", function(data)
    local text = data.text 
    if text and text ~= "" then 
        local newPlate = text
        if newPlate ~= nil and newPlate ~= "" and string.len(newPlate) == 8 then
            local vehicles, dist = GetClosestVehicle(p:pos())
            if newPlate:match("%W") == nil then
                if IsMyVehicle(GetVehicleNumberPlateText(vehicles)) then
                    if not spam then
                        if not TriggerServerCallback("core:plateExist", newPlate) then
                            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicles)))
                            local changePlate = TriggerServerCallback("core:ChangePlateVeh", vehicle.getProps(vehicles).plate, string.upper(newPlate), model)
                            print("change", changePlate)
                            RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
                            while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
                                Wait(0)
                            end
                            spam = true 
                            CreateThread(function()
                                Wait(5 * 60000)
                                spam = false
                            end)
                            p:PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 1)
                            SendNuiMessage(json.encode({
                                type = 'openWebview',
                                name = 'Progressbar',
                                data = {
                                    text = "Changement en cours...",
                                    time = 8,
                                }
                            }))
                            Modules.UI.RealWait(8000)
                            ClearPedTasks(p:ped())
                            vehicle.setProps(vehicles, { plate = string.upper(newPlate) })
                            TriggerServerEvent("core:SetPropsVeh", token, string.upper(newPlate),
                                vehicle.getProps(vehicles))
                                
                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                -- duration = 5, -- In seconds, default:  4
                                content = "La plaque d'immatriculation a ~s bien été changée"
                            })
                            
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "La plaque d'immatriculation ~s existe deja"
                            })
                        end
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Vous devez attendre avant de re-changer de plaque"
                        })
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous ne pouvez changer de plaque que sur vos véhicules"
                    })
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "La plaque d'immatriculation ~s ne doit pas comporter de caractères spéciaux"
                })
            end
        else            
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "La plaque d'immatriculation ~s doit faire 8 caractères"
            })            
        end
    end
    if premReturn == true then
        openCb()
        premReturn = false
        return
    end
end)

local premReturn = false
local now = false
RegisterCommand("plate", function(source, args, raw)
    if args[1] == "prem" and p:getPermission() > 0 then premReturn = true end
    if p:getSubscription() >= 1 then
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        Wait(100)
        now = true
        ChangePlate()
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~c Vous devez avoir le premium pour pouvoir utiliser cette commande"
        })
    end
end)

RegisterNetEvent("core:UsePlate")
AddEventHandler("core:UsePlate", function()
    if p:getSubscription() >= 1 then
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        ChangePlate()
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~c Vous devez avoir le premium pour pouvoir utiliser cette commande"
        })
    end
end)
-- local created = false
-- Citizen.CreateThread(function()
--     local ped = nil
--     if not created then
--         ped = entity:CreatePedLocal("player_two", vector3(1975.1326904297, 3818.6940917969, 32.43628692627),
--             81.998306274414)
--         created = true

--     end
--     SetEntityInvincible(ped.id, true)
--     ped:setFreeze(true)
--     TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
--     SetEntityAsMissionEntity(ped.id, 0, 0)
--     SetBlockingOfNonTemporaryEvents(ped.id, true)
-- end)

-- zone.addZone(
--     "plate",
--     vector3(1975.098886719, 3818.6213378906, 33.43628692627),
--     "Appuyer sur ~INPUT_CONTEXT~ pour acheter une plaque (~g~50$~s~)",
--     function()
--         if p:pay(50) then
--             TriggerSecurGiveEvent("core:addItemToInventory", token, "plate", 1, {})
--         end
--     end,
--     false,
--     36, 0.5, { 255, 255, 255 }, 255
-- )

RegisterNUICallback("focusOut", function(data)
    if premReturn and now then
        openCb()
        premReturn = false
        return
    end
end)

RegisterCommand("plateExists", function(source ,args)
    print(TriggerServerCallback("core:plateExist", args[1]))
end)

RegisterCommand("getOriginalPlate", function(source ,args)
    print(TriggerServerCallback("core:getOriginPlate", args[1]))
end)