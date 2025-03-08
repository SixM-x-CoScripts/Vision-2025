local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function LoadRealEstateAgent()
    dutyproperty = false
    zone.addZone(
        "society_REA",
        vector3(-717.43695068359, 259.68115234375, 84.137870788574),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir les actions d'entreprise",
        function()
            OpenSocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleGestion"
    )
    zone.addZone(
        "coffre_REA",
        vector3(-716.45727539063, 266.95428466797, 84.100952148438),
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le coffre de l'entreprise",
        function()
            OpenInventorySocietyMenu() --TODO: fini le menu society
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        1.5,
        true,
        "bulleCoffre"
    )

    local open = false
    local createProperty_main = RageUI.CreateMenu("", "Creation de propriete", 0.0, 0.0, "root_cause",
        "Banner-D8")
    local createProperty_editInterior = RageUI.CreateSubMenu(createProperty_main, "", "Creation de propriete", 0.0, 0.0,
        "root_cause", "Banner-D8")
    local createProperty_editInterior_index = RageUI.CreateSubMenu(createProperty_editInterior, "",
        "Creation de propriete", 0.0, 0.0, "root_cause", "Banner-D8")
    createProperty_main.Closed = function()
        open = false
    end
    createProperty_editInterior.Closable = false

    local propertyType = {
        "Appartement",
        -- "Maison",
        "Garage",
        "Entrepot",
        "Bureau",
        "Autres",
    }
    local typeIndex = 1
    local enterIndex = 1
    local interiorIndex = 1
    local interiorEtage = {}
    local etageIndex = 1
    local propertyName = ""
    local enterCoords = vector3(0, 0, 0)
    local enterMarker = false
    local selected_etage = 0
    local garageOutIndex = 1
    local garageCoords = vector4(0, 0, 0, 0)
    local GarageMarker = false


    zone.addZone(
        "society_real_estate_delete",
        vector3(-711.57250976563, 276.09552001953, 84.320617675781),
        "~INPUT_CONTEXT~ Ranger le véhicule",
        function()
            if IsPedInAnyVehicle(p:ped(), false) then
                if GetVehicleBodyHealth(p:currentVeh()) / 10 >= 80 or
                    GetVehicleEngineHealth(p:currentVeh()) / 10 >= 80 then
                    local veh = GetVehiclePedIsIn(p:ped(), false)
                    --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                    DeleteEntity(veh)

                else
                    -- ShowNotification("~r~Votre véhicule est trop abimé")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Votre véhicule est trop abimé"
                    })

                end
            end

        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleGarage"
    )

    zone.addZone(
        "society_real_estate_spawn",
        vector3(-716.93304443359, 274.10864257813, 84.684341430664),
        "~INPUT_CONTEXT~ Sortir le véhicule",
        function()
            if dutyproperty then
                OpenMenuVehRealEstate() --TODO: fini le menu society
            else
                -- ShowNotification("~r~Vous n'êtes pas en service")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes ~s pas en service"
                })

            end
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleVehicule"
    )

    local listVeh = {
        headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_dynasty.webp',
        headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
        headerIconName = 'VEHICULES',
        callbackName = 'vehMenuEstate',
        elements = {
            {
                id = 1,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/baller2.webp',
                label = 'Baller',
                name = "baller2"
            },
            {
                id = 2,
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/washington.webp',
                label = 'Washington',
                name = "washington"
            },
        }
    }

    function OpenMenuVehRealEstate()
        forceHideRadar()
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogue',
            data = listVeh
        }))
    end

    RegisterNUICallback("MenuHabitationPreview", function (data, cb)
    end)

    function OpenPropertyCreationMenu()
        if dutyproperty then
            closeUI()
            local  liste_habitation, liste_stockage, liste_garage, timeLocation  = {}, {}, {}, 15
            for k,v in pairs(Property["Appartement"].ListName) do
                table.insert(liste_habitation, {id = k, valeur = v, img = "https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Selection/Habitation/img"..k..".webp", categorie = "habitation"})
            end
            for k,v in pairs(Property["Entrepot"].ListName) do
                table.insert(liste_stockage, {id = k, valeur = v, img = "https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Selection/Stockage/img"..k..".webp", categorie = "stockage"})
            end
            for k,v in pairs(Property["Garage"].ListName) do
                table.insert(liste_garage, {id = k, valeur = v, img = "https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Selection/Garage/img"..k..".webp", categorie = "garage"})
            end
            forceHideRadar()
            Wait(100)
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Menu_habitation',
                data = { habitation = liste_habitation,
                         garage = liste_garage,
                         stockage = liste_stockage,
                         maxDuration =  timeLocation
                    }
            }))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'êtes ~s pas en service"
            })
        end
    end
    local elements = nil
    local openRadial = false

    local function CloseRadial()
        openRadial = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end

    function PropertyFacture()
        if dutyproperty then
            CloseRadial()
            TriggerEvent("nuiPapier:client:startCreation",2)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end

    function CreateAdvert()
        if dutyproperty then
            CloseRadial()
            CreateJobAnnonce()
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous devez ~s prendre votre service"
            })
        end
    end
    
    function PropertyDuty()
        if dutyproperty then
            TriggerServerEvent('core:DutyOff', "realestateagent")
            -- ShowNotification("Vous avez ~r~quitté~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s quitté ~c votre service"
            })

            dutyproperty = false
            Wait(5000)
        else
            TriggerServerEvent('core:DutyOn', "realestateagent")
            -- ShowNotification("Vous avez ~g~pris~s~ votre service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s pris ~c votre service"
            })

            dutyproperty = true
            Wait(5000)
        end
    end

    function OpenPropertyRadial()
        if not openRadial then
            openRadial = true
            CreateThread(function()
                while openRadial do
                    Wait(0)
                    DisableControlAction(0, 1, openRadial)
                    DisableControlAction(0, 2, openRadial)
                    DisableControlAction(0, 142, openRadial)
                    DisableControlAction(0, 18, openRadial)
                    DisableControlAction(0, 322, openRadial)
                    DisableControlAction(0, 106, openRadial)
                end
            end)
            elements = {
                {
                    name = "ANNONCE",
                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                    action = "CreateAdvert"
                }, 
                {
                    name = "FACTURE",
                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                    action = "PropertyFacture"
                },
                {
                    name = "PRISE DE SERVICE",
                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                    action = "PropertyDuty"
                },
                {
                    name = "PROPRIÉTÉ",
                    icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/house.svg",
                    action = "OpenPropertyCreationMenu"
                }
            }
            Wait(200)
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'RadialMenu',
                data = {elements = elements,  title = "DYNASTY 8"}
            }));
        else
            CloseRadial()
            return
        end
    end

    RegisterJobMenu(OpenPropertyRadial)

    RegisterNUICallback("focusOut", function(data, cb)
        if openRadial then
            CloseRadial()
        end
    end)

    function FactureAgentImmo(entity)
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
            --ShowNotification("Facturation envoyée \n Prix : ~g~" ..
            --    billing_price .. "~s~$ \n Raison : " .. billing_reason)

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "Facturation envoyée \nPrix : ~s " .. billing_price .. "$ \n~c Raison : ~s " .. billing_reason
            })
            
        end
    end
end

function UnLoadRealEstateAgent()
    zone.removeZone("society_REA")
    zone.removeZone("coffre_REA")
end

-- RegisterCommand("ipl", function ()
--     --xm_x17dlc_int_placement_interior_32_v_garagem_milo_ -- garage 2 place
--     --hei_hw1_blimp_interior_2_dlc_garage_high_new_milo_ -- garage 10 place
--     --sf_int_placement_sec_interior_2_dlc_garage_sec_milo_ -- garage truc place
--     --vw_casino_carpark -- garage casino
--     --hei_dt1_11_interior_0_dt1_11_carpark -- oh encore un autre garage
--     local ipl = "hei_sm_13_interior_0_sm_13_carpark"
--     RequestIpl(ipl)
--     while not IsIplActive(ipl) do Wait(1) end
--     SetInteriorRoomFlag(GetInteriorAtCoords(-1527.9731, -587.80927, 26.144802), 1, 64)
--     -- SetInteriorPortalFlag(GetInteriorAtCoords(-1527.9731, -587.80927, 26.144802), 1, 256)
--     RefreshInterior(GetInteriorAtCoords(-1527.9731, -587.80927, 26.144802))
--     SetEntityCoords(p:ped(), vector3(-1527.9731, -587.80927, 26.144802))
-- end)


RegisterNUICallback("MenuHabitationCreation", function (data, cb)
    propertyId = nil
    propertyName = data.name
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    local we = GetEntityHeading(PlayerPedId())
    enterCoords = vector4(x,y,z,we)
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    local result = ChoicePlayersInZone(3.0, true)
    if result == nil then
        -- ShowNotification("Vous avez annulé la creation de la propriété")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s annulé la creation ~c de la propriété"
        })

    else
        TriggerServerEvent("core:property:create", token, GetPlayerServerId(result), propertyName, enterCoords, {
            type = data.type,
            interior = data.propriete.valeur,
            duration = data.duration,
        }, data.capacity)
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez créé une nouvelle propriété"
        })
    end
end)

RegisterNUICallback("vehMenuEstate", function (data, cb)
    if vehicle.IsSpawnPointClear(vector3(-713.40368652344, 276.04968261719, 84.442810058594), 3.0) then
        RageUI.CloseAll()
        open = false
        if DoesEntityExist(vehs) then
            TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
            --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
            DeleteEntity(vehs)
        end
        vehs = vehicle.create(data.name, vector4(-713.40515136719, 276.05038452148, 84.443588256836, 298.48010253906), {})
        local plate = vehicle.getProps(vehs).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
        --createKeys(plate, model)
    else
        -- ShowNotification("Il n'y a pas de place pour le véhicule")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Il n'y a ~s pas de place ~c pour le véhicule"
        })

    end
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7realestateagent ^3loaded")
end)