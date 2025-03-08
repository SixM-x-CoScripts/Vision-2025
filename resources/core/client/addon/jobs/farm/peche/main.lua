local token = nil
local service = false
local veh = nil
local missionStart = false
local HasRod = false
local PlayersId = {}

local blipRadiusGreen = nil
local posGreen = nil

local Choosenk = 1
local posRed = nil
local blipsred = nil

local inPeche = false
local good = 0
local first = false
local limit = 0
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local lucky = 0
local inOut = true
MaxPeche = math.random(10, 16)
local touche = { {
    touch = "D",
    number = 9
}, {
    touch = "C",
    number = 319
}, {
    touch = "A",
    number = 44
}, {
    touch = "L",
    number = 182
}, {
    touch = "Z",
    number = 32
}, {
    touch = "S",
    number = 33
} }

local toucheQWERTY = { {
    touch = "W",
    number = 32
}, {
    touch = "S",
    number = 33
}, {
    touch = "C",
    number = 26
}, {
    touch = "V",
    number = 0
} }

local greenZone = { {
    item = "carpe",
    price = 4
}, {
    item = "bar",
    price = 4
}, {
    item = "merlan",
    price = 10
}, {
    item = "saumon",
    price = 11
}, {
    item = "calamar",
    price = 17
} }

local redZone = {
    {
        price = 70,
        name = "dauphin",
        label = "Dauphin",
        chance = 20,
    },
    {
        price = 60,
        name = "Esturgeon",
        label = "Esturgeon",
        chance = 30,
    },
    {
        price = 100,
        name = "orc",
        label = "Orque",
        chance = 10,
    },

    --{
    --    price = 45,
    --    name =  "PoissonNapoleon",
    --    label = "Poisson Napoleon",
    --    chance = 20,
    --},
    --{
    --    price = 55,
    --    name =  "PoissonScie",
    --    label = "Poisson Scie",
    --    chance = 15,
    --},
    --{
    --    price = 250,
    --    name =  "Baleine",
    --    label = "Baleine",
    --    chance = 2,
    --},

    {
        price = 40,
        name =  "raie",
        label = "Raie",
        chance = 30,
    },
    {
        price = 100,
        name =  "requin",
        label = "Requin",
        chance = 10,
    },

    --{
    --    price = 45,
    --    name =  "Murene",
    --    label = "Murène",
    --    chance = 20,
    --},

    --{
    --    price = 0,
    --    name =  "algues",
    --    label = "Algues",
    --    chance = 70,
    --},
}

local items = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuMetier/header_peche.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
    headerIconName = 'PÊCHE',
    callbackName = 'sellFishIllegal',
    showTurnAroundButtons = false,
    elements = {
        {
            price = 70,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/dauphin.webp",
            name = "dauphin",
            label = "Dauphin",
            chance = 8,
        },
        {
            price = 60,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Esturgeon.webp",
            name = "Esturgeon",
            label = "Esturgeon",
            chance = 12,
        },
        {
            price = 100,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/orc.webp",
            name = "orc",
            label = "Orque",
            chance = 6,
        },

        {
            price = 45,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/PoissonNapoleon.webp",
            name =  "PoissonNapoleon",
            label = "Poisson Napoleon",
            chance = 20,
        },
        {
            price = 55,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/PoissonScie.webp",
            name =  "PoissonScie",
            label = "Poisson Scie",
            chance = 15,
        },
        {
            price = 250,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Baleine.webp",
            name =  "Baleine",
            label = "Baleine",
            chance = 2,
        },

        {
            price = 40,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/raie.webp",
            name =  "raie",
            label = "Raie",
            chance = 30,
        },
        {
            price = 100,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/requin.webp",
            name =  "requin",
            label = "Requin",
            chance = 6,
        },

        {
            price = 45,
            image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/Murene.webp",
            name =  "Murene",
            label = "Murène",
            chance = 20,
        },
    }
}

local AllPosPeche = {
    {
        ped = vector4(3867.5708007813, 4462.1396484375, 1.7238185405731, 57.33073425293),
        spawn = vector4(3863.7424316406, 4468.9975585938, -0.87957856059074, 267.92),
        despawn = vector3(3870.2861328125, 4464.01953125, -0.8383301794529),
        greenzone = vector3(4070.279296875, 4625.5249023438, -4.121787071228),
        rezone = vector3(3863.88, 4463.55, 1.9),
    },
    {
        ped = vector4(-290.00582885742, -2769.6403808594, 1.195300579071, 8.9478597640991),
        spawn = vector4(-291.67813110352, -2761.0270996094, 0.25465500354767, 277.40927124023),
        despawn = vector3(-290.92874145508, -2760.4211425781, 1.5122601985931),
        greenzone = vector3(-269.58020019531, -3480.8979492188, 1.0229111909866),
        rezone = vector3(-293.66, -2769.11, 1.8),
    },
    {
        ped = vector4(3374.0222167969, 5183.462890625, 0.46652722358704, 72.9478597640991),
        spawn = vector4(3377.55, 5188.75, -1.91, 269.23),
        despawn = vector3(3377.57, 5188.72, -1.4),
        greenzone = vector3(3793.9, 5312.26, 1.63),
        rezone = vector3(3371.22, 5183.98, 1.46),
    },
    {
        ped = vector4(-1614.5623779297, 5261.564453125, 2.9741015434265, 209.51426696777),
        spawn = vector4(-1618.7182617188, 5255.5380859375, -0.86835840344429, 15.51426696777),
        despawn = vector3(-1604.0867919922, 5262.982421875, -0.88046258687973),
        greenzone = vector3(-1752.2315673828, 5625.9790039063, -1.7272484302521),
        rezone = vector3(-1612.3, 5259.08, 3.17),
    },
}

local item = ""
local index = 1
local redZoneActive = false
local poissonsPeche = 0
local hasShownFinished = false
local allowmoving = false
local blipsDespawn = nil
function TakePecheurService(priceofbateau, isFriend)
    local AntiSpam = false
    local threadPeche 
    local threadPeche2
    local TerminatedPeche = false
    local despawnpos = AllPosPeche[Choosenk].despawn
    zone.addZone("pecheur_DelVeh", despawnpos,   
        "Appuyer sur ~INPUT_CONTEXT~ pour ranger le bateau", function()
            if IsPedInAnyVehicle(p:ped(), false) then
                exports['tuto-fa']:HideStep()
                poissonsPeche = 0
                hasShownFinished = false
                missionStart = false 
                RemoveTenuePeche()
                service = false
                RemoveBlip(blipsDespawn)
                DeleteEntity(GetVehiclePedIsIn(p:ped()))
                if AllPosPeche[Choosenk] and AllPosPeche[Choosenk].rezone then 
                    SetEntityCoords(PlayerPedId(), AllPosPeche[Choosenk].rezone)
                end
                TriggerServerEvent("core:SellPecheur", token)
                blipsDespawn = nil
            end
        end, 
        true, 
        35, 
        1.5, 
        { 255, 0, 0 }, 
        255,
        9.0,
        true,
        "bulleRendreBateau",
        nil,
        50.0
    )
    if not service then
        service = true
        missionStart = true

        OpenTutoFAInfo("Pêcheur", "Rends toi dans la zone de pêche pour pêcher")

        ---Premiere Phase
        CreateThread(function()
            ---GestionBlips
            while missionStart do
                if blipRadiusGreen ~= nil or blipsred ~= nil  then
                    RemoveBlip(blipRadiusGreen)
                    RemoveBlip(blipsred)

                    ClearPedTasks(p:ped())
                end

                math.randomseed(GetGameTimer())
                if isFriend then
                    posGreen = isFriend.posGreen
                else
                    --local ramdom = math.random(1, #Pecheur.green)
                    posGreen = AllPosPeche[Choosenk].greenzone
                end
                print("AddBlipForRadius", posGreen.xyz)
                blipRadiusGreen = AddBlipForRadius(posGreen.xyz, 300.0)
                SetBlipSprite(blipRadiusGreen, 9)
                SetBlipColour(blipRadiusGreen, 2)
                SetBlipAlpha(blipRadiusGreen, 100)
                redZoneActive = false
                first = false

                math.randomseed(GetGameTimer())
                
                --if isFriend then
                --    posRed = isFriend.posRed
                --else
                --    local RedPosRdm = math.random(1, #Pecheur.red)
                --    posRed = Pecheur.red[RedPosRdm]
                --end
                --blipsred = AddBlipForRadius(posRed, 300.0)
                --SetBlipSprite(blipsred, 9)
                --SetBlipColour(blipsred, 1)
                --SetBlipAlpha(blipsred, 100)
                redZoneActive = true
                first = false

                Modules.UI.RealWait(13 * 60000)

            end

        end)
        Wait(1000)
        
        while not posGreen do Wait(200) end
        if not isFriend then
            TriggerServerEvent("core:activities:update", PlayersId, "peche", {posGreen = posGreen, posRed = posRed})
        end
        
        blipsDespawn = AddBlipForCoord(despawnpos)
        SetBlipSprite(blipsDespaawn, 427)
        SetBlipDisplay(blipsDespaawn, 4)
        SetBlipColour(blipsDespawn, 2)
        SetBlipAsShortRange(blipsDespawn, true)
        SetBlipScale(blipsDespawn, 0.75)
        SetBlipAlpha(blipsDespawn, 100)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Rendre le bateau de pêche")
        EndTextCommandSetBlipName(blipsDespawn)

        -- Gestion Peches Green
        CreateThread(function()
            while missionStart do
                CreateThread(function()
                    while #(p:pos() - AllPosPeche[Choosenk].ped.xyz) <= 50.0 do
                        if IsControlJustPressed(0, 38) and p:isInVeh() then
                            if veh ~= nil then
                                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                                removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                                DeleteEntity(veh)
                            end

                            exports['tuto-fa']:HideStep()
                            if p:isInVeh() then
                                DeleteEntity(veh)
                            end
                            SetEntityCoords(p:ped(), AllPosPeche[Choosenk].ped.xyz)
                            RemoveBlip(blipRadiusGreen)
                            RemoveBlip(blipsred)
                            TriggerServerEvent("core:activities:kickPlayers", PlayersId, "peche", true, {pos = AllPosPeche[Choosenk].ped.xyz})

                            -- ShowNotification("Merci de ton travail à la prochaine")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'CLOCHE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s Merci ~c de ton travail à la prochaine"
                            })
                            
                            Wait(200)
                            service = false
                            veh = nil
                            missionStart = false
                            blipRadiusGreen = nil
                            blipsred = nil
                            posGreen = nil
                            posRed = nil
                            inPeche = false
                            service = false
                            return
                        end
                        Wait(1)
                    end
                end)
                while #(p:pos().xyz - posGreen.xyz) <= 300 do
                    if not p:isInVeh() then
                        if hasShownExit then
                            hasShownExit = false
                            exports['tuto-fa']:HideStep()
                        end
                        --ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour pêcher")
                        if not inPeche then
                            if poissonsPeche < MaxPeche then
                                Bulle.create("pecher", GetEntityCoords(p:ped()) + vector3(0.0, 0.0, 1.0), "bullePecher", true)
                            end
                        end
                        if poissonsPeche >= MaxPeche then 
                            if not hasShownFinished then
                                hasShownFinished = true
                                OpenTutoFAInfo("Pêcheur", "Retourne au port pour rendre le bateau et vendre tes poissons")
                            end
                        end
                        if IsControlJustPressed(0, 38) and not inPeche and poissonsPeche < MaxPeche then

                            TerminatedPeche = false
                            inPeche = true
                            Bulle.hide("pecher")
                            Bulle.remove("pecher")
                            TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_STAND_FISHING", -1, true)
                            -- Play Scenario
                            good = 0                            
                            OpenTutoFAInfo("Pêcheur", "Pêche un maximum de poissons pour pouvoir les revendre")
                            math.randomseed(GetGameTimer())
                            local maths = math.random(15, 30)
                            --Wait(maths * 1000)
                            local timer = 1
                            while timer < 100*maths do 
                                Wait(1)
                                timer += 10
                                print("timer", timer, 100*maths)
                                if IsControlJustPressed(0, 38) then 
                                    inPeche = false
                                    TerminatedPeche = true
                                    print("STOP PECHE 2", inPeche, TerminatedPeche)
                                    TerminateThread(threadPeche)
                                    TerminateThread(threadPeche2) 
                                    ClearPedTasksImmediately(p:ped(), true)
                                    local rod = GetClosestObjectOfType(p:pos().xyz, 20.0,
                                        GetHashKey("prop_fishing_rod_01"),
                                        1, false, false)
                                    local rod2 = GetClosestObjectOfType(p:pos().xyz, 20.0,
                                        GetHashKey("prop_fishing_rod_01"),
                                        0, false, false)
                                    if rod ~= 0 then
                                        SetEntityAsMissionEntity(rod, 1, 1)
                                        DeleteEntity(rod)
                                    end
                                    if rod2 ~= 0 then
                                        SetEntityAsMissionEntity(rod2, 1, 1)
                                        DeleteEntity(rod2)
                                    end
                                    timer = 110*maths
                                end
                            end
                            print("inPeche", inPeche, "TerminatedPeche", TerminatedPeche)
                            if inPeche and (not TerminatedPeche) then
                                -- ShowNotification("Attention un poisson mord")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "~s Attention ~c un poisson mord"
                                })

                                threadPeche2 = CreateThread(function()
                                    while inPeche do
                                        Wait(0)
                                        if not allowmoving then
                                            DisableAllControlActions(0)
                                        end
                                    end
                                end)

                                threadPeche = CreateThread(function()
                                    while inPeche do
                                        if not inPeche then break end
                                        if not allowmoving then
                                            if IsPedInAnyVehicle(PlayerPedId()) then 
                                                inPeche = false 
                                                break
                                            end
                                            if IsAZERTYKeyboard() then
                                                local x, y = Modules.UI.ConvertToPixel(90, 90)
                                                Modules.UI.DrawRectangle(vector2(0.48333334922791, 0.1490740776062), vector2(x, y),
                                                    { 0, 0, 0, 150 }, true, { 0, 0, 0, 150 }, function()
                                                    end, nil, false, false)
                                                Modules.UI.DrawTexts(0.50729167461395, 0.16111110150814, touche[index].touch, true,
                                                    0.90, { 255, 255, 255, 255 }, 6, false, false)
                                                Modules.UI.DrawTexts(0.51093751192093, 0.099074073135853,
                                                    "Appuyer sur la bonne touche !", true, 0.50, { 255, 255, 255, 255 }, 6, false,
                                                    false)
                                                    
                                                if IsControlJustPressed(0, tonumber(touche[index].number)) or IsDisabledControlJustPressed(0, tonumber(touche[index].number)) then
                                                    math.randomseed(GetGameTimer())
                                                    index = math.random(1, #touche)
                                                    good = good + 1
                                                end
                                            elseif IsQWERTYKeyboard() then
                                                local x, y = Modules.UI.ConvertToPixel(90, 90)
                                                Modules.UI.DrawRectangle(vector2(0.48333334922791, 0.1490740776062), vector2(x, y),
                                                    { 0, 0, 0, 150 }, true, { 0, 0, 0, 150 }, function()
                                                    end, nil, false, false)
                                                Modules.UI.DrawTexts(0.50729167461395, 0.16111110150814, toucheQWERTY[index].touch, true,
                                                    0.90, { 255, 255, 255, 255 }, 6, false, false)
                                                Modules.UI.DrawTexts(0.51093751192093, 0.099074073135853,
                                                    "Appuyer sur la bonne touche !", true, 0.50, { 255, 255, 255, 255 }, 6, false,
                                                    false)
                                                    
                                                if IsControlJustPressed(0, tonumber(toucheQWERTY[index].number)) or IsDisabledControlJustPressed(0, tonumber(toucheQWERTY[index].number)) then
                                                    math.randomseed(GetGameTimer())
                                                    index = math.random(1, #toucheQWERTY)
                                                    good = good + 1
                                                end
                                            end

                                            if good == 5 then
                                                if not AntiSpam then 
                                                    AntiSpam = true
                                                    poissonsPeche += 1
                                                    math.randomseed(GetGameTimer())
                                                    local poisson = math.random(0, 100)
                                                    if poisson <= 25 then
                                                        -- ShowNotification("vous avez attrapé une carpe")

                                                        -- New notif
                                                        exports['vNotif']:createNotification({
                                                            type = 'JAUNE',
                                                            -- duration = 5, -- In seconds, default:  4
                                                            content = "Vous avez attrapé ~s une carpe"
                                                        })

                                                        TriggerSecurGiveEvent("core:addItemToInventory", token, greenZone[1].item,
                                                            1, {})
                                                    elseif poisson > 25 and poisson <= 50 then
                                                        -- ShowNotification("vous avez attrapé un bar")

                                                        -- New notif
                                                        exports['vNotif']:createNotification({
                                                            type = 'JAUNE',
                                                            -- duration = 5, -- In seconds, default:  4
                                                            content = "Vous avez attrapé ~s un bar"
                                                        })

                                                        TriggerSecurGiveEvent("core:addItemToInventory", token, greenZone[2].item,
                                                            1, {})

                                                    elseif poisson > 50 and poisson <= 68 then
                                                        -- ShowNotification("vous avez attrapé un merlan")

                                                        -- New notif
                                                        exports['vNotif']:createNotification({
                                                            type = 'JAUNE',
                                                            -- duration = 5, -- In seconds, default:  4
                                                            content = "Vous avez attrapé ~s un merlan"
                                                        })
                                                        
                                                        TriggerSecurGiveEvent("core:addItemToInventory", token, greenZone[3].item,
                                                            1, {})

                                                    elseif poisson > 68 and poisson <= 84 then
                                                        -- ShowNotification("vous avez attrapé un saumon")

                                                        -- New notif
                                                        exports['vNotif']:createNotification({
                                                            type = 'JAUNE',
                                                            -- duration = 5, -- In seconds, default:  4
                                                            content = "Vous avez attrapé ~s un saumon"
                                                        })

                                                        TriggerSecurGiveEvent("core:addItemToInventory", token, greenZone[4].item,
                                                            1, {})

                                                    elseif poisson > 84 then
                                                        -- ShowNotification("vous avez attrapé un calamar")

                                                        -- New notif
                                                        exports['vNotif']:createNotification({
                                                            type = 'JAUNE',
                                                            -- duration = 5, -- In seconds, default:  4
                                                            content = "Vous avez attrapé ~s un calamar"
                                                        })

                                                        TriggerSecurGiveEvent("core:addItemToInventory", token, greenZone[5].item,
                                                            1, {})

                                                    end
                                                    CreateThread(function()
                                                        Wait(2000)
                                                        AntiSpam = false
                                                    end)
                                                end
                                                good = 0
                                                allowmoving = true
                                                math.randomseed(GetGameTimer())
                                                local maths = math.random(15, 30)
                                                Wait(maths * 1000)
                                                allowmoving = false
                                                if not inPeche then return end
                                            end
                                        end
                                        Wait(1)
                                    end
                                end)
                            end
                        elseif IsControlJustPressed(0, 38) and inPeche then
                            inPeche = false
                            TerminatedPeche = true
                            print("STOP PECHE", inPeche, TerminatedPeche)
                            TerminateThread(threadPeche)
                            TerminateThread(threadPeche2)
                            ClearPedTasksImmediately(p:ped(), true)
                            local rod = GetClosestObjectOfType(p:pos().xyz, 20.0,
                                GetHashKey("prop_fishing_rod_01"),
                                1, false, false)
                            local rod2 = GetClosestObjectOfType(p:pos().xyz, 20.0,
                                GetHashKey("prop_fishing_rod_01"),
                                0, false, false)
                            if rod ~= 0 then
                                SetEntityAsMissionEntity(rod, 1, 1)
                                DeleteEntity(rod)
                            end
                            if rod2 ~= 0 then
                                SetEntityAsMissionEntity(rod2, 1, 1)
                                DeleteEntity(rod2)
                            end
                            Wait(250)
                        end
                    else
                        if not hasShownExit then
                            Bulle.hide("pecher")
                            Bulle.remove("pecher")
                            hasShownExit = true
                            if not hasShownFinished then
                                OpenTutoFAInfo("Pêcheur", "Sortez du bateau pour commencer à pecher")
                            end
                        end
                    end

                    Wait(1)
                end

                while #(p:pos().xyz - posGreen.xyz) > 300 and #(AllPosPeche[Choosenk].ped.xyz - p:pos().xyz) > 10.0 do
                    if not missionStart then 
                        Bulle.hide("pecher")
                        Bulle.remove("pecher")
                        exports['tuto-fa']:HideStep()
                        break
                    end
                    if not p:isInVeh() then
                        if hasShownExit then
                            hasShownExit = false
                            exports['tuto-fa']:HideStep()
                        end
                        if not inPeche then
                            if HasRod then
                                if poissonsPeche < MaxPeche then
                                    Bulle.create("pecher", GetEntityCoords(p:ped()) + vector3(0.0, 0.0, 1.0), "bullePecherIllegal", true)
                                end
                            end
                        end
                        if poissonsPeche >= MaxPeche then 
                            if not hasShownFinished then
                                hasShownFinished = true
                                OpenTutoFAInfo("Pêcheur", "Retourne au port pour rendre le bateau et vendre tes poissons")
                            end
                        end
                        if HasRod then
                            if IsControlJustPressed(0, 38) and not inPeche then
                                Bulle.hide("pecher")
                                Bulle.remove("pecher")
                                inPeche = true
                                TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_STAND_FISHING", -1, true)
                                -- Play Scenario
                                good = 0
                                math.randomseed(GetGameTimer())
                                OpenTutoFAInfo("Pêcheur", "Pêche un maximum de poissons pour pouvoir les revendre, appuie sur E pour arreter de pecher")
                                local maths = math.random(15, 30)
                                Wait(maths * 1000)
                                -- ShowNotification("Attention un poisson mord")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'JAUNE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "~s Attention ~c un poisson mord"
                                })

                                if not first then
                                    local streetName = GetStreetNameFromHashKey(
                                        GetStreetNameAtCoord(GetEntityCoords(PlayerPedId())))
                                    TriggerSecurEvent('core:makeCall', "lspd", GetEntityCoords(PlayerPedId()), true,
                                        "Pêche illegal vers "
                                        ..
                                        streetName, false, "illegal")
                                    TriggerSecurEvent('core:makeCall', "lssd", GetEntityCoords(PlayerPedId()), true,
                                        "Pêche illegal vers "
                                        ..
                                        streetName, false, "illegal")
                                    TriggerSecurEvent('core:makeCall', "gcp", GetEntityCoords(PlayerPedId()), true,
                                        "Pêche illegal vers "
                                        ..
                                        streetName, false, "illegal")
                                    CreateThread(function()
                                        Modules.UI.RealWait(3 * 60000)
                                        first = true
                                    end)

                                end
                                
                                CreateThread(function()
                                    while inPeche do
                                        Wait(0)
                                        DisableAllControlActions(0)
                                        if not inPeche then 
                                            break
                                        end
                                    end
                                end)

                                CreateThread(function()
                                    while inPeche do
                                        if not inPeche then 
                                            break
                                        end
                                        local x, y = Modules.UI.ConvertToPixel(90, 90)
                                        Modules.UI.DrawRectangle(vector2(0.48333334922791, 0.1490740776062), vector2(x, y),
                                            { 0, 0, 0, 150 }, true, { 0, 0, 0, 150 }, function()
                                            end, nil, false, false)
                                        Modules.UI.DrawTexts(0.50729167461395, 0.16111110150814, touche[index].touch, true,
                                            0.90, { 255, 255, 255, 255 }, 6, false, false)
                                        Modules.UI.DrawTexts(0.51093751192093, 0.099074073135853,
                                            "Appuyer sur la bonne touche !", true, 0.50, { 255, 255, 255, 255 }, 6, false,
                                            false)

                                        if IsControlJustPressed(0, tonumber(touche[index].number)) or IsDisabledControlJustPressed(0, tonumber(touche[index].number)) then
                                            math.randomseed(GetGameTimer())
                                            index = math.random(1, #touche)
                                            good = good + 1
                                        end

                                        if good == 5 then
                                            poissonsPeche += 1
                                            math.randomseed(GetGameTimer())
                                            local poisson = math.random(0, 100)

                                            local currentChance = 0
                                            for _, fish in ipairs(redZone) do
                                                currentChance = currentChance + fish.chance
                                                if poisson <= currentChance then
                                                    -- Le joueur a pêché ce poisson ou cette mauvaise chose (algues)
                                                    -- New notif
                                                    exports['vNotif']:createNotification({
                                                        type = 'JAUNE',
                                                        -- duration = 5, -- In seconds, default:  4
                                                        content = "Vous avez attrapé ~s un(e) ".. fish.label
                                                    })

                                                    TriggerSecurGiveEvent("core:addItemToInventory", token, fish.name, 1, {})
                                                    

                                                    return
                                                end
                                            end
                                            
                                            good = 0
                                            allowmoving = true
                                            math.randomseed(GetGameTimer())
                                            local maths = math.random(15, 30)
                                            Wait(maths * 1000)
                                            allowmoving = false
                                            if not inPeche then return end
                                        end
                                        Wait(1)
                                    end
                                end)
                            elseif IsControlJustPressed(0, 38) and inPeche then
                                inPeche = false
                                ClearPedTasksImmediately(p:ped(), true)
                                local rod = GetClosestObjectOfType(p:pos().xyz, 20.0,
                                    GetHashKey("prop_fishing_rod_01"),
                                    false, false, false)
                                if rod ~= 0 then
                                    SetEntityAsMissionEntity(rod, 1, 1)
                                    DeleteEntity(rod)
                                end
                            end
                        end
                    end

                    Wait(1)
                end
                Wait(500)
            end

        end)

    else
        if veh ~= nil then
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
            DeleteEntity(veh)
        end
        RemoveBlip(blipRadiusGreen)
        RemoveBlip(blipsred)
        -- ShowNotification("Merci de ton travail à la prochaine")

        if AllPosPeche[Choosenk].rezone then 
            SetEntityCoords(PlayerPedId(), AllPosPeche[Choosenk].rezone)
        end

        -- New notif
        exports['vNotif']:createNotification({
            type = 'CLOCHE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Merci ~c de ton travail à la prochaine"
        })
        
        Wait(200)
        service = false
        veh = nil
        missionStart = false
        blipRadiusGreen = nil
        blipsred = nil
        posGreen = nil
        posRed = nil
        inPeche = false
        service = false
        return
    end
end

local open = false
local called = false
---vente

local open = false
---vente

Citizen.CreateThread(function()
    for k,v in pairs(AllPosPeche) do
        local ped = entity:CreatePedLocal("a_m_m_salton_02", v.ped.xyz, v.ped.w)
        SetEntityInvincible(ped.id, true)
        ped:setFreeze(true)
        TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
        SetEntityAsMissionEntity(ped.id, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped.id, true)
    end
end)

local PecheOuvert = false
local PlayersInJob = {}
local OpenedId = 0
CreateThread(function()
    while zone == nil do
        Wait(0)
    end
    while p == nil do 
        Wait(1)
    end
    PlayersInJob = {
        { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
    }
    for k,v in pairs(AllPosPeche) do
        zone.addZone("pecheur_job" .. k, -- Nom
            v.ped.xyz + vector3(0.0, 0.0, 2.0), -- Position
            "~INPUT_CONTEXT~ Prendre/arrêter le service", -- Text afficher
            function() -- Action qui seras fait
                --Openpeche()     
                OpenedId = k
                PecheOuvert = true 
                Bulle.hide("pecheur_job" .. k)
                SendNUIMessage({
                    type = "openWebview",
                    name = "MenuJob",
                    data = {
                        headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10885463580315526631202284666888142899BannerPeche11.webp",
                        choice = {
                            label = "Bateaux",
                            isOptional = false,
                            choices = {
                                --{ -- ATTEND AVANT DE LE REMETTRE
                                --    id = 1,
                                --    label = 'Tug 500$',
                                --    name = 'tug',
                                --    price = 500,
                                --    img= "https://cdn.sacul.cloud/v2/vision-cdn/Farm/Peche/tug.webp",
                                --}, 
                                {
                                    id = 1,
                                    label = 'Suntrap 500$',
                                    name = 'suntrap',
                                    price = 500,
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Farm/Peche/suntrap.webp",
                                },      
                                {
                                    id = 2,
                                    label = 'Dinghy 500$',
                                    name = 'dinghy',
                                    price = 500,
                                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Farm/Peche/dinghy.webp",
                                },
                            },
                        },
                        participants = PlayersInJob,
                        participantsNumber = 4,
                        callbackName = "MetierPeche",
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
            "bulleTravaillerPoisson"
        )
        
    end

end)

function Openpeche()
    SendNUIMessage({
        type = "openWebview",
        name = "MenuMetier",
        data = itemcall
    })
    PecheOuvert = true 
    forceHideRadar()
    SetNuiFocusKeepInput(true)
    CreateThread(function()
        while PecheOuvert do 
            Wait(1)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true) 
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 264, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true) 
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
        end
    end)
end

RegisterNUICallback("focusOut", function (data, cb)
    Bulle.show("pecheur_job" .. OpenedId)
    if PecheOuvert then 
        openRadarProperly()
        PecheOuvert = false
    end
end)

RegisterNUICallback("MetierPeche", function(data)
    if data.selected and type(data.selected) == "table" then 
        AddTenuePeche()
        for k,v in pairs(AllPosPeche) do
            if Vdist2(GetEntityCoords(p:ped()), v.spawn.xyz) < 100.0 then
                Choosenk = k
                if vehicle.IsSpawnPointClear(v.spawn.xyz, 5.0) then
                    local outPos = v.spawn
                    veh = vehicle.create(data.selected.name, outPos, {})
                    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                    PecheOuvert = false
                    OpenTutoFAInfo("Pêcheur", "Rends toi dans la zone de pêche pour commencer a pêcher")
                    SendNuiMessage(json.encode({
                        type = 'closeWebview'
                    }))
                    if not missionStart then
                        PlayersId = {}
                        for k, v in pairs(PlayersInJob) do 
                            table.insert(PlayersId, v.id)
                        end
                        TriggerServerEvent("core:activities:create", token, PlayersId, "peche")
                        TakePecheurService(data.selected.price)
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Un bateau est déjà de sortie"
                    })
                end
            end
        end
    elseif data.button == "start" then 
        if not service then
            if CheckJobLimit() then
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous pouvez ~s commencer ~c à pêcher"
                })
                PecheOuvert = false
                SendNuiMessage(json.encode({
                    type = 'closeWebview'
                }))
                TakePecheurService(data.selected.price)
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous êtes déjà en service de pêche"
            })
        end
    elseif data.button == "stop" then
        if service then
            StopJobPeche()
        else
            if next(PlayersInJob) then
                TriggerServerEvent("core:activities:kickPlayers", PlayersId, "peche")
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'êtes pas en service de pêche"
                })
            end
        end
    elseif data.button == "removePlayer" then
        local playerSe = data.selected
        TriggerServerEvent("core:activities:SelectedKickPlayer", playerSe, "peche")
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
            local closestPlayer = ChoicePlayersInZone(5.0)
            if closestPlayer == nil then
                return
            end
            if closestPlayer == PlayerId() then return end
            local sID = GetPlayerServerId(closestPlayer)
            TriggerServerEvent("core:activities:askJob", sID, "Pêcheur")
        end
    end
end)

function AddTenuePeche()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 1)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 90)
        SkinChangeFake("pants_2",0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 20)
        SkinChangeFake("helmet_2", 1)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 73)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 14)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 93)
        SkinChangeFake("pants_2", 1)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 21)
        SkinChangeFake("helmet_2", 2)
    end
end

function RemoveTenuePeche()
    local playerSkin = p:skin()
    ApplySkin(playerSkin)
end

function StopJobPeche()
    --if service then
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez ~s arrêté ~c de pêcher"
        })
        PecheOuvert = false
        onMissionFinished()
        exports['tuto-fa']:HideStep()
        RemoveBlip(blipRadiusGreen)
        RemoveBlip(blipsDespawn)
        RemoveBlip(blipsred)
        service = false
        veh = nil
        missionStart = false
        posGreen = nil
        posRed = nil
        inPeche = false
        service = false
        TriggerServerEvent("core:SellPecheur", token)
        
        poissonsPeche = 0
        hasShownFinished = false
        RemoveTenuePeche()
        DeleteVehicle(GetVehiclePedIsIn(p:ped()))
        DeleteEntity(GetVehiclePedIsIn(p:ped()))
        TriggerServerEvent("core:SellPecheur", token)
        if veh ~= nil then
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
            TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
            DeleteEntity(veh)
        end
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        Wait(200)
        blipRadiusGreen = nil
        blipsred = nil
        blipsDespawn = nil
    --end
end

RegisterNetEvent("core:activities:create", function(typejob, players)
    if typejob == "peche" then 
        AddTenuePeche()
    end
    PlayersId = players
end)

RegisterNetEvent("core:activities:update", function(typejob, data, src)
    if src ~= GetPlayerServerId(PlayerId()) then
        if typejob == "peche" then 
            service = false
            TakePecheurService(0, data)
        end
    end
end)

RegisterNetEvent("core:activities:kickPlayer", function(typejob, info)
    if typejob == "peche" then 
        StopJobPeche()
        PlayersInJob = {
            { name = p:getFirstname(), id = GetPlayerServerId(PlayerId()) }
        }
        if info and info.pos then 
            SetEntityCoords(PlayerPedId(), info.pos)
        end
    end
end)

RegisterNetEvent("core:activities:acceptedJob", function(ply, pname)
    table.insert(PlayersInJob, {name = pname, id = ply})
end)

RegisterNetEvent("core:useRod", function()
    HasRod = not HasRod
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7peche ^3loaded")
end)