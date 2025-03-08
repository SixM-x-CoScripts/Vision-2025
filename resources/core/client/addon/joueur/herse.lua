local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:UseHerse")
AddEventHandler("core:UseHerse", function()
    PutHerse('p_ld_stinger_s')
end)

function PutHerse(obj)
    if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "usss" or p:getPermission() >= 3 then
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)

        local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
        local objCoords = (coords + forward * 2.5)
        local placed = false
        local heading = p:heading()
        local objS = entity:CreateObject(obj, objCoords)
        objS:setPos(objCoords)
        objS:setHeading(heading)
        PlaceObjectOnGroundProperly(objS.id)

        while not placed do
            coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
            objCoords = (coords + forward * 2.5)
            objS:setPos(objCoords)
            PlaceObjectOnGroundProperly(objS.id)
            objS:setAlpha(170)
            SetEntityCollision(objS.id, false, true)

            if IsControlPressed(0, 190) then
                heading = heading + 0.5
            elseif IsControlPressed(0, 189) then
                heading = heading - 0.5
            end

            SetEntityHeading(objS.id, heading)

            ShowHelpNotification(
                "Appuyez sur ~INPUT_CONTEXT~ pour placer l'objet\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pour faire pivoter l'objet")
            if IsControlJustPressed(0, 38) then
                placed = true
            end
            Wait(0)
        end
        SetEntityCollision(objS.id, true, true)
        objS:resetAlpha()
    else
        for key, value in pairs(p:getInventaire()) do
            if "herse" == value.name then
                TriggerServerEvent("core:RemoveItemToInventory", token, "herse", value.count, value.metadatas)
            end
        end
        exports['vNotif']:createNotification({type = 'ROUGE', content = "Vous n'êtes pas autorisé à poser des herses."})
    end
end

function PickupHerse(entity)
    p:PlayAnim("pickup_object", "pickup_low", 0)
    local netid = ObjToNet(entity)
    TriggerServerEvent("core:deletesyncItem", netid)
    DeleteEntity(entity)
    TriggerSecurGiveEvent("core:addItemToInventory", token, "herse", 1, {})
    -- ShowNotification("Vous avez ramassé ~g~une herse")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Vous avez ramassé ~s une herse."
    })
end


RegisterNetEvent("core:deletesyncItemC", function(netid)
    local obj = NetToObj(netid)
    if obj and DoesEntityExist(obj) then 
        DeleteEntity(obj)
    end
end)