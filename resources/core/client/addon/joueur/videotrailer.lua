RegisterNetEvent('videoPlayer:playVideo')
AddEventHandler('videoPlayer:playVideo', function(url)
    local playerPed = PlayerPedId()
    if playerPed and playerPed ~= -1 then
        SendNUIMessage({
            type = "open",
            url = url
        })
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent('videoPlayer:closeVideo')
AddEventHandler('videoPlayer:closeVideo', function()
    SendNUIMessage({
        type = "close"
    })
    SetNuiFocus(false, false)
end)