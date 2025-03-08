local pos_ile = vector3(-1021.7836914063, -92.488265991211, -99.40307617188)
-- local tp_ile = vector3(4040.9150390625, 8008.1875, 117.14750671387)
local pos_ls = vector3(479.03967285156, -106.90042114258, 63.157886505127)
-- local tp_ls = vector3(-725.7529296875, -1444.4907226563, 5.4611053466797)

Citizen.CreateThread(function()
    while zone == nil do Wait(1000) end
    zone.addZone(
        "50records_tp",
        pos_ile,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), pos_ls)
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
        "50records_ls",
        pos_ls,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            bypassAntiTeleport = true 
            Wait(100)
            SetEntityCoords(p:ped(), pos_ile)
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
