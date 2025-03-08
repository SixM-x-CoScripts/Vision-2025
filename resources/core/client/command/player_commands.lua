local token = nil
local AntiSpam = true

Optimisation = false

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterCommand("report", function(source, args)
    if AntiSpam then
        AntiSpam = false
        local text = table.concat(args, " ")

        if text == "" then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Veuillez entrer un message valide."
            })
            return
        end

        if #args < 3 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Veuillez entrer plus de détails dans votre message."
            })
            return
        end

        TriggerServerEvent("core:SendReport", token, {name = p:getFullName(), id = GetPlayerServerId(PlayerId()), uniqueID = p:getId(), msg = text})
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Veuillez patienter, votre demande d'aide à bien été reçu."
        })
        SetTimeout(120000, function() AntiSpam = true end)
    else 
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Veuillez patienter, vous devez attendre 1 minute avant de pouvoir refaire une demande d'aide."
        })
    end
end)

RegisterCommand("opti", function()
    Optimisation = not Optimisation
end)

RegisterCommand("debug", function()
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = "Vous venez d'effectuer la commande debug, veuillez patientez 5s"
    })
    DoScreenFadeOut(1000)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 142, true)
    EnableControlAction(0, 18, true)
    ExecuteCommand("+vui_menu_back")
    ClearFocus()
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 106, true)
    TriggerEvent("debug")
    SendNuiMessage(json.encode({
        type = 'closeWebview', -- forceClose once ready
    }))
    SetNuiFocus(false, false)
    TriggerScreenblurFadeIn(50)
    TriggerScreenblurFadeOut(50)
    RemoveLoadingPrompt()
    DisableScreenblurFade()
    RenderScriptCams(false, false, 0, 1, 0)
    Wait(5000)
    DoScreenFadeIn(1000)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = "Votre personnage à été debug, nous vous souhaitons un bon jeu sur Vision"
    })
end)

RegisterCommand("stuck", function()
    RemoveLoadingPrompt()
    ClearPedTasksImmediately(PlayerPedId())
    DisableScreenblurFade()
    RequestCollisionAtCoord(GetEntityCoords(PlayerPedId()))
    local coords = GetEntityCoords(PlayerPedId())
    -- Gets the closest road coords
    local ret, coordsTemp, heading = GetClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, 1, 3.0, 0)
    local retval, coordsSide = GetPointOnRoadSide(coordsTemp.x, coordsTemp.y, coordsTemp.z)
    SetEntityCoords(PlayerPedId(), coordsSide.x, coordsSide.y, coordsSide.z, false, false, false, true)
    Wait(150)
    -- Refresh focus
    SetFocusPosAndVel(0.0,0.0,0.0)
    Wait(150)
    SetFocusPosAndVel(GetEntityCoords(PlayerPedId()))
    Wait(150)
    ClearFocus()
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = "Vous avez été débloqué"
    })
end)

RegisterCommand("focus", function()
    SetNuiFocus(false, false)
end)

RegisterCommand("id", function()
    -- ShowNotification("Votre id est: ~o~" .. GetPlayerServerId(PlayerId()))
    print(GetPlayerServerId(PlayerId()))
    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre id est : ~s " .. GetPlayerServerId(PlayerId())
    })

end)
RegisterCommand("license", function()
    -- ShowNotification("Votre licence est: ~o~" .. p:getLicense())

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre licence est : ~s " .. p:getLicense()
    })

end)


RegisterCommand("getdiscord", function()
    -- ShowNotification("Votre licence est: ~o~" .. p:getLicense())

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre discord est : ~s " .. p:getDiscord()
    })

end)


RegisterCommand("getfivem", function()
    -- ShowNotification("Votre licence est: ~o~" .. p:getLicense())

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "Votre discord est : ~s " .. p:getFiveMID()
    })

end)

RegisterCommand("idbdd", function()
    -- ShowNotification("Votre id bdd est: ~o~" .. p:getId())
    print(p:getId())
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 5, -- In seconds, default:  4
        content = "Votre id bdd est : ~s" .. p:getId()
    })
end)

--RegisterCommand("infocrew", function()
--    local crewLevel, crewExp = nil , nil 
--    crewLevel = TriggerServerCallback("core:GetCrewLevel", p:getCrew())
--    print("1",crewLevel)
--    Wait(1200)
--    crewExp = TriggerServerCallback("core:GetCrewExp", p:getCrew())
--    while crewLevel == nil or crewExp == nil do Wait(1) end
--    exports['vNotif']:createNotification({
--        type = 'JAUNE',
--        duration = 5, -- In seconds, default:  4
--        content = "Votre crew est niveau : ~s" ..crewLevel.."~c avec ~s" ..crewExp.."~c d'expérience"
--    })
--end)

local mePed = {}
local display = false
-- local function displayText(ped, text)
--     local pPed = PlayerPedId()
--     local pPos = GetEntityCoords(pPed)
--     local tPos = GetEntityCoords(ped)
--     local dst = #(pPos - tPos)
--     local los = HasEntityClearLosToEntity(pPed, ped, 17)

--     if dst ~= 1 and dst <= 200 and los then
--         local exists = mePed[ped] ~= nil

--         mePed[ped] = {
--             time = GetGameTimer() + 5000,
--             text = text
--         }

--         if not exists then
--             display = true

--             while display do
--                 Wait(0)
--                 local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
--                 DrawText3D(vector3(pos.x, pos.y, pos.z + 0.03), mePed[ped].text, 0.7)
--                 display = GetGameTimer() <= mePed[ped].time
--             end

--             mePed[ped] = nil
--         end
--     end
-- end

-- RegisterCommand("me", function(source, args)
--     local text = "* l'individu " .. table.concat(args, " ") .. " *"
--     TriggerServerEvent("core:show3dme", token, text)
-- end)

local antispam = false
RegisterCommand("me", function(source, args)
    if antispam then 
        return
    end
    antispam = true
    local text = "* l'individu " .. table.concat(args, " ") .. " *"
    local players = {}
    for i,v in ipairs(GetActivePlayers()) do 
        table.insert(players, GetPlayerServerId(v))
    end
    TriggerServerEvent("core:sendtext", players, text)
    Wait(5000)
    antispam = false
end)


-- RegisterNetEvent("core:show3dme")
-- AddEventHandler("core:show3dme", function(text, player)
--     local target = GetPlayerFromServerId(player)
--     if target ~= 1 or player == GetPlayerServerId(PlayerId()) then
--         local ped = GetPlayerPed(target)
--         displayText(ped, text)
--     end
-- end)

local lastPos = nil
CreateThread(function()
    while p == nil do Wait(500) end
    lastPos = p:pos()
    while true do
        lastPos = p:pos()
        Wait(5000)
    end
end)

RegisterCommand("lastPos", function()
    SetEntityCoords(p:ped(), lastPos)
end)

RegisterCommand("sync", function ()
    local coords = vector4(p:pos(), p:heading())
    TriggerServerEvent("core:UpdatePlayerPosition", coords)
    -- ShowNotification("~g~Votre position a été synchronisée")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'SYNC',
        -- duration = 5, -- In seconds, default:  4
        content = "~sSynchronisation de la position"
    })

end)

local idle = false
RegisterCommand('idle', function ()
    idle = not idle
    DisableIdleCamera(idle)
    -- show notification depending on whether idle is on or off
    -- ShowNotification(idle and 'Vous avez désactivé la caméra AFK' or 'Vous avez activé la caméra AFK')

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = idle and 'Vous avez ~s désactivé ~c la caméra AFK' or 'Vous avez ~s activé ~c la caméra AFK'
    })

    while idle do 
        Wait(5000)
        InvalidateIdleCam()
		InvalidateVehicleIdleCam()
    end
end)

-- RegisterCommand("service", function()
--     local onDuty = TriggerServerCallback("core:getOnDutyNames", token, p:getJob())
--     if #onDuty == 0 then
--         -- ShowNotification("Aucun employé en service")

--         -- New notif
--         exports['vNotif']:createNotification({
--             type = 'ROUGE',
--             -- duration = 5, -- In seconds, default:  4
--             content = "~s Aucun employé en service"
--         })
--     else
--         -- ShowNotification("Liste des employés en service dans le F8")
--         -- New notif
--         exports['vNotif']:createNotification({
--             type = 'VERT',
--             -- duration = 5, -- In seconds, default:  4
--             content = "~s Liste des employés : " .. json.encode(onDuty)
--         })
--         print("Liste des employés en service :")
--         print(json.encode(onDuty))
--     end

-- end)

RegisterCommand("resetCatalogue", function()
    if p:getJob() == "cardealerSud" then
        TriggerServerEvent("core:resetCatalogue", 'sud')
    elseif p:getJob() == "cardealerNord" then
        TriggerServerEvent("core:resetCatalogue", 'nord')
    elseif p:getJob() == "heliwave" then
        TriggerServerEvent("core:resetCatalogue", 'heliwave')
    end
end)

RegisterCommand("tryDebug", function()
    if p:getJob() == "cardealerSud" then
        TriggerServerEvent("core:tryDebug", 'sud')
    elseif p:getJob() == "cardealerNord" then
        TriggerServerEvent("core:tryDebug", 'nord')
    elseif p:getJob() == "heliwave" then
        TriggerServerEvent("core:tryDebug", 'heliwave')
    end
end)

RegisterCommand("dutyon", function(source)
    local job = p:getJob()

    if job ~= nil or job ~= "aucun" then
        TriggerServerEvent("core:DutyOn", job)

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous êtes désormais en service"
        })
    end
end)

RegisterCommand("dutyoff", function(source)
    local job = p:getJob()

    if job ~= nil or job ~= "aucun" then
        TriggerServerEvent("core:DutyOff", job)

        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous êtes désormais hors service"
        })
    end
end)