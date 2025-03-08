local token = nil
local canLoadLabo = true
local InsideLabo = false

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

-- In ACTION
-- {"PosWork":"null","coords":{"z":29.29220962524414,"y":-1428.5531005859376,"x":105.83672332763672},"blocked":false,"percentages":[96.0,96.0,96.0],"minutes":1,"maxTime":90,"quantityDrugs":180,"state":1}

-- Finished
-- {"state":2,"blocked":false,"PosWork":"null","quantityDrugs":105,"minutes":0,"coords":{"z":29.29220962524414,"y":-1428.5531005859376,"x":105.83672332763672},"maxTime":90,"percentages":[1.0,1.0,1.0]}

local MaxTimeProd = 120
local IsInProduction = false
local CrewLevel
local LaboQuantity
local LaboQuantityDrug
local LaboWeedStatus = 0
local LaboProduction
IsCloseToLabo = false -- ## item dynamite
local LaboCrewLevel
local LaboState
local LaboType
local LaboItemsNeeded = {}
MaxTimeProductions = {
    --[0] = 120,
    --[1] = 120,
    --[2] = 120,
    --[3] = 120,
    --[4] = 105,
    --[5] = 90,
    [0] = 70,
    [1] = 70,
    [2] = 70,
    [3] = 70,
    [4] = 60,
    [5] = 45,
}
GoodNames = {
    ["eaudechaux"] = "Eau de chaux",
    ["feuilledecoca"] = "Feuilles de coca",
    ["acidesulfurique"] = "Acide sulfurique",
    ["engrais"] = "Engrais",
    ["fertilisant"] = "Fertilisant",
    ["grainecannabis"] = "Graines de cannabis",
    ["ephedrine"] = "Ephedrine",
    ["methylamine"] = "Methylamine",
    ["phenylacetone"] = "Phenylacetone",
    ["pavosomnifere"] = "Pavo somnifère",
    ["chlorureammonium"] = "Chlorure Ammonium",
    ["anhydrideacetique"] = "Anhydride Acetique",
    ["kerosene"] = "Kerosène",
    ["feuilledeweed"] = "Feuille de Weed" -- <3
}

local posLaboratory = {
    ["coke"] = {
        type = "Cocaine",
        entrance = vector3(1088.7307128906, -3187.763671875, -38.993450164795),
        gestion = vector3(1087.243, -3198.13, -38.993431091309),
        production = vector3(1087.3186035156, -3194.1750488281, -38.993431091309),
        ItemsNeeded = {
            "kerosene",
            "feuilledecoca",
            "acidesulfurique",
        },
        itemgive = "coke",
    },
    ["weed"] = {
        type = "Weed",
        entrance = vector3(1066.2290039063, -3183.3837890625, -39.163497924805),
        gestion = vector3(1044.5041503906, -3194.7421875, -38.158142089844),
        production = vector3(1044.4807128906, -3196.7629394531, -38.157634735107),
        weedState = {
            small = {
                "weed_growtha_stage1",
                "weed_growthb_stage1",
                "weed_growthc_stage1",
                "weed_growthd_stage1",
                "weed_growthe_stage1",
                "weed_growthf_stage1",
                "weed_growthg_stage1",
                "weed_growthh_stage1",
                "weed_growthi_stage1",
            },
            medium = {
                "weed_growtha_stage2",
                "weed_growthb_stage2",
                "weed_growthc_stage2",
                "weed_growthd_stage2",
                "weed_growthe_stage2",
                "weed_growthf_stage2",
                "weed_growthg_stage2",
                "weed_growthh_stage2",
                "weed_growthi_stage2",
            },
            full = {
                "weed_growtha_stage3",
                "weed_growthb_stage3",
                "weed_growthc_stage3",
                "weed_growthd_stage3",
                "weed_growthe_stage3",
                "weed_growthf_stage3",
                "weed_growthg_stage3",
                "weed_growthh_stage3",
                "weed_growthi_stage3",
            }
        },
        ItemsNeeded = {
            "fertilisant",
            "grainecannabis",
            "engrais",
        },
        itemgive = "weed",
    },
    ["meth"] = {
        type = "Meth",
        entrance = vector3(997.18542480469, -3200.7912597656, -36.39368057251),
        gestion = vector3(1003.7327270508, -3195.0615234375, -38.993125915527),
        production = vector3(1001.4822998047, -3194.8959960938, -38.993148803711),
        ItemsNeeded = {
            "ephedrine",
            "methylamine",
            "phenylacetone",
        },
        itemgive = "meth",
    },
    ["fentanyl"] = {
        type = "Fentanyl",
        entrance = vector3(997.18542480469, -3200.7912597656, -36.39368057251),
        gestion = vector3(1003.7327270508, -3195.0615234375, -38.993125915527),
        production = vector3(1001.4822998047, -3194.8959960938, -38.993148803711),
        ItemsNeeded = {
            "pavosomnifere",
            "chlorureammonium",
            "anhydrideacetique",
        },
        itemgive = "fentanyl",
    },
}

--RegisterCommand("startProcess", function()
--    print("cocaine, id =", InsideLabo)
--    CreateLaboPeds("cocaine", InsideLabo)
--end)

AllLaboratory = {}

-- Chek need if he load
CreateThread(function()
    while p == nil do Wait(100) end
    Wait(2000)
    --local allcrews = TriggerServerCallback("core:crew:getAllCrew")
    --if allcrews then
    --    for k,v in ipairs(allcrews) do
    --        if v.name == p:getCrew() then
    --            canLoadLabo = true
    --        end
    --    end
    --else
    --    canLoadLabo = true
    --end
    if p:getPermission() >= 3 or canLoadLabo or p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "gcp" then
        LoadLaboratory()
    end
end)

RegisterNetEvent("core:labo:updateLabs", function()
    if canLoadLabo then
        LoadLaboratory(true)
    end
end)

RegisterNetEvent("core:labo:changeState", function(state, idlab, min, shouldblock, percentages, updatePlant)
    --if canLoadLabo then
        for u,x in pairs(AllLaboratory) do
            if x.id == idlab then
                x.state = state
                x.minutes = min
                x.percentages = percentages
                --[[if shouldblock then x.blocked = true end
                if x.laboType == "weed" then
                    x.PosWork = {
                        {x = 1051.6655273438, y=-3206.1398925781, z=-40.144805908203, type = 1},
                        {x = 1057.4426269531, y=-3205.9860839844, z=-40.130340576172, type = 2},
                        {x = 1063.1239013672, y=-3204.4331054688, z=-40.125465393066, type = 3},
                        {x = 1063.3931884766, y=-3197.9868164063, z=-40.111530303955, type = 4},
                        {x = 1063.7102050781, y=-3192.9262695313, z=-40.139533996582, type = 5},
                        {x = 1055.8797607422, y=-3189.2038574219, z=-40.131362915039, type = 6},
                        {x = 1051.0413818359, y=-3190.1357421875, z=-40.109767913818, type = 7},
                        {x = 1050.7368164063, y=-3196.7192382813, z=-40.149147033691, type = 8},
                        {x = 1050.8310546875, y=-3199.8098144531, z=-40.107440948486, type = 9},
                        {x = 1057.0352783203, y=-3201.2414550781, z=-40.118370056152, type = 10},
                    }
                elseif x.laboType == "coke" or x.laboType == "cocaine" then
                    x.PosWork = {
                        {x= 1093.0819091797, y=-3196.7763671875, z=-39.993476867676, h=2.4575769901276, type = 1},
                        {x= 1090.2670898438, y=-3196.7502441406, z=-39.993476867676, h=3.0010781288147, type = 2},
                        {x= 1095.3757324219, y=-3196.6611328125, z=-39.993476867676, h=1.4820932149887, type = 3},
                    }
                elseif x.laboType == "meth" or x.laboType == "fentanyl" then
                    x.PosWork = {
                        {x= 1006.543762207, y=-3197.775390625, z=-39.993122101083, h=271.82159423828, type = 1},
                        {x= 1007.844543457, y=-3201.2121582031, z=-39.993122101083, h=178.9291229248, type = 2},
                        {x= 1004.0552368164, y=-3200.7126464844, z=-39.993141174316, h=183.94758605957, type = 3},
                    }
                else
                    x.PosWork = {
                        {x = 1051.6655273438, y=-3206.1398925781, z=-40.144805908203, type = 1},
                        {x = 1057.4426269531, y=-3205.9860839844, z=-40.130340576172, type = 2},
                        {x = 1063.1239013672, y=-3204.4331054688, z=-40.125465393066, type = 3},
                        {x = 1063.3931884766, y=-3197.9868164063, z=-40.111530303955, type = 4},
                        {x = 1063.7102050781, y=-3192.9262695313, z=-40.139533996582, type = 5},
                        {x = 1055.8797607422, y=-3189.2038574219, z=-40.131362915039, type = 6},
                        {x = 1051.0413818359, y=-3190.1357421875, z=-40.109767913818, type = 7},
                        {x = 1050.7368164063, y=-3196.7192382813, z=-40.149147033691, type = 8},
                        {x = 1050.8310546875, y=-3199.8098144531, z=-40.107440948486, type = 9},
                        {x = 1057.0352783203, y=-3201.2414550781, z=-40.118370056152, type = 10},
                    }
                end
                if InsideLabo and InsideLabo == x.id then
                    --if updatePlant then
                    --    DoCheckProductionWeed(0, true)
                    --end
                    local labo = x.laboType
                    if x.PosWork then
                        for k,v in pairs(x.PosWork) do
                            print(labo == "weed" and "bulleTravaillerWeed" or labo == "coke" and "bulleTravaillerCoke" or labo == "fentanyl" and "bulleTravaillerFentanyl" or labo == "meth" and "bulleTravaillerMeth")
                            zone.addZone("laborecolte" .. k,
                                vec3(v.x, v.y, v.z + 1.0),
                                "~INPUT_CONTEXT~ Sortir",
                                function()
                                    Bulle.hide("laborecolte" .. k)
                                    zone.removeZone("laborecolte" .. k)
                                    if v.h then
                                        SetEntityHeading(PlayerPedId(), v.h)
                                    end
                                    if labo == "weed" then
                                        RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
                                        while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do
                                            Wait(1)
                                        end
                                        TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            duration = 2,
                                            content = "~s Vous êtes en train de travailler la plante",
                                        })
                                        Wait(2000)
                                        ClearPedTasks(PlayerPedId())
                                        TriggerServerEvent("core:labo:ClearKPosWork", idlab, v.type)
                                    elseif labo == "coke" then
                                        RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
                                        while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
                                            Wait(1)
                                        end
                                        TaskPlayAnim(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            duration = 15,
                                            content = "~s Vous êtes en train de travailler la cocaine",
                                        })
                                        Wait(15000)
                                        ClearPedTasks(PlayerPedId())
                                        TriggerServerEvent("core:labo:ClearKPosWork", idlab, v.type)
                                    elseif labo == "meth" or labo == "fentanyl" then
                                        RequestAnimDict("anim@amb@business@meth@meth_monitoring_cooking@monitoring@")
                                        while not HasAnimDictLoaded("anim@amb@business@meth@meth_monitoring_cooking@monitoring@") do
                                            Wait(1)
                                        end
                                        TaskPlayAnim(PlayerPedId(), "anim@amb@business@meth@meth_monitoring_cooking@monitoring@", "button_press_monitor", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            duration = 15,
                                            content = labo == "meth" and "~s Vous êtes en train de travailler la meth" or "~s Vous êtes en train de travailler la fentanyl",
                                        })
                                        Wait(15000)
                                        ClearPedTasks(PlayerPedId())
                                        TriggerServerEvent("core:labo:ClearKPosWork", idlab, v.type)
                                    end
                                end,
                                false,
                                27,
                                0.5,
                                { 255, 255, 255 },
                                170,
                                2.5,
                                true,
                                labo == "weed" and "bulleTravaillerWeed" or labo == "coke" and "bulleTravaillerCoke" or labo == "fentanyl" and "bulleTravaillerFentanyl" or labo == "meth" and "bulleTravaillerMeth"
                            )
                        end
                    end
                    CreateThread(function()
                        while true do
                            Wait(1)
                            local labo = x.laboType
                            local id = x.id
                            if not InsideLabo then
                                break
                            end
                            if not x.PosWork or not next(x.PosWork) then
                                x.PosWork = nil
                                x.hasPlantTreated = true
                                TriggerServerEvent("core:labo:PosWorkFinished", id)
                                break
                            end
                            --[[for k,v in pairs(x.PosWork) do
                                if labo == "weed" then DrawMarker(2, v.x, v.y, v.z+0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 42, 180, 19, 185, true, 1, 0, 0) else DrawMarker(2, v.x, v.y, v.z+0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 42, 120, 180, 185, true, 1, 0, 0) end
                                local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z)
                                if dist < 1.5 then
                                    if labo == "weed" then ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour travailler la plante") else ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour travailler la drogue") end
                                    if IsControlJustPressed(0, 38) then
                                        if v.h then
                                            SetEntityHeading(PlayerPedId(), v.h)
                                        end
                                        if labo == "weed" then
                                            RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
                                            while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do
                                                Wait(1)
                                            end
                                            TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                duration = 14,
                                                content = "~s Vous êtes en train de travailler la plante",
                                            })
                                            Wait(15000)
                                            ClearPedTasks(PlayerPedId())
                                            TriggerServerEvent("core:labo:ClearKPosWork", id, v.type)
                                        elseif labo == "coke" then
                                            RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
                                            while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
                                                Wait(1)
                                            end
                                            TaskPlayAnim(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                duration = 59,
                                                content = "~s Vous êtes en train de travailler la cocaine",
                                            })
                                            Wait(60000)
                                            ClearPedTasks(PlayerPedId())
                                            TriggerServerEvent("core:labo:ClearKPosWork", id, v.type)
                                        elseif labo == "meth" or labo == "fentanyl" then
                                            RequestAnimDict("anim@amb@business@meth@meth_monitoring_cooking@monitoring@")
                                            while not HasAnimDictLoaded("anim@amb@business@meth@meth_monitoring_cooking@monitoring@") do
                                                Wait(1)
                                            end
                                            TaskPlayAnim(PlayerPedId(), "anim@amb@business@meth@meth_monitoring_cooking@monitoring@", "button_press_monitor", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                duration = 59,
                                                content = labo == "meth" and "~s Vous êtes en train de travailler la meth" or "~s Vous êtes en train de travailler la fentanyl",
                                            })
                                            Wait(60000)
                                            ClearPedTasks(PlayerPedId())
                                            TriggerServerEvent("core:labo:ClearKPosWork", id, v.type)
                                        end
                                    end
                                end
                            end]]
                        --[[end
                    end)
                end
                TriggerServerEvent("core:labo:PosWork", idlab, x.PosWork)]]
            end
        end
    --end
end)

RegisterNetEvent("core:createNewLab", function(id, crew, typeLab, entry)
    table.insert(AllLaboratory, {
        id = id,
        crew = crew,
        laboType = typeLab,
        coords = entry,
    })
end)

-- Load laboratory
function LoadLaboratory(ignoreblip)
    local Laboratory = TriggerServerCallback("core:getLaboratory", token)
    AllLaboratory = {}
    while Laboratory == nil do Wait(1) end
    while not p do Wait(0) end
    if not next(Laboratory) then return end
    for k,v in pairs(Laboratory) do
     --   print("k;v", k,v)
        --print("v.id,v.crew,v.laboType,data.coords",v.id,v.crew,v.laboType,data.coords)
        table.insert(AllLaboratory, {
            id = v.id,
            crew = v.crew,
            laboType = v.laboType,
            state = v.state,
            minutes = v.minutes,
            blocked = v.blocked,
            quantityDrugs = v.quantityDrugs,
            percentages = v.percentages,
            inAction = v.InAction,
            coords = v.coords,
        })
        --print("p:getCrew(), v.crew", p:getCrew(), v.crew)
        if not ignoreblip then -- PAS DE BLIP DECISION STAFF
            --[[if p:getCrew() == v.crew then
                local blips = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
                SetBlipSprite(blips, 40)
                SetBlipScale(blips, 0.75)
                SetBlipColour(blips, 39)
                SetBlipAsShortRange(blips, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName("Laboratoire " .. posLaboratory[v.laboType].type)
                EndTextCommandSetBlipName(blips)
            end]]
        end
    end
end

RegisterNetEvent("core:labo:finished", function(id, percentages, quantity,labtype)
    if canLoadLabo then
        for k,v in pairs(AllLaboratory) do
            if v.id == id then
                v.state = 2
                v.percentages = percentages
                v.minutes = 0
                --[[ if v.crew == p:getCrew() then
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        duration = 10,
                        content = "Votre production de " .. v.laboType .. " est terminée !"
                    })
                end ]]
                v.quantityDrugs = quantity
                LaboCrewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", v.crew)
                if InsideLabo == id then
                    if labtype then
                        SendNuiMessage(json.encode({
                            type = 'updateLaboratoires',
                            name = 'laboratoires',
                            data = {
                                type = 'updateLaboratoires',
                                state = 2,
                                pourcentage = v.percentages,
                                items = {GoodNames[posLaboratory[labtype].ItemsNeeded[1]], GoodNames[posLaboratory[labtype].ItemsNeeded[2]], GoodNames[posLaboratory[labtype].ItemsNeeded[3]]},
                                quantity = v.quantityDrugs,
                                quantityDrugs = v.quantityDrugs,
                                lvl = LaboCrewLevel,
                                drugName = string.upper(labtype),
                                paye = TriggerServerCallback("core:labo:HasAlreadyLaunched", id) and 500 or 0,
                                stateOfButton = LaboProduction,
                                stateOfButtonMax = MaxTimeProductions[LaboCrewLevel],
                                image = v.laboType
                            }
                        }))
                    end
                    if v.laboType == "weed" and LaboWeedStatus ~= 3 then
                        DoCheckProductionWeed(MaxTimeProductions[LaboCrewLevel])
                    end
                end
            end
        end
    end
end)

local function OpenLaboProduction(id, laboType, getProduction)
    forceHideRadar()
    SetNuiFocusKeepInput(false)
    SetNuiFocus(true, false)
    Wait(100)
    local state = 0
    local percentages = {0, 0, 0}
    if IsInProduction then
        state = IsInProduction == 100 and 2 or 1
    end
    local quantity = 140
    if CrewLevel == 4 then
        quantity = 160
    elseif CrewLevel >= 5 then
        quantity = 180
    end
    LaboQuantity = quantity
    LaboQuantityDrug = 0
    LaboType = laboType
    LaboCrewLevel = CrewLevel
    LaboImage = laboType
    LaboBlocked = false
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'laboratoires',
    }))
    local ShouldTakeDrug = TriggerServerCallback("core:IsFinishedLab", token, id)
    local MyLab = TriggerServerCallback("core:getMyLab", token, id)
    --print(json.encode(MyLab, {indent = true}))
    getProduction = MyLab.minutes
    state = MyLab.state
    percentages = MyLab.percentages
    LaboBlocked = MyLab.blocked
    LaboQuantityDrug = MyLab.quantityDrugs or 0
    if LaboQuantityDrug == 0 then
        if state == 2 then
            LaboQuantityDrug = 0
            state = 0
            TriggerSecurEvent("core:labo:update", id, 0, 0, 0)
        end
    end
    if LaboBlocked == true then
        state = 0
    end
    if ShouldTakeDrug then
        state = 2
        LaboQuantityDrug = ShouldTakeDrug
    end
    LaboState = state
    LaboItemsNeeded = {posLaboratory[laboType].ItemsNeeded[1], posLaboratory[laboType].ItemsNeeded[2], posLaboratory[laboType].ItemsNeeded[3]}
    if state == 1 then
        local getProductionTime, percentages2 = TriggerServerCallback("core:getLabProduction", token, id)
        if getProductionTime then getProduction = getProductionTime end
        if percentages2 then percentages = percentages2 end
    end
    if state == 1 then
        getProduction = getProduction or (MaxTimeProd - 1)
    else
        getProduction = false
    end
    LaboProduction = getProduction
    if percentages[1] and percentages[2] and percentages[3] then
        percentages[1] = math.floor(percentages[1])
        percentages[2] = math.floor(percentages[2])
        percentages[3] = math.floor(percentages[3])
        if percentages[1] > 100.0 then percentages[1] = 100.0 end
        if percentages[2] > 100.0 then percentages[2] = 100.0 end
        if percentages[3] > 100.0 then percentages[3] = 100.0 end
        if percentages[1] < 0 then percentages[1] = 0 end
        if percentages[2] < 0 then percentages[2] = 0 end
        if percentages[3] < 0 then percentages[3] = 0 end
        if percentages[1] == 0 or percentages[2] == 0 or percentages[3] == 0 then
            if state == 1 then
                state = 0
            end
        end
    else
        percentages = {0, 0, 0}
    end
    local firstNeedCount = 5
    local secondNeedCount = 5
    local thirdNeedCount = 5
    if CrewLevel <= 3 then
        firstNeedCount = FormattedDrugDataNeeds[laboType].levelthree[posLaboratory[laboType].ItemsNeeded[1]]
        secondNeedCount = FormattedDrugDataNeeds[laboType].levelthree[posLaboratory[laboType].ItemsNeeded[2]]
        thirdNeedCount = FormattedDrugDataNeeds[laboType].levelthree[posLaboratory[laboType].ItemsNeeded[3]]
    elseif CrewLevel == 4 then
        firstNeedCount = FormattedDrugDataNeeds[laboType].levelfour[posLaboratory[laboType].ItemsNeeded[1]]
        secondNeedCount = FormattedDrugDataNeeds[laboType].levelfour[posLaboratory[laboType].ItemsNeeded[2]]
        thirdNeedCount = FormattedDrugDataNeeds[laboType].levelfour[posLaboratory[laboType].ItemsNeeded[3]]
    else
        firstNeedCount = FormattedDrugDataNeeds[laboType].levelfive[posLaboratory[laboType].ItemsNeeded[1]]
        secondNeedCount = FormattedDrugDataNeeds[laboType].levelfive[posLaboratory[laboType].ItemsNeeded[2]]
        thirdNeedCount = FormattedDrugDataNeeds[laboType].levelfive[posLaboratory[laboType].ItemsNeeded[3]]
    end
    if LaboQuantityDrug > 180 then LaboQuantityDrug = 180 end
    if LaboQuantityDrug < 0 then LaboQuantityDrug = 0 end
    --print(state, json.encode(percentages), json.encode({GoodNames[posLaboratory[laboType].ItemsNeeded[1]] .. " (x".. firstNeedCount ..")", GoodNames[posLaboratory[laboType].ItemsNeeded[2]] .. " (x".. secondNeedCount ..")", GoodNames[posLaboratory[laboType].ItemsNeeded[3]] .. " (x".. thirdNeedCount ..")"}),
    --    quantity, string.upper(laboType), LaboQuantityDrug, CrewLevel, getProduction, MaxTimeProd, laboType)
    SendNuiMessage(json.encode({
        --type = 'updateLaboratoires',
        name = 'laboratoires',
        type = 'updateLaboratoires',
        data = {
            type = 'updateLaboratoires',
            state = state,
            pourcentage = percentages,
            items = {GoodNames[posLaboratory[laboType].ItemsNeeded[1]] .. " (x".. firstNeedCount ..")", GoodNames[posLaboratory[laboType].ItemsNeeded[2]] .. " (x".. secondNeedCount ..")", GoodNames[posLaboratory[laboType].ItemsNeeded[3]] .. " (x".. thirdNeedCount ..")"},
            quantity = quantity,
            drugName = string.upper(laboType),
            paye = 0,
            quantityDrugs = LaboQuantityDrug,
            lvl = CrewLevel,

            stateOfButton = getProduction,
            stateOfButtonMax = MaxTimeProd,
            image = laboType
        }
    }))
end

RegisterNetEvent("core:labo:StartProduction", function(labid, senttable)
    if canLoadLabo then
        local percentages, activityPercentage, LabStatee, LaboImage, LaboType, LaboCrewLevel, LaboQuantity, src, quantityDrugs, ItemsToRemove = senttable.percentages, senttable.activityPercentage, senttable.LabStatee, senttable.LaboImage, senttable.LaboType, senttable.LaboCrewLevel, senttable.LaboQuantity, senttable.src, senttable.quantityDrugs, senttable.ItemsToRemove
        if percentages[1] > 100 then percentages[1] = 100 end
        if percentages[2] > 100 then percentages[2] = 100 end
        if percentages[3] > 100 then percentages[3] = 100 end
        if percentages[1] < 0 then percentages[1] = 0 end
        if percentages[2] < 0 then percentages[2] = 0 end
        if percentages[3] < 0 then percentages[3] = 0 end
        for k,v in pairs(AllLaboratory) do
            if v.id == labid then
                v.minutes = activityPercentage
                v.state = LabStatee
                v.percentages = {percentages[1], percentages[2], percentages[3]}
                v.quantityDrugs = quantityDrugs
                v.blocked = false
            end
        end
        --print("InsideLabo == labid", InsideLabo, labid)
        if InsideLabo and InsideLabo == labid then
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "La production a été lancé"
            })
            SendNuiMessage(json.encode({
                type = 'updateLaboratoires',
                name = 'laboratoires',
                data = {
                    type = 'updateLaboratoires',
                    state = LabStatee,
                    pourcentage = {percentages[1], percentages[2], percentages[3]},
                    items = {GoodNames[posLaboratory[LaboType].ItemsNeeded[1]], GoodNames[posLaboratory[LaboType].ItemsNeeded[2]], GoodNames[posLaboratory[LaboType].ItemsNeeded[3]]},
                    quantity = LaboQuantity,
                    quantityDrugs = quantityDrugs,
                    lvl = LaboCrewLevel,
                    drugName = string.upper(LaboType),
                    paye = 0,

                    stateOfButton = activityPercentage,
                    stateOfButtonMax = MaxTimeProd,
                    image = LaboImage
                }
            }))
            if ItemsToRemove then
                for k,v in pairs(ItemsToRemove) do
                    if v.count ~= 0 then
                        TriggerServerEvent("core:RemoveItemToInventory", token, v.name, tonumber(v.count), {})
                    end
                end
            end
            --local hasEntitiesBeenInstanced = TriggerServerCallback("core:getInstancedEntities", token, labid)
            --if not hasEntitiesBeenInstanced then
            --    if GetPlayerServerId(PlayerId()) == src then
            --        print("[Labo] No entity instanced, create it, your the source")
            --        if LaboType == "coke" then LaboType = "cocaine" end
            --        CreateLaboPeds(LaboType, labid)
            --    end
            --end
            if LaboType == "weed" then
                local calc = activityPercentage == nil and 0 or MaxTimeProd - activityPercentage
                DoCheckProductionWeed(calc, true)
            end
        end
    end
end)

RegisterNetEvent("core:receiveAddItemLabo", function(idlabo, quantityDrugs, percentages, labtype)
    SendNuiMessage(json.encode({
        type = 'updateLaboratoires',
        name = 'laboratoires',
        data = {
            type = 'updateLaboratoires',
            state = 2,
            pourcentage = percentages,
            items = {GoodNames[posLaboratory[labtype].ItemsNeeded[1]], GoodNames[posLaboratory[labtype].ItemsNeeded[2]], GoodNames[posLaboratory[labtype].ItemsNeeded[3]]},
            quantity = LaboQuantity, -- a modif in the futur
            quantityDrugs = quantityDrugs,
            lvl = LaboCrewLevel, -- a modif in the futur
            drugName = string.upper(labtype),
            paye = TriggerServerCallback("core:labo:HasAlreadyLaunched", idlabo) and 500 or 0,

            stateOfButton = LaboProduction, -- a modif in the futur
            stateOfButtonMax = MaxTimeProd, -- a modif in the futur
            image = labtype
        }
    }))
end)

RegisterNUICallback("laboratoires__callback", function(data)
    local skipnotif = false
    local percentages = {}
    local quantityDrugs = 0
    local cango = true
    local Minutes = 0
    local IsBlocked = false
    local itemsNeeded = {}
    if p:getCrew() == "None" then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = 'Action impossible sans crew'
        })
        return
    end
    local crewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", p:getCrew())
    MaxTimeProd = MaxTimeProductions[crewLevel]
    local goodToGo2 = true
    local poswork
    LaboCrewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", p:getCrew())
    if data.lancer or data == "lancer" then
        local MyLab = TriggerServerCallback("core:getMyLab", token, InsideLabo)
        percentages = MyLab.percentages
        quantityDrugs = MyLab.quantityDrugs
        Minutes = MyLab.minutes
        IsBlocked = MyLab.blocked
        poswork = MyLab.PosWork
        local breakable = 1
        if percentages[1] and percentages[2] and percentages[3] then
            if percentages[1] > 1 and percentages[2] > 1 and percentages[3] > 1 then
                goodToGo2 = false
                skipnotif = true
            end
        end
        if goodToGo2 then
            for k,v in pairs(LaboItemsNeeded) do
                itemsNeeded[k] = {count = tonumber(p:getItemCount(v)), name = v, goodname = GoodNames[v], percentage = GetPercentageLabo(v, p:getItemCount(v), true, LaboCrewLevel, LaboType)}
                percentages[k] = GetPercentageLabo(v, p:getItemCount(v), false, LaboCrewLevel, LaboType)
            end
            if itemsNeeded[1].count == 0 and itemsNeeded[2].count == 0 and itemsNeeded[3].count == 0 then
                cango = false
            end
            if itemsNeeded[1].count == nil and itemsNeeded[2].count == nil and itemsNeeded[3].count == nil then
                cango = false
            end
            if HasExceedMaxValue(itemsNeeded[1].count, LaboCrewLevel, LaboType, itemsNeeded[1].name) == nil or HasExceedMaxValue(itemsNeeded[2].count, LaboCrewLevel, LaboType, itemsNeeded[2].name) == nil or HasExceedMaxValue(itemsNeeded[3].count, LaboCrewLevel, LaboType, itemsNeeded[3].name) == nil then
                skipnotif = true
            else
                itemsNeeded[1].count = HasExceedMaxValue(itemsNeeded[1].count, LaboCrewLevel, LaboType, itemsNeeded[1].name)
                itemsNeeded[2].count = HasExceedMaxValue(itemsNeeded[2].count, LaboCrewLevel, LaboType, itemsNeeded[2].name)
                itemsNeeded[3].count = HasExceedMaxValue(itemsNeeded[3].count, LaboCrewLevel, LaboType, itemsNeeded[3].name)
            end
            if cango then
                CreateLaboPeds(LaboType, InsideLabo)
                TriggerServerEvent("core:labo:LaunchProduction", token, skipnotif == false and itemsNeeded or nil, LaboType, LaboQuantity, percentages, InsideLabo, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantityDrugs, Minutes, poswork)
            end
        else
            CreateLaboPeds(LaboType, InsideLabo)
            TriggerServerEvent("core:labo:LaunchProduction", token, skipnotif == false and itemsNeeded or nil, LaboType, LaboQuantity, percentages, InsideLabo, LaboState, LaboImage, LaboCrewLevel, MaxTimeProd, quantityDrugs, Minutes, poswork)
        end
    end
    if data.recolter or data == "recolter" then
        if tonumber(data.recolter) > 0 and InsideLabo then
            if ply == false then
                --TriggerServerEvent("core:labo:ICanPickup", InsideLabo)
            end
            local MyLab = TriggerServerCallback("core:getMyLab", token, InsideLabo)
            labType = MyLab.laboType
            quantityDrugs = MyLab.quantityDrugs or 0
            if data.recolter <= quantityDrugs then
                if posLaboratory[labType] then
                    TriggerServerEvent("core:addItemLabo", token, posLaboratory[labType].itemgive, tonumber(data.recolter), {}, InsideLabo, quantityDrugs)
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Votre montant est supérieur à celui de la quantité de drogue disponible"
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Montant invalide"
            })
        end
    end
end)

local function LeaveLabo(id, oldCoords)
    DoScreenFadeOut(200)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    TriggerServerEvent("core:rmvPlayerInLabo", token, GetPlayerServerId(PlayerId()), id)
    TriggerServerEvent("core:InstancePlayer", token, 0, "Labos : Ligne 714")
    SetEntityCoords(p:ped(), oldCoords.x, oldCoords.y, oldCoords.z)
    TriggerServerEvent("core:updateLastLabo", token, false)
    InsideLabo = false
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(1) end
    SetEntityCoords(p:ped(), oldCoords.x, oldCoords.y, oldCoords.z)
    Wait(1500)
    DoScreenFadeIn(1000)
    --if LaboEntities then
    --    for k,v in pairs(LaboEntities) do
    --        print("Delete", v)
    --        DeleteEntity(v)
    --    end
    --end
    for k,v in pairs(Utils.GlobalCache) do
        if v.type == "labo" then
            UnpinInterior(v.value)
            table.remove(Utils.GlobalCache, k)
        end
    end
end

---- TODO

RegisterNetEvent("core:labo:ClearKPosWork", function(labid, kid)
    for k,v in pairs(AllLaboratory) do
        if v.id == labid then
            if not v.PosWork then
                v.PosWork = TriggerServerCallback("core:labo:getWorkPos", labid)
            end
            for i, o in ipairs(v.PosWork) do
                if o.type == kid then
                    print("REMOVE", kid)
                    table.remove(v.PosWork, i)
                    if #v.PosWork == 0 then
                        v.blocked = false
                        v.hasPlantTreated = true
                        TriggerServerEvent("core:labo:PosWorkFinished", v.id)
                    end
                end
            end
            if #v.PosWork == 0 then
                v.blocked = false
                v.hasPlantTreated = true
                TriggerServerEvent("core:labo:PosWorkFinished", v.id)
            end
        end
    end
end)

local function StartLoopLabo(id, crew, labo, oldCoords, production, isBlocked)
    InsideLabo = id
    if labo == "cocaine" then labo = "coke" end
    zone.addZone("exitlabo",
        posLaboratory[labo].entrance,
        "~INPUT_CONTEXT~ Sortir",
        function()
            LeaveLabo(id, oldCoords)
        end,
        false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.5,
        true,
        "bulleSortir"
    )
    zone.addZone("productionLabo",
        posLaboratory[labo].production,
        "~INPUT_CONTEXT~ Production",
        function()
            OpenLaboProduction(id, labo, production)
        end,
        false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        2.5,
        true,
        labo == "weed" and "bulleProduireWeed" or labo == "coke" and "bulleProduireCoke" or labo == "fentanyl" and "bulleProduireFentanyl" or labo == "meth" and "bulleProduireMeth"
    )
    if isBlocked then
        for k,v in pairs(isBlocked) do
            zone.addZone("laborecolte" .. k,
                vec3(v.x, v.y, v.z + 1.0),
                "",
                function()
                    Bulle.hide("laborecolte" .. k)
                    zone.removeZone("laborecolte" .. k)
                    if v.h then
                        SetEntityHeading(PlayerPedId(), v.h)
                    end
                    if labo == "weed" then
                        RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
                        while not HasAnimDictLoaded("anim@amb@business@weed@weed_inspecting_lo_med_hi@") do
                            Wait(1)
                        end
                        TaskPlayAnim(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_lo_med_hi@", "weed_crouch_checkingleaves_idle_01_inspector", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            duration = 14,
                            content = "~s Vous êtes en train de travailler la plante",
                        })
                        Wait(15000)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("core:labo:ClearKPosWork", id, v.type)
                    elseif labo == "coke" then
                        RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
                        while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
                            Wait(1)
                        end
                        TaskPlayAnim(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            duration = 59,
                            content = "~s Vous êtes en train de travailler la cocaine",
                        })
                        Wait(60000)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("core:labo:ClearKPosWork", id, v.type)
                    elseif labo == "meth" or labo == "fentanyl" then
                        RequestAnimDict("anim@amb@business@meth@meth_monitoring_cooking@monitoring@")
                        while not HasAnimDictLoaded("anim@amb@business@meth@meth_monitoring_cooking@monitoring@") do
                            Wait(1)
                        end
                        TaskPlayAnim(PlayerPedId(), "anim@amb@business@meth@meth_monitoring_cooking@monitoring@", "button_press_monitor", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            duration = 59,
                            content = labo == "meth" and "~s Vous êtes en train de travailler la meth" or "~s Vous êtes en train de travailler la fentanyl",
                        })
                        Wait(60000)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("core:labo:ClearKPosWork", id, v.type)
                    end
                end,
                false,
                27,
                0.5,
                { 255, 255, 255 },
                170,
                2.5,
                true,
                labo == "weed" and "bulleTravaillerWeed" or labo == "coke" and "bulleTravaillerCoke" or labo == "fentanyl" and "bulleTravaillerFentanyl" or labo == "meth" and "bulleTravaillerMeth"
            )
        end
    end
end

function GetClosestPed2(x,y,z,rad)
    local closestPed = 0

    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(x,y,z, GetEntityCoords(ped), true)
        if distanceCheck <= rad then
            closestPed = ped
            break
        end
    end

    return closestPed
end

local function EnterLabo(id, crew, labo, oldCoords)
    local coords = posLaboratory[labo].entrance
    local int = GetInteriorAtCoords(coords)
    table.insert(Utils.GlobalCache, {type = "labo", value = int})
    DoScreenFadeOut(200)
    PinInteriorInMemory(int)
    Wait(500)
    SetEntityCoords(p:ped(), coords)
    print("ok2")
    Wait(500)
    print("ok4")
    TriggerServerEvent("core:updateLastLabo", token, true, id, labo)
    local Labos = TriggerServerCallback("core:getLaboratory", token)
    crewLevel = TriggerServerCallback("core:crew:getCrewLevelByName", crew)
    print("crewLevel", crewLevel)
    MaxTimeProd = MaxTimeProductions[crewLevel]
    local crewXP = TriggerServerCallback("core:crew:getCrewXpByName", crew)
    print("crewXP", crewXP)
    CrewLevel = crewLevel
    print("Labos, crewLevel, crewXP", Labos, crewLevel, crewXP)
    --if crewLevel == 1 then print("[Labo] Le niveau du crew est trop faible merci de report cet erreur au staff : Crew " .. crew) return end
    local WeedSend = 0
    local LabState = 0
    local IsBlocked = false
    local ShouldActualize = false
    for k,v in pairs(AllLaboratory) do
        if v.id == id then
            if v.state == nil or v.state == false then
                v.state = 0
            elseif v.state and tonumber(v.state) == 1 then
                WeedSend = MaxTimeProd - (tonumber(v.minutes) or 0)
            elseif v.state and v.state == 2 then
                IsInProduction = MaxTimeProd
            end
            if v.minutes and v.minutes ~= 0 then
                ShouldActualize = MaxTimeProd - v.minutes
            end
            if v.minutes == nil then
                v.minutes = MaxTimeProd
            end
            if v.blocked then
                if v.PosWork then
                    IsBlocked = v.PosWork
                else
                    IsBlocked = TriggerServerCallback("core:labo:getPosWork", id)
                end
            end
            LabState = v.state
        end
    end
    if LabState == nil or LabState == false then
        LabState = 0
    end
    if LabState == 1 or LabState == 2 then
        if labo == "coke" then labo = "cocaine" end
        if labo == "weed" then
            if LabState == 2 then
                DoCheckProductionWeed(100)
            else
                DoCheckProductionWeed(WeedSend, true)
            end
        end
    else
        if labo == "weed" then
            DoCheckProductionWeed(ShouldActualize and ShouldActualize or 0)
        end
    end
    Wait(500)
    SetEntityCoords(p:ped(), coords)
    print("id, crew, labo, oldCoords, IsInProduction, IsBlocked", id, crew, labo, oldCoords, IsInProduction, IsBlocked)
    DoScreenFadeIn(200)
    StartLoopLabo(id, crew, labo, oldCoords, IsInProduction, IsBlocked)
end

local Isclose = false
CreateThread(function()
    Wait(6000)
    while true do
        Wait(1)
        if next(AllLaboratory) then
            for k,v in pairs(AllLaboratory) do
                local dista = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords.x, v.coords.y, v.coords.z, true)
                if dista < 100.0 then
                    Isclose = true
                    --DrawMarker(25, v.coords.x, v.coords.y, v.coords.z-.92, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6,
                    --    51, 204, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                    if dista < 2.0 then
                        --v.crew = v.crew:gsub("%s+", "")
                        if string.upper(tostring(v.crew)) == string.upper(tostring(p:getCrew())) then
                            if not v.attacked then
                                --ShowHelpNotification("~INPUT_CONTEXT~ Accéder à la propriété")
                                Bulle.create("entrerLabo", vec3(v.coords.x, v.coords.y, v.coords.z), "bulleEntrer", true)
                                if IsControlJustPressed(0,38) then
                                    TriggerServerEvent("core:InstancePlayer", token, v.id, "Labos : Ligne 953")
                                    TriggerServerEvent("core:AddPlayerInLabo", token, GetPlayerServerId(PlayerId()), v.id)
                                    IsInProduction = false
                                    EnterLabo(v.id, v.crew, v.laboType, v.coords)
                                end
                            else
                                Bulle.create("entrerLabo", vec3(v.coords.x, v.coords.y, v.coords.z), "bulleEntrer", true)
                                ShowHelpNotification("~INPUT_CONTEXT~ Accéder à la propriété\nAppuyez sur ~INPUT_DETONATE~ pour désamorcer le dispositif")
                                if IsControlJustPressed(0,38) then
                                    TriggerServerEvent("core:InstancePlayer", token, v.id, "Labos : Ligne 961")
                                    TriggerServerEvent("core:AddPlayerInLabo", token, GetPlayerServerId(PlayerId()), v.id)
                                    IsInProduction = false
                                    EnterLabo(v.id, v.crew, v.laboType, v.coords)
                                end
                                if IsControlJustPressed(0, 47) then
                                    TaskPlayAnim(PlayerPedId(), "misstrevor2ig_7", "plant_bomb", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
                                    local time = GetAnimDuration("misstrevor2ig_7", "plant_bomb")*1000
                                    Wait(time)
                                    StopAnimTask(PlayerPedId(), "misstrevor2ig_7", "plant_bomb", 1.0)
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "~s Vous avez désamorcé le dispositif",
                                    })
                                    v.attacked = false
                                    v.open = false
                                end
                            end
                        else
                            if v.open == nil or v.open == false then
                                if p:getPermission() >= 3 or p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "gcp" or p:getJob() == "usss" then
                                    ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour sonner\nAppuyez sur ~INPUT_DETONATE~ pour perquisitionner la propriété")
                                    if IsControlJustPressed(0,38) then
                                        TriggerServerEvent("core:labo:sonne", v.id,v.crew)
                                    end
                                    if IsControlJustPressed(0,47) then
                                        TriggerServerEvent("core:InstancePlayer", token, v.id, "Labos : Ligne 989")
                                        TriggerServerEvent("core:AddPlayerInLabo", token, GetPlayerServerId(PlayerId()), v.id)
                                        IsInProduction = false
                                        EnterLabo(v.id, v.crew, v.laboType, v.coords)
                                    end
                                else
                                    ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour sonner")
                                    if IsControlJustPressed(0,38) then
                                        TriggerServerEvent("core:labo:sonne", v.id,v.crew)
                                    end
                                end
                            else
                                Bulle.create("entrerLabo", vec3(v.coords.x, v.coords.y, v.coords.z), "bulleEntrer", true)
                                if IsControlJustPressed(0,38) then
                                    TriggerServerEvent("core:InstancePlayer", token, v.id, "Labos : Ligne 1004")
                                    TriggerServerEvent("core:AddPlayerInLabo", token, GetPlayerServerId(PlayerId()), v.id)
                                    IsInProduction = false
                                    EnterLabo(v.id, v.crew, v.laboType, v.coords)
                                end
                            end
                        end
                        IsCloseToLabo = v.id
                    else
                        IsCloseToLabo = false
                    end
                end
            end
            if not Isclose then
                Wait(2000)
            end
        else
            Wait(2000)
        end
    end
end)

RegisterNetEvent("core:labo:acceptedsonette", function(id)
    for k,v in pairs(AllLaboratory) do
        if v.id == id then
            TriggerServerEvent("core:InstancePlayer", token, v.id, "Labos : Ligne 1029")
            TriggerServerEvent("core:AddPlayerInLabo", token, GetPlayerServerId(PlayerId()), v.id)
            IsInProduction = false
            EnterLabo(v.id, v.crew, v.laboType, v.coords)
        end
    end
end)

RegisterNetEvent("core:labo:sonne", function(id, plyid)
    if InsideLabo and InsideLabo == id then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            duration = 10,
            content = "Une personne sonne au laboratoire"
        })
        Wait(50)
        exports['vNotif']:createNotification({
            type = 'VERT',
            duration = 10,
            content = "Appuyer sur ~K Y pour ~s accepter"
        })
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 10,
            content = "Appuyer sur ~K N pour ~s ignorer"
        })
        local breakable = 1
        while true do
            Wait(1)
            if IsControlJustPressed(0, 246) then -- Y
                TriggerServerEvent("core:labo:acceptsonnette", token, id, plyid)
                break
            end
            if IsControlJustPressed(0, 306) then -- K
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~s Vous avez ignoré"
                })
                break
            end
            breakable = breakable + 1
            if breakable > 600 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~s Vous avez ignoré"
                })
                break
            end
        end
    end
end)

RegisterNetEvent("core:attackLabo", function()
    for k,v in pairs(AllLaboratory) do
        local dista = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords.x, v.coords.y, v.coords.z)
        if dista < 2.0 then
            TriggerServerEvent("core:RemoveItemToInventory", token, "dynamite", 1, {})
            local obj = GetHashKey("ch_prop_ch_ld_bomb_01a")
            RequestModel(obj)
            while not HasModelLoaded(obj) do
                Wait(1)
            end
            TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
            local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
            local objCoords = (coords + forward * 0.5)
            local x,y,z = table.unpack(objCoords)
            local Obj = CreateObject(obj, x,y,z-0.98, 1)
            SetEntityRotation(Obj, 90.0, 0.0, 90.0)
            SetEntityAsMissionEntity(Obj, true, true)
            PlaceObjectOnGroundProperly(Obj)
            while (not HasAnimDictLoaded("misstrevor2ig_7")) do
                RequestAnimDict("misstrevor2ig_7")
                Wait(5)
            end
            TaskPlayAnim(PlayerPedId(), "misstrevor2ig_7", "plant_bomb", 8.0, 8.0, -1, 1, 0, false, false, false) -- aucun mouvement
            local time = GetAnimDuration("misstrevor2ig_7", "plant_bomb")*1000
            Wait(time)
            StopAnimTask(PlayerPedId(), "misstrevor2ig_7", "plant_bomb", 1.0)
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous avez amorcé la dynamite, elle explosera dans 10 minutes",
            })
            v.attacked = true
            TriggerServerEvent("core:labo:alertCrew", token, v.id, v.crew)
            Wait(10*60000)
            --xSound:PlayUrl("bip", "https://youtu.be/JmVub7sTpc0", 1.0)
            if v.attacked == true then
                xSound:PlayUrlPos('bip', 'https://youtu.be/JmVub7sTpc0', 0.45, vector3(x,y,z))
                while not xSound:soundExists("bip") do Wait(1) end
                Wait(6200)
                DeleteEntity(Obj)
                AddExplosion(x,y,z, 2, 10.0, true, false, 1.0)
                xSound:Destroy("bip")
                v.open = true
                TriggerServerEvent("core:labo:setOpen", token, v.id, true)
            end
        end
    end
end)

RegisterNetEvent("core:labo:alertCrew", function(id,crew)
    if crew == p:getCrew() then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            duration = 15,
            content = "Votre laboratoire est en train d'être attaqué !"
        })
        PlaySoundFrontend(-1,'Boss_Message_Orange','GTAO_Boss_Goons_FM_Soundset',1)
    end
    for k,v in pairs(AllLaboratory) do
        if v.id == id then
            v.attacked = true
        end
    end
end)

RegisterNetEvent("core:labo:setOpen", function(id, bool)
    if canLoadLabo then
        for k,v in pairs(AllLaboratory) do
            if v.id == id then
                v.open = bool
            end
        end
    end
end)

RegisterNetEvent("core:labo:gotDeleted", function(id)
    if canLoadLabo then
        for k,v in pairs(AllLaboratory) do
            if v.id == id then
                table.remove(AllLaboratory, k)
            end
        end
    end
end)

RegisterNetEvent("core:labo:sendnotif", function(crew, msg, id, bignotif, mustbeinside)
    if crew == p:getCrew() then
        if type(msg) ~= "string" and type(msg) == "number" then
            TriggerSecurEvent("core:crew:updateXp", token, 250, "add", p:getCrew(), "labo")
            --TriggerServerEvent("core:labo:RMCanPickup", id)
            for k,v in pairs(AllLaboratory) do
                if v.id == id then
                    v.percentages[1] = 0
                    v.percentages[2] = 0
                    v.percentages[3] = 0
                    v.minutes = nil
                    v.state = 0
                    v.blocked = true
                end
            end
        else
            local labotype = "weed"
            for k,v in pairs(AllLaboratory) do
                if v.id == id then
                    labotype = v.laboType
                end
            end
            if not bignotif then
                if mustbeinside then
                    if InsideLabo and InsideLabo == id then
                        exports['vNotif']:createNotification({
                            type = 'JAUNE',
                            duration = 15,
                            content = msg
                        })
                    end
                end
            else
                ColorsLab = {
                    ["weed"] = "#0E8313",
                    ["coke"] = "#D12410",
                    ["fentanyl"] = "#D1C810",
                    ["meth"] = "#10A8D1",
                }
                exports['vNotif']:createNotification({
                    type = 'ILLEGAL',
                    name = "Lester",
                    label = "Laboratoire",
                    labelColor = ColorsLab[labotype],
                    logo = "https://static.wikia.nocookie.net/gtawiki/images/4/49/LesterCrest-GTAVee.webp",
                    mainMessage = msg,
                    duration = 10,
                })
            end
        end
    end
end)

-- INSTANCE
CreateThread(function()
    while p == nil do Wait(1) end
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
    while not GetEntityModel(PlayerPedId()) do Wait(1) end
    Wait(1300)
    local result = TriggerServerCallback("core:getPlayerLastProperty", token);
    Wait(1000)
    local lastPropertyPlayer = type(result) == "table" and result or type(result) == "string" and json.decode(result) or nil
    if lastPropertyPlayer then
        if lastPropertyPlayer ~= '' and lastPropertyPlayer[1] and lastPropertyPlayer[1].labo then
            while not next(AllLaboratory) do Wait(1) end
            for k,v in pairs(AllLaboratory) do
                if v.id == tonumber(lastPropertyPlayer[1].id) then
                    TriggerServerEvent("core:InstancePlayer", token, v.id, "Labos : Ligne 1234")
                    TriggerServerEvent("core:AddPlayerInLabo", token, GetPlayerServerId(PlayerId()), v.id)
                    EnterLabo(v.id, v.crew, v.laboType, v.coords)
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        content = "~c Vous avez été replacé à la dernière position.~s"
                    })
                end
            end
        end
    end
end)



-- WEED IPL
function DoCheckProductionWeed(IsInProduction2, forcesmall)
    local IsInProductione = IsInProduction2 or 0
    local percentage = (IsInProductione/MaxTimeProd)*100
    print("[Labo] Pourcentage de la production de weed " .. math.floor(percentage) .. "%. Calcul : (" .. IsInProductione .. "/" .. MaxTimeProd ..")*100")
    if math.floor(percentage) == 0 or math.floor(percentage) < 0 then
        SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
        if forcesmall then
            Wait(20)
            SetIplPropState(247297, posLaboratory["weed"].weedState.small, true, true)
            LaboWeedStatus = 1
        else
            LaboWeedStatus = 0
        end
    elseif math.floor(percentage) > 0 and math.floor(percentage) < 25 then
        SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
        Wait(20)
        SetIplPropState(247297, posLaboratory["weed"].weedState.small, true, true)
        LaboWeedStatus = 1
    elseif math.floor(percentage) >= 25 and math.floor(percentage) <= 75 then
        SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
        Wait(20)
        SetIplPropState(247297, posLaboratory["weed"].weedState.medium, true, true)
        LaboWeedStatus = 2
    else
        SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
        Wait(20)
        SetIplPropState(247297, posLaboratory["weed"].weedState.full, true, true)
        LaboWeedStatus = 3
    end
end

RegisterCommand("propweedipl", function(source, args)
    if GetPlayerName(PlayerId()) == "Flozii" or GetPlayerName(PlayerId()) == "Gamingo" or GetPlayerName(PlayerId()) == "Adil" then
        if args[1] == "full" then
            SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
            Wait(20)
            SetIplPropState(247297, posLaboratory["weed"].weedState.full, true, true)
        elseif args[1] == "medium" then
            SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
            Wait(20)
            SetIplPropState(247297, posLaboratory["weed"].weedState.medium, true, true)
        elseif args[1] == "small" then
            SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
            Wait(20)
            SetIplPropState(247297, posLaboratory["weed"].weedState.small, true, true)
        elseif args[1] == "empty" then
            SetIplPropState(247297, {posLaboratory["weed"].weedState.small, posLaboratory["weed"].weedState.medium, posLaboratory["weed"].weedState.full}, false, true)
        end
    end
end)

function SetIplPropState(interiorId, props, state, refresh)
    if type(props) == "table" then
        for key, value in pairs(props) do
            SetIplPropState(interiorId, value, state, refresh)
        end
    else
        if state then
            if not IsInteriorEntitySetActive(interiorId, props) then
                ActivateInteriorEntitySet(interiorId, props)
            end
        else
            if IsInteriorEntitySetActive(interiorId, props) then
                DeactivateInteriorEntitySet(interiorId, props)
            end
        end
    end
    if refresh then
        RefreshInterior(interiorId)
    end
end
