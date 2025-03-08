function GetLicense(id)
    if id == nil then return "" end 
    if id == 0 then return "" end
    if id == -1 then return "" end
    if GetPlayerName(id) == nil then return "" end
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return v
        end
    end
    print("Couldn't find license for  : "..id)
    return "license:000000000000000000000000000000000000"
end

function GetSteam(id)
    if id == nil then return "" end 
    if id == 0 then return "" end
    if id == -1 then return "" end
    if GetPlayerName(id) == nil then return "" end
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            return v
        end
    end
    print("Couldn't find steam for  : "..id)
    return "steam:00000000000000000"
end

function GetDiscord(id, moreinfo)
    if id == nil then return "" end 
    if id == 0 then return "" end
    if id == -1 then return "" end
    if GetPlayerName(id) == nil then return "" end
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "discord") then
            if not moreinfo then
                return v
            else
                newdiscord = v:gsub("discord:", "")
                return v .. " ( <@" .. newdiscord .. "> )"
            end
        end
    end
    print("Couldn't find discord for  : "..id)
    return "discord:000000000000000000"
end

function deepcopy(t)
    if type(t) ~= 'table' then return t end

    local meta = getmetatable(t)
    local target = {}

    for k,v in pairs(t) do
        if type(v) == 'table' then
            target[k] = deepcopy(v)
        else
            target[k] = v
        end
    end

    setmetatable(target, meta)

    return target
end

function GetIDFiveM(id, moreinfo)
    if id == nil then return "" end 
    if id == 0 then return "" end
    if id == -1 then return "" end
    if GetPlayerName(id) == nil then return "" end
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "fivem") then
            if not moreinfo then
                return v
            else
                return v:gsub("fivem:", "")
            end
        end
    end
    --print("Couldn't find FiveM ID for  : "..id)
    return "fivem:0000InvalideTaCapte"
end


function PlayersIdentifierToString(source, withIp)
    local identifiers = GetPlayerIdentifiers(source)
    local cb = ""
    for _, v in pairs(identifiers) do
        if withIp then
            cb = cb..v.."\n"
        else
            if not string.find(v, "ip") then
                cb = cb..v.."\n"
            end
        end
    end
    return cb
end

function GetPlayerFromLicenseIfExist(license)
    local players = GetPlayers()
    for k,v in pairs(players) do
        local ids = GetPlayerIdentifiers(v)
        for _,i in pairs(ids) do
            if i == license then    
                return v
            end
        end
    end
    return false
end

function CorePrint(text)
    print("^3Core:^7 "..text)
end

function CoreError(...)
    print("^7<--------->")
    print("^1Error:^7 ")
    print(...)
    print("^7<--------->")
end

function CompareMetadatas(t1, t2)
    -- Compare each entry of table t1 with the same entry of table t2
    -- If entry is a table, recursively call this function
    -- If t1 entry is not the same as t2 entry, return false
    -- If tables are not exactly the same, return false

    if type(t1) ~= "table" or type(t2) ~= "table" then
        return false
    end

    for k,v in pairs(t1) do
        if type(v) == "table" then
            if not CompareMetadatas(v, t2[k]) then
                return false
            end
        else
            if v ~= t2[k] then
                return false
            end
        end
    end
    return true
end

function extractVideoId(url)
    local videoId = url:match("watch%?v=([a-zA-Z0-9_-]+)")
    if not videoId then
        videoId = url:match("/([a-zA-Z0-9_-]+)$")
    end
    return videoId
end

local apiKey = "AIzaSyAtrOhTvRlCp0s29px_K7YuZ_fQjCuLnr0"
function GetYoutubeNameFromLink(url)
    if not url then return end
    url = extractVideoId(url)
    if not url then return end
    Wait(50)
    local videoTitle = ""
    local apiurl = "https://www.googleapis.com/youtube/v3/videos?id=" .. url .. "&key=" .. apiKey .. "&part=snippet"
    PerformHttpRequest(apiurl, function(statusCode, data, headers)
        if statusCode == 200 then
            local responseData = json.decode(data)
            videoTitle = responseData.items[1].snippet.title
        else
            print("Erreur lors de la requête HTTP:", statusCode)
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
    local timer = 1
    while videoTitle == "" do 
        Wait(100)
        timer += 1
        if timer > 15 then 
            break
        end
    end
    return videoTitle
end

-- Events utils

RegisterNetEvent("DeleteEntity")
AddEventHandler("DeleteEntity", function(token, table)
    if CheckPlayerToken(source, token) then
        for k,v in pairs(table) do
            DeleteEntity(NetworkGetEntityFromNetworkId(v))
        end
    end
end)

RegisterNetEvent("core:getClothData")
AddEventHandler("core:getClothData", function(cloth)
    cloth = json.decode(cloth)
    SendDiscordLog("vetement", source, json.encode(cloth))
end)

exports('getDiscord', function(id)
    return GetDiscord(id)
end)