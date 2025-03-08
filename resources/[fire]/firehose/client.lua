ESX = nil
QBCore = nil

if Config.UseESX then
	Citizen.CreateThread(function()
		while not ESX do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(500)
		end
	end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
            --Gives The Player FireHose Perms
            TriggerEvent('fhose:canUseNozzles', true)
        else 
            --Remove The FireHose Perms
            TriggerEvent('fhose:canUseNozzles', false)
        end
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
            --Gives The Player FireHose Perms
            TriggerEvent('fhose:canUseNozzles', true)
        else
            --Remove The FireHose Perms
            TriggerEvent('fhose:canUseNozzles', false)
        end
    end)
elseif Config.UseQBUS then
    QBCore = exports['qb-core']:GetCoreObject()
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        local PlayerJob = QBCore.Functions.GetPlayerData().job
        if PlayerJob.name == Config.JobName then
            --Gives The Player FireHose Perms
            TriggerEvent('fhose:canUseNozzles', true)
        else
            --Remove The FireHose Perms
            TriggerEvent('fhose:canUseNozzles', false)
        end
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
        local PlayerJob = job
        if PlayerJob.name == Config.JobName then
            --Gives The Player FireHose Perms
            TriggerEvent('fhose:canUseNozzles', true)
        else
            --Remove The FireHose Perms
            TriggerEvent('fhose:canUseNozzles', false)
        end
    end)
else
    RegisterNetEvent('core:setJobPlayer')
    AddEventHandler('core:setJobPlayer', function(job, grade)
        for k, v in pairs(Config.Job) do
            if job == v then
                print("You are a firefighter")
                TriggerEvent('fhose:canUseNozzles', true)
                break
            end
        end
    end)

    AddEventHandler('core:PlayerLoaded', function()
        local PlayerJob = exports['core']:GetJobPlayer()
        if exports['core']:getPermission() >= 5 then
            TriggerEvent('fhose:canUseNozzles', true)
        else
            for k, v in pairs(Config.Job) do
                if PlayerJob == v then
                    print("You are a firefighter")
                    TriggerEvent('fhose:canUseNozzles', true)
                    break
                end
            end
        end
    end)
end

AddEventHandler('fhose:onPumpBreak', function()
    ShowNotification("~r~La lance est cassée !")
end)

AddEventHandler('fhose:requestEquipPump', function()
    if Config.UseESX then
        --You can do checks here for inventory or other stuff
        TriggerEvent("fhose:equipPump")
    elseif Config.UseQBUS then
        --You can do checks here for inventory or other stuff
        TriggerEvent("fhose:equipPump")
	else 
        TriggerEvent("fhose:equipPump")
    end
end)

AddEventHandler('fhose:playSplashParticle', function(pdict, pname, posx, posy, posz, heading)
	Citizen.CreateThread(function()
        UseParticleFxAssetNextCall(pdict)
        local pfx = StartParticleFxLoopedAtCoord(pname, posx, posy, posz, 0.0, 0.0, heading, 1.0, false, false, false, false)
        Citizen.Wait(200)
        StopParticleFxLooped(pfx, 0)
    end)
end)

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end