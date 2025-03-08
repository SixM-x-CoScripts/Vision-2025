local token
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
function StartIntroAnimation()

    DoScreenFadeOut(1)
    Wait(1)
    ClearFocus()
    SetEntityCoords(p:ped(), -1126.5367431641, -1866.0819091797, 2.312967300415, 0.0, 0.0, 0.0, 0)
    FreezeEntityPosition(p:ped(), true)
    forceHideRadar()
    local civil = p:getCloths().skin
    --RequestCutscene("MP_INTRO_CONCAT", 8) -- Usually 8.
    SetAudioFlag("LoadMPData", true)
    PrepareMusicEvent("FM_INTRO_START")
    TriggerMusicEvent("FM_INTRO_START")
    RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 103, 8)
    while not (HasCutsceneLoaded()) do
        Wait(0)
    end

    -- Sets current player ped as cutscene mp ped.
    if p:isMale() then
        SetCutsceneEntityStreamingFlags("MP_Male_Character", 0, 1)
        RegisterEntityForCutscene(PlayerPedId(), "MP_Male_Character", 0, 0, 64)
        SetCutsceneEntityStreamingFlags("MP_Female_Character", 0, 1)
        RegisterEntityForCutscene(PlayerPedId(), "MP_Female_Character", 3, GetHashKey("mp_f_freemode_01"), 0)
        for i = 1, 7 do
            SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_" .. tostring(i), 0, 1)
            RegisterEntityForCutscene(0, "MP_Plane_Passenger_" .. tostring(i), 3, GetHashKey("mp_f_freemode_01"), 0)
            RegisterEntityForCutscene(0, "MP_Plane_Passenger_" .. tostring(i), 3, GetHashKey("mp_m_freemode_01"), 0)
        end
    else
        SetCutsceneEntityStreamingFlags("MP_Female_Character", 0, 1)
        RegisterEntityForCutscene(PlayerPedId(), "MP_Female_Character", 0, 0, 64)
        SetCutsceneEntityStreamingFlags("MP_Male_Character", 0, 1)
        RegisterEntityForCutscene(PlayerPedId(), "MP_Male_Character", 3, GetHashKey("mp_f_freemode_01"), 0)
        for i = 1, 7 do
            SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_" .. tostring(i), 0, 1)
            RegisterEntityForCutscene(0, "MP_Plane_Passenger_" .. tostring(i), 3, GetHashKey("mp_f_freemode_01"), 0)
            RegisterEntityForCutscene(0, "MP_Plane_Passenger_" .. tostring(i), 3, GetHashKey("mp_m_freemode_01"), 0)
        end
    end


    StartCutscene(0)

    DoScreenFadeIn(1000)
    -- Waiting for the cutscene to spawn the mp ped.

    while not (DoesCutsceneEntityExist("MP_Male_Character", 0)) do
        Wait(0)
    end


    for k, v in pairs(civil) do
        p:setCloth(k, v)
        Wait(0)
    end


    while not (HasCutsceneFinished()) do


        if GetCutsceneTime() >= 25000 then
            DoScreenFadeOut(2500)

            Wait(2500)
            PrepareMusicEvent("FM_INTRO_DRIVE_END")
            TriggerMusicEvent("FM_INTRO_DRIVE_END")

            ClearFocus()

            StopCutsceneImmediately()
            FreezeEntityPosition(p:ped(), false)
            openRadarProperly()


        end

        Wait(0)
    end
    TriggerServerEvent("core:InstancePlayer", token, 0, "intro_annimation")
    SetEntityCoordsNoOffset(p:ped(), -822.75482177734, -1223.1422119141, 7.3654098510742, 0.0, 0.0, 0.0, 0)
    SetEntityHeading(p:ped(), 54.535850524902)
    SetEntityCollision(p:ped(), true, true)
    SetEntityVisible(p:ped(), true, true)
    SetEntityInvincible(p:ped(), true)
    SetEntityInvincible(p:ped(), false)
    ExecuteCommand("save")
    ExecuteCommand("sync")
    DoScreenFadeIn(2000)
end

-- RegisterCommand('intro', function()
--     StartIntroAnimation()
-- end)
