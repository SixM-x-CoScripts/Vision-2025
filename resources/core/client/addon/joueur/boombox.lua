BoomBox = {
    open = false,
    Volume = 7,
    holdingboom = false,
}

xSound = exports.xsoundtemp

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNUICallback("focusOut", function()
    if BoomBox.open then
        BoomBox.open = false 
        SetModelAsNoLongerNeeded(GetHashKey("prop_boombox_01"))
        RemoveAnimDict("pickup_object")
    end
end)

local function FuncUpdatePosition(musicid, coords) 
    CreateThread(function()
        while true do 
            Wait(650) -- en dessous inutile et au dessus le son va pas suivre
            local plys = GetAllPlayersIdsInArea(GetEntityCoords(PlayerPedId()), 10.0)
            if xSound:soundExists(musicid) then
                if BoomBox.holdingboom then
                    xSound:Position(musicid, GetEntityCoords(PlayerPedId()))
                    Wait(1000)
                    TriggerServerEvent("core:updateSongPos", token, plys,musicid, GetEntityCoords(PlayerPedId()))
                else
                    xSound:Position(musicid, coords)
                    Wait(5000)
                    TriggerServerEvent("core:updateSongPos", token, plys,musicid, coords)
                end
            end
        end
    end)
end

RegisterNetEvent("core:updateSongPosC", function(musicid, coooords)
    if xSound:soundExists(musicid) then
        xSound:Position(musicid, coooords)
    end
end)

RegisterNUICallback("boomBox_callBack_action_user", function(data)
    local closestBoobsbox = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, `prop_boombox_01`, false)
    if closestBoobsbox == -1 then return end
    if data.action_user and data.action_user == "ramasser" then 
        RequestAnimDict("move_weapon@jerrycan@generic")
        while not HasAnimDictLoaded("move_weapon@jerrycan@generic") do Wait(1) end
        TaskPlayAnim(PlayerPedId(), "move_weapon@jerrycan@generic", "idle", 1.0, -1, -1, 50, 0, 0, 0, 0)
        NetworkRequestControlOfEntity(closestBoobsbox)
        while not NetworkHasControlOfEntity(closestBoobsbox) do Wait(1) NetworkRequestControlOfEntity(closestBoobsbox) end
        AttachEntityToEntity(closestBoobsbox, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.27, 0.0, 0.0, 0.0, 263.0, 58.0, true, true, false , true, 1, true)
        BoomBox.holdingboom = true
        RemoveAnimDict("move_weapon@jerrycan@generic")
        FuncUpdatePosition('id_'..closestBoobsbox)
    elseif data.action_user == "porter" then 
        RequestAnimDict("molly@boombox1")
        while not HasAnimDictLoaded("molly@boombox1") do Wait(1) end
        TaskPlayAnim(PlayerPedId(), "molly@boombox1", "boombox1_clip", 1.0, -1, -1, 50, 0, 0, 0, 0)
        NetworkRequestControlOfEntity(closestBoobsbox)
        while not NetworkHasControlOfEntity(closestBoobsbox) do Wait(1) NetworkRequestControlOfEntity(closestBoobsbox) end
        AttachEntityToEntity(closestBoobsbox, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 10706), -0.2310,
        -0.0770,
        0.2410,
        -179.7256,
        176.7406,
        23.0190, true, true, false , true, 1, true)
        RemoveAnimDict("molly@boombox1")
        BoomBox.holdingboom = true
        FuncUpdatePosition('id_'..closestBoobsbox)
    elseif data.action_user == "poser" then 
        if BoomBox.holdingboom then
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            while not NetworkHasControlOfEntity(closestBoobsbox) do Wait(1) NetworkRequestControlOfEntity(closestBoobsbox) end
            if IsEntityAttached(closestBoobsbox) then 
                if GetEntityAttachedTo(closestBoobsbox) == PlayerPedId() then 
                    BoomBox.holdingboom = false
                    ClearPedTasks(PlayerPedId())
                end
                DetachEntity(closestBoobsbox)
            end
            SetEntityCoords(closestBoobsbox, x+0.78,y,z-0.98)
            FuncUpdatePosition('id_'..closestBoobsbox, GetEntityCoords(PlayerPedId()))
        end
    end
end)

function PoseLaBoombox()
    local closestBoobsbox = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, `prop_boombox_01`, false)
    if BoomBox.holdingboom then
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        while not NetworkHasControlOfEntity(closestBoobsbox) do Wait(1) NetworkRequestControlOfEntity(closestBoobsbox) end
        if IsEntityAttached(closestBoobsbox) then 
            if GetEntityAttachedTo(closestBoobsbox) == PlayerPedId() then 
                BoomBox.holdingboom = false
                ClearPedTasks(PlayerPedId())
            end
            DetachEntity(closestBoobsbox)
        end
        SetEntityCoords(closestBoobsbox, x+0.78,y,z-0.98)
        FuncUpdatePosition('id_'..closestBoobsbox, GetEntityCoords(PlayerPedId()))
    end
end

RegisterNetEvent("core:plyBoomSongC", function(musicId, url, volume, coords)
    local mycoords = GetEntityCoords(PlayerPedId())
    local distance = GetDistanceBetweenCoords(mycoords, coords, true)
    if distance < 200.0 then
        xSound:PlayUrlPos(musicId, url, volume, GetEntityCoords(PlayerPedId()))
        xSound:Distance(musicId, 10.0)
        xSound:setVolume(musicId, volume)
    end
end)

RegisterNUICallback("boomBox_callBack_action_son", function(data)
    local closestBoobsbox = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, `prop_boombox_01`, false)
    if closestBoobsbox == -1 then print("Aucune boombox proche") return end
    local musicId = 'id_'..closestBoobsbox
    if data.action_son == "play" then 
       -- xSound:PlayUrlPos(musicId, data.url_youtube, data.volume, GetEntityCoords(PlayerPedId()))
       -- xSound:Distance(musicId, 10.0)
       -- xSound:setVolume(musicId, data.volume)
        TriggerServerEvent("core:plyBoomSong", token, musicId, data.url_youtube, data.volume, GetEntityCoords(PlayerPedId()))
        FuncUpdatePosition(musicId, GetEntityCoords(PlayerPedId()))
    elseif data.action_son == "pause" then 
        if xSound:isPaused(musicId) then 
            xSound:Resume(musicId)
            TriggerServerEvent("core:PauseBoomSong", token, musicId, "resume")
        else
            xSound:Pause(musicId)
            TriggerServerEvent("core:PauseBoomSong", token, musicId, "pause")
        end
    elseif data.action_son == "stop" then 
        xSound:Destroy(musicId)
        TriggerServerEvent("core:PauseBoomSong", token, musicId, "stop")
    end
end)

RegisterNetEvent("core:PauseBoomSongC", function(musicid, typer)
    if xSound:soundExists(musicid) then
        if typer == "resume" then 
            xSound:Resume(musicid)
        elseif typer == "pause" then
            xSound:Pause(musicid)
        elseif typer == "stop" then
            xSound:Destroy(musicid)
        end
    end
end)

RegisterNUICallback("boomBox_callBack_volume", function(data)
    local closestBoobsbox = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, `prop_boombox_01`, false)
    if closestBoobsbox == -1 then return end
    if data.url_youtube ~= "" then
        while xSound == nil do Wait(1) print("wait xsound") end
        local musicId = 'id_'..closestBoobsbox
        if data.volume and data.volume/100 ~= BoomBox.Volume then 
            BoomBox.Volume = data.volume/100            
            TriggerServerEvent("core:BoomSongVolume", token, musicId, BoomBox.Volume)
            xSound:setVolume(musicId, BoomBox.Volume)
        end
    end
end)

RegisterNetEvent("core:BoomSongVolumeC", function(musicId, volum)
    if xSound:soundExists(musicId) then
        xSound:setVolume(musicId, volum)
    end
end)

OpenBoomBoxUI = function()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    BoomBox.open = true
    SetNuiFocusKeepInput(true)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'BoomBox'
    }))
    forceHideRadar()
    CreateThread(function()
        local disablekeys = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 23, 24, 25, 26, 32, 33, 34, 35, 37, 44, 45, 61, 268,270, 269,266,281,280,278,279,71,72,73,74,77,87,232,62, 63,69, 70, 140, 141, 142, 257, 263, 264}
        while BoomBox.open do 
            Wait(1)
            for k,v in pairs(disablekeys) do 
                DisableControlAction(0, v, true)
            end
            if IsDisabledControlJustPressed(0, 194) or IsDisabledControlJustPressed(0, 202) or IsControlJustPressed(0, 194) or IsControlJustPressed(0, 202) then 
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                BoomBox.open = false
            end
        end
    end)
end

--RegisterCommand("boombox", function()
--    if not BoomBox.open then
--        if not BoomBox.holdingboom then
--            RequestModel(GetHashKey("prop_boombox_01"))
--            while not HasModelLoaded(GetHashKey("prop_boombox_01")) do Wait(1) end
--            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
--            local obj = CreateObject(GetHashKey("prop_boombox_01"), x,y,z-0.98, 1)
--            OpenBoomBoxUI()
--        else
--            OpenBoomBoxUI()
--        end
--    else
--        SendNuiMessage(json.encode({
--            type = 'closeWebview',
--        }))
--        BoomBox.open = false
--    end
--end)

--local waitime = 1
--CreateThread(function()
--    while true do 
--        Wait(waitime)
--        while not NetworkIsPlayerActive(PlayerId()) do Wait(1) end
--        while not GetEntityModel(PlayerPedId()) do Wait(1) end
--        local boomobj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey("prop_boombox_01"), 0, 0, 0)
--        local boomobjcoords = GetEntityCoords(boomobj)
--        if BoomBox.open == false then
--            if not BoomBox.holdingboom then
--                if boomobj ~= nil or boomobj ~= -1 or boomobj ~= 0 then
--                --    print("boomobj, boomobjcoords", boomobj, boomobjcoords)
--                    if Vdist2(GetEntityCoords(PlayerPedId()), boomobjcoords) < 1.8 then 
--                        waitime = 1
--                        ShowHelpNotification("Appuyez sur ~r~~INPUT_PICKUP~~s~ pour utiliser la boombox.")
--                        if IsControlJustPressed(0, 38) then 
--                            OpenBoomBoxUI()
--                        end
--                    else
--                        waitime = 100
--                    end
--                else
--                    waitime = 300
--                end
--            else
--                waitime = 300
--            end
--        else
--            waitime = 300
--        end
--    end
--end)

RegisterNetEvent("core:UseBoombox", function()
    if not BoomBox.holdingboom then
        RequestModel(GetHashKey("prop_boombox_01"))
        while not HasModelLoaded(GetHashKey("prop_boombox_01")) do Wait(1) end
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        local obj = CreateObject(GetHashKey("prop_boombox_01"), x, y, z-0.98, 1)
        
        CheckBoomBoxPresence(obj)
        OpenBoomBoxUI()
    else
        OpenBoomBoxUI()
    end
end)

function CheckBoomBoxPresence(obj)
    Citizen.CreateThread(function()
        while DoesEntityExist(obj) do
            Wait(250)
        end

        xSound:Destroy('id_'..obj)
        TriggerServerEvent("core:PauseBoomSong", token, 'id_'..obj, "stop")
    end)
end

function PickupBoombox(entity)
    p:PlayAnim("pickup_object", "pickup_low", 0)
    TriggerServerEvent("DeleteEntity", token, { ObjToNet(entity) })
    xSound:Destroy('id_'..entity)
    TriggerServerEvent("core:PauseBoomSong", token, 'id_'..entity, "stop")
    --DeleteEntity(entity)
    TriggerSecurGiveEvent("core:addItemToInventory", token, "boombox", 1, {})
    exports['vNotif']:createNotification({
        type = 'VERT',
        -- duration = 5, -- In seconds, default:  4
        content = 'Vous avez ramassé une boombox.'
    })
end