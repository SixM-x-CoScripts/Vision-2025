local npcsToSpawn = {
    { model = 'ig_manuel', x = 4927.9438476563, y = -5292.2475585938, z = 4.9025921821594, heading = 82.74535369873 },
}

function SpawnNPCs()
    for _, npc in ipairs(npcsToSpawn) do
        local modelHash = GetHashKey(npc.model)

        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(0)
        end

        local ped = CreatePed(4, modelHash, npc.x, npc.y, npc.z, npc.heading, false, false)
        
        SetEntityInvincible(ped, true)
        SetEntityHasGravity(ped, false)
        SetEntityCollision(ped, false, false)
        SetBlockingOfNonTemporaryEvents(ped, true)

        FreezeEntityPosition(ped, true)
    end
end

Citizen.CreateThread(function()
    SpawnNPCs()
end)