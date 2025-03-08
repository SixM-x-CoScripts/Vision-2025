local open = false
cinemamod, minimapMod = false, false

function OpenRadialmenuf9()
  if not open then
    open = true
    CreateThread(function()
      while open do
        Wait(0)
        DisableControlAction(0, 1, open)
        DisableControlAction(0, 2, open)
        DisableControlAction(0, 142, open)
        DisableControlAction(0, 18, open)
        DisableControlAction(0, 322, open)
        DisableControlAction(0, 106, open)
      end
    end)
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    Wait(200)
    CreateThread(function()
      elements = {
        {
          name = "MODE CINEMA",
          icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/cinema.svg",
          position = {
            top = "-30",
            left = "-60"
          },
          action = "CinemaMod"
        },
        {
          name = "MASQUER HUD",
          icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/crossed_eye.svg",
          position = {
            top = "-35",
            left = "-20"
          },
          action = "NoMoreATH"
        },
        {
          name = "REINITIALISER",
          icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/back.svg",
          position = {
            top = "-32.5",
            left = "-27.5"
          },
          action = "DefaultCamera"
        },
        -- A changé et mettre premium camera libre
        --{
        --  name = "CAMERA STREET",
        --  icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/cam.svg",
        --  position = {
        --    top = "-20",
        --    left = "-35"
        --  },
        --  action = "CameraStreet"
        --}
    }
      SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'RadialMenu',
        data = {
          elements = elements,
          title = "HUD",
          key = "F9"
        }
      }));
    end)
  else
    open = false
    SetNuiFocusKeepInput(false)
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 142, true)
    EnableControlAction(0, 18, true)
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 106, true)
    SetNuiFocus(false, false)
    SendNuiMessage(json.encode({
      type = 'closeWebview',
    }))
    Wait(200)
    if cinemamod or minimapMod then
      forceHideRadar()
    end
    return
  end
end

RegisterNUICallback("focusOut", function(data, cb)
  if open then
    open = false
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 142, true)
    EnableControlAction(0, 18, true)
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 106, true)
  end
  cb({})
end)


RegisterCommand("+openmenucamera", function()
	OpenRadialmenuf9()
end, false)

RegisterKeyMapping("+openmenucamera", "Radial Menu Camera", "keyboard", "F9")

local w = 0
local minimap

local function DrawRects() -- [[Draw the Black Rects]]
  DrawRect(0.0, 0.0, 2.0, 0.2, 0, 0, 0, 255)
  DrawRect(0.0, 1.0, 2.0, 0.2, 0, 0, 0, 255)
end

local function DisplayHealthArmour(int)
  BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
  ScaleformMovieMethodAddParamInt(int)
  EndScaleformMovieMethod()
end

local function DESTROYHudComponents() -- [[Get rid of all active hud components.]]
  for i = 0, 22, 1 do
    if IsHudComponentActive(i) then
      HideHudComponentThisFrame(i)
    end
  end
end

function CinemaMod()

  cinemamod = not cinemamod

  SetRadarBigmapEnabled(false, false)
  if cinemamod then
    parametersInstructionalButtons.hide = true
    forceHideRadar()
    Citizen.CreateThread(function() -- [[Requests the minimap scaleform and actually calls the rect function allong with the hud components function.]]
      while cinemamod do
        Wait(1)
        if cinemamod then
          DrawRects()
        end
      end
    end)
  else
    parametersInstructionalButtons.hide = false
    openRadarProperly()
  end
end

function NoMoreATH()
  Modules.Utils.RealWait(100)
  minimapMod = not minimapMod

  if minimapMod then
    --DisplayRadar(false)
    DisplayHealthArmour(3)
    print("minimapMod")
    parametersInstructionalButtons.hide = true
    forceHideRadar()
  else
    --DisplayRadar(true)
    DisplayHealthArmour(0)
    print("minimapMod")
    parametersInstructionalButtons.hide = false
    openRadarProperly()
  end
end

function openCommandMenu(...)
  TriggerEvent('__atoshi::openCommandMenu', ...)
end

local shakecamerastreet = false


function CameraStreet()
    if (not shakecamerastreet) then
        ShakeGameplayCam("HAND_SHAKE", 4.6)
        shakecamerastreet = true
        CreateThread(function()
            while shakecamerastreet do 
              Wait(500)
              ShakeGameplayCam("HAND_SHAKE", 4.6)
            end
        end)
    else
      ShakeGameplayCam("HAND_SHAKE", 0.0)
      StopGameplayCamShaking(true)
      shakecamerastreet = false
    end
end

function DefaultCamera()
  if (shakecamerastreet) then
    ShakeGameplayCam("HAND_SHAKE", 0.0)
    shakecamerastreet = false
    StopGameplayCamShaking(true)
  end
  if IsRadarHidden() then
    --DisplayRadar(true)
  end
  if cinemamod then
    cinemamod = false
  end
end

RegisterNUICallback('radialmenu__callback', function(data, cb)
  _G[data.button](data.args)
end)

local rockstarActivate = false

Keys.Register("F3", "F3", "Rockstar Editor", function()
  if not rockstarActivate then
    rockstarActivate = true
    StartRecording(1)
  else
    rockstarActivate = false
    StopRecordingAndSaveClip()
  end
end)
