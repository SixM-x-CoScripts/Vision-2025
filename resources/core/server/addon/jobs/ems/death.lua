
--Detection mort
RegisterNetEvent("core:onPlayerDeath")
AddEventHandler('core:onPlayerDeath', function(data)
    local source = source
    local src = GetPlayer(source)
    local weapon = data.deathCause
    local posVictime = vector3(data.victimCoords.x, data.victimCoords.y, data.victimCoords.z)
    if data.killedByPlayer then 
        if data.killerServerId == 0 then return end
        local target = GetPlayer(data.killerServerId)
        local causeDeath = data.causeDeath
        local posKiller = vector3(data.killerCoords.x, data.killerCoords.y, data.killerCoords.z)

        SendDiscordLog("killPlayer", source, string.sub(GetDiscord(source), 9, -1), src:getLastname() .. " ".. src:getFirstname(), json.encode(causeDeath), posVictime, data.killerServerId, string.sub(GetDiscord(data.killerServerId), 9, -1), target:getLastname() .. " " .. target:getFirstname(), weapon, posKiller, data.distance)
    else
        SendDiscordLog("killSuicide", source, string.sub(GetDiscord(source), 9, -1), src:getLastname() .. " ".. src:getFirstname(), posVictime)
    end
    -- source, discord, src:getLastname() .. " ".. src:getFirstname(), causeDeath, posVictime, data.killerServerId, discord, target:getLastname() .. " " .. target:getFirstname(), weapon, posKiller, distance
    -- local data = {
    --     victimCoords = {
    --         x = math.round(victimCoords.x, 1),
    --         y = math.round(victimCoords.y, 1),
    --         z = math.round(victimCoords.z, 1)
    --     },
    --     killerCoords = {
    --         x = math.round(killerCoords.x, 1),
    --         y = math.round(killerCoords.y, 1),
    --         z = math.round(killerCoords.z, 1)
    --     },
    --     causeDeath = table.pack(p:GetAllCauseOfDeath()),
    --     killedByPlayer = true,
    --     deathCause = killerWeapon,
    --     distance = math.round(distance, 1),

    --     killerServerId = killerServerId,
    --     killerClientId = killerClientId
    -- }
end)
