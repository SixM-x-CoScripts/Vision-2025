isTrembling = false

RegisterNetEvent("core:StartTremblement", function()
    isTrembling = true
    Wait(1000)
    RequestAnimSet("move_m@drunk@verydrunk")
    while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(1)
    end

    SetTimecycleModifier("spectator5")
    
    local count = 0
    xSound:PlayUrl("tremblement", "https://youtu.be/0HO9fgplJOI", 1.0)
    
    Wait(2000)
    ShakeGameplayCam("SKY_DIVING_SHAKE", 0.1)
    while count < 45 do 
        
        
        if count == 2 then
            SetGameplayCamShakeAmplitude(1.0)
        elseif count == 9 then
            DoScreenFadeOut(300)
            Wait(300)
            SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", true)
            DoScreenFadeIn(800)
            SetGameplayCamShakeAmplitude(2.0)
        elseif count == 11 then 
            SetGameplayCamShakeAmplitude(4.0)
        elseif count == 16 then 
            SetGameplayCamShakeAmplitude(5.0)
        elseif count == 18 then 
            SetGameplayCamShakeAmplitude(7.0)
        elseif count == 21 then 
            SetGameplayCamShakeAmplitude(9.0)
        elseif count == 30 then
            SetGameplayCamShakeAmplitude(7.0)
        elseif count == 35 then 
            SetGameplayCamShakeAmplitude(5.0)
        elseif count == 36 then 
            SetGameplayCamShakeAmplitude(4.0)
        elseif count == 37 then 
            SetGameplayCamShakeAmplitude(3.0)
        elseif count == 39 then 
            SetGameplayCamShakeAmplitude(2.0)
        elseif count == 40 then 
            SetGameplayCamShakeAmplitude(1.0)
        end
        count = count + 1
        Wait(1000)
    end
    DoScreenFadeOut(300)
    Wait(350)

    ResetPedMovementClipset(PlayerPedId())
    ShakeGameplayCam("SKY_DIVING_SHAKE", 0.0)
    xSound:Destroy("tremblement")
    DoScreenFadeIn(500)
    Wait(500)
    
    
    isTrembling = false
end)