Citizen.CreateThread(function()
    while true do
        Wait(10*60000) -- 10 minutes

        local playerPed = PlayerPedId()
        local isPlayerInDuty = TriggerServerCallback("core:isInDuty")

        if playerPed and isPlayerInDuty then
            local currentPos = GetEntityCoords(playerPed)

            if previousPos and currentPos == previousPos then
                TriggerServerEvent('core:DutyOff', p:getJob())
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    duration = 60,
                    content = "~s Vous êtes AFK, vous avez été retiré de votre service."
                })
            end

            previousPos = currentPos
        end

    end
end)