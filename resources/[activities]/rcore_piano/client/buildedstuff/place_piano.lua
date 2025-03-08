---------------------------------------------------------------
-- Variables
---------------------------------------------------------------
local CachedPianos = {}
local NearPocketPiano = false
local LastNetID = 0
local PlayerPocketPianoCount = 2
local PianoModel = GetHashKey("rcore_piano")
---------------------------------------------------------------
-- Functions
---------------------------------------------------------------
function CreatePianoObject(pos)
    RequestModel(PianoModel)
    while not HasModelLoaded(PianoModel) do
        Wait(100)
    end

    return CreateObject(PianoModel, pos.x, pos.y, pos.z, true, false, false)
end
---------------------------------------------------------------
-- Threads
---------------------------------------------------------------
-- check if player is near any player placed piano
CreateThread(function()
    while true do
        Wait(1250)
        NearPocketPiano = false
        local playerPos = GetEntityCoords(PlayerPedId())
        for v, _ in pairs(CachedPianos) do
            if NetworkDoesEntityExistWithNetworkId(v) then
                local obj = NetToObj(v)
                if #(playerPos - GetEntityCoords(obj)) < 1.5 and GetEntityModel(obj) == PianoModel then
                    if LastNetID ~= v then
                        ShowHelpNotification(_U("play pocket piano"))
                    end

                    NearPocketPiano = true
                    LastNetID = v
                end
            end
        end
    end
end)

-- keys for control
CreateThread(function()
    while true do
        Wait(0)
        if not NearPocketPiano then Wait(1000) end

        if IsControlJustReleased(0, 38) and NearPocketPiano then
            TriggerServerEvent(TriggerName("CanPlayPiano"), LastNetID)
        end

        if IsControlJustReleased(0, 47) and NearPocketPiano then
            Animation.ResetAll()
            Animation.Play("pickup")
            Wait(1000)
            TriggerServerEvent(TriggerName("PickUpPiano"), LastNetID)
        end
    end
end)
---------------------------------------------------------------
-- Events
---------------------------------------------------------------
RegisterNetEvent(TriggerName("FetchCache"), function(data)
    CachedPianos = data
end)

AddEventHandler(TriggerName("ClosePianoEvent"), function()
    Animation.ResetAll()

    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    TriggerServerEvent(TriggerName("SetActivePiano"), LastNetID, false)
end)

RegisterNetEvent(TriggerName("CanPlayPiano"), function(netID)
    local PianoObj = NetToObj(netID)
    local ped = PlayerPedId()
    if DoesEntityExist(PianoObj) then
        local PianoPos = GetOffsetFromEntityInWorldCoords(PianoObj, 0.3, 0.0, 1.0)
        SetEntityCoordsNoOffset(ped, PianoPos)
        SetEntityHeading(ped, GetEntityHeading(PianoObj) + 80)

        Wait(450)
        FreezeEntityPosition(ped, true)
        Config.OnPlayerMountedPiano()

        TriggerEvent("rcore_piano:SetDisplayStatus", true, 25)
    end
end)

RegisterNetEvent(TriggerName("PlacePianoDown"), function()
    Animation.ResetAll()
    Animation.Play("pickup")
    Wait(1000)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    local obj = CreatePianoObject(pos)

    TriggerServerEvent(TriggerName("SetActivePiano"), ObjToNet(obj), false)

    SetEntityHeading(obj, GetEntityHeading(ped) - 90)
    PlaceObjectOnGroundProperly(obj)
    local forward = GetEntityForwardVector(ped)
    local finalLocation = (GetEntityCoords(obj) - vector3(0, 0, 0.2)) + forward * 0.5
    SetEntityCoords(obj, finalLocation)

    ForceRoomForEntity(obj, GetInteriorAtCoords(finalLocation), GetRoomKeyFromEntity(ped))
    FreezeEntityPosition(obj, true)
end)