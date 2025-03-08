CreateThread(function()
    while RegisterServerCallback == nil do
        Wait(1)
    end

    RegisterServerCallback("core:ChangePropertyCar", function(source, token, plate, model, props, id, crew)
        if CheckPlayerToken(source, token) then
            if plate ~= nil then
                local vente = nil
                local job = nil
                local owner = GetPlayer(id):getId()
                local action = "changement vehicule particulier"
                if crew == "job" then
                    --vente = GetPlayer(id):getJob()
                    job = GetPlayer(id):getJob()
                    --owner = GetPlayer(id):getJob()
                    action = "changement vehicule job " .. job
                elseif crew == 'crew' then
                    vente = GetPlayer(id):getCrew()
                    --owner = GetPlayer(id):getCrew()
                    action = "changement vehicule crew " .. vente
                end
                local veh = GetVehicle(plate)
                if veh ~= nil then
                    veh:changeOwner(owner, vente, job)
                    TriggerClientEvent("__atoshi::createNotification", id, {
                        type = 'JAUNE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous êtes le nouveau propriétaire du véhicule immatriculé [ ~s " .. plate .. " ~c ]"
                    })

                    SendDiscordLog("pawnshop", source, string.sub(GetDiscord(source), 9, -1), GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(),
                        id, string.sub(GetDiscord(id), 9, -1), GetPlayer(id):getLastname() .. " " .. GetPlayer(id):getFirstname(),
                        action, plate, veh:getOwner())
                else
                    TriggerClientEvent("__atoshi::createNotification", id, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "erreur avec le véhicule immatriculé [ ~s " .. plate .. " ~c ]"
                    })
                end
                return true
            end
            return false
        else
            --TODO: AC Detection
        end
    end)

    RegisterServerCallback("core:CasseDeleteVeh", function(source, token, plate)
        if CheckPlayerToken(source, token) then
            local index = GetVehicleIndexFromPlate(plate)
            local type = nil
            if index ~= 0 then
                -- véhicule joueur
                if vehicles[index][plate] ~= nil then
                    vehicles[index][plate] = nil
                    MarkVehicleAsNotSaved(index, plate)
                    type = "joueur"
                    return type
                end
            else
                -- Véhicule volé
                type = "volé"
                return type
            end
        else
            return nil
        end
    end)

    RegisterServerCallback("core:AddCoOwners", function(source, token, plate, id)
        if CheckPlayerToken(source, token) then
            local veh = GetVehicle(plate)
            if veh ~= nil then
                veh:AddCoowner(GetPlayer(id):getId())
                return true
            end
            return false
        else
            --TODO: AC Detection
        end
    end)

    RegisterServerCallback("core:AcceptChangeCar", function(source, token, plate)
        if CheckPlayerToken(source, token) then
            local index = GetVehicleIndexFromPlate(plate)
            -- print(index)
            if index ~= 0 then
                if vehicles[index][plate] ~= nil then
                    if vehicles[index][plate].vente == nil then
                        local player = GetPlayerById(vehicles[index][plate].owner);
                        if (player) then
                            return TriggerClientCallback(player.source, "core:AcceptChangeCar");
                        end
                    else
                        return true
                    end
                end
            end
            return false
        else
            --TODO: AC Detection
        end
    end)

    RegisterServerCallback("core:AcceptCasseCar", function(source, token, plate)
        if CheckPlayerToken(source, token) then
            local index = GetVehicleIndexFromPlate(plate)
            if index ~= 0 then
                if vehicles[index][plate] ~= nil then
                    -- si la voiture est vendue en individuel
                    if vehicles[index][plate].vente == nil then
                        local player = GetPlayerById(vehicles[index][plate].owner);
                        if (player) then
                            return TriggerClientCallback(player.source, "core:AcceptCasseCar");
                        end
                    else
                        -- si la voiture est vendue en groupe
                        return false
                    end
                end
            else
                -- si la voiture est volée
                return true
            end
            return false
        else
            --TODO: AC Detection
        end
    end)

    RegisterServerCallback("core:AddCoOwner", function(source, token, plate)
        if CheckPlayerToken(source, token) then
            local index = GetVehicleIndexFromPlate(plate)
            if index ~= 0 then
                if vehicles[index][plate] ~= nil then
                    if vehicles[index][plate].vente == nil then
                        local player = GetPlayerById(vehicles[index][plate].owner);
                        if (player) then
                            return TriggerClientCallback(player.source, "core:AddCoOwner");
                        end
                    else
                        return true
                    end
                end
            end
            return false
        else
            --TODO: AC Detection
        end
    end)
end)

RegisterNetEvent("core:casseLog")
AddEventHandler("core:casseLog", function(token, plate, model, price, type)
    SendDiscordLog("casse", source, string.sub(GetDiscord(source), 9, -1), GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), plate, model, price, type)
end)
