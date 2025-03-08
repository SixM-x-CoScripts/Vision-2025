local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local lockedAnimalList = {}
local carBlip
local isSkinning = false
local hunterservice = false
local missionStart = false
local sold = false
local huntingAnimals = {
    { ped = "a_c_boar", meat = "viandesanglier" },
    { ped = "a_c_deer", meat = "viandebiche" },
    { ped = "a_c_rabbit_01", meat = "viandelapin" },
    { ped = "a_c_mtlion", meat = "viandepuma" },
    { ped = "a_c_pigeon", meat = "viandeoiseau" },
    { ped = "a_c_seagull", meat = "viandeoiseau" },
    { ped = "a_c_chickenhawk", meat = "viandeoiseau" },
}
local PlayersInJob = {}

function AddTenueChasse()
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

CreateThread(function()
    while p == nil do Wait(1000) end 
    PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
    local ped = nil
    local created = false
    if not created then
        ped = entity:CreatePedLocal("s_m_m_linecook", vector3(-1492.5665283203, 4977.8598632813, 62.541934967041),
            50.697154998779)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    while zone == nil do Wait(500) end

    zone.addZone("serviceHunt", -- Nom
        vector3(-1492.5665283203, 4977.8598632813, 64.541934967041), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour prendre votre service", -- Text afficher
        function() -- Action qui seras fait
            PlayersInJob = {{ name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }}
            SendNUIMessage({
                type = "openWebview",
                name = "MenuJob",
                data = {
                    headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/dlcavril/banner_chasse.webp",
                    choice = {
                        label = "Chasse",
                        isOptional = false,
                        choices = {
                            {
                                id = 1,
                                label = 'Bodhi',
                                name = "bodhi2",
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/bodhi2.webp",
                            },
                            {
                                id = 2,
                                label = 'Verus',
                                name = "verus",
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/verus.webp",
                            },
                            {
                                id = 3,
                                label = 'Rebel',
                                name = "rebel",
                                img= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/rebel.webp",
                            },
                        },
                    },
                    participants = PlayersInJob,
                    participantsNumber = 2,
                    callbackName = "MetierChasse",
                }
            })
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5,
        true,
        "bulleChasse"
    )
    
    print("^3[JOBS]: ^7chasse ^3loaded")
end)

local vehicles

RegisterNUICallback("MetierChasse", function(data)
    if data and data.button == "start" then 
        local car = data.selected.name
        if CheckJobLimit() then
            AddTenueChasse()
            PlayersId = {}
            for k, v in pairs(PlayersInJob) do 
                table.insert(PlayersId, v.id)
            end
            TriggerServerEvent("core:activities:create", token, PlayersId, "chasse")
            closeUI()
            StartHunting(car)
        end
    elseif data.button == "addPlayer" then
        if data.selected ~= 0 then 
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "chasse", true)
        end
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "chasse")
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
        hunterservice = false
        RemoveBlip(blips)
        missionStart = false
        blips = nil
        if vehicles then 
            DeleteEntity(vehicles)
        end
        service = false
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté votre service ~c de chasse"
        })
        TriggerServerEvent("hunt:removeWeap")
        local playerSkin = p:skin()
        onMissionFinished()
        RemoveBlip(carBlip)
        ApplySkin(playerSkin)
        closeUI()
    end
end)

RegisterNetEvent("hunt:animalLock")
AddEventHandler("hunt:animalLock", function(lockedAnimal)
    lockedAnimalList[lockedAnimal] = true
end)

local function SpawnChasseAnimals()
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 2*60000)
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 30000)
    Wait(3000)
    CreateThread(function()
        for i = 1, 25, 1 do
            math.randomseed(GetGameTimer())
            local animal = huntingAnimals[math.random(1, #huntingAnimals)]
            -- randomly chooses a index from the Chasseur table
            math.randomseed(GetGameTimer())
            local random = math.random(1, #Chasseur)
            -- spawns the animal
            local animalPed = entity:CreatePed(animal.ped, Chasseur[random], 0.0)
            SetEntityAsMissionEntity(animalPed.id, 0, 0)
            --make the animal move around
            TaskWanderStandard(animalPed.id, 10.0, 10)
            Wait(1500)
        end
    end)
end

function StartHunting(car, isfriend)
    if hunterservice then
        hunterservice = false
        RemoveBlip(blips)
        missionStart = false
        blips = nil
        service = false
        -- TriggerEvent("core:ShowNotification", "~r~Vous avez quitté votre service de chasse")

		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté votre service ~c de chasse"
        })
        local playerSkin = p:skin()
        RemoveBlip(carBlip)
        ApplySkin(playerSkin)
        onMissionFinished()
        TriggerServerEvent("hunt:removeWeap")

    else
        hunterservice = true
        missionStart = true
        -- show on screen notification
        -- ShowNotification("Vous pouvez commencer à chasser")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous pouvez ~s commencer ~c à chasser"
        })

        TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_knife", 1, {premium = true, chasse = true})
        TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_musket", 1, {premium = true, chasse = true})

        -- set the hunting area on the players map
        CreateThread(function()
            while missionStart do
                if blips ~= nil then
                    RemoveBlip(blips)
                end
                blips = AddBlipForRadius(-1073.3568115234, 4376.8896484375, 12.356980323792, 600.0)
                SetBlipSprite(blips, 9)
                SetBlipColour(blips, 1)
                SetBlipAlpha(blips, 100)
                Wait(15 * 60000)
            end
        end)
        TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 2*60000)
        Wait(1000)
        -- spawn the animals in the area
        if not isfriend then
            vehicles = vehicle.create(car, vector4(-1494.9586181641, 4963.4868164062, 62.88561630249, 177.08815002441), {})
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicles, -1)
            carBlip = AddBlipForEntity(vehicles)
            SetBlipSprite(carBlip, 225)
            SetBlipColour(carBlip, 2)
            CreateThread(function()
                Wait(30000)
                if DoesEntityExist(vehicles) then 
                    if GetDistanceBetweenCoords(GetEntityCoords(vehicles), -1494.9586181641, 4963.4868164062, 62.8856163024) < 2.0 then 
                        DeleteEntity(vehicles)
                    end
                end
            end)
        else
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Montez dans le véhicule de votre collègue"
            })
        end
        OpenTutoFAInfo("Chasse", "Allez dans la zone de chasse pour commencer à chasser")
        SpawnChasseAnimals()
        local hided = false
        CreateThread(function()
            while missionStart do
                Wait(1)
                if IsControlJustPressed(0, 45) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_musket") then 
                    SetPedAmmo(PlayerPedId(), GetHashKey("weapon_musket"), 1)
                end
            end
        end)
        CreateThread(function()
            while missionStart do
                while #(p:pos().xyz - vector3(-1073.3568115234, 4376.8896484375, 12.356980323792)) <= 600 do
                    Wait(500)
                    if not hided then 
                        exports['tuto-fa']:HideStep()
                        hided = true
                    end
                    -- Auto reload
                    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_musket") then
                        local ret, ammo = GetAmmoInClip(PlayerPedId(), GetHashKey("weapon_musket"))
                        if ammo == 0 then
                            Wait(500)
                            SetPedAmmo(PlayerPedId(), GetHashKey("weapon_musket"), 1)
                        end
                    end
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    -- find the closest dead animal
                    local random, animal = FindFirstPed()
                    repeat
                        if not IsPedAPlayer(animal) and not IsPedInAnyVehicle(playerPed) and
                            not IsPedInAnyVehicle(animal) then
                            -- check if animal model is in the huntingAnimals table
                            for k, v in pairs(huntingAnimals) do
                                if GetEntityModel(animal) == GetHashKey(v.ped) then
                                    -- check if the player is close enough to the animal
                                    local animalCoords = GetEntityCoords(animal)
                                    local distance = #(playerCoords - animalCoords)
                                    if not lockedAnimalList[NetworkGetNetworkIdFromEntity(animal)] then
                                        while distance <= 3.0 and IsPedDeadOrDying(animal) and not lockedAnimalList[NetworkGetNetworkIdFromEntity(animal)] do
                                            Wait(1)
                                            distance = #(p:pos() - GetEntityCoords(animal))
                                            Bulle.create("depecage", vector3(animalCoords.x, animalCoords.y, animalCoords.z + 0.75), "bulleDepecer", true)
                                            Bulle.show("depecage")
                                            if IsControlJustPressed(0, 38) then
                                                -- check if the player has a knife
                                                if HasPedGotWeapon(playerPed, GetHashKey("WEAPON_KNIFE"), false) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_KNIFE") then
                                                    -- check if the player is not already skinning an animal
                                                    if not isSkinning then
                                                        isSkinning = true
                                                        -- load the skinning animation
                                                        RequestAnimDict("amb@world_human_gardener_plant@male@base")
                                                        while not
                                                            HasAnimDictLoaded("amb@world_human_gardener_plant@male@base") do Wait(0) end
                                                        -- play the animation
                                                        TaskPlayAnim(p:ped(),
                                                            "amb@world_human_gardener_plant@male@base", "base", 1.0, 1.0
                                                            , 0.7, 120, 0.2, 1, 1, 1)
                                                        Wait(5000)
                                                        StopAnimTask(pid, "amb@world_human_gardener_plant@male@base",
                                                            "base", 1.0)
                                                        -- give item depending on the animal
                                                        for _, animals in pairs(huntingAnimals) do
                                                            if GetEntityModel(animal) == GetHashKey(animals.ped) then
                                                                TriggerSecurGiveEvent("core:addItemToInventory", token,
                                                                    animals.meat, 1, {})

                                                                --[[ Ancienne notification
                                                                -- ShowNotification("~g~Tu as récupéré 1x ~o~ Viande de "
                                                                    .. animals.meat)
                                                                ---]]

                                                                -- New notif
                                                                exports['vNotif']:createNotification({
                                                                    type = 'JAUNE',
                                                                    -- duration = 5, -- In seconds, default:  4
                                                                    content = "Tu as récupéré ~s 1x ".. GetItemLabel(animals.meat)
                                                                })

                                                            end
                                                        end
                                                        -- can't skin the animal again
                                                        TriggerServerEvent("hunt:animalLock", NetworkGetNetworkIdFromEntity(animal))
                                                        SetEntityAsNoLongerNeeded(animal)
                                                        ClearPedTasksImmediately(playerPed)
                                                        isSkinning = false
                                                        Bulle.hide("depecage")
                                                        Bulle.remove("depecage")
                                                    end
                                                else
                                                    -- ShowNotification("~r~Vous n'avez pas de couteau")

                                                    -- New notif
                                                    exports['vNotif']:createNotification({
                                                        type = 'ROUGE',
                                                        -- duration = 5, -- In seconds, default:  4
                                                        content = "~s Vous n'avez pas de couteau en main"
                                                    })

                                                end
                                            end
                                        end
                                        Bulle.hide("depecage")
                                    end
                                end
                            end
                        end
                        success, animal = FindNextPed(random)
                    until not success
                    EndFindPed(random)
                end
                Wait(500)

                if #(p:pos().xyz - vector3(-1073.3568115234, 4376.8896484375, 12.356980323792)) > 1500.0 then 
                    print("Remove job chasse")
                    hunterservice = false
                    RemoveBlip(blips)
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
                    RemoveBlip(carBlip)
                    missionStart = false
                    blips = nil
                    service = false
                    TriggerServerEvent("hunt:removeWeap")
                    local playerSkin = p:skin()
                    onMissionFinished()
                    ApplySkin(playerSkin)
                    if vehicles then 
                        DeleteEntity(vehicles)
                    end
                end
            end
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
            TriggerServerEvent("hunt:removeWeap")
        end)
    end
end


RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "chasse" then 
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "chasse" then 
            AddTenueChasse()
            StartHunting(nil, true)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob)
    if typejob == "chasse" then 
        hunterservice = false
        RemoveBlip(blips)
        missionStart = false
        blips = nil
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
        onMissionFinished()
        service = false
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s quitté votre service ~c de chasse"
        })
        TriggerServerEvent("hunt:removeWeap")
        local playerSkin = p:skin()
        RemoveBlip(carBlip)
        ApplySkin(playerSkin)
        if vehicles then 
            DeleteEntity(vehicles)
        end
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)