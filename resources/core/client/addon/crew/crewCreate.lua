local token = nil
local typeCrew = "normal"


TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterCommand("crewCreation", function(source, args, rawCommand)
    if p:getPermission() > 2 then
        TriggerServerEvent("core:createCrewCreation", GetPlayerServerId(PlayerId()), 'normal')
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Cette commande n'est plus disponible aux joueurs"
        })
    end
end)

RegisterNetEvent("core:createCrewCreation")
AddEventHandler("core:createCrewCreation", function(crewType)
    typeCrew = crewType
    print("openCrewCreate", typeCrew)
    openCrewCreate()
end)

function openCrewCreate()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CrewCreateMenu',
        data = {}
    }));
end

local pressed = false
RegisterNUICallback("crewMenu_callback", function(data)
    print("crewMenu_callback", json.encode(data, {indent = true}))
    if not pressed then
        pressed = true
        if not data then data = {crewNameMenu = "?", crewDeviseMenu = "", crewColor = "#10A8D1"} end
        local crew_cfg = {
            name = data.crewNameMenu,
            tag = "tag0",
            devise = data.crewDeviseMenu or "",
            grade = {
                { name = "Chef", id = 1 },
                { name = "Sous-Chef", id = 2 },
                { name = "manager", id = 3 },
                { name = "celui qui tient le canon", id = 4 },
                { name = "chair a canon", id = 5 }
            },
            color = data.crewColor or "#10A8D1",
            typeCrew = typeCrew,
        }
        local mainMessage = ""
        if crew_cfg.typeCrew ~= "normal" then
            TriggerServerEvent('core:AddCrewTable', crew_cfg.name)
            if crew_cfg.typeCrew == "pf" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", 140000, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_bat", 2, {})
                mainMessage = "Vous avez reçu votre starter.\n+140000$\n+2 Bat"
            elseif crew_cfg.typeCrew == "gang" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", 250000, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_pistol", 1, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_bat", 4, {})
                mainMessage = "Vous avez reçu votre starter.\n+250000$\n+1 Beretta\n+4 Bat"
            elseif crew_cfg.typeCrew == "mc" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", 310000, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_combatpistol", 2, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_bat", 4, {})
                mainMessage = "Vous avez reçu votre starter.\n+310000$\n+2 Glocks\n+4 Bat"
            elseif crew_cfg.typeCrew == "orga" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", 430000, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_combatpistol", 2, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_microsmg", 1, {})
                mainMessage = "Vous avez reçu votre starter.\n+430000$\n+2 Glocks\n+1 UZI"
            elseif crew_cfg.typeCrew == "mafia" then 
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", 500000, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_combatpistol", 2, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_microsmg", 1, {})
                Wait(200)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "weapon_compactrifle", 1, {})
                mainMessage = "Vous avez reçu votre starter.\n+500000$\n+2 Glocks\n+1 UZI\n+1 AkU"
            end
            Wait(200)
            TriggerSecurGiveEvent("core:addItemToInventory", token, "tablet", 1, {})
            exports['vNotif']:createNotification({
                type = 'ILLEGAL',
                name = "CREW",
                label = "Création de crew",
                labelColor = data.crewColor,
                logo = "https://i.imgur.com/4YkO1GX.webp",
                mainMessage = mainMessage,
                duration = 10,
            })
        end
        TriggerServerEvent('core:CreateCrew', token, crew_cfg)
        SendNUIMessage({
            type = 'closeWebview',
            name = 'CrewCreateMenu'
        });
    end
    pressed = false
end)