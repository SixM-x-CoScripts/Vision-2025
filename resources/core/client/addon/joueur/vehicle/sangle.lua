local open = false
local main = RageUI.CreateMenu("Sangle", "Action disponible")
local attach = RageUI.CreateSubMenu(main, "Sangle", "Action disponible")

local posX = 0
local posY = 0
local posZ = 0
local rotX = 0
local rotY = 0
local rotZ = 0
main.Closed = function()
    open = false
    RageUI.Visible(main, false)
    RageUI.Visible(attach, false)
end


local inChoice = false
local firstVeh = nil
local secondVeh = nil
local deleteVeh = nil
local function StartChoiceDeleteCar(veh)
    deleteVeh = nil
    -- ShowNotification(
    --    "Appuyez sur ~g~E~s~ pour valider\nAppuyez sur ~b~L~s~ pour choisir le véhicule à détacher\nAppuyez sur ~r~X~s~ pour annuler")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K E pour ~s valider"
    })

    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K L pour ~s choisir le véhicule à détacher"
    })
        
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyez sur ~K X pour ~s annuler"
    })

    local timer = GetGameTimer() + 10000
    while inChoice do
        if next(veh) then
            SetEntityAlpha(veh[1], 50, false)
            local mCoors = GetEntityCoords(veh[1])
            DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255,
                255, 120, 0, 1, 2, 0, nil, nil, 0)
            if GetGameTimer() > timer then
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le délai est dépassé"
                })

                ResetEntityAlpha(veh[1])

                inChoice = false
                return
            elseif IsControlJustPressed(0, 51) then -- E
                deleteVeh = veh[1]
                inChoice = false
                ResetEntityAlpha(veh[1])
                return
            elseif IsControlJustPressed(0, 182) then -- L
                ResetEntityAlpha(veh[1])
                table.remove(veh, 1)

                if next(veh) then
                    timer = GetGameTimer() + 10000
                end
            elseif IsControlJustPressed(0, 73) then -- X
                -- ShowNotification("~r~Vous avez annulé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s annulé"
                })

                ResetEntityAlpha(veh[1])
                deleteVeh = nil
                inChoice = false
                return
            end
        else
            -- ShowNotification("~r~Il n'y a personne autour de vous")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Il n'y a personne autour de vous"
            })

            deleteVeh = nil
            inChoice = false
            return
        end
        Wait(0)
    end
end

local function StartChoicesecondCar(veh)
    secondVeh = nil
    -- ShowNotification(
    --    "Appuyez sur ~g~E~s~ pour valider\nAppuyez sur ~b~L~s~ pour choisir le second véhicule\nAppuyez sur ~r~X~s~ pour annuler")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K E pour ~s valider"
    })

    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K L pour ~s choisir le second véhicule"
    })
        
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyez sur ~K X pour ~s annuler"
    })

    local timer = GetGameTimer() + 10000
    while inChoice do
        if next(veh) then
            SetEntityAlpha(veh[1], 50, false)
            local mCoors = GetEntityCoords(veh[1])
            DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255,
                255, 120, 0, 1, 2, 0, nil, nil, 0)
            if GetGameTimer() > timer then
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le délai est dépassé"
                })

                ResetEntityAlpha(veh[1])

                inChoice = false
                return
            elseif IsControlJustPressed(0, 51) then -- E
                secondVeh = veh[1]
                inChoice = false
                ResetEntityAlpha(veh[1])
                return
            elseif IsControlJustPressed(0, 182) then -- L
                ResetEntityAlpha(veh[1])
                table.remove(veh, 1)

                if next(veh) then
                    timer = GetGameTimer() + 10000
                end
            elseif IsControlJustPressed(0, 73) then -- X
                -- ShowNotification("~r~Vous avez annulé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s annulé"
                })

                ResetEntityAlpha(veh[1])
                secondVeh = nil
                inChoice = false
                return
            end
        else
            -- ShowNotification("~r~Il n'y a personne autour de vous")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Il n'y a personne autour de vous"
            })

            secondVeh = nil
            inChoice = false
            return
        end
        Wait(0)
    end
end

local function StartChoiceFirstCar(veh)
    firstVeh = nil
    -- ShowNotification(
    --    "Appuyez sur ~g~E~s~ pour valider\nAppuyez sur ~b~L~s~ pour choisir le premier véhicule\nAppuyez sur ~r~X~s~ pour annuler")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K E pour ~s valider"
    })

    exports['vNotif']:createNotification({
        type = 'JAUNE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyer sur ~K L pour ~s choisir le premier véhicule"
    })
        
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        duration = 10, -- In seconds, default:  4
        content = "Appuyez sur ~K X pour ~s annuler"
    })
    
    local timer = GetGameTimer() + 10000
    while inChoice do
        if next(veh) then
            SetEntityAlpha(veh[1], 50, false)
            local mCoors = GetEntityCoords(veh[1])
            DrawMarker(20, mCoors.x, mCoors.y, mCoors.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255,
                255, 120, 0, 1, 2, 0, nil, nil, 0)
            if GetGameTimer() > timer then
                -- ShowNotification("~r~Le délai est dépassé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Le délai est dépassé"
                })

                ResetEntityAlpha(veh[1])

                inChoice = false
                return
            elseif IsControlJustPressed(0, 51) then -- E
                firstVeh = veh[1]
                inChoice = false
                ResetEntityAlpha(veh[1])
                return
            elseif IsControlJustPressed(0, 182) then -- L
                ResetEntityAlpha(veh[1])
                table.remove(veh, 1)

                if next(veh) then
                    timer = GetGameTimer() + 10000
                end
            elseif IsControlJustPressed(0, 73) then -- X
                -- ShowNotification("~r~Vous avez annulé")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez ~s annulé"
                })

                ResetEntityAlpha(veh[1])
                firstVeh = nil
                inChoice = false
                return
            end
        else
            -- ShowNotification("~r~Il n'y a personne autour de vous")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Il n'y a personne autour de vous"
            })
            
            firstVeh = nil
            inChoice = false
            return
        end
        Wait(0)
    end
end

RegisterNetEvent("core:UseSangleBiatch")
AddEventHandler("core:UseSangleBiatch", function()
    OpenPositionCar()
end, false)

function OpenPositionCar()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        posX = 0
        posY = 0
        posZ = 0
        rotX = 0
        rotY = 0
        rotZ = 0
        RageUI.Visible(main, true)
        local deleteTable = {}

        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("Detacher un véhicule", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            local veh = GetAllVehicleInArea(p:pos(), 10.0)
                            for key, value in pairs(veh) do
                                if GetEntityAttachedTo(value) ~= 0 then
                                    table.insert(deleteTable, value)
                                end
                            end
                            inChoice = true
                            StartChoiceDeleteCar(deleteTable)
                            while deleteVeh == nil do Wait(1) end
                            DetachEntity(deleteVeh)
                        end,
                    })
                    RageUI.Button("Attacher deux véhicules", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            inChoice = true
                            local veh = GetAllVehicleInArea(p:pos(), 10.0)
                            StartChoiceFirstCar(veh)
                            while firstVeh == nil do Wait(1) end
                            veh = GetAllVehicleInArea(p:pos(), 10.0)
                            for k, v in pairs(veh) do
                                if v == firstVeh then
                                    table.remove(veh, k)
                                end
                            end
                            inChoice = true
                            Wait(300)
                            StartChoicesecondCar(veh)
                            while secondVeh == nil do Wait(1) end
                            -- OpenPositionCar(firstVeh, secondVeh)
                        end,
                    }, attach)
                end)


                RageUI.IsVisible(attach, function()
                    AttachEntityToEntity(secondVeh, firstVeh, GetEntityBoneIndexByName(firstVeh, "platelight"), posX,
                        posY, posZ, rotX
                        ,
                        rotY, rotZ
                        , false, false, false, false, 0.0, true)
                    RageUI.Button("Valider", false, {}, true, {
                        onSelected = function()
                            open = false
                            RageUI.Visible(main, false)
                            RageUI.Visible(attach, false)
                            RageUI.CloseAll()
                        end,
                    })
                    RageUI.Button("Detacher/Annuler", false, {}, true, {
                        onSelected = function()
                            DetachEntity(firstVeh, true, true)
                            DetachEntity(secondVeh, true, true)
                        end,
                    })

                    RageUI.Button('posX: ' .. tostring(posX), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 174) then
                                posX = posX - 0.01

                            elseif IsControlPressed(0, 175) then
                                posX = posX + 0.01
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la position X")
                            posX = input
                        end
                    })

                    RageUI.Button('posY: ' .. tostring(posY), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 174) then
                                posY = posY - 0.01

                            elseif IsControlPressed(0, 175) then
                                posY = posY + 0.01
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la position Y")
                            posY = input
                        end
                    })

                    RageUI.Button('posZ: ' .. tostring(posZ), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 174) then
                                posZ = posZ - 0.01

                            elseif IsControlPressed(0, 175) then
                                posZ = posZ + 0.01
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la position Z")
                            posZ = input
                        end
                    })

                    RageUI.Button('rotX: ' .. tostring(rotX), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 174) then
                                rotX = rotX - 0.01

                            elseif IsControlPressed(0, 175) then
                                rotX = rotX + 0.01
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la rotation X")
                            rotX = input
                        end
                    })

                    RageUI.Button('rotY: ' .. tostring(rotY), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 174) then
                                rotY = rotY - 0.01

                            elseif IsControlPressed(0, 175) then
                                rotY = rotY + 0.01
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la rotation Y")
                            rotY = input
                        end
                    })

                    RageUI.Button('rotZ: ' .. tostring(rotZ), nil, {}, true, {
                        onActive = function()
                            if IsControlPressed(0, 174) then
                                rotZ = rotZ - 0.01

                            elseif IsControlPressed(0, 175) then
                                rotZ = rotZ + 0.01
                            end
                        end,
                        onSelected = function()
                            local input = KeyboardImput("Choisir la rotation Z")
                            rotZ = input
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end
