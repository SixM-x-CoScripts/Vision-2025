local train
local hidemarker = false
local shouldDecharge = true
local PlayersId = {}
local PlayersInJob = {}

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local DLCMars = true

CreateThread(function()
    while not p do Wait(1) end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    if not DLCMars then return end
    local ped = entity:CreatePedLocal("a_m_y_business_01", vector3(-139.5951385498, 6146.96875, 31.436786651611), 218.27481079102)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 1, 1)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    zone.addZone("train", -- Nom
        vector3(-139.5951385498, 6146.96875, 33.436786651611),
        "~INPUT_PICKUP~ Prendre le train",
        function()
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_train.webp",
                    choice = {
                        label = "Trains",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'Train de fret',
                                name = 'train',
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/train.webp",
                            },
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 1,
                    callbackName = "MetierTrain",
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
end)

RegisterNUICallback("MetierTrain", function(data)
    if data and data.button == "start" then 
        if p:getSubscription() == 0 then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous devez avoir le premium pour pouvoir faire ce job !"
            })
        else
            --if CheckJobLimit() then
                PlayersId = {}
                for k, v in pairs(PlayersInJob) do 
                    table.insert(PlayersId, v.id)
                end
                TriggerServerEvent("core:activities:create", token, PlayersId, "train")
                closeUI()
                CreateTrain()
            --end
        end
    elseif data.button == "addPlayer" then
        --if data.selected ~= 0 then 
        --    local closestPlayer = ChoicePlayersInZone(5.0)
        --    if closestPlayer == nil then
        --        return
        --    end
        --    if closestPlayer == PlayerId() then return end
        --    local sID = GetPlayerServerId(closestPlayer)
        --    TriggerServerEvent("core:activities:askJob", sID, "train", true)
        --end
    elseif data.button == "stop" then
        DeleteMissionTrain(train)
        local playerSkin = p:skin()
        ApplySkin(playerSkin)
    end
end)

function loadTrainModels()
    local trainsAndCarriages = {
        'freight', 'metrotrain', 'freightcont1', 'freightcar', 
        'freightcar2', 'freightcont2', 'tankercar', 'freightgrain'
    }

    for _, vehicleName in ipairs(trainsAndCarriages) do
        local modelHashKey = GetHashKey(vehicleName)
        RequestModel(modelHashKey) -- load the model
        -- wait for the model to load
        while not HasModelLoaded(modelHashKey) do
            Citizen.Wait(0)
        end
    end
end

local InsideZoneSlow = false
local SlowZones = {
    vector3(-327.18380737305, 5948.3193359375, 40.573261260986),
    vector3(1790.8619384766, 3498.400390625, 37.758052825928),
    vector3(2172.7763671875, 3717.8544921875, 37.492031097412),
    vector3(158.78112792969, -2100.6513671875, 15.523509979248),
    vector3(188.17074584961, -1962.8299560547, 18.735847473145),
    vector3(246.34248352051, -1894.3791503906, 25.009220123291),
    vector3(337.14743041992, -1786.1184082031, 27.627416610718),
    vector3(432.37048339844, -1672.3115234375, 28.195081710815),
    vector3(2610.8278808594, 1750.52734375, 25.405025482178),
    vector3(3026.0993652344, 4284.73828125, 59.74813079834),
    vector3(218.11433410645, -2164.4768066406, 13.230734825134),
}
function CreateTrain(isFriend)
    TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
    if not isFriend then
        loadModel('freight')
        loadModel('freightcar')
        loadModel('tr_prop_tr_container_01a')
        loadModel('prop_ld_container')
        loadModel('tr_prop_tr_lock_01a')
        loadModel('xm_prop_lab_desk_02')
        loadTrainModels()
        Wait(200)
        train = CreateMissionTrain(24, -139.67497253418, 6142.466796875, 30.577228546143, true, true, true)
        while not DoesEntityExist(train) do Wait(1) end
        TaskWarpPedIntoVehicle(p:ped(), train, -1)
        TriggerServerEvent("core:activities:update", PlayersId, "train", {gtrain = VehToNet(train)})
    end
    if isFriend then 
        train = NetToVeh(isFriend.gtrain)
        TaskWarpPedIntoVehicle(p:ped(), train, 0)
    end
    OpenTutoFAInfo("Conducteur de train", "Conduit le train, jusqu'a son prochain arrêt")
    CreateThread(function()
        while DoesEntityExist(train) do
            Wait(250)
            for k,v in pairs(SlowZones) do 
                if GetDistanceBetweenCoords(GetEntityCoords(train), v) < 80.0 then 
                    SetTrainCruiseSpeed(train, 25.0)
                    Wait(5000)
                    SetTrainCruiseSpeed(train, 80.0)
                end
            end
        end
    end)
    local perm = p:getPermission()
    while DoesEntityExist(train) do 
        Wait(1)
        if DoesEntityExist(train) then
            if IsPedInVehicle(PlayerPedId(), train, false) then
                if IsControlPressed(0, 32) then -- "Z"
                    SetTrainCruiseSpeed(train, 80.0)
                end
                if IsControlPressed(0, 33) then -- "S" 
                    if perm > 0 then
                        SetTrainCruiseSpeed(train, 0.0)
                    else
                        SetTrainCruiseSpeed(train, 15.0)
                    end
                end
            end

            if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(train)) < 6.0 then 
                if IsControlJustPressed(0, 75) then 
                    TaskWarpPedIntoVehicle(p:ped(), train, -1)
                end
            end
        end

        if not hidemarker then 
            DrawMarker(43, 669.18304443359, -978.31384277344, 21.49976348877, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 
                51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
        end

        -- DECHARGE
        if shouldDecharge and GetDistanceBetweenCoords(vector3(669.18304443359, -978.31384277344, 21.49976348877), GetEntityCoords(p:ped())) < 4.0 then 
            hidemarker = true
            shouldDecharge = false
        end

        -- FINISH
        if GetDistanceBetweenCoords(vector3(-186.20272827148, 6095.8564453125, 30.651691436768), GetEntityCoords(p:ped())) < 4.0 then 
            hidemarker = false
            shouldDecharge = true
            endMissionTrain()
        end

        if IsControlJustPressed(0, 178) then 
            local confirmation = ChoiceInput("Voulez vous arreter l'activité ?")
            if confirmation == true then
                endMissionTrain()
            end
        end
    end
    hidemarker = false
    shouldDecharge = true
end

function endMissionTrain(shouldnotwin)
    onMissionFinished()
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    SetEntityCoords(p:ped(), -140.67037963867, 6145.5571289062, 31.438667297363)
    SetTrainCruiseSpeed(train, 0.0)
    DeleteMissionTrain(train)
    exports['tuto-fa']:HideStep()
    if not shouldnotwin then
        local winmin, winmax = 125, 190
        local varWinMin, varWinMax = getWinRange("train", 125, 190)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local price = math.random(winmin, winmax)
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez gagné "..price..'$'
        })
    end
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
end

function AddTenueTrain()
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
        SkinChangeFake("helmet_1", 113)
        SkinChangeFake("helmet_2", 0)
        SkinChangeFake("chain_1",26)
        SkinChangeFake("chain_2", 5)
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
        SkinChangeFake("helmet_1", 112)
        SkinChangeFake("helmet_2", 0)
        SkinChangeFake("chain_1",22)
        SkinChangeFake("chain_2", 10)
    end
end

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "train" then 
        AddTenueTrain()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "train" then 
            CreateTrain(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "train" then 
        endMissionTrain()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)