local LastRandomID = 0

local CurrentRandomFireID = 0

Citizen.CreateThread(function()
    while true do
        Wait((Config.RandomFires.Delay * 60) * 1000)
        if Config.RandomFires.Enabled then
            local fires = Config.RandomFires.Locations[Config.RandomFires.AOP]
            if(fires and #fires > 0) then
                
                if(#fires == 1) then
                    LastRandomID = 0--There is only one location so it should repeat
                end

                --Get A Random Location
                local randomID = 0
                repeat
                    randomID = math.random(#fires)
                until randomID ~= LastRandomID
                LastRandomID = randomID

                local fireData = fires[randomID]

                TotalFires = TotalFires + 1
                CurrentFireID = CurrentFireID + 1

                local data = {
                    ["position"] = { x = fireData.position.x, y = fireData.position.y, z = fireData.position.z },
                    ["flames"] = fireData.flames,
                    ["spread"] = fireData.spread,
                    ["info"] = Config.FireTypes[fireData.type]
                }
                TriggerClientEvent('FireScript:SyncFire', -1, CurrentFireID, data)
                data["id"] = CurrentFireID
                data["position"] = fireData.position
                data["location"] = fireData.location
                AllFires[CurrentFireID] = data

                print("Random Fire Started At " .. fireData.location)
                
                TriggerEvent('core:makeCall', "lsfd", AllFires[CurrentFireID]["position"], false, "Un nouveau feu a été signalé !")
                TriggerEvent("FireScript:FireStarted", CurrentFireID)
                CurrentRandomFireID = CurrentFireID
                Wait(fireData.timeout * 1000) --Check If Its Taken out

                if AllFires[CurrentRandomFireID] then --Fire not taken out, take it out manually
                    StopFire(CurrentRandomFireID)
                end

            else
                print("Failed Loading Random Fire For AOP " .. Config.RandomFires.AOP)
            end
        end
    end
end)

RegisterServerEvent("FireScript:SetAOP")
AddEventHandler("FireScript:SetAOP", function(aop)
	Config.RandomFires.AOP = aop
    LastRandomID = 0
end)

RegisterServerEvent("FireScript:EnableRandomFires")
AddEventHandler("FireScript:EnableRandomFires", function(enable)
	Config.RandomFires.Enabled = enable
end)