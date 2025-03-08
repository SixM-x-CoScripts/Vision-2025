-- Désactivation du Job Vespucci Bike

--[[ local used = false
local stock = {}

local function LoadStockFromFile() -- Allow dynamic load
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "server/addon/jobs/vespuccibike/stock.json")
    stock = json.decode(loadFile)


end

LoadStockFromFile()

local function RefreshStockFromFiles() -- Allow dynamic save
    SaveResourceFile(GetCurrentResourceName(), "server/addon/jobs/vespuccibike/stock.json", json.encode(stock), -1)
end

function RemoveVehicleToStock(data)
    if data == nil then return end

    for i = 1, #stock, 1 do
        if stock[i].name == data.name then
            table.remove(stock, i)
            RefreshStockFromFiles()
            LoadStockFromFile()
            return
        end
    end
end


function AddVehiculeToStockVespucciBick(data)
    if data == nil then return end
    table.insert(stock, { name = data.name, model = data.model, price = data.price })
    RefreshStockFromFiles()
    LoadStockFromFile()
end


CreateThread(function ()
    while RegisterServerCallback == nil do Wait(1) end
    RegisterServerCallback("core:VespucciBikeCatalogueState", function (source, state)
        used = state
        return used
    end)


    RegisterServerCallback("core:GestionVespucciBike", function (source, token)
        if CheckPlayerToken(source, token) then
            return stock
        end
    end)

    RegisterServerCallback("core:GetUsed", function (source)
        return used
    end)

    RegisterServerCallback("core:BuySKate", function (source, token, price)
        if CheckPlayerToken(source, token) then
            if RemoveMoneyToSociety(tonumber(price), 'concessvelo') then
                return true
            else

                --[[ Ancienne notification
                --TriggerClientEvent('core:ShowNotification', source,
                --    "Votre societé n'a pas assez d'argent pour acheter ce véhicule.")
                --
                    
                -- New notif
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Votre societé n'a pas assez d'argent pour acheter ce véhicule."
                })

                return false
            end
        else
            DropPlayer(source, "Nahhh bro nice try !")
            return false
        end
    end)
end)


RegisterNetEvent("core:VespucciBikeAddStock")
AddEventHandler("core:VespucciBikeAddStock", function (token, veh, price)

    if CheckPlayerToken(source, token) then
        if RemoveMoneyToSociety(tonumber(price), 'concessvelo') then
            AddVehiculeToStockVespucciBick(veh)
            Wait(100)
        else
            
            --[[ Ancienne notification
            -- TriggerClientEvent('core:ShowNotification', source,
            --    "Votre societé n'a pas assez d'argent pour acheter ce véhicule.")
            

            -- New notif
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Votre societé n'a pas assez d'argent pour acheter ce véhicule."
            })
        end
    else
        DropPlayer(source, "Nahhh bro nice try !")
    end
end)



function BuyBike(player, vehicle, crew, color)
    local model = vehicle
    local props = {}
    local plate = GenerateNotOwnedPlate()
    props.plate = plate
    if crew == "None" then
        crew = nil
    end
    MySQL.Async.execute("INSERT INTO vehicles (owner, plate, name, props, inventory, garage, vente) VALUES (@1, @2, @3, @4, @5, @6, @7)"
        , {
            ["1"] = Getplayer(player):getId(),
            ["2"] = props.plate,
            ["3"] = tostring(model),
            ["4"] = json.encode(props),
            ["5"] = json.encode({}),
            ["6"] = "central",
            ["7"] = crew,
        }, function(affectedRows)
        if affectedRows ~= 0 then
            GetPlayerVehicle(player, true)
            TriggerClientEvent('core:spawnBikecardealerSud', player, tostring(model), props.plate, color)
        else
            -- TriggerClientEvent('core:ShowNotification', player, "~r~Erreur lors de l'achat du véhicule")
            -- New notif
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Erreur lors de l'achat du véhicule"
            })
        end
    end)
end
RegisterNetEvent("core:assignBuyerToBike")
AddEventHandler("core:assignBuyerToBike", function(token, vehicle, buyer, crew, color)
    if CheckPlayerToken(source, token) then
        RemoveVehicleToStock(vehicle)

        BuyBike(buyer, vehicle.name, crew, color)
    else

    end
end) ]]