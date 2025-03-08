CasinoConfig = {}

CasinoConfig.ChipsPrice = 1

CasinoConfig.EnableVip = true

CasinoConfig.ExternalVip = true 
CasinoConfig.IsPlayerVIP = function(src)
    if src and GetPlayer(src) then
        return GetPlayer(src):getSubscription() > 0 
    else
        return false
    end
end

CasinoConfig.RemoveChips = function(source,amount)
    local goode = false
    for key, value in pairs(GetPlayer(source):getInventaire()) do
        if value.name == "casino_chips" then
            goode = RemoveItemToPlayer(source, "casino_chips", amount, value.metadatas)
            return goode
        end
    end
    
    -- Update Chips HUD
    if goode then
        TriggerClientEvent("casino:chipshud:remove", source, amount)
    end
    return goode
end

CasinoConfig.Car = {
    activate = true,
    carPos = {x=1099.7315673828, y=220.11318969727, z=-49.748649597168, h=252.1410369873},
    carHash = GetHashKey("neon"),
    ShouldTurn = false,
}

CasinoConfig.GiveChips = function(source,amount)
    -- FOR ESX
    --[[local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addInventoryItem("chips", amount)
        updatePlayerChips(source)
    end]]

    GiveItemToPlayer(source, "casino_chips", amount, {})
    updatePlayerChips(source)
    -- Update Chips HUD
    TriggerClientEvent("casino:chipshud:give", source, amount)
end

CasinoConfig.GetChipsCount = function(source)
    -- FOR ESX
    --[[local xPlayer = ESX.GetPlayerFromId(source)
    local coun = xPlayer.getInventoryItem("chips").count
    return coun]]

    return GetItemCount(source, "casino_chips")
end

CasinoConfig.SellChips = function(source, amount)
    local hasChips = false
    for key, value in pairs(GetPlayer(source):getInventaire()) do
        if value.name == "casino_chips" then
            hasChips = RemoveItemToPlayer(source, "casino_chips", amount, value.metadatas)
        end
    end
    if hasChips then 
        GiveItemToPlayer(source, "money", amount, {})
        -- Update Chips HUD
        TriggerClientEvent("casino:chipshud:remove", source, amount)
    end
end

CasinoConfig.CanBuyChips = function(source, amount)
    -- FOR ESX
    --[[local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getAccount('cash').money
    local bank = xPlayer.getAccount("bank").money
    local price = chips*CasinoConfig.ChipsPrice
    if money >= price then 
        xPlayer.removeAccountMoney("cash", price)
        xPlayer.addInventoryItem("chips", amount)
        return true
    else
        if bank >= price then 
            xPlayer.removeAccountMoney("bank", price)
            xPlayer.addInventoryItem("chips", amount)
            return true
        end
    end
    return false]]
    local good = false
    for key, value in pairs(GetPlayer(source):getInventaire()) do
        if RemoveItemToPlayer(source, "money", amount, value.metadatas) then 
            GiveItemToPlayer(source, "casino_chips", amount, {})
            good = true
            break
        end
        break
    end

    if good then
        TriggerClientEvent("swcasino:updatehud", source, GetItemCount(source, "casino_chips"))
    end

    return good
end

CasinoConfig.WinWheel = function(source, WinType)
    if WinType == "CHIPS 2500" then
        GiveItemToPlayer(source, "casino_chips", 2500, {})
        TriggerClientEvent('blackjack:notify', source, "Vous avez gagné 2500 jetons")
    elseif WinType == "DRINKS" then 
        GiveItemToPlayer(source, "soda", 1, {})
        Wait(750)
        GiveItemToPlayer(source, "ecola", 1, {})
        Wait(750)
        GiveItemToPlayer(source, "sprunk", 1, {})
        TriggerClientEvent('blackjack:notify', source, "Vous avez gagné 3 boissons !")
    elseif WinType == "MONEY 20000" then 
        GiveItemToPlayer(source, "casino_chips", 20000, {})
        TriggerClientEvent('blackjack:notify', source, "Vous avez gagné 20000 jetons")
    elseif WinType == "MONEY 30000" then 
        GiveItemToPlayer(source, "casino_chips", 30000, {})
        TriggerClientEvent('blackjack:notify', source, "Vous avez gagné 30000 jetons")
    elseif WinType == "MONEY 40000" then 
        GiveItemToPlayer(source, "casino_chips", 40000, {})
        TriggerClientEvent('blackjack:notify', source, "Vous avez gagné 40000 jetons")
    elseif WinType == "DISCOUNT LOGO" then 
        TriggerClientEvent('blackjack:notify', source, "Vous n'avez rien gagné")
    elseif WinType == "NOTHING" then
        TriggerClientEvent('blackjack:notify', source, "Vous n'avez rien gagné")
    elseif WinType == "CAR LOGO" then 
        BuyVehicleBoutique(source, "neon", 0, "casino")
    end
end

SW = {}
SW.ServerCallbacks = {}

SWTriggerServCallback = function(name, requestId, source, cb, ...)
	if SW.ServerCallbacks[name] then
		SW.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^6Flozii Handler^7] [^1ERROR^7] Server callback "%s" does not exist. Make sure that the server sided file really is loading, an error in that file might cause it to not load.'):format(name))
	end
end

SWRegisterServCallback = function(name, cb)
	SW.ServerCallbacks[name] = cb
end

RegisterServerEvent('border:triggerServerCallback')
AddEventHandler('border:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	SWTriggerServCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('border:serverCallback', playerId, requestId, ...)
	end, ...)
end)