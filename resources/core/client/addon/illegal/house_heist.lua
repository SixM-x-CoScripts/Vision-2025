local token = nil
local timer = 2 * 60000 ---2 minutes
inHeist = false
local inHouse = false
local common
local recolt = false
local sound = 0
local looted = 0
local obj
local colorAlerte = { 3, 157, 26, 150 }
local alertePolice = false
local textAlerte = "Relativement calme"
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local RollTable = {}
local sizeOfItemList = 0
for k, v in pairs(House_heist_Item) do
    sizeOfItemList = sizeOfItemList + 1
end
-- sizeOfItemList = 18 pour l'instant
for i = 1, sizeOfItemList do
    for j = 1, House_heist_Item[i].luck do
        table.insert(RollTable, House_heist_Item[i])
    end
end

local function Roll() --> ObjectName [string]
    return RollTable[math.random(1, #RollTable)]
end

---
local name = nil
local boucle = false
local soundID

function playAlarm(s)
    if s.type == 1 then
        soundID = GetSoundId();
        PlaySoundFromEntity(soundID, s.dict, s.entity or PlayerPedId(), s.name, true, 0);
    elseif s.type == 2 then
        StopSound(soundID);
        ReleaseSoundId(soundID);
    end
end

local PropsInvis
function StartHouseHeist(id, pos, posInside, coffre, owner)
    local houseHeist = GetVariable("heist").hook
    --local houseHeist = {xp = 100, cops = 0}
    local policeMans = (GlobalState['serviceCount_lspd'] or 0) + (GlobalState['serviceCount_lssd'] or 0)
    if policeMans >= tonumber(houseHeist.cops) then
        if p:haveItem("crochet") and not inHeist then
            for _, value in pairs(p:getInventaire()) do
                if value.name == "crochet" then
                    TriggerServerEvent("core:RemoveItemToInventory", token, "crochet", 1, value.metadatas)
                end
            end
            RequestAnimDict('missheistfbisetup1')
            while not HasAnimDictLoaded('missheistfbisetup1') do
                Wait(0)
            end
            p:PlayAnim('missheistfbisetup1', 'hassle_intro_loop_f', 1)
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            if DlcIllegal then 
                if Serveur == "FA" then
                    OpenTutoFAInfo("Cambriolage", "Utilisez ZQSD ou les fleches pour deplacer la goupille")
                elseif Serveur == "WL" then
                    OpenTutoWLInfo("Cambriolage", "Utilisez ZQSD ou les fleches pour deplacer la goupille")
                end
                HideAllCambu()
                local result = exports['lockpick']:startLockpick()
                while result == nil do 
                    Wait(1)
                end
                if Serveur == "FA" then
                    exports['tuto-fa']:HideStep()
                elseif Serveur == "WL" then
                    exports['tuto-wl']:HideStep()
                end
                if not result then 
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous avez cassé votre crochet !"
                    })
                    DeleteCrochet()
                    ClearPedTasks(PlayerPedId())
                    return 
                end
                TriggerServerEvent('core:house:setPlayerRobberyGood')
                RemoveAnimDict("missheistfbisetup1")
                DeleteCrochet()
            else
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'Progressbar',
                    data = {
                        text = "Crochetage en cours...",
                        time = 10,
                    }
                }))
                TriggerServerEvent('core:house:setPlayerRobberyGood')
                RemoveAnimDict("missheistfbisetup1")
                Modules.UI.RealWait(10000)
            end
            TriggerServerEvent("core:heistlog", id, pos)
            if not inHeist then
                inHeist = true
                HideAllCambuForEnter(pos)
            end
            alertePolice = false
            recolt = false
            common = {}
            looted = 0
            boucle = false
            TriggerServerEvent("core:braquedHouse", token, id)
            TriggerServerEvent("core:InstancePlayer", token, id, "house_heist : Ligne 76")
            SetEntityCoordsNoOffset(p:ped(), posInside, 0.0, 0.0, 0.0)
            if not inHouse then
                inHouse = true
            end
            TriggerSecurEvent('core:makeCall', "lspd", pos, true,
                "cambriolage", false, 'illegal')

            TriggerSecurEvent('core:makeCall', "lssd", pos, true,
                "cambriolage", false, 'illegal')

            TriggerSecurEvent('core:makeCall', "gcp", pos, true,
                "cambriolage", false, 'illegal')
            -- sortie
            if inHouse and inHeist and not boucle then
                boucle = true
                CreateThread(function()
                    while inHeist do
                        if #(p:pos() - pos) > 20 and not inHouse then
                            timer = 2 * 60000 ---3 minute
                            inHouse = false
                            ShowAllPropertiesForCrochet()
                            recolt = false
                            sound = 0
                            boucle = false
                            colorAlerte = { 3, 157, 26, 150 }
                            alertePolice = false
                            textAlerte = "Relativement calme"
                            inHeist = false
                            if Serveur == "FA" then
                                exports['tuto-fa']:HideStep()
                            elseif Serveur == "WL" then
                                exports['tuto-wl']:HideStep()
                            end
                            return
                        end
                        Wait(1)
                        if IsPedRunning(p:ped()) and sound <= 100 and inHouse then
                            sound = sound + 0.1
                        end
                        if MumbleIsPlayerTalking(PlayerId()) and sound <= 100 and inHouse then
                            sound = sound + 0.03
                        end
                        if IsPedJumping(p:ped()) and sound <= 100 and inHouse then
                            sound = sound + 0.1
                        end
                        if IsPedWalking(p:ped()) and not GetPedStealthMovement(p:ped()) and sound <= 100 and inHouse then
                            sound = sound + 0.06
                        end
                        if sound <= 30 then
                            colorAlerte = { 3, 157, 26, 150 }
                            textAlerte = "Relativement calme"
                        elseif sound > 30 and sound <= 63 then
                            colorAlerte = { 157, 108, 3, 150 }
                            textAlerte = "Bruyant"
                        elseif sound > 60 then
                            colorAlerte = { 157, 3, 3, 150 }
                            textAlerte = "T'as réveillé le voisin"
                            -- Appel gang
                            if not Alerter then 
                                Alerter = true 
                                local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z))
                                TriggerServerEvent("core:house:callMecAppart", owner, streetName)
                                if DlcIllegal then 
                                    if PropsInvis then
                                        playAlarm({
                                            type = 1,
                                            entity = PropsInvis:getEntityId(), 
                                            dict = "Crate_Beeps", 
                                            name = "MP_CRATE_DROP_SOUNDS"
                                        })
                                    else                                        
                                        if not hasCreatedprops then 
                                            hasCreatedprops = true
                                            PropsInvis = entity:CreateObject("prop_tool_screwdvr03", value)
                                            SetEntityVisible(PropsInvis:getEntityId(), false, false)
                                            playAlarm({
                                                type = 1,
                                                entity = PropsInvis:getEntityId(), 
                                                dict = "Crate_Beeps", 
                                                name = "MP_CRATE_DROP_SOUNDS"
                                            })
                                        end
                                    end
                                end
                            end
                        end

                        Modules.UI.DrawSlider(0.42532941699028, 0.953125, 0.2, 0.03, { 0, 0, 0, 150 }, colorAlerte, sound
                            ,
                            100, {}, function()
                        end)
                        Modules.UI.DrawTexts(0.52489018440247, 0.95572918653488, textAlerte, true, 0.35,
                            { 255, 255, 255, 200 }, 1, false, false)
                    end
                end)                
                CreateThread(function()

                    while inHeist do
                        local gamePool = GetGamePool("CVehicle")
                        ----check distance
                        if #(p:pos() - pos) > 20 and not inHouse then
                            timer = 2 * 60000 ---3 minute
                            inHouse = false
                            recolt = false
                            ShowAllPropertiesForCrochet()
                            sound = 0
                            colorAlerte = { 3, 157, 26, 150 }
                            alertePolice = false
                            textAlerte = "Relativement calme"
                            boucle = false
                            inHeist = false
                            if Serveur == "FA" then
                                exports['tuto-fa']:HideStep()
                            elseif Serveur == "WL" then
                                exports['tuto-wl']:HideStep()
                            end                            
                            return
                        end
                        -- item zone
                        for key, value in pairs(coffre) do     
                            if not hasCreatedprops then 
                                hasCreatedprops = true
                                PropsInvis = entity:CreateObject("prop_tool_screwdvr03", value)
                                SetEntityVisible(PropsInvis:getEntityId(), false, false)
                            end
                            while #(p:pos() - value) < 8 do
                                --ShowHelpNotification("Appuyez sur ~r~~INPUT_CONTEXT~~s~ pour fouiller.")
                                Bulle.create("fouillerHouseHeist", value, "bulleFouillerMain", true)
                                if #(p:pos() - value) < 2.0 then
                                    if IsControlJustReleased(0, 38) and not recolt then

                                        item = Roll()
                                        common = item
                                        if item ~= nil then
                                            ClearPedTasksImmediately(p:ped())
                                            ExecuteCommand("e c")

                                            RequestAnimDict("pickup_object") while not HasAnimDictLoaded("pickup_object") do Wait(1) end
                                            TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
                                            Wait(1000)
                                            if item.propsName ~= "" then
                                                name = item.propsName
                                                obj = entity:CreateObject(item.propsName, p:pos())
                                                SetEntityCollision(obj:getEntityId(), false, true)
                                                AttachEntityToEntity(obj:getEntityId(), p:ped(),
                                                    GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), item.offset[1],
                                                    item.offset[2], item.offset[3], item.offset[4], item.offset[5],
                                                    item.offset[6], false, false, false, false, 0.0, true)
                                            end
                                            if item.emote then
                                                p:PlayAnim(item.dict, item.anim, 49)
                                            else
                                                ExecuteCommand("e box")
                                            end
                                            recolt = true
                                        else
                                            -- ShowNotification("Vous n'avez rien trouvé.")

                                            -- New notif
                                            exports['vNotif']:createNotification({
                                                type = 'JAUNE',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "Vous n'avez ~s rien trouvé."
                                            })
                                        end
                                    end
                                end
                                Wait(1)
                            end
                            Bulle.remove("fouillerHouseHeist")
                        end

                        ---Detection vehicule
                        if not inHouse then
                            for k, v in pairs(gamePool) do
                                while #
                                    (
                                    p:pos() - GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, "platelight")) +
                                        vector3(0.0, 0.0, 0.5)) < 1.5 and recolt do
                                    Bulle.create("poserCoffreHeist", GetWorldPositionOfEntityBone(v, GetEntityBoneIndexByName(v, "platelight")) + vector3(0.0, 0.0, 0.5), "bulleDeposer", true)
                                    --ShowHelpNotification("Appuyer sur ~r~~INPUT_CONTEXT~~s~ pour mettre l'objet dans le coffre.")
                                    if IsControlJustReleased(0, 38) and recolt then
                                        SetVehicleDoorOpen(v, 5, false, false)
                                        p:PlayAnim("anim@heists@narcotics@trash", "throw_b", 49)
                                        Wait(1000)
                                        local plate = all_trim(GetVehicleNumberPlateText(v))
                                        TriggerServerCallback("core:GetVehicleInventory", tostring(plate), GetEntityModel(v), v, VehToNet(v))
                                        TriggerSecurEvent("core:AddItemToVehicle", token, common.label, 1, tostring(plate), {}, GetEntityModel(v))
                                        -- ShowNotification("vous venez de déposer un(e) " .. common.item)

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'JAUNE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "Vous venez de déposer un(e) ~s " .. common.item
                                        })

                                        ExecuteCommand("e c")
                                        ClearPedTasksImmediately(p:ped())
                                        if obj ~= nil then
                                            obj:delete()
                                        end
                                        SetVehicleDoorShut(v, 5, false)
                                        recolt = false
                                        Bulle.remove("poserCoffreHeist")
                                        looted = looted + 1
                                        if looted == 5 then
                                            inHouse = false
                                            recolt = false
                                            sound = 0
                                            colorAlerte = { 3, 157, 26, 150 }
                                            alertePolice = false
                                            boucle = false
                                            textAlerte = "Relativement calme"
                                            ShowAllPropertiesForCrochet()
                                            -- ShowNotification("Vous avez fini de fouiller la maison.")

                                            ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), houseHeist.influence or 20, 13, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
                                            TriggerSecurEvent("core:crew:updateXp", token, tonumber(houseHeist.xp), "add", p:getCrew(), "heist")
                                            
                                            -- New notif
                                            exports['vNotif']:createNotification({
                                                type = 'JAUNE',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "Vous avez ~s fini de fouiller ~c la maison."
                                            })

                                            inHeist = false
                                            break
                                        end
                                    end
                                    Wait(1)
                                end
                            end
                        end
                        ---sortie
                        if #(p:pos() - pos) < 2.0 then
                            --ShowHelpNotification("Appuyer sur ~r~~INPUT_CONTEXT~~s~ pour rentrer")
                            if IsControlJustReleased(0, 38) and inHeist and not inHouse then
                                StartHouseHeist(id, pos, posInside, coffre)
                                Wait(200)
                                -- StartHouseHeist(id)
                            end
                        end
                        Wait(1)
                    end
                end)
                CreateThread(function()
                    while true do 
                        Wait(1)
                        if not inHeist then 
                            break
                        end
                        if #(p:pos() - posInside) < 4.0 then
                            --ShowHelpNotification("Appuyer sur ~r~~INPUT_CONTEXT~~s~ pour sortir")
                            Bulle.create("sortirBulle", posInside, "bulleSortir", true)
                            if IsControlJustPressed(0, 38) and inHeist then
                                SetEntityCoordsNoOffset(p:ped(), pos, 0.0, 0.0, 0.0)
                                Wait(200)
                                inHouse = false
                                TriggerServerEvent("core:InstancePlayer", token, 0, "house_heist : Ligne 292")
                                if obj ~= nil then
                                    obj:delete()
                                end
                                Wait(300)

                                if common ~= nil and common.emote and recolt then
                                    p:PlayAnim(common.dict, common.anim, 49)
                                    obj = entity:CreateObject(name, p:pos())
                                    SetEntityCollision(obj:getEntityId(), false, true)
                                    AttachEntityToEntity(obj:getEntityId(), p:ped(),
                                        GetEntityBoneIndexByName(p:ped(), "IK_R_Hand"), common.offset[1],
                                        common.offset[2],
                                        common.offset[3], common.offset[4], common.offset[5], common.offset[6], false,
                                        false, false, false, 0.0, true)
                                elseif recolt then
                                    ExecuteCommand("e box")
                                end
                            end
                        end
                    end
                end)
            end
        else
            if inHeist then
                TriggerServerEvent("core:InstancePlayer", token, id, "house_heist : Ligne 320")
                SetEntityCoordsNoOffset(p:ped(), posInside, 0.0, 0.0, 0.0)
                RageUI.CloseAll()
                inHouse = true
                if recolt then
                    if common ~= nil and common.emote and recolt then
                        p:PlayAnim(common.dict, common.anim, 49)
                    elseif recolt then
                        ExecuteCommand("e box")
                    end
                end
            else
                -- ShowNotification("Tu n'as pas les ~r~outils nécessaire~s~.")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Tu n'as pas les ~s outils nécessaire."
                })

            end

            return
        end
    else
        print("Pas assez de policier en service")
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Essayez plus tard."
        })
    end

end

local PropertyData = {}
---Point d'entrer et sortie
-- CreateThread(function()
--     while zone == nil do
--         Wait(1)
--     end
--     Wait(5000)
--     local property = TriggerServerCallback("core:getPropertyList", token)
--     local tables = {}
--     PropertyData = property
--     -- for k, v in pairs(House_heist.House) do
--     --     for key, value in pairs(PropertyData) do
--     --         local vec= vec3(tonumber(value.enter_pos.x), tonumber(value.enter_pos.y), tonumber(value.enter_pos.z))
--     --         local pos = #(v.EnterPos - vec)
--     --         if pos >= 5.0 then
--     --             if json.encode(tables) == "[]" then
--     --                 table.insert(tables, {name = v.name, pos = v.EnterPos, k= k})
--     --             end
--     --             for _, i in pairs(tables) do
--     --                 if i.pos ~= v.EnterPos then
--     --                     table.insert(tables, {name = v.name, pos = v.EnterPos, k= k})
--     --                 end
--     --             end
--     --         end
--     --     end
--     -- end
--     for k, v in pairs(House_heist.House) do
--         zone.addZone(v.name .. math.random(0,456456454), -- Nom
--         v.EnterPos, -- Position
--         nil, -- Text afficher
--         function() -- Action qui seras fait
--             if p:haveItem("crochet") then
--                 StartHouseHeist(k)
--             end
--         end, false)
--     end

-- end)


RegisterNetEvent("core:UseCrocket")
AddEventHandler("core:UseCrocket", function()
    -- for k, v in pairs(House_heist.House) do
    --     if #(p:pos() - v.EnterPos) <= 3.0 then
    --         StartHouseHeist(k)
    --     end
    -- end
    if TriggerServerCallback("core:house:getIfPlayerAlrdyRobbe") == true then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous avez déja cambriolée une maison."
        })
        return 
    end

    local propertiese = GetAllProperties()
    for k, v in pairs(propertiese) do -- load property
        if #(p:pos() - vector3(v.enter_pos.x, v.enter_pos.y, v.enter_pos.z)) <= 3.0 then
            local proper = TriggerServerCallback("core:property:getProperty", token, v.id)
            local has = TriggerServerCallback("core:heist:hasBraqued", token, v.id)
            if not has then
                Enter(v.id, vector3(v.enter_pos.x, v.enter_pos.y, v.enter_pos.z), proper)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Cette propriétée a déjà été cambriolée."
                })
            end
            -- body
            return


        end
    end
end)

function Enter(id, enter, property)
    if property.data.type == "habitation" then
        property.data.type = "Appartement"
    end
    
    if property.data.type == "stockage" then
        property.data.type = "Entrepot"
    end

    if property.data.type == "garage" then
        property.data.type = "Garage"
    end
    for k, v in pairs(Property) do
        for i = 1, #Property[k].data do
            RemoveIpl(Property[k].data[i].ipl)
        end
        if k == property.data.type then
            for _, i in pairs(v.data) do
                if i.name == property.data.interior then
                    if i.ipl ~= "" then
                        EnableIpl(i.ipl, true)

                        while not IsIplActive(i.ipl) do
                            Wait(1)
                        end
                    end
                    if string.find(property.data.interior, "Vide") then 
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Cette propriétée est sécurisé"
                        })
                        return
                    end
                    if property.data.type ~= "Garage" then
                        StartHouseHeist(id, enter, i.leave, i.itemPos, property.owner)
                    else
                        -- ShowNotification("~r~Cette propriétée est sécurisé")

                        -- New notif
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Cette propriétée est sécurisé"
                        })

                    end
                end
            end
        end
    end
end


RegisterNetEvent("core:houseBeingCrochet", function(streetname)
    if not DlcIllegal then return end
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Voisin",
        label = streetname,
        labelColor = "#FF0000",
        logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/1088546358031552663118717104605548138425289553566899079The_T.webp",
        mainMessage = "Viens vite ! Tu te fais cambrioler !",
        duration = 15,
    })
end)