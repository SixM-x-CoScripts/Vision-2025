local IsOnIsland = false
local ClosestTeleportLocation = nil
local IsTeleporting = false
local CutscenesLong = false
local CutscenesEnabled = true


function LoadCutscene(cut, flag1, flag2)
  if (not flag1) then
    RequestCutscene(cut, 8)
  else
    RequestCutsceneEx(cut, flag1, flag2)
  end
  while (not HasThisCutsceneLoaded(cut)) do Wait(0) end
  return
end

local function BeginCutsceneWithPlayer()
  local plyrId = PlayerPedId()
  local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)

  SetBlockingOfNonTemporaryEvents(playerClone, true)
  SetEntityVisible(playerClone, false, false)
  SetEntityInvincible(playerClone, true)
  SetEntityCollision(playerClone, false, false)
  FreezeEntityPosition(playerClone, true)
  SetPedHelmet(playerClone, false)
  RemovePedHelmet(playerClone, true)

  SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
  RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)

  Wait(10)
  StartCutscene(0)
  Wait(10)
  ClonePedToTarget(playerClone, plyrId)
  Wait(10)
  DeleteEntity(playerClone)
  Wait(50)
  DoScreenFadeIn(250)

  return playerClone
end

local function Finish(timer)
  local tripped = false

  repeat
    Wait(0)
    if (timer and (GetCutsceneTime() > timer))then
      DoScreenFadeOut(250)
      tripped = true
    end

    if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
      DoScreenFadeOut(250)
      tripped = true
    end
  until not IsCutscenePlaying()
  if (not tripped) then
    DoScreenFadeOut(100)
    Wait(150)
  end
  return
end

local landAnim = {1, 2, 4}
local timings = {
  [1] = 9100,
  [2] = 17500,
  [4] = 25400
}

function BeginLeaving(isIsland)
  if (isIsland) then
    RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)

    LoadCutscene('hs4_nimb_isd_lsa', 8, 24)
    BeginCutsceneWithPlayer()
    Finish()
    RemoveCutscene()
  else
    RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)

    LoadCutscene('hs4_lsa_take_nimb2')
    BeginCutsceneWithPlayer()

    Finish()
    RemoveCutscene()

    if (CutscenesLong) then
      LoadCutscene('hs4_nimb_lsa_isd', 128, 24)
      BeginCutsceneWithPlayer()
      Finish(165000)

      LoadCutscene('hs4_nimb_lsa_isd', 256, 24)
      BeginCutsceneWithPlayer()
      Finish(170000)

      LoadCutscene('hs4_nimb_lsa_isd', 512, 24)
      BeginCutsceneWithPlayer()
      Finish(175200)
      RemoveCutscene()
    end
  end
end

function BeginLanding(isIsland)
  if (isIsland) then
    RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)
    local flag = landAnim[ math.random( #landAnim ) ]
    LoadCutscene('hs4_lsa_land_nimb', flag, 24)
    BeginCutsceneWithPlayer()
    Finish(timings[flag])
    RemoveCutscene()
  else
    LoadCutscene('hs4_nimb_lsa_isd_repeat')

    RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)
    BeginCutsceneWithPlayer()

    Finish()
    RemoveCutscene()
  end
end

local function GetToCoordinate(location)
  if not location then location = {} end
  local coordinate = location.IslandCoordinate or vector3(4436.5322265625, -4487.3408203125, 4.2469692230225)
  local heading = location.IslandHeading or 199.1714630127

  if IsOnIsland or (GetDistanceBetweenCoords(4436.5322265625, -4487.3408203125, 4.2469692230225, GetEntityCoords(p:ped())) < 3.0) then
    coordinate = vector3(-1040.7633056641, -2742.9753417969, 12.944957733154)
    heading = 326.85543823242
    IsOnIsland = true
  end

  return coordinate, heading
end

function TeleportCayoMenu()
  local endCoordinate, endHeading = GetToCoordinate(ClosestTeleportLocation)

  NoMoreATH()
  if not IsTeleporting then
    Citizen.CreateThread(function()
      if not IsPlayerTeleportActive() then
        IsTeleporting = true
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)

        if IsScreenFadedIn() then
          DoScreenFadeOut(500)
          while not IsScreenFadedOut() do
            Wait(50)
          end
        end

        if (CutscenesEnabled) then
          BeginLeaving(IsOnIsland)
        end

        if (CutscenesEnabled) then
          BeginLanding(IsOnIsland)
        end

        StartPlayerTeleport(PlayerId(), endCoordinate.x, endCoordinate.y, endCoordinate.z, endHeading, true, true, false)

        local start = GetGameTimer()
        while IsPlayerTeleportActive() do
          if GetGameTimer() - start > 20000 then
            if IsScreenFadedOut() then
              DoScreenFadeIn(0)
            end
            return
          end
          Wait(500)
        end

        SetGameplayCamRelativePitch(0.0, 1.0)
        SetGameplayCamRelativeHeading(0.0)

        if IsScreenFadedOut() then
          DoScreenFadeIn(1000)
          while not IsScreenFadedIn() do
            Wait(50)
          end
        end

        IsTeleporting = false
        IsOnIsland = not IsOnIsland
        NoMoreATH()
        FreezeEntityPosition(ped, false)
      end
    end)
  end
end
    
zone.addZone("cayoTP1",
    vector3(4436.5322265625, -4487.3408203125, 4.2469692230225),
    "~INPUT_CONTEXT~ Magasin de vêtements",
    function()
      if p:pay(200) then
        TeleportCayoMenu()
      end
    end, 
    true,
    33,
    0.5,
    { 255, 255, 255 },
    170,
    3.0,
    true,
    "bulleLosSantos"
)
zone.addZone("cayoTP2",
    vector3(-1042.24, -2745.33, 21.36),
    "~INPUT_CONTEXT~ Magasin de vêtements",
    function()
      if p:pay(200) then
        TeleportCayoMenu()
      end
    end, 
    true,
    33,
    0.5,
    { 255, 255, 255 },
    170,
    3.0,
    true,
    "bulleCayo"
)