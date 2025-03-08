local isInTutorial = false

RegisterNUICallback("disableFocus", function(data, cb)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(500)
    cb("ok")
end)

RegisterNUICallback("startTuto", function(data, cb)
    isInTutorial = true
    cb("ok")
end)

function OpenTutorialForm()
    TriggerScreenblurFadeIn(500)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openForm" })
end

function GoToSpecialStep(step)
    SendNUIMessage({ action = "openStep", step = step })
end

function OpenStepCustom(title, desc)
    SendNUIMessage({ action = "openStepCustom", title = title, desc = desc })
end

function HideStep()
    SendNUIMessage({ action = "hideStep" })
end

RegisterKeyMapping('hidestepnotif', 'Cacher les notifications', 'keyboard', 'i')

RegisterCommand('hidestepnotif', function()
    SendNUIMessage({ action = "hideNotif" })    
end)

function GotoStep(step)
    if isInTutorial then
        SendNUIMessage({ action = "gotoStep", step = step })
        if step == 2 then
            -- waypoint to dmv school
            SetNewWaypoint(231.6, 363.7)
        elseif step == 3 then
            -- waypoint to vespucci police station
            SetNewWaypoint(-1112.5, -824.2)
        elseif step == 4 then
            -- waypoint to binco
            SetNewWaypoint(-826.2, -1078.0)
        elseif step == 5 then
            -- waypoint to ltd
            SetNewWaypoint(-711.7, -917.1)
        elseif step == 6 then
            -- waypoint to job center
            SetNewWaypoint(-268.6, -956.9)
        end
    end
end

exports("OpenTutorialForm", OpenTutorialForm)
exports("GotoStep", GotoStep)
exports("GoToSpecialStep", GoToSpecialStep)
exports("HideStep", HideStep)
exports("OpenStepCustom", OpenStepCustom)