Citizen.CreateThread(function()
    Citizen.Wait(1000)

    while true do 
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local coords = GetEntityCoords(veh ~= 0 and veh or ped)
        local _, z = GetGroundZCoordWithOffsets(coords.x, coords.y, 150.0, 0)
        local ground, groundz = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 1)

        local minHeight = 3.0
        local controlKey = 38
        local shouldFreeze = false

        if coords.z < groundz and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and (IsPedFalling(ped) or (veh ~= 0 and IsEntityInAir(veh))) then 
            drawTxt("Appuyer sur E pour vous debug", 0, 0.35, 0.5, 0.8, 0.4, 255, 153, 51, 255)

            if IsControlJustPressed(0, 38) then
                ClearPedTasksImmediately(ped)

                local targetCoords = { x = coords.x, y = coords.y, z = z}

                if veh ~= 0 then 
                    SetEntityCoordsNoOffset(veh, targetCoords.x, targetCoords.y, targetCoords.z, true, false, false)
                    SetPedIntoVehicle(ped, veh, -1)
                else
                    SetEntityCoordsNoOffset(ped, targetCoords.x, targetCoords.y, targetCoords.z, true, false, false)
                end

                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    duration = 10, 
                    content = "~c [DEBUG] Vous êtes de nouveau sur le sol"
                })

                if shouldFreeze then 
                    Citizen.CreateThread(function()
                        FreezeEntityPosition(ped, true)
                        Citizen.Wait(5000)
                        FreezeEntityPosition(ped, false)
                    end)
                end
            end
        else
            Wait(5000)
        end
        Citizen.Wait(10)
    end
end)

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextScale(0.0, 0.3)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end