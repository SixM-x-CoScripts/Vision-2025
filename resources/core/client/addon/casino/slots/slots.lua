local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData = {}
local closetoSlots = false
local Slots = {}
local Spins = {}
local selectedSlot = nil
local SITTING_SCENE = nil
local CURRENT_CHAIR_DATA = nil
local SELECTED_CHAIR_ID = nil
local ACTIVE_SLOT = nil
local currentBetAmount = 0

CreateThread(function()
    SetPlayerControl(PlayerId(), 1, 0)
end)

local createdSlots = false
local function funcCreateSlots()
    if not craetedSlots then 
        createdSlots = true 
        for slotIndex, data in pairs(CasinoConfig.Slots) do
            createSlots(slotIndex, data)
        end
    end
end

CreateThread(function()
    while true do
        Wait(5000)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z < -30.0 then
            local playerCoords = GetEntityCoords(PlayerPedId())
            closetoSlots = false
            for k, v in pairs(CasinoConfig.Slots) do
                if #(playerCoords - CasinoConfig.Slots[k].pos) < 900.0 then
                    closetoSlots = true
                    funcCreateSlots()
                end
                Wait(100)
            end
        else
            Wait(5000)
        end
    end
end)

local IsRunningSlots = false

function GetClosestPedSlots(x,y,z,rad)
    local closestPed = 0
  
    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(x,y,z, GetEntityCoords(ped), true)
        if distanceCheck <= rad then
            print(ped, PlayerPedId(), PlayerId())
            if ped ~= PlayerPedId() then
                closestPed = ped
                break
            end
        end
    end

    return closestPed
end

createSlots = function(index, data)
   --print(data.pos)
    local self = {}

    self.index = index
    self.data = data
    self.betData = {}
    
    self.spin1 = nil
    self.spin2 = nil
    self.spin3 = nil
    
    self.spin1b = nil
    self.spin2b = nil
    self.spin3b = nil
	IsRunningSlots = false
    
    self.tableObject = GetClosestObjectOfType(data.pos,0.8,GetHashKey(self.data.prop),0,0,0)
    --SetEntityHeading(self.tableObject, -80.0)
    
    self.data.rot = GetEntityHeading(self.tableObject)
    self.data.position = GetEntityCoords(self.tableObject)
    
    self.offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),0.0, 0.05, 0.0)
    
    self.startPlaying = function(state)
        if state then
            Wait(3000)
            FreezeEntityPosition(PlayerPedId(), true)
            
            local sex = 0
            local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
            if not IsPedMale(PlayerPedId()) then sex = 1 end
            local L = 'anim_casino_a@amb@casino@games@slots@male'
            if sex == 1 then
                L = 'anim_casino_a@amb@casino@games@slots@female'
            end
            RequestAnimDict(L)
            while not HasAnimDictLoaded(L) do
                Wait(1)
            end
            SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            local rndspin = ({'base_idle_a', 'base_idle_b', 'base_idle_c', 'base_idle_d', 'base_idle_e', 'base_idle_f'})[math.random(1, 6)]
            NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,L,rndspin,2.0,2.0,13,16,2.0,0)
            NetworkStartSynchronisedScene(SITTING_SCENE)
            
            model = GetHashKey(self.data.prop1)
            RequestModel(model)
            while not HasModelLoaded(model) do
                RequestModel(model)
                Wait(0)
            end
        
            model = GetHashKey(self.data.prop2)
            RequestModel(model)
            while not HasModelLoaded(model) do
                RequestModel(model)
                Wait(0)
            end
        
            local rot = vector3(0.0, 0.0, self.data.rot + 0.0)
            local Offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.0, -0.5, 0.6)
                        
            local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),-0.118, 0.05, 0.9)
            local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.000, 0.05, 0.9)
            local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.118, 0.05, 0.9)
            
            
            selectedSlot = self.index
            
            self.spin1 = CreateObject(GetHashKey(self.data.prop1), Offset1.x, Offset1.y, Offset1.z, true, true)
            self.spin2 = CreateObject(GetHashKey(self.data.prop1), Offset2.x, Offset2.y, Offset2.z, true, true)
            self.spin3 = CreateObject(GetHashKey(self.data.prop1), Offset3.x, Offset3.y, Offset3.z, true, true)
            
            table.insert(Spins, self.spin1)
            table.insert(Spins, self.spin2)
            table.insert(Spins, self.spin3)
            
            SetEntityAsMissionEntity(self.spin1, true, true)
            SetEntityAsMissionEntity(self.spin2, true, true)
            SetEntityAsMissionEntity(self.spin3, true, true)
            
            SetEntityHeading(self.spin1, self.data.rot)
            SetEntityHeading(self.spin2, self.data.rot)
            SetEntityHeading(self.spin3, self.data.rot)
                        
            CreateThread(function()
                while selectedSlot ~= nil do
                    Wait(0)
                    if selectedSlot then
                        CasinoConfig.Slots2.ShowHelpNotification(string.format(CasinoConfigSH.Lang.InsideSlots, self.data.bet))
                    end

                    DisableKeysCasinoSlots()
                    
                    --if IsDisabledControlJustPressed(0, 191) then
                    --    local keke = KeyboardInput("", 10)
                    --    if keke and keke ~= "" then 
                    --        if tonumber(keke) then 
                    --            self.data.bet = tonumber(keke)
                    --        end
                    --    end
                    --end
                        
                    if IsDisabledControlJustPressed(0, 194) then	-- BACKSPACE
                        ACTIVE_SLOT = nil
                        DeleteSlots(self.spin1, self.spin2, self.spin3)
                        DeleteSlots2(Spins)
                        IsRunningSlots = false
                        selectedSlot = nil
                        self.startPlaying(false)
                        self.spin1 = GetClosestObjectOfType(Offset.x-0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
                        self.spin2 = GetClosestObjectOfType(Offset.x+0.000, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
                        self.spin3 = GetClosestObjectOfType(Offset.x+0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
                    end
                    if IsDisabledControlJustPressed(0, 22) then	-- SPIN
                        if not IsRunningSlots then
                            IsRunningSlots = true
                            startSlot(self.index, self.data)
                            self.spin1 = GetClosestObjectOfType(Offset.x-0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
                            self.spin2 = GetClosestObjectOfType(Offset.x+0.000, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
                            self.spin3 = GetClosestObjectOfType(Offset.x+0.118, Offset.y, Offset.z, 1.0, GetHashKey(self.data.prop1), false, false, false)
                        else
                            CasinoConfig.ShowNotification(CasinoConfigSH.Lang.ImpossibleAction)
                        end
                    end
                end
            end)
            Wait(2000)
        else
            IsRunningSlots = false
            FreezeEntityPosition(PlayerPedId(), false)
            
            selectedSlot = nil
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            local sex = 0
            local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
            if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then sex = 1 end
            local L = 'anim_casino_a@amb@casino@games@slots@male'
            if sex == 1 then
                L = 'anim_casino_a@amb@casino@games@slots@female'
            end
            RequestAnimDict(L)
            while not HasAnimDictLoaded(L) do
                Wait(1)
            end
            SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
            local rndspin = ({'exit_left', 'exit_right'})[math.random(1, 2)]
            NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,L,rndspin,2.0,2.0,13,16,0,0)
            NetworkStartSynchronisedScene(SITTING_SCENE)
            Wait(3000)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('sunwiseSlots:notUsing', self.index)
        end
    end
    
    self.spin = function(tickRate)
        local sex = 0; local rot = CURRENT_CHAIR_DATA.rotation + vector3(0.0, 0.0, -90.0)
        if not IsPedMale(PlayerPedId()) then sex = 1 end
        local L = 'anim_casino_a@amb@casino@games@slots@male'; if sex == 1 then L = 'anim_casino_a@amb@casino@games@slots@female' end
        RequestAnimDict(L) while not HasAnimDictLoaded(L) do Wait(1) end
        SITTING_SCENE = NetworkCreateSynchronisedScene(self.offset, rot, 2, 1, 0, 1065353216, 0, 1065353216)
        local rndspin = ({'press_spin_a', 'press_spin_b'})[math.random(1, 2)]
        NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,L,rndspin,2.0,2.0,50,16,2.0,0)
        NetworkStartSynchronisedScene(SITTING_SCENE)
        
        Wait(500)
        
        DeleteSlots(self.spin1, self.spin2, self.spin3)
        DeleteSlots2(Spins)
        
        local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject),-0.118, 0.05, 0.9)
        local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.000, 0.05, 0.9)
        local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject), GetEntityHeading(self.tableObject), 0.118, 0.05, 0.9)
        
        self.spin1b = CreateObject(GetHashKey(self.data.prop2), Offset1.x, Offset1.y, Offset1.z, true, true)
        self.spin2b = CreateObject(GetHashKey(self.data.prop2), Offset2.x, Offset2.y, Offset2.z, true, true)
        self.spin3b = CreateObject(GetHashKey(self.data.prop2), Offset3.x, Offset3.y, Offset3.z, true, true)
        table.insert(Spins, self.spin1b); table.insert(Spins, self.spin2b); table.insert(Spins, self.spin3b);
        SetEntityAsMissionEntity(self.spin1b, true, true)
        SetEntityAsMissionEntity(self.spin2b, true, true)
        SetEntityAsMissionEntity(self.spin3b, true, true)
        
        SetEntityHeading(self.spin1b, self.data.rot); SetEntityHeading(self.spin2b, self.data.rot); SetEntityHeading(self.spin3b, self.data.rot);
        local temp1 = GetEntityRotation(self.spin1b)
        local temp2 = GetEntityRotation(self.spin2b)
        local temp3 = GetEntityRotation(self.spin3b)
        
        SetEntityRotation(self.spin1b, temp1.x+math.random(0,360)-180.0, temp1.y, temp1.z, 0, true)
        SetEntityRotation(self.spin2b, temp2.x+math.random(0,360)-180.0, temp2.y, temp2.z, 0, true)
        SetEntityRotation(self.spin3b, temp3.x+math.random(0,360)-180.0, temp3.y, temp3.z, 0, true)
        
        for i=1,300,1 do
            local h1 = GetEntityRotation(self.spin1b)
            local h2 = GetEntityRotation(self.spin2b)
            local h3 = GetEntityRotation(self.spin3b)
            
            if i < 180 then
                SetEntityRotation(self.spin1b, h1.x+math.random(40,100)/10, h1.y, h1.z, 0, true)
            elseif i == 180 then
                h1 = GetEntityRotation(self.spin1b); DeleteSlot(self.spin1b)
                self.spin1 = CreateObject(GetHashKey(self.data.prop1), Offset1.x, Offset1.y, Offset1.z, true, true)
                table.insert(Spins, self.spin1)
                SetEntityAsMissionEntity(self.spin1, true, true)
                SetEntityHeading(self.spin1, self.data.rot); SetEntityRotation(self.spin1, tickRate.a*22.5-180+0.0, h1.y, h1.z, 0, true)
            end
                            
                            
            if i < 240 then
                SetEntityRotation(self.spin2b, h2.x+math.random(40,100)/10, h2.y, h2.z, 0, true)
            elseif i == 240 then
                h2 = GetEntityRotation(self.spin2b); DeleteSlot(self.spin2b)
                self.spin2 = CreateObject(GetHashKey(self.data.prop1), Offset2.x, Offset2.y, Offset2.z, true, true)
                table.insert(Spins, self.spin2)
                SetEntityAsMissionEntity(self.spin2, true, true)
                SetEntityHeading(self.spin2, self.data.rot); SetEntityRotation(self.spin2, tickRate.b*22.5-180+0.0, h2.y, h2.z, 0, true)
            end
                            
                            
            if i < 300 then
                SetEntityRotation(self.spin3b, h3.x+math.random(40,100)/10, h3.y, h3.z, 0, true)
            elseif i == 300 then
                h3 = GetEntityRotation(self.spin3b);DeleteSlot(self.spin3b)
                self.spin3 = CreateObject(GetHashKey(self.data.prop1), Offset3.x, Offset3.y, Offset3.z, true, true)
                table.insert(Spins, self.spin3)
                SetEntityAsMissionEntity(self.spin3, true, true)
                SetEntityHeading(self.spin3, self.data.rot); SetEntityRotation(self.spin3, tickRate.c*22.5-180+0.0, h3.y, h3.z, 0, true)
                local rndidle = ({'idle_a', 'idle_a=b'})[math.random(1, 2)]
                NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,'anim_casino_b@amb@casino@games@shared@player@',rndidle,2.0,2.0,50,16,2.0,0)
                NetworkStartSynchronisedScene(SITTING_SCENE)
            end				
            Wait(10)
            
        end
        IsRunningSlots = false
        TriggerServerEvent('sunwiseSlots:CheckWin', self.index, tickRate, self.data)
    end
    
    Slots[self.index] = self
end

function DeleteSlots(a, b, c)
    DeleteEntity(a)
    DeleteObject(a)
    while DoesEntityExist(a) do
        Wait(0)
        SetEntityAsMissionEntity(a, true, true)
        DeleteEntity(a)
        DeleteObject(a)
    end
    
    DeleteEntity(b)
    DeleteObject(b)
    while DoesEntityExist(b) do
        Wait(0)
        SetEntityAsMissionEntity(b, true, true)
        DeleteEntity(b)
        DeleteObject(b)
    end
    
    DeleteEntity(c)
    DeleteObject(c)
    while DoesEntityExist(c) do
        Wait(0)
        SetEntityAsMissionEntity(c, true, true)
        DeleteEntity(c)
        DeleteObject(c)
    end
end

function DeleteSlots2(a)
    for k,v in pairs(Spins) do 
        DeleteEntity(v)
        DeleteObject(v)
        while DoesEntityExist(v) do
            Wait(0)
            SetEntityAsMissionEntity(v, true, true)
            DeleteEntity(v)
            DeleteObject(v)
        end
    end
end

function DeleteSlot(a)
    DeleteEntity(a)
    DeleteObject(a)
    while DoesEntityExist(a) do
        Wait(0)
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteEntity(a)
        DeleteObject(a)
    end
end

function startSlot(index, data)
    if Slots[index] then
        TriggerServerEvent('sunwise:casino:StartSlots', index, data)
    else
        IsRunningSlots = false
    end
end

RegisterNetEvent("core:slots:resetSpin", function()
    IsRunningSlots = false
end)

function DisableKeysCasinoSlots()
    DisableControlAction(0, Keys['E'], true)
    DisableControlAction(0, Keys['F'], true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 323, true)
    DisableControlAction(0, 113, true)
    DisableControlAction(0, Keys['G'], true)
    DisableControlAction(0, Keys['X'], true)
    DisableControlAction(0, Keys['LEFTCTRL'], true)
    DisableControlAction(0, Keys['LEFTSHIFT'], true)
    DisableControlAction(0, Keys['DELETE'], true)
    DisableControlAction(0, Keys['ENTER'], true)
    DisableControlAction(0, Keys['BACKSPACE'], true)
    DisableControlAction(0, Keys['NENTER'], true)
    DisableControlAction(0, Keys['N4'], true)
    DisableControlAction(0, Keys['N5'], true)
    DisableControlAction(0, Keys['N6'], true)
    DisableControlAction(0, Keys['N7'], true)
    DisableControlAction(0, Keys['N8'], true)
    DisableControlAction(0, Keys['N9'], true)
    DisableControlAction(0, Keys['SPACE'], true)
end

RegisterNetEvent('sunwiseSlots:startSpin')
AddEventHandler('sunwiseSlots:startSpin',function(index, tickRate)
    if Slots[index] ~= nil then
        Slots[index].spin(tickRate)
    else
        IsRunningSlots = false
    end
end)

AddEventHandler('baseevents:onPlayerDied', function()
    if Slots[ACTIVE_SLOT] then
        Slots[ACTIVE_SLOT].startPlaying(false)
        DeleteSlots2(Spins)
    end
end)

local letSleep = 1
CreateThread(function()
    while true do
        Wait(letSleep)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        if z > -30.0 then
            letSleep = 2000
        end
        local playerpos = GetEntityCoords(PlayerPedId())
        if closetoSlots and selectedSlot == nil then
            for k, v in pairs(Slots) do
                if DoesEntityExist(v.tableObject) then
                    local objcoords = GetEntityCoords(v.tableObject)
                    local dist = Vdist2(playerpos, objcoords)
                    if dist < 2.0 then
                        letSleep = 1
                        local closestChairData = getClosestChairDataSlots(v.tableObject)
                        if closestChairData == nil then
                            break
                        end
                        DrawMarker(
                            20,
                            closestChairData.position + vector3(0.0, 0.0, 1.0),
                            0.0,
                            0.0,
                            0.0,
                            180.0,
                            0.0,
                            0.0,
                            0.3,
                            0.3,
                            0.3,
                            255,
                            255,
                            255,
                            255,
                            true,
                            true,
                            2,
                            true,
                            nil,
                            nil,
                            false
                        )
                        -- en menu
                        --CasinoConfig.Slots2.ShowHelpNotification(CasinoConfigSH.Lang.PlaySlots)
                        if IsControlJustPressed(0, 38) then 
                            local closestPos = GetClosestPedSlots(closestChairData.position.x, closestChairData.position.y, closestChairData.position.z, 0.5)
                            if closestPos == 0 then
                                ACTIVE_SLOT = v.index
                                SELECTED_CHAIR_ID = closestChairData.chairId
                                CURRENT_CHAIR_DATA = closestChairData
                                SITTING_SCENE = NetworkCreateSynchronisedScene(closestChairData.position, closestChairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
                                RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
                                while not HasAnimDictLoaded('anim_casino_b@amb@casino@games@shared@player@') do
                                    Wait(1)
                                end
                                local randomSit = ({'sit_enter_left', 'sit_enter_right'})[math.random(1, 2)]
                                NetworkAddPedToSynchronisedScene(PlayerPedId(),SITTING_SCENE,'anim_casino_b@amb@casino@games@shared@player@',randomSit,2.0,-2.0,13,16,2.0,0)
                                NetworkStartSynchronisedScene(SITTING_SCENE)
                                startSlot2(k, closestChairData.chairId)
                            else
                                CasinoConfig.ShowNotification(CasinoConfigSH.Lang.SeatOccupied)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function startSlot2(index, chairId)
    if Slots[index] then
        Slots[index].startPlaying(true)
    end
end

function getClosestChairDataSlots(tableObject)
    local localPlayer = PlayerPedId()
    local playerpos = GetEntityCoords(localPlayer)
    if DoesEntityExist(tableObject) then
        local objcoords = GetWorldPositionOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, 'Chair_Base_01'))
        local dist = Vdist(playerpos, objcoords)
        if dist < 1.7 then
            return {
                position = objcoords,
                rotation = GetWorldRotationOfEntityBone(tableObject, GetEntityBoneIndexByName(tableObject, 'Chair_Base_01')),
                chairId = 1,
                obj = tableObject
            }
        end
    end
end