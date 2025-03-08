CarWash = {
    CanWash = true,
    Lang = "fr",

    Zones = {
        {
            pos = vector3(-3.976, -1392.261, 29.304), 
            heading = 92.158, 
            startPos = vector3(49.190, -1392.024, 28.420), 
            endPos = vector3(-3.804, -1391.698, 28.302),
            wait = 5, -- (seconds)

            particlesStart = {
                -- Premier rouleau (droite)
                {pos = vector3(37.440, -1390.143, 29.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
                {pos = vector3(37.440, -1390.143, 30.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
                
                -- Premier rouleau (gauche)
                {pos = vector3(37.430, -1393.497, 29.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 0},
                {pos = vector3(37.430, -1393.497, 30.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 7000},

                -- Dernier rouleau (droite)
                {pos = vector3(14.305, -1390.107, 29.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},
                {pos = vector3(14.305, -1390.107, 30.500), particle = "ent_amb_car_wash_jet", xRot = 90.0, nextWait = 0},

                -- Dernier rouleau (gauche)
                {pos = vector3(14.213, -1393.546, 29.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 0},
                {pos = vector3(14.213, -1393.546, 30.500), particle = "ent_amb_car_wash_jet", xRot = -90.0, nextWait = 0}
            }
        },
        {
            pos = vector3(-699.77, -924.21, 19.01), 
            heading = 1.16, 
            startPos = vector3(-699.86, -941.89, 18.16), 
            endPos = vector3(-699.77, -924.21, 19.01),
            wait = 3, -- (seconds)

            particlesStart = {
                -- Premier rouleau (droite)
                {pos = vector3(-697.77, -938.67, 20.01), particle = "ent_amb_car_wash_jet", xRot = 90.0, yRot = -135.0, nextWait = 0},
                {pos = vector3(-697.77, -938.67, 19.01), particle = "ent_amb_car_wash_jet", xRot = 90.0, yRot = -135.0, nextWait = 0},
                
                -- Premier rouleau (gauche)
                {pos = vector3(-702.12, -938.76, 18.90), particle = "ent_amb_car_wash_jet", xRot = -90.0, yRot = 135.0, nextWait = 0},
                {pos = vector3(-702.12, -938.76, 19.90), particle = "ent_amb_car_wash_jet", xRot = -90.0, yRot = 135.0, nextWait = 2200},

                -- Dernier rouleau (droite)
                {pos = vector3(-697.77, -927.54, 18.80), particle = "ent_amb_car_wash_jet", xRot = 90.0, yRot = -135.0, nextWait = 0},
                {pos = vector3(-697.77, -927.54, 19.80), particle = "ent_amb_car_wash_jet", xRot = 90.0, yRot = -135.0, nextWait = 0},

                -- Dernier rouleau (gauche)
                {pos = vector3(-702.11, -927.65, 18.80), particle = "ent_amb_car_wash_jet", xRot = 90.0, yRot = 135.0, nextWait = 0},
                {pos = vector3(-702.11, -927.65, 19.80), particle = "ent_amb_car_wash_jet", xRot = 90.0, yRot = 135.0, nextWait = 0}
            }
        }
    },

    MarkerType = 2,

    Labels = {
        ["carwash_help"] = "CWASH_RIDEHLP",
        ["car_broke"] = "CWASH_CARBROKE"
    },

    DisplayHelp = true,
    MaximalBodyHealth = 800.0,
    CarWashPrice = 50,
    CreatedParticles = {}
}

AddEventHandler("debug", function()
    EnableAllControlActions(0)
    EnableAllControlActions(1)
    StopParticleFxLooped(MyParticleCarwash, 0)
    RemoveParticleFx(MyParticleCarwash, 0)
    MyParticleCarwash = nil
    DeleteObject(objWaterPipeCar)
end)

CreateThread(function()
    CarWash:StartMainLoop()
end)

local lasti = 1
function CarWash:StartMainLoop()
    while true do
        Wait(1)
        local plyPed = PlayerPedId()
        if IsPedInAnyVehicle(plyPed, false) then
            for i = 1, #self.Zones do
                local plyPos = GetEntityCoords(plyPed)
                local carWashPos = self.Zones[i].startPos
                local distance = self.GetDistance(plyPos, carWashPos)
                if (distance < 3.5 and IsPedInAnyVehicle(plyPed, false)) and self.CanWash then
                    lasti = i
                    Bulle.create("carwash", GetEntityCoords(GetVehiclePedIsIn(p:ped())) + vector3(0.0, 0.0, 1.3),"bulleCarwash",true)
                    if IsControlJustPressed(0, 38) then
                        if p:haveItemWithCount("money", self.CarWashPrice) then
                            if p:pay(self.CarWashPrice) then 
                                if self.CanWash then
                                    if Bulle.exists("carwash") then
                                        Bulle.hide("carwash")
                                        Bulle.remove("carwash")
                                    end
                                    self:StartCarWash(self.Zones[i])
                                    self.CanWash = false
                                    return
                                end
                            end
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "~c Vous n'avez ~s pas assez d'argent"
                            })
                        end
                    end
                else
                    if lasti == i then
                        if Bulle.exists("carwash") then
                            Bulle.hide("carwash")
                            Bulle.remove("carwash")
                        end
                    end
                end
            end
        else
            Wait(2000)
        end
    end
end

function CarWash:ShowHelp(label, addNumber)
    if self.DisplayHelp then
        BeginTextCommandDisplayHelp(label)

        if (addNumber) then 
            AddTextComponentInteger(addNumber)
        end

        EndTextCommandDisplayHelp(0, false, false, -1)
    end
end

function CarWash.ShowNotification(text, begin)
    BeginTextCommandThefeedPost(begin or "STRING")

    if (text) then 
        AddTextComponentSubstringPlayerName(text) 
    end

    EndTextCommandThefeedPostTicker(true, true)
end

function CarWash.GetDistance(coords1, coords2)
    return #(coords1 - coords2)
end

function CarWash.CreateBlip(label, sprite, pos, scale, color)
    local blip = AddBlipForCoord(pos)

	SetBlipSprite (blip, sprite)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, (scale or 1.0))
	SetBlipColour (blip, (color or 4))
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(label)
	EndTextCommandSetBlipName(blip)
end

function CarWash.ShowLoadingPrompt(msg, type)
	BeginTextCommandBusyspinnerOn("STRING")
	AddTextComponentSubstringPlayerName(msg)
    EndTextCommandBusyspinnerOn(type)
end

function CarWash:StartWashParticle(actualZone)
    local asset = "scr_carwash"
    
    for i = 1, #actualZone.particlesStart do
        local currentParticle = actualZone.particlesStart[i]

        RequestNamedPtfxAsset(asset)
        UseParticleFxAssetNextCall(asset)

        while not HasNamedPtfxAssetLoaded(asset) do
            Wait(100)
        end
        
        actualZone.particlesStart[i].createdParticle = StartParticleFxLoopedAtCoord(currentParticle.particle, currentParticle.pos, currentParticle.xRot, currentParticle.yRot or 0.0, 0.0, 1.0, 0, 0, 0)
        
        if (currentParticle.nextWait > 0) then 
            Wait(currentParticle.nextWait)
        end
    end
end

function CarWash:StopAllParticles(actualZone)
    for i = 1, #actualZone.particlesStart do
        local particle = actualZone.particlesStart[i].createdParticle

        StopParticleFxLooped(particle, 0)
        RemoveParticleFx(particle, 0)

        actualZone.particlesStart[i].createdParticle = nil
    end
end

function CarWash:StartCarWash(actualZone)
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    if DoesEntityExist(plyVeh) then
        local bodyHealth = GetVehicleBodyHealth(plyVeh)
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
        local boneIndex = GetEntityBoneIndexByName(plyVeh, "chassis")

        if (bodyHealth > self.MaximalBodyHealth) then
            self.DisplayHelp = false
            SetEntityCoordsNoOffset(plyVeh, actualZone.startPos, false, false, false)
            SetEntityHeading(plyVeh, actualZone.heading)
            SetCurrentPedWeapon(plyPed, GetHashKey("WEAPON_UNARMED"), true)
            SetEveryoneIgnorePlayer(plyPed, true)
            SetPlayerControl(plyPed, false)
            Wait(250)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, 1, 0)
            SetCamFov(cam, 40.0)
            ShakeCam(cam, "HAND_SHAKE", 3.0)
            AttachCamToVehicleBone(cam, plyVeh, boneIndex, true, 0.0, 0.0, 0.0, 0.0, -8.0, 1.0, true)
            TaskVehicleDriveToCoord(plyPed, plyVeh, actualZone.endPos, 5.0, 0.0, GetEntityModel(plyVeh), 262144, 1.0, 1000.0)

            self.ShowLoadingPrompt("Lavage du véhicule ...", 1)
            self:StartWashParticle(actualZone)

            if BusyspinnerIsOn() then 
                BusyspinnerOff() 
            end

            DisplayHud(true)
          --  DisplayRadar(true)

            SetVehicleDirtLevel(plyVeh, 0.0)
            SetEveryoneIgnorePlayer(plyPed, false)
            SetPlayerControl(plyPed, true)

            SetCamActive(cam, false)
            RenderScriptCams(false, true, 2000, 0, 0)

            self.CanWash = true
            self.DisplayHelp = true
            
            Wait((actualZone.wait * 1000))

            self:StopAllParticles(actualZone)
            self:StartMainLoop()
        else
            self.ShowNotification(nil, self.Labels["car_broke"])
        end
    end
end