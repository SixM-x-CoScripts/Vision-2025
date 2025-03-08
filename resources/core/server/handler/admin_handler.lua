RegisterNetEvent('core:FreezePlayer')
AddEventHandler("core:FreezePlayer", function(token, id, staut)
    local src = source
    local id = id
    if GetPlayer(id):getPermission() >= 6 and not staut == false then
        TriggerClientEvent("__atoshi::createNotification", id, {
            type = 'ROUGE',
            content = "Coucou loulou, "..GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname() .. " a essayé de te freeze, mais il a échoué !"
        })
        return
    end
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 3 then
            TriggerClientEvent("core:FreezePlayer", tonumber(id), staut)
        else
            SunWiseKick(src, "Tried exec core:FreezePlayer")
        end
    else
        --AcTodo: Ac detection
    end
end)

RegisterNetEvent("core:ReturnPlayer", function(token, id, coords)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            TriggerClientEvent("core:ReturnPlayer", tonumber(id), coords)
        end
    end
end)

RegisterNetEvent('core:GotoBring')
AddEventHandler("core:GotoBring", function(token, pId, id)
    local src = source
    if pId == nil then
        pId = src
    else
        id = src
    end
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 2 then
            TriggerClientEvent("core:GotoBring", tonumber(pId), GetEntityCoords(GetPlayerPed(id)))
        else
            SunWiseKick(src, "Tried exec core:GotoBring")
        end
    else
        --AcTodo: Ac detection
    end
end)

RegisterNetEvent("core:ctxm:SetEntityCoords")
AddEventHandler("core:ctxm:SetEntityCoords", function(token, id, coords)
    local src = source
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 2 then
            TriggerClientEvent("core:ctxm:SetEntityCoords", tonumber(id), coords)
        else
            SunWiseKick(src, "Tried exec core:ctxm:SetEntityCoords")
        end
    else
        --AcTodo: Ac detection
    end
end)

RegisterNetEvent('core:KickPlayer')
AddEventHandler("core:KickPlayer", function(token, id, reason)
    local src = source
    local id = id
    if GetPlayer(id) == nil then
        if callback then callback(false) end
        return
    -- elseif GetPlayer(id):getPermission() >= 6 then
    --     DropPlayer(tonumber(src), "Kick: ".."ntm")
    --     TriggerClientEvent("__atoshi::createNotification", id, {
    --         type = 'ROUGE',
    --         content = "Coucou loulou, "..GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname() .. " a essayé de te kick, mais il a échoué !"
    --     })
    --     return
    end
    if CheckPlayerToken(src, token) then
        if GetPlayer(src):getPermission() >= 2 then
            KickPlayer(src, id, reason)
        else
            SunWiseKick(src, "Tried exec core:KickPlayer")
        end
    else
        --AcTodo: Ac detection
    end
end)

function KickPlayer(src, id, reason, callback)
    if not src == 0 then
        SendDiscordLog("kick", src, string.sub(GetDiscord(id), 9, -1), GetPlayer(id):getLastname() .. " " .. GetPlayer(id):getFirstname(), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), reason)
    end
    DropPlayer(tonumber(id), "Kick: "..reason)
    if callback then callback(true) end
end

RegisterServerEvent("core:StaffSpectate")
AddEventHandler("core:StaffSpectate", function(token, id)
    local source = source
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() >= 2 then
            TriggerClientEvent("core:StaffSpectate", source, GetEntityCoords(GetPlayerPed(tonumber(id))), tonumber(id))
        else
            SunWiseKick(source, "Tried exec core:StaffSpectate")
        end
    else
        --AcTodo: Ac detection et nibards
    end
end)
