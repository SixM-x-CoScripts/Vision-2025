-- -276.49411010742, 6020.0151367188, 30.965690612793, 358.27435302734
local ped = nil
local created = false
local blipTravailRout
local trailer = nil
local PlayersInJob = {}
local GlobVeh 
local PlayersId = {}
local shouldBreak = false
local blipRoutier = nil

local hasDeposerRemorque = false

CreateThread(function()
    while not p do Wait(1) end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    if not created then
        ped = entity:CreatePedLocal("s_m_m_cntrybar_01", RoutierPos.Ped.xyz, RoutierPos.Ped.w)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
end)

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local spawnPlaces = {
    --vector4(-797.92742919922, 5390.0419921875, 33.299438476563, 358.06530761719),
    vector4(-285.1208190918, 6035.7719726563, 30.507102966309, 43.359828948975),
    vector4(-278.78448486328, 6043.3784179688, 30.543684005737, 56.082725524902),
}

RegisterNetEvent("core:activities:liveupdate", function(typejob, data, src)
    --print("core:activities:liveupdate", typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        --print("inside miam")
        if typejob == "routier" then 
            --print("routierrrrr", json.encode(data), data.recompense)
            if data.recompense then 
                --print("data.recompense", data.recompense)
                Bulle.hide("livrerRoutier")
                Bulle.remove("livrerRoutier")
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez gagné " .. data.recompense .. "$"
                })
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", data.recompense, {})--data.recompense, {})
                RemoveBlip(blipRoutier)
                blipRoutier = nil
                OpenTutoFAInfo("Routier", "Retournez à l'entrepot, un point GPS a été placé.")
                blipTravailRout = AddBlipForCoord(RoutierPos.DeleteService)
                SetBlipColour(blipTravailRout, 15)
                SetBlipRoute(blipTravailRout, 1)
            end
        end
    end
end)

local function CreateMissionRoutier(trajet, trailer, isFriend)
    shouldBreak = false
    if not isFriend then
        AddTenueRoutier()
        TriggerServerEvent("core:activities:update", PlayersId, "routier", {trajet = trajet, trailer = VehToNet(trailer), trailercoord = GetEntityCoords(trailer)})
    end
    OpenTutoFAInfo("Routier", "Allez récupérer votre remorque, un point GPS a été placé.")
    if not isFriend then
        blipRoutier = AddBlipForCoord(GetEntityCoords(trailer))
    else
        blipRoutier = AddBlipForCoord(isFriend)
    end
    while not IsVehicleAttachedToTrailer(GetVehiclePedIsIn(p:ped())) do Wait(1) end
    RemoveBlip(blipRoutier)
    Wait(100)
    blipRoutier = AddBlipForCoord(trajet.arrive)
    SetBlipColour(blipRoutier, 15)
    SetBlipRoute(blipRoutier, 1)
    OpenTutoFAInfo("Routier", "Allez livrer la cargaison, un point GPS a été placé.")
    CreateThread(function()
        Wait(60000)
        while true do 
            Wait(1)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), RoutierPos.DeleteService)
            if distance < 55.0 then 
                Bulle.create("rendreCamionPouettePouette", RoutierPos.DeleteService, "bulleRendreGrosCamion")
                DrawMarker(39, RoutierPos.DeleteService + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 
                    255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
            end
            if distance < 5.0 then 
                if IsControlJustPressed(0, 38) then 
                    if hasDeposerRemorque then
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            content = "Vous avez gagné " .. trajet.recompense .. "$"
                        })                
                        if p:getSubscription() == 1 then trajet.recompense = trajet.recompense*1.25 end 
                        if p:getSubscription() == 2 then trajet.recompense = trajet.recompense*2 end 
                        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", trajet.recompense, {})
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "Vous n'avez gagné"
                        })
                    end
                    TriggerServerEvent("core:activities:liveupdate", PlayersId, "routier", {recompense = 0})
                    TriggerServerEvent("core:activities:kickPlayers", PlayersId, "routier", true)
                    endRoutier()
                    break
                end
            end
        end
    end)
    while true do 
        Wait(10)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), trajet.arrive)
        if distance < 75.0 then 
            if blipRoutier ~= nil then
                if distance < 5.0 then 
                    Bulle.create("livrerRoutier", GetEntityCoords(GetVehiclePedIsIn(PlayerPedId())) + vector3(0.0, 0.0, 3.0), "bulleDeposerColis")
                end
                DrawMarker(39, trajet.arrive + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 
                    0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
            end
        end
        if distance < 5.0 then 
            if IsPedInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                local bool, trail = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId()))
                if bool then
                    if IsControlJustPressed(0, 38) then 
                        DeleteEntity(trail)
                        Bulle.hide("livrerRoutier")
                        Bulle.remove("livrerRoutier")
                        RemoveBlip(blipRoutier)
                        blipRoutier = nil
                        hasDeposerRemorque = true
                        OpenTutoFAInfo("Routier", "Retournez à l'entrepot, un point GPS a été placé.")
                        blipTravailRout = AddBlipForCoord(RoutierPos.DeleteService)
                        SetBlipColour(blipTravailRout, 15)
                        SetBlipRoute(blipTravailRout, 1)
                    end
                end
            end
        end
        if shouldBreak then 
            break
        end
    end
end

local function spawnVeh(Vehname)
    for k,v in pairs(RoutierPos.PosCamion) do 
        if vehicle.IsSpawnPointClear(v.xyz, 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(Vehname, v, {})
            GlobVeh = vehs
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            TaskWarpPedIntoVehicle(PlayerPedId(), vehs, -1)
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            createKeys(plate, model)
            break
            --local randomm = math.random(1, #RoutierPos.PossibleTrajets)
            --local tr = RoutierPos.PossibleTrajets[randomm].trailer
            --trailer = vehicle.create(RoutierPos.PossibleTrajets[randomm].trailer, vector4(-285.1208190918, 6035.7719726563, 30.507102966309, 43.359828948975) + vector4(0.0, 5.0, 0.0, 0.0), {})
            --AttachVehicleToTrailer(vehs, trailer, 8.0)
            --CreateMissionRoutier(RoutierPos.PossibleTrajets[randomm])
        end
    end
    for k,v in pairs(RoutierPos.trailers) do 
        if vehicle.IsSpawnPointClear(v.xyz, 3.0) then
            local randomm = math.random(1, #RoutierPos.PossibleTrajets)
            trailer = vehicle.create(RoutierPos.PossibleTrajets[randomm].trailer, v, {})
            CreateMissionRoutier(RoutierPos.PossibleTrajets[randomm], trailer)
            break
        end
    end
end

zone.addZone("routier_pos_prendre",
    RoutierPos.Ped.xyz + vector3(0.0, 0.0, 2.0),
    "Appuyer sur ~INPUT_CONTEXT~ pour récupérer ton camion",
    function()
        SendNUIMessage({
            type = "openWebview",
            name = "MenuJob",
            data = {
                headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10493763812109926601206613008126709760banniereroutier1.webp",
                choice = {
                    label = "Camions",
                    isOptional = false,
                    choices = {
                        {
                            id = 1,
                            label = 'Packer',
                            name = "packer",
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/packer.webp",
                        },
                        {
                            id = 2,
                            label = 'Hauler',
                            name = "hauler",
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/hauler.webp",
                        },
                        {
                            id = 3,
                            label = 'Phantom',
                            name = "phantom",
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/12015583804567184961203805358766825502image.webp",
                        },
                    },
                },
                participants = PlayersInJob,
                participantsNumber = 2,
                callbackName = "MetierRoutier",
            }
        })
    end, 
    false,
    27,
    0.5,
    { 255, 255, 255 },
    170,
    3.0,
    true,
    "bulleTravaillerGrosCamion"
)


RegisterNUICallback("MetierRoutier", function(data)
    print(json.encode(data, {indent = true}))
    if data and data.button == "start" then 
        if CheckJobLimit() then
            PlayersId = {}
            for k, v in pairs(PlayersInJob) do 
                table.insert(PlayersId, v.id)
            end
            TriggerServerEvent("core:activities:create", token, PlayersId, "routier")
            closeUI()
            spawnVeh(data.selected.name)
        end
    elseif data.button == "stop" then
        endRoutier()
        closeUI()
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "gopostal")
        for k,v in pairs(PlayersInJob) do 
            if v.id == playerSe then 
                table.remove(PlayersInJob, k)
            end
        end
        if PlayersId then 
            for k,v in pairs(PlayersId) do 
                if v == PlayersId then 
                    table.remove(PlayersId, k)
                end
            end
        end
        closeUI()
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then 
            closeUI()
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "routier")
        end
    end
end)

function AddTenueRoutier()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 26)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 57)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 11)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 252)
        SkinChangeFake("pants_2", 4)
        SkinChangeFake("shoes_1", 48)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 58)
        SkinChangeFake("helmet_2", 0)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 359)
        SkinChangeFake("torso_2", 2)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 0)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 1)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 58)
        SkinChangeFake("helmet_2", 2)
    end
end

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "routier" then 
        AddTenueRoutier()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "routier" then 
            print("receive data", json.encode(data, {indent = true}))
            CreateMissionRoutier(data.trajet, NetToVeh(data.trailer), data.trailercoord)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "routier" then 
        endRoutier()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)

function endRoutier()
    shouldBreak = true
    onMissionFinished()
    Bulle.hide("rendreCamionPouettePouette")
    Bulle.remove("rendreCamionPouettePouette")
    Bulle.hide("livrerRoutier")
    Bulle.remove("livrerRoutier")
    exports['tuto-fa']:HideStep()
    hasDeposerRemorque = false
    RemoveBlip(blipTravailRout)
    RemoveBlip(blipRoutier)
    if GlobVeh then 
        DeleteEntity(GlobVeh)
    end
    if trailer then 
        DeleteEntity(trailer)
    end
    if GetVehiclePedIsIn(PlayerPedId()) then
        DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
    end
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7Routier ^3loaded")
end)

