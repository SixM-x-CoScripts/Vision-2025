local inWork = false
local blip = nil

local CoefMult = 8.5 -- Les staff devraient pouvoir modifié un jour inshAllah

local PlayersId = {}
local finished = false
local firstTime = true
local sentToFriends = false

local trashZone = {

    -- A GARDER EN COMMENTE !

    --[1] = {
    --    { pos = vector3(172.34837341309, 6649.4345703125, 31.879837036133), passed = false },
    --    { pos = vector3(30.497442245483, 6657.8481445313, 31.588813781738), passed = false },
    --    { pos = vector3(-11.143181800842, 6642.3979492188, 30.908910751343), passed = false },
    --    { pos = vector3(-28.118839263916, 6529.384765625, 31.965408325195), passed = false },
    --    { pos = vector3(-127.48989868164, 6230.849609375, 31.643989562988), passed = false },
    --    { pos = vector3(-23.074214935303, 6297.927734375, 31.641952514648), passed = false },
    --    { pos = vector3(11.895273208618, 6581.1557617188, 32.491321563721), passed = false },
    --    { pos = vector3(-137.67095947266, 6342.40234375, 31.80782699585), passed = false },
    --    { pos = vector3(-181.08407592773, 6315.6328125, 31.750469207764), passed = false },
    --    { pos = vector3(-300.45294189453, 6276.9858398438, 31.888610839844), passed = false },
    --    { pos = vector3(-348.65658569336, 6241.5405273438, 31.212715148926), passed = false },
    --    { pos = vector3(-398.11813354492, 6097.4970703125, 32.012577056885), passed = false },
    --},
    --[2] = {
    --    { pos = vector3(1964.3087158203, 3029.8845214844, 47.350574493408), passed = false },
    --    { pos = vector3(1699.7036132813, 3290.6931152344, 41.364295959473), passed = false },
    --    { pos = vector3(1681.2042236328, 3571.4997558594, 35.847324371338), passed = false },
    --    { pos = vector3(1429.2670898438, 3621.44921875, 35.431510925293), passed = false },
    --    { pos = vector3(1382.1325683594, 3616.2722167969, 35.016464233398), passed = false },
    --    { pos = vector3(984.05303955078, 3581.0534667969, 33.655792236328), passed = false },
    --    { pos = vector3(921.62493896484, 3652.3771972656, 32.868232727051), passed = false },
    --    { pos = vector3(1557.6700439453, 3804.8815917969, 34.589218139648), passed = false },
    --    { pos = vector3(1747.9792480469, 3708.4443359375, 34.443542480469), passed = false },
    --    { pos = vector3(1691.9538574219, 3750.4943847656, 34.498229980469), passed = false },
    --    { pos = vector3(1947.3436279297, 3831.5551757813, 32.392791748047), passed = false },
    --    { pos = vector3(1974.8746337891, 3787.873046875, 32.428707122803), passed = false },
    --    { pos = vector3(1968.3538818359, 3757.4379882813, 32.455661773682), passed = false },
    --    { pos = vector3(1903.1934814453, 3736.6789550781, 33.010932922363), passed = false },
    --    { pos = vector3(1401.3681640625, 3632.1708984375, 35.180561065674), passed = false },
    --},
    --[3] = {
    --    { pos = vector3(2454.9392089844, 4055.0900878906, 38.381031036377), passed = false },
    --    { pos = vector3(2521.8244628906, 4211.0478515625, 40.111881256104), passed = false },
    --    { pos = vector3(2570.0207519531, 4278.328125, 41.816825866699), passed = false },
    --    { pos = vector3(1947.7034912109, 4625.189453125, 40.911643981934), passed = false },
    --    { pos = vector3(1770.7005615234, 4587.9702148438, 38.111839294434), passed = false },
    --    { pos = vector3(1722.2160644531, 4631.9287109375, 43.058387756348), passed = false },
    --    { pos = vector3(1707.9484863281, 4671.6845703125, 42.874423980713), passed = false },
    --    { pos = vector3(1663.2781982422, 4771.0126953125, 41.793239593506), passed = false },
    --    { pos = vector3(1684.9521484375, 4814.255859375, 41.904003143311), passed = false },
    --    { pos = vector3(1678.2521972656, 4868.126953125, 41.838199615479), passed = false },
    --    { pos = vector3(1683.0125732422, 4914.873046875, 42.336288452148), passed = false },
    --    { pos = vector3(1685.3432617188, 4972.5654296875, 42.89705657959), passed = false },
    --    { pos = vector3(1659.2779541016, 4867.634765625, 41.865169525146), passed = false },
    --    { pos = vector3(1659.1326904297, 4830.8916015625, 41.868106842041), passed = false },
    --    { pos = vector3(1663.4890136719, 4770.9331054688, 41.853790283203), passed = false },
    --},
    [1] = {
        { pos = vector3(-234.63885498047, -1299.8404541016, 31.675804138184), passed = false },
        { pos = vector3(-87.033103942871, -1298.0638427734, 29.600378036499), passed = false },
        { pos = vector3(2.0231773853302, -1387.1494140625, 29.486749649048), passed = false },
        { pos = vector3(104.55025482178, -1317.1765136719, 29.475326538086), passed = false },
        { pos = vector3(95.692733764648, -1438.9204101563, 29.49810218811), passed = false },
        { pos = vector3(-9.7130212783813, -1565.029296875, 29.611518859863), passed = false },
        { pos = vector3(-133.39237976074, -1706.4349365234, 29.827779769897), passed = false },
        { pos = vector3(29.704376220703, -1887.0102539063, 22.180467605591), passed = false },
    },
    [2] = {
        { pos = vector3(1190.0150146484, -1686.9114990234, 36.140911102295), passed = false },
        { pos = vector3(1256.8232421875, -1653.6990966797, 47.019519805908), passed = false },
        { pos = vector3(1315.2828369141, -1656.9796142578, 51.489139556885), passed = false },
        { pos = vector3(1321.6646728516, -1559.1497802734, 51.337177276611), passed = false },
        { pos = vector3(1165.3924560547, -1453.9461669922, 34.669792175293), passed = false },
        { pos = vector3(962.54833984375, -1466.3997802734, 31.570350646973), passed = false },
        { pos = vector3(1220.607421875, -1381.0732421875, 35.629718780518), passed = false },
    },
    [3] = {
        { pos = vector3(-1135.3236083984, -921.68133544922, 3.019923210144), passed = false },
        { pos = vector3(-835.77209472656, -1066.4996337891, 11.48885345459), passed = false },
        { pos = vector3(-716.70703125, -1170.4384765625, 10.90978717804), passed = false },
        { pos = vector3(-541.2568359375, -1220.1040039063, 18.802732467651), passed = false },
        { pos = vector3(-671.537109375, -949.70129394531, 21.683763504028), passed = false },
        { pos = vector3(-569.22973632813, -857.91693115234, 26.665874481201), passed = false },
        { pos = vector3(-561.81512451172, -820.76129150391, 27.653432846069), passed = false },
        { pos = vector3(-518.36920166016, -869.75830078125, 29.601858139038), passed = false },
    },
    [4] = {
        { pos = vector3(523.01959228516, -162.42082214355, 56.143707275391), passed = false },
        { pos = vector3(456.39312744141, -70.244125366211, 73.873107910156), passed = false },
        { pos = vector3(863.84985351563, 18.435997009277, 78.916557312012), passed = false },
        { pos = vector3(879.708984375, -238.67877197266, 69.190773010254),  passed = false },
        { pos = vector3(-120.60227203369, 216.48986816406, 94.720336914063), passed = false },
        { pos = vector3(-211.67051696777, 132.43635559082, 69.693229675293), passed = false },
        { pos = vector3(331.88000488281, -284.37609863281, 53.484973907471), passed = false },
        { pos = vector3(70.919136047363, -209.74983215332, 54.817722320557), passed = false },
    },
    [5] = {
        { pos = vector3(-289.67971801758, -98.096817016602, 47.237236022949), passed = false },
        { pos = vector3(-378.64056396484, 21.728527069092, 47.447818756104), passed = false },
        { pos = vector3(-548.14263916016, 286.75479125977, 82.874565124512), passed = false },
        { pos = vector3(-519.61047363281, 270.45895385742, 83.039772033691), passed = false },
        { pos = vector3(-215.95867919922, 277.25402832031, 91.951118469238), passed = false },
        { pos = vector3(-183.42524719238, 244.66526794434, 92.570747375488), passed = false },
        { pos = vector3(87.364402770996, 311.05889892578, 110.45986175537), passed = false },
    },
    [6] = {
        { pos = vector3(-947.16607666016, -1078.1270751953, 2.2243113517761), passed = false },
        { pos = vector3(-1018.7421264648, -1119.5313720703, 2.2461082935333), passed = false },
        { pos = vector3(-1130.1467285156, -1181.3477783203, 2.6209766864777), passed = false },
        { pos = vector3(-1276.6134033203, -1210.7065429688, 4.8891973495483), passed = false },
        { pos = vector3(-1328.7165527344, -1025.3317871094, 7.9693737030029), passed = false },
        { pos = vector3(-1235.6887207031, -908.59405517578, 11.687321662903), passed = false },
        { pos = vector3(-1194.5017089844, -718.57379150391, 21.821144104004), passed = false },
    },
    [7] = {
        { pos = vector3(1230.7376708984, -1235.7100830078, 36.026237487793), passed = false },
        { pos = vector3(1147.6153564453, -1012.5845336914, 45.080978393555), passed = false },
        { pos = vector3(1099.2238769531, -776.22961425781, 58.714344024658), passed = false },
        { pos = vector3(1263.2386474609, -718.58172607422, 64.29296875), passed = false },
        { pos = vector3(1270.3553466797, -481.53259277344, 69.130165100098), passed = false },
        { pos = vector3(1249.625, -350.44067382813, 69.299629211426), passed = false },
        { pos = vector3(1167.2164306641, -317.68374633789, 69.656539916992), passed = false },
        { pos = vector3(1067.0684814453, -449.34143066406, 65.110366821289), passed = false },
    },
    [8] = {
        { pos = vector3(223.6349029541, -1837.2967529297, 27.185131072998), passed = false },
        { pos = vector3(414.01162719727, -2014.1138916016, 23.701072692871), passed = false },
        { pos = vector3(397.22088623047, -1924.9301757813, 25.016286849976), passed = false },
        { pos = vector3(505.14993286133, -1786.0355224609, 28.062271118164), passed = false },
        { pos = vector3(271.49270629883, -1502.5026855469, 29.663564682007), passed = false },
        { pos = vector3(165.86566162109, -1346.6229248047, 29.782432556152), passed = false },
        { pos = vector3(305.31109619141, -1290.8637695313, 30.989133834839), passed = false },
    }
}
local savedPos = {}
local startPos = vector3(-425.53598022461, -1689.9555664063, 19.744178771973)
local workObj = nil
local veh = nil
local recup = false
local inCamion = false
local numberOfAction = 0
local totalPrice = 0
local token = nil
local PoubelleCamion = nil
local IdToSelec = 1

local PlayersInJob = {}

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local function IsPlayerInCamion()
    if GetEntityModel(p:currentVeh()) == GetHashKey("trash2") then
        return true
    else
        return false
    end
end

local pointCounted = 0
local donePoints = {}
function GetPoint()
    pointCounted += 1
    for i = 1, #trashZone[IdToSelec] do
        savedPos[i] = trashZone[IdToSelec][i]
    end
    print("pointCounted, #savedPos", pointCounted, #savedPos)
    if tonumber(pointCounted) == tonumber(#savedPos) then 
        finished = true
    else
        finished = false
    end
    if not finished then
        print("savedPos", savedPos, next(savedPos))
        if next(savedPos) then
            local random = math.random(1, #savedPos)
            while donePoints[random] == true do 
                random = math.random(1, #savedPos)
            end
            donePoints[random] = true
            local point = savedPos[random]
            if point.passed then
                return false
            else
                return random, point
            end
            return false
        end
    end
    print("FINI JE RENVOI FINi")
    return false, nil, true
end

function StopJobCourse()
    pointCounted = 0
    if workObj then
        workObj:delete()
    end
    savedPos = {}
    RemoveBlip(blip)
    if veh then
        TriggerEvent('persistent-vehicles/forget-vehicle', veh)
        removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
        DeleteEntity(veh)
    end
    blip = nil
    Bulle.remove("ramasserPoubelle")
    Bulle.remove("rendreCamion")
    exports['tuto-fa']:HideStep()
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    workObj = nil
    TriggerSecurEvent('core:eboueurEndDuty', totalPrice*CoefMult) --TODO: edit this
    totalPrice = 0
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
end

function AddTenueEboueur()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 146)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 63)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 36)
        SkinChangeFake("pants_2",0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 5)
        SkinChangeFake("helmet_2", 0)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 117)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 14)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 81)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 35)
        SkinChangeFake("pants_2",0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 5)
        SkinChangeFake("helmet_2", 0)
    end
end 

local NewVe = nil 
local NewKey = nil 
local NeedNewPoint = false
RegisterNetEvent("core:activities:liveupdate", function(typejob, data, src)
    print("core:activities:liveupdate", typejob, json.encode(data))
    if tonumber(src) ~= tonumber(GetPlayerServerId(PlayerId())) and not data.firstTime then 
        RemoveBlip(blip)
        print("src ~= GetPlayerServerId(PlayerId())", src ~= GetPlayerServerId(PlayerId()))
        exports['tuto-fa']:HideStep()
        Bulle.hide("ramasserPoubelle")
        Bulle.remove("ramasserPoubelle")
        Bulle.hide("poubelleCamion")
        Bulle.remove("poubelleCamion")
        workObj = nil
        SetVehicleDoorShut(veh, 5, false)
        inCamion = true
        recup = false
        sentToFriends = false
        totalPrice = totalPrice + math.random(25, 35)
        numberOfAction = numberOfAction + 1
    end
    Wait(200)
    if typejob == "eboueur" then 
        if data.ve then 
            NewVe = data.ve
        end
        if data.idselec then 
            IdToSelec = data.idselec
        end
        if data.key then 
            NewKey = data.key
        end
        if data.finished then 
            if tonumber(src) ~= tonumber(GetPlayerServerId(PlayerId())) then
                if blip then RemoveBlip(blip) end
                finished = true
            end
        end
        if data.removeTout then 
            exports['tuto-fa']:HideStep()
            if blip then RemoveBlip(blip) end
            Bulle.hide("rendreCamion")
            Bulle.remove("rendreCamion")
        end
        NeedNewPoint = true
        if NewVe then
            if blip then RemoveBlip(blip)  print("removeblip") end
            Wait(250)
            blip = AddBlipForCoord(NewVe.pos)
            SetBlipRoute(blip, true)
        end
        print("updated", NewVe, NewKey)
    end
end)


function TakeEboueurService(asFriend, defaultVal)
    finished = false
    print("TakeEboueurService(asFriend)", asFriend, json.encode(defaultVal))
    local alrdyTakeService = TriggerServerCallback("core:getIfAlrdyTakeService", token)
    inWork = true
    TriggerServerEvent('core:eboueurStartDuty', token)
    if not asFriend then
        IdToSelec = math.random(1, #trashZone)
        local outPos = vector4(-425.53598022461, -1689.9555664063, 18.744178771973, 158.12982177734)
        veh = vehicle.create("trash2", outPos, {})
        closeUI()
        local plate = vehicle.getProps(veh).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, veh, VehToNet(veh), p:getJob())
        createKeys(plate, model)
        TriggerServerEvent("core:activities:create", token, PlayersId, "eboueur")
        TaskWarpPedIntoVehicle(p:ped(), veh, -1)
    end
    AddTenueEboueur()
    print("go")
    if not asFriend then
        TriggerServerEvent("core:activities:update", PlayersId, "eboueur", {camion = NetworkGetNetworkIdFromEntity(veh)})
    end
    -- create a deepcopy of trashzone in savedpos
    if asFriend then
        if not asFriend.camion then
            OpenTutoFAInfo("Eboueur", "Montez dans le camion pour commencer votre tournée")
        else
            TaskWarpPedIntoVehicle(p:ped(), NetworkGetEntityFromNetworkId(asFriend.camion), 0)
        end
    end
    print("go2")
    while not IsPedInAnyVehicle(PlayerPedId()) do Wait(1) end
    if asFriend then
        veh = GetVehiclePedIsIn(p:ped())
    end
    Wait(500)
    local shouldhide = true
    OpenTutoFAInfo("Eboueur", "Suivez les points sur le GPS pour ramasser les poubelles")
    sentToFriends = false
    firstTime = true
    local oldPos = nil
    if not asFriend then
        TriggerServerEvent("core:activities:liveupdate", PlayersId, "eboueur", {idselec = IdToSelec, ve = defaultVal.v, key = defaultVal.key, firstTime = firstTime, camion = NetworkGetNetworkIdFromEntity(veh)})
    end
    local key, v = nil, nil
    if not asFriend then
        key, v = defaultVal.key, defaultVal.v
    else
        NeedNewPoint = false
        key, v = NewKey, NewVe
    end
    zone.removeBulle("eboueur_job")
    Citizen.CreateThread(function()
        while inWork do
            Wait(300)
            --if NeedNewPoint then
            --    print("NeedNewPoint", NeedNewPoint)
            --    NeedNewPoint = false
            --    if not asFriend then
            --        key, v = GetPoint()
            --        NewKey, NewVe = key, v
            --    else
            --        print("friend", NewKey, NewVe)
            --        key, v = NewKey, NewVe
            --    end
            --    if key ~= false and numberOfAction < 100 and v then
            --        --blip = AddBlipForCoord(v.pos)
            --        --SetBlipRoute(blip, true)
            --        if not sentToFriends then 
            --            sentToFriends = true
            --            print("senttttt")
            --            TriggerServerEvent("core:activities:liveupdate", PlayersId, "eboueur", {ve = v, key = key, firstTime = firstTime})
            --            firstTime = false
            --        end
            --    end
            --end
            --print("inWork", key, numberOfAction, v)

            while not NewVe do Wait(1) end 
            recup = false
            inCamion = false
            --print("key, numberOfAction, v", key, numberOfAction, v, NewVe.pos)
            if not finished and key ~= false and numberOfAction < 100 and v then

                if not inWork then
                    print("stop job course inwork")
                    StopJobCourse()
                    break
                end

                while #(p:pos() - NewVe.pos) <= 10.0 and inWork and IsPlayerInCamion() do
                    --print("#(p:pos() - v.pos) <= 10.0 and inWork and IsPlayerInCamion()")
                    Wait(1)
                    shouldhide = true
                    OpenTutoFAInfo("Eboueur", "Descendez du camion pour aller récupérer la poubelle")
                    break
                end

                -- Récupération de la poubelle
                while #(p:pos() - NewVe.pos) < 100 and inWork and not recup do
                    --print("#(p:pos() - v.pos) < 100 and inWork and not recup")
                    Wait(1)
                    if recup then 
                        break
                    end
                    if shouldhide then
                        exports['tuto-fa']:HideStep()
                        OpenTutoFAInfo("Eboueur", "Récupérez la poubelle puis mettez-la a l'arrière du camion")
                        shouldhide = false
                    end
                    --Visual.Subtitle("Récupérez la poubelle puis mettez-la a l'arrière du camion", 60)
                    Bulle.create("ramasserPoubelle", NewVe.pos, "bulleRamasserPoubelle", true)
                    --DrawMarker(20, v.pos, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 9, 151, 227, 255, 0, 0, 0, 0)
                    if #(p:pos() - NewVe.pos) < 3.5 then
                        --ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer la poubelle")
                        if IsControlJustPressed(0, 38) then
                            RemoveBlip(blip)
                            Wait(250)
                            Bulle.hide("ramasserPoubelle")
                            Bulle.remove("ramasserPoubelle")
                            TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
                            blip = AddBlipForCoord(GetEntityBoneIndexByName(veh, "platelight"))
                            recup = true
                            if GetClosestObjectOfType(GetEntityCoords(p:ped()), 5.0, -1096777189, 1) ~= 0 or GetClosestObjectOfType(GetEntityCoords(p:ped()), 5.0, -1096777189) ~= 0 then 
                                ExecuteCommand("e gbin4")
                                print("1")
                            elseif GetClosestObjectOfType(GetEntityCoords(p:ped()), 5.0, -1426008804, 1) ~= 0 or GetClosestObjectOfType(GetEntityCoords(p:ped()), 5.0, -1426008804) ~= 0 then 
                                ExecuteCommand("e gbin5")
                                print("2")
                            elseif GetClosestObjectOfType(GetEntityCoords(p:ped()), 5.0, -1681329307, 1) ~= 0 or GetClosestObjectOfType(GetEntityCoords(p:ped()), 5.0, -1681329307) ~= 0 then 
                                print("3")
                                p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                                Wait(1000)
                                ClearPedTasks(p:ped())
                                local prop = "hei_prop_heist_binbag"
                                local offset = { 0.049, 0.034, -0.025, 0, -100.4, 0.0 }
                                local obj = entity:CreateObject(prop, p:pos())
                                AttachEntityToEntity(obj:getEntityId(), p:ped(),
                                    GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), offset[1], offset[2],
                                    offset[3], offset[4], offset[5], offset[6], false, false,
                                    false, false, 0.0, true)
                                p:PlayAnim("anim@heists@narcotics@trash", "walk", 49)
                                workObj = obj
                            else
                                print("4")
                                p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                                Wait(1000)
                                ClearPedTasks(p:ped())
                                local prop = "hei_prop_heist_binbag"
                                local offset = { 0.049, 0.034, -0.025, 0, -100.4, 0.0 }
                                local obj = entity:CreateObject(prop, p:pos())
                                AttachEntityToEntity(obj:getEntityId(), p:ped(),
                                    GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), offset[1], offset[2],
                                    offset[3], offset[4], offset[5], offset[6], false, false,
                                    false, false, 0.0, true)
                                p:PlayAnim("anim@heists@narcotics@trash", "walk", 49)
                                workObj = obj
                            end
                            print("5")
                        end
                    end
                end

                -- Mettre poubelle dans le camion
                while inWork and recup and not inCamion do
                    --print("inWork and recup and not inCamion")
                    Bulle.create("poubelleCamion", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) + vector3(0.0, 0.0, 0.5), "bulleDeposerPoubelle", true)
                    if #(p:pos() - GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) +
                            vector3(0.0, 0.0, 0.5)) < 3.0 then
                        --ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour mettre la poubelle dans le camion")
                        if IsControlJustPressed(0, 38) then
                            SetVehicleDoorOpen(veh, 5, false, false)
                            Bulle.hide("poubelleCamion")
                            Bulle.remove("poubelleCamion")
                            RemoveBlip(blip)
                            if IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then 
                                p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                                PoubelleCamion = entity:CreateObject(-1096777189, p:pos())
                                AttachEntityToEntity(PoubelleCamion:getEntityId(), veh,
                                    GetEntityBoneIndexByName(veh, "platelight"), 0.0, 0.0,
                                    0.0, 0.0, 0.0, 0.0, false, false,
                                    false, false, 0.0, true)
                                Wait(500)
                                StopAnimTask(p:ped(), "anim@heists@narcotics@trash", "throw_b", 1.0)
                                local X = 0.0
                                local Y = 0.0
                                local Z = 0.0
                                local OZ = 0.0
                                ExecuteCommand("e c")
                                while true do 
                                    Wait(50)
                                    X -= 1.0
                                    OZ += 0.005
                                    AttachEntityToEntity(PoubelleCamion:getEntityId(), veh,
                                        GetEntityBoneIndexByName(veh, "platelight"), 0.0, 0.0, OZ,
                                        X, Y, Z, false, false,
                                        false, false, 0.0, true)
                                    if X <= -75 then 
                                        break
                                    end
                                    --[[if IsControlJustPressed(0, 172) then
                                        X += 0.1
                                        AttachEntityToEntity(PoubelleCamion:getEntityId(), veh,
                                            GetEntityBoneIndexByName(veh, "platelight"), 0.0, 0.0, 0.0,
                                            X, Y, Z, false, false,
                                            false, false, 0.0, true)
                                        print(X,Y,Z)
                                    end
                                    if IsControlJustPressed(0, 173) then
                                        X -= 0.1
                                        AttachEntityToEntity(PoubelleCamion:getEntityId(), veh,
                                            GetEntityBoneIndexByName(veh, "platelight"), 0.0, 0.0, 0.0,
                                            X, Y, Z, false, false,
                                            false, false, 0.0, true)
                                        print(X,Y,Z)
                                    end
                                    if IsControlJustPressed(0, 175) then
                                        Z += 0.1
                                        AttachEntityToEntity(PoubelleCamion:getEntityId(), veh,
                                            GetEntityBoneIndexByName(veh, "platelight"), 0.0, 0.0, 0.0,
                                            X, Y, Z, false, false,
                                            false, false, 0.0, true)
                                        print(X,Y,Z)
                                    end
                                    if IsControlJustPressed(0, 174) then
                                        Z -= 0.1
                                        AttachEntityToEntity(PoubelleCamion:getEntityId(), veh,
                                            GetEntityBoneIndexByName(veh, "platelight"), 0.0, 0.0, 0.0,
                                            X, Y, Z, false, false,
                                            false, false, 0.0, true)
                                        print(X,Y,Z)
                                    end]]
                                end
                            else
                                p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                            end
                            exports['tuto-fa']:HideStep()
                            Wait(500)
                            if PoubelleCamion then
                                TriggerServerEvent("DeleteEntity", token, { VehToNet(PoubelleCamion:getEntityId()) })
                            end
                            if workObj then
                                TriggerServerEvent("DeleteEntity", token, { VehToNet(workObj:getEntityId()) })
                            end
                            Wait(500)
                            ExecuteCommand("e c")
                            workObj = nil
                            ClearPedTasks(p:ped())
                            OpenTutoFAInfo("Eboueur", "Retournez dans le camion pour avoir le prochain point")
                            SetVehicleDoorShut(veh, 5, false)
                            inCamion = true
                            recup = false
                            sentToFriends = false
                            totalPrice = totalPrice + math.random(25, 35)
                            numberOfAction = numberOfAction + 1
                            CreateThread(function()
                                while true do 
                                    Wait(500)
                                    if IsPedInAnyVehicle(p:ped()) then 
                                        local key, vee, finsihed = GetPoint()
                                        if finsihed then 
                                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "eboueur", {ve = vee, key = key, finished = true})
                                        else
                                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "eboueur", {ve = vee, key = key})
                                        end
                                        exports['tuto-fa']:HideStep()
                                        break
                                    end
                                end
                            end)
                        end
                    end
                    Wait(1)
                end

                while inWork and inCamion and not IsPedInVehicle(p:ped(), veh) do
                    if not asFriend then
                        table.remove(savedPos, key)
                    end
                    --RemoveBlip(blip)
                    --blip = nil
                    Wait(50)
                end
            else
                RemoveBlip(blip)
                Wait(500)
                RemoveBlip(blip)
                Wait(500)
                blip = AddBlipForCoord(startPos)
                SetBlipRoute(blip, true)
                SetBlipRouteColour(blip, 2)
                SetBlipColour(blip, 2)

                while #(p:pos() - startPos) > 5.0 and IsPlayerInCamion() do
                    Wait(1)
                    if not hasShownEnd then
                        hasShownEnd = true
                        OpenTutoFAInfo("Eboueur", "Service terminé, retournez à l'entreprise pour rendre votre camion")
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "eboueur", {finished = true})
                    end
                end

                while #(p:pos() - startPos) <= 50.0 do
                    DrawMarker(39, startPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 
                        0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                    if #(p:pos() - startPos) <= 5.0 then
                        if IsPlayerInCamion() then
                            Bulle.create("rendreCamion", startPos, "bulleRendreCamion", true)
                            if IsControlJustPressed(0, 38) then
                                exports['tuto-fa']:HideStep()
                                RemoveBlip(blip)
                                -- ShowNotification("la caution de 100$ vous a été rendue.")
                                Bulle.hide("rendreCamion")
                                Bulle.remove("rendreCamion")
                                hasShownEnd = false
                                TriggerServerEvent("core:activities:kickPlayers", PlayersId, "eboueur")
                                TriggerServerEvent("core:activities:liveupdate", PlayersId, "eboueur", {removeTout = true})
                                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                                DeleteEntity(veh)
                                veh = nil
                                onMissionFinished()
                                zone.showBulle("eboueur_job")
                                StopJobCourse()
                                inWork = false
                            end
                        end
                    end
                    Wait(1)
                end
            end
        end
    end)
end

function StopJobEboueur()
    local alrdyTakeService = TriggerServerCallback("core:getIfAlrdyTakeService", token)
    donePoints = {}
    if blip then RemoveBlip(blip) end
    if alrdyTakeService and inWork then
        onMissionFinished()
        zone.showBulle("eboueur_job")
        StopJobCourse()
        inWork = false
    else
        if workObj then
            workObj:delete()
        end
        savedPos = {}
        if veh then
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
            DeleteEntity(veh)
        end
        blip = nil
        exports['tuto-fa']:HideStep()
        local playerSkin = p:skin()
        ApplySkin(playerSkin)
        workObj = nil
    end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    totalPrice = 0
end

Citizen.CreateThread(function()
    while zone == nil do Wait(100) end
    while not p do Wait(100) end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }

    zone.addZone(
        "eboueur_job", -- Nom
        vector3(-428.890625, -1728.0677490234, 20.783836364746), -- Position
        "~INPUT_CONTEXT~ Prendre/arrêter le service", -- Text afficher
        function() -- Action qui seras fait
            --TakeEboueurService()
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10493763812109926601206612750017761331eboueur1.webp",
                    choice = {
                        label = "Camions",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'Camion poubelle',
                                name = 'trash2',
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10493763812109926601206613722811076608imageremovebgpreview512.webp",
                            },
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 4,
                    callbackName = "MetierEboueur",
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
        "bulleTravaillerCamion"
    )
    local ped = entity:CreatePedLocal("s_m_y_garbage", vector3(-428.890625, -1728.0677490234, 18.783836364746), 71.37141418457)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
end)

RegisterNUICallback("MetierEboueur", function(data)
    if data and data.button == "start" then 
        if CheckJobLimit() then
            if not inWork then
                PlayersId = {}
                for k, v in pairs(PlayersInJob) do 
                    table.insert(PlayersId, v.id)
                end
                TriggerServerEvent("core:activities:create", token, PlayersId, "eboueur")
                local kcaca,vite = GetPoint()
                TakeEboueurService(nil, {key = kcaca, v = vite})
            else
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous êtes déjà en mission !"
                })
            end
        end
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "eboueur")
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
    elseif data.button == "stop" then
        StopJobEboueur()
    elseif data.button == "addPlayer" then
        closeUI()
        ActivityAskPlayer(3.0, "eboueur")
    end
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7eboueur ^3loaded")
end)

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "eboueur" then 
        AddTenueEboueur()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    print("core:activities:update", typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "eboueur" then 
            print("GOO")
            TakeEboueurService(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "eboueur" then 
        StopJobEboueur()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)