

DrugsZone = {}

---name zone
---RenameZone
---Table All Count gang
function LoadAllZoneDrugs()
    MySQL.Async.fetchAll("SELECT * FROM zonedrugs", {}, function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                DrugsZone[v.name] = {}
                DrugsZone[v.name].id = v.name
                DrugsZone[v.name].label = v.label
                DrugsZone[v.name].data = json.decode(v.data)
                DrugsZone[v.name].needSave = false
            end
        end
    end)

    return DrugsZone
end
LoadAllZoneDrugs()

RegisterServerCallback("core:GetZoneDataDrugs",function (source, data)
    return DrugsZone[data]
end)

RegisterServerCallback("core:ChangeNameZone",function (source, id, newName)
    if DrugsZone[tostring(id)] ~= nil then
        DrugsZone[tostring(id)].label = newName
        DrugsZone[tostring(id)].needSave = true
        return true
    end
    return false
end)


local function SaveDataDrugs(id)
    MySQL.Async.execute("UPDATE zonedrugs SET data = @1, label = @2 WHERE name = @name",
    {
        ['@1'] = json.encode(DrugsZone[tostring(id)].data),
        ['@2'] = DrugsZone[tostring(id)].label,
        ['@name'] = id,
    },
    function(affectedRows)
        CorePrint("Zone " .. id .. " saved.")
        DrugsZone[tostring(id)].needSave = false
    end)

end
RegisterNetEvent("core:UpdateZoneDrugs")
AddEventHandler("core:UpdateZoneDrugs", function(token, id, name, data)
    local source = source
    if CheckPlayerToken(source, token) then
        if DrugsZone[tostring(id)] ~= nil then
            DrugsZone[tostring(id)].data = data
            DrugsZone[tostring(id)].needSave = true
        end
    end
end)

RegisterNetEvent("core:CreateZoneData")
AddEventHandler("core:CreateZoneData", function(token, id, name, data)
    if CheckPlayerToken(source, token) then
        if DrugsZone[id] == nil then
            MySQL.Async.insert("INSERT INTO zonedrugs (name, label, data) VALUES (@1, @2, @3)", {
                ["@1"] = id,
                ["@2"] = name,
                ["@3"] = json.encode(data),
            }, function(affectedRows)
                if affectedRows ~= 0 then
                    DrugsZone[tostring(id)] = {}
                    DrugsZone[tostring(id)].id = id
                    DrugsZone[tostring(id)].label = name
                    DrugsZone[tostring(id)].data = data
                    DrugsZone[tostring(id)].needSave = false
                    -- TriggerClientEvent('core:ShowNotification', source, "~g~La zone " ..name .. " a été créée")
                else
                    -- TriggerClientEvent('core:ShowNotification', source, "~r~Erreur lors de la création de la propriete")
                end
            end)
        end
    end
end)

RegisterNetEvent("drugs:notifDrugs")
AddEventHandler("drugs:notifDrugs", function(leader, lieux)
    local sources = GetPlayers();
    local src, player;
    for i = 1, #sources do
        src = tonumber(sources[i]);
        player = GetPlayer(src);
        if (type(player) == "table") then
            if (player:getCrew() == leader) then
                TriggerClientEvent('drugs:notifDrugs', player.source, key, lieux);
            end
        end
    end
end)


CreateThread(function()
    while true do
        for k, v in pairs(DrugsZone) do
            if v.needSave then
                SaveDataDrugs(k)
            end
        end
        Wait(1*6000)
    end
end)
