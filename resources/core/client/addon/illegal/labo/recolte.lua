local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

ActivateDrugRecolte = true

local DrugsRecolte = {
    Weed = {
        typeGroup = "gang",
        item = "grainecannabis",
        Plants = {
            vector3(1027.4809570313, -1834.759765625,  31.454067230225 - 3.0),
            vector3(1029.7799072266, -1836.5825195313, 31.346210479736 - 3.0),
            vector3(1030.9749755859, -1839.1856689453, 30.969820022583 - 3.0),
            vector3(1024.6096191406, -1838.3602294922, 31.133678436279 - 3.0),
            vector3(1024.3204345703, -1835.9478759766, 31.352474212646 - 3.0),
            vector3(1026.4094238281, -1833.2310791016, 31.534797668457 - 3.0),
            vector3(1027.8707275391, -1829.9971923828, 31.812030792236 - 3.0),
            vector3(1029.9421386719, -1829.2951660156, 31.978672027588 - 3.0),
        },
        Props = {
            "bkr_prop_weed_lrg_01b",
            "bkr_prop_weed_lrg_01b",
            "bkr_prop_weed_med_01b",
        }
    },
    Fentanyl = {
        typeGroup = "mc",
        item = "pavosomnifere",
        Plants = {
            -- Sud
            vector3(3300.7299804688, -130.58518981934, 13.517362594604),
            vector3(3298.3139648438, -131.00796508789, 13.434408187866),
            vector3(3299.0859375, -128.5004119873, 13.142456054688),
            vector3(3301.8688964844, -127.81659698486, 13.21166229248),
            vector3(3300.3962402344, -127.01670074463, 13.043619155884),
            vector3(3302.3332519531, -125.80640411377, 12.902609825134),
            vector3(3299.7390136719, -135.15205383301, 13.947853088379),
            vector3(3297.2563476562, -134.12155151367, 13.708131790161),

            -- Nord
            vector3(-2185.8427734375, 5219.9311523438, 20.968967437744),
            vector3(-2183.5795898438, 5220.6401367188, 21.039615631104),
            vector3(-2182.0266113281, 5218.3364257812, 20.494630813599),
            vector3(-2184.1518554688, 5217.3051757812, 20.673725128174),
            vector3(-2186.4086914062, 5216.8627929688, 20.360525131226),
            vector3(-2185.5241699219, 5214.9545898438, 20.225742340088),
            vector3(-2183.3381347656, 5215.060546875, 20.273565292358),
            vector3(-2181.1354980469, 5216.0473632812, 20.106622695923),
        },
        Props = "prop_cat_tail_01",
    },
    Cocaine = {
        typeGroup = "orga",
        item = "feuilledecoca",
        Plants = {
            -- Sud
            vector3(-2930.0524902344, 442.94485473633, 16.952787399292),
            vector3(-2933.4951171875, 446.89068603516, 16.435426712036),
            vector3(-2931.3139648438, 447.46493530273, 16.759662628174),
            vector3(-2932.0031738281, 446.04223632812, 16.655920028687),
            vector3(-2928.9624023438, 445.74526977539, 17.148330688477),
            vector3(-2933.6779785156, 441.73510742188, 16.481136322021),
            vector3(-2935.98046875, 442.05621337891, 16.10214805603),
            vector3(-2938.423828125, 441.62033081055, 15.498031616211),

            -- Nord
            vector3(561.49731445312, 2652.5874023438, 41.147350311279),
            vector3(561.84576416016, 2653.7495117188, 41.141910552979),
            vector3(561.20660400391, 2655.7175292969, 41.144584655762),
            vector3(560.90521240234, 2657.8994140625, 41.143432617188),
            vector3(560.31658935547, 2653.1726074219, 41.159126281738),
            vector3(559.61108398438, 2654.5361328125, 41.163082122803),
            vector3(557.94757080078, 2654.3713378906, 41.179035186768),
            vector3(557.87689208984, 2655.8740234375, 41.176700592041),
        },
        Props = "prop_plant_fern_02a",
    },
    Meth = {
        typeGroup = "mafia",
        item = "phenylacetone",
        Plants = {
            vector3(403.57800292969, 64.869995117188, 96.977920532227),
            vector3(404.28726196289, 64.526000976562, 96.977920532227),
            vector3(405.4856262207, 64.036796569824, 96.977920532227),
            vector3(404.91326904297, 63.322563171387, 96.977920532227),
            vector3(404.02172851562, 63.448471069336, 96.977920532227),
            vector3(403.13787841797, 64.077392578125, 96.977920532227),
            vector3(402.75079345703, 63.340747833252, 96.977920532227),
            vector3(404.34365844727, 62.604709625244, 96.977920532227),

            -- Nord
            vector3(1406.0651855469, 3620.5222167969, 38.000793457031),
            vector3(1405.0604248047, 3620.1530761719, 38.000755310059),
            vector3(1403.9814453125, 3619.8947753906, 38.000755310059),
            vector3(1403.2108154297, 3619.6369628906, 38.000755310059),
            vector3(1406.1597900391, 3619.8566894531, 38.000755310059),
            vector3(1406.4765625, 3619.0295410156, 38.000755310059),
            vector3(1406.6970214844, 3618.3828125, 38.000755310059),
            vector3(1406.9820556641, 3617.8063964844, 38.000755310059),
        },
        Props = "bkr_prop_meth_phosphorus",
    },
}


local Plants = {}
local PlantsTwo = {}
local PlantsThree = {}
local PlantsFour = {}
local inRecolte = false
local function StartRecolteWeed(plantid, index, item, vecto, newvec)
    local finsihed = false
    local entityModel = GetEntityModel(plantid.plant)
    inRecolte = true
    local playerPed = PlayerPedId()
    local p1 = GetEntityCoords(plantid.plant, true)
    local p2 = GetEntityCoords(playerPed, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(playerPed, heading-180)
    Wait(50)
    RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
    while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do 
        Wait(1)
    end
    TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
    Wait(6000)
    local coordsPlantx, coordsPlanty, coordsPlantz = table.unpack(GetEntityCoords(plantid.plant))
    local headingPlant = GetEntityHeading(headingPlant)
    coordsPlant = vector3(coordsPlantx, coordsPlanty, coordsPlantz)
    --print(vector3(coordsPlantx, coordsPlanty, coordsPlantz))
    NetworkRequestControlOfEntity(plantid.plant)
    local timer = 1
    while not NetworkHasControlOfEntity(plantid.plant) do 
        Wait(1) 
        timer += 1
        if timer > 600 then 
            break
        end
    end
    SetEntityAlpha(plantid.plant, 0, 0)
    DeleteObject(plantid.plant)
    DeleteEntity(plantid.plant)
    -- give weed
    ClearPedTasks(PlayerPedId())
    if not Plants[index].second and not Plants[index].third then
        local obj = GetClosestObjectOfType(GetEntityCoords(p:ped()), 0.5, GetHashKey("bkr_prop_weed_lrg_01b"), 1)
        if obj ~= 0 then 
            NetworkRequestControlOfEntity(obj)
            local timer = 1
            while not NetworkHasControlOfEntity(obj) do 
                Wait(1) 
                timer += 1
                if timer > 600 then 
                    break
                end
            end
            SetEntityAlpha(obj, 0, 0)
            DeleteObject(obj)
            DeleteEntity(obj)
        end
        print("SECOND")
        Plants[index] = {plant=CreateObject(GetHashKey(DrugsRecolte["Weed"].Props[2]), newvec - vector3(0.0, 0.0, 1.0), true, false, true)}
        FreezeEntityPosition(Plants[index].plant, true)
        SetEntityAsMissionEntity(Plants[index].plant, true)
        Plants[index].second = true
        print(" go update -2")
        Bulle.remove("plantWeed" .. index)
        Wait(100)
        Bulle.create("plantWeed" .. index, vecto + vector3(0.0, 0.0, -1.0), "bulleRecolterWeed", true)
    elseif Plants[index] and Plants[index].second then 
        print("THIRD")
        finsihed = true
        Plants[index] = {plant=CreateObject(GetHashKey(DrugsRecolte["Weed"].Props[3]), vector3(coordsPlantx, coordsPlanty, coordsPlantz-1.6), true, false, true)}
        FreezeEntityPosition(Plants[index].plant, true)
        SetEntityAsMissionEntity(Plants[index].plant, true)
        Plants[index].second = nil
        Plants[index].third = true
        Bulle.remove("plantWeed" .. index)
        Wait(100)
        Bulle.create("plantWeed" .. index, vecto + vector3(0.0, 0.0, -1.0), "bulleRecolterWeed", true)
    else
        print("DETECT FINI")
        Plants[index].finished = true
    end
    TriggerSecurGiveEvent("core:addItemToInventory", token, item, 2, {})
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = ("Vous avez récupéré ~s 2 graines de cannabis")
    })

    if Plants[index].finished then 
        print("FINISHED")
        Bulle.remove("plantWeed" .. index)
        zone.removeZone("plantWeed" .. index)
        zone.removeZone("plantWeed2" .. index)
    end
    print("finsihed", finsihed)
    Plants[index].finished = finsihed

    inRecolte = false
end

local function StartRecolteFantanyl(plantid, index, item)
    inRecolte = true
    RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
    while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do 
        Wait(1)
    end
    TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
    Wait(6000)
    local obj = GetClosestObjectOfType(GetEntityCoords(p:ped()), 0.5, GetHashKey("prop_cat_tail_01"), 1)
    if obj ~= 0 then 
        NetworkRequestControlOfEntity(obj)
        while not NetworkHasControlOfEntity(obj) do Wait(1) end
        SetEntityAlpha(obj, 0, 0)
        DeleteObject(obj)
        DeleteEntity(obj)
    end
    NetworkRequestControlOfEntity(plantid)
    local timer = 1
    while not NetworkHasControlOfEntity(plantid) do 
        Wait(1) 
        timer += 1
        if timer > 600 then 
            break
        end
    end
    SetEntityAlpha(plantid, 0, 0)
    DeleteObject(plantid)
    DeleteEntity(plantid)
    ClearPedTasks(PlayerPedId())
    TriggerSecurGiveEvent("core:addItemToInventory", token, item, 6, {})
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = ("Vous avez récupéré ~s 6 pavots somnifères")
    })
    Bulle.remove("plantFentanyl" .. index)
    zone.removeZone("plantFentanyl" .. index)
    inRecolte = false
end

local function StartRecolteCoke(plantid, index, item)
    inRecolte = true
    RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
    while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do 
        Wait(1)
    end
    TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
    Wait(6000)
    local obj = GetClosestObjectOfType(GetEntityCoords(p:ped()), 0.5, GetHashKey("prop_plant_fern_02a"), 1)
    if obj ~= 0 then 
        NetworkRequestControlOfEntity(obj)
        local timer = 1
        while not NetworkHasControlOfEntity(obj) do 
            Wait(1) 
            timer += 1
            if timer > 600 then 
                break
            end
        end
        SetEntityAlpha(obj, 0, 0)
        DeleteObject(obj)
        DeleteEntity(obj)
    end
    NetworkRequestControlOfEntity(plantid)
    local timer = 1
    while not NetworkHasControlOfEntity(plantid) do 
        Wait(1) 
        timer += 1
        if timer > 600 then 
            break
        end
    end
    SetEntityAlpha(plantid, 0, 0)
    DeleteObject(plantid)
    DeleteEntity(plantid)
    ClearPedTasks(PlayerPedId())
    TriggerSecurGiveEvent("core:addItemToInventory", token, item, 6, {})
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = ("Vous avez récupéré ~s 6 feuilles de coca")
    })
    Bulle.remove("plantCocke" .. index)
    zone.removeZone("plantCocke" .. index)
    inRecolte = false
end

RegisterNetEvent("core:block:recolte", function(index, item, source)
    if GetPlayerServerId(PlayerId()) ~= source then
        if item == "phenylacetone" then
            Bulle.remove("plantMeth" .. index)
            zone.removeZone("plantMeth" .. index)
        elseif item == "feuilledecoca" then
            Bulle.remove("plantCocke" .. index)
            zone.removeZone("plantCocke" .. index)
        elseif item == "pavosomnifere" then
            Bulle.remove("plantFentanyl" .. index)
            zone.removeZone("plantFentanyl" .. index)
        elseif item == "grainecannabis" then
            Bulle.remove("plantWeed" .. index)
            zone.removeZone("plantWeed" .. index)
            zone.removeZone("plantWeed2" .. index)
        end
    end
end)

local function StartRecolteMeth(plantid, index, item)
    inRecolte = true
    RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
    while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do 
        Wait(1)
    end
    TriggerServerEvent("core:block:recolte", index, item)
    TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
    Wait(6000)
    local obj = GetClosestObjectOfType(GetEntityCoords(p:ped()), 0.5, GetHashKey("bkr_prop_meth_phosphorus"), 1)
    if obj ~= 0 then 
        NetworkRequestControlOfEntity(obj)
        local timer = 1
        while not NetworkHasControlOfEntity(obj) do 
            Wait(1) 
            timer += 1
            if timer > 600 then 
                break
            end
        end
        SetEntityAlpha(obj, 0, 0)
        DeleteObject(obj)
        DeleteEntity(obj)
    end
    NetworkRequestControlOfEntity(plantid)
    local timer = 1
    while not NetworkHasControlOfEntity(plantid) do 
        Wait(1) 
        timer += 1
        if timer > 600 then 
            break
        end
    end
    SetEntityAlpha(plantid, 0, 0)
    DeleteObject(plantid)
    DeleteEntity(plantid)
    ClearPedTasks(PlayerPedId())
    TriggerSecurGiveEvent("core:addItemToInventory", token, item, 6, {})
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = ("Vous avez récupéré ~s 6 bidons")
    })
    Bulle.remove("plantMeth" .. index)
    zone.removeZone("plantMeth" .. index)
    inRecolte = false
end

function RemoveAllPlants()
    for k,v in pairs(DrugsRecolte) do 
        if k == "Weed" then 
            for t, cooplant in pairs(v.Plants) do 
                zone.removeZone("plantWeed" .. t)
                zone.removeZone("plantWeed2" .. t)
                if Plants[t] then
                    if type(Plants[t]) == "table" and Plants[t].plant then 
                        if DoesEntityExist(Plants[t].plant) then 
                            DeleteEntity(Plants[t].plant)
                        end
                    end
                end
            end
        end
        if k == "Fentanyl" then 
            for t, cooplant in pairs(v.Plants) do 
                zone.removeZone("plantFentanyl" .. t)
                if PlantsTwo[t] then 
                    if type(PlantsTwo[t]) == "table" and PlantsTwo[t].plant then 
                        if DoesEntityExist(PlantsTwo[t].plant) then 
                            DeleteEntity(PlantsTwo[t].plant)
                        end
                    end
                end
            end
        end
        if k == "Cocaine" then 
            for t, cooplant in pairs(v.Plants) do 
                zone.removeZone("plantCocke" .. t)
                if PlantsThree then 
                    if PlantsThree[t] then 
                        if type(PlantsThree[t]) == "table" and PlantsThree[t].plant then 
                            if DoesEntityExist(PlantsThree[t].plant) then 
                                DeleteEntity(PlantsThree[t].plant)
                            end
                        end
                    end
                end
            end
        end
        if k == "Meth" then 
            for t, cooplant in pairs(v.Plants) do 
                zone.removeZone("plantMeth" .. t)
                if PlantsFour then 
                    if PlantsFour[t] then 
                        if type(PlantsFour[t]) == "table" and PlantsFour[t].plant then 
                            if DoesEntityExist(PlantsFour[t].plant) then 
                                DeleteEntity(PlantsFour[t].plant)
                            end
                        end
                    end
                end
            end
        end
    end
end

function CheckCreateAllPlants()
    local needPlants = TriggerServerCallback("core:shouldCreatePlantsRecolt")
    if needPlants then 
        RemoveAllPlants()
        CreateAllPlants()
    end
end

function CreateAllPlants()
    for k,v in pairs(DrugsRecolte) do 
        if k == "Weed" then 
            if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getCrewType() == v.typeGroup then
                for t, cooplant in pairs(v.Plants) do 
                    Plants[t] = {plant = CreateObject(GetHashKey(v.Props[1]), cooplant, false, false, false)}
                    FreezeEntityPosition(Plants[t].plant, true)
                    SetEntityAsMissionEntity(Plants[t].plant, true)
                    zone.addZone("plantWeed" .. t,
                        cooplant +  vector3(0.0, 0.0, 5.45),
                        "~INPUT_CONTEXT~ Récolter la plante",
                        function()
                            --if not inRecolte then
                            --    StartRecolteWeed(Plants[t], t, v.item)
                            --end
                        end, false,
                        27,
                        0.5,
                        { 255, 255, 255 },
                        170,
                        1.5,
                        true,
                        "bulleRecolterWeed"
                    )
                    zone.addZone("plantWeed2" .. t,
                        cooplant +  vector3(0.0, 0.0, 3.0),
                        nil,
                        function()
                            if not inRecolte then
                                inRecolte = true
                                print("go in", Plants[t])
                                StartRecolteWeed(Plants[t], t, v.item, cooplant + vector3(0.0, 0.0, 5.45), cooplant)
                            end
                        end, false,
                        27,
                        0.3,
                        { 255, 255, 255 }
                    )
                end
            end
        end
        if k == "Fentanyl" then 
            if (p:getJob() == "lspd" or p:getJob() == "lssd") or p:getCrewType() == v.typeGroup then
                for t, cooplant in pairs(v.Plants) do 
                    PlantsTwo[t] = CreateObject(GetHashKey(v.Props), cooplant + vector3(0.0, 0.0, -0.45), false, false, false)
                    FreezeEntityPosition(PlantsTwo[t], true)
                    SetEntityAsMissionEntity(PlantsTwo[t], true)
                    zone.addZone("plantFentanyl" .. t,
                        cooplant + vector3(0.0, 0.0, 1.3),
                        "~INPUT_CONTEXT~ Récolter la plante",
                        function()
                            if not inRecolte then
                                StartRecolteFantanyl(PlantsTwo[t], t, v.item)
                            end
                        end, false,
                        27,
                        0.5,
                        { 255, 255, 255 },
                        170,
                        1.5,
                        true,
                        "bulleRecolteFentanyl"
                    )
                end
            end
        end
        if k == "Cocaine" then 
            if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getCrewType() == v.typeGroup then
                for t, cooplant in pairs(v.Plants) do 
                    PlantsThree[t] = CreateObject(GetHashKey(v.Props), cooplant + vector3(0.0, 0.0, 0.0), false, false, false)
                    FreezeEntityPosition(PlantsThree[t], true)
                    SetEntityAsMissionEntity(PlantsThree[t], true)
                    zone.addZone("plantCocke" .. t,
                        cooplant + vector3(0.0, 0.0, 1.75),
                        "~INPUT_CONTEXT~ Récolter la plante",
                        function()
                            if not inRecolte then
                                StartRecolteCoke(PlantsThree[t], t, v.item)
                            end
                        end, false,
                        27,
                        0.5,
                        { 255, 255, 255 },
                        170,
                        1.5,
                        true,
                        "bulleRecolteCoca"
                    )
                end
            end
        end
        if k == "Meth" then 
            if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getCrewType() == v.typeGroup then
                for t, cooplant in pairs(v.Plants) do 
                    PlantsFour[t] = CreateObject(GetHashKey(v.Props), cooplant + vector3(0.0, 0.0, 0.0), false, false, false)
                    FreezeEntityPosition(PlantsFour[t], true)
                    SetEntityAsMissionEntity(PlantsFour[t], true)
                    zone.addZone("plantMeth" .. t,
                        cooplant + vector3(0.0, 0.0, 1.0),
                        "~INPUT_CONTEXT~ Récolter le bidon",
                        function()
                            if not inRecolte then
                                StartRecolteMeth(PlantsFour[t], t, v.item)
                            end
                        end, false,
                        27,
                        0.5,
                        { 255, 255, 255 },
                        170,
                        1.5,
                        true,
                        "bulleRecolteBidon"
                    )
                end
            end
        end
    end
end

RegisterNetEvent("core:createAllPlants", function()
    while not p do Wait(500) end
    RemoveAllPlants()
    CreateAllPlants()
end)