local posbas = vector3(2504.4152832031, -433.13842773438, 98.112205505371)
local poshaut = vector3(2504.4455566406, -433.13055419922, 105.91299438477)

Citizen.CreateThread(function()
    while zone == nil do Wait(0) end
    zone.addZone(
        "noose_bas",
        posbas,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), poshaut)
            Wait(1000)
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

    zone.addZone(
        "noose_haut",
        poshaut,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), posbas)
            Wait(1000)
        end,
        true,
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )
end)