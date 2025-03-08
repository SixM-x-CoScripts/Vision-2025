local inGoFast = false
local veh
local ped = {}
local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local peds = {
    { pos = vector4(179.14172363281, 1216.4306640625, 231.32650756836, 280.28204345703), modelPed = "a_m_y_soucent_02" },
    { pos = vector4(-1513.0865478516, 1520.3365478516, 111.62113189697, 86.33878326416), modelPed = "a_m_y_soucent_02" },
    { pos = vector4(156.73387145996, 3130.2641601563, 43.584144592285, 281.40957641602), modelPed = "a_m_y_soucent_02" },
}

CreateThread(function()
    --BulleInfo
    while GoFast == nil do Wait(1) end
    for k, v in pairs(peds) do
        Bulle.add("INFORMATEUR2" .. k, vector3(v.pos.x, v.pos.y, v.pos.z),
            function()
                RobertoBulle("gofast2" .. k, vector3(v.pos.x, v.pos.y, v.pos.z + 1), 'bulleInformation', 255, 0)
            end,
            function()
                local gf2 = GetVariable("heist").gofast1
                local policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
                if not inMission and policeMans >= tonumber(gf2.cops) and TriggerServerCallback("gofast:AlreadyDidGF1", token, p:getId()) and tostring(gf2.active) == "true" then
                    local phone = TriggerServerCallback("core:GetNumber", token)
                    if phone ~= nil then
                        inMission = true
                        CreateThread(function()
                            Visual.Subtitle("Yo mon petit, j'ai besoin de toi pour me récuperer une cargaison", 3000)
                            Modules.UI.RealWait(3000)
                            Visual.Subtitle("je vais t'envoyer toutes les informations un peu plus tard. ", 3000)
                            Modules.UI.RealWait(3000)
                            Visual.Subtitle("Maintenant BOUGE ! ", 2000)
                            Modules.UI.RealWait(5 * 1000) -- 5 Minute
                            local data = GoFast1[math.random(1, #GoFast1)]
                            TriggerServerEvent("missionTel:goFast1", vector2(data.posVeh.x, data.posVeh.y))
                            TriggerEvent("core:StartGoFast", data)
                            TriggerSecurEvent("core:crew:updateXp", token, gf2.xp, "add", p:getCrew(), "gofast2")
                        end)
                    else
                        Visual.Subtitle("Va t'acheter un téléphone que je puisse te contacter et reviens me voir", 2000)
                    end
                else
                    Visual.Subtitle("J'ai pas besoin de toi petit, bouge de la avant que tu le regrette", 2000)
                end
            end)

        ped[k] = entity:CreatePedLocal(v.modelPed, vector3(v.pos.x, v.pos.y, v.pos.z - 1.0), v.pos.w)
        TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_DRUG_DEALER", -1, true)
        Wait(1000)
        SetEntityInvincible(ped[k].id, true)
        FreezeEntityPosition(ped[k].id, true)
        --CreatePed
    end
end)

function StartGoFast(data)
    inGoFast = true
    veh = nil
    local message = false
    local mess2 = false
    local mess3 = false
    local peds = {}
    local createVeh = false
    local finishLivraison = false
    local maletteRecup = false
    local step1 = false
    local step2 = false
    CreateThread(function()
        while inGoFast do
            local pNear = false

            if #(p:pos() - data.posVeh.xyz) <= 50 then
                pNear = true
                if not createVeh then
                    createVeh = true
                    veh = vehicle.create("sultan", data.posVeh, {})
                    TriggerServerEvent("missionTel:addItemTrunkGF1", token, GetVehicleNumberPlateText(veh))
                end
                if IsPedSittingInVehicle(p:ped(), veh) then
                    if not message then
                        message = true
                        TriggerServerEvent("missionTel:goFast2", vector2(data.livraison.x, data.livraison.y))
                        -- TriggerServerEvent("phone:AnonymeCall", "667-8596", data.livraison, "")
                        TriggerSecurEvent('core:makeCall', "lspd", vector3(data.posVeh.x, data.posVeh.y, data.posVeh.z), true, "Véhicule suspect en route", false, "illegal")
                        TriggerSecurEvent('core:makeCall', "lssd", vector3(data.posVeh.x, data.posVeh.y, data.posVeh.z), true, "Véhicule suspect en route", false, "illegal") -- FIX_LSSD_LSPD
                        step1 = true
                    end
                end
            end
            if #(p:pos() - data.livraison.xyz) <= 50 and step1 then
                for key, value in pairs(data.posPed) do
                    if not value.create then
                        TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
                        value.create = true
                        Wait(2000)
                        peds[key] = entity:CreatePedLocal("s_m_m_chemsec_01", value.pos.xyz, value.pos.w)
                        SetEntityInvincible(peds[key].id, true)
                        GiveWeaponToPed(peds[key].id, GetHashKey("weapon_assaultrifle"), 250, true, true)
                    end
                end

                if #(p:pos() - data.livraison.xyz) <= 2 and not finishLivraison then
                    if not mess2 then
                        mess2 = true
                        TriggerServerEvent("missionTel:goFast3")
                        -- TriggerServerEvent("phone:AnonymeCall", "667-8596", nil, "Attends que mes hommes prennent la marchandise et je te donne la suite des instructions")
                        TriggerSecurEvent('core:makeCall', "lspd", vector3(data.livraison.x, data.livraison.y, data.livraison.z), true, "Homme suspect qui vide un coffre", false, "illegal")
                        TriggerSecurEvent('core:makeCall', "lssd", vector3(data.livraison.x, data.livraison.y, data.livraison.z), true, "Homme suspect qui vide un coffre", false, "illegal")  -- FIX_LSSD_LSPD
                    end
                    FreezeEntityPosition(veh, true)

                    local posPlate = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "platelight")) +
                        vector3(0.0, 0.0, 0.5)
                    TaskGoToCoordAnyMeans(peds[1].id, posPlate.x, posPlate.y, posPlate.z, 1.0, 0, 0, 786603, 0)
                    if #(GetEntityCoords(peds[1].id) - posPlate.xyz) <= 1.5 and not maletteRecup then
                        ClearPedTasks(peds[1].id)
                        SetEntityHeading(peds[1].id, GetEntityHeading(veh))
                        RemoveWeaponFromPed(peds[1].id, GetHashKey("weapon_assaultrifle"))
                        LoadAnimDict("move_weapon@jerrycan@generic")
                        SetVehicleDoorOpen(veh, 5, false, false)
                        Wait(1000)
                        TaskPlayAnim(peds[1].id, "move_weapon@jerrycan@generic", "idle", 8.0, 8.0, 1, 16, 0, 0, 0, 0)
                        LoadModel("bkr_prop_biker_case_shut")
                        local malette = CreateObject("bkr_prop_biker_case_shut", GetEntityCoords(peds[1].id), true, false
                            , false)
                        AttachEntityToEntity(malette, peds[1].id, GetPedBoneIndex(peds[1].id, 28422), 0.1000, 0.0100,
                            0.0040, 0.0, 0.0, -90.00, true, true, false, true, 1, true)
                        maletteRecup = true
                        SetVehicleDoorShut(veh, 5, false, false)
                        TriggerServerEvent("missionTel:removeItemTrunkGF1", token, GetVehicleNumberPlateText(veh))
                    end
                    if maletteRecup then
                        TaskGoToCoordAnyMeans(peds[1].id, data.posPed[1].pos.x, data.posPed[1].pos.y,
                            data.posPed[1].pos.z, 1.0, 0, 0, 786603, 0)
                    end
                    if #(GetEntityCoords(peds[1].id) - data.posPed[1].pos.xyz) <= 1.0 and maletteRecup then
                        ClearPedTasks(peds[1].id)
                        SetEntityHeading(peds[1].id, data.posPed[1].pos.w)
                        if not mess3 then
                            mess3 = true
                            TriggerServerEvent("missionTel:goFast4", vector2(data.lastPos.x, data.lastPos.y))
                            -- TriggerServerEvent("phone:AnonymeCall", "667-8596", data.lastPos, "Va me ramener le véhicule et laisse la à l'endroit que je t'envoie")
                        end

                        finishLivraison = true
                        step2 = true
                    end
                end
            end
            if step2 then
                FreezeEntityPosition(veh, false)
            end
            if #(p:pos() - data.lastPos.xyz) <= 3 and step2 then
                local gf2 = GetVariable("heist").gofast1
                for key, value in pairs(peds) do
                    DeleteEntity(value.id)
                end
                TriggerServerEvent("missionTel:goFast5")
                -- TriggerServerEvent("phone:AnonymeCall", "667-8596", nil, "Merci de ton aide à la prochaine.")
                FreezeEntityPosition(veh, true)
                inGoFast = false
                -- ShowNotification("Vous avez reçu ~g~" .. data.reward .. "$")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'DOLLAR',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez reçu ~s " .. gf2.win .. "$"
                })

                TriggerServerEvent("missionTel:deleteconvo")
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", tonumber(gf2.win), {})
                Wait(60000)
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                DeleteEntity(veh)
                return
            end
            if pNear then
                Wait(1)
            else
                Wait(500)
            end
        end
    end)
end

RegisterNetEvent("core:StartGoFast")
AddEventHandler("core:StartGoFast", function(data)
    StartGoFast(data)
end)