IsProne = false
local isCrouched = false
local isCrawling = false
local inAction = false
local proneType = "onfront"
local lastKeyPress = 0

local function CanPlayerCrouchCrawl(playerPed)
    if not IsPedOnFoot(playerPed) or IsPedJumping(playerPed) or IsPedFalling(playerPed) or IsPedInjured(playerPed) or IsPedInMeleeCombat(playerPed) or IsPedRagdoll(playerPed) then
        return false
    end

    return true
end

local function IsPlayerAiming(player)
    return IsPlayerFreeAiming(player) or IsAimCamActive() or IsAimCamThirdPersonActive()
end

-- Crouching --
local function ResetCrouch()
    local playerPed = PlayerPedId()

    ResetPedStrafeClipset(playerPed)
    ResetPedWeaponMovementClipset(playerPed)
    SetPedMaxMoveBlendRatio(playerPed, 1.0)
    SetPedCanPlayAmbientAnims(playerPed, true)

    -- Applies the previous walk style (or resets to default if non had been set)
    local walkStyle = GetResourceKvpString("walkstyle")
    if walkStyle ~= nil then
        RequestWalking(walkStyle)
        SetPedMovementClipset(playerPed, walkStyle, 0.6)
        RemoveAnimSet(walkStyle)
    else
        ResetPedMovementClipset(playerPed, 0.5)
    end

    RemoveAnimSet("move_ped_crouched")
end

local function CrouchThread()
    CreateThread(function()
        local playerId = PlayerId()

        while isCrouched do
            local playerPed = PlayerPedId()

            -- Checks if the player is falling, in vehicle, dead etc.
            if not CanPlayerCrouchCrawl(playerPed) then
                isCrouched = false
                break
            end

            -- Limit the speed that the player can walk when aiming
            if IsPlayerAiming(playerId) then
                SetPedMaxMoveBlendRatio(playerPed, 0.15)
            end

            -- This blocks the ped from standing up and playing idle anims (this needs to be looped)
            SetPedCanPlayAmbientAnims(playerPed, false)

            -- Disables "INPUT_DUCK" and blocks action mode
            DisableControlAction(0, 36, true)
            if IsPedUsingActionMode(playerPed) == 1 then
                SetPedUsingActionMode(playerPed, false, -1, "DEFAULT_ACTION")
            end

            -- Disable first person
            DisableFirstPersonCamThisFrame()

            Wait(0)
        end

        -- Reset walk style and ped variables
        ResetCrouch()
    end)
end

local function StartCrouch()
    isCrouched = true
    RequestWalking("move_ped_crouched")
    local playerPed = PlayerPedId()

    -- Force leave stealth mode
    if GetPedStealthMovement(playerPed) == 1 then
        SetPedStealthMovement(playerPed, false, "DEFAULT_ACTION")
        Wait(100)
    end

    -- Force leave first person view
    if GetFollowPedCamViewMode() == 4 then
        SetFollowPedCamViewMode(0) -- THIRD_PERSON_NEAR
    end

    SetPedMovementClipset(playerPed, "move_ped_crouched", 0.6)
    SetPedStrafeClipset(playerPed, "move_ped_crouched_strafing")

    CrouchThread()
end

local function AttemptCrouch(playerPed)
    if CanPlayerCrouchCrawl(playerPed) then
        StartCrouch()
        return true
    else
        return false
    end
end

local function CrouchKeyPressed()
    -- If we already are doing something, then don't continue
    if inAction then
        return
    end

    -- If crouched then stop crouching
    if isCrouched then
        isCrouched = false
        return
    end

    -- Get the player ped
    local playerPed = PlayerPedId()

    -- Get +crouch and INPUT_DUCK keys
    local crouchKey = GetControlInstructionalButton(0, 0xD2D0BEBA, false)
    local duckKey = GetControlInstructionalButton(0, 36, false)

    -- If they are the same and we aren't prone, then check if we are in stealth mode and how long ago the last button press was.
    if crouchKey == duckKey and not IsProne then
        local timer = GetGameTimer()

        -- If we are in stealth mode and we have already pressed the button in the last second
        if GetPedStealthMovement(playerPed) == 1 and timer - lastKeyPress < 1000 then
            DisableControlAction(0, 36, true) -- Disable INPUT_DUCK this frame
            lastKeyPress = 0
            AttemptCrouch(playerPed)
            return
        end
        lastKeyPress = timer
        return
    end

    -- Attempt to crouch, if we were successful, then also check if we are prone, if so then play an animaiton
    if AttemptCrouch(playerPed) and IsProne then
        inAction = true
        IsProne = false
        PlayAnimOnce(playerPed, "get_up@directional@transition@prone_to_knees@crawl", "front", nil, nil, 780)
        Wait(780)
        inAction = false
    end
end

RegisterKeyMapping('+crouch', "Accroupir", "keyboard", "lcontrol")
RegisterCommand('+crouch', function() CrouchKeyPressed() end, false)
RegisterCommand('-crouch', function() end, false) -- This needs to be here to prevent errors/warnings
RegisterCommand('crouch', function()
    if isCrouched then
        isCrouched = false
        return
    end

    AttemptCrouch(PlayerPedId())
end, false)

-- Exports --
-- Returns weather or not the player is crouched
local function IsPlayerCrouched()
	return isCrouched
end

exports('IsPlayerCrouched', IsPlayerCrouched)