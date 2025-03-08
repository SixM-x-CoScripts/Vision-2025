local function HandleControls()
    if Freefall.PedIsSitting then
        if Freefall.InProgress then
            if Config.Enable3dText then
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))

                Draw3dText(x, y, z + 0.85, Config.Text.FREEFALL_GET_OFF)
            else
                DisplayHelpTextThisFrame('FREEFALL_GET_OFF')
            end
        else
            if Config.Enable3dText then
                local x, y, z = table.unpack(Freefall.SeatsCoords[Freefall.CurrentSeatIndex])

                Draw3dText(x, y, z + 0.85, Config.Text.FREEFALL_START)
            else
                DisplayHelpTextThisFrame('FREEFALL_START')
            end
        end

        if IsControlJustPressed(0, 75) then
            TriggerServerEvent('rcore_lunapark:Freefall:getOff', Freefall.CurrentSeatIndex)
        end

        if IsControlPressed(0, 33)  then
            TriggerServerEvent('rcore_lunapark:Freefall:start')
        end
    else
        local playerPos = GetEntityCoords(PlayerPedId())

        if #(Freefall.PlatformCoords - playerPos) < 1.5 then
            local full = true

            for i = 1, #Freefall.OccupiedSeats do
                if Freefall.OccupiedSeats[i] == 0 then
                    full = false
                    break
                end
            end

            if full then
                if Config.Enable3dText then
                    local x, y, z = table.unpack(Freefall.PlatformCoords)

                    Draw3dText(x, y, z + 1.25, Config.Text.FREEFALL_FULL)
                else
                    DisplayHelpTextThisFrame('FREEFALL_FULL')
                end
            else
                if Config.Enable3dText then
                    local x, y, z = table.unpack(Freefall.PlatformCoords)

                    Draw3dText(x, y, z + 1.25, Config.Text.FREEFALL_GET_ON)
                else
                    DisplayHelpTextThisFrame('FREEFALL_GET_ON')
                end

                if IsControlJustPressed(0, 51) then
                    if Freefall.EnterCooldown - GetGameTimer() <= 0 then
                        Freefall.EnterCooldown = GetGameTimer() + 2000
                        TriggerServerEvent('rcore_lunapark:Freefall:buyTicket')
                    end
                end
            end
        end
    end
end

local function OnTick()
    if Freefall.Timer >= 1 then
        HandleControls()
    end
end

CreateThread(function()
    while true do
        Wait(0)

        if Freefall.InSoundRange then
            OnTick()
        end
    end
end)