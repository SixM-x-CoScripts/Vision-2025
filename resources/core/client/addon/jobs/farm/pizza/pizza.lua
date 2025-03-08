local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local MaximumPizza = 3

local PedsPizza = {
    "a_m_y_eastsa_02",
    "a_m_y_eastsa_01",
}

local pos = {}
local PlayersId = {}
local HasLettersInHand = false
local idToGo = 1
local ShouldReloadZone = false
local PlayersInJob = {}
local HasPizza = false
local finished
local blippos = nil
local advance = 0
local addpos = vector3(0.0, 0.0, 0.0)
local blipBoites
local delivered = 0
local FriendHasTakenColis
local veh
pedPizza = {}
local playerpos = nil
local near = false
local price = 0
local stoped = false
local recupedPizza = 0
local pizzaSold = 0
local objLettre = nil

PositionsPizza = {
    spawnPlaces = {
        vector4(291.44760131836, -957.63201904297, 28.262222290039, 265.25387573242),
        vector4(295.2346496582, -957.79522705078, 28.262594223022, 266.57232666016),
        vector4(298.734375, -957.90087890625, 28.262474060059, 268.37274169922),
        vector4(289.69674682617, -957.591796875, 28.262413024902, 266.74206542969),
    },
    deleteVehicule = vector3(294.27947998047, -957.94775390625, 29.264410018921),
    ped = vector4(287.51864624023, -963.89605712891, 28.418626785278, 1.5441319942474),
    veh = "foodbike",
    posTakeLettre = vector3(292.44, -963.57, 28.42),
    jobName = "Pizza",
}

local BoxesDone = {}
function CreatePedForPizza(coh)
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
    Wait(500)
    if blippos then RemoveBlip(blippos) end
    local ped = entity:CreatePedLocal(PedsPizza[math.random(1, #PedsPizza)], coh.xyz, coh.w)
    SetEntityAsMissionEntity(ped.id, true)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    SetEntityInvincible(ped.id, true)
    FreezeEntityPosition(ped.id, true)
    SetTimeout(1.5*60000, function()
        DeleteEntity(ped.id)
    end)
    blippos = AddBlipForCoord(coh.xyz)
    pedPizza[delivered] = ped.id
    return GetEntityCoords(ped.id)
end

CreateThread(function()
    local ped = nil
    local created = false
    if not created then
        ped = entity:CreatePedLocal("s_m_m_cntrybar_01", PositionsPizza.ped.xyz, PositionsPizza.ped.w)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    
    while not p do Wait(1) end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
end)

local function spawnVeh()
    for k, v in pairs(PositionsPizza.spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create(PositionsPizza.veh, vector4(v), {})
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            SetVehicleLivery(vehs, 2)
            createKeys(plate, model)
            veh = vehs
            --TaskWarpPedIntoVehicle(PlayerPedId(), vehs, -1)
            return vehs
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Il n'y a ~s pas de place ~c pour le véhicule"
            })
        end
    end
    return nil
end


zone.addZone("pizzapos",
    PositionsPizza.ped.xyz + vector3(0.0, 0.0, 2.0),
    "Appuyer sur ~INPUT_CONTEXT~ pour récupérer la feuille de service",
    function()
        SendNUIMessage({
            type = "openWebview",
            name = "MenuJob",
            data = {
                headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/12015582390289777761205619411537362954pizza.webp",
                choice = {
                    label = "Scoots",
                    isOptional = false,
                    choices = {
                        {
                            id = 1,
                            label = 'Foodbike',
                            name = PositionsPizza.veh,
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Entreprise/BurgerShot/foodbike.webp",
                        },
                    },
                },
                participants = PlayersInJob,
                participantsNumber = 1,
                callbackName = "MetierPizza",
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
    "bulleTravaillerScoot"
)

RegisterNUICallback("MetierPizza", function(data)
    if data and data.button == "start" then 
        if CheckJobLimit() then
            PlayersId = {}
            for k, v in pairs(PlayersInJob) do 
                table.insert(PlayersId, v.id)
            end
            TriggerServerEvent("core:activities:create", token, PlayersId, "pizza")
            StartPizzaMission()
        end
    elseif data.button == "stop" then
        endPizzaMission()
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then 
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, PositionsPizza.jobName)
        end
    end
end)

function AddTenuePizza()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 123)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 4)
        SkinChangeFake("pants_2",0)
        SkinChangeFake("shoes_1", 1)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 17)
        SkinChangeFake("helmet_2", 3)
        SkinChangeFake("glasses_1", 8)
        SkinChangeFake("glasses_2", 0)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 119)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 14)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 4)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 4)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 1)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 17)
        SkinChangeFake("helmet_2", 3)
        SkinChangeFake("glasses_1", 11)
        SkinChangeFake("glasses_2", 0)
    end
end 

RegisterNetEvent("core:activities:liveupdate", function(typejob, data)
    if typejob == "pizza" then 
        if data.finished then 
            print("data.finished", data.finished)
            finished = data.finished
        end
        if data.delivered then 
            delivered = data.delivered
        end
        if data.takencolis then 
            FriendHasTakenColis = true
        end
        if data.finishcolis then 
            FriendHasTakenColis = false
        end
    end
end)

function StartPizzaMission(isFriend)
    AddTenuePizza()
    delivered = 0
    print("num", #pizzaPos)
    math.randomseed(GetGameTimer())
    idToGo = math.random(1, #pizzaPos)
    OpenTutoFAInfo(PositionsPizza.jobName, "Aller récupérer les pizzas sur le point GPS.")
    veh = isFriend and NetToVeh(isFriend.veh) or spawnVeh()
    advance = 0
    Bulle.create("pizza:recupBoites", PositionsPizza.posTakeLettre, "bulleRecupererPizza", true)
    blipBoites = AddBlipForCoord(PositionsPizza.posTakeLettre)
    near = false
    MaximumPizza = #pizzaPos[idToGo]
    print("MaximumPizza", MaximumPizza)
    local shown = false
    finished = false
    if not isFriend then
        TriggerServerEvent("core:activities:update", PlayersId, "pizza", {MaximumPizza = MaximumPizza, veh = VehToNet(veh)})
    end
    while not finished do
        Wait(1)
        playerpos = GetEntityCoords(PlayerPedId())
        -- Prendre pizza du coffre
        if GetDistanceBetweenCoords(playerpos, addpos) < 100.0 then
            if GetDistanceBetweenCoords(playerpos, addpos) < 20.0 then
                if not IsPedInAnyVehicle(p:ped()) then 
                    if not IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                        if not FriendHasTakenColis then
                            if not shown then
                                OpenTutoFAInfo(PositionsPizza.jobName, "Récuperez une pizza et livrez le client.")
                                shown = true
                            end
                            Bulle.create("poserCoffrePizza", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust")) + vector3(0.0, 0.0, 1.2), "bulleRecupererPizza", true)
                            if Vdist2(GetEntityCoords(p:ped()), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust"))) < 2.0 then 
                                if IsControlJustPressed(0, 38) then 
                                    HasPizza = true
                                    TriggerServerEvent("core:activities:liveupdate", PlayersId, "pizza", {takencolis = true})
                                    ExecuteCommand("e carrypizza")
                                    OpenTutoFAInfo(PositionsPizza.jobName, "Déposez les pizzas dans le coffre du scooteur et suit le GPS pour les livrer.")
                                    Bulle.hide("poserCoffrePizza")
                                    Bulle.remove("poserCoffrePizza")
                                end
                            end
                        else
                            Bulle.hide("poserCoffrePizza")
                            Bulle.remove("poserCoffrePizza")
                        end
                    else
                        if shown then
                            shown = false
                            if Bulle.exists("poserCoffrePizza") then
                                Bulle.hide("poserCoffrePizza")
                                Bulle.remove("poserCoffrePizza")
                            end
                            exports['tuto-fa']:HideStep()
                        end
                    end
                else
                    if shown then
                        shown = false
                        if Bulle.exists("poserCoffrePizza") then
                            Bulle.hide("poserCoffrePizza")
                            Bulle.remove("poserCoffrePizza")
                        end
                        exports['tuto-fa']:HideStep()
                    end
                    if Bulle.exists("poserCoffrePizza") then
                        Bulle.hide("poserCoffrePizza")
                        Bulle.remove("poserCoffrePizza")
                    end
                end
            end
        else
            shown = false
        end
        -- Donner la pizza au client
        if GetDistanceBetweenCoords(playerpos, addpos) < 2 then
            if IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) or HasPizza then
                near = true
                Bulle.create("pizzaDepos", addpos + vector3(0.0, 0.0, 1.0), "bulleLivrerPizza", true)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("core:activities:liveupdate", PlayersId, "pizza", {finishcolis = true})
                    RequestAnimDict("mp_common")
                    p:PlayAnim('mp_common', 'givetake1_a', 50)
                    while not HasAnimDictLoaded("mp_common") do Wait(1) end
                    TaskPlayAnim(pedPizza[delivered], "mp_common", "givetake1_a", 8.0, -8.0, -1, 50, 0, 0, 0, 0)
                    HasPizza = false
                    pizzaSold += 1
                    Wait(1000)
                    ExecuteCommand("e c")
                    PlayPedAmbientSpeechNative(pedPizza[delivered], 'GENERIC_HI', 'Speech_Params_Force_Normal_Clear')
                    ClearPedTasks(pedPizza[delivered])
                    TaskPlayAnim(pedPizza[delivered], "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 50, 0, 0, 0, 0)
                    RequestModel(`prop_pizza_box_02`)
                    while not HasModelLoaded(`prop_pizza_box_02`) do Wait(1) end
                    local obj = CreateObject(`prop_pizza_box_02`, GetEntityCoords(p:ped()))
                    AttachEntityToEntity(obj, pedPizza[delivered], GetPedBoneIndex(pedPizza[delivered], 28422), 0.0100, -0.1000, -0.1590, 20.0000007, 0.0, 0.0, true, true,
                    false, true, 1, true)
                    RemoveBlip(blippos)
                    Bulle.hide("pizzaDepos")
                    Bulle.remove("pizzaDepos")
                    if Bulle.exists("poserCoffrePizza") then
                        Bulle.hide("poserCoffrePizza")
                        Bulle.remove("poserCoffrePizza")
                    end
                    local olddelivered = delivered
                    CreateThread(function()
                        Wait(5000)
                        print("DELETE", pedPizza[olddelivered], olddelivered)
                        if pedPizza[olddelivered] and DoesEntityExist(pedPizza[olddelivered]) then
                            NetworkRequestControlOfEntity(pedPizza[olddelivered])
                            while not NetworkHasControlOfEntity(pedPizza[olddelivered]) do Wait(1) end
                            DeleteEntity(pedPizza[olddelivered])
                            pedPizza[olddelivered] = nil
                        end
                        if obj and DoesEntityExist(obj) then
                            DeleteEntity(obj)
                        end
                    end)
                    delivered += 1
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez livré une pizza"
                    })
                    print(delivered, MaximumPizza)
                    if tonumber(delivered) == tonumber(MaximumPizza) then 
                        TriggerServerEvent("core:activities:liveupdate", PlayersId, "pizza", {finished = true})
                        finished = true
                    end
                    if delivered < MaximumPizza then
                        addpos = CreatePedForPizza(pizzaPos[idToGo][delivered+1])
                        SetNewWaypoint(addpos.x, addpos.y)
                    else
                        OpenTutoFAInfo(PositionsPizza.jobName, "Retournez à la pizzeria pour rendre le scooteur et récuperer ta paye.")
                        finished = true                        
                    end
                end
            end
        else
            near = false
        end
        -- Recup pizza pour aller mettre dans le coffre
        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), PositionsPizza.posTakeLettre) < 2.0 then 
            if IsControlJustPressed(0, 38) then 
                if recupedPizza < MaximumPizza then
                    if not IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                        recupedPizza += 1
                        ExecuteCommand("e carrypizza")
                        Bulle.hide("pizza:recupBoites")
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "Allez d'abord déposer dans le coffre votre colis !"
                        })
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez déjà pris tous vos colis, vous pouvez commencer votre service !"
                    })
                end
            end 
        end
        -- Depos dans le coffre des lettres
        if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), PositionsPizza.ped.xyz) < 50.0 then
            if IsEntityPlayingAnim(p:ped(), "anim@heists@box_carry@", "idle", 3) then
                if Vdist2(p:pos(), GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust"))) < 2.5 then 
                    Bulle.create("poserCoffrePizza", GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "exhaust")) + vector3(0.2, 0.0, 1.3), "bulleDeposerScoot", true)
                    if IsControlJustPressed(0, 38) then 
                        p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                        Wait(500)
                        ExecuteCommand("e c")
                        Wait(500)
                        ClearPedTasks(PlayerPedId())
                        if recupedPizza == MaximumPizza then
                            exports['tuto-fa']:HideStep()
                            Bulle.hide("pizza:recupBoites")
                            Bulle.hide("poserCoffrePizza")
                            Bulle.remove("pizza:recupBoites")
                            Bulle.remove("poserCoffrePizza")
                            math.randomseed(GetGameTimer())
                            addpos = CreatePedForPizza(pizzaPos[idToGo][delivered+1])
                            RemoveBlip(blipBoites)
                            SetNewWaypoint(addpos.x, addpos.y)
                            TriggerServerEvent("core:activities:liveupdate", PlayersId, "pizza", {recupedPizza = recupedPizza, addpos = addpos})
                            OpenTutoFAInfo(PositionsPizza.jobName, "Montez dans votre scooter et allez sur le point défini sur votre GPS.")
                        else
                            Bulle.show("pizza:recupBoites")
                        end
                    end
                end
            end
        end
    end
    FriendHasTakenColis = false
    HasLettersInHand = false
    if Bulle.exists("poserCoffrePizza") then
        Bulle.hide("poserCoffrePizza")
        Bulle.remove("poserCoffrePizza")
    end
    print("FINISHEDD")
    RemoveBlip(blippos)
    advance = advance + 1
    if stoped then return end
    local finishblip = AddBlipForCoord(PositionsPizza.deleteVehicule)
    SetNewWaypoint(PositionsPizza.deleteVehicule.xy)
    OpenTutoFAInfo(PositionsPizza.jobName, "Allez rendre le scooter pour etre payé.")
    zone.addZone(PositionsPizza.jobName..":deleteveh",
        PositionsPizza.deleteVehicule.xyz,
        "Appuyer sur ~INPUT_CONTEXT~ pour rendre le vehicle",
        function()
            RemoveBlip(finishblip)
            endPizzaMission()
            TriggerServerEvent("core:activities:kickPlayers", PlayersId, "pizza")
            Bulle.remove("bulleRendreVelo")
        end,
        true,
        36,
        0.5,
        { 0, 255, 0 },
        170,
        5.5,
        true,
        "bulleRendreVelo"
    )
    
end

RegisterCommand("stoppizza", function()
    stoped = true
    advance = 5
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    recupedPizza = 0
    exports['tuto-fa']:HideStep()
end)

function endPizzaMission()
    if IsPedInAnyVehicle(p:ped(), false) then
        local veh = GetVehiclePedIsIn(p:ped(), false)
        if veh then
            removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            DeleteEntity(veh)
        end
    end
    onMissionFinished()
    BoxesDone = {}

    exports['tuto-fa']:HideStep()
    if pizzaSold ~= 0 then
        local winmin, winmax = 125, 190
        local varWinMin, varWinMax = getWinRange("pizza", 125, 190)
        if tonumber(varWinMin) and tonumber(varWinMax) then 
            winmin, winmax = varWinMin, varWinMax
        end
        local money = math.random(winmin, winmax)
        price = money * pizzaSold
        if p:getSubscription() == 1 then price = price*1.25 end 
        if p:getSubscription() == 2 then price = price*2 end 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})

        local nprice = price or 0
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez gagné "..nprice..'$'
        })
    end
    recupedPizza = 0
    pizzaSold = 0
    price = 0

    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
    
    pos = {}
    advance = 0
    Bulle.hide(PositionsPizza.jobName..":deleteveh")
    zone.hideNotif(PositionsPizza.jobName..":deleteveh")
    zone.removeZone(PositionsPizza.jobName..":deleteveh")
end


RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "pizza" then 
        AddTenuePizza()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "pizza" then 
            StartPizzaMission(data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "pizza" then 
        endPizzaMission()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7"..PositionsPizza.jobName.." ^3loaded")
end)