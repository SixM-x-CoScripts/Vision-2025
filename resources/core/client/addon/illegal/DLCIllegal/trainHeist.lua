
function StartTrainHeist()
    local policeMans = tonumber(getNumberOfCopsInDuty())
    --if policeMans >= 2 then
        if p:haveItem("laptop") then
            Bulle.hide("train_heist")
            local bool = HackAnimation()
            while bool == nil do 
                Wait(1)
            end
            if bool == true then
                OpenTutoFAInfo("Braquage de train", "Un point GPS va être placé, monte sur le train et récupere la cargaison !")
                TriggerServerEvent("core:events:train:start", p:getCrewType())
                Bulle.hide("train_heist")
                CreateThread(function()
                    Wait(30000)
                    exports['tuto-fa']:HideStep()
                end)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Réessaye !"
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas d'ordinateur"
            })
        end
    --else
    --    exports['vNotif']:createNotification({
    --        type = 'ROUGE',
    --        -- duration = 5, -- In seconds, default:  4
    --        content = "~s Reviens plus tard ! (Il faut 2 policier en service)"
    --    })
    --end
end

RegisterClientCallback("core:createtrainheist", function()
    loadModel('freight')
    loadModel('freightcar')
    loadModel('tr_prop_tr_container_01a')
    loadModel('prop_ld_container')
    loadModel('tr_prop_tr_lock_01a')
    loadModel('xm_prop_lab_desk_02')
    loadTrainModels()
    Wait(200)
    train = CreateMissionTrain(24, 2872.028, 4544.253, 47.758, true, true, true)
    while not DoesEntityExist(train) do Wait(1) end
    SetMissionTrainCoords(train, 2872.028, 4544.253, 47.758)
    return NetworkGetNetworkIdFromEntity(train)
end)

local blipTrain

while not entity do Wait(100) end
local entitypol = entity

RegisterNetEvent("core:events:train:start", function(train)
    local entity = NetworkGetEntityFromNetworkId(train)

    print("entity", entity, DoesEntityExist(entity))

    local coords = GetEntityCoords(entity)
    blipTrain = AddBlipForCoord(coords)
    SetBlipSprite(blipTrain, 795)
    SetBlipScale(blipTrain, 0.75)
    SetBlipColour(blipTrain, 1)
    SetBlipAsShortRange(blipTrain, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("~r~Train")
    EndTextCommandSetBlipName(blipTrain)

    SetTrainCruiseSpeed(entity, 0.0)

    local obj = entitypol:CreateObjectLocal('tr_prop_tr_container_01a', coords).id
    FreezeEntityPosition(obj, true)
    local carriage = GetTrainCarriage(entity,4)
    local carcoords = GetEntityCoords(carriage)
    local forward = GetEntityForwardVector(carriage)
    local goodcoord = (carcoords + forward * 4.5)
    print("carcoords", goodcoord)
end)

RegisterNetEvent("core:event:trainupdate", function(coords)
    if blipTrain then 
        SetBlipCoords(blipTrain, coords)
    end
end)

RegisterNetEvent("core:event:trainfinish", function()
    if blipTrain then 
        RemoveBlip(blipTrain)
    end
end)