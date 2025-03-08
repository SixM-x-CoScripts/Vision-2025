local cutscene_menu = RageUI.CreateMenu("cutscenes", "cutscene Menu")
--cutscene_menu:SetStyleSize(200)
cutscene_menu:DisplayPageCounter(true)
local open = false
local selected_cutscene = nil
local selected_strength = 1
local cutscenes_list = {}

cutscene_menu.Closed = function()
    open = false
end

local path_to_cutscenes = "config/cutscenes.json"

local fileJson = LoadResourceFile(GetCurrentResourceName(), path_to_cutscenes)
if fileJson then
    cutscenes_list = json.decode(fileJson)
end

RegisterCommand("cutscenes", function()
    if p and p:getPermission() >= 3 then
        OpencutsceneMenu()
    end
end)
RegisterCommand("stopcutscene", function()
    if p and p:getPermission() >= 3 then
        StopCutsceneImmediately()
    end
end)

CreateThread(function()
    -- sort the list by name
    table.sort(cutscenes_list, function(a, b)
        return a < b
    end)
end)

local function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function OpencutsceneMenu()
    if open then
        open = false
        RageUI.Visible(cutscene_menu, false)
        return
    else
        open = true
        selected_cutscene = nil
        RageUI.Visible(cutscene_menu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(cutscene_menu, function()
                    -- add a button to select a cutscene
                    RageUI.Button("Arreter la cutscene", nil, { RightLabel = ">" }, true, {
                        onSelected = function(Index, Item)
                            StopCutsceneImmediately()
                        end
                    })
                    for k, v in pairs(cutscenes_list) do
                        --if string.find(v, "") then
                            RageUI.Button(v, nil, { RightLabel = ">" }, true, {
                                onSelected = function(Index, Item)
                                    -- play the cutscene (if it's already playing, stop it)
                                    Citizen.CreateThread(function()
                                        if IsCutsceneActive() then
                                            StopCutsceneImmediately()
                                        else
                                            RequestCutscene(v, 8)
                                            local timeout = GetGameTimer() + 10000
                                            while not HasCutsceneLoaded() and GetGameTimer() < timeout do
                                                Wait(0)
                                            end
                                            if HasCutsceneLoaded() then
                                                local plyrId = PlayerPedId()
                                                local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)
                                                SetBlockingOfNonTemporaryEvents(playerClone, true)
                                                SetEntityVisible(playerClone, false, false)
                                                SetEntityInvincible(playerClone, true)
                                                SetEntityCollision(playerClone, false, false)
                                                FreezeEntityPosition(playerClone, true)
                                                SetPedHelmet(playerClone, false)
                                                RemovePedHelmet(playerClone, true)
                                                SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
                                                RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)
                                                StartCutscene(v)
                                                CreateThread(function()
                                                    SetTimeout(100, function()
                                                        if IsCutsceneActive() then
                                                            local coords = GetWorldCoordFromScreenCoord(0.5, 0.5)
                                                            NewLoadSceneStartSphere(coords.x, coords.y, coords.z, 1000, 0)
                                                        end
                                                    end)
                                                end)
                                            else
                                                ShowNotification("Cutscene n'a pas réussi a charger")
                                            end
                                        end
                                    end)
                                end
                            })
                        --end
                    end
                end)
                Wait(0)
            end
        end)
    end
end


RegisterCommand("carcutscene", function(source, args)
   local v = "mp_intro_mcs_8_a1"
   RequestCutscene(v, 8)
   local timeout = GetGameTimer() + 10000
   while not HasCutsceneLoaded() and GetGameTimer() < timeout do
       Wait(0)
   end
   RequestModel(GetHashKey("adder"))
   while not HasModelLoaded(GetHashKey("adder")) do 
       Wait(0) 
   end
   local vehicle = CreateVehicle(GetHashKey("adder"), 355.35885620117, 271.88616943359, 102.0662002563, GetEntityHeading(PlayerPedId()), true, false)
   if HasCutsceneLoaded() then
       local plyrId = PlayerPedId()
       local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)
       SetBlockingOfNonTemporaryEvents(playerClone, true)
       SetEntityVisible(playerClone, false, false)
       SetEntityInvincible(playerClone, true)
       SetEntityCollision(playerClone, false, false)
       FreezeEntityPosition(playerClone, true)
       SetPedHelmet(playerClone, false)
       RemovePedHelmet(playerClone, true)
       SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
       RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)

       SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
       RegisterEntityForCutscene(plyrId, 'MP_2', 3, GetEntityModel(plyrId), 64)
   
       SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
       RegisterEntityForCutscene(plyrId, 'MP_3', 3, GetEntityModel(plyrId), 64)
   
       SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
       RegisterEntityForCutscene(plyrId, 'MP_4', 3, GetEntityModel(plyrId), 64)

       SetCutsceneEntityStreamingFlags(vehicle, 0, 1)
       RegisterEntityForCutscene(vehicle, args[1] or 'Vehicle_1', 0, GetEntityModel(vehicle), 64)

       N_0x78e8e3a640178255(vehicle)
       SetNetworkIdVisibleInCutscene(VehToNet(vehicle), true, true)
       SetNetworkCutsceneEntities(true)
       SetEntityVisibleInCutscene(vehicle, true, true)
       --SetCutsceneEntityStreamingFlags('Lamar', 0, 1)
       --RegisterEntityForCutscene(PlayerPedId(), 'Lamar', 0, GetEntityModel(plyrId), 64)

       StartCutscene(v)
       CreateThread(function()
           SetTimeout(100, function()
               if IsCutsceneActive() then
                   local coords = GetWorldCoordFromScreenCoord(0.5, 0.5)
                   NewLoadSceneStartSphere(coords.x, coords.y, coords.z, 1000, 0)
               end
           end)
       end)
   end
   
end)