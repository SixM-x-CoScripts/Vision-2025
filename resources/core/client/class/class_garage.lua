-- "simulation" d'une class car Lua n'a pas vraiment de class, c'est juste pratique de faire ça
--TODO: enlever ca pour faire un vrai garage avec le system de propriete
local garageMenu = RageUI.CreateMenu("Garage", "~b~Sortir un véhicule")
garage = {
    vehicles = {},
    outPos = {},
    open = false,

    setVehicles = function(vehs)
        garage.vehicles = vehs
    end,

    setOutPos = function(pos)
        garage.outPos = pos
    end,

    getRandomPos = function()
        SetRandomSeed(0)
        return garage.outPos[math.random(1, #garage.outPos)]
    end,

    openGarage = function()
        if not garage.open then
            garage.open = true
            RageUI.Visible(garageMenu, true)
            OpenGarageMenu()
        end
    end,

    closeGarage = function()
        if garage.open then
            garage.open = false
            RageUI.Visible(garageMenu, false)
        end
    end,
}


garageMenu.Closed = function()
    garage.open = false
    RageUI.Visible(garageMenu, false)
end

function OpenGarageMenu()
    Citizen.CreateThread(function()
        while garage.open do
            RageUI.IsVisible(garageMenu, function()

                if not p:isInVeh() then
                    for k,v in pairs(garage.vehicles) do
                        if v.stored == true or v.stored == 1 then
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.veh))) or v.veh, nil, {}, true, {
                                onSelected = function()
                                    local pos = garage.getRandomPos()
                                    local veh = vehicle.create(v.veh, pos, v.props)
                                    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                                    garage.closeGarage()
                                    TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(veh)), VehToNet(veh), veh)
                                end,    
                            }); 
                        elseif v.stored == false or v.stored == 0 then
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.veh))) or v.veh, nil, {RightLabel = "~r~SORTIE"}, true, {}); 
                        else
                            RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.veh))) or v.veh, nil, {RightLabel = "~e~Fourrière"}, true, {}); 
                        end
                    end
                else
                    RageUI.Button("Ranger votre véhicule", "Attention, si vous rangez un véhicule qui ne vous appartient pas ( volé / Véhicule de métier, il sera simplement supprimé de la map)", {}, true, {
                        onSelected = function()
                            local myVeh = TriggerServerCallback("core:SetVehicleIn", all_trim(GetVehicleNumberPlateText(p:currentVeh())))
                            if myVeh then
                                local veh = entity:register(p:currentVeh())
                                veh:delete()
                                local result = TriggerServerCallback('core:GetVehicles')
					            garage.setVehicles(result)
                                RageUI.CloseAll()
                                garage.closeGarage()
                            else
                                local veh = entity:register(p:currentVeh())
                                veh:delete()
                            end
                        end,    
                    }); 
                end
            end)
            Wait(1)
        end
    end)
end