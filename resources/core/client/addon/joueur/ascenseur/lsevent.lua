Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone(
        "fib_as_1", -- Nom
        vector3(-288.38552856445, -722.37512207031, 124.47332000732), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour monter", -- Text afficher
        function() -- Action qui seras fait
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), vector3(-304.92752075195, -720.99621582031, 27.028614044189))
        end,
        true, -- Avoir un marker ou non
        27, -- Id / type du marker
        0.5, -- La taille
        { 255, 255, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone(
        "fib_as_2", -- Nom
        vector3(-304.92752075195, -720.99621582031, 27.028614044189), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour descendre", -- Text afficher
        function() -- Action qui seras fait
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), vector3(-288.38552856445, -722.37512207031, 124.47332000732))
        end,
        true, -- Avoir un marker ou non
        27, -- Id / type du marker
        0.5, -- La taille
        { 255, 255, 255 }, -- RGB
        170-- Alpha
    )
end)
