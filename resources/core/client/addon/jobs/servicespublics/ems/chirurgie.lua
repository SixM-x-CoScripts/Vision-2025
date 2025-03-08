local token
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local ChirurgiePos = {
    vector3(-681.86, -189.0945, 36.999986120605),
}

local ChirurgieOpen = false

local cam1 = nil
local camR = nil
local camL = nil
local highInit = nil

function changeHighCam(thisCam, ThisValue, XorYorZ)
    local newHigh = GetCamCoord(thisCam)[XorYorZ] + ThisValue
    local lowLimit = highInit[XorYorZ] - 0.5
    local highLimit = highInit[XorYorZ] + 0.5
    if newHigh < lowLimit-1.0 or newHigh > highLimit then
        return
    end
    if XorYorZ == 'y' then
        SetCamCoord(thisCam, GetCamCoord(thisCam).x, GetCamCoord(thisCam).y + ThisValue, GetCamCoord(thisCam).z)
    elseif XorYorZ == 'z' then
        SetCamCoord(thisCam, GetCamCoord(thisCam).x, GetCamCoord(thisCam).y, GetCamCoord(thisCam).z + ThisValue)
    end
end

CreateThread(function()
    while zone == nil do
        Wait(1)
    end
    for k, v in pairs(ChirurgiePos) do
        zone.addZone("ChirurgiePos" .. k,
            vector3(v.x, v.y, v.z),
            "~INPUT_CONTEXT~ Chirurgie esthetique",
            function()
                if p:getSubscription() >= 1 then
                    if not ChirurgieOpen then
                        ChirurgieOpen = true
                        RequestAnimDict("anim@gangops@morgue@table@")
                        while not HasAnimDictLoaded("anim@gangops@morgue@table@") do Wait(1) end

                        SetEntityCoords(p:ped(), v.x, v.y, v.z)
            
                        SetEntityHeading(p:ped(), 34.31)
                        FreezeEntityPosition(p:ped(), true)

                        cam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
                        SetCamActive(cam1, true)
                        --local boneIndex = GetEntityBoneIndexByName(PlayerPedId(), "FB_R_Brow_Out_000")
                        --print("boneIndex", boneIndex)
                        --local coords = GetWorldPositionOfEntityBone(PlayerPedId(), boneIndex)
                        --print("coords", coords)
                        local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.1, -0.65, 0.0)
                        SetCamParams(cam1, offset.x, offset.y, offset.z + 1.0, 270.0, 0.0, 210.0, 50.0, 0, 1, 1, 2)
                        --camHigh = v.z + 1.0
                        SetCamFov(cam1, 50.0)
                        RenderScriptCams(1, 0, 0, 1, 1)
                        highInit = GetCamCoord(cam1)

                        OpenChirurgie()

                        TaskPlayAnim(p:ped(), 'anim@gangops@morgue@table@', "body_search", 8.0, -8.0, -1, 1, 0, 0, 0, 0)

                        while ChirurgieOpen do
                            Wait(0)
                            forceHideRadar()
                            zone.hideNotif("ChirurgiePos" .. k)
                        end
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous devez avoir l'abonnement premium pour pouvoir utiliser la chirurgie esthetique"
                    })
                end
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.0,
            true,
            "bulleChirurgie"
        )
    end
end)

RegisterCommand("chirurgie", function()
    if p:getPermission() >= 4 then
        OpenChirurgie()
    end
end)

function OpenChirurgie()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Surgery',
    }))
end

local lastnoseX, lastnoseY = nil, nil 
local lastnosePointeX, lastnosePointeY = nil, nil
local lastnoseProfileX, lastnoseProfileY = nil, nil
local lastSourcilsX, lastSourcilsY = nil, nil
local lastpommettesX, lastpommettesY = nil, nil
local lastMentonX, lastMentonY = nil, nil
local lastMentonShapeX, lastMentonShapeY = nil, nil
local lastMachoireX, lastMachoireY = nil, nil
local lastCou, lastlevres, lastjoues, lastyeux = nil, nil, nil, nil 

RegisterNUICallback("SurgeryPreview", function(data)

    if data ~= nil  then
        if data.n ~= nil and data.n.x ~= lastnoseX or data.n.y ~= lastnoseY then
            TriggerEvent('skinchanger:change', "nose_1", data.n.x)
            TriggerEvent('skinchanger:change', "nose_2", data.n.y)
            lastnoseX = data.n.x
            lastnoseY = data.n.y
        end
        if data.nP ~= nil and data.nP.x ~= lastnosePointeX or data.nP.y ~= lastnosePointeY then
            TriggerEvent('skinchanger:change', "nose_3", data.nP.x)
            TriggerEvent('skinchanger:change', "nose_4", data.nP.y)
            lastnosePointeX = data.nP.x
            lastnosePointeY = data.nP.y
        end
        if data.nPo ~= nil and data.nPo.x ~= lastnoseProfileX or data.nPo.y ~= lastnoseProfileY then
            TriggerEvent('skinchanger:change', "nose_5", data.nPo.x)
            TriggerEvent('skinchanger:change', "nose_6", data.nPo.y)
            lastnoseProfileX = data.nPo.x
            lastnoseProfileY = data.nPo.y
        end
        if data.s ~= nil and data.s.x ~= lastSourcilsX or data.s.y ~= lastSourcilsY then
            TriggerEvent('skinchanger:change', "eyebrows_5", data.s.x)
            TriggerEvent('skinchanger:change', "eyebrows_6", data.s.y)
            lastSourcilsX = data.s.x
            lastSourcilsY = data.s.y
        end
        if data.p ~= nil and data.p.x ~= lastPommettesX or data.p.y ~= lastPommettesY then
            TriggerEvent('skinchanger:change', "cheeks_1", data.p.x)
            TriggerEvent('skinchanger:change', "cheeks_2", data.p.y)
            lastpommettesX = data.p.x
            lastpommettesY = data.p.y
        end
        if data.m ~= nil and data.m.x ~= lastMentonX or data.m.y ~= lastMentonY then
            TriggerEvent('skinchanger:change', "chin_height", data.m.x)
            TriggerEvent('skinchanger:change', "chin_lenght", data.m.y)
            lastMentonX = data.m.x
            lastMentonY = data.m.y
        end
        if data.mS ~= nil and data.mS.x ~= lastMentonShapeX or data.mS.y ~= lastMentonShapeY then
            TriggerEvent('skinchanger:change', "chin_width", data.mS.x)
            TriggerEvent('skinchanger:change', "chin_hole", data.mS.y)
            lastMentonShapeX = data.mS.x
            lastMentonShapeY = data.mS.y
        end
        if data.ma ~= nil and data.ma.x ~= lastMachoireX or data.ma.y ~= lastMachoireY then
            TriggerEvent('skinchanger:change', "jaw_1", data.ma.x)
            TriggerEvent('skinchanger:change', "jaw_2", data.ma.y)
            lastMachoireX = data.ma.x
            lastMachoireY = data.ma.y
        end
        if data.c ~= nil and data.c ~= lastCou then
            TriggerEvent('skinchanger:change', "neck_thick", data.c/100)
            lastCou = data.c/100
        end
        if data.l ~= nil and data.l ~= lastlevres then
            TriggerEvent('skinchanger:change', "lips_thick", data.l/100)
            lastlevres = data.l/100
        end
        if data.j ~= nil and data.j ~= lastjoues then
            TriggerEvent('skinchanger:change', "cheeks_3", data.j/100)
            lastjoues = data.j/100
        end

        if data.y ~= nil and data.y ~= lastyeux then
            TriggerEvent('skinchanger:change', "eye_open", data.y/100)
            lastyeux = data.y/100
        end
    end 
end)

RegisterNUICallback("SurgeryValidate", function(data)
    if p:pay(tonumber(9500)) then
        local skin = {}
        TriggerEvent("skinchanger:getSkin", function(cb)
            skin = cb
        end)
        TriggerServerEvent("core:SetPlayerActiveSkin", token, skin)
        p:setSkin(skin)
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(p:ped(), false)
        RenderScriptCams(false, 0, 3000, 1, 0)
        DestroyCam(cam1)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    else
        TriggerServerEvent("core:SetPlayerActiveSkin", token, p:getCloths().skin)
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas assez d'argent"
        })
        ClearPedTasksImmediately(PlayerPedId())
        RenderScriptCams(false, 0, 3000, 1, 0)
        FreezeEntityPosition(p:ped(), false)
        DestroyCam(cam1)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end
end)

RegisterNUICallback("SurgeryKeyEvent", function(data)
    local valueH
    key = data.key
    if key == 'e' then
        if camR == nil then
            if camL ~= nil then
                SetCamCoord(cam1, GetCamCoord(cam1).x, GetCamCoord(cam1).y, highInit.z - 1.3)
                DestroyCam(camL, false)
                camL = nil
            end
            camR = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
            SetCamActive(camR, true)
            SetCamParams(camR, GetCamCoord(cam1).x, GetCamCoord(cam1).y - 1.0, highInit.z - 1.3, 335.0, 0.0, 0.0, 50.0, 0, 1, 1, 2)
            SetCamFov(camR, 50.0)
            RenderScriptCams(1, 0, 0, 1, 1)
        else
            SetCamCoord(cam1, GetCamCoord(cam1).x, GetCamCoord(cam1).y, highInit.z - 1.3)
            DestroyCam(camR, false)
            camR = nil
        end
    elseif key == 'a'then
        if camL == nil then
            if camR ~= nil then
                SetCamCoord(cam1, GetCamCoord(cam1).x, GetCamCoord(cam1).y, highInit.z - 1.3)
                DestroyCam(camR, false)
                camR = nil
            end
            camL = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
            SetCamActive(camL, true)
            SetCamParams(camL, GetCamCoord(cam1).x, GetCamCoord(cam1).y + 1.0, highInit.z - 1.3, 335.0, 0.0, 180.0, 50.0, 0, 1, 1, 2)
            SetCamFov(camL, 50.0)
            RenderScriptCams(1, 0, 0, 1, 1)
        else
            SetCamCoord(cam1, GetCamCoord(cam1).x, GetCamCoord(cam1).y, highInit.z - 1.3)
            DestroyCam(camL, false)
            camL = nil
        end
    elseif key == 'mouseDown' then
        valueH = 0.1
    elseif key == 'mouseUp' then
        valueH = -0.1
    end
    if valueH ~= nil then
        if camR ~= nil then
            changeHighCam(camR, valueH, 'y')
        elseif camL ~= nil then
            changeHighCam(camL, valueH*(-1), 'y')
        else
            changeHighCam(cam1, valueH, 'z')
        end
    end
end)

RegisterNUICallback("focusOut", function()
    if ChirurgieOpen then
        RenderScriptCams(false, 0, 3000, 1, 0)
        DestroyCam(cam1)
        ClearPedTasksImmediately(PlayerPedId())
        FreezeEntityPosition(p:ped(), false)
        ChirurgieOpen = false
    end
end)