local token = nil
local tokenAcces = {
    ["core"] = 300,
}
AddEventHandler("core:RequestTokenAcces", function(ressource, cb)
    while token == nil do Wait(100) end
    local granted = false
    if tokenAcces[ressource] ~= nil then
        if tokenAcces[ressource] > 0 then
            granted = true
            tokenAcces[ressource] = tokenAcces[ressource] - 1
            cb(token)
        end
    end

    if not granted then
        TriggerServerEvent("core:WrongTokenRequest", ressource)
    end
end)

LastTimePlayer = 0

function PrioEvent()
    LastTimePlayer += 1
    Wait(150*LastTimePlayer)
    return true
end

function TriggerSecurEvent(name, ...) -- Utilsier cette event
    if PrioEvent() then
        local time, idPlayer, size, fname  = tostring(GetGameTimer()), tostring(GetPlayerServerId(PlayerId())), tostring(p:getSize()), tostring(p:getFirstname())
        local message = _TRGSE(fname..time..idPlayer..size)
        LastTimePlayer -= 1
        TriggerServerEvent(name, time, message, ...)
    end
end

-- function TriggerSecurGiveEvent(name, token, item, count, ...)
--     if PrioEvent() then
--         local time, idPlayer, size, item, count2, fname =  tostring(GetGameTimer()), tostring(GetPlayerServerId(PlayerId())), tostring(p:getSize()), tostring(item), tostring(count), tostring(p:getFirstname())
--         local message = _TRGSE(idPlayer..time..count2..size..item..fname)
--         LastTimePlayer -= 1
--         TriggerServerEvent(name, time, nil, message, item, count, ...)
--     end
-- end

TriggerSecurGiveEvent = function(eventName, token, ...)
    local securid = GlobalState.coreSecurID
    TriggerServerEvent(eventName, securid, ...)
end


Citizen.CreateThread(function()
    while RegisterClientCallback == nil do Wait(10) end
    RegisterClientCallback('core:SyncPlayer', function(IdEvent)
        local ValueReturn = false
        if NomDeTAbLeApasMontrerSVVP[IdEvent] ~= nil then
            if NomDeTAbLeApasMontrerSVVP[IdEvent] == true then
                NomDeTAbLeApasMontrerSVVP[IdEvent] = nil 
                ValueReturn = true
            end
        end
        return ValueReturn
    end)
end)

local function GeneratePlayerToken(source)
    local token = math.random(100001,9000009).."-"..math.random(100001,9000009).."-"..math.random(100001,9000009).."-"..math.random(100001,9000009)
    return token
end

local Connected = false
Citizen.CreateThread(function()
    local t = GeneratePlayerToken()
    TriggerServerEvent("core:RegisterPlayerToken", t)
    token = t
    while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end 
    while not GetEntityModel(PlayerPedId()) do Wait(1) end 
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do Wait(1) end 
    Wait(15000)
    TriggerServerEvent("core:secu:ImConnected")
    TriggerServerEvent("core:secu:ImConnectedFirst")
    Connected = true
end)

CreateThread(function()
    while not Connected do Wait(1) end
    while true do 
        Wait(15000)
        TriggerServerEvent("core:secu:ImConnected")
    end
end)

local Detect = {
    found = false,
    weapon = nil,
    flag = 0,
    allflags = 0
}

CreateThread(function()
    while not p do Wait(1) end
    if p:getPermission() <= 2 then
        while true do
            Detect.found = false
            if not IsPedInAnyVehicle(PlayerPedId()) then
                if IsPedArmed(PlayerPedId(), 1) or IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 2) then
                    if GetSelectedPedWeapon(PlayerPedId()) ~= 683870287 and GetSelectedPedWeapon(PlayerPedId()) ~= -822264317 and GetSelectedPedWeapon(PlayerPedId()) ~= 740922169 and GetSelectedPedWeapon(PlayerPedId()) ~= -1993457855 then
                        for k, v in pairs(p:getInventaire()) do
                            if v.name and string.find(v.name, "weapon_") then 
                                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(v.name) then 
                                    Detect.found = true
                                end
                            end
                        end
                        if not Detect.found then 
                            if weaponHashes[GetSelectedPedWeapon(PlayerPedId())] then
                                Detect.flag += 1
                                Detect.allflags += 1
                                Detect.weapon = weaponHashes[GetSelectedPedWeapon(PlayerPedId())]
                            else
                                Detect.allflags += 1
                                Detect.flag += 1
                                Detect.weapon = GetSelectedPedWeapon(PlayerPedId()).." (Hash)"
                            end
                            if Detect.allflags >= 7 and not IsPedInAnyVehicle(PlayerPedId()) then
                                TriggerServerEvent("zt:detectionban", "Total de 8 détections de give d'armes sans quelles soient dans l'inventaire.", nil, nil, "Gives")
                            end
                            if Detect.flag >= 3 and not IsPedInAnyVehicle(PlayerPedId()) then
                                TriggerServerEvent("zt:detectionban", "3 armes give sans quelles soient dans l'inventaire en moins de une minute.", nil, nil, "Gives")
                            else
                                if not string.find(Detect.weapon, "Hash") then
                                    local exists = items[string.lower(Detect.weapon)] and "Yes" or "No" 
                                    local ammoCount = GetAmmoInPedWeapon(PlayerPedId(), Detect.weapon) or "JSP"
                                    TriggerServerEvent("zt:detectkick", "Suppression de l'arme en main du joueur car il ne l'a pas en inventaire : " ..Detect.weapon .. ", Total ammo : ".. ammoCount ..  ". Item exists ? : " .. exists, "Gives")
                                    --if string.find(string.upper(Detect.weapon), "MK2") then 
                                    --    TriggerServerEvent("zt:detectionban", "Armes blacklist give sans quelle soit dans l'inventaire : " .. Detect.weapon, nil, nil, "Gives")
                                    --end
                                else
                                    TriggerServerEvent("zt:detectkick", "Suppression de l'arme en main du joueur car il ne l'a pas en inventaire : " ..Detect.weapon, "Gives")
                                end
                                Wait(150)
                                RemoveAllPedWeapons(PlayerPedId())
                                SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
                            end
                            if GetItsMyFirstSpawn() and not IsPedInAnyVehicle(PlayerPedId()) then 
                                local ammoCount = GetAmmoInPedWeapon(PlayerPedId(), Detect.weapon) or "JSP"
                                TriggerServerEvent("zt:detectionban", "Armes give sans quelle soit dans l'inventaire : " .. Detect.weapon .. ", Total ammo : ".. ammoCount, nil, nil, "Gives")
                            end
                        end
                    end
                end
            end
            SetEntityProofs(PlayerPedId(), false, true, false, false, false, false, false, false)		
            Wait(2000)
        end
    end
end)

CreateThread(function()
    while Detect.flag == 0 do Wait(2000) end
    while true do 
        Wait(80000)
        Detect.flag = 0
    end
end)

RegisterNetEvent("core:takescreensw", function(id)
    exports["screenshot-basic"]:requestScreenshotUpload("https://discord.com/api/webhooks/1199421873520382033/Tddog3H4tjSE4vOiZXhEz2NtcWvCQ9k7dJjUa4R5RV1-Z-_0BpTztD0iiYIvAQ_NphA6", "files[]",function(data)
        local resp = json.decode(data)
        TriggerServerEvent("core:getscreenshotsw", resp.attachments[1].url, id)
    end)
end)

local LastTime = 0

function PrioEventSW()
    LastTime += 1
    Wait(150*LastTime)
    return true
end

function TriggerSWEvent(name, ...)
    if PrioEventSW() then
        local time, idPlayer  = tostring(GetGameTimer()), tostring(GetPlayerServerId(PlayerId()))
        local message = _TRGSE(time..idPlayer)
        LastTime -= 1
        TriggerServerEvent(name, time, message, ...)
    end
end

exports('TriggerSWEvent', TriggerSWEvent)