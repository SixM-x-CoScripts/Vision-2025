local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

--[[ RegisterCommand("weazel", function(source, args)
    local message = table.concat(args, " ")

    exports['aHUD']:dislpayWeazelAnnouncement(message)
end) ]]

function getMapPosition()
    local minimap = {}
    local resX, resY = GetActiveScreenResolution()
    local aspectRatio = GetAspectRatio()
    local scaleX = 1 / resX
    local scaleY = 1 / resY
    local minimapRawX, minimapRawY
    SetScriptGfxAlign(string.byte('L'), string.byte('B'))
    if IsBigmapActive() then
        minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
        minimap.width = scaleX * (resX / (2.52 * aspectRatio))
        minimap.height = scaleY * (resY / (2.3374))
    else
        minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
        minimap.width = scaleX * (resX / (4 * aspectRatio))
        minimap.height = scaleY * (resY / (5.674))
    end
    ResetScriptGfxAlign()
    minimap.leftX = minimapRawX
    minimap.rightX = minimapRawX + minimap.width
    minimap.topY = minimapRawY
    minimap.bottomY = minimapRawY + minimap.height
    minimap.X = minimapRawX + (minimap.width / 2)
    minimap.Y = minimapRawY + (minimap.height / 2)
    return minimap
end

RegisterCommand("dv", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        local veh, dst = GetClosestVehicle()
        if dst <= 6.0 then
            --TriggerServerEvent("core:SetVehicleIn", all_trim(GetVehicleNumberPlateText(veh)))
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            TriggerServerEvent("DeleteEntity", token, { VehToNet(veh) })
            TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(veh)),
                VehToNet(veh))
            -- DeleteEntity(veh)
        else
            -- ShowNotification("Aucun véhicule proche")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun véhicule proche"
            })
        end
    end
end, false)
addChatSuggestion(1, "dv", "Supprimer le véhicule le plus proche", {})

RegisterCommand("dvr", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local radius = tonumber(args[1])

        local vehicles = {}

        for veh in EnumerateVehicles() do
            local vehCoords = GetEntityCoords(veh)
            local distance = #(playerCoords - vehCoords)
            if distance <= radius then
                table.insert(vehicles, veh)
            end
        end

        for _, veh in ipairs(vehicles) do
            --TriggerServerEvent("core:SetVehicleIn", all_trim(GetVehicleNumberPlateText(veh)))
            TriggerEvent('persistent-vehicles/forget-vehicle', veh)
            TriggerServerEvent("DeleteEntity", token, { VehToNet(veh) })
            TriggerServerEvent("police:SetVehicleInFourriere", token, all_trim(GetVehicleNumberPlateText(veh)),
                VehToNet(veh))
        end

        if #vehicles == 0 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Aucun véhicule proche dans la zone"
            })
        end
    end
end, false)
addChatSuggestion(2, "dvr", "Supprimer les véhicules dans un rayon donné", {
    { name = "rayon", help = "Rayon de suppression" }
})

checkIfVehiculeIsBlacklisted = function(item) 
    local vehiculesBlacklist = {
        ["avenger"] = 4,
        ["avenger2"] = 4,
        ["besra"] = 4,
        ["blimp"] = 4,
        ["blimp2"] = 4,
        ["blimp3"] = 4,
        ["bombushka"] = 4,
        ["cargoplane"] = 4,
        ["cargoplane2"] = 4,
        ["hydra"] = 4,
        ["jet"] = 4,
        ["lazer"] = 4,
        ["titan"] = 4,
        ["volatol"] = 4,
        ["alkonost"] = 4,
        ["dinghy5"] = 4,
        ["kosatka"] = 4,
        ["cerberus"] = 4,
        ["cerberus2"] = 4,
        ["cerberus3"] = 4,
        ["phantom2"] = 4,
        ["akula"] = 4,
        ["annihilator"] = 4,
        ["buzzard"] = 4,
        ["hunter"] = 4,
        ["savage"] = 4,
        ["annihilator2"] = 4,
        ["apc"] = 4,
        ["barrage"] = 4,
        ["chernobog"] = 4,
        ["halftrack"] = 4,
        ["khanjali"] = 4,
        ["minitank"] = 4,
        ["rhino"] = 4,
        ["thruster"] = 4,
        ["oppressor"] = 4,
        ["oppressor2"] = 4,
        ["trailersmall2"] = 4,
        ["shotaro"] = 4,
        ["tampa3"] = 4,
        ["blazer5"] = 4,
        ["dune2"] = 4,
        ["dune4"] = 4,
        ["dune5"] = 4,
        ["insurgent"] = 4,
        ["insurgent3"] = 4,
        ["nightshark"] = 4,
        ["trophytruck2"] = 4,
        ["technical2"] = 4,
        ["technical3"] = 4,
        ["limo2"] = 4,
        ["kuruma2"] = 4,
        ["zr380"] = 4,
        ["zr3802"] = 4,
        ["zr3803"] = 4,  
        ["dick"] = 68      
    }

    local itemConfig = vehiculesBlacklist[item]
    if itemConfig and p:getPermission() <= itemConfig then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~s Non, non, non, seulement le staff peut faire spawn ce véhicule !"
        })
        return true
    else 
        return false
    end
end

local spam = false
RegisterCommand("car", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        local vehName = args[1]
        if checkIfVehiculeIsBlacklisted(vehName) then return end
        if vehName ~= nil then
            if spam then 
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~s Attend un peu !"
                })
                return
            end
            spam = true
            TriggerServerEvent("core:staffActionLog", token, "/car", vehName)
            SpawnCar(vehName)
            SetTimeout(2000,function()
                spam = false
            end)
        end
    end
end, false)
addChatSuggestion(1, "car", "Faire spawn un véhicule", {
    { name = "nom", help = "Nom du véhicule" }
})


-- RegisterCommand("setcarcolor1", function(source, args)
--     if p:getPermission() >= 3 then
--         local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--         local paintType, color, pearlescentColor = GetVehicleModColor_2(vehicle)
--         print(paintType, color, pearlescentColor)
--         SetVehicleModKit(vehicle, 0)
--         SetVehicleColours(vehicle, tonumber(args[1]), color)
--     end
-- end)

-- RegisterCommand("setcarcolor2", function(source, args)
--     if p:getPermission() >= 3 then
--         local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--         local paintType, color, pearlescentColor = GetVehicleModColor_1(vehicle)
--         print(paintType, color, pearlescentColor)
--         SetVehicleModKit(vehicle, 0)
--         SetVehicleColours(vehicle, color, tonumber(args[1]))
--     end
-- end)

RegisterCommand("setcarcolor", function(source, args)
    if p:getPermission() >= 3 then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehicleModKit(veh, 0)
        SetVehicleColours(veh, tonumber(args[1]), tonumber(args[1]))
        local props = vehicle.getProps(veh)
        TriggerServerEvent("core:SetPropsVeh", token, props.plate, props)
    end
end)

RegisterCommand("ban", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local id = tonumber(args[1])
        local reason = args[2]
        local time = args[3]
        local item = args[4]
        if not id then return end 
        if id == -1 then return end
        if reason ~= nil and reason ~= "" and time ~= nil and time ~= "" then
            -- TriggerServerEvent("core:staffSuivi", token, "ban", tonumber(id), reason, tonumber(time), item)
            TriggerServerEvent("core:staffBanAction", token, "/ban",
                id .. "** - Raison :** " .. reason .. "** - Temps : **" .. time)
            TriggerServerEvent("core:ban:banplayer", token, tonumber(id), reason, tonumber(time),
                GetPlayerServerId(PlayerId()), item)
        end
    end
end, false)
addChatSuggestion(2, "ban", "Bannir un joueur", {
    { name = "ID", help = "ID du joueur" },
    { name = "Raison", help = "Raison du ban" },
    { name = "Temps", help = "Durée du ban" },
    { name = "Unité", help = "Unité de temps | heures, jours, perm" }
})

RegisterCommand("unban", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local target = args[1]
        if target ~= nil then
            TriggerServerEvent("core:staffActionLog", token, "/unban", target)
            TriggerServerEvent("core:ban:unbanplayer", token, args[1])
        end
    end
end, false)
addChatSuggestion(2, "unban", "Débannir un joueur", {
    { name = "ID", help = "ID du ban" }
})

RegisterCommand("revive", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        if args[1] ~= nil then
            local player = tonumber(args[1])
            TriggerServerEvent("core:staffActionLog", token, "/revive", player)
            TriggerServerEvent("core:RevivePlayer", token, player, true)
            TriggerServerEvent("core:createvNotif", token, tonumber(player), 'VERT', "Vous avez été réanimé par un membre du staff.")
        else
            local player = GetPlayerServerId(PlayerId())
            TriggerServerEvent("core:staffActionLog", token, "/revive", "Soi-même")
            TriggerServerEvent("core:RevivePlayer", token, player, true)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez été réanimé"
            })

            -- Unragdoll player in case he was ragdolled
            SetPedToRagdoll(p:ped(), false, false, false)
        end
    end
end, false)
addChatSuggestion(1, "revive", "Réanimer un joueur", {
    { name = "ID", help = "ID du joueur" }
})

RegisterCommand("repair", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        if args[1] then
            TriggerServerEvent("core:repair", args[1])
        end
        TriggerServerEvent("core:staffActionLog", token, "/repair", "Véhicule")
        SetVehicleFixed(p:currentVeh())
        SetVehicleBodyHealth(p:currentVeh(), 1000.0)
        SetVehicleEngineHealth(p:currentVeh(), 1000.0)
        SetVehicleDirtLevel(p:currentVeh(), 0.0)
    end
end, false)
addChatSuggestion(1, "repair", "Réparer le véhicule actuel", {
    { name = "ID", help = "ID du joueur" }
})

RegisterNetEvent("core:repair", function()
    SetVehicleFixed(p:currentVeh())
    SetVehicleBodyHealth(p:currentVeh(), 1000.0)
    SetVehicleEngineHealth(p:currentVeh(), 1000.0)
    SetVehicleDirtLevel(p:currentVeh(), 0.0)
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Votre véhicle a été réparé par un staff"
    })
end)

RegisterCommand('tp', function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            args[1] = args[1]:gsub(",", "")
            args[2] = args[2]:gsub(",", "")
            args[3] = args[3]:gsub(",", "")

            local pPed = PlayerPedId()
            TriggerServerEvent("core:staffActionLog", token, "/tp", args[1] .. " " .. args[2] .. " " .. args[3])
            TeleportPlayer(vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Mauvaise Coords"
            })
        end
    end
end, false)
addChatSuggestion(1, "tp", "Téléporter un joueur", {
    { name = "X", help = "Coordonnée X" },
    { name = "Y", help = "Coordonnée Y" },
    { name = "Z", help = "Coordonnée Z" }
})

RegisterCommand('tpm', function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        GotoMarker()
    end
end, false)
addChatSuggestion(1, "tpm", "Se téléporter au marqueur", {})

RegisterCommand('upgrade', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        TriggerServerEvent("core:staffActionLog", token, "/upgrade", "Véhicule")
        local pVeh = p:currentVeh()
        SetVehicleModKit(pVeh, 0)
        for i = 0, 49 do
            if i ~= 11 and i ~= 12 and i ~= 13 and i ~= 14 and i ~= 15 and i ~= 18 and i ~= 22 then
                local max = GetNumVehicleMods(pVeh, i) - 1
                if max > 0 then
                    SetVehicleMod(pVeh, i, math.random(0, max), true)
                end
            end
        end
        for i = 11, 15 do
            local max = GetNumVehicleMods(pVeh, i) - 1
            SetVehicleMod(pVeh, i, max, true)
        end
        -- SetVehicleMod(pVeh, 11, GetNumVehicleMods(pVeh, 11), true)
        -- SetVehicleMod(pVeh, 12, GetNumVehicleMods(pVeh, 12), true)
        -- SetVehicleMod(pVeh, 13, GetNumVehicleMods(pVeh, 13), true)
        -- SetVehicleMod(pVeh, 14, GetNumVehicleMods(pVeh, 14), true)
        -- SetVehicleMod(pVeh, 15, GetNumVehicleMods(pVeh, 15), true)
        ToggleVehicleMod(pVeh, 18, true)
        ToggleVehicleMod(pVeh, 22, true)
        local props = vehicle.getProps(pVeh)
        TriggerServerEvent("core:SetPropsVeh", token, props.plate, props)
    end
end, false)
addChatSuggestion(2, "upgrade", "Améliorer le véhicule actuel", {})

RegisterCommand('specupgrade', function(source, args, rawCommand)
    if p:getPermission() >= 5 then
        TriggerServerEvent("core:staffActionLog", token, "/specupgrade", "Véhicule")
        local pVeh = p:currentVeh()
        SetVehicleModKit(pVeh, 0)
		
        SetVehicleMod(pVeh, 11, GetNumVehicleMods(pVeh, 11), true)
        SetVehicleMod(pVeh, 12, GetNumVehicleMods(pVeh, 12), true)
        SetVehicleMod(pVeh, 13, GetNumVehicleMods(pVeh, 13), true)
        SetVehicleMod(pVeh, 18, GetNumVehicleMods(pVeh, 18), true)
        ToggleVehicleMod(pVeh, 18, true)

        local props = vehicle.getProps(pVeh)
        TriggerServerEvent("core:SetPropsVeh", token, props.plate, props)
    end
end, false)
addChatSuggestion(4, "specupgrade", "Améliorer les performances du véhicule actuel", {})

RegisterCommand('testprop', function(source, args, rawCommand)
    if p:getPermission() >= 4 then
        StartPropTestMenu()
    end
end, false)

RegisterCommand('setjob', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local player = args[1]
        local job = args[2]
        local grade = args[3]
        if grade == nil or grade == "" then
            -- ShowNotification("~r~Commande incomplète (setjob ID job grade)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Commande incomplète (setjob ID job grade)"
            })

            return
        end
        TriggerServerEvent("core:staffActionLog", token, "/setjob",
            player .. " - Job : " .. job .. " - Grade : " .. grade)
        TriggerEvent("jobs:unloadcurrent")
        TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(player), job, tonumber(grade))
    end
end, false)
addChatSuggestion(2, "setjob", "Changer le job d'un joueur", {
    { name = "ID", help = "ID du joueur" },
    { name = "Job", help = "Nom du job" },
    { name = "Grade", help = "Grade du joueur" }
})

RegisterCommand('setcrew', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local player = args[1]
        local crew = args[2]
        local rang = args[3]
        if rang == nil or rang == "" then
            -- ShowNotification("~r~Commande incomplète (setcrew ID job rang)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Commande incomplète (setcrew ID crew rang)"
            })

            return
        end
        TriggerServerEvent("core:staffActionLog", token, "/setcrew",
            player .. " - Crew : " .. crew .. " - Rang : " .. rang)
        -- print("token, tonumber(player), crew, rang", token, tonumber(player), crew, rang)
        TriggerSecurEvent("core:setCrew", token, tonumber(player), crew, rang)
    end
end, false)
addChatSuggestion(2, "setcrew", "Changer le crew d'un joueur", {
    { name = "ID", help = "ID du joueur" },
    { name = "Crew", help = "Nom du crew" },
    { name = "Rang", help = "Rang du joueur" }
})

RegisterCommand("addItem", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local player = args[1]
        local item = args[2]
        local amount = args[3]
        if amount == nil or amount == "" then
            -- ShowNotification("~r~Commande incomplète (addItem ID item amount)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Commande incomplète (addItem ID item amount)"
            })

            return
        end
        TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), item, tonumber(amount), {})
    end
end)

function firstToUpper(str) return (str:gsub("^%l", string.upper)) end

function FindIDintable(table, id)
    for k, v in pairs(table) do
        if v == id then
            return true
        end
        return false
    end
end

RegisterCommand("addPermaItem", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local player = args[1]
        local item = args[2]
        local itemid = tonumber(args[3])
        local itemVariation = args[4]
        local itemBras = args[5]
        local soushaut = args[6]
        local soushaut2 = args[7]
        if itemid == nil or itemid == "" or item == nil or item == "" then
            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Commande incomplète (addItem ID item itemID itemVariation)"
            })

            return
        end
        item = string.lower(item)
        if item == "tshirt" then
            if FindIDintable(MaillotsPremium, itemid) or FindIDintable(MaillotsCustom, itemid) then
                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), item, 1, {
                    renamed = "Haut N°" .. tonumber(itemid),
                    drawableTorsoId = tonumber(itemid),
                    variationTorsoId = tonumber(itemVariation) or 0,
                    drawableArmsId = 5,
                    variationArmsId = 0,
                    drawableTshirtId = soushaut and tonumber(soushaut) or 15,
                    variationTshirtId = soushaut2 and tonumber(soushaut2) or 0
                })
            else
                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), item, 1, {
                    renamed = "Haut N°" .. tonumber(itemid),
                    drawableTorsoId = tonumber(itemid),
                    variationTorsoId = tonumber(itemVariation) or 0,
                    drawableArmsId = tonumber(itemBras),
                    variationArmsId = 0,
                    drawableTshirtId = soushaut and tonumber(soushaut) or 15,
                    variationTshirtId = soushaut2 and tonumber(soushaut2) or 0
                })
            end
        elseif item == "tshirt2" then
            TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), item, 1, {
                renamed = "T-Shirt N°" .. tonumber(itemid),
                drawableTorsoId = 15,
                variationTorsoId = 0,
                drawableArmsId = tonumber(itemBras),
                variationArmsId = 0,
                drawableTshirtId = tonumber(itemid),
                variationTshirtId = tonumber(itemVariation) or 0
            })
        elseif item == "sac" then
            TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), "access", 1, {
                renamed = firstToUpper(item) .. " #" .. tonumber(itemid),
                drawableId = tonumber(itemid),
                variationId = tonumber(itemVariation) or 0,
                name = item
            })
        elseif item == "mask" then
            TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), item, 1, {
                renamed = firstToUpper(item) .. " #" .. tonumber(itemid),
                drawableId = tonumber(itemid),
                variationId = tonumber(itemVariation) or 0,
                name = "mask"
            })
        else
            TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(player), item, 1, {
                renamed = firstToUpper(item) .. " #" .. tonumber(itemid),
                drawableId = tonumber(itemid),
                variationId = tonumber(itemVariation) or 0
            })
        end
    end
end)

RegisterCommand("addItemData", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local player = args[1]
        local item = args[2]
        local amount = args[3]
        local dataid = args[4]
        local variation = args[5]
        if amount == nil or amount == "" or dataid == nil or variation == nil then
            -- ShowNotification("~r~Commande incomplète (addItem ID item amount)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Commande incomplète (addItemData ID item amount dataid variation)"
            })

            return
        end
        TriggerEvent("core:tempgiveiditem", tonumber(args[1]), args[4], args[2], args[5])
    end
end)

RegisterCommand("addExpcrew", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local crewName = args[1]
        local count = args[2]
        if crewName == nil or count == nil then
            -- ShowNotification("~r~Commande incomplète (addItem ID item amount)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Commande incomplète (addExpcrew 'nom crew' 'nombre exp à ajouter')"
            })

            return
        end
        TriggerSecurEvent("core:crew:updateXp", token, tonumber(args[1]), "add", args[2], "admin")
    end
end)

RegisterCommand("rmvExpcrew", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local crewName = args[1]
        local count = args[2]
        if crewName == nil or count == nil then
            -- ShowNotification("~r~Commande incomplète (addItem ID item amount)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Commande incomplète (rmvExpcrew 'nom crew' 'nombre exp à retirer')"
            })

            return
        end
        TriggerSecurEvent("core:crew:updateXp", token, tonumber(args[1]), "remove", args[2], "admin")
    end
end)

RegisterCommand("getXpCrew", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local crewName = args[1]
        if crewName == nil then
            -- ShowNotification("~r~Commande incomplète (addItem ID item amount)")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Commande incomplète (getXpCrew 'crewName')"
            })

            return
        end
        local xp = TriggerServerCallback("core:getXpCrew", token, crewName)
        local level = TriggerServerCallback("core:crew:getCrewXpByName", crewName)
        print("le crew " .. crewName .. " a " .. xp .. " et est niveau " .. level)
    end
end)

-- RegisterCommand("semiwipe", function(source, args)
--     if p:getPermission() >= 4 then
--         if tonumber(args[1]) == -1 then return end
--         local id = tonumber(args[1])
--         local Player = TriggerServerCallback("core:GetPlayerInfoForWipe", token, id)

--         if Player == nil then
--             exports['vNotif']:createNotification({
--                 type = 'ROUGE',
--                 content = "~s Joueur introuvable"
--             })

--             return
--         end

--         local confirmation = WipeConfirm(id, Player.firstname, Player.lastname)
--         if confirmation == true then
--             TriggerServerEvent("core:SemiWipePlayer", token, id)
--         end
--     else
--         exports['vNotif']:createNotification({
--             type = 'ROUGE',
--             -- duration = 5, -- In seconds, default:  4
--             content = "Vous n'avez pas les permissions"
--         })
--     end
-- end)

RegisterCommand("wipe", function(source, args, rawCommand)
    if p:getPermission() >= 4 then
        if tonumber(args[1]) == -1 then return end
        local _id = tonumber(args[1])
        local Player = TriggerServerCallback("core:GetPlayerInfoForWipe", token, _id)

        if Player == nil then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~s Joueur introuvable"
            })

            return
        end

        local confirmation = WipeConfirm(_id, Player.firstname, Player.lastname)

        if confirmation == true then
            TriggerServerEvent("core:wipePlayer", _id)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas confirmé"
            })
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas les permissions"
        })
    end
end)

RegisterCommand("wipeidbdd", function(source, args, rawCommand)
    if p:getPermission() >= 5 then
        if tonumber(args[1]) == -1 then return end
        local id = tonumber(args[1])

        local confirmation = WipeConfirm(
        "Êtes-vous sûr de vouloir WIPE ce joueur ? (Il sera supprimé de la base de donnée)")
        if confirmation == true then
            Wait(1000)
            TriggerServerEvent("core:staffActionLog", token, "Wipe ID BDD", "ID du Personnage : " .. id)
            TriggerServerEvent("core:wipePlayerOffline", token, id)
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas les permissions"
        })
    end
end)

RegisterCommand("removeweaponidbdd", function(source, args, rawCommand)
    if p:getPermission() >= 5 then
        if tonumber(args[1]) == -1 then return end
        local id = tonumber(args[1])

        local confirmation = WipeConfirm("Êtes-vous sûr de vouloir SUPPRIMER les armes de ce joueur ? (Il sera supprimé de la base de donnée)")
        if confirmation == true then
            Wait(1000)
            TriggerServerEvent("core:staffActionLog", token, "Remove Weapon ID BDD", "ID du Personnage : " .. id)
            TriggerServerEvent("core:removeWeaponPlayerOffline", token, id)
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas les permissions"
        })
    end
end)

RegisterNetEvent("core:ReturnPlayer", function(coord)
    SetEntityCoords(PlayerPedId(), coord)
end)

RegisterCommand("goto", function(source, args, rawCommand)
    local player = args[1]
    TriggerServerEvent("core:staffActionLog", token, "/goto", player)
    TriggerServerEvent("core:GotoBring", token, nil, tonumber(player))
end)

bringData = {} 

RegisterCommand("return", function(source, args, rawCommand)
    local playerID = tonumber(args[1])
    if p:getPermission() >= 2 and bringData[playerID] then
        local data = bringData[playerID]
        TriggerServerEvent("core:staffActionLog", token, "/return", playerID)
        TriggerServerEvent("core:ReturnPositionPlayer", token, playerID, data.coords)
        bringData[playerID] = nil -- Remove player from bring data after return
    end
end)

RegisterCommand("bring", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        local playerID = tonumber(args[1])
        if playerID ~= -1 then
            local coords = TriggerServerCallback("core:CoordsOfPlayer", token, playerID)
            bringData[playerID] = {coords = coords}
            TriggerServerEvent("core:staffActionLog", token, "/bring", playerID)
            TriggerServerEvent("core:GotoBring", token, playerID, nil)
        else
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Oui bas bring ta daronne aussi tant qu'on y est"
            })
        end
    end
end)

RegisterCommand("setped", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        if tonumber(args[1]) == -1 then
            return
        end
        local id = GetPlayerServerId(PlayerId())
        local player = args[1]
        local ped = args[2]
        if ped == "m53" then
            if not string.find(string.lower(GetPlayerName(PlayerId())), "flo") then
                return
            end
        end

        if tonumber(player) == tonumber(id) then
            TriggerServerEvent("core:staffActionLog", token, "/setped", "Soi-même - " .. ped)
        else
            TriggerServerEvent("core:staffActionLog", token, "/setped", "ID " .. player .. " - " .. ped)
        end
        TriggerServerEvent("core:setPedStaff", token, tonumber(player), ped)
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "~c Votre ped à bien été changé en: " .. ped
        })
    end
end)

RegisterCommand("unsetped", function(source, args)
    if p:getPermission() >= 2 then
        args[1] = tonumber(args[1])
        if args[1] == nil or args[1] == -1 then
            return
        end
        local player = tonumber(args[1])
        local playerSex = p:getSex()

        local ped = "mp_m_freemode_01"
        if playerSex == "F" then
            ped = "mp_f_freemode_01"
        end

        TriggerServerEvent("core:acteurLog", token, "/setped", "Soi-même ** - Ped : **" .. ped)
        TriggerServerEvent("core:setPedStaff", token, player, ped)

        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Ped réinitialisé! Équipez n'importe quel vêtement pour récuperer votre personnage."
        })
    end
end)

RegisterCommand("resetHeistsLimit", function(source, args, rawCommand)
    if p:getPermission() >= 4 then
        TriggerServerEvent("core:ChangeHeistsLimitByID", token, args[1], "reset")

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "~s Limite de braquages remise à zéro pour l'id " .. args[1]
        })
    end
end)

--RegisterCommand("spFreq", function(source, args, rawCommand)
--    if p:getPermission() >= 3 then
--        local job = args[1]
--        local freq = tonumber(args[2])
--        local alrdSet = false
--
--        TriggerServerEvent('updatespFreq', job, freq)
--    end
--end)

local cooldown = false
RegisterCommand("creator", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        if tonumber(args[1]) == -1 then
            return
        end
        if args[1] ~= nil then
            local player = tonumber(args[1])
            TriggerServerEvent("core:staffActionLog", token, "/creator", player)
            TriggerServerEvent("core:loadCreator", token, player)
        else
            local player = GetPlayerServerId(PlayerId())
            TriggerServerEvent("core:staffActionLog", token, "/creator", "Soi-même")
            TriggerServerEvent("core:loadCreator", token, player)
        end
    elseif p:getSubscription() ~= 0 then 
        if not cooldown then
            cooldown = true
            local player = GetPlayerServerId(PlayerId())
            TriggerServerEvent("core:loadCreator", token, player)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez vous /creator que une fois par jour !"
            })
        end
    end
end)

RegisterNetEvent('core:setCrew')
AddEventHandler('core:setCrew', function(name)
    MyCrewLevel, MyCrewColor = nil, nil
    if p:getCrew() ~= "None" then
        print('crew : ' .. p:getCrew())
        TriggerServerEvent("core:UpdateCrewCount", p:getCrew(), false)
    end
    p:setCrew(name)
    ResetNoSpamSecuro()
    if p:getCrew() ~= "None" then
        print('crew : ' .. p:getCrew())
        TriggerServerEvent("core:UpdateCrewCount", p:getCrew(), true)
    end
    updateCrewPlayer(name)
    CheckCreateAllPlants()
    MyCrewLevel, MyCrewColor = TriggerServerCallback('core:crew:getCrewInfosForRadial',name)
    TriggerServerEvent("core:RegisterPlayer", name, nil, nil)
end)

RegisterNetEvent("core:loadCreator")
AddEventHandler("core:loadCreator", function()
    LoadNewCharCreator()
end)

RegisterCommand("liveries", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local veh = p:currentVeh()
        adminLiveries(veh)
    end
end)

--[[ RegisterCommand("gm", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        OpenGMmenu()
    end
end) ]]
-- open a menu to see available liveries and stickers
local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "shopui_title_carmod", "shopui_title_carmod")
local liveries = RageUI.CreateSubMenu(main, "", "Action disponible")
local stickers = RageUI.CreateSubMenu(main, "", "Action disponible")
local extra = RageUI.CreateSubMenu(main, "", "Action disponible")
local open = false
main.Closed = function()
    RageUI.Visible(main, false)
    RageUI.Visible(liveries, false)
    RageUI.Visible(stickers, false)
    RageUI.Visible(extra, false)
    open = false
end

function adminLiveries(veh)
    if open then
        open = false
        RageUI.Visible(main, false)
        RageUI.Visible(liveries, false)
        RageUI.Visible(stickers, false)
        RageUI.Visible(extra, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("Motif", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, liveries)
                    RageUI.Button("Stickers", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, stickers)
                    RageUI.Button("extra", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, extra)
                end)
                RageUI.IsVisible(liveries, function()
                    if GetNumVehicleMods(veh, 48) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 0, GetNumVehicleMods(veh, 48) do
                            local name = GetLabelText(GetModTextLabel(veh, 48, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, 48, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleMod(veh, 48, i, 0)
                                end
                            }, nil)
                        end
                    end
                end)
                RageUI.IsVisible(stickers, function()
                    if GetVehicleLiveryCount(veh) == -1 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetVehicleLiveryCount(veh) do
                            local name = GetLabelText(GetLiveryName(veh, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {
                                onActive = function()
                                    SetVehicleLivery(veh, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleLivery(veh, i)
                                end
                            }, nil)
                        end
                    end
                end)
                RageUI.IsVisible(extra, function()
                    local veh = p:currentVeh()
                    local availableExtras = {}
                    extrasExist = false
                    for extra = 0, 20 do
                        if DoesExtraExist(veh, extra) then
                            availableExtras[extra] = extra
                            extrasExist = true
                        end
                    end

                    if not extrasExist then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i in pairs(availableExtras) do
                            name = 'ORIGINAL'
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end
                            RageUI.Button(name, false, { RightBadge = Rightbadge }, true, {

                                onSelected = function()
                                    if IsVehicleExtraTurnedOn(veh, i) then
                                        SetVehicleExtra(veh, i, 1)
                                    else
                                        index = i
                                        SetVehicleExtra(veh, i, 0)
                                    end
                                end
                            }, nil)
                        end
                    end
                end)
                Wait(0)
            end
        end)
    end
end

local entitySets = {
    ["basketball"] = { 'mba_tribune', 'mba_tarps', 'mba_basketball', 'mba_jumbotron' },
    ["boxing"] = { 'mba_tribune', 'mba_tarps', 'mba_fighting', 'mba_boxing', 'mba_jumbotron' },
    ["concert"] = { 'mba_tribune', 'mba_tarps', 'mba_backstage', 'mba_concert', 'mba_jumbotron' },
    ["curling"] = { 'mba_tribune', 'mba_chairs', 'mba_curling' },
    ["derby"] = { 'mba_cover', 'mba_terrain', 'mba_derby', 'mba_ring_of_fire' },
    ["fameorshame"] = { 'mba_tribune', 'mba_tarps', 'mba_backstage', 'mba_fameorshame', 'mba_jumbotron' },
    ["fashion"] = { 'mba_tribune', 'mba_tarps', 'mba_backstage', 'mba_fashion', 'mba_jumbotron' },
    ["gokarta"] = { 'mba_cover', 'mba_gokart_01' },
    ["gokartb"] = { 'mba_cover', 'mba_gokart_02' },
    ["hockey"] = { 'mba_tribune', 'mba_chairs', 'mba_field', 'mba_hockey' },
    ["mma"] = { "mba_tribune", "mba_tarps", "mba_fighting", "mba_mma", "mba_jumbotron" },
    ["none"] = { 'mba_tribune', 'mba_tarps', 'mba_jumbotron' },
    ["paintball"] = { 'mba_tribune', 'mba_chairs', 'mba_paintball', 'mba_jumbotron' },
    ["trackmaniaa"] = { 'mba_trackmania_01', 'mba_cover' },
    ["trackmaniab"] = { 'mba_trackmania_02', 'mba_cover' },
    ["trackmaniac"] = { 'mba_trackmania_03', 'mba_cover' },
    ["trackmaniad"] = { 'mba_trackmania_04', 'mba_cover' },
    ["rocketleague"] = { 'mba_tribune', 'mba_chairs', 'mba_rocketleague' },
    ["soccer"] = { 'mba_tribune', 'mba_chairs', 'mba_field', 'mba_soccer' },
    ["wrestling"] = { 'mba_tribune', 'mba_tarps', 'mba_fighting', 'mba_wrestling', 'mba_jumbotron' },
    ["all"] = { 'mba_trackmania_04', 'mba_trackmania_03', 'mba_trackmania_02', 'mba_trackmania_01', 'mba_gokart_02',
        'mba_gokart_01', 'mba_hockey', 'mba_field', 'mba_soccer', 'mba_rocketleague', 'mba_curling', 'mba_tribune',
        'mba_cover',
        'mba_tarps', 'mba_chairs', 'mba_basketball', 'mba_derby', 'mba_paintball', 'mba_fighting', 'mba_wrestling',
        'mba_mma',
        'mba_boxing', 'mba_backstage', 'mba_concert', 'mba_fashion', 'mba_fameorshame', 'mba_ring_of_fire',
        'mba_jumbotron', 'mba_terrain' },
}

local function removeEntitysets(intID)
    for _, entitySet in ipairs(entitySets["all"]) do
        DeactivateInteriorEntitySet(intID, entitySet)
    end
    RefreshInterior(intID)
end

local function enableEntitysets(intID, entities)
    for _, entitySet in ipairs(entitySets[entities]) do
        ActivateInteriorEntitySet(intID, entitySet)
    end
    RefreshInterior(intID)
end

RegisterCommand('mba', function(source, args, rawCommand)
    if p:getPermission() >= 4 then
        if not args[1] then return end
        if args[1] then
            if args[1] == "all" then return end
            TriggerServerEvent("Gabz:server:UpdateMBALocation", args[1])
        end
    end
end)
addChatSuggestion(3, "mba", "Changer la configuration de la Maze Bank Arena", {
    { name = "Map", help = "basketball, boxing, concert, curling, derby, fameorshame, fashion, gokarta, gokartb, hockey, mma, none, paintball, trackmaniaa, trackmaniab, trackmaniac, trackmaniad, rocketleague, soccerwrestling" }
})

RegisterNetEvent("Gabz:client:UpdateMBALocation", function(map)
    local intID = GetInteriorAtCoords(-324.22030000, -1968.49300000, 20.60336000)
    if intID ~= 0 then
        removeEntitysets(intID)
        Wait(500)
        enableEntitysets(intID, map)
    end
end)

if GlobalState["mba:map"] then
    local intID = GetInteriorAtCoords(-324.22030000, -1968.49300000, 20.60336000)
    if intID ~= 0 then
        removeEntitysets(intID)
        Wait(500)
        enableEntitysets(intID, GlobalState["mba"])
    end
end

RegisterCommand("checkjob", function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local job = tostring(args[1])

        local onDuty = TriggerServerCallback("core:getOnDutyNames", token, job)
        if #onDuty == 0 then
            -- ShowNotification("Aucun employé en service")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Aucun employé en service"
            })
        else
            -- ShowNotification("Liste des employés en service dans le F8")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Liste des employés en service dans le F8"
            })

            print("Liste des employés en service :")
            print(json.encode(onDuty))
        end
    end
end)


-- RegisterCommand('adminBlackout', function()
--     if p:getPermission() >= 5 then
--         TriggerServerEvent('adminBlackout', p:getPermission())
--     end
-- end)

RegisterCommand('playsound', function(source, args, rawCommand)
    local url = args[1]
    local volume = args[2]

    if args[2] == nil then
        volume = 1.0
    end


    if p:getPermission() >= 5 then
        TriggerServerEvent('serverPlaySound', url, volume)
    end
end)

RegisterCommand('stopsound', function(source, args, rawCommand)
    if p:getPermission() >= 5 then
        TriggerServerEvent('serverStopSound')
    end
end)

RegisterCommand('volumesound', function(source, args, rawCommand)
    local volume = args[1]
    if p:getPermission() >= 5 then
        TriggerServerEvent('serverVolumeSound', volume)
    end
end)

-- DISABLE TURBULENCE
RegisterCommand('dt', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local plane = GetVehiclePedIsIn(PlayerPedId(), false)
        if IsThisModelAPlane(GetEntityModel(plane)) then
            SetPlaneTurbulenceMultiplier(plane, 0.0)
        elseif IsPedInAnyHeli(PlayerPedId()) then
            SetHeliTurbulenceScalar(plane, 0.0)
        end
    end
end)

RegisterCommand('spawnobject', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        local model = args[1]
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local heading = GetEntityHeading(PlayerPedId())
        local obj = CreateObject(GetHashKey(model), x, y, z, true, true, true)
        PlaceObjectOnGroundProperly(obj)
        SetEntityHeading(obj, heading)
        if args[2] == "false" then
            FreezeEntityPosition(obj, false)
        else
            FreezeEntityPosition(obj, true)
        end
    end
end)

RegisterCommand('labs', function()
    if p:getPermission() >= 3 then
        CreateLaboratory()
    end
end)

RegisterCommand("crun", function(source, args)
    if p:getPermission() >= 5 then
        local text = ""
        for i = 1, #args do
            text = text .. "" .. args[i]
        end
        local stringFunction, errorMessage = load("return " .. tostring(args[1]))

        if errorMessage then
            stringFunction, errorMessage = load(tostring(args[1]))
            print("crun error: " .. errorMessage)
        end

        pcall(stringFunction)
    end
end)

RegisterCommand('blips', function()
    if p:getPermission() >= 3 then
        exports["BlipCreator"]:blipCreator()
    end
end)

RegisterCommand('wipePhone', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        if args[1] then
            local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(args[1])
            exports["lb-phone"]:ResetSecurity(phoneNumber)  
            TriggerServerEvent("phone:server:resetNumber", args[1])
        end
    end
end)

RegisterCommand('resetSecurity', function(source, args, rawCommand)
    if p:getPermission() >= 3 then
        if args[1] then
            local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
            exports["lb-phone"]:ResetSecurity(phoneNumber)  
        end
    end
end)

RegisterCommand("heal", function(source, args)
    if p:getPermission() >= 3 then
        if args[1] ~= nil then
            local player = tonumber(args[1])
            TriggerServerEvent("core:staffActionLog", token, "/heal", player)
            TriggerServerEvent("core:HealthPlayer", token, player)
            TriggerServerEvent("core:createvNotif", token, tonumber(player), 'VERT', "Vous avez été soigné par un membre du staff.", 5)
        else
            local player = GetPlayerServerId(PlayerId())
            TriggerServerEvent("core:staffActionLog", token, "/heal", "Soi-même")
            TriggerServerEvent("core:HealthPlayer", token, player)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez été soigné"
            })
        end
    end
end)
addChatSuggestion(2, "heal", "Soigner un joueur", {
    { name = "id", help = "ID du joueur" }
})

RegisterCommand("annoncezone", function(source, args)
    if p:getPermission() >= 5 then
        local radius = args[1]
        local message = ""
        for i = 2, #args do
            message = message .. " " .. args[i]
        end
        AnnonceZone(radius, message)
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas les permissions"
        })
    end
end)
addChatSuggestion(4, "annoncezone", "Annonce dans une zone", {
    { name = "radius", help = "Rayon de l'annonce" },
    { name = "message", help = "Message de l'annonce" }
})

RegisterCommand("treatzone", function(source, args)
    if p:getPermission() >= 5 then
        TreatZone(args[1])
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~sPermission insuffisante !"
        })
    end
end)
addChatSuggestion(4, "treatzone", "Traiter une zone", {
    { name = "radius", help = "Rayon de la zone" }
})

RegisterCommand("resetJob", function(source, args, rawCommand)
    if p:getPermission() >= 4 then
        local societyname = args[1]

        if p:getPermission() < 5 and (societyname == "lspd" or societyname == "lssd" or societyname == "g6" or societyname == "usmc" or societyname == "usss" or societyname == "doj" or societyname == "justice" or societyname == "gouvernement" or societyname == "ems" or societyname == "lsfd") then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous n'avez pas les permissions de reset ce job !"
            })
            return
        end

        local confirmation = ChoiceInput("Attention cette action est irréversible, êtes vous sûr de vouloir remettre à zéro le job ".. societyname .." ?")
        if confirmation == true then
            local items = KeyboardImput("Liste des items à give (séparé par des virgules).")
            local quantity = KeyboardImput("Quantité des items à give (Défaut: 25).")

            local itemQuantity = tonumber(quantity) or 25

            if p:getPermission() < 5 and itemQuantity > 50 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'avez pas les permissions de give plus de 50 items !"
                })
                return
            end

            if not itemQuantity then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~sQuantité invalide !"
                })
                return
            end

            TriggerServerEvent("core:resetSociety", token, societyname, items, itemQuantity)
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas les permissions"
        })
    end
end)

RegisterCommand("kill", function(source, args)
    if p:getPermission() >= 3 then
        if args[1] == nil then return end
        if tonumber(args[1]) == -1 then return end

        TriggerServerEvent("core:KillPlayer", token, tonumber(args[1]))
        TriggerServerEvent("core:staffActionLog", token, "/kill", tonumber(args[1]))

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez kill ~s " .. tonumber(args[1])
        })
    end
end)
addChatSuggestion(2, "kill", "Tuer un joueur", {
    { name = "id", help = "ID du joueur" }
})

RegisterCommand("freeze", function(source, args)
    if p:getPermission() >= 3 then
        if args[1] == nil then return end
        if tonumber(args[1]) == -1 then return end
        TriggerServerEvent("core:FreezePlayer", token, tonumber(args[1]), true)
        TriggerServerEvent("core:staffActionLog", token, "/freeze", tonumber(args[1]))

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez freeze ~s " .. tonumber(args[1])
        })
    end
end)

RegisterCommand("unfreeze", function(source, args)
    if p:getPermission() >= 3 then
        if args[1] == nil then return end
        if tonumber(args[1]) == -1 then return end
        TriggerServerEvent("core:FreezePlayer", token, tonumber(args[1]), false)
        TriggerServerEvent("core:staffActionLog", token, "/unfreeze", tonumber(args[1]))

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez unfreeze ~s " .. tonumber(args[1])
        })
    end
end)

RegisterCommand("kick", function(source, args)
    if p:getPermission() >= 2 then
        if tonumber(args[1]) == -1 then return end
        local reason = ""
        for i = 2, #args do
            reason = reason .. " " .. args[i]
        end
        if reason == "" then return end
        TriggerServerEvent("core:staffSuivi", token, "kick", tonumber(args[1]), reason)
        TriggerServerEvent("core:KickPlayer", token, tonumber(args[1]), reason)

        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Vous avez kick ~s " .. tonumber(args[1])
        })
    end
end)

RegisterCommand("msg", function(source, args)
    if p:getPermission() >= 2 then
        if tonumber(args[1]) == -1 then return end
        local message = ""
        for i = 2, #args do
            message = message .. " " .. args[i]
        end
        if message ~= "" or message ~= nil then
            TriggerServerEvent("core:SendMessage", token, tonumber(args[1]), message)

            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez envoyé un message à ~s " .. tonumber(args[1])
            })
        end
    end
end)

local insideTablette = false
RegisterNUICallback("focusOut", function()
    if insideTablette then
        insideTablette = false
        openRadarProperly()
        SetNuiFocus(false, false)
        ExecuteCommand("e c")
    end
end)

RegisterNUICallback("InventoryCleaner_deleteItems", function(data)
    TriggerServerEvent("core:InventoryCleaner:Clean", token, data)
end)

RegisterCommand("InventoryCleaner", function(source, args)
    if p:getPermission() < 5 then return end

    local playerId = tonumber(args[1])
    local neededData = TriggerServerCallback("core:InventoryCleaner:GetData", token, playerId)

    if neededData == nil then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Joueur introuvable"
        })
        return
    end

    forceHideRadar()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openWebview',
        name = 'InventoryCleaner',
        data = {
            inventory = neededData.inventory,
            balance = neededData.balance,
            premium = neededData.premium,
            unique_id = neededData.unique_id,
            source = neededData.source,
            fullname = neededData.fullname,
            forced = true
        }
    })
end)

RegisterCommand("dutykick", function(source, args)
    if p:getPermission() < 2 then return end

    local playerId = tonumber(args[1])

    if playerId == -1 then return end

    TriggerServerEvent("core:ForceDutyOff", playerId)

    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Le joueur " .. playerId .. " a été kick de son service."
    })
end)

RegisterCommand("surprise", function(source, args)
    if p:getPermission() < 5 then return end

    if args[1] == nil then return end
    local target = tonumber(args[1])

    if target == -1 then return end

    TriggerServerEvent("core:SurprisePlayer", token, target)
end)

RegisterCommand("fesses", function(source, args)
    local mmap = getMapPosition()

    print(json.encode(mmap), "sacul le pire dev")
end)

RegisterNetEvent("core:SurprisePlayer")
AddEventHandler("core:SurprisePlayer", function()
    exports['aHUD']:toggleScreamer()
end)

--RegisterCommand("mdt", function(source, args)
RegisterNetEvent("core:tabletteMDT")
AddEventHandler("core:tabletteMDT", function()
    insideTablette = true
    forceHideRadar()
    ExecuteCommand("e tablet2")
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openWebview',
        name = 'mdt',
    })
    while insideTablette do
        Wait(1)
        DisableAllControlActions(0)
    end
end)

--RegisterCommand("lifeinvader", function(source, args)
RegisterNetEvent("core:tabletteLI")
AddEventHandler("core:tabletteLI", function()
    insideTablette = true

    forceHideRadar()
    ExecuteCommand("e tablet2")
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openWebview',
        name = 'LifeInvader',
    })
    while insideTablette do
        Wait(1)
        DisableAllControlActions(0)
    end
end)

RegisterNetEvent("Vision::ToggleLightBar")
AddEventHandler("Vision::ToggleLightBar", function()
    
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not DoesEntityExist(vehicle) then 
        -- If the vehicle does not exist, end the execution of the code here.
        return 
    end

    exports.vLightbar:loadLightbarInCar(vehicle, GetEntityModel(vehicle))
end)

RegisterNetEvent("core:vui:staffAlert")
AddEventHandler("core:vui:staffAlert", function(data)
    exports["VUI"]:ToggleStaffAlert(data.name, data.permission, data.message)
end)

RegisterNetEvent("core:vnotif:createAlert")
AddEventHandler("core:vnotif:createAlert", function(data)
    exports['vNotif']:createAlert(data)
end)

RegisterCommand("messagechiant", function(source, args)
    if p:getPermission() >= 5 then
        local id = args[1]
        local title = KeyboardImput("Titre du message")
        local message = KeyboardImput("Message")

        if id == nil or title == nil or message == nil then return end

        TriggerServerEvent("core:vadmin:message:chiant", token, id, title, message)
    end
end)

RegisterNetEvent("core:vadmin:message:chiant")
AddEventHandler("core:vadmin:message:chiant", function(data)
    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieMethodParameterString("~r~" .. data.title)
    PushScaleformMovieMethodParameterString(data.message)
    PushScaleformMovieMethodParameterInt(5)
    EndScaleformMovieMethod()
    -- loop for 5 seconds
    local timer = GetGameTimer() + 5000
    while GetGameTimer() < timer do
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        Wait(0)
    end
end)

addChatSuggestion(4, "startfire", "Démarre un incendie à votre position", {
    { name = "Flammes", help = "Le nombre de flammes" },
    { name = "Propagation", help = "La propagation de l'incendie en mètres" },
    { name = "Type", help = "Le type d'incendie | normal, normal2, chemical, electrical, bonfire" },
})

addChatSuggestion(3, "setfireaop", "Définit la zone de patrouille pour les incendies aléatoires", {
    { name = "ZDP", help = "La zone de patrouille" }, -- ZDP = Zone de Patrouille
})

addChatSuggestion(3, "stopfire", "Arrête un incendie spécifique ou ceux à proximité", {
    { name = "id", help = "Un ID d'incendie spécifique"}
})

addChatSuggestion(3, "enablerandomfires", "Active/Désactive les incendies aléatoires", {
    { name = "Activer", help = "Incendies aléatoires activés ? (true ou false)"}
})

addChatSuggestion(3, "stopallfires", "Arrête tous les incendies")

addChatSuggestion(3, "getfires", "Récupère toutes les données des incendies")