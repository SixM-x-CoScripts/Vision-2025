local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local IsAlreadyDrunk = false
local DrunkLevel = -1
local alcohol = 0
local shake = 0

function Drunk(level, start)

    CreateThread(function()

        local playerPed = PlayerPedId()

        if start then
            DoScreenFadeOut(800)
            Wait(1000)
        end

        if level == 0 then

            RequestAnimSet("move_m@drunk@slightlydrunk")
            shake = 1.0
            while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                Wait(0)
            end

            SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)

            RemoveAnimSet("move_m@drunk@slightlydrunk")
        elseif level == 1 then

            RequestAnimSet("move_m@drunk@moderatedrunk")
            shake = 1.5
            while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
                Wait(0)
            end

            SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

            RemoveAnimSet("move_m@drunk@moderatedrunk")
        elseif level == 2 then

            RequestAnimSet("move_m@drunk@verydrunk")
            shake = 2.0
            while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
                Wait(0)
            end

            SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)

            RemoveAnimSet("move_m@drunk@verydrunk")
        end

        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(playerPed, true)
        ShakeGameplayCam("DRUNK_SHAKE", shake)
        SetPedIsDrunk(playerPed, true)

        if start then
            DoScreenFadeIn(800)
        end

    end)

end

function Reality()

    CreateThread(function()

        local playerPed = PlayerPedId()

        DoScreenFadeOut(800)
        Wait(1000)
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(playerPed, 0)
        SetPedIsDrunk(playerPed, false)
        SetPedMotionBlur(playerPed, false)

        DoScreenFadeIn(800)

    end)

end

RegisterNetEvent("core:drink")
AddEventHandler('core:drink', function(intensity) -- 5, 10, 15, 25
    alcohol = alcohol + (intensity * 1000)
end)


CreateThread(function()

    while isTrembling == false do
        Wait(1000)
        if alcohol > 0 then
            alcohol = alcohol - 200
        end
        if alcohol < 0 then
            alcohol = 0
        end
        if alcohol > 50000 then
            if IsAlreadyDrunk then
                start = false
            end
            local level = 0

            if alcohol <= 75000 then
                level = 0
            elseif alcohol <= 100000 then
                level = 1
            else
                level = 2
            end

            if level ~= DrunkLevel then
                Drunk(level, start)
            end

            IsAlreadyDrunk = true
            DrunkLevel = level
        end
        if alcohol <= 50000 and alcohol >= 25000 then
            CreateThread(function()
                RequestAnimSet("move_m@drunk@slightlydrunk")
                ShakeGameplayCam("DRUNK_SHAKE", 0.0)
                while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                    Wait(0)
                end
                SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
                RemoveAnimSet("move_m@drunk@slightlydrunk")
            end)
        end
        if alcohol <= 25000 then
            if IsAlreadyDrunk then
                Reality()
            end
            ShakeGameplayCam("DRUNK_SHAKE", 0.0)
            IsAlreadyDrunk = false
            DrunkLevel     = -1
        end
    end
end)

-- RegisterCommand("alcohol", function(source, args, rawCommand)
--     print(alcohol)
-- end, false)
-- RegisterCommand("reset", function(source, args, rawCommand)
--     Reality()
--     alcohol = 0
--     IsAlreadyDrunk = false
--     DrunkLevel = -1
-- end, false)