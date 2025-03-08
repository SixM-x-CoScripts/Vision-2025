
--2519.9675292969, 4406.1821289063, 36.442028045654, 223.86827087402
CreateThread(function()
    local ped = entity:CreatePedLocal("s_m_m_cntrybar_01", vector3(2519.4985351563, 4406.5083007813, 36.524688720703), 208.75006103516)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
end)

local Mowposes = {
    {x=2522.6838378906, y=4401.7768554688, z=36.255154418945},
    {x=2525.5329589844, y=4398.8100585938, z=36.335774230957},
    {x=2529.2888183594, y=4395.0537109375, z=36.651253509521},
    {x=2532.6450195313, y=4391.6953125,    z=36.958275604248},
    {x=2535.6049804688, y=4389.0263671875, z=37.245907592773},
}

RegisterCommand("startMower", function()
    local objs = {}
    RequestModel(GetHashKey('prop_veg_grass_01_d'))
    while not HasModelLoaded(GetHashKey('prop_veg_grass_01_d')) do Wait(1) end
    for i = 1, #Mowposes do 
        objs[i] = CreateObject(GetHashKey('prop_veg_grass_01_d'), Mowposes[i].x, Mowposes[i].y, Mowposes[i].z)
    end
    local veh = vehicle.create("mower", vector4(2522.9426269531, 4402.8588867188, 36.485172271729, 223.0411), {})
    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
    while true do 
        Wait(100)
        for i = 1, #objs do 
            local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(objs[i]))
            if dist < 1.2 then 
                if IsPedInAnyVehicle(PlayerPedId()) then 
                    DeleteEntity(DeleteEntity(objs[i]))
                end
            end
        end
    end
end)