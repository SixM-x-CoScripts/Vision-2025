local ListContextAssis = {
    "PROP_HUMAN_SEAT_DECKCHAIR",
    "PROP_HUMAN_SEAT_BUS_STOP_WAIT",
    "PROP_HUMAN_SEAT_BENCH",
    "PROP_HUMAN_SEAT_ARMCHAIR",
}

local assis = false
local actualSitChair = 3
function Sitbench(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    if GetEntityModel(entity) == -634790943 then
        heading = -40.0
    end
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 or 
        GetEntityModel(entity) == -110460483 then
        offset = 0.0
    end
    if GetEntityModel(entity) == -552026043 then
        offset = 0.9
    end
    if entity ~= nil then
        if IsPedActiveInScenario(pPed) then
            ClearPedTasks(pPed)
            TaskStartScenarioAtPosition(pPed, "PROP_HUMAN_SEAT_BENCH", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        else
            local ped = GetClosestPed2(entityCoords.x, entityCoords.y, entityCoords.z, 0.4)
            if ped ~= 0 and ped ~= PlayerPedId() then 
                local offset2 = GetOffsetFromEntityInWorldCoords(ped, 0.5, 0.0, 0.0)
                TaskStartScenarioAtPosition(pPed, "PROP_HUMAN_SEAT_BENCH", offset2.x, offset2.y, offset2.z,
                    GetEntityHeading(entity) + heading, 0, true, true)
            else
                TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BENCH", entityCoords.x, entityCoords.y,
                    entityCoords.z + offset,
                    GetEntityHeading(entity) + heading, 0, true, true)
            end
            local switching = false
            CreateThread(function()
                while not IsPedActiveInScenario(pPed) do Wait(500) end 
                while IsPedActiveInScenario(pPed) or switching do
                    Wait(1) 
                    if not assis then 
                        break
                    end
                    ShowHelpNotification("~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ Positions")
                    DisableCamCollisionForEntity(entity)
                    if IsControlJustPressed(0,174) then 
                        if actualSitChair-1 == 0 or not ListContextAssis[actualSitChair-1] then
                            actualSitChair = #ListContextAssis+1
                        end
                        print(actualSitChair, ListContextAssis[actualSitChair-1])
                        switching = true
                        TaskStartScenarioAtPosition(p:ped(), ListContextAssis[actualSitChair-1], entityCoords.x, entityCoords.y,
                            entityCoords.z + offset,
                            GetEntityHeading(entity) + heading, 0, true, true)
                        actualSitChair -= 1
                    end
                    if IsControlJustPressed(0, 175) then 
                        if not ListContextAssis[actualSitChair+1] then
                            actualSitChair = 0
                        end
                        switching = true
                        print(actualSitChair, ListContextAssis[actualSitChair+1])
                        TaskStartScenarioAtPosition(p:ped(), ListContextAssis[actualSitChair+1], entityCoords.x, entityCoords.y,
                            entityCoords.z + offset,
                            GetEntityHeading(entity) + heading, 0, true, true)
                        actualSitChair += 1
                    end
                end
            end)
        end
    end
end

function SitbenchMBA(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0
    local heading = 180.0
    if GetEntityModel(entity) == -634790943 then
        heading = -40.0
    end
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsPedActiveInScenario(pPed) then
            ClearPedTasks(pPed)
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BENCH", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        else
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BENCH", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
end

function SitbenchBeauF(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    if GetEntityModel(entity) == -634790943 then
        heading = -40.0
    end
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsPedActiveInScenario(pPed) then
            ClearPedTasks(pPed)
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_DECKCHAIR", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        else
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_DECKCHAIR", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
end

function SitbenchWait(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    if GetEntityModel(entity) == -634790943 then
        heading = -40.0
    end
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 or 
        GetEntityModel(entity) == -110460483 then
        offset = 0.0
    end
    if GetEntityModel(entity) == -552026043 then
        offset = 0.9
    end
    if entity ~= nil then
        if IsPedActiveInScenario(pPed) then
            ClearPedTasks(pPed)
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BUS_STOP_WAIT", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        else
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BUS_STOP_WAIT", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
end

function SitbenchWaitMBA(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0
    local heading = 180.0
    if GetEntityModel(entity) == -634790943 then
        heading = -40.0
    end
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsPedActiveInScenario(pPed) then
            ClearPedTasks(pPed)
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BUS_STOP_WAIT", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        else
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_BUS_STOP_WAIT", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
end

function SitbenchWithChill(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    if GetEntityModel(entity) == -634790943 then
        heading = 0.0
    end
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsPedActiveInScenario(pPed) then
            ClearPedTasks(pPed)
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_ARMCHAIR", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        else
            TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_ARMCHAIR", entityCoords.x, entityCoords.y,
                entityCoords.z + offset,
                GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
end

function StopAnim(entity)
    ClearPedTasks(p:ped())
    exports['tuto-fa']:HideStep()
end

-- crun entity:CreateObject(1631638868,GetEntityCoords(PlayerPedId())-vector(0.0,0.0,1.0))
function StartHealingProcess(dict, anim)
    OpenTutoFAInfo("Hopital", "Restez allongé pour vous faire soigner")
    while not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) do 
        Wait(500)
    end
    CreateThread(function()
        while IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) do 
            Wait(30000)
            local health = GetEntityHealth(PlayerPedId())
            SetEntityHealth(PlayerPedId(), health + 5)
        end
        exports['tuto-fa']:HideStep()
    end)
end

-- CreateThread(function()
--     while true do 
--         Wait(1)
--         local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 20.0, 1573503690, 1)
--         local obj2 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 20.0, 1004440924, 1)
--         local obj3 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 20.0, -1544802998, 1)
--         local obj4 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 20.0, 2117668672, 1)
--         local obj5 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 20.0, 1631638868, 1)
--         local obj6 = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 20.0, 1570477186, 1)
--         if obj or obj2 or obj3 or obj4 or obj5 or obj6 then 
--             local coord = GetEntityCoords(obj and obj or obj2 and obj2 or obj3 and obj3 or obj4 and obj4 or obj5 and obj5 or obj6 and obj6)
--             Bulle.create("litHopital", coord + vector3(0.0, 0.0, 1.15), "bulleSoigner", true)
--         end
--     end
-- end)

function SleepOnHospital(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    local rot = GetEntityRotation(entity)
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsEntityPlayingAnim(pPed, "combat@damage@writheidle_c", "writhe_idle_g") then
            ClearPedTasks(pPed)

            RequestAnimDict("combat@damage@writheidle_c")
            while not HasAnimDictLoaded("combat@damage@writheidle_c") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), 'combat@damage@writheidle_c', "writhe_idle_g", 8.0, -8.0, -1, 1, 0, false, false, false)
        else
            RequestAnimDict("combat@damage@writheidle_c")
            while not HasAnimDictLoaded("combat@damage@writheidle_c") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), 'combat@damage@writheidle_c', "writhe_idle_g", 8.0, -8.0, -1, 1, 0, false, false, false)
            -- TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_ARMCHAIR", entityCoords.x, entityCoords.y,
            --     entityCoords.z + offset,
            --     GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
    StartHealingProcess("combat@damage@writheidle_c", "writhe_idle_g")
end

function SleepOnHospitalDos(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    local rot = GetEntityRotation(entity)
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 or GetEntityModel(entity) == 1580642483 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsEntityPlayingAnim(pPed, "switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_girl") then
            ClearPedTasks(pPed)

            RequestAnimDict("switch@trevor@annoys_sunbathers")
            while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1
                , 0, false, false, false)
        else
            RequestAnimDict("switch@trevor@annoys_sunbathers")
            while not HasAnimDictLoaded("switch@trevor@annoys_sunbathers") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), 'switch@trevor@annoys_sunbathers', "trev_annoys_sunbathers_loop_girl", 8.0, -8.0, -1, 1
                , 0, false, false, false)
            -- TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_ARMCHAIR", entityCoords.x, entityCoords.y,
            --     entityCoords.z + offset,
            --     GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
    StartHealingProcess("switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_girl")
end

function SleepOnHospitalVentre(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    local rot = GetEntityRotation(entity)
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsEntityPlayingAnim(pPed, "missheist_jewel", "2b_guard_onfloor_loop") then
            ClearPedTasks(pPed)

            RequestAnimDict("missheist_jewel")
            while not HasAnimDictLoaded("missheist_jewel") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) - 40.0))

            TaskPlayAnim(p:ped(), "missheist_jewel", "2b_guard_onfloor_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
        else
            RequestAnimDict("missheist_jewel")
            while not HasAnimDictLoaded("missheist_jewel") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) - 40.0))

            TaskPlayAnim(p:ped(), "missheist_jewel", "2b_guard_onfloor_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
            -- TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_ARMCHAIR", entityCoords.x, entityCoords.y,
            --     entityCoords.z + offset,
            --     GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
    StartHealingProcess("missheist_jewel", "2b_guard_onfloor_loop")
end

function SleepOnHospitalHeartAttack(entity)
    local pPed = p:ped()
    local pPos = p:pos()
    local entityCoords = GetEntityCoords(entity)
    local offset = 0.5
    local heading = 180.0
    local rot = GetEntityRotation(entity)
    if GetEntityModel(entity) == -171943901 or GetEntityModel(entity) == -829283643 or
        GetEntityModel(entity) == -634790943 then
        offset = 0.0
    end
    if entity ~= nil then
        if IsEntityPlayingAnim(pPed, "anim@heists@prison_heistig_5_p1_rashkovsky_idle", "idle_180") then
            ClearPedTasks(pPed)

            RequestAnimDict("anim@heists@prison_heistig_5_p1_rashkovsky_idle")
            while not HasAnimDictLoaded("anim@heists@prison_heistig_5_p1_rashkovsky_idle") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), "anim@heists@prison_heistig_5_p1_rashkovsky_idle", "idle_180", 8.0, -8.0, -1, 1, 0,
                false, false, false)
        else
            RequestAnimDict("anim@heists@prison_heistig_5_p1_rashkovsky_idle")
            while not HasAnimDictLoaded("anim@heists@prison_heistig_5_p1_rashkovsky_idle") do Wait(1) end

            SetEntityCoords(p:ped(), entityCoords.x, entityCoords.y, entityCoords.z + 0.5)
            SetEntityHeading(p:ped(), (GetEntityHeading(entity) + 180.0))

            TaskPlayAnim(p:ped(), "anim@heists@prison_heistig_5_p1_rashkovsky_idle", "idle_180", 8.0, -8.0, -1, 1, 0,
                false, false, false)
            -- TaskStartScenarioAtPosition(p:ped(), "PROP_HUMAN_SEAT_ARMCHAIR", entityCoords.x, entityCoords.y,
            --     entityCoords.z + offset,
            --     GetEntityHeading(entity) + heading, 0, true, true)
        end
    end
end

local Banc = {
    -628719744,
    -99500382,
    1805980844,
    -1317098115,
    -2021659595,
    1037469683,
    -741944541,
    725259233,
    525667351,
    764848282,
    146905321,
    276029927,
    784932497,
    -1173315865,
    -721037220,
    536071214,
    -523951410,
    -881696544,
    1339364336,
    867556671,
    -171943901,
    -109356459,
    1580642483,
    377849416,
    -1281587804,
    -829283643,
    -634790943,
    444105316,
    696509779,
    -1062810675,
}

local function CheckBenchPossibility()
    local pPed = p:ped()
    if IsPedActiveInScenario(pPed) or IsPedPlayingBaseClipInScenario(pPed) or assis then
        ClearPedTasks(pPed)
        assis = false
        return
    end
    for k,v in pairs(Banc) do 
        local obj = GetClosestObjectOfType(GetEntityCoords(pPed), 0.65, v, true)
        if obj ~= 0 then 
            assis = true
            Sitbench(obj)
        end
    end
end

Keys.Register("E", "E", "Intéragir avec l'environnement", function()
    local pPed = p:ped()
    if IsPedInAnyVehicle(pPed) then return end
    if IsPlayerPlaying(pPed) then return end
    CheckBenchPossibility()
    Wait(500)
end)