-- GetVehicleHandlingFloat(vehicle.Handle, "CHandlingData", "fPetrolTankVolume")

local token = false
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local isInVeh = false
local config = {
    pos = {
        vector3(264.71890258789, -1259.2796630859, 29.142892837524),
        vector3(-72.567558288574, -1759.4125976562, 31.696844100952),
        vector3(819.32482910156, -1028.6318359375, 29.129278182983),
        vector3(-723.24951171875, -936.82580566406, 23.349870681763),
        vector3(-2097.2104492188, -319.20663452148, 16.119041442871),
        vector3(-2556.3415527344, 2333.9982910156, 38.127464294434),
        vector3(2680.3029785156, 3265.1865234375, 57.496898651123),
        vector3(180.00204467773, 6600.2416992188, 36.713390350342),
    },
}

local electricCar = {
    "Neon"
}

Citizen.CreateThread(function()
    while p == nil do Wait(1) end
    DecorRegister("FUEL_LEVEL", 1)
    -- for k, v in pairs(config.pos) do
    --     local blip = AddBlipForCoord(v)

    --     SetBlipSprite(blip, 361)
    --     SetBlipColour(blip, 55)
    --     SetBlipAsShortRange(blip, true)
    --     SetBlipScale(blip, 0.75)

    --     BeginTextCommandSetBlipName('STRING')
    --     AddTextComponentSubstringPlayerName("Station à essence")
    --     EndTextCommandSetBlipName(blip)
    -- end
    while true do
        local pPed = PlayerPedId()
        isInVeh = false
        if IsPedInAnyVehicle(pPed, false) then
            local pVeh = GetVehiclePedIsIn(pPed, false)
            local vFuel = GetVehicleFuelLevel(pVeh)
            if DecorExistOn(pVeh, "FUEL_LEVEL") then
                vFuel = DecorGetFloat(pVeh, "FUEL_LEVEL")
            end
            local vSpeed = GetEntitySpeed(pVeh) * 3.6
            local pSeat = GetPedInVehicleSeat(pVeh, -1)

            if pSeat == pPed then
                if GetVehicleClass(pVeh) == 14 then
                    SetVehicleFuelLevel(pVeh, 90.0)
                    DecorSetFloat(pVeh, "FUEL_LEVEL", GetVehicleFuelLevel(pVeh))
                else
                    isInVeh = true
                    for k, v in pairs(electricCar) do
                        if GetVehicleHandlingFloat(GetVehiclePedIsIn(pPed, false), "CHandlingData", "fPetrolTankVolume")
                            >
                            0.0 and GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(p:currentVeh()))) ~= v then
                            if vSpeed > 5.0 then

                                if vSpeed < 30.0 then
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.007)
                                elseif vSpeed < 60.0 then
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.01)
                                elseif vSpeed < 100.0 then
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.015)
                                elseif vSpeed < 140.0 then
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.04)
                                elseif vSpeed < 180.0 then
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.06)
                                elseif vSpeed < 230.0 then
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.08)
                                else
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.1)
                                end
                                if GetVehicleClass(pVeh) == 15 or GetVehicleClass(pVeh) == 16 then -- Avion et hélico
                                    SetVehicleFuelLevel(pVeh, vFuel - 0.125)
                                end
                            else
                                SetVehicleFuelLevel(pVeh, vFuel - 0.001)
                            end
                        end
                        DecorSetFloat(pVeh, "FUEL_LEVEL", GetVehicleFuelLevel(pVeh))
                    end
                end
            end
        else
            Wait(2000)
        end

        Wait(800*2)
    end
end)


local pump = {
    [GetHashKey("prop_gas_pump_1a")] = true,
    [GetHashKey("prop_gas_pump_1b")] = true,
    [GetHashKey("prop_gas_pump_1c")] = true,
    [GetHashKey("prop_gas_pump_1d")] = true,
    [GetHashKey("prop_gas_pump_old2")] = true,
    [GetHashKey("prop_gas_pump_old3")] = true,
    [GetHashKey("prop_vintage_pump")] = true,
}

local essence = false

Citizen.CreateThread(function()
    while p == nil do Wait(1) end
    local essence = false

    while true do
        local _, hash = GetCurrentPedWeapon(p:ped())
        local pCoords = p:pos()
        if hash == GetHashKey("weapon_petrolcan") and not p:isInVeh() then
            local vehicle, dst = GetClosestVehicle(pCoords)
            while dst <= 3.0 and not p:isInVeh() do
                pCoords = p:pos()
                vehicle, dst = GetClosestVehicle(pCoords)
                _, hash = GetCurrentPedWeapon(p:ped())
                local currentEssenceLevel = math.round(GetVehicleFuelLevel(vehicle), 0);
                --ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour mettre de l'essence", false);
                Bulle.create("essence", GetEntityCoords(PlayerPedId()) + vector3(0.0, 0.0, 1.3),"bulleEssence",true)
                if IsControlJustReleased(0, 38) then
                    Bulle.hide("essence")
                    Bulle.remove("essence")
                    Wait(350)
                    local pVeh = vehicle
                    local fuel = GetVehicleFuelLevel(pVeh)
                    for k, v in pairs(electricCar) do
                        if (GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume") - currentEssenceLevel
                            ) > 0.0 then
                            if GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ~= v then
                                essence = true

                                while essence and not p:isInVeh() do
                                    local vFuel = GetVehicleFuelLevel(pVeh)
                                    if vFuel >= fuel + 10 then
                                        essence = false
                                    else
                                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ stopper\nNiveau: ~o~" ..
                                            math.round((vFuel * 100 / (
                                                GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
                                                )), 1) .. "~s~%", false)
                                        SetVehicleFuelLevel(pVeh, vFuel + 0.02)
                                        DecorSetFloat(pVeh, "FUEL_LEVEL", GetVehicleFuelLevel(pVeh))
                                        if IsControlJustReleased(0, 38) then
                                            essence = false
                                        end
                                        if vFuel >=
                                            GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume") then
                                            SetVehicleFuelLevel(pVeh,
                                                GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume"))
                                            essence = false
                                        end
                                    end
                                    Wait(1)
                                end
                                for key, value in pairs(p:getInventaire()) do
                                    if value.name == "weapon_petrolcan" then
                                        TriggerServerEvent("core:RemoveItemToInventory", token, "weapon_petrolcan", 1,
                                            value.metadatas)
                                        SetCurrentPedWeapon(p:ped(), GetHashKey("WEAPON_UNARMED"), true)
                                    end
                                end
                                for key, value in pairs(Weapons) do
                                    if value.name == "weapon_petrolcan" then
                                        Weapons[key] = nil
                                    end
                                end
                            end
                        else
                            -- ShowNotification("Votre véhicule a le plein !")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Votre véhicule ~s a le plein !"
                            })

                        end
                    end
                end
                Wait(1)
            end
        end

        if isInVeh then
            local pPed = PlayerPedId()
            local pCoords = GetEntityCoords(pPed)
            local pump, dst, coords = GetNearestPump(pCoords)

            if pump ~= nil then
                if dst <= 5.0 then
                    local dst = GetDistanceBetweenCoords(coords, pCoords);

                    while dst <= 5.0 and isInVeh do
                        pCoords = GetEntityCoords(pPed)
                        dst = GetDistanceBetweenCoords(coords, pCoords)

                        local currentEssenceLevel = math.round(GetVehicleFuelLevel(GetVehiclePedIsIn(pPed, false)), 0);
                        --ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour mettre de l'essence", false);
                        Bulle.create("essence", GetEntityCoords(pump) + vector3(0.0, 0.0, 1.3),"bulleEssence",true)

                        local pumpCoords = GetEntityCoords(pump);

                        DrawLine(pCoords, vector3(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.5), 255, 255, 255, 170);

                        if IsControlJustReleased(0, 38) and not InsideJobCiterne then
                            Wait(350)
                            for k, v in pairs(electricCar) do
                                if GetVehicleHandlingFloat(GetVehiclePedIsIn(pPed, false), "CHandlingData",
                                    "fPetrolTankVolume") > 0.0 then
                                    if (
                                        GetVehicleHandlingFloat(GetVehiclePedIsIn(pPed, false), "CHandlingData",
                                            "fPetrolTankVolume") - currentEssenceLevel) > 0.0 then
                                        if GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(p:currentVeh())))
                                            ~= v then
                                                Bulle.hide("essence")
                                                Bulle.remove("essence")
                                            SendNuiMessage(json.encode({
                                                type = 'openWebview',
                                                name = 'fuelstation',
                                                data = {
                                                    maxFuel = GetVehicleHandlingFloat(GetVehiclePedIsIn(pPed, false),
                                                        "CHandlingData", "fPetrolTankVolume") - currentEssenceLevel,
                                                    literPrice = 2
                                                }
                                            }));
                                        end
                                    else
                                        -- ShowNotification("Votre véhicule a le plein !")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'JAUNE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "Votre véhicule ~s a le plein !"
                                        })

                                    end
                                else
                                    -- ShowNotification("Ce véhicule ne peut pas avoir d'essence")

                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "~s Ce véhicule ne peut pas avoir d'essence"
                                    })

                                end
                            end
                        end

                        Wait(1)
                    end
                    if Bulle.exists("essence") then
                        Bulle.hide("essence")
                        Bulle.remove("essence")
                    end
                else
                    if Bulle.exists("essence") then
                        Bulle.hide("essence")
                        Bulle.remove("essence")
                    end
                end
            else
                if Bulle.exists("essence") then
                    Bulle.hide("essence")
                    Bulle.remove("essence")
                end
            end
        end

        Wait(500)
    end
end)
-- GetVehicleHandlingFloat(GetVehiclePedIsIn(pPed, false), "CHandlingData", "fPetrolTankVolume")
function GetNearestPump(coords)
    local nearProp = nil
    local nearDst = 1000
    local nearCoords = vector3(0.0, 0.0, 0.0)

    for v in EnumerateObjects() do
        if pump[GetEntityModel(v)] ~= nil then
            local dst = GetDistanceBetweenCoords(coords, GetEntityCoords(v), true)
            if dst < nearDst then
                nearProp = v
                nearDst = dst
                nearCoords = GetEntityCoords(v)
            end
        end
    end

    return nearProp, nearDst, nearCoords
end

RegisterNUICallback('fuelstation__callback', function(data, cb)
    local essence = false
    local pVeh = GetVehiclePedIsIn(p:ped(), false)
    local fuel = GetVehicleFuelLevel(pVeh)
    if data.useCash then
        if not p:haveEnoughMoney(data.amount) then
            -- ShowNotification("~r~Vous n'avez pas assez d'argent.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })
        else
            essence = true
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))

            SetVehicleDoorsLocked(pVeh, 2)
            TaskLeaveAnyVehicle(p:ped(), 1, 1)
            essence = true

            while essence do
                local vFuel = GetVehicleFuelLevel(pVeh)
                if vFuel >=
                    fuel + data.amount then
                    essence = false
                else
                    ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ stopper\nNiveau: ~o~" ..
                        math.round((vFuel * 100 / (fuel + data.amount)), 1) .. "~s~%", false)
                    SetVehicleFuelLevel(pVeh, vFuel + 0.02)
                    DecorSetFloat(pVeh, "FUEL_LEVEL", GetVehicleFuelLevel(pVeh))
                    if IsControlJustReleased(0, 38) then
                        essence = false
                    end
                end
                Wait(1)
            end
            SetVehicleDoorsLocked(pVeh, 0)

            for k, v in pairs(p:getInventaire()) do
                if v.name == "money" then
                    TriggerServerEvent("core:RemoveItemToInventory", token, "money", math.round(data.amount * 2, 1),
                        v.metadatas)
                end
            end

            -- ShowNotification("Vous avez fini de mettre de l'essence.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s fini ~c de mettre de l'essence."
            })

        end

    else
        local amount = TriggerServerCallback("core:GetAccountMoneyFuel", token)

        if amount >= data.amount then
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))

            SetVehicleUndriveable(pVeh, 1)
            SetVehicleDoorsLocked(pVeh, 2)
            TaskLeaveAnyVehicle(p:ped(), 1, 1)
            essence = true

            while essence do
                local vFuel = GetVehicleFuelLevel(pVeh)
                if vFuel >=
                    fuel + data.amount then
                    essence = false
                else
                    ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ stopper\nNiveau: ~o~" ..
                        math.round((vFuel * 100 / (fuel + data.amount)), 1) .. "~s~%", false)
                    SetVehicleFuelLevel(pVeh, vFuel + 0.02)
                    DecorSetFloat(pVeh, "FUEL_LEVEL", GetVehicleFuelLevel(pVeh))
                    if IsControlJustReleased(0, 38) then
                        essence = false
                    end
                end
                Wait(1)
            end
            SetVehicleDoorsLocked(pVeh, 0)
            SetVehicleUndriveable(pVeh, 0)

            TriggerServerEvent("core:RemoveAccountMoneyFuel", token, math.round(data.amount * 2, 1))
            -- ShowNotification("Vous avez fini de mettre de l'essence")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez ~s fini ~c de mettre de l'essence."
            })

        else
            -- ShowNotification("~r~Vous n'avez pas assez d'argent.")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez ~s pas assez d'argent"
            })
        end
    end
end)
