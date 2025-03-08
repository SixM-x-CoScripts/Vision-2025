TelevisionsLocal = {}

RegisterNUICallback("Television_click_action", function(dataNUI)
    print("CURRENT_SCREEN", json.encode(CURRENT_SCREEN))
    local screen = CURRENT_SCREEN.entity
    if screen and DoesEntityExist(screen) then
        print("yes exists")
        if dataNUI.action == "play" and dataNUI.url_youtube then
            print("play", dataNUI.url_youtube)
            if string.find(dataNUI.url_youtube, "https") then
                local pattern = "v=([%w_-]+)"
                dataNUI.url_youtube = string.match(dataNUI.url_youtube, pattern)
            end
            print("new play", dataNUI.url_youtube)
            TriggerServerEvent("core:tv:event", CURRENT_SCREEN, "ptv_status", {
                type = "play",
                url = dataNUI.url_youtube
            })
        end
        if dataNUI.action == "stop" or dataNUI.action == "skip" then  
            print("stop, skip")
            TriggerServerEvent("core:tv:event", CURRENT_SCREEN, "ptv_status", {
                type = "stop"
            })
        end
        if dataNUI.action == "pause" then 
            print("pause")
            TriggerServerEvent("core:tv:event", CURRENT_SCREEN, "ptv_status", {
                type = "pause"
            })
        end
    end
    print("ernnn")
end)

local SelectedTV = 1
function OpenTVMenu(id) 
    SelectedTV = id
    local screen = CURRENT_SCREEN
    if not screen then return end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(500)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Menu_Television'
    }))            
end

function PlayBrowser(data)
    while not IsDuiAvailable(getDuiURL()) do Wait(10) end
    setDuiURL(data.url)
end


local URLYOUTUBE = 'https://www.youtube.com/embed/%s?autoplay=1&controls=1&disablekb=1&volume=50&fs=0&rel=0&showinfo=0&start=%s'
function PlayVideo(data)
    print("duiObj", duiObj, json.encode(data))
    if data and data.time then data.time = data.time + 3 end
    while not IsDuiAvailable(duiObj) do Wait(10) end
    if SelectedTV then Bulle.hide("tvobj" .. SelectedTV) end
    --if (getDuiURL() ~= DEFAULT_URL) then 
    --    setDuiURL(DEFAULT_URL)
    --    Wait(2500)
    --end
    --local data = GetClosestScreen()
    --ShowScreen(data, data.url)
    
    local width = 1280
    local height = 720
    sfHandle = loadScaleform("generic_texture_renderer")
    runtimeTxd = 'ptelevision_b_dict'

    local txd = CreateRuntimeTxd(runtimeTxd)
    duiObj = CreateDui(string.format(URLYOUTUBE, data.url, data.time or 0), width, height)
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'ptelevision_b_txd', dui)
    
    Citizen.Wait(10)

    PushScaleformMovieFunction(sfHandle, 'SET_TEXTURE')

    PushScaleformMovieMethodParameterString(runtimeTxd)
    PushScaleformMovieMethodParameterString('ptelevision_b_txd')

    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(width)
    PushScaleformMovieFunctionParameterInt(height)

    PopScaleformMovieFunctionVoid()

    Wait(400)
    SetDuiUrl(duiObj, string.format(URLYOUTUBE, data.url, data.time or 0))
end

function ResetDisplay()
    setDuiURL(DEFAULT_URL)
end

function GetTelevisionLocal(coords)
    for k,v in pairs(TelevisionsLocal) do 
        if #(v3(v.coords) - v3(coords)) < 0.01 then
            return k, v
        end
    end
end

function SetTelevisionLocal(coords, key, value)
    local index, data = GetTelevisionLocal(coords)
    if (index ~= nil) then 
        if (TelevisionsLocal[index] == nil) then 
            TelevisionsLocal[index] = {}
        end
        TelevisionsLocal[index][key] = value
    else
        index = GetGameTimer()
        while TelevisionsLocal[index] do 
            index = index + 1
            Citizen.Wait(0)
        end
        if (TelevisionsLocal[index] == nil) then 
            TelevisionsLocal[index] = {}
        end
        TelevisionsLocal[index][key] = value
    end
    TelevisionsLocal[index].coords = coords
    return index
end

function PauseVideo()
    if duiObj then
        SendDuiMouseMove(duiObj, 30, 700)
        Wait(5)
        SendDuiMouseDown(duiObj, 'left')
        Wait(7)
        SendDuiMouseUp(duiObj, 'left')

        SendDuiMouseMove(duiObj, 30, 500)
    end
end

RegisterNetEvent("core:tv:event", function(data, index, key, value) 
    Televisions = data
    local data = Televisions[index]
    local screen = CURRENT_SCREEN
    if (screen and #(v3(screen.coords) - v3(data.coords)) < 0.001) then 
        local index, data = GetTelevision(screen.coords)
        if (index) then 
            local event = value
            if (event.type == "play") then 
                local data = { url = event.url }
                if (event.channel) then
                    data = Channels[event.channel]
                    data.channel = event.channel
                end
                HideScreen()
                PlayVideo(data)
            elseif (event.type == "stop") then 
                HideScreen()
            elseif (event.type == "pause") then 
                PauseVideo()
            elseif (event.type == "browser") then 
                PlayBrowser({ url = event.url })
            end 
        end
    end
    SetTelevisionLocal(Televisions[index].coords, "start_time", GetGameTimer())
end)

RegisterNetEvent("core:tv:broadcast", function(data, index)
    Channels = data
    if getDuiURL() == DEFAULT_URL then 
        local screen = CURRENT_SCREEN
        local tvObj = screen.entity
        local _, status = GetTelevision(screen.coords)
        if (status and status.channel == index and data[index] == nil) then 
            ResetDisplay()
            Citizen.Wait(10)
        end
        SendDuiMessage(duiObj, json.encode({
            showNotification = true,
            channel = index,
            data = data[index]
        }))
    end
end)

RegisterCommand('tv', function()
    if p:getSubscription() > 0 then
        OpenTVMenu() 
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous devez avoir le premium pour pouvoir faire cette commande !"
        })
    end
end)

RegisterCommand("broadcast", function(source, args, raw)
    BroadcastMenu()
end)