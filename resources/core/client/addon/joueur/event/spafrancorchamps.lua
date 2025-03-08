--[[local pos_ile = vector3(4063.2163085938, 8017.0668945313, 114.7562789917)
local tp_ile = vector3(4063.2163085938, 8017.0668945313, 114.7562789917)
local pos_ls = vector3(-704.71020507813, -1394.3002929688, 4.1502647399902)
local tp_ls = vector3(-704.71020507813, -1394.3002929688, 4.1502647399902)

Citizen.CreateThread(function()
    while zone == nil do Wait(0) end
    zone.addZone(
        "event_ile",
        pos_ile,
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir",
        function()
            SetEntityCoords(p:ped(), tp_ls)
        end,
        false
    )

    zone.addZone(
        "event_ls",
        pos_ls,
        "Appuyer sur ~INPUT_CONTEXT~ pour interagir",
        function()
            SetEntityCoords(p:ped(), tp_ile)
        end,
        false
    )
end)

CreateThread(function()
    local ped = nil
    local ped2 = nil
    if not created then
        ped3 = entity:CreatePedLocal("s_m_m_pilot_01", vector3(-704.18792724609, -1394.7145996094, 4.1502656936646),
            55.501194000244)
        ped4 = entity:CreatePedLocal("s_m_m_pilot_01", vector3(4063.4143066406, 8017.8979492188, 114.73371887207),
            166.70497131348)

        created = true
    end

    SetEntityInvincible(ped3.id, true)
    ped3:setFreeze(true)
    TaskStartScenarioInPlace(ped3.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped3.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped3.id, true)

    SetEntityInvincible(ped4.id, true)
    ped4:setFreeze(true)
    TaskStartScenarioInPlace(ped4.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped4.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped4.id, true)

end)]]