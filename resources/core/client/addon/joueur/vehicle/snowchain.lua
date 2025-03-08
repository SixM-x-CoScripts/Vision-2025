local VehicleTrails = true

RegisterNetEvent('Vision::toggleSnowChain')
AddEventHandler('Vision::toggleSnowChain', function()
    SetVehicleTrailsXmas(not VehicleTrails)
end)

RegisterNetEvent('Vision::forceSnowChain')
AddEventHandler('Vision::forceSnowChain', function(NewVehicleTrail)
    SetVehicleTrailsXmas(NewVehicleTrail)
end)

function SetVehicleTrailsXmas(NewVehicleTrail)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        VehicleTrails = NewVehicleTrail
        if VehicleTrails then
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous enlevez les chaînes de neige de votre voiture."
            })

	    SetForceVehicleTrails(VehicleTrails)
        else

            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Progressbar',
                data = {
                    text = "Vous mettez les chaînes à neige...",
                    time = 5,
                }
            }))

            Wait(8000)
        
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous serez seul à ne pas glisser sur la neige avec cette voiture (pour des raisons techniques)"
            })

	    SetForceVehicleTrails(VehicleTrails)
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous devez être dans un vehicule."
        })
    end
end

-- Citizen.CreateThread(function()
--	while true do
-- 		Citizen.Wait(0)
-- 
--		SetForceVehicleTrails(VehicleTrails)
--
--	end
--end)
