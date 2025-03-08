---@diagnostic disable: lowercase-global
playerData = {}
loaded = false

TriggerServerEvent("core:InitPlayer")

RegisterNetEvent("core:RefreshPlayerData")
AddEventHandler("core:RefreshPlayerData", function(data)
    playerData = data
    player:new(data)
    TriggerEvent("core:RefreshData", playerData)
end)

AddEventHandler("playerSpawned", function()
    while p == nil do Wait(1) end
    while p:getFirstname() == nil do
        Wait(1)
    end
    FreezeEntityPosition(p:ped(), true)
    DisablePlayerVehicleRewards(p:ped())
    ShutdownLoadingScreenNui()
    SetEntityInvincible(p:ped(), true)
    RequestAllIpls()
    if p:getLastname() == "" or p:getFirstname() == "" then
        LoadNewCharCreator()
    elseif p:getLastname() ~= "" and p:getFirstname() ~= "" then
        LoadPlayerData(false)
        tattoosByed = p:getTattoos()
        GradenderByed = p:getDegrader()
        TriggerEvent("skinchanger:loadSkin", p:getCloths().skin)
        -- TriggerEvent('rcore_tattoos:applyOwnedTattoos')
    end
    SetEntityHealth(PlayerPedId(), p:getStatus().health)
    TriggerServerEvent("core:RestaurationInventaireDeBgplayer")
    while AddBlip == nil do Wait(500) end
    loaded = true
    SetEntityInvincible(p:ped(), false)
    FreezeEntityPosition(p:ped(), false)
    SetEntityHealth(PlayerPedId(), p:getStatus().health)
    --p:saveSkin() -- ne pas decommenté sauf urgence transexuel
    TriggerServerEvent("core:playerTimer:start", p:getId())

    local count = 0
    for k, v in pairs(p:getInventaire()) do
        if v.metadatas and tonumber(v.metadatas.removeTimestamp) then
            local timestamp = GlobalState.OsTime
            if tonumber(v.metadatas.removeTimestamp) < tonumber(timestamp) then
                count = count + 1
                print('Suppresion des items non existant', v.name)
                TriggerServerEvent("core:RemoveItemToInventory", nil, v.name, v.count, v.metadatas)
            end
        end
    end

    DoTemporaryStuff()
end)

function LoadPlayerData(fromCharCreator) -- Tout les init irons ici
    InitPositionHandler(p:getPos(), fromCharCreator)
    InitBlips()
    LoadWeaponHandler()
end

RegisterCommand("spawn", function()
    if p:getPermission() > 3 then 
        loaded = false
        TriggerEvent("playerSpawned")
    end
end)

local nibard = false
RegisterCommand("newpersonnage", function()
    local new = TriggerServerCallback("core:GetAllPersonnageNumber")
    if (p:getPermission() == 1 or p:getPermission() > 3) or p:getSubscription() >= 1 then 
        if (new < 2 and not nibard) or p:getPermission() > 3 then
            TriggerServerEvent("core:playerTimer:stop", p:getLicense(), p:getId())
            exports['vNotif']:createNotification({
                type = 'VERT',
                duration = 5, -- In seconds, default:  4
                content = "Vous êtes en train de créer un nouveau personnage"

            })
            TriggerServerEvent("core:NewPersonnage")
            nibard = true
            Wait(3000)
            nibard = false
            TriggerEvent("playerSpawned")
        else
            -- ShowNotification("Vous avez assez de personnage")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                duration = 5, -- In seconds, default:  4
                content = "~s Vous avez assez de personnage ou n'avez pas les droits"

            }) 

        end
    else
        if p:getPermission() == 0 or p:getPermission() == 2 or p:getPermission() == 3 and p:getSubscription() == 0 then 
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                duration = 5, -- In seconds, default:  4
                content = "~s Vous devez avoir le premium pour pouvoir créer un nouveau personnage"

            })
        end
    end
end)
local premReturn = false
RegisterCommand("personnage", function(source, args, raw)
    if args[1] == "prem" and p:getPermission() > 0 then premReturn = true end
    local characterList = TriggerServerCallback("core:GetAllPersonnage")
    forceHideRadar()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'ChoixPersonnage',
        data = characterList
    }))
end)

RegisterNUICallback("CloseChoixPersonnage", function (data, cb)
    if premReturn == true then
        openCb()
        premReturn = false
        return
    end
end)
RegisterNUICallback("ChoixPersonnage", function (data, cb)
    if (data.selected ~= nil) then
        
        if p:getSubscription() >= 1 or p:getPermission() == 1 or p:getPermission() >= 4 then
            if (switchChoixPersonnage(data.selected.id)) then
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                Citizen.CreateThread(function()
                    InitialSetup()
                    while GetPlayerSwitchState() ~= 5 do
                        Citizen.Wait(0)
                        ClearScreen()
                    end
                    ShutdownLoadingScreen()
                    ClearScreen()
                    Citizen.Wait(0)
                    DoScreenFadeOut(0)
                    ClearScreen()
                    Citizen.Wait(0)
                    ClearScreen()
                    DoScreenFadeIn(500)

                    FreezeEntityPosition(PlayerPedId(), true)
                    while not IsScreenFadedIn() do
                        Citizen.Wait(0)
                        ClearScreen()
                    end
                    local timer = GetGameTimer()
                    ToggleSound(false)
                    while true do
                        ClearScreen()
                        Citizen.Wait(0)
                        if GetGameTimer() - timer > 2000 then
                            SwitchInPlayer(PlayerPedId())
                            ClearScreen()
                            while GetPlayerSwitchState() ~= 12 do
                                Citizen.Wait(0)
                                ClearScreen()
                            end
                            break
                        end
                    end
                    ClearDrawOrigin()
                    Cam.RemoveAll()
                    SetNuiFocusKeepInput(false)
                    SetNuiFocus(false, false)
                    DisplayHud(true)
                    openRadarProperly()
                    FreezeEntityPosition(PlayerPedId(), false)
                    TriggerEvent("core:RefreshBinco")
                    TriggerEvent("core:RefreshMask")
                    TriggerEvent("core:RefreshCoiffeur")
                    return
                end)
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                --duration = 5, -- In seconds, default:  4
                content = "vous devez avoir l'abonnement premium pour pouvoir changer de personnage"
            })
        end
    end
    if premReturn == true then
        renderPremiumMenu()
        premReturn = false
        return
    end
end)
local cloudOpacity = 0.01 
local muteSound = true 

-- function ToggleSound(state)
--     if state then
--         StartAudioScene("MP_LEADERBOARD_SCENE");
--     else
--         StopAudioScene("MP_LEADERBOARD_SCENE");
--     end
-- end

-- function InitialSetup()
--     ToggleSound(muteSound)
--     if not IsPlayerSwitchInProgress() then
--         SwitchOutPlayer(PlayerPedId(), 0, 1)
--     end
-- end

-- function ClearScreen()
--     SetCloudHatOpacity(cloudOpacity)
--     HideHudAndRadarThisFrame()
--     SetDrawOrigin(0.0, 0.0, 0.0, 0)
-- end


local isSwitching = false

function switchChoixPersonnage(id)
    if p:getPermission() >=1 or p:getSubscription() >= 1 then
        -- don't allow to switch on the current character
        if id ~= nil then
            if not isSwitching then
                if tonumber(id) ~= tonumber(p:getId()) then
                    isSwitching = true
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous êtes en train de changer de personnage"
                    })
                    TriggerServerEvent("core:DutyOff", p:getJob())
                    TriggerServerEvent("core:playerTimer:stop", p:getLicense(), p:getId())
                    TriggerServerEvent("core:Switch", id)
                    Wait(2000)
                    TriggerEvent("playerSpawned")
                    ExecuteCommand("save")
                    isSwitching = false
                    
                    return true
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous êtes déjà sur ce personnage"
                    })
                    return false
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous êtes déjà en train de switch"
                })
                return false
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous devez spécifier un personnage"
            })
            return false
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            --duration = 5, -- In seconds, default:  4
            content = "vous devez avoir l'abonnement premium pour pouvoir changer de personnage"
        })
        return false
    end
end

-- evt refresh

RegisterNetEvent("core:setJobPlayer")
AddEventHandler("core:setJobPlayer", function(job, grade)
    p:updateJob(job, grade)
    CheckNewRegister()
end)

RegisterNetEvent("core:setStatusPlayer")
AddEventHandler("core:setStatusPlayer", function(hunger, thirst, health)
    p:updateStatus(hunger, thirst, health)
end)

RegisterNetEvent("core:addClothPlayer")
AddEventHandler("core:addClothPlayer", function(name, data)
    table.insert(p:getCloths().cloths, {name = name, data = data})
end)

RegisterNetEvent("core:removeClothPlayer")
AddEventHandler("core:removeClothPlayer", function(key)
    table.remove(p:getCloths().cloths, key)
end)

RegisterNetEvent("core:renameClothPlayer")
AddEventHandler("core:renameClothPlayer", function(key, name)
    p:getCloths().cloths[key].name = name
end)

RegisterNetEvent("core:setCrewPlayer")
AddEventHandler("core:setCrewPlayer", function(crew, crewType)
    CheckCreateAllPlants()
    print("crew, crewType : "..crew, crewType)
    if p:getCrew() ~= "None" then
        print('crew : '..p:getCrew())
        TriggerServerEvent("core:UpdateCrewCount", p:getCrew(), false)
    end
    p:setCrew(crew)
    if crew ~= "None" then 
        p:setCrewType(crewType)
    end
    if p:getCrew() ~= "None" then
        print('crew : '..p:getCrew())
        TriggerServerEvent("core:UpdateCrewCount", p:getCrew(), true)
    end
end)

RegisterNetEvent("core:setSkinPlayer")
AddEventHandler("core:setSkinPlayer", function(skin)
    p:setSkin(skin)
end)

RegisterNetEvent("core:setIdentityPlayer")
AddEventHandler("core:setIdentityPlayer", function(nom, prenom, age, sexe, taille, birthplaces)
    p:updateIdentity(nom, prenom, age, sexe, taille, birthplaces)
end)

RegisterNetEvent("core:addItemPlayer")
AddEventHandler("core:addItemPlayer", function(item)
    while not p do Wait(1) end
    local inv = p:getInventaire()
    table.insert(inv, item)
    p:setInventaire(inv)
end)

RegisterNetEvent("core:addExistItemPlayer")
AddEventHandler("core:addExistItemPlayer", function(item, quantity)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name then
            v.count = v.count + quantity
            break
        end
    end
    p:setInventaire(inv)
end)

RegisterNetEvent("core:renameItemPlayer")
AddEventHandler("core:renameItemPlayer", function(item, name, metadatas)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name then
            if v.metadatas == nil then
                v.metadatas = {}
            end
            if CompareMetadatas(v.metadatas, metadatas) then
                v.metadatas["renamed"] = name
            end
        end
    end
    p:setInventaire(inv)
end)

RegisterNetEvent("core:renameClothPlayer")
AddEventHandler("core:renameClothPlayer", function(item, name, metadatas)
    local inv = p:getInventaire()
    for k, v in pairs(inv) do
        if item == v.name and v.metadatas["drawableId"] == metadatas["drawableId"] and v.metadatas["renamed"] == metadatas["renamed"] then
            if v.metadatas == nil then v.metadatas = {} end
            v.metadatas["renamed"] = name
        end
    end
    p:setInventaire(inv)
end)

RegisterNetEvent("core:RemoveItemFromInventoryNil")
AddEventHandler("core:RemoveItemFromInventoryNil", function(name, quantity, metadatas)
    local inv = p:getInventaire()
    if inv ~= nil then
        for i = 1, #inv do
            if inv[i] ~= nil then
                if inv[i].name ~= nil and inv[i].metadatas == nil then
                    if inv[i].name == "money" and inv[i].metadatas == nil then
                        if inv[i].count - quantity <= 0 then table.remove(inv, i)
                        else inv[i].count = inv[i].count - quantity end
                        p:setInventaire(inv)
                        break
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("core:UpdateItemMetadata")
AddEventHandler("core:UpdateItemMetadata", function(item, count, metadata, newMetadata)
    local inv = p:getInventaire()
    for i = 1, #inv do
        if inv[i] ~= nil then
            if inv[i].name == item and inv[i].metadatas ~= nil then
                if CompareMetadatas(inv[i].metadatas, metadata) then
                    inv[i].metadatas = newMetadata
                    p:setInventaire(inv)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent("core:RemoveMetadatasInventory")
AddEventHandler("core:RemoveMetadatasInventory", function(name, quantity, metadatas)
    local inv = p:getInventaire()
    if inv ~= nil then
        for i = 1, #inv do
            if inv[i] ~= nil then
                if inv[i].name ~= nil and inv[i].metadatas ~= nil and CompareMetadatas(inv[i].metadatas, metadatas) and inv[i].name == name then
                    if inv[i].count - quantity <= 0 then table.remove(inv, i)
                    else inv[i].count = inv[i].count - quantity end
                    p:setInventaire(inv)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent("core:SetNewInventory")
AddEventHandler("core:SetNewInventory", function(inventory)
    p:setInventaire(inventory)
end)


local dataPlayerDroppedText = {}
local hidePlayerDroppedText = false

-- RegisterCommand('createtest', function()
--     dataPlayerDroppedText[1] = {
--         coords = GetEntityCoords(PlayerPedId(), false),
--         name = 'Test',
--         reason = 'Test',
--         start = GetGameTimer()
--     }
-- end)

RegisterCommand('hideplayerdroppedtext', function()
    if hidePlayerDroppedText then hidePlayerDroppedText = false else hidePlayerDroppedText = true end
end)

local maxDistance = 2500
local viewDistance = 500

Citizen.CreateThread(function()
    while p == nil do Wait(1) end
    if p:getPermission() < 2 then return end
    while true do
        if hidePlayerDroppedText then
            Wait(2500)
        else
            local counterNearPlayer = 0
            for k, v in pairs(dataPlayerDroppedText) do
                if GetGameTimer() > v.start + 480000 then
                    dataPlayerDroppedText[k] = nil
                else
                    local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), v.coords.x, v.coords.y, v.coords.z)
    
                    local alpha
                    if dist < viewDistance then
                        alpha = 255
                    else
                        alpha = math.floor(255 - ((dist - viewDistance) / (maxDistance - viewDistance)) * 255)
                    end

                    local size
                    if dist < viewDistance then
                        size = 0.2
                    else
                        size = 0.2 - ((dist - (viewDistance-200)) / (maxDistance - (viewDistance-200))) * (0.2 - 0.1)
                    end

                    if dist < maxDistance then
                        counterNearPlayer = counterNearPlayer + 1
                        SetTextScale(0.0, size)
                        SetTextFont(0)
                        SetTextProportional(0.2)
                        SetTextColour(250, 250, 250, alpha)
                        SetTextDropshadow(1, 1, 1, 1, 255)
                        SetTextEdge(2, 0, 0, 0, 150)
                        SetTextDropShadow()
                        SetTextOutline()
                        SetTextEntry("STRING")
                        SetTextCentre(1)
                        AddTextComponentString('Le joueur ~y~ID : '..k..'~s~ s\'est déconnecté\n~y~Raison ~s~: '..v.reason)
                        SetDrawOrigin(v.coords.x, v.coords.y, v.coords.z, 0)
                        DrawText(0.0, 0.0)
                        ClearDrawOrigin()
                    end
                end
            end

            if next(dataPlayerDroppedText) and counterNearPlayer > 0 then
                Wait(5)
            elseif next(dataPlayerDroppedText) then
                Wait(300)
            else
                Wait(1500)
            end
        end
    end
end)

RegisterNetEvent('core:sendPlayerDroppedText')
AddEventHandler('core:sendPlayerDroppedText', function(data)
    if p:getPermission() >= 2 then
        dataPlayerDroppedText[data.src] = {
            coords = data.coords,
            name = data.name,
            reason = data.raison,
            start = GetGameTimer()
        }
    end
end)