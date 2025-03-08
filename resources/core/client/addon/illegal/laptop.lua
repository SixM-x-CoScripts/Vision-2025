local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local UsingComputer = false
function setUsingComputer(bool)
    UsingComputer = bool
end

RemoveFleecaBulle = false

local XPMultiplication = 1

RegisterNetEvent("core:UseLaptop", function()
    if UsingComputer then
        return
    end
    UsingComputer = true
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    local isInSouth = coordsIsInSouth(plyPos)
    local policeMans = nil
    if isInSouth then
        policeMans = GlobalState['serviceCount_lspd'] or 0
    else
        policeMans = GlobalState['serviceCount_lssd'] or 0
    end

    local bracage = GetVariable("heist")
    if #(plyPos - vec3(11.095767974854, -664.18542480469, 32.448928833008)) <= 5.0 then -- BRINKS
        if bracage.brinks.active == "true" then
            if CanAccessAction('Brinks') then
                if policeMans >= bracage.brinks.cops then
                    TriggerSecurEvent("core:crew:updateXp", token, bracage.brinks.xp, "add", p:getCrew(), "brinks")
                    startHackingBrinks()
                    return
                else
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        content = "Ton ordinateur n'a ~s plus de batterie"
                    })
                end
            else
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "Vous n'avez pas acces à cette action"
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Ton ordinateur n'a ~s plus de batterie"
            })
        end
    elseif #(plyPos - vec3(494.81155395508, -563.11547851563, 23.652143478394)) <= 5.0 then -- TRAIN 6 police
        if bracage.brinks.active == "true" then
            if policeMans >= bracage.train.cops then
                TriggerSecurEvent("core:crew:updateXp", token, bracage.train.xp, "add", p:getCrew(), "train")
                startHackingTrain()
                return
            else
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "Ton ordinateur n'a ~s plus de batterie"
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Ton ordinateur n'a ~s plus de batterie"
            })
        end
    else
        if CanAccessAction('Fleeca') then
            for k, v in pairs(Fleeca) do
                if #(plyPos - v.door[1].pos.xyz) <= 3.5 then
                    local copsneeded = bracage and bracage.fleeca.cops or 2
                    if tonumber(policeMans) >= tonumber(copsneeded) then
                                
                        if not coordsIsInSouth(p:pos()) then
                            XPMultiplication = bracage.fleeca.XPNorthMultiplication
                        end

                        TriggerSecurEvent("core:crew:updateXp", token, tonumber(bracage.fleeca.xp)*tonumber(XPMultiplication) or 10000, "add", p:getCrew(), "fleeca")
                        AnimationHackingOpenDoor(v, k)
                        return
                    else
                        exports['vNotif']:createNotification({
                            type = 'JAUNE',
                            content = "Ton ordinateur n'a ~s plus de batterie"
                        })
                    end
                end
            end
        else
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "Vous n'avez pas acces à cette action"
            })
        end
    end
    UsingComputer = false
end)

local foundClosest = false
hasBraquerVangelico = false
CreateThread(function()
    if not DlcIllegal then return end
    while not p do Wait(1) end
    while true do 
        Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 11.095767974854, -664.18542480469, 32.448928833008) < 5.0 then 
            foundClosest = true
            --print("1")
            if p:haveItem("laptop") and not InsideBracoBrinks then 
                --print("have")
                if CanAccessAction('Brinks') then
                    Bulle.create("laptopbrinks", vector3(11.095767974854, -664.18542480469, 32.448928833008+1.0), "bulleHacker", true)
                    if IsControlJustPressed(0, 38) then 
                        startHackingBrinks()
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'JAUNE',
                        content = "Vous n'avez pas acces à cette action"
                    })
                end
            else
                Bulle.remove("laptopbrinks")
                Wait(1200)
            end
        else
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -630.84014892578, -229.67807006836, 38.057033538818) < 15.0 then
                foundClosest = true
                if p:haveItem("laptop") then 
                    if not hasBraquerVangelico then
                        if CanAccessAction("Vangelico") then
                            Bulle.create("vangelico_heist", vector3(-630.84014892578, -229.67807006836, 38.057033538818), "bulleHacker", true)
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), -630.84014892578, -229.67807006836, 38.057033538818) < 2.5 then
                                if IsControlJustPressed(0, 38) then 
                                    StartVangelicoHeist()
                                end
                            end
                        else
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                content = "Vous n'avez pas acces à cette action"
                            })
                        end
                    end
                else
                    Bulle.remove("vangelico_heist")
                    Wait(1200)
                end
            else                
                Bulle.remove("vangelico_heist")
                Bulle.remove("laptopbrinks")
            end
        end      
        if p:haveItem("laptop") then  
            if GetDistanceBetweenCoords(-25.44, -1104.4, 26.27, GetEntityCoords(PlayerPedId())) < 5.0 then 
                foundClosest = true
                Bulle.create("concess_heist", vector3(-25.44, -1104.4, 27.27), "bulleHacker", true)
                if IsControlJustPressed(0, 38) then 
                    StartTrailerHeist()
                end
            end
            if GetDistanceBetweenCoords(2939.83, 4623.78, 48.72, GetEntityCoords(PlayerPedId())) < 5.0 then 
                foundClosest = true
                Bulle.create("train_heist", vector3(2939.83, 4623.78, 48.72), "bulleHacker", true)
                if IsControlJustPressed(0, 38) then 
                    StartTrainHeist()
                end
            end
            if CanAccessAction('Fleeca') then
                for k, v in pairs(Fleeca) do
                    if #(GetEntityCoords(PlayerPedId()) - v.door[1].pos.xyz) <= 4.5 then
                        foundClosest = true
                        if not RemoveFleecaBulle then
                            Bulle.create("fleecaHack", vector3(v.door[1].pos.xyz) + vector3(0.0, 0.0, 0.9), "bulleHacker", true)
                        end
                        if #(GetEntityCoords(PlayerPedId()) - v.door[1].pos.xyz) <= 2.5 then
                            if IsControlJustPressed(0, 38) then 
                                AnimationHackingOpenDoor(v,k)
                            end
                        end
                    end
                end
            else
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "Vous n'avez pas acces à cette action"
                })
            end
        end
        if not foundClosest then 
            Wait(2000)
        end
    end
end)

function StartTrailerHeist()
    local policeMans = tonumber(getNumberOfCopsInDuty())
    if policeMans >= 2 then
        if p:haveItem("laptop") then
            Bulle.hide("concess_heist")
            local bool = HackAnimation()
            while bool == nil do 
                Wait(1)
            end
            if bool == true then
                OpenTutoFAInfo("Braquage véhicules", "Un point GPS va être placé, vas voler les véhicules !")
                TriggerServerEvent("core:events:trailer:cl:start", p:getCrewType())
                Bulle.hide("concess_heist")
                CreateThread(function()
                    Wait(30000)
                    exports['tuto-fa']:HideStep()
                end)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Réessaye !"
                })
            end
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas d'ordinateur"
            })
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Reviens plus tard ! (Il faut 2 policier en service)"
        })
    end
end