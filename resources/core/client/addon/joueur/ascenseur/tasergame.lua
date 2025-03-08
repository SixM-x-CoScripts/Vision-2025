local posaccred = vector3(-36.219619750977, 6382.1298828125, 31.583162307739)
local posroomred = vector3(8.1115674972534, 6408.7729492188, -23.810819625854)

local posaccblue = vector3(-43.198432922363, 6388.7783203125, 31.583166122437)
local posroomblue = vector3(-55.199863433838, 6388.9331054688, -23.810819625854)

Citizen.CreateThread(function()
    while zone == nil do Wait(0) end
    zone.addZone(
        "accrouge",
        posaccred,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            SetEntityCoords(p:ped(), posroomred)
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
        "roomrouge",
        posroomred,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            SetEntityCoords(p:ped(), posaccred)
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
        "accbleu",
        posaccblue,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            SetEntityCoords(p:ped(), posroomblue)
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
        "roombleu",
        posroomblue,
        "~INPUT_CONTEXT~ Intéragir",
        function()
            SetEntityCoords(p:ped(), posaccblue)
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
