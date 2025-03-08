local posbas = vector3(967.10650634766, 7.5780334472656, 81.2)
local poshaut = vector3(964.92034912109, 58.62455368042, 112.55307006836)

Citizen.CreateThread(function()
    while zone == nil do Wait(0) end
    zone.addZone(
        "casino_bas",
        posbas,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), poshaut)
            Wait(1000)
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
        "casino_haut",
        poshaut,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), posbas)
            Wait(1000)
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
