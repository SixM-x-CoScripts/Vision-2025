local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local canAccessLTD = false
--[[CreateThread(function()
    while true do 
        Wait(30000)
        if TriggerServerCallback("core:getNumberOfDuty", token, 'ltdsud') + TriggerServerCallback("core:getNumberOfDuty", token, 'ltdseoul') + TriggerServerCallback("core:getNumberOfDuty", token, 'ltdmirror') <= 0 then 
            canAccessLTD = true
            --[[zone.addZone("ltdSudPublic",
                vector3(-47.762920379639, -1757.0087890625, 29.421014785767),
                "~INPUT_CONTEXT~ Magasin de vêtements",
                function()
                    openStore(nil, "ltd", true)
                end, false,
                27,
                0.5,
                { 255, 255, 255 },
                170,
                3.0,
                true,
                "bulleEpicerie"
            )
            zone.addZone("ltdMirrorPublic",
                vector3(1163.4830322266, -323.03421020508, 69.205154418945),
                "~INPUT_CONTEXT~ Magasin de vêtements",
                function()
                    openStore(nil, "ltd", true)
                end, false,
                27,
                0.5,
                { 255, 255, 255 },
                170,
                3.0,
                true,
                "bulleEpicerie"
            )
            zone.addZone("ltdSeoulPublic",
                vector3(-707.37164306641, -913.94982910156, 19.21558380127),
                "~INPUT_CONTEXT~ Magasin de vêtements",
                function()
                    openStore(nil, "ltd", true)
                end, false,
                27,
                0.5,
                { 255, 255, 255 },
                170,
                3.0,
                true,
                "bulleEpicerie"
            )]]
        --[[else
            canAccessLTD = false
            Bulle.hide("ltdSudPublic")
            Bulle.hide("ltdSeoulPublic")
            Bulle.hide("ltdMirrorPublic")
            zone.removeZone("ltdSudPublic")
            zone.removeZone("ltdSeoulPublic")
            zone.removeZone("ltdMirrorPublic")
        end
    end
end)]]

InsideStoreLTDV1 = false
--RegisterCommand("ltd", function(source, args, rawCommand)
function openStore(ped, job, ispublic)
    InsideStoreLTDV1 = true
    exports['tuto-fa']:GotoStep(6)
    if not DlcIllegal then
        pedCoords = GetEntityCoords(ped)
        playerCoords = GetEntityCoords(PlayerPedId())
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, 1)
        SetCamCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.7)
        SetCamFov(cam, 40.0)
        PointCamAtCoord(cam, pedCoords.x, pedCoords.y, pedCoords.z + 0.5)
        RenderScriptCams(true, 0, 3000, 1, 0)   
        FreezeEntityPosition(PlayerPedId(), true)
    end
    if job == "don" or job == "rexdiner" then
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuLTD',
            data = catalogue_item_don
        }));
    else
        if not ispublic then
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuLTD',
                data = catalogue_item_ltd
            }));
        else
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'MenuLTD',
                data = catalogue_item_ltd_free_service
            }));
        end
    end
end
--end, false)
local AntiSpamLTD = true

RegisterNUICallback("MenuLTD", function(data, cb)
    if AntiSpamLTD then
        AntiSpamLTD = false
        TriggerServerEvent("core:buyFromLTD", data.item)
        Wait(200)
        AntiSpamLTD = true
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if InsideStoreLTDV1 then
        InsideStoreLTDV1 = false
        TriggerScreenblurFadeOut(0.5)
        openRadarProperly()
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)

--[[
    Ped into illegal

    ./core/addon/illegal/new_superette.lua
]]--

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7ltd ^3loaded")
end)