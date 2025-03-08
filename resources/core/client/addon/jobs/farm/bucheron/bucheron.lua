local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local treePosCheck = nil
local playerpos = nil
local near = false
local blipZoneBois = nil 
local blipSellWood = nil
local blippos = {}
local addpos = nil

local spawnPlaces = {
    --vector4(-797.92742919922, 5390.0419921875, 33.299438476563, 358.06530761719),
    vector4(-805.18969726563, 5388.8510742188, 33.516979217529, 355.70230102539),
    vector4(-783.39196777344, 5401.3486328125, 33.220932006836, 85.978843688965),
}

local ped = nil
local created = false
if not created then
    ped = entity:CreatePedLocal("s_m_m_cntrybar_01", vector3(-777.88519287109, 5402.7905273438, 33.240947723389),
        109.14374542236)
    created = true
end
SetEntityInvincible(ped.id, true)
ped:setFreeze(true)
TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
SetEntityAsMissionEntity(ped.id, 0, 0)
SetBlockingOfNonTemporaryEvents(ped.id, true)

local function spawnVeh()
    for k, v in pairs(spawnPlaces) do
        if vehicle.IsSpawnPointClear(vector3(v.x, v.y, v.z), 3.0) then
            if DoesEntityExist(vehs) then
                TriggerEvent('persistent-vehicles/forget-vehicle', vehs)
                removeKeys(GetVehicleNumberPlateText(vehs), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(vehs))
                DeleteEntity(vehs)
            end
            vehs = vehicle.create('bison3', vector4(v), {})
            local plate = vehicle.getProps(vehs).plate
            local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehs)))
            TaskWarpPedIntoVehicle(PlayerPedId(), vehs, -1)
            local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, vehs, VehToNet(vehs), p:getJob())
            createKeys(plate, model)
        else
        end
    end
end

zone.addZone("keepUtils",
    vector3(-777.88519287109, 5402.7905273438, 33.240947723389),
    "Appuyer sur ~INPUT_CONTEXT~ pour récupérer ton materiel",
    function()
        if CheckJobLimit() then
            if not p:haveItem('chainsaw') then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "chainsaw", 1, {})
            end
            spawnVeh()
            blipSellWood = AddBlipForCoord(-795.39440917969, 5389.189453125, 33.111812591553)
            SetBlipColour(blipSellWood, 15)

            for k=1, #treePos do
                addpos = treePos[k]
                blippos[k] = AddBlipForCoord(addpos)
            end
        end
    end
)
RegisterNetEvent("core:chainsawuse", function()
    for k=1, #treePos do
        playerpos = GetEntityCoords(PlayerPedId())
        treePosCheck = treePos[k]
        if GetDistanceBetweenCoords(playerpos, treePosCheck) > 2 then
            near = false
        else
            near = true
            RemoveBlip(blippos[k])
            table.remove(treePos, k)
            table.remove(blippos, k)
            goto skipboucle

        end
    end

    ::skipboucle::
    if near then
        

        cutTree()
        TriggerSecurGiveEvent("core:addItemToInventory", token, "rawwood", 5, {})

        exports['vNotif']:createNotification({
            type = 'VERT',
            duration = 3, -- In seconds, default:  4
            content = "Vous avez récupérer 5 bûches de bois brut"
        })
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 3, -- In seconds, default:  4
            content = "Cette arbre ne doit pas être coupé !"
        })
    end
end)

function cutTree()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Abattage de l'arbre en cours...",
            time = 30,
        }
    }))
    xSound:PlayUrl('chainsaw', 'https://youtu.be/2CoS5MrRGO4', 0.1, false)
    Modules.UI.RealWait(4000)
    p:PlayAnim('random@mugging4', 'struggle_loop_b_thief', 1)
    Modules.UI.RealWait(26000)
    ClearPedTasksImmediately(PlayerPedId())
end


local pedSell = nil
local function createpedSell()
    pedSell = entity:CreatePedLocal("s_m_m_cntrybar_01", vector3(-795.39440917969, 5389.189453125, 33.111812591553),
    27.628381729126)
    SetEntityInvincible(pedSell.id, true)
    pedSell:setFreeze(true)
    TaskStartScenarioInPlace(pedSell.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(pedSell.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(pedSell.id, true)
end
createpedSell()

zone.addZone("bucheron:sellwood",
    vector3(-795.39440917969, 5389.189453125, 33.111812591553),
    "Appuyer sur ~INPUT_CONTEXT~ pour vendre ton bois",
    function()
        startSellWood()
    end
)

function startSellWood()
    local rawwoodCount = 0
    local rawwoodCount2 = 0
    local closestVehicle, closestDistance = GetClosestVehicle(vector3(-795.39440917969, 5389.189453125, 33.111812591553))
    local vehPos = GetEntityCoords(closestVehicle)
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
    local price = 0

    if vehName == 'BISON' then
        invVeh = vehicle.GetVehicleInventory(vehicle.getPlate(closestVehicle))
        if invVeh then
            for k, v in pairs(invVeh) do
                if v.name == "rawwood" then
                    rawwoodCount = rawwoodCount + v.count
                end
            end
        end
       
        TriggerServerEvent('mine:removeMinerai', vehicle.getPlate(closestVehicle),'rawwood', charcoalCount)

        if p:getItemCount("rawwood") and p:getItemCount("rawwood") >= 1 then
            rawwoodCount = rawwoodCount + p:getItemCount("rawwood")
            rawwoodCount2 = p:getItemCount("rawwood")
            Wait(100)
            TriggerServerEvent("core:RemoveItemToInventory", token, "rawwood", rawwoodCount2, {})
        else
            rawwoodCount2 = 0
        end
                
        price = rawwoodCount * 1
        if p:getSubscription() == 1 then price = price*1.25 end 
        if p:getSubscription() == 2 then price = price*2 end 
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
        
        TriggerServerEvent("core:RemoveItemToInventory", token, "chainsaw", 1, {})
        onMissionFinished()
        exports['vNotif']:createNotification({
            type = 'VERT',
            duration = 5, -- In seconds, default:  4
            content = "Vous avez gagné "..tonumber(price)..'$'
        })
        removeKeys(GetVehicleNumberPlateText(closestVehicle), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))))
        TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(closestVehicle))
        DeleteEntity(closestVehicle)
        RemoveBlip(blipSellWood)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Ce n'est pas le bon véhicule !"
        })
    end
    
end

RegisterCommand('stopbucheron', function()
    for k=1, #blippos do
        RemoveBlip(blippos[k])
    end
    RemoveBlip(blipSellWood)
end)

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7mine ^3loaded")
end)