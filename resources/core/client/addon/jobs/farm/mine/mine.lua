local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local near = false
local blipMine = nil
local Farmed = 0
local blipSellMine = nil

local spawnPlaces = {
    --vector4(-797.92742919922, 5390.0419921875, 33.299438476563, 358.06530761719),
    vector4(2836.6164550781, 2788.5651855469, 57.2653465271, 230.40905761719),
    vector4(2827.5290527344, 2797.6313476563, 56.676387786865, 174.06541442871),
}

local MineraisPos = {
    vector3(2925.2805175781, 2795.5004882813, 39.816257476807),
    vector3(2926.35, 2792.17, 39.21),
    vector3(2930.6560058594, 2787.1770019531, 39.225761413574),
    vector3(2934.3840332031, 2784.2463378906, 38.135757446289),
    vector3(2937.828125, 2774.8056640625, 38.228908538818),
    vector3(2938.9655761719, 2770.0649414063, 38.123588562012),
    vector3(2947.9494628906, 2766.7329101563, 38.1826171875),
    vector3(2952.9279785156, 2769.4438476563, 38.095897674561),
    vector3(2957.0073242188, 2773.4763183594, 38.842121124268),
    vector3(2968.4428710938, 2774.4914550781, 37.163333892822),
    vector3(2963.9797363281, 2774.6801757813, 38.475654602051),
    vector3(2980.4152832031, 2781.8859863281, 38.655368804932),
    vector3(2980.9919433594, 2786.7941894531, 39.391803741455),
    vector3(2977.7492675781, 2791.0603027344, 39.600025177002),
    vector3(2975.71484375, 2795.9372558594, 40.028232574463),
    vector3(2971.0729980469, 2799.107421875, 40.350330352783),
    vector3(2957.6865234375, 2819.1396484375, 41.601528167725),
    vector3(2950.5200195313, 2815.8869628906, 41.212207794189),
    vector3(2948.2314453125, 2819.4318847656, 41.661563873291),
    vector3(2944.0004882813, 2818.99609375, 42.505672454834),
    vector3(2937.4741210938, 2813.3364257813, 42.477264404297),
    vector3(2930.7114257813, 2816.419921875, 44.221382141113),
    vector3(2927.1694335938, 2813.1740722656, 43.584541320801),
    vector3(2919.685546875, 2799.6977539063, 40.254199981689),
}

pedd = entity:CreatePedLocal("s_m_y_dockwork_01", vector3(2829.0295410156, 2810.6799316406, 56.414730072021),
170.57766723633)
local InJobMine = false
SetEntityInvincible(pedd.id, true)
pedd:setFreeze(true)
TaskStartScenarioInPlace(pedd.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
SetEntityAsMissionEntity(pedd.id, 0, 0)
SetBlockingOfNonTemporaryEvents(pedd.id, true)

local bullePierre = false

local function funcStartMinerais()
    CreateThread(function()
        InJobMine = true
        while InJobMine do 
            Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 2975.080078125, 2780.8583984375, 39.918369293213) < 60.0 then 
                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    for k,v in pairs(MineraisPos) do 
                        local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v)
                        if dist < 5.0 then
                            if not bullePierre then 
                                Bulle.create("bulleMinePierre",v + vector3(0.0, 0.0, 1.3),"bulleMiner", true)
                            else 
                                Bulle.remove("bulleMinePierre")
                            end
                            if IsControlJustPressed(0, 38) then
                                OpenTutoFAInfo("Mine", "Une fois remplit, vendez vos pierres et rendez le camion.")
                                if not ismining then
                                    ismining = true
                                    local patchMine = mine_startMining()
                                    if patchMine then
                                        ismining = false
                                        local mineraiWin = nil
                                        math.randomseed(GetGameTimer())
                                        local randomNumber = math.random(1, 100)
                                        if randomNumber <= 70 then
                                            mineraiWin = 'de charbon'
                                            TriggerSecurGiveEvent("core:addItemToInventory", token, "charcoal", 1, {})
                                        elseif randomNumber <= 90 then
                                            mineraiWin = 'de fer'
                                            TriggerSecurGiveEvent("core:addItemToInventory", token, "iron", 1, {})
                                        elseif randomNumber <= 100 then
                                            mineraiWin = "d'or"
                                            TriggerSecurGiveEvent("core:addItemToInventory", token, "gold", 1, {})
                                        end
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            duration = 5, -- In seconds, default:  4
                                            content = "Vous avez récupéré un minerai "..mineraiWin.."."
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            else
                Wait(3000)
            end
        end
    end)
end

local VehSelect = nil

local function spawnVeh()
    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            AddTenueMine()
            vehs = vehicle.create('bison', vector4(v), {})
            local plate = vehicle.getProps(vehs).plate
            VehSelect = plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            TaskWarpPedIntoVehicle(PlayerPedId(), vehs, -1)
            createKeys(plate, model)
            funcStartMinerais()
        end
    end
    Bulle.create("bulleMineCamionRendre",vector3(2834.5, 2793.29, 58.67),"bulleRendreCamionMine", true)
end

Bulle.create("bulleMineCamion",vector3(2829.0295410156, 2810.6799316406, 58.414730072021),"bulleTravaillerMine", true)
zone.addZone("mine:keepUtils",
    vector3(2829.0295410156, 2810.6799316406, 56.414730072021),
    nil,
    function()
    --     if not p:haveItem('axe') then
    --         if not p:haveItem("weapon_pickaxe") then
    --             exports['vNotif']:createNotification({
    --                 type = 'ROUGE',
    --                 content = "Vous avez besoin d'acheter une pioche à l'armurerie."
    --             })
    --             return
    --         end
    --     end
        closeUI()
        SendNUIMessage({
            type = "openWebview",
            name = "MenuJob",
            data = {
                headerBanner = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10493763812109926601206612668497006632MINE.webp",
                choice = {
                    label = "Bison",
                    isOptional = false,
                    choices = {
                        {
                            id = 1,
                            label = 'Bison',
                            name = 'bison',
                            img= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/bison.webp",
                        },
                    },
                },
                participants = {{name = p:getFirstname(), id = GetPlayerServerId(PlayerId())}},
                participantsNumber = 1,
                callbackName = "MetierMine",
            }
        })
    end, 
    false,
    27,
    1.5,
    { 255, 255, 255 },
    170,
    3.0
)

RegisterNUICallback("MetierMine", function(data)
    if data and data.button == "start" then 
        if CheckJobLimit() then
            spawnVeh()
            OpenTutoFAInfo("Mine", "Descends à la mine pour commencer à miner")
            blipMine = AddBlipForRadius(2975.080078125, 2780.8583984375, 39.918369293213, 60.0)
            SetBlipSprite(blipMine, 9)
            SetBlipColour(blipMine, 1)
            SetBlipAlpha(blipMine, 100)
            blipSellMine = AddBlipForCoord(2834.5, 2793.29, 56.67)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName("Vente de minerai")
            EndTextCommandSetBlipName(blipSellMine)
            SetBlipColour(blipSellMine, 15)
            closeUI()
        end
    elseif data.button == "stop" then 
        
    end
end)



local ismining = false
-- RegisterNetEvent("core:axeuse", function()
--     local minePoint = vector3(2975.080078125, 2780.8583984375, 39.918369293213)
--     local playerpos = GetEntityCoords(PlayerPedId())
--     local mineDistance = GetDistanceBetweenCoords(minePoint, playerpos, false) 

--     if mineDistance > 60.0 then
--         near = false
--     else
--         near = true
--     end

--     if near then
--         if not ismining then
--             if Farmed < 25 then
--                 local mineraiWin = nil
--                 math.randomseed(GetGameTimer())
--                 local randomNumber = math.random(1, 100)
--                 if randomNumber <= 75 then
--                     mineraiWin = 'de charbon'
--                     TriggerSecurGiveEvent("core:addItemToInventory", token, "charcoal", 1, {})
--                 elseif randomNumber <= 95 then
--                     mineraiWin = 'de fer'
--                     TriggerSecurGiveEvent("core:addItemToInventory", token, "iron", 1, {})
--                 elseif randomNumber <= 100 then
--                     mineraiWin = "d'or"
--                     TriggerSecurGiveEvent("core:addItemToInventory", token, "gold", 1, {})
--                 end
--                 exports['vNotif']:createNotification({
--                     type = 'VERT',
--                     content = "Vous avez récupéré un minerai "..mineraiWin.."."
--                 })
--             else
--                 mine_startMining()
--             end
--         else
--             exports['vNotif']:createNotification({
--                 type = 'ROUGE',
--                 content = "Arrete d'essayer de glitch"
--             })
--         end
--     elseif IsPedInAnyVehicle(PlayerPedId(), false) then
--         exports['vNotif']:createNotification({
--             type = 'ROUGE',
--             duration = 3, -- In seconds, default:  4
--             content = "Veuillez descendre de votre véhicule"
--         })
--     else
--         exports['vNotif']:createNotification({
--             type = 'ROUGE',
--             duration = 3, -- In seconds, default:  4
--             content = "Il n'y a pas de minerai dans cette zone !"
--         })
--     end
-- end)

function mine_startMining()
    --if not ismining then
        if Farmed >= 25 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez plus miner, allez vendre ce que vous avez sur vous"
            })
            return false
        else
            ismining = true
            TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
            Farmed += 1
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Progressbar',
                data = {
                    text = "Vous êtes entrain de miner...",
                    time = 20,
                }
            }))
            local miningAxe = CreateObject(GetHashKey('prop_tool_pickaxe'), GetEntityCoords(PlayerPedId()), true, false, false)
            FreezeEntityPosition(miningAxe, true)
            AttachEntityToEntity(miningAxe,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 18905),0.09,0,0,-94.0,60.0,-10.0,1,1,0,1,0,1)

            p:PlayAnim('melee@large_wpn@streamed_core', 'ground_attack_on_spot', 1)
            Modules.UI.RealWait(20000)
            ismining = false
            DeleteEntity(miningAxe)
            --TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
            ClearPedTasksImmediately(PlayerPedId())
            return true
        end
   -- end
end


local pedSell = nil
local function createpedSell()
    pedSell = entity:CreatePedLocal("s_m_m_cntrybar_01", vector3(2834.5, 2793.29, 56.67),188.72)
    SetEntityInvincible(pedSell.id, true)
    pedSell:setFreeze(true)
    TaskStartScenarioInPlace(pedSell.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(pedSell.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedSell.id, true)
end
createpedSell()

zone.addZone("mine:sell",
    vector3(2834.5, 2793.29, 56.67),
    nil,
    function()
        mine_startSell()
    end, 
    false,
    27,
    1.5,
    { 255, 255, 255 },
    170,
    3.5
)

function AddTenueMine()
    local Skin = p:skin()
    ApplySkinFake(Skin)
    -- TODO
    if GetEntityModel(p:ped()) == `mp_m_freemode_01` then 
        SkinChangeFake("torso_1", 146)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 30)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 36)
        SkinChangeFake("pants_2",0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 145)
        SkinChangeFake("helmet_2", 0)
    elseif GetEntityModel(p:ped()) == `mp_f_freemode_01` then 
        SkinChangeFake("torso_1", 88)
        SkinChangeFake("torso_2", 0)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 250)
        SkinChangeFake("arms_2", 0)
        SkinChangeFake("pants_1", 35)
        SkinChangeFake("pants_2", 0)
        SkinChangeFake("shoes_1", 25)
        SkinChangeFake("shoes_2", 0)
        SkinChangeFake("helmet_1", 144)
        SkinChangeFake("helmet_2", 0)
    end
end


function mine_startSell()
    local charcoalCount = 0
    local ironCount = 0
    local goldCount = 0
    
    local charcoalCount2 = 0
    local ironCount2 = 0
    local goldCount2 = 0

    local closestVehicle, closestDistance = GetClosestVehicle(vector3(2834.5, 2793.29, 56.67))
    local vehPos = GetEntityCoords(closestVehicle)
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
    local price = 0

    Bulle.remove("bulleMineCamionRendre")

    if vehName == 'BISON' then

        invVeh = vehicle.GetVehicleInventory(vehicle.getPlate(closestVehicle))
        for k, v in pairs(invVeh) do
            if v.name == "charcoal" then
                charcoalCount = charcoalCount + v.count
            elseif v.name == "iron" then
                ironCount = ironCount + v.count
            elseif v.name == "gold" then
                goldCount = goldCount + v.count
            end
        end
        
        TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'charcoal', charcoalCount)
        TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'iron', ironCount)
        TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'gold', goldCount)

        for k, v in pairs(p:getInventaire()) do
            if v.name == "charcoal" then
                charcoalCount = charcoalCount + v.count
                charcoalCount2 = charcoalCount2 + v.count
            elseif v.name == "iron" then
                ironCount = ironCount + v.count
                ironCount2 = ironCount2 + v.count
            elseif v.name == "gold" then
                goldCount = goldCount + v.count
                goldCount2 = goldCount2 + v.count
            end
        end
        
        
        TriggerServerEvent("core:RemoveItemToInventory", token, "charcoal", charcoalCount2, {})
        TriggerServerEvent("core:RemoveItemToInventory", token, "iron", ironCount2, {})
        TriggerServerEvent("core:RemoveItemToInventory", token, "gold", goldCount2, {})

        Modules.UI.RealWait(500)

        InJobMine = false

        local charcoalPrice, ironPrice, goldPrice = 21, 28, 35

        if GetVariable("jobcenter") then
            local mine = GetVariable("jobcenter").mine
            if tonumber(mine.prices.charcoal) and tonumber(mine.prices.iron) and tonumber(mine.prices.gold) then
                charcoalPrice = tonumber(mine.prices.charcoal)
                ironPrice = tonumber(mine.prices.iron)
                goldPrice = tonumber(mine.prices.gold)
            end
        end

        price = (charcoalCount * charcoalPrice + ironCount * ironPrice + goldCount * goldPrice)
        if p:getSubscription() == 1 then price = price*1.25 end 
        if p:getSubscription() == 2 then price = price*2 end 
        if price ~= 0 then
            TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
        
            exports['vNotif']:createNotification({
                type = 'VERT',
                duration = 5, -- In seconds, default:  4
                content = "Vous avez gagné "..price..'$'
            })
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                duration = 5, -- In seconds, default:  4
                content = "Vous n'avez rien gagné"
            })
        end
        Farmed = 0
        ismining = false
        removeKeys(GetVehicleNumberPlateText(closestVehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(closestVehicle))

        local playerSkin = p:skin()
        ApplySkin(playerSkin)
        onMissionFinished()
        exports['tuto-fa']:HideStep()

        DeleteEntity(closestVehicle)
        RemoveBlip(blipSellMine)
        RemoveBlip(blipMine)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Ce n'est pas le bon véhicule !"
        })
    end
    
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7mine ^3loaded")
end)