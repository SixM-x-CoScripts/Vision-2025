Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone(
        "fib_as_1", -- Nom
        vector3(135.53392028809, -763.72497558594, 45.752040863037), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour monter", -- Text afficher
        function() -- Action qui seras fait
            SetEntityCoords(p:ped(), vector3(135.41111755371, -763.51892089844, 242.15214538574))
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleAscenseur"
    )

    zone.addZone(
        "fib_as_2", -- Nom
        vector3(135.41111755371, -763.51892089844, 242.15214538574), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour descendre", -- Text afficher
        function() -- Action qui seras fait
            SetEntityCoords(p:ped(), vector3(135.53392028809, -763.72497558594, 45.752040863037))
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        2.0,
        true,
        "bulleAscenseur"
    )
end)
