local _wheel = nil
local timeout = false
local closestBank = nil
local _lambo = nil
local _isShowCar = false
local _wheelPos = CasinoConfig.WheelPos
local _baseWheelPos = vector3(951.41, 63.77, 74.99)
local _isRolling = false

CreateThread(function()  
    local model = GetHashKey('vw_prop_vw_luckywheel_02a')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    _wheel = CreateObject(model, _wheelPos, false, false)
    SetEntityHeading(_wheel, 0.0)
    FreezeEntityPosition(_wheel,true)
    SetModelAsNoLongerNeeded(model)
    SetEntityNoCollisionEntity(PlayerPedId(), _wheel)

    while true do 
        Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z < -30.0 then
            if (GetDistanceBetweenCoords(coords, _wheelPos, true) < 2.5) then
                CasinoConfig.ShowHelpNotification(CasinoConfigSH.Lang.PlayWheel)
                if IsControlJustPressed(0, 38) then
                    if CasinoConfig.RollPrice == 0 then
                        doRoll()
                    else
                        SWTriggerServCallback("sunwisecasino:GetNumJetons", function(cb)
                            if cb >= CasinoConfig.RollPrice then
                                doRoll(CasinoConfig.RollPrice)
                            else
                                CasinoConfig.ShowNotification(CasinoConfigSH.Lang.NotEnough)
                            end                        
                        end)
                    end
                end
            else
                Wait(1000)
            end
        else
            Wait(2500)
        end
    end
end)

RegisterNetEvent("sunwise:casino:wheeldoRoll")
AddEventHandler("sunwise:casino:wheeldoRoll", function(_prizeIndex) 
    _isRolling = true
    SetEntityHeading(_wheel, 0.9754)
    CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _winAngle = (_prizeIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0

                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            SetEntityHeading(_wheel, 0.9754)
            SetEntityRotation(_wheel, 0.0, _y, 0.9754, 2, true)
            Wait(0)
        end
    end)
end)

RegisterNetEvent("sunwise:casino:wheelrollFinished")
AddEventHandler("sunwise:casino:wheelrollFinished", function() 
    if _isRolling then
    _isRolling = false
    end
end)

function doRoll(price)
    SWTriggerServCallback("sunwisecasino:getTimeWheel", function(cb)
        if cb then
            if not _isRolling then
                _isRolling = true
                local playerPed = PlayerPedId()
                local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
                local lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
                local anim = 'enter_right_to_baseidle'
                RequestAnimDict(lib)
                local _movePos = vector3(1109.7861328125, 229.18688964844, -50.635848999023)
                TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1,  360.0,  0.0)
                local _isMoved = false
                while not _isMoved do
                    local coords = GetEntityCoords(PlayerPedId())
                    if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                        _isMoved = true
                    end
                    Wait(0)
                end
                SetEntityHeading(PlayerPedId(), 0.0)
                TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                Wait(0)
                TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
                Wait(0)
                TriggerServerEvent("sunwise:casino:wheelgetLucky", price)
                TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
            end
        else
            CasinoConfig.ShowNotification(CasinoConfigSH.Lang.WaitWheel)
        end
    end, p:getSubscription())
end

RegisterNetEvent("sunwise:casino:wheelwinCar")
AddEventHandler("sunwise:casino:wheelwinCar", function()
    CasinoConfig.WinCar()
end)