xSound = exports.xsoundtemp

DJList = {}

Citizen.CreateThread(function()
    Wait(1103)
    DJList = TriggerServerCallback('core:admin:getAllDJSets')
end)

while p == nil do Wait(1) end
while DJList == nil or next(DJList) == nil do Wait(100) end

local MyDJ = ""
local Selected = {}
local open = false

local function CanAccessDJ(job, crew)
    if not job and not crew then
        return true
    end
    if job then
        for k,v in pairs(job) do
            if p:getJob() == v then
                return true
            end
        end
    end
    if crew then
        for k,v in pairs(crew) do
            if p:getCrew() == v then
                return true
            end
        end
    end
    return false
end

local function createDJSet(name, position, djset)
    zone.addZone("djset" .. name,
        position + vector3(0.0, 0.0, 1.0),
        "~INPUT_CONTEXT~ DJ",
        function()
            printDev("DJSet : " .. name, json.encode(djset))
            if CanAccessDJ(djset.mixer.jobs, djset.mixer.crews) or p:getPermission() > 2 then
                MyDJ = name
                OpenDJUI(name, position, djset.speaker.distance / 2)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous n'avez pas accès à ce DJ Set !",
                })
            end
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        1.5,
        true,
        "bulleMusique"
    )
end

RegisterNUICallback("AddNewMusic", function(data)
    local tablee = {}
    for k, v in pairs(GetActivePlayers()) do
        table.insert(tablee, GetPlayerServerId(v))
    end
    printDev("AddNewMusic", data.name, data.input, json.encode(data))
    TriggerServerEvent("core:dj:play", MyDJ, Selected[MyDJ].coords, Selected[MyDJ].dist, data.input, 0.2, true)
end)

RegisterNUICallback("addMusicToPlaylist", function(data)
    local tablee = {}
    for k, v in pairs(GetActivePlayers()) do
        table.insert(tablee, GetPlayerServerId(v))
    end
    printDev("addMusicToPlaylist", json.encode(data))
    --print("addMusicToPlaylist", data.name, data.input.url, json.encode(data))
    local urlf = ""
    if data and data.input and data.input.url then
        url = data.input.url
    end
    if data.url then
        url = data.url
    end
    TriggerServerEvent("core:dj:play", MyDJ, Selected[MyDJ].coords, Selected[MyDJ].dist, url, 0.2, false)
end)

RegisterNUICallback("djGetMyMusicList", function(data, cb)
    printDev("djGetMyMusicList", json.encode(data))
    local musics = TriggerServerCallback("core:getMySavedMusic", data.name)
    cb({
        data = musics
    })
end)

RegisterNUICallback("djGetMyPlayList", function(data, cb)
    local musics = TriggerServerCallback("core:getDjPlaylist", data.name)
    cb({
        data = musics
    })
end)

RegisterNUICallback("PlayDj", function(data)
    local tablee = {}
    for k, v in pairs(GetActivePlayers()) do
        table.insert(tablee, GetPlayerServerId(v))
    end
    printDev("PlayDj", data.name, data.input, json.encode(data))
    if type(data) == "string" then
        data = {}
        data.name = data
    end
    TriggerServerEvent("core:dj:play", data.name, Selected[MyDJ].coords, Selected[MyDJ].dist, data.input, 0.2, false)
end)

RegisterNUICallback("justplayFlozii", function(data)
    local tablee = {}
    for k, v in pairs(GetActivePlayers()) do
        table.insert(tablee, GetPlayerServerId(v))
    end
    printDev("justplayFlozii", data.name, data.input, json.encode(data))
    TriggerServerEvent("core:dj:play", data.name, Selected[MyDJ].coords, Selected[MyDJ].dist, data.input, 0.2, false)
end)

RegisterNUICallback("StopDj", function(data)
    printDev("StopDj", data)
    TriggerServerEvent("core:dj:stop", data, true)
end)

RegisterNUICallback("NextDj", function(data)
    printDev("NextDj", data)
    TriggerServerEvent("core:dj:stop", data)
end)

RegisterCommand("requestPlaylist", function()
    local playlist = TriggerServerCallback("core:getDjPlaylist", "Unicorn")

end)

RegisterCommand("getMySavedmusic", function(source, args)
    local url = args[1]
    local songname = args[2]
    -- Get My saved music :
    --local savedmusics = TriggerServerCallback("core:getMySavedMusic", "Unicorn")
    -- Save My music :
    --TriggerServerEvent("core:savemymusic", "Unicorn", url, songname)
end)

RegisterNUICallback("changeRange", function(data)
    printDev('changeRange', json.encode(data), data.range/100)
    TriggerServerEvent("core:dj:volume", data.name, data.range/100)
end)

RegisterNetEvent("core:dj:volume", function(name, volume)
    xSound:setVolume(name, volume)
end)

RegisterNetEvent("core:create:dj", function(name, dist, coords)
    --table.insert(DJList, {
    --    name = name,
    --    dist = dist,
    --    coords = coords,
    --    vol = 0.2
    --})
end)

RegisterNetEvent("core:dj:play", function(name, coords, distance, ytb, vol, songname)
    Selected[name] = {}
    Selected[name] = {
        name = name,
        url = ytb,
        title = songname,
        dist = distance,
        coords = coords,
        vol = vol
    }
    PlayDJSong(Selected[name])
end)

RegisterNetEvent("core:dj:stop", function(name)
    xSound:Destroy(name)
end)

function PlayDJSong(table)
    if not table.coords then return end
    if xSound:soundExists(table.name) then
        xSound:Destroy(table.name)
        Wait(700)
    end
    xSound:PlayUrlPos(table.name, table.url, table.vol, table.coords)
    xSound:Distance(table.name, tonumber(table.dist)*4)
    xSound:setVolume(table.name, table.vol)
    xSound:Position(table.name, table.coords)
    xSound:Resume(table.name)
    xSound:setOcclusion(table.name, table.coords)
end

RegisterNUICallback("focusOut", function()
    if open then
        open = false
        SetNuiFocus(false, false)
    end
end)

function OpenDJUI(name, pos, distance)
    Selected[name] = {
        name = name,
        coords = pos,
        dist = distance,
    }
    open = true
    local datas = TriggerServerCallback("core:dj:getDatas", name)
    printDev(json.encode(datas))
    SendNUIMessage({
        type = 'openWebview',
        name = 'Dj',
        data = {
            name = name,
            volume = datas.volume*100,
            musicPlay = datas.musicPlaying,
        }
    })
end

CreateThread(function()
    while not zone do Wait(1000) end
    for k,v in pairs(DJList) do
        local positionMixer = vector3(v.mixer.pos.x, v.mixer.pos.y, v.mixer.pos.z)
        createDJSet(k, positionMixer, v)
    end
end)

RegisterNetEvent('core:createDJSet')
AddEventHandler('core:createDJSet', function(name, pos, job, crew, distance)
    DJList[name] = {
        mixer = {
            pos = pos,
            distance = 5,
            jobs = job,
            crews = crew
        },
        speaker = {
            pos = pos,
            distance = distance,
        },
        defaultVolume = 0.5,
    }
    local positionMixer = vector3(DJList[name].mixer.pos.x, DJList[name].mixer.pos.y, DJList[name].mixer.pos.z)
    createDJSet(name, positionMixer, DJList[name])
end)

RegisterNetEvent('core:deleteDJSet')
AddEventHandler('core:deleteDJSet', function(name)
    DJList[name] = nil

    zone.removeZone("djset" .. name)
    Bulle.remove("djset" .. name)
end)
