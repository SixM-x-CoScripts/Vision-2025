--[[local dataTV = {}
local URLYOUTUBE = 'https://www.youtube.com/embed/%s?autoplay=1&controls=1&disablekb=1&fs=0&rel=0&showinfo=0&start=%s'
local SFHandle
-- https://www.youtube.com/watch?v=P1pNyAdCBYE

local TVObjects = {
    {
        ['Object'] = 'prop_tv_flat_01',
        ['Scale'] = 0.056,
        ['Offset'] = vec3(-1.03, -0.053, 1.04),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'ex_prop_ex_tv_flat_01',
        ['Scale'] = 0.056,
        ['Offset'] = vec3(-1.03, -0.053, 1.04),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'xm_prop_x17_tv_flat_02',
        ['Scale'] = 0.056,
        ['Offset'] = vec3(-1.03, -0.053, 1.04),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_michael',
        ['Scale'] = 0.035,
        ['Offset'] = vec3(-0.675, -0.055, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_trev_tv_01',
        ['Scale'] = 0.012,
        ['Offset'] = vec3(-0.225, -0.01, 0.26),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03b',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.062, 0.18),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.01, 0.4),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02b',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.029,
        ['Offset'] = vec3(-0.53, -0.011, 0.539),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'apa_mp_h_str_avunitm_01',
        ['Scale'] = 0.054,
        ['Offset'] = vec3(-1.00, -0.2939, 2.08),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_huge_display_01',
        ['Scale'] = 0.284,
        ['Offset'] = vector3(-5.20, -0.0939, 3.68),
        ['Distance'] = 50.0,
    },
    {
        ['Object'] = 'vw_prop_vw_cinema_tv_01',
        ['Scale'] = 0.056,
        ['Offset'] = vec3(-1.03, -0.053, 1.04),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = "apa_mp_h_str_avunitl_01_b",
        ['Scale'] = 0.056,
        ['Offset'] = vec3(-0.43999, -0.13299, 1.89999),
        ['Distance'] = 9.5,
    }
}

local function GenerateId(length, usecapital, usenumbers)
    local result = ''

    for i = 1, length do
        local randomised = string.char(math.random(97, 122))
        if usecapital then
            if math.random(1, 2) == 1 then
                randomised = randomised:upper()
            end
        end
        if usenumbers then
            if math.random(1, 2) == 1 then
                randomised = tostring(math.random(0, 9))
            end
        end
        result = result .. randomised
    end

    return result
end

local function PauseVideo(id)
    if dataTV[id]['DUI'] then
        local duiLong = dataTV[id]['DUI']['Long']

        SendDuiMouseMove(duiLong, 75, 700)
        Wait(5)
        SendDuiMouseDown(duiLong, 'left')
        Wait(7)
        SendDuiMouseUp(duiLong, 'left')

        SendDuiMouseMove(duiLong, 75, 500)
    end
end

local function VolumeCheck(id)
    if dataTV[id]['DUI'] then
        if dataTV[id]['Volume'] > 0.99 then dataTV[id]['Volume'] = 0.99 end
        if dataTV[id]['ActualVolume'] ~= dataTV[id]['Volume'] then
            local duiLong = dataTV[id]['DUI']['Long']

            SendDuiMouseMove(duiLong, 75, 700)
            Wait(550)
            SendDuiMouseMove(duiLong, 95 + math.ceil(dataTV[id]['Volume'] * 5), 702)
            Wait(5)
            SendDuiMouseDown(duiLong, 'left')
            Wait(7)
            SendDuiMouseUp(duiLong, 'left')
            
            SendDuiMouseMove(duiLong, 75, 500)
            dataTV[id]['ActualVolume'] = dataTV[id]['Volume']
            PauseVideo(id)
        end
    end
end

local function CreateVideo(id, url, object, coords, scale, offset, time, volume)
    if dataTV[id] then
        if dataTV[id]['DUI'] then
            DestroyDui(dataTV[id]['DUI']['Long'])
        end
        dataTV[id] = nil
        Wait(500)
    end

    local distance = 10.0

    for k, v in pairs(TVObjects) do
        if v['Object'] == object then
            Distance = v['Distance']
            break
        end
    end

    dataTV[id] = {
        ['URL'] = url,
        ['Time'] = time,
        ['Started'] = math.ceil(GetGameTimer() / 1000) + 1,
        ['Object'] = object,
        ['Coords'] = coords,
        ['Offset'] = offset,
        ['Scale'] = scale,
        ['Volume'] = volume,
        ['ActualVolume'] = 0,
        ['Distance'] = Distance
    }

    Wait(250)

    CreateTheDUI()

    CreateThread(function()
        if dataTV[id] then
            if dataTV[id]['DUI'] then
                --print("DUI URL", dataTV[id]['DUI']['Long'], string.format(URLYOUTUBE, dataTV[id]['URL'], 0), dataTV[id]['Time'], dataTV[id]['Started'])
                local time = (math.floor(GetGameTimer() / 1000) + dataTV[id]['Time']) - dataTV[id]['Started']
                if time < 0 then 
                    time = 0
                end
                SetDuiUrl(dataTV[id]['DUI']['Long'], URLYOUTUBE:format(dataTV[id]['URL'], time))
            end
        end
    end)

    --SendDuiMessage(duiObj, json.encode({
    --    setVideo = true,
    --    data = data
    --}))

    if dataTV[id]['DUI'] then
        while not IsDuiAvailable(dataTV[id]['DUI']['Long']) do Wait(10) print("wait") end
    end
    CreateThread(function()
        for k, v in pairs(dataTV) do
            if v ~= nil then
                local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
                CreateThread(function()
                    if v['DUI'] then
                        --print('found go ', v['DUI']['Long'])
                        local time = (math.floor(GetGameTimer() / 1000) + v['Time']) - v['Started']
                        if time < 1 then 
                            time = 0
                        end
                        SetDuiUrl(v['DUI']['Long'], URLYOUTUBE:format(v['URL'], time))
                    end
                end)
                break
            end
        end
    end)
end

RegisterNetEvent('core:tv:update')
AddEventHandler('core:tv:update', function(players, instanceid, idtele, offs)
    if instanceid == nil then instanceid = 0 end
    local myinstance = TriggerServerCallback("core:GetInstanceID")
    if instanceid == myinstance then 
        for k, v in pairs(players) do
            if v ~= nil then
                CreateVideo(k, v['URL'], v['Object'], v['Coords'], v['Scale'], v['Offset'], v['Time'], v['Volume'])
    
                if v['Duration'] then
                    dataTV[k]['Duration'] = v['Duration']
                end

            end
        end
        for k,v in pairs(TVObjects) do 
            if v['Offset'] == offs then
                v.teleid = idtele
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(500)

        for k, v in pairs(dataTV) do
            Wait(100)
            local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), v['Distance'], GetHashKey(v['Object']))

            if v ~= nil then
                local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
                if DoesEntityExist(obj) then
                    Wait(2500)
                    while #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= v['Distance'] and dataTV[k] ~= nil and DoesEntityExist(obj) do
                 --       print("Volume check")
                        VolumeCheck(k)
                        Wait(800)
                    end
                end
            end
        end
    end
end)

function CreateTheDUI()
    --print("go crea")
    for k, v in pairs(dataTV) do
        if v ~= nil then
            --print("---------------")
            --print(v['Coords'], v['Distance'], v['Object'], v['URL'], v['Time'], v['Started'])
            local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
            --print("obj", obj)
            if DoesEntityExist(obj) then
                if #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= v['Distance'] then
                    local duiLong = CreateDui(URLYOUTUBE:format(v['URL'], (math.floor(GetGameTimer() / 1000) + v['Time']) - v['Started']), 2660, 1440)
                    local dui = GetDuiHandle(duiLong)
                    --print("Create DUI")
                    --print("---------------")

                    local txd, txn = GenerateId(25, true, false), GenerateId(25, true, false)
                    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd(txd), txn, dui)

                    v['DUI'] = {
                        ['Long'] = duiLong,
                        ['Obj'] = dui,
                    }

                    v['Texture'] = {
                        ['txd'] = txd,
                        ['txn'] = txn,
                    }

                    PushScaleformMovieFunction(SFHandle, 'SET_TEXTURE')
                    PushScaleformMovieMethodParameterString(v['Texture']['txd'])
                    PushScaleformMovieMethodParameterString(v['Texture']['txn'])

                    PushScaleformMovieFunctionParameterInt(0)
                    PushScaleformMovieFunctionParameterInt(0)
                    PushScaleformMovieFunctionParameterInt(1920)
                    PushScaleformMovieFunctionParameterInt(1080)

                    PopScaleformMovieFunctionVoid()
                end
            end
        end
    end
end

CreateThread(function()
    while not GetEntityModel(PlayerPedId()) do Wait(50) end
    Wait(200)
    SFHandle = RequestScaleformMovie('hypnonema_texture_renderer01')
    while not HasScaleformMovieLoaded(SFHandle) do Wait(1) end
    TriggerServerEvent('core:tv:fetch')

    while true do
        Wait(500)

        for k, v in pairs(dataTV) do
            if v ~= nil then
                local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
                if DoesEntityExist(obj) then
                    if #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= v['Distance'] then
                        if SFHandle ~= nil then
                            local duiLong = CreateDui(URLYOUTUBE:format(v['URL'], (math.floor(GetGameTimer() / 1000) + v['Time']) - v['Started']), 2660, 1440)
                            local dui = GetDuiHandle(duiLong)

                            local txd, txn = GenerateId(25, true, false), GenerateId(25, true, false)
                            CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd(txd), txn, dui)

                            v['DUI'] = {
                                ['Long'] = duiLong,
                                ['Obj'] = dui,
                            }

                            v['Texture'] = {
                                ['txd'] = txd,
                                ['txn'] = txn,
                            }

                            PushScaleformMovieFunction(SFHandle, 'SET_TEXTURE')
                            PushScaleformMovieMethodParameterString(v['Texture']['txd'])
                            PushScaleformMovieMethodParameterString(v['Texture']['txn'])

                            PushScaleformMovieFunctionParameterInt(0)
                            PushScaleformMovieFunctionParameterInt(0)
                            PushScaleformMovieFunctionParameterInt(1920)
                            PushScaleformMovieFunctionParameterInt(1080)

                            PopScaleformMovieFunctionVoid()

                            while #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= v['Distance'] and DoesEntityExist(obj) and dataTV[k] ~= nil do
                                Wait(0)

                                if v['Duration'] then
                                    if (math.ceil(GetGameTimer() / 1000) - v['Started']) > v['Duration'] then
                                        DestroyDui(v['DUI']['Long'])
                                        dataTV[k] = nil
                                        break
                                    end
                                end
                                DrawScaleformMovie_3dNonAdditive(SFHandle, GetOffsetFromEntityInWorldCoords(obj, v['Offset']), 0.0, GetEntityHeading(obj) * -1, 0.0, 2, 2, 2, v['Scale'] * 1, v['Scale'] * (9 / 16), 1, 2)
                            end

                            if dataTV[k] then
                                DestroyDui(v['DUI']['Long'])

                                v['DUI'] = {}
                                v['Texture'] = {}
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterCommand('tv', function(source, args)
    for k, v in pairs(TVObjects) do
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v['Object']))
        if DoesEntityExist(obj) then
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'Menu_Television'
            }))
            break
        end
    end
end)

RegisterNUICallback("Television_click_action", function(dataNUI)
    for k, v in pairs(TVObjects) do
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v['Object']))
        if DoesEntityExist(obj) then
            if dataNUI.action == "play" and dataNUI.url_youtube then
                if string.find(dataNUI.url_youtube, "https") then
                    local pattern = "v=([%w_-]+)"
                    dataNUI.url_youtube = string.match(dataNUI.url_youtube, pattern)
                end
                TriggerServerEvent('core:tv:add', dataNUI.url_youtube, v['Object'], GetEntityCoords(obj), v['Scale'], v['Offset'], dataNUI.volume/100)
                break
            end
            if dataNUI.action == "stop" or dataNUI.action == "skip" then  
                for k, v in pairs(dataTV) do
                    if #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= 5.0 then
                        TriggerServerEvent('core:tv:destroy', k)
                        break
                    end
                end
            end
            if dataNUI.action == "pause" then 
                for k, v in pairs(dataTV) do
                    Wait(100)
                    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), v['Distance'], GetHashKey(v['Object']))
    
                    if v ~= nil then
                        local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
                        if DoesEntityExist(obj) then
                            PauseVideo(k)
                            break
                        end
                    end
                end
            end
        end
    end
end)
               

RegisterNUICallback("Television_volume_action", function(dataNUI)
    local volume = tonumber(dataNUI.volume)/100
    if volume == 1 then volume = 1.5 end
    if volume > 10 then volume = 10 end
    for k, v in pairs(TVObjects) do
        local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v['Object']))
        if DoesEntityExist(obj) then
            TriggerServerEvent('core:tv:setvolume', v.teleid and v.teleid or k, volume)
        end
    end
end)


RegisterCommand('refreshtv', function()
    for k, v in pairs(dataTV) do
        Wait(0)
        if v ~= nil then
            local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
            if DoesEntityExist(obj) then
                for k, v in pairs(dataTV) do
                    if v['Coords'] == GetEntityCoords(obj) then
                        CreateThread(function()
                            if v['DUI'] then
                                SetDuiUrl(v['DUI']['Long'], URLYOUTUBE:format(v['URL'], (math.floor(GetGameTimer() / 1000) + v['Time']) - v['Started']))
                            end
                        end)
                    end
                end
            end
        end
    end
end)

RegisterCommand('synctv', function()
    for k, v in pairs(dataTV) do
        Wait(0)
        if v ~= nil then
            local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
            if DoesEntityExist(obj) then
                for k, v in pairs(dataTV) do
                    if v['Coords'] == GetEntityCoords(obj) then
                        CreateThread(function()
                            if v['DUI'] then
                                SetDuiUrl(v['DUI']['Long'], URLYOUTUBE:format(v['URL'], (math.floor(GetGameTimer() / 1000) + v['Time']) - v['Started']))
                            end
                        end)
                    end
                end
            end
        end
    end
end)

RegisterCommand('volume', function(src, args)
    if args[1] then
        local volume = tonumber(args[1])
        if volume then
            if volume >= 0 then

                for k, v in pairs(dataTV) do
                    if #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= 5.0 then
                        if volume == 1 then volume = 1.5 end
                        if volume > 10 then volume = 10 end
                        TriggerServerEvent('core:tv:setvolume', k, volume)
                        break
                    end
                end

            end
        end
    end
end)

RegisterNetEvent('core:tv:delete')
AddEventHandler('core:tv:delete', function(id)
    if dataTV[id] then
        if dataTV[id]['DUI'] then
            DestroyDui(dataTV[id]['DUI']['Long'])
        end
        dataTV[id] = nil
    end
end)

RegisterNetEvent('core:tv:updatevolume')
AddEventHandler('core:tv:updatevolume', function(id, volume)
    if dataTV[id] then
        if volume == 1.0 then 
            volume = 0.9
        end
        if volume == 0.0 then 
            volume = 0.1
        end
        dataTV[id]['Volume'] = volume
    end
end)

RegisterCommand("changePosTV", function(source, args)
    for k, v in pairs(dataTV) do
        if v ~= nil then
            local obj = GetClosestObjectOfType(v['Coords'], v['Distance'], GetHashKey(v['Object']))
            if DoesEntityExist(obj) then
                if #(GetEntityCoords(PlayerPedId()) - v['Coords']) <= v['Distance'] then
                    if args[1] == "offsetX" then 
                        local amount = v["Offset"].x
                        amount = amount + args[2]
                        v["Offset"] = vector3(amount, v["Offset"].y, v["Offset"].z)
                    end
                    if args[1] == "offsetY" then 
                        local amount = v["Offset"].y
                        amount = amount + args[2]
                        v["Offset"] = vector3(v["Offset"].x, amount, v["Offset"].z)
                    end
                    if args[1] == "offsetZ" then 
                        local amount = v["Offset"].z
                        amount = amount + args[2]
                        v["Offset"] = vector3(v["Offset"].x, v["Offset"].y, amount)
                    end
                    if args[1] == "scale" then 
                        v["Scale"] = v["Scale"] + args[2]
                    end
                end
            end
        end
    end    
end)

--CreateThread(function()
--    local x,y,z,h = -1707.412109375, -904.71954345703, 6.7169904708862, 329.29138183594
--    RequestModel(GetHashKey("prop_huge_display_01"))
--    while not HasModelLoaded(GetHashKey("prop_huge_display_01")) do Wait(1) end
--    local obj = CreateObject(GetHashKey("prop_huge_display_01"), x,y,z, 1)
--    SetEntityHeading(obj, h-190)
--    FreezeEntityPosition(obj, true)
--    SetEntityAsMissionEntity(obj, 1, 1)
--end)]]