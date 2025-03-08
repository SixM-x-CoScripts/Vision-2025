local posLabo = {
    { pos = vector3(-326.7500,-1356.434,31.295) },
    { pos = vector3(146.71100,-1701.907,29.291) },
    { pos = vector3(-1262.992,-1123.942,7.6170) },
    { pos = vector3(578.09400,-423.0649,24.730) },
    { pos = vector3(939.84500,-1492.575,30.085) },
    { pos = vector3(-1982.979,-242.9831,34.911) },
    { pos = vector3(-42.68900,-1289.172,29.065) },
    { pos = vector3(793.67700,-103.9858,82.031) },
    { pos = vector3(-156.2820,6291.4487,31.609) },
    { pos = vector3(-28.33600,6471.3950,31.601) },
    { pos = vector3(1381.2700,-2076.611,51.998) },
    { pos = vector3(2846.7390,4449.7680,48.516) },
    { pos = vector3(557.59100,2663.4711,42.182) },
    { pos = vector3(964.56800,3612.4609,32.757) },
    { pos = vector3(2520.8650,4125.2719,38.630) },
    { pos = vector3(452.56200,-1981.740,23.185) }
}

RegisterCommand("spawnLaboBlip", function ()
    for k,v in pairs(posLabo) do
        local blips = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
        SetBlipSprite(blips, 140)
        SetBlipScale(blips, 0.75)
        SetBlipColour(blips, 2)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(k)
        EndTextCommandSetBlipName(blips)
    end
end)

