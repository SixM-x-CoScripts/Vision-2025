local used = false
local stock = {}

local function LoadStockFromFile() -- Allow dynamic load
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "server/addon/jobs/concessEntreprise/stock.json")
    stock = json.decode(loadFile)


end

LoadStockFromFile()

local function RefreshStockFromFiles() -- Allow dynamic save
    SaveResourceFile(GetCurrentResourceName(), "server/addon/jobs/concessEntreprise/stock.json", json.encode(stock), -1)
end

local function RemoveVehicleToStock(data)
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


local function AddVehiculeToStockConcessEntreprise(data)
    if data == nil then return end
    table.insert(stock, { name = data.name, model = data.model, price = data.price , liveries = data.liveries})
    RefreshStockFromFiles()
    LoadStockFromFile()
end


CreateThread(function ()
    while RegisterServerCallback == nil do Wait(1) end
    RegisterServerCallback("core:EntrepriseCatalogueState", function (source, state)
        used = state
        return used
    end)


    RegisterServerCallback("core:GestionEntreprise", function (source, token)
        if CheckPlayerToken(source, token) then
            return stock
        end
    end)

    RegisterServerCallback("core:GetUsed", function (source)
        return used
    end)

    RegisterServerCallback("core:BuySKate", function (source, token, price)
        if CheckPlayerToken(source, token) then
            if RemoveMoneyToSociety(tonumber(price), 'cardealerSud') then
                return true
            else

                --[[TriggerClientEvent('core:ShowNotification', source,
                    "Votre societé n'a pas assez d'argent pour acheter ce véhicule.")]]
                TriggerClientEvent("__atoshi::createNotification", source, {
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Votre societé n'a pas assez d'argent pour acheter ce véhicule"
                })
                return false
            end
        else
            DropPlayer(source, "Nahhh bro nice try !")
            return false
        end
    end)
end)


RegisterNetEvent("core:EntrepriseAddStock")
AddEventHandler("core:EntrepriseAddStock", function (token, veh, price)

    if CheckPlayerToken(source, token) then
        if RemoveMoneyToSociety(tonumber(price), 'cardealerSud') then
            AddVehiculeToStockConcessEntreprise(veh)
            Wait(100)
        else
            --[[TriggerClientEvent('core:ShowNotification', source,
                "Votre societé n'a pas assez d'argent pour acheter ce véhicule.")]]
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Votre societé n'a pas assez d'argent pour acheter ce véhicule"
            })
        end
    else
        DropPlayer(source, "Nahhh bro nice try !")
    end
end)



function BuyEntreprise(player, vehicle, crew, color, liveries, job)
    local model = vehicle
    local props = {}
    local plate = GenerateNotOwnedPlate()
    props.plate = plate
    props.modLivery = liveries
    local owner = Getplayer(player):getId()
    if crew == "None" then
        crew = nil
    end
    if job == "aucun" then
        job = nil
    end
    -- if job ~= nil and crew == nil then
    --     owner = job
    -- end
    -- if crew ~= nil and job == nil then 
    --     owner = crew
    -- end
    MySQL.Async.execute("INSERT INTO vehicles (owner, plate, name, props, inventory, garage, vente, job) VALUES (@1, @2, @3, @4, @5, @6, @7, @8)"
        , {
            ["1"] = owner,
            ["2"] = props.plate,
            ["3"] = tostring(model),
            ["4"] = json.encode(props),
            ["5"] = json.encode({}),
            ["6"] = "central",
            ["7"] = crew,
            ["8"] = job,
        }, function(affectedRows)
        if affectedRows ~= 0 then
            GetPlayerVehicle(player, true)
            TriggerClientEvent('core:spawnEntreprisecardealerSud', player, tostring(model), props.plate, color, props.modLivery)

			local vehName = TriggerClientCallback(source, "core:getVehicleNameFromModel", model)

			if vehName ~= "NULL" then
				local params = {
					plate = props.plate,
					model = vehName,
				}

				exports['knid-mdt']:api().people.vehicles.create(owner, params,
					function(cb)
						if cb == 201 then
							print("^2[" .. cb .. "]^0 MDT: (BUY ENTREPRISE) Vehicle created : ^6", owner, json.encode(params), "^0")
						else
							print("^8[" .. cb .. "]^0 MDT: (BUY ENTREPRISE) Error creating vehicle : ^6", owner, json.encode(params), "^0")
						end
					end)
			end
        else
            --[[TriggerClientEvent('core:ShowNotification', player, "~r~Erreur lors de l'achat du véhicule")]]
            TriggerClientEvent("__atoshi::createNotification", player, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Erreur lors de l'achat du véhicule"
            })
        end
    end)
end
RegisterNetEvent("core:assignBuyerToEntreprise")
AddEventHandler("core:assignBuyerToEntreprise", function(token, vehicle, buyer, crew, color, liveries, job)
    if CheckPlayerToken(source, token) then
        RemoveVehicleToStock(vehicle)

        BuyEntreprise(buyer, vehicle.model, crew, color, liveries, job)
    else

    end
end)