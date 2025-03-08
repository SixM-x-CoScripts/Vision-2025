RegisterNetEvent("core:plyBoomSong", function(token, musicId, url, volume, coords)
    local src = source
    if CheckPlayerToken(src, token) then
        TriggerClientEvent("core:plyBoomSongC", -1, musicId, url, volume, coords)
    end
end)

local AntiSpam = {}
RegisterNetEvent("core:BoomSongVolume", function(token, musicId, volume)
    local src = source
    if AntiSpam[src] then 
        if AntiSpam[src].ToGo then
            AntiSpam[src].ToGo = false
            Wait(2000)
            TriggerClientEvent("core:BoomSongVolumeC", -1, musicId, volume)
            AntiSpam[src] = nil
        end
    else
        AntiSpam[src] = {ToGo = true}
        TriggerClientEvent("core:BoomSongVolumeC", -1, musicId, volume)
    end
end)

RegisterNetEvent("core:updateSongPos", function(token, tablePlayers, musicid, coords)
    local src = source
    if CheckPlayerToken(src, token) then
        TriggerClientEvents("core:updateSongPosC", tablePlayers, musicid, coords)
    end
end)

RegisterNetEvent("core:PauseBoomSong", function(token, musicId, typer)
    local src = source
    if CheckPlayerToken(src, token) then
        TriggerClientEvent("core:PauseBoomSongC", -1, musicId, typer)
    end
end)