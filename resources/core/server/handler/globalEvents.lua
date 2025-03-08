RegisterNetEvent("core:OpenVehicleTruck")
AddEventHandler("core:OpenVehicleTruck", function(net)
    TriggerClientEvent("core:OpenVehicleTruck", NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(net)), net) 
end)

RegisterNetEvent("core:CloseVehicleTruck")
AddEventHandler("core:CloseVehicleTruck", function(net)
    TriggerClientEvent("core:CloseVehicleTruck", NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(net)), net) 
end)