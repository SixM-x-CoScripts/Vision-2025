local function GetAllCoordsFromJobVar()
    local TableReturn = {}
    for k,v in pairs(GetVariable("job")) do
        if v.djpoint then
            table.insert(TableReturn, {coords = v.djpoint, onlyjob = v.djonlyjob})
        end
    end
    return TableReturn
end

local DJList = {}

RegisterNetEvent('core:create:dj')
AddEventHandler('core:create:dj', function(djName, position, jobName, crewName, distance)
    local source = source
    if GetPlayer(source):getPermission() < 2 then return end

    local jobsArray = {}
    if jobName == "Aucun" then
        jobsArray = nil
    else
        for str in jobName:gmatch("%s*([^,%s]+)%s*,?") do
            table.insert(jobsArray, str)
        end
    end

    local crewsArray = {}
    if crewName == "Aucun" then
        crewsArray = nil
    else
        for str in crewName:gmatch("%s*([^,%s]+)%s*,?") do
            table.insert(crewsArray, str)
        end
    end

    local data = {
        mixer = {
            pos = position,
            distance = 5,
            jobs = jobsArray,
            crews = crewsArray
        },
        speaker = {
            pos = position,
            distance = distance,
        },
        defaultVolume = 0.5,
    }

    local encodedData = json.encode(data)

    MySQL.Async.execute('INSERT INTO dj_sets (name, data) VALUES (@name, @data)', {
        ['@name'] = djName,
        ['@data'] = encodedData
    }, function(rowsChange)
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'VERT',
            content = "~c Le point DJ a bien été créé"
        })
        DJList[djName] = data
        TriggerClientEvent('core:createDJSet', -1, djName, position, jobsArray, crewsArray, distance)
    end)
end)

RegisterNetEvent('core:delete:dj')
AddEventHandler('core:delete:dj', function(djName)
    local source = source
    if GetPlayer(source):getPermission() < 2 then return end

    DJList[djName] = nil
    TriggerClientEvent('core:deleteDJSet', -1, djName)

    MySQL.Async.execute('DELETE FROM dj_sets WHERE name = @name', {
        ['@name'] = djName
    })

    TriggerEvent("core:dj:stop", djName, true)
end)

local function GetAllCoordsFromDJVar()
    local TableReturn = {}
    for k,v in pairs(GetVariable("dj")) do
        if v.coords and v.name then
        end
    end
    return TableReturn
end

DJPlayingSong = {}

CreateThread(function()
    while not GetVariable do Wait(1000) end
    if GetVariable("job") then
        GetAllCoordsFromJobVar()
    end
    if GetVariable("dj") then
        GetAllCoordsFromDJVar()
    end
    RegisterServerCallback("core:dj:getInfo", function(source,name)
        return DJPlayingSong[name]
    end)
    RegisterServerCallback("core:getDjPlaylist", function(source,name)
        return DJPlayingSong[name] and DJPlayingSong[name].List or {
            {
                title = "Aucun",
                url = "",
                position = 0,
                active = true,
            },
        }
    end)
    RegisterServerCallback("core:getMySavedMusic", function(source,name)
        return DJPlayingSong[name] and DJPlayingSong[name].Saved or {
            {
                title = "Aucun",
                url = "",
            },
        }
    end)
    RegisterServerCallback("core:dj:getDatas", function(source,name)
        local vol = DJPlayingSong[name] and DJPlayingSong[name].volume or 0.5
        local musicPlay = DJPlayingSong[name] and DJPlayingSong[name].Playing and DJPlayingSong[name].Playing.title or nil
        return {
            volume = vol,
            musicPlaying = musicPlay
        }
    end)
    RegisterServerCallback('core:admin:getAllDJSets', function()
        return DJList
    end)


    MySQL.Async.fetchAll("SELECT * FROM dj", {}, function(result)
        if not result then return end
        if not next(result) then return end
        for _, v in pairs(result) do
            if not DJPlayingSong[v.name] then
                DJPlayingSong[v.name] = {}
                DJPlayingSong[v.name].Saved = json.decode(v.list)
            end
        end
    end)

    MySQL.Async.fetchAll('SELECT * FROM dj_sets', {}, function(result)
        if not result then return end
        for _, v in ipairs(result) do
            DJList[v.name] = json.decode(v.data)
        end
    end)
end)

local function PlayNextSong(name)
    if not DJPlayingSong[name] then return end
    if not DJPlayingSong[name].List then return end
    for k,v in ipairs(DJPlayingSong[name].List) do
        if DJPlayingSong[name].Playing and v.url == DJPlayingSong[name].Playing.url then
            if DJPlayingSong[name].List[k+1] and DJPlayingSong[name].List[k+1].url then
                local YtbName = GetYoutubeNameFromLink(DJPlayingSong[name].List[k+1].url)
                DJPlayingSong[name].Playing.url = DJPlayingSong[name].List[k+1].url
                DJPlayingSong[name].Playing.title = DJPlayingSong[name].List[k+1].title
                DJPlayingSong[name].WaitingForNewSong = false
                TriggerClientEvent("core:dj:play", -1, name, DJPlayingSong[name].coords, DJPlayingSong[name].distance, DJPlayingSong[name].Playing.url, DJPlayingSong[name].volume, YtbName)
                break
            else
                DJPlayingSong[name].Playing = nil
                DJPlayingSong[name].WaitingForNewSong = true
            end
        end
    end
end

RegisterNetEvent("core:dj:ended", function(name)
    if not DJPlayingSong[name] then return end
end)

RegisterNetEvent("core:savemymusic", function(name, url, songname)
    if not DJPlayingSong[name] then
        DJPlayingSong[name] = {}
    end
    if not DJPlayingSong[name].Saved then
        DJPlayingSong[name].Saved = {}
    end
    table.insert(DJPlayingSong[name].Saved, {url = url, title = songname})
    DJPlayingSong[name].NeedSave = true
end)

RegisterNetEvent("core:dj:play", function(name, coords, distance, ytb, vol, shouldSave)
    local YtbName = GetYoutubeNameFromLink(ytb)
    if not name then return end
    if DJPlayingSong[name] then
        if not DJPlayingSong[name].coords then
            DJPlayingSong[name].coords = coords
            DJPlayingSong[name].distance = distance
            DJPlayingSong[name].volume = vol
        end
    else
        DJPlayingSong[name] = {}
        DJPlayingSong[name] = {name = name, coords = coords, distance = distance, volume = vol}
    end
    if not ytb then
        PlayNextSong(name)
        return
    end
    if not DJPlayingSong[name].List then
        DJPlayingSong[name].List = {}
        DJPlayingSong[name].Playing = {url = ytb, title = YtbName}
        table.insert(DJPlayingSong[name].List, {url = ytb, title = YtbName, position = 0, active = true})
        print("go play " .. ytb)
        TriggerClientEvent("core:dj:play", -1, name, coords, distance, ytb, DJPlayingSong[name].volume, YtbName)
    else
        if not DJPlayingSong[name].WaitingForNewSong then
            print("Insert for waiting")
            table.insert(DJPlayingSong[name].List, {url = ytb, title = YtbName, position = 0, active = false})
        else
            print("Play because waiting for song")
            DJPlayingSong[name].Playing = {url = ytb, title = YtbName}
            DJPlayingSong[name].WaitingForNewSong = false
            TriggerClientEvent("core:dj:play", -1, name, coords, distance, ytb, DJPlayingSong[name].volume, YtbName)
        end
    end
    if shouldSave then
        if not DJPlayingSong[name] then
            DJPlayingSong[name] = {}
        end
        if not DJPlayingSong[name].Saved then
            DJPlayingSong[name].Saved = {}
        end
        table.insert(DJPlayingSong[name].Saved, {url = ytb, title = YtbName})
        DJPlayingSong[name].NeedSave = true
    end
end)

RegisterNetEvent("core:dj:stop", function(name, forceStop)
    if DJPlayingSong[name] and not forceStop then
        print("WaitingForNewSong")
        DJPlayingSong[name].WaitingForNewSong = true
        PlayNextSong(name)
    end
    if forceStop then
        DJPlayingSong[name].Playing = nil
        DJPlayingSong[name].WaitingForNewSong = true
    end
    TriggerClientEvent("core:dj:stop", -1, name)
end)

local AntiSpam = {}
RegisterNetEvent("core:dj:volume", function(name, volume)
    if AntiSpam[name] then
        if AntiSpam[name].ToGo then
            AntiSpam[name].ToGo = false
            Wait(1000)
            DJPlayingSong[name].volume = volume
            TriggerClientEvent("core:dj:volume", -1, name, volume)
            AntiSpam[name] = nil
        end
    else
        AntiSpam[name] = {ToGo = true}
        DJPlayingSong[name].volume = volume
        TriggerClientEvent("core:dj:volume", -1, name, volume)
    end
end)

RegisterNetEvent("core:create:dj", function(name, dist, coords)
    local src = source
    local ply = GetPlayer(src)
    local perm = ply:getPermission()
    if perm >= 2 then
        if not GetVariable("dj") then
            SetVariable("dj", {})
        end
        TriggerClientEvent("core:create:dj", -1, name, dist, coords)
    else
        SunWiseKick(src, "Tried to exec core:create:dj with perm " .. perm)
    end
end)

CreateThread(function()
    --Wait(30000)
    while true do
        Wait(10*60000)
        local counted = 0
        for k,v in pairs(DJPlayingSong) do
            if v.NeedSave then
                MySQL.Async.execute('INSERT INTO dj (name, list) VALUES (@name, @list) ON DUPLICATE KEY UPDATE list = @list', {
                    ['@name'] = k,
                    ['@list'] = json.encode(v.Saved)
                }, function(rowsChange)
                end)
                counted += 1
                v.NeedSave = false
            end
        end
        if counted > 0 then
            CorePrint("Saved ^3x"..counted.."^7 dj points")
        end
    end
end)
