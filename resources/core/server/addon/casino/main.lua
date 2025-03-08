GlobalState.CasinoOpen = false

local LOG = {
    TotalAchat = 0,
    TotalVente = 0,
}

CreateThread(function()
    Wait(5000)
    local veh = CreateVehicle(CasinoConfig.Car.carHash, CasinoConfig.Car.carPos.x, CasinoConfig.Car.carPos.y, CasinoConfig.Car.carPos.z, CasinoConfig.Car.carPos.h)
    SetVehicleDoorsLocked(veh, 2)
    while CasinoConfig.Car.ShouldTurn do 
        Wait(25)
        SetEntityHeading(veh, GetEntityHeading(veh)+0.5)
    end
end)

RegisterCommand("opencasino", function(source)
    if source == 0 or GetPlayer(source):getPermission() > 2 then 
        GlobalState.CasinoOpen = not GlobalState.CasinoOpen
        if source == 0 then 
            print(GlobalState.CasinoOpen == true and "Le casino est ouvert !" or "Le casino est fermé")
        else
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = GlobalState.CasinoOpen == true and "Le casino est ouvert !" or "Le casino est fermé"
            })
        end
    end
end)

local casinoPlayer = {}
function GetCasinoPlayers()
    local goodTable = {}
    for k,v in pairs(casinoPlayer) do 
        table.insert(goodTable, k)
    end
    return goodTable
end

RegisterNetEvent("sunwisecasino:status", function(typeEnt)
    local src = source
    if typeEnt == "enter" then 
        casinoPlayer[src] = true
    else
        casinoPlayer[src] = nil
    end
end)

RegisterNetEvent("core:logCasino", function(nbr, vente)
    local nbr = tonumber(nbr)
    if nbr and nbr > 0 then 
        if vente == "vente" then 
            LOG.TotalVente = LOG.TotalVente + nbr
        else
            LOG.TotalAchat = LOG.TotalAchat + nbr
        end
    end
end)

local sent = false
CreateThread(function()
    -- LOG a minuit pour envoyer le total d'achat et de vente de jetons du casino 
    while true do 
        Wait(40000)
        local time = os.date("*t")
        if time.hour == 0 then
            if not sent then
                SendDiscordLog("casino", "CONSOLE", "CONSOLE",
                    "LOG DU JOUR", "**Total des ventes de jetons** : " .. LOG.TotalVente .. "\n**Total des achats de jetons** : " .. LOG.TotalAchat)
                LOG.TotalAchat = 0
                LOG.TotalVente = 0
                sent = true
            end
        else
            sent = false
        end
    end
end)