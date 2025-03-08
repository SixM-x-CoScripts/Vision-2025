local Radio = {
    Has = true,
    Open = false,
    frequence = 80.8,
    On = false,
    opening = false,
    Enabled = true,
    Handle = nil,
    Prop = GetHashKey('prop_cs_hand_radio'), -- only ran once and doesn't break my syntax viewer
    Bone = 28422,
    Offset = vector3(0.0, 0.0, 0.0),
    Rotation = vector3(0.0, 0.0, 0.0),
    Dictionary = {
        "cellphone@",
        "cellphone@in_car@ds",
        "cellphone@str",
        "random@arrests",
    },
    Animation = {
        "cellphone_text_in",
        "cellphone_text_out",
        "cellphone_call_listen_a",
        "generic_radio_chatter",
    },
    Clicks = true, -- Radio clicks
    AllowRadioWhenClosed = true,
    volume = 50
}

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("debug", function()
    Radio.Open = false
    DetachEntity(Radio.Handle, true, false)
    DeleteEntity(Radio.Handle)
end)

local loaded = true

function OpenRadio()
    RadioToggle(true)
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openWebview",
        name = "radio",
        data = {
            frequence = math.round(Radio.frequence, 1)
        }
    })
    Radio.opening = false
    CreateThread(function()
        while Radio.Open do
            Wait(1)
            DisableControlAction(0, 24, Radio.On) -- disable attack
            DisableControlAction(0, 25, Radio.On) -- disable aim
            DisableControlAction(0, 1, Radio.On) -- LookLeftRight
            DisableControlAction(0, 2, Radio.On) -- LookUpDown
            DisableControlAction(0, 142, Radio.On)
            DisableControlAction(0, 18, Radio.On)
            DisableControlAction(0, 322, Radio.On)
            DisableControlAction(0, 106, Radio.On)
            DisableControlAction(0, 263, Radio.On) -- disable melee
            DisableControlAction(0, 264, Radio.On) -- disable melee
            DisableControlAction(0, 257, Radio.On) -- disable melee
            DisableControlAction(0, 140, Radio.On) -- disable melee
            DisableControlAction(0, 141, Radio.On) -- disable melee
            DisableControlAction(0, 142, Radio.On) -- disable melee
            DisableControlAction(0, 143, Radio.On) -- disable melee
        end
    end)
end

RegisterNUICallback("radio__callback", function(data, cb)
    if data.action == "soundup" then
        Radio.volume = Radio.volume + 5
        exports["pma-voice"]:setRadioVolume(Radio.volume)
    elseif data.action == "sounddown" then
        Radio.volume = Radio.volume - 5
        exports["pma-voice"]:setRadioVolume(Radio.volume)
    end
    if data.args == "remove" then
        if Radio.frequence > 999.8 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez pas mettre une fréquence supérieur à 1000."
            })
        elseif Radio.frequence < 20.0 and (p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "ems" and p:getJob() ~= "bcms" and p:getJob() ~= "lsfd" and p:getJob() ~= "g6" and p:getJob() ~= "usmc" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2") then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Cette fréquence est cryptée. Vous ne pouvez pas l'utiliser."
            })
        else
            Radio.frequence = Radio.frequence + 0.1
            SendNUIMessage({
                type = "updateFrequence",
                frequence = math.round(Radio.frequence, 1),
            })
        end
    elseif data.args == "add" then
        if Radio.frequence < 0.2 then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Vous ne pouvez pas mettre une fréquence négative."
            })
        elseif Radio.frequence < 20.1 and (p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "ems" and p:getJob() ~= "lsfd" and p:getJob() ~= "g6" and p:getJob() ~= "usmc" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2") then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "Cette fréquence est cryptée. Vous ne pouvez pas l'utiliser."
            })
        else
            Radio.frequence = Radio.frequence - 0.1
            SendNUIMessage({
                type = "updateFrequence",
                frequence = math.round(Radio.frequence, 1),
            })
        end
    elseif data.action == "toggle" then
        if Radio.On then
            Radio.On = false
            exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
            cb(false)
            -- RadioToggle(false)
        else
            Radio.On = true
            cb(true)
            exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        end
    elseif data.action == "man" then
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false, false)
        local freq = tonumber(KeyboardImput("Frequence"))
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        if freq ~= nil and type(freq) == "number" then
            if freq <= 0.0 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous ne pouvez pas mettre une fréquence négative."
                })
            elseif freq >= 1000.0 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous ne pouvez pas mettre une fréquence supérieur à 1000."
                })
            elseif freq < 20.0 and (p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" and p:getJob() ~= "ems" and p:getJob() ~= "lsfd" and p:getJob() ~= "g6" and p:getJob() ~= "usmc" and p:getJob() ~= "gouv" and p:getJob() ~= "gouv2") then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Cette fréquence est cryptée. Vous ne pouvez pas l'utiliser."
                })
            else
                print("New freq", freq)
                Radio.frequence = freq
                SendNUIMessage({
                    type = "updateFrequence",
                    frequence = math.round(Radio.frequence, 1),
                })
                -- save in cache
                SetResourceKvp('visionradio', freq)
                TriggerServerEvent("core:logs", token, {type = "radio", value = math.round(Radio.frequence, 1)})
            end
        else
            print("Vous n'avez pas rentré un nombre")
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous n'avez pas rentré un nombre"
            })
        end
        RadioToggle(false)
        SendNUIMessage({
            type = "closeWebview",
        })
    end
    if Radio.On then
        AddPlayerInRadio(math.round(Radio.frequence, 1))
    else
        AddPlayerInRadio(0)
    end
end)

CreateThread(function()
    -- get cache freq
    local kvpValue = GetResourceKvpString('visionradio') 
    if kvpValue then 
        SendNUIMessage({
            type = "updateFrequence",
            frequence = math.round(tonumber(kvpValue), 1),
        })
    end
end)


Keys.Register("P", "P", "Ouvrir la radio", function()
   -- if not Radio.opening then
     --   Radio.opening = true
        if p:haveItem("radio") then
            if loaded == true then
                if not Radio.Open then
                    Radio.volume = 50
                    exports["pma-voice"]:setRadioVolume(50)
                    OpenRadio()
            --        Radio.opening = false
                else
                    RadioToggle(false)
                    SendNUIMessage({
                        type = "closeWebview",
                    })
                end
       --     else                
       --         Radio.opening = false
            end
        else
            -- ShowNotification("~r~Vous n'avez pas de radio")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas de radio"
            })
           -- Radio.opening = false
        end
    --end
end)

---Function

function RadioToggle(toggle)
    local playerPed = PlayerPedId()
    local count = 0

    if not Radio.Has or IsEntityDead(playerPed) then
        Radio.Open = false
        DetachEntity(Radio.Handle, true, false)
        DeleteEntity(Radio.Handle)
        return
    end
    if Radio.Open == toggle then
        return
    end
    Radio.Open = toggle

    if Radio.On and not Radio.AllowRadioWhenClosed then
        exports["pma-voice"]:setVoiceProperty("radioEnabled", toggle)
    end

    local dictionaryType = 1 + (IsPedInAnyVehicle(playerPed, false) and 1 or 0)
    local animationType = 1 + (Radio.Open and 0 or 1)
    local dictionary = Radio.Dictionary[dictionaryType]
    local animation = Radio.Animation[animationType]

    RequestAnimDict(dictionary)

    while not HasAnimDictLoaded(dictionary) do
        loaded = false
        Citizen.Wait(150)
    end
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
   
    if Radio.Open then
        RequestModel(Radio.Prop)
        
        while not HasModelLoaded(Radio.Prop) do
            loaded = false
            Citizen.Wait(150)
        end
        loaded = true
        Radio.Handle = CreateObject(Radio.Prop, 0.0, 0.0, 0.0, true, true, false)

        local bone = GetPedBoneIndex(playerPed, Radio.Bone)
        SetEntityAsMissionEntity(Radio.Handle, true, true)
        SetCurrentPedWeapon(playerPed, unarmed, true)
        SetEntityCollision(Radio.Handle, false, false)
        AttachEntityToEntity(Radio.Handle, playerPed, bone, Radio.Offset.x, Radio.Offset.y, Radio.Offset.z,
            Radio.Rotation.x, Radio.Rotation.y, Radio.Rotation.z, true, false, false, false, 2, true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Radio.Handle), true)

        SetModelAsNoLongerNeeded(Radio.Prop)

        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)
    else
        loaded = false
        TaskPlayAnim(playerPed, dictionary, animation, 4.0, -1, -1, 50, 0, false, false, false)

        Citizen.Wait(700)

        StopAnimTask(playerPed, dictionary, animation, 1.0)

        NetworkRequestControlOfEntity(Radio.Handle)

        while not NetworkHasControlOfEntity(Radio.Handle) and count < 1000 do
            Citizen.Wait(0)
            count = count + 1
        end

        DetachEntity(Radio.Handle, true, false)
        DeleteEntity(Radio.Handle)
        loaded = true
    end
end

function AddPlayerInRadio(id)
    exports["pma-voice"]:setRadioChannel(id)
end

function RemovePlayerInRadio()
    exports["pma-voice"]:setRadioChannel(0)
end
