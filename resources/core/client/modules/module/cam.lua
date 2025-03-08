Modules.Cam = {
    inAnimationCam = false,
    cams = {},

    RemoveAll = function()
        for k, v in pairs(Modules.Cam.cams) do
            Modules.Cam.delete(k)
        end
        DestroyAllCams(0)
        DestroyAllCams(1)
    end,

    Get = function(name)
        return Modules.Cam.cams[name]
    end,

    isActive = function (name)
        if Modules.Cam.cams[name] ~= nil then 
            return IsCamActive(Modules.Cam.cams[name])
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (delete)")
        end
    end,

    create = function(name)
        if Modules.Cam.cams[name] ~= nil then
            Modules.Cam.delete(name)
            print("^2WARNING: ^7Cam already existed, deleting it before creating it again (" .. name .. ")")
        end
        local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        Modules.Cam.cams[name] = c
    end,

    delete = function(name)
        if Modules.Cam.cams[name] ~= nil then
            RenderScriptCams(0, 0, 0, 0, 1)
            SetCamActive(Modules.Cam.cams[name], false)
            DestroyCam(Modules.Cam.cams[name], false)
            ClearFocus()
            Modules.Cam.cams[name] = nil
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (delete)")
        end
    end,

    setActive = function(name, bool)
        if Modules.Cam.cams[name] ~= nil then
            SetCamActive(Modules.Cam.cams[name], bool)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (setActive)")
        end
    end,

    setPos = function(name, pos)
        if Modules.Cam.cams[name] ~= nil then
            SetFocusPosAndVel(pos.xyz, 0.0, 0.0, 0.0)
            SetCamCoord(Modules.Cam.cams[name], pos.xyz)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (setPos)")
        end
    end,

    setFov = function(name, fov)
        if Modules.Cam.cams[name] ~= nil then
            SetCamFov(Modules.Cam.cams[name], fov)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (setFov)")
        end
    end,

    lookAtCoords = function(name, pos)
        if Modules.Cam.cams[name] ~= nil then
            PointCamAtCoord(Modules.Cam.cams[name], pos.xyz)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (lookAtCoords)")
        end
    end,

    lookAtEntity = function(name, entity)
        if Modules.Cam.cams[name] ~= nil then
            PointCamAtEntity(Modules.Cam.cams[name], entity, 1, 1, 1, 1)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (lookAtEntity)")
        end
    end,

    attachToEntity = function(name, entity, xOffset, yOffset, zOffset, isRelative)
        if Modules.Cam.cams[name] ~= nil then
            AttachCamToEntity(Modules.Cam.cams[name], entity, xOffset, yOffset, zOffset, isRelative)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (attachToEntity)")
        end
    end,

    attachToEntityBone = function(name, ped, boneIndex, x, y, z, heading)
        if Modules.Cam.cams[name] ~= nil then
            AttachCamToPedBone(Modules.Cam.cams[name], ped, boneIndex, x, y, z, heading)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (attachToEntityBone)")
        end
    end,

    attachToVehicleBone = function(name, vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection)
        if Modules.Cam.cams[name] ~= nil then
            AttachCamToVehicleBone(Modules.Cam.cams[name], vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (attachToVehicleBone)")
        end
    end,

    render = function(name, render, animation, time)
        if Modules.Cam.cams[name] ~= nil then
            SetCamActive(Modules.Cam.cams[name], true)
            RenderScriptCams(render, animation, time, 1, 1)
            if not render then
                ClearFocus()
            end
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (render)")
        end
    end,

    switchToCam = function(name, oldCam, time)
        if Modules.Cam.cams[name] ~= nil then
            if Modules.Cam.cams[oldCam] ~= nil then
                SetCamActive(Modules.Cam.cams[name], true)
                SetCamActive(Modules.Cam.cams[oldCam], true)
                SetCamActiveWithInterp(Modules.Cam.cams[name], Modules.Cam.cams[oldCam], time, 1, 1)
            else
                print("^2WARNING: ^7La cam " .. oldCam .. " n'éxiste pas ! (switchToCam)")
            end
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (switchToCam)")
        end
    end,

    animateToCoords = function(name, position, rotation, fov, speed, rotationOrder)
        if Modules.Cam.cams[name] ~= nil then
            SetCamActive(Modules.Cam.cams[name], true)
            --RenderScriptCams(true, false, 3000, true, false, false)
            SetCamParams(Modules.Cam.cams[name], position.xyz, rotation.xyz, fov, speed, 1, 3, rotationOrder)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (animateToCoords)")
        end
    end,

    rotation = function(name, rotX, rotY, rotZ)
        if Modules.Cam.cams[name] ~= nil then
            SetCamRot(Modules.Cam.cams[name], rotX, rotY, rotZ, 2)
        else
            print("^2WARNING: ^7La cam " .. name .. " n'éxiste pas ! (rotation)")
        end
    end,
}
