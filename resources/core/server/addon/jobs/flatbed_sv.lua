local VehAttachee = {}

RegisterServerEvent('core:GetVehAttachee')
AddEventHandler('core:GetVehAttachee',function()
    local source = source
    TriggerClientEvent('core:VehAttachee',source,VehAttachee)
end)

RegisterServerEvent('core:AddVehAttachee')
AddEventHandler('core:AddVehAttachee',function(IdCamion,IdVeh)
    local source = source
    VehAttachee[IdCamion] = IdVeh
    TriggerClientEvent('core:VehAttachee',-1,VehAttachee)
end)

RegisterServerEvent('core:DeleteVehAttachee')
AddEventHandler('core:DeleteVehAttachee',function(IdCamion)
    local source = source
    VehAttachee[IdCamion] = nil
    TriggerClientEvent('core:VehAttachee',-1,VehAttachee)
end)

RegisterServerEvent('InteractSound:PlayFromCoord')
AddEventHandler('InteractSound:PlayFromCoord',function(coord,maxDistance,soundfile,soundVolume)
    TriggerClientEvent('InteractSound:PlayFromCoord_CL',-1,coord,maxDistance,soundfile,soundVolume)
end)