Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    Wait(1000)
    zone.addZone("vault", vector3(237.12397766113, 231.41835021973, 96.117141723633),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir la porte du coffre",
        function()
            openVault()
        end,
        false, -- Avoir un marker ou non
        29, -- Id / type du marker
        1.0, -- La taille
        {50, 168, 82}, -- RGB
        170, -- Alpha
        5.0,
        true,
        "bulleOuvrirCoffre"
    )
end)

function openVault()
    TriggerEvent("core:openVault")
    TriggerEvent("core:vaultSound")
end


RegisterNetEvent("core:openVault") -- vault door done
AddEventHandler("core:openVault", function()
    local doorcoords = {236.1346282959, 229.20481872559, 96.117164611816}
    local obj = GetClosestObjectOfType(doorcoords[1],doorcoords[2], doorcoords[3], 1.5, 9611976194,false,false,false)
    local count = 0
    repeat
      local rotation = GetEntityHeading(obj) - 0.05
      SetEntityHeading(obj,rotation)
      count = count + 1
      Citizen.Wait(10)
    until count == 1500
    FreezeEntityPosition(obj, true)
end)

RegisterNetEvent("core:vaultSound")
AddEventHandler("core:vaultSound", function()
    local sescount = 0
    repeat
      PlaySoundFrontend(-1,"OPENING", "MP_PROPERTIES_ELEVATOR_DOORS" ,1)
      Citizen.Wait(900)
      sescount = sescount + 1
    until sescount == 18
end)