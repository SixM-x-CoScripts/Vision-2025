local fourriereOpen = false
local actuel = nil
local stock = nil
local amount = 100
local posVeh
local data_ui = {
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Fourriere/header.webp',
    headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/voiture-icon.webp',
    headerIconName = 'FOURRIERE',
    callbackName = 'fourriere_callback',
    showTurnAroundButtons = false,
    elements = {}
}

function OpenMenuFourriere(posSpawn, id)
    posVeh = posSpawn
    fourriereOpen = true
    data_ui.elements = {}
    stock = TriggerServerCallback("core:GetAllVehPounder", id, true)

    if json.encode(stock) ~= "[]" or crewStock ~= nil then
        if json.encode(stock) ~= "[]" then
            for k, v in pairs(stock) do
                if v.job ~= nil then 
                    cat = "Entreprise"
                elseif v.vente ~= nil then
                    cat = "Crew"
                else
                    cat = "Personnel"
                end
                if v.stored == 2 then
                    table.insert(data_ui.elements, {
                        id = k,
                        price = amount,
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Concessionnaire/Voiture/"..v.name..".webp",
                        name=v.name,
                        label=v.name.." "..v.currentPlate,
                        category= cat,
                    })
                end
            end
        end

        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'MenuCatalogueAchat',
            data = data_ui,
        }));
    else
        -- ShowNotification("Aucun véhicule dans la fourrière")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Aucun véhicule dans la fourrière"
        })

    end
end

local AntiSpam = 0
RegisterNUICallback("fourriere_callback", function(data, cb)
    if AntiSpam == 0 then
        if vehicle.IsSpawnPointClear(vector3(posVeh.x, posVeh.y, posVeh.z), 3.0) then
            AntiSpam = 1
            local vehprops = TriggerServerCallback("core:getVehProps", stock[data.id].currentPlate)
            local veh = vehicle.create(stock[data.id].name, posVeh, vehprops)
            TaskWarpPedIntoVehicle(p:ped(), veh, -1)
            TriggerServerEvent("core:SetVehicleOut", string.upper(vehicle.getPlate(veh)), VehToNet(veh), veh)
            SetVehicleFuelLevel(veh,
            GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume"))
            SendNuiMessage(json.encode({
                type = 'closeWebview'
            }))
            CreateThread(function()
                Wait(2000)
                AntiSpam = 0
            end)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Le véhicule ne peut pas sortir"
            })
        end
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Veuillez attendre"
        })
    end
end)