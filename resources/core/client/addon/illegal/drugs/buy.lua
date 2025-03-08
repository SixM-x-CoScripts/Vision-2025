--[[local crew = "families"
local rank = 1
local data = {}
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
-- menu provisoire
local livraison = {}
local open = false
local main = RageUI.CreateMenu("Tablette", "ta capter le S on bicrave ici")
local boutique = RageUI.CreateSubMenu(main, "Tablette", "C'est de la bonne le reuf")
local finishCommande = RageUI.CreateSubMenu(boutique, "Tablette", "Commande")
local heure = { "19:10", "19:20", "19:30", "19:40", "19:50", "20:00", "20:10", "20:20", "20:30", "20:40",
    "20:50", "21:00", "21:10", "21:20", "21:30", "21:40", "21:50", "22:00", "22:10", "22:20", "22:30",
    "22:40", "22:50", "23:00", "23:10", "23:20", "23:30", "23:40", "23:50", "00:00", "00:10", "00:20",
    "00:30", "00:40", "00:50", "01:00", "01:10", "01:20", "01:30", "01:40", "01:50", "02:00" }
function OpenTabletteIllegal()
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("Article disponible", nil, {}, true, {
                        onSelected = function()
                            for k, v in pairs(DrugsOLD.Crew) do

                                if v.name == crew then

                                    rank = v.rank
                                end
                            end
                        end

                    }, boutique)
                    RageUI.Separator("Livraison programmée")

                end)
                RageUI.IsVisible(boutique, function()
                    for k, v in pairs(DrugsOLD.Item) do
                        if v.rank == rank and v.acces then

                            RageUI.Button(v.label, nil, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    if v.rank == rank then
                                        data.label = v.label
                                        data.name = v.name
                                        data.rank = v.rank
                                        -- TriggerServerEvent("drugs:buy", v.id)
                                    end
                                end
                            }, finishCommande)
                        end
                    end
                end)
                RageUI.IsVisible(finishCommande, function()
                    RageUI.Separator("Commande : " .. data.label)
                    RageUI.Separator("Choisissez une horaire de livraison : ")
                    for k, v in pairs(heure) do
                        RageUI.Button(v, nil, {}, true, {
                            onSelected = function()
                                ---Finish
                                data.heure = v
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)
    end
end

function OpenTabletteIllegalNui()
    local tables = {}
    local ranks
    if p:getCrew() ~= "None" then
        for k, v in pairs(DrugsOLD.Crew) do
            if v.name == p:getCrew() then
                ranks = v.rank
            end
        end

        SetNuiFocus(true, true)
        for k, v in pairs(DrugsOLD.Item) do
            if v.rank == ranks then
                table.insert(tables, {
                    id = k,
                    name = v.name,
                    label = v.label,
                    picture = v.img,
                    drugs = v.drugs,
                    quantity = v.quantity,
                    price = v.price,
                    description = v.desc
                })
            end
        end
        SendNUIMessage({
            type = "openWebview",
            name = "tablettedrugs",
            data = {
                items = { table.unpack(tables) },
                times = { "19:00", "19:10", "19:20", "19:30", "19:40", "19:50", "20:00", "20:10", "20:20", "20:30",
                    "20:40", "20:50", "21:10", "21:20", "21:30", "21:40", "21:50", "22:00", "22:10",
                    "22:20", "22:30", "22:40", "22:50", "23:00", "23:10", "23:20", "23:30", "23:40", "23:50",
                    "00:00", "00:10", "00:20", "00:30", "00:40", "00:50", "01:00", "01:10", "01:20", "01:30", "01:40",
                    "01:50", "02:00"
                },
                name = p:getCrew()
            }
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Accès ~s refusé"
        })

    end
end

--
local time = 10 * 60000
local timeBlips = 5 * 60000
function BlipMission(my, pos)
    if not my then
        local random = math.random(100, 300.0)
        local random2 = math.random(1, 4)
        if random2 == 1 then
            pos = vector3(pos.x + random, pos.y + random, pos.z + random)
        elseif random2 == 2 then
            pos = vector3(pos.x + random, pos.y - random, pos.z + random)
        elseif random2 == 3 then
            pos = vector3(pos.x - random, pos.y + random, pos.z + random)
        elseif random2 == 4 then
            pos = vector3(pos.x - random, pos.y - random, pos.z + random)
        end
        local blips = AddBlipForRadius(pos, 500.0)
        SetBlipSprite(blips, 9)
        SetBlipColour(blips, 1)
        SetBlipAlpha(blips, 100)
        Modules.UI.RealWait(timeBlips)
        RemoveBlip(blips)

    else
        local blips = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blips, 140)
        SetBlipScale(blips, 0.75)
        SetBlipColour(blips, 2)
        SetBlipAsShortRange(blips, true)
        SetBlipRoute(blips, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Zone de livraison")
        EndTextCommandSetBlipName(blips)
        Modules.UI.RealWait(timeBlips)
        RemoveBlip(blips)
    end
end

RegisterCommand("testbuy", function()

     ShowAdvancedNotification("Simeon", "", "Livraison effectuée. Rendez-vous a la position: SEGNORA",
        "CHAR_CASTRO", "CHAR_CASTRO")

 end, false)


---start oklm et tout tu coco le sang de la veine
function StartLivraisonDrugs(item, quantity, pos)
    -- Creation Blisp
    local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z))
     ShowAdvancedNotification("Simeon", "", "Livraison effectuée. Rendez-vous a la position: " .. streetName,
        "CHAR_CASTRO", "CHAR_CASTRO")

    Wait(3000)
end

-- function SpawnAndAlerte(item, quantity, pos)
--     local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z))
--     local maths = math.random(0, 100)
--     local vehs = math.random(1, #veh)
--     if vehicle.IsSpawnPointClear(vector3(pos.x, pos.y, pos.z), 10.0) then
--         local veh = vehicle.create(veh[vehs], pos, {})
--         while not DoesEntityExist(veh) do Wait(1) end
--         SetVehicleHasBeenOwnedByPlayer(veh, true)
--         Wait(1000)
--         SetVehicleOnGroundProperly(veh)
--         TriggerServerEvent("core:AddItemToVehicleStaff", token, item, quantity, vehicle.getProps(veh).plate, {})
--     end
--     Wait(3 * 6000) -- 18 seconde
--     if maths <= 100 then
--         TriggerSecurEvent('core:makeCall', "lspd", pos, true, "Un convoi suspect a été aperçu sur " .. streetName,
--             false, "drugs")
--     end
-- end

RegisterNetEvent("core:NotifAndSpawnTablet")
AddEventHandler("core:NotifAndSpawnTablet", function(data)
    local pos = data.pos
    local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z))
    Wait(3 * 6000) -- 18 seconde
    TriggerSecurEvent('core:makeCall', "lspd", pos, true, "Convoi suspect vers " .. streetName, false, "drugs")
    TriggerSecurEvent('core:makeCall', "lssd", pos, true, "Convoi suspect vers " .. streetName, false, "drugs")
    TriggerSecurEvent('core:makeCall', "gcp", pos, true, "Convoi suspect vers " .. streetName, false, "drugs")
    -- SpawnAndAlerte(data.item, data.quantity, data.pos)
end)

RegisterNUICallback("tablettedrugs_callback", function(data, cb)
    local horaire = TriggerServerCallback("core:getHoraireTablette", data.time, p:getCrew())
    if horaire then
        if p:payLiquide(data.item.price * data.quantityItem) then
            local random = math.random(1, #DrugsOLD.Livraison)
            local ranks
            for key, value in pairs(DrugsOLD.Crew) do
                if value.name == p:getCrew() then
                    ranks = value.rank
                end
            end
            if data.time ~= nil then
                if data.time == "23H00" then
                    data.time = "19:00"
                end
                if data.quantityItem ~= 1 then
                    TriggerServerEvent("core:Addlivraison", token, tostring(data.time), data.item.name, data.quantityItem
                    , data.item.price * data.quantityItem, p:getCrewType(), p:getCrew(), DrugsOLD.Livraison[random].pos)
                elseif data.quantityItem == 1 then
                    TriggerServerEvent("core:Addlivraison", token, tostring(data.time), data.item.name,
                    data.item.quantity, data.item.price, p:getCrewType(), p:getCrew(), DrugsOLD.Livraison[random].pos)
                end
                 ShowAdvancedNotification("Simeon", "",
                    "~g~Commande effectuée avec succès~s~.\nJe te transmets la position à l'heure convenue",
                    "CHAR_CASTRO", "CHAR_CASTRO")

                -- VOIR POUR METTRE UNE PLUS GROSSE NOTIF EN MODE APPEL JUSTE AVEC LA POS ET TT


                Wait(3000)
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            end
        else
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas assez d'argent."
            })
        

        end
    end

    cb({})

end)

RegisterNetEvent("core:NotificationStart")
AddEventHandler("core:NotificationStart", function(token, pos)
    if p:getCrew() ~= nil and p:getCrew() ~= "" then
        local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z))
        ShowAdvancedNotification("Nabil la balance", "", "J'ai aperçu un convoi étrange vers " .. streetName,
            "CHAR_CASTRO", "CHAR_CASTRO")
    end
end)

RegisterNetEvent("core:StartMissionBlips")
AddEventHandler("core:StartMissionBlips", function(data)
    if data.rank == p:getCrewType() then
        if p:getCrew() == data.crew then
            BlipMission(true, data.pos)
        else
            BlipMission(false, data.pos)
        end
    end
end)

RegisterNetEvent("core:StartMission")
AddEventHandler("core:StartMission", function(data)
    if data.rank == p:getCrewType() then
        local spawnveh = TriggerServerCallback("core:VehTabletSpawn", token, false)
        StartLivraisonDrugs(data.item, data.quantity, data.pos)
    end
end)

RegisterNetEvent('core:Usetablet')
AddEventHandler("core:Usetablet", function()
    local policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
    if policeMans >= 4 then
        OpenTabletteIllegalNui()
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Le vendeur n'est ~s pas disponible."
        })

    end
end)]]


--[[ RegisterNetEvent("core:UseKevlarGang")
AddEventHandler("core:UseKevlarGang", function(item, shield)
    local inUse
    if p:haveItemWithCount(item, 1) then
        print(p:skin().bproof_1)
        if p:skin().bproof_1 == 60 or p:skin().bproof_1 == 2 or p:skin().bproof_1 == 61 or p:skin().bproof_1 == 106 or p:skin().bproof_1 == 107 or p:skin().bproof_1 == 108 or
            p:skin().bproof_1 == 110 or p:skin().bproof_1 == 111 or p:skin().bproof_1 == 112 or p:skin().bproof_1 == 113 or p:skin().bproof_1 == 114 then
            inUse = false
            p:setShield(0)
            p:setCloth("bproof_1", 0)
            p:setCloth("bproof_2", 0)
            return
        else
            inUse = true
            if item == "t1_1" then
                p:setCloth("bproof_1", 110)
                p:setCloth("bproof_2", 0)
            elseif item == "t1_2" then
                p:setCloth("bproof_1", 110)
                p:setCloth("bproof_2", 1)
            elseif item == "t1_3" then
                p:setCloth("bproof_1", 110)
                p:setCloth("bproof_2", 2)
            elseif item == "t1_4" then
                p:setCloth("bproof_1", 111)
                p:setCloth("bproof_2", 0)
            elseif item == "t1_5" then
                p:setCloth("bproof_1", 111)
                p:setCloth("bproof_2", 1)
            elseif item == "t1_6" then
                p:setCloth("bproof_1", 111)
                p:setCloth("bproof_2", 2)
            elseif item == "t2_1" then
                p:setCloth("bproof_1", 112)
                p:setCloth("bproof_2", 0)
            elseif item == "t2_2" then
                p:setCloth("bproof_1", 112)
                p:setCloth("bproof_2", 1)
            elseif item == "t2_3" then
                p:setCloth("bproof_1", 112)
                p:setCloth("bproof_2", 2)
            elseif item == "t2_4" then
                p:setCloth("bproof_1", 113)
                p:setCloth("bproof_2", 0)
            elseif item == "t2_5" then
                p:setCloth("bproof_1", 113)
                p:setCloth("bproof_2", 1)
            elseif item == "t2_6" then
                p:setCloth("bproof_1", 114)
                p:setCloth("bproof_2", 0)
            elseif item == "t2_7" then
                p:setCloth("bproof_1", 114)
                p:setCloth("bproof_2", 1)
            end
            p:setShield(shield)
            while GetPedArmour(p:ped()) > 0 do Wait(1000) end
            if inUse and p:skin().bproof_1 ~= 0 then
                inUse = false
                p:setShield(0)
                p:setCloth("bproof_1", 0)
                p:setCloth("bproof_2", 0)
                for key, value in pairs(p:getInventaire()) do
                    if item == value.name then
                        TriggerServerEvent('core:RemoveItemToInventory', token, item, 1, value.metadatas)
                        -- p:setCloth("bproof_1", 1)
                        return
                    end
                end
            end
        end
    end
end) ]]