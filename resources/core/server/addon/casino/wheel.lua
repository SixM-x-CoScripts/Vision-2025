local timeOut = false
isRoll = false
amount = 50000
SpawnPunt = {x = -59.18, y = -1109.71, z = 25.45, h = 68.5}

local NumberCharset = {}

RegisterServerEvent('sunwise:casino:wheelgetLucky')
AddEventHandler('sunwise:casino:wheelgetLucky', function(price)
    local _source = source
    if price then
        if CasinoConfig.GetChipsCount(_source) >= price then
            CasinoConfig.RemoveChips(_source, price)
        else
            return
        end
    end
    if not isRoll then
        isRoll = true
        local _randomPrice = math.random(1, 100)
        if _randomPrice == 1 then
            -- Win car
            local _subRan = math.random(1,1000)
            if _subRan <= 1 then
                _prizeIndex = 19
            else
                _prizeIndex = 3
            end
        elseif _randomPrice > 1 and _randomPrice <= 6 then
            -- Win skin AK Gold
            _prizeIndex = 12
            local _subRan = math.random(1,20)
            if _subRan <= 2 then
                _prizeIndex = 12
            else
                _prizeIndex = 7
            end
        elseif _randomPrice > 6 and _randomPrice <= 15 then
            -- Black money
            -- 4, 8, 11, 16
            local _sRan = math.random(1, 4)
            if _sRan == 1 then
                _prizeIndex = 4
            elseif _sRan == 2 then
                _prizeIndex = 8
            elseif _sRan == 3 then
                _prizeIndex = 11
            else
                _prizeIndex = 16
            end
        elseif _randomPrice > 15 and _randomPrice <= 25 then
            -- Win 300,000$
            -- _prizeIndex = 5
            local _subRan = math.random(1,20)
            if _subRan <= 2 then
                _prizeIndex = 5
            else
                _prizeIndex = 20
            end
        elseif _randomPrice > 25 and _randomPrice <= 40 then
            -- 1, 9, 13, 17
            local _sRan = math.random(1, 4)
            if _sRan == 1 then
                _prizeIndex = 1
            elseif _sRan == 2 then
                _prizeIndex = 9
            elseif _sRan == 3 then
                _prizeIndex = 13
            else
                _prizeIndex = 17
            end
        elseif _randomPrice > 40 and _randomPrice <= 60 then
            local _itemList = {}
            _itemList[1] = 2
            _itemList[2] = 6
            _itemList[3] = 10
            _itemList[4] = 14
            _itemList[5] = 18
            _prizeIndex = _itemList[math.random(1, 5)]
        elseif _randomPrice > 60 and _randomPrice <= 100 then
            local _itemList = {}
            _itemList[1] = 3
            _itemList[2] = 7
            _itemList[3] = 15
            _itemList[4] = 20
            _prizeIndex = _itemList[math.random(1, 4)]
        end
        TriggerClientEvent("sunwise:casino:wheeldoRoll", -1, _prizeIndex)
        Wait(5000)
        isRoll = false
        print("_prizeIndex", _prizeIndex)
        if _prizeIndex == 9 or _prizeIndex == 13 or _prizeIndex == 14 or _prizeIndex == 18 or _prizeIndex == 10 or _prizeIndex == 17 or _prizeIndex == 20 then
            CasinoConfig.WinWheel(_source, "DRINKS")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
                GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné a boire")
        elseif _prizeIndex == 1 or _prizeIndex == 2 then
            CasinoConfig.WinWheel(_source, "CHIPS 2500")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
            GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné 2500 JETONS")
        elseif _prizeIndex == 11 or _prizeIndex == 12 then 
            CasinoConfig.WinWheel(_source, "CHIPS 20000")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
            GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné 20000 JETONS")
        elseif _prizeIndex == 3 or _prizeIndex == 4 then 
            CasinoConfig.WinWheel(_source, "MONEY 20000")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
            GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné 20000 MONEY")
        elseif _prizeIndex == 7 or _prizeIndex == 8 then 
            CasinoConfig.WinWheel(_source, "MONEY 30000")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
            GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné 30000 MONEY")
        elseif _prizeIndex == 15 or _prizeIndex == 16 then
            CasinoConfig.WinWheel(_source, "MONEY 40000")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
            GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné 40000 MONEY")
        elseif _prizeIndex == 5 or _prizeIndex == 6 then
            CasinoConfig.WinWheel(_source, "NOTHING")
        elseif _prizeIndex == 19 then
            TriggerClientEvent("sunwise:casino:wheelwinCar", _source)
            CasinoConfig.WinWheel(_source, "CAR LOGO")
            SendDiscordLog("casino", _source, string.sub(GetDiscord(_source), 9, -1),
            GetPlayer(_source):getLastname() .. " " .. GetPlayer(_source):getFirstname(), "La personne à tournée la roue et à gagné **UNE VOITURE (NEON)**")
        end
        TriggerClientEvent("sunwise:casino:wheelrollFinished", -1)
    end
end)

function GetPossibleLicense(id)
    local identifiers = GetPlayerIdentifiers(id)
    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return v
        end
    end
    for _, v in pairs(identifiers) do
        if string.find(v, "discord") then
            return v
        end
    end
    return "license:000000000000000000000000000000000000"
end

local PlayersWheel = {}
SWRegisterServCallback('sunwisecasino:getTimeWheel', function(source, cb, premium)
    if not PlayersWheel[GetPossibleLicense(source)] then 
        PlayersWheel[GetPossibleLicense(source)] = 1
        cb(true)
    else
        --if CasinoConfig.IsPlayerVIP(source) then
        if premium > 0 then
            if PlayersWheel[GetPossibleLicense(source)] and PlayersWheel[GetPossibleLicense(source)] < 2 then
                PlayersWheel[GetPossibleLicense(source)] += 1
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end
end)