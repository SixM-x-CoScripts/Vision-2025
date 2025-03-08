local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local isAnimated = false

RegisterNetEvent("core:hunger&thirst")
AddEventHandler("core:hunger&thirst", function(type, value, propname)
    if type == "nourriture" then
        TriggerEvent("core:EatItem", propname)
        p:setHunger(p:getStatus().hunger + value)

        if p:getStatus().hunger > 100 then
            p:setHunger(100)
        end
        if p:getStatus().thirst > 100 then
            p:setThirst(100)
        end
        TriggerServerEvent("core:SetPlayerStatus", token, Round(p:getStatus().hunger), Round(p:getStatus().thirst), GetEntityHealth(p:ped()))
    elseif type == "boisson" then
        TriggerEvent("core:DrinkItem", propname)
        p:setThirst(p:getStatus().thirst + value)

        if p:getStatus().hunger >= 100 then
            p:setHunger(100)
        end
        if p:getStatus().thirst >= 100 then
            p:setThirst(100)
        end
        TriggerServerEvent("core:SetPlayerStatus", token, Round(p:getStatus().hunger), Round(p:getStatus().thirst), GetEntityHealth(p:ped()))

    end

end)
local function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Citizen.Wait(1)
    end
end

function WalkMenuStart(name)
    RequestWalking(name)
    SetPedMovementClipset(PlayerPedId(), name, 0.2)
    RemoveAnimSet(name)
end

CreateThread(function()
    while p == nil do
        Wait(100)
    end
    while not loaded do
        Wait(100)
    end
    while true do

        local thirst = p:getStatus().thirst
        local hunger = p:getStatus().hunger
        local permissions = p:getPermission()
		
        CreateThread(function()
            while thirst <= 2 or hunger <= 2 and p:getHealth() > 0 do
                local health = p:getHealth()
                thirst = p:getStatus().thirst
                hunger = p:getStatus().hunger
                p:setHealth(health - 1)
                if health == 0 then
                    if p:isInVeh() then 
                        p:setPos(p:pos())
                        SetEntityVisible(p:ped(), true)
                    end
                    TriggerEvent('core:onPlayerDeath')
                    return
                end
                Wait(1000)
            end
        end)

        if thirst > 0 and permissions <= 5 then
            local thirst = Round(thirst - 2)
			if thirst <= 0 then
                p:setThirst(0)
                thirst = 0
            else
                p:setThirst(thirst)
            end
        end

        if hunger > 0 and permissions <= 5 then
            local hunger = Round(hunger - 2)
			if hunger <= 0 then 
                p:setHunger(0)
            else
                p:setHunger(hunger)
            end
        end

        if thirst <= 0 then
            p:setThirst(0)
            thirst = 0
            WalkMenuStart("move_m@drunk@slightlydrunk")
        elseif hunger <= 0 then
            p:setHunger(0)
            hunger = 0
            WalkMenuStart("move_m@drunk@slightlydrunk")
        end
        
        TriggerServerEvent("core:SetPlayerStatus", token, p:getStatus().hunger, p:getStatus().thirst, GetEntityHealth(p:ped()))
        if hunger < 25 then
            -- ShowNotification("Vous avez ~g~Faim")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'BURGER',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s Faim"
            })
            
        end
        if thirst < 25 then
            -- ShowNotification("Vous avez ~b~Soif")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'BLEU',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s Soif"
            })

        end
        Wait(5 * 60000)
    end
end)

RegisterNetEvent("core:DrinkItem")
AddEventHandler("core:DrinkItem", function(propname)
    if not isAnimated then
        local propName = propname or 'prop_ld_flow_bottle'
        isAnimated = true
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        RequestModel(GetHashKey(propName))
        while not HasModelLoaded(GetHashKey(propName)) do 
            Wait(1)
        end
        local playerPed = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        local prop = CreateObject(GetHashKey(propName), x, y, z + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(playerPed, 18905)
        SetEntityCollision(prop, false, false)
        AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 72.0, 60.0, 160.0, true, false, false, true, 1, true)
        if not HasAnimDictLoaded('mp_player_intdrink') then
            RequestAnimDict('mp_player_intdrink')
            while not HasAnimDictLoaded('mp_player_intdrink') do
                Wait(1)
            end
        end
        TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 2.0, 2.0, 6000, 49, 0, 0, 0, 0)
        Wait((GetAnimDuration("mp_player_intdrink", "loop_bottle") * 1000) + 2200)
        isAnimated = false
        SetEntityAlpha(prop, 0.0)
        DeleteObject(prop)
        SetModelAsNoLongerNeeded(GetHashKey(propName))
    end
end)

RegisterNetEvent("core:EatItem")
AddEventHandler("core:EatItem", function(propname)
    if not isAnimated then
        TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
        local propName = propname or "prop_cs_burger_01"
        local prop2
        local propName2
        isAnimated = true
        if propName == "salade" or propName == "bol" then
            propName = propName == "salade" and "prop_cs_plate_01" or "v_res_tt_bowl"
            propName2 = "bkr_prop_coke_spoon_01"
            TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
            RequestModel(GetHashKey(propName2))
            while not HasModelLoaded(GetHashKey(propName2)) do 
                Wait(1)
            end
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            prop2 = CreateObject(GetHashKey(propName2), x, y, z + 0.2, 1)
        else
            RequestModel(GetHashKey(propName))
            while not HasModelLoaded(GetHashKey(propName)) do 
                Wait(1)
            end
        end
        local playerPed = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        local prop = CreateObject(GetHashKey(propName), x, y, z + 0.2, 1)
        local boneIndex = GetPedBoneIndex(playerPed, 18905)
        SetEntityCollision(prop, false, false)
        if propName == "prop_food_bs_burger2" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "prop_donut_01" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "bzzz_icecream_cherry" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "natty_lollipop_spin01" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "p_amb_coffeecup_01" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "prop_plastic_cup_02" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_chicken_wrap_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_buckets" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_ice_cream_meteorite_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "prop_candy_pqs" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_tacos_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "apple_1" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "bzzz_food_xmas_lollipop_a" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "brum_cherryshake_bubblegum" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "brum_heartfrappe" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_burg" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_fowl" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_fries" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_kids" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_rings" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_salad" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_soup" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "gn_cluckin_cup" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "bzzz_food_xmas_mulled_wine_a" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "knjgh_pizzaslice1" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_burger_simply_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_goat_wrap_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_fries_box_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_burger_fabulous_6lb_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_burger_glorious_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_burger_double_shot_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_soda_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_ice_cream_orang_otan_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_burger_prickly_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "nels_burger_bleeder_prop" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, -30.0, true, false, false, true, 1, true)
        elseif propName == "prop_taymckenzienz_popcorn" then 
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.10, 0.008, 0.05, -100.0, 16.0, -30.0, true, false, false, true, 1, true)
        
            

        elseif propName == "prop_cs_plate_01" or propName == "v_res_tt_bowl" then
            AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.0300, 0.0100, 0.0, 0.0, 0.0, true, false, false, true, 1, true)
            AttachEntityToEntity(prop2, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, true, 1, true)
        else
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.05, 0.02, -50.0, 16.0, 60.0, true, false, false, true, 1, true)
        end
        local animdict = propName2 == nil and 'mp_player_inteat@burger' or "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1"
        local animname = propName2 == nil and 'mp_player_int_eat_burger' or "base_idle"
        local duration = propName2 == nil and (GetAnimDuration(animdict, animname)*1000) + 3000 or GetAnimDuration(animdict, animname)*1000
        if not HasAnimDictLoaded(animdict) then
            RequestAnimDict(animdict)
            while not HasAnimDictLoaded(animdict) do
                Wait(1)
            end
        end
        TaskPlayAnim(PlayerPedId(), animdict, animname, 2.0, 2.0, duration, 49, 0, 0, 0, 0)
        Wait(duration)
        StopAnimTask(PlayerPedId(), animdict, animname, 1.0)
        isAnimated = false
        SetEntityAlpha(prop, 0.0)
        DeleteObject(prop)
        SetModelAsNoLongerNeeded(GetHashKey(propName))
        if propName2 then SetModelAsNoLongerNeeded(GetHashKey(propName2)) end
        if prop2 then SetEntityAlpha(prop2, 0.0) SetEntityCollision(prop2, false, false) DeleteObject(prop2) end
    end
end)

local cached_health = nil

CreateThread(function()
    while p == nil do
        Wait(0)
    end
    while not loaded do
        Wait(0)
    end
    while true do
        local health = p:getHealth()
        if health ~= cached_health then
            cached_health = health
            TriggerServerEvent("core:SetPlayerStatus", token, p:getStatus().hunger, p:getStatus().thirst, GetEntityHealth(p:ped()))
        end
        Wait(5000)
    end
end)