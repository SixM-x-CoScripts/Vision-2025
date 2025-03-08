------------------ change this -------------------

local admins = {
    'steam:11000014186fba0', -- mathu
    'steam:1100001038ce038', -- meg
    'steam:11000010801b5ea', -- palomba
    'steam:11000010dd3cf91', -- gamingo
    'steam:110000145eb6159', -- nico
}



--------------------------------------------------
local debugprint = false -- don't touch this unless you know what you're doing or you're being asked by Vespura to turn this on.
--------------------------------------------------







-------------------- DON'T CHANGE THIS --------------------
local AvailableWeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
}

local function GetDiscord(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "discord") then
            return v
        end
    end
    print("Couldn't find discord for  : "..id)
    return "discord:000000000000000000"
end

local CurrentWeather = "EXTRASUNNY"
local Time = {}
Time.h = 7
Time.m = 0
local freezeTime = false


local rate_limit = {}
RegisterServerEvent('requestSync')
AddEventHandler('requestSync', function()
    -- if source == nil or source == 0 then
    --     TriggerClientEvent('updateWeather', -1, CurrentWeather)
    --     TriggerClientEvent('updateTime', -1, Time.h, Time.m)
    -- else
    --     if rate_limit[source] == nil then
    --         TriggerClientEvent('updateWeather', -1, CurrentWeather)
    --         TriggerClientEvent('updateTime', -1, Time.h, Time.m)
    --     end
    -- end
end)

RegisterNetEvent("AdminMenu:setWeather")
AddEventHandler("AdminMenu:setWeather", function(weather)
    CurrentWeather = weather
    TriggerEvent('requestSync')
end)

RegisterCommand('weather', function(source, args, rawCommand)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("Invalid syntax, correct syntax is: /weather <weathertype> ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("Weather has been upated.")
                CurrentWeather = string.upper(args[1])
                TriggerEvent('requestSync')
            else
                print("Invalid weather type, valid weather types are: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ")
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax, use ^0/weather <weatherType> ^1instead!')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^3Weather has been upated, new weather: ' .. string.lower(args[1]))
                    exports.core:SendDiscordLog("wheather", source, string.sub(GetDiscord(source), 9, -1), exports.core:GetPlayerFullname(source), "wheather", string.upper(args[1]))
                    CurrentWeather = string.upper(args[1])
                    TriggerEvent('requestSync')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /weather denied.')
        end
    end
end, false)

local times = {
    ["morning"] = {h = 9, m = 0},
    ["noon"] = {h = 12, m = 0},
    ["evening"] = {h = 18, m = 0},
    ["night"] = {h = 23, m = 0},
}

RegisterNetEvent("AdminMenu:setTime")
AddEventHandler("AdminMenu:setTime", function(label)
    Time.h = times[label].h
    Time.m = times[label].m
    TriggerClientEvent('chatMessage', source, '', {255,255,255}, 'Le temps à été changé.')
    TriggerEvent('requestSync')
end)

-- RegisterCommand('morning', function(source)
--     if source == 0 then
--         print("Use the \"/time\" command instead!")
--         return
--     end
--     if isAllowedToChange(source) then
--         Time.h = 9
--         Time.m = 0
--         TriggerClientEvent('chatMessage', source, '', {255,255,255}, 'Time set to morning.')
--         TriggerEvent('requestSync')
--     end
-- end)
-- RegisterCommand('noon', function(source)
--     if source == 0 then
--         print("Use the \"/time\" command instead!")
--         return
--     end
--     if isAllowedToChange(source) then
--         Time.h = 12
--         Time.m = 0
--         TriggerClientEvent('chatMessage', source, '', {255,255,255}, 'Time set to noon.')
--         TriggerEvent('requestSync')
--     end
-- end)
-- RegisterCommand('evening', function(source)
--     if source == 0 then
--         print("Use the \"/time\" command instead!")
--         return
--     end
--     if isAllowedToChange(source) then
--         Time.h = 18
--         Time.m = 0
--         TriggerClientEvent('chatMessage', source, '', {255,255,255}, 'Time set to evening.')
--         TriggerEvent('requestSync')
--     end
-- end)
-- RegisterCommand('night', function(source)
--     if source == 0 then
--         print("Use the \"/time\" command instead!")
--         return
--     end
--     if isAllowedToChange(source) then
--         Time.h = 23
--         Time.m = 0
--         TriggerClientEvent('chatMessage', source, '', {255,255,255}, 'Time set to night.')
--         TriggerEvent('requestSync')
--     end
-- end)

RegisterCommand('time', function(source, args, rawCommand)
    print('time', source)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                Time.h = argh
            else
                Time.h = 0
            end
            if argm < 60 then
                Time.m = argm
            else
                Time.m = 0
            end
            -- Time.h = argh
            -- Time.m = argm
            print("Time has changed to " .. Time.h .. ":" .. Time.m .. ".")
            TriggerEvent('requestSync')
        else
            print("Invalid syntax, correct syntax is: time <hour> <minute> !")
        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                exports.core:SendDiscordLog("wheather", source, string.sub(GetDiscord(source), 9, -1), exports.core:GetPlayerFullname(source), "time" , argh..' '..argm)
                if argh < 24 then
                    Time.h = argh
                else
                    Time.h = 0
                end
                if argm < 60 then
                    Time.m = argm
                else
                    Time.m = 0
                end
                -- Time.h = argh
                -- Time.m = argm
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^2Time has been updated, new time is: ^0' .. Time.h .. ":" .. Time.m .. "^2!" )
                TriggerEvent('requestSync')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax. Use ^0/time <hour> <minute> ^1instead!')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /time denied.')
        end
    end
end)

RegisterCommand("freezetime", function(source)
    print("freez")
    if isAllowedToChange(source) then
        exports.core:SendDiscordLog("wheather", source, string.sub(GetDiscord(source), 9, -1), exports.core:GetPlayerFullname(source), "freeze time", not freezeTime)
        freezeTime = not freezeTime
        if source == 0 then
            print(freezeTime and "[^3Météo^7] Le temps a ete freeze" or "[^3Météo^7] Le temps n'est plus freeze")
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, freezeTime and "[^3Météo^7] Le temps a été freeze" or "[^3Météo^7] Le temps n'est plus freeze")
        end
        TriggerEvent('requestSync')
    end
end)

function isAllowedToChange(player)
    --local allowed = false
    --for i,id in ipairs(admins) do
    --    for x,pid in ipairs(GetPlayerIdentifiers(player)) do
    --        if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
    --        if string.lower(pid) == string.lower(id) then
    --            allowed = true
    --        end
    --    end
    --end
    --return allowed
    print('perm',exports["core"]:GetPlayerTarget(player).permission)
    if player == 0 or exports["core"]:GetPlayerTarget(player).permission >= 5 then
        return true
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        if not freezeTime then
            Time.m = Time.m + 1
            if Time.m > 59 then
                Time.m = 0
                Time.h = Time.h + 1
                if Time.h > 23 then
                    Time.h = 0
                end
            end

            GlobalState.minute = Time.m
            GlobalState.hour = Time.h
            --print("time", GlobalState.hour, GlobalState.minute)
        end
    end
end)


-- Idk where the weather loop is, so I'm just gonna put it here.
Citizen.CreateThread(function()
    while true do
        GlobalState.weather = CurrentWeather
        Wait(5000)
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(5000)
--         TriggerClientEvent('updateTime', -1, Time.h, Time.m)
--     end
-- end)
-- Citizen.CreateThread(function()
--     while true do
--         TriggerClientEvent('updateWeather', -1, CurrentWeather)
--         Citizen.Wait(300000)
--     end
-- end)