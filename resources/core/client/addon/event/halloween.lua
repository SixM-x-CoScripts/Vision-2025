local Zombies = {
    "u_m_y_zombie_01",
    "U_M_O_FilmNoir",
}
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterCommand("stopZombie", function()
    if p:getPermission() > 4 then
        TriggerServerEvent("core:event:resetPed")
    end
end)

RegisterNetEvent("core:event:resetPed", function()
    -- if ped model is a zombie then unsetped
    RequestModel(GetHashKey("mp_m_freemode_01"))
    while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) do
        Wait(0)
    end
    RequestModel(GetHashKey("mp_f_freemode_01"))
    while not HasModelLoaded(GetHashKey("mp_f_freemode_01")) do
        Wait(0)
    end
    for i = 1, #Zombies do 
        if GetEntityModel(PlayerPedId()) == GetHashKey(Zombies[i]) then
            if string.lower(p:getSex()) == "m" then
                SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))
            else
                SetPlayerModel(PlayerId(), GetHashKey("mp_f_freemode_01"))
            end 
            TriggerEvent("skinchanger:loadSkin", p:getCloths().skin)
        end
    end
end)


local function RequestWalking(set)
    local timeout = GetGameTimer() + 5000
    while not HasAnimSetLoaded(set) and GetGameTimer() < timeout do
        RequestAnimSet(set)
        Wait(5)
    end
end

function EventHalloweenDiedByPlayer(killerId)
    -- check if player killerId has a zombie skin
    CreateThread(function()
        local _data = TriggerServerCallback("core:event:getPedModel", killerId)
        Pedmodel = _data.Pedmodel
        Active = _data.Active
        Wait(2050)
        --print("pedmodel", Pedmodel, Active)
        if Active then
            print("active")
            local Found = false
            for i = 1, #Zombies do 
                if Pedmodel == GetHashKey(Zombies[i]) then
                    Found = true
                end
            end
            for i = 1, #Zombies do 
                if GetEntityModel(PlayerPedId()) == GetHashKey(Zombies[i]) then
                    Found = false
                end
            end
            print("Revive")
            print("Found", Found)
            if Found then 
                TriggerEvent("core:RevivePlayer")
                local random = math.random(1, #Zombies)
                RequestModel(GetHashKey(Zombies[random]))
                while not HasModelLoaded(GetHashKey(Zombies[random])) do
                    Wait(0)
                end
                print("GetHashKey(Zombies[random])", GetHashKey(Zombies[random]))
                Wait(200)
                SetPlayerModel(PlayerId(), GetHashKey(Zombies[random]))
                Wait(200)
                TriggerServerEvent("core:halloween:weap")
                Wait(200)
                RequestWalking("move_m@buzzed")
                SetPedMovementClipset(PlayerPedId(), "move_m@buzzed", 0.2)
            else
                Wait(30000)
                TriggerEvent("core:RevivePlayer")
            end
        end    
    end)
end

RegisterNetEvent("core:event:halloween:setped", function()
    local random = math.random(1, #Zombies)
    RequestModel(GetHashKey(Zombies[random]))
    while not HasModelLoaded(GetHashKey(Zombies[random])) do
        Wait(0)
    end
    SetPlayerModel(PlayerId(), GetHashKey(Zombies[random]))
    RequestWalking("move_m@buzzed")
    SetPedMovementClipset(PlayerPedId(), "move_m@buzzed", 0.2)
end)