local tram = nil
local StationToGo = 1
local blip = nil
PlayersIdTaxiFarm = {}
local PlayersInJob = {}

local DLCMars = true

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local TaxiParams = {
    {
        VehicleSpawn = {
            vector4(911.5272, -163.7983, 74.3562, 198.6738),
            vector4(913.9636, -160.032, 74.7556, 200.2266),
            vector4(917.6412, -167.2584, 74.5841, 100.7624),
            vector4(915.8552, -170.6685, 74.3942, 95.2654),
            vector4(908.603, -183.1293, 74.2071, 61.7967),
            vector4(906.6928, -186.1627, 74.005, 54.1545),
            vector4(904.9775, -188.7189, 73.7999, 57.5776),
            vector4(903.019, -191.5337, 73.7914, 59.6044),
            vector4(897.8198, -183.9544, 73.7861, 243.9197),
            vector4(899.8725, -180.7313, 73.8597, 237.6166),
        },
        TaxiTake = vector3(902.6, -167.25, 74.07),
    }
}

CreateThread(function()
    while not p do Wait(1) end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    if p:getJob() == "taxi" then return end
    if not DLCMars then return end
    for k,v in pairs(TaxiParams) do 
        zone.addZone("taxi"..k, -- Nom
            v.TaxiTake.xyz + vector3(0.0, 0.0, 1.0),
            "~INPUT_PICKUP~ Prendre le tram",
            function()
                SendNUIMessage({
                    type = "openWebview", 
                    name = "MenuJob", 
                    data = {
                        headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_tram.webp",
                        choice = {
                            label = "Taxi",
                            isOptional = false,
                            choices = {
                                {
                                    id = 1,
                                    label = 'Stanier',
                                    name = 'staniertaxi',
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/staniertaxi.webp",
                                },
                                {
                                    id = 2,
                                    label = 'Merit',
                                    name = 'merittaxi',
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/merittaxi.webp",
                                },
                                {
                                    id = 3,
                                    label = 'Baller',
                                    name = 'ballertaxi',
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/Taxi/ballertaxi.webp",
                                },
                            },
                        },
                        participants = PlayersInJob,
                        participantsNumber = 2,
                        callbackName = "MetierTaxi",
                    }
                })
            end,
            false,
            27,
            1.5,
            { 255, 255, 255 },
            170,
            3.0,
            true,
            "bulleTravaillerTrain"
        )
    end
end)

RegisterNUICallback("MetierTaxi", function(data)
    if data and data.button == "start" then 
        PlayersIdTaxiFarm = {}
        for k, v in pairs(PlayersInJob) do 
            table.insert(PlayersIdTaxiFarm, v.id)
        end
        TriggerServerEvent("core:activities:create", token, PlayersIdTaxiFarm, "taxi")
        closeUI()
        if data.selected then 
            for k, v in pairs(TaxiParams[1].VehicleSpawn) do
                if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
                    if DoesEntityExist(vehs) then
                        TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                        --removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                        DeleteEntity(vehs)
                    end
                   -- vehs = vehicle.create(data.selected.name, v, {})
                    vehs = vehicle.create("taxi", v, {})
                    TaskWarpPedIntoVehicle(p:ped(), vehs, -1)
                    MissionPnjTaxi(true)
                    return
                end
            end
        end
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then 
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "taxi")
        end
    elseif data.button == "stop" then
        endTaxiFarm()
    end
end)

function endTaxiFarm(givemoney)
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    onMissionFinished()
    RemoveBlip(blip)
    TaskLeaveAnyVehicle(p:ped(), 1, 1)
    Wait(1000)
    StationToGo = 1
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    if givemoney then
        local winmin, winmax = 1000, 2000
        if GetVariable("job") and GetVariable("job").taxi then 
            winmin, winmax = GetVariable("job").taxi.winMin, GetVariable("job").taxi.winMax
        end 
        local amount = math.random(winmin, winmax)
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", amount, {})
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez gagné "..amount..'$'
        })
    end
end

function AddTenueTaxi()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 29)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 33)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 12)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 10)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 24)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("chain_1",26)
        SkinChangeFake("chain_2", 2)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 92)
        SkinChangeFake("torso_2", 2)
        SkinChangeFake("tshirt_1", 38)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 3)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 34)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 0)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("chain_1",22)
        SkinChangeFake("chain_2", 0)
    end
end

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "taxi" then 
        AddTenueTaxi()
    end
    PlayersIdTaxiFarm = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "taxi" then 
            if data.streetName and data.streetName2 and data.dist2 and data.dist then 
                exports['vNotif']:createNotification({
                    type = 'MISSIONTAXI',
                    title = 'Taxi',
                    content = "Demande taxi accepté", -- Raison (en haut à droite)
                    adress = data.streetName, -- Adresse
                    adress2 = data.streetName2, -- Adresse
                    duration = 10, -- Durée seconde
                    distance = math.ceil(data.dist2),
                    distancepnj = math.ceil(data.dist),
                })

            end
            if data.finish then 
                OpenTutoFAInfo("Taxi", "Vous avez fini votre service, retournez au taxis pour prendre votre paye")

            end
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "taxi" then 
        endTaxiFarm(true)
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)