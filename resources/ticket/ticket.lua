local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local TicketPrice = {
    Nothing = {
      chance = 50,
      message = '~c~Vous n\'avez rien gagné.~s~',
      price = {
        price_money = 0,
        item = {
          price_is_item = false,
          item_name = '',
          item_amount = 1
        }
      }
    },
    Common = {
      chance = 20,
      message = '~g~Vous avez gagné un nouveau ticket à gratter !',
      price = {
        price_money = 0,
        item = {
          price_is_item = true,
          item_name = 'ticket',
          item_amount = 1
        }
      }
    },
    Rare = {
      chance = 15,
      message = '~g~Vous avez gagné !~s~ Achetez-vous quelque chose de sympa d\'une valeur de ~g~250$~s~!',
      price = {
        price_money = 250,
        item = {
          price_is_item = false,
          item_name = '',
          item_amount = 1
        }
      }
    },
    Epic = {
      chance = 9,
      message = '~g~Vous avez gagné ! ~g~+750$~s~!',
      price = {
        price_money = 750,
        item = {
          price_is_item = false,
          item_name = '',
          item_amount = 1
        }
      }
    },
    Legendary = {
      chance = 1,
      message = 'Vous avez gagné ! ~g~+1000$~s~!',
      price = {
        price_money = 1000,
        item = {
          price_is_item = false,
          item_name = '',
          item_amount = 1
        }
      }
    }
}

local totalSumChance = 0

CreateThread(function()
    for _,priceInfo in pairs(TicketPrice) do
        totalSumChance = totalSumChance + priceInfo['chance']
    end 
end)

RegisterNetEvent("core:useTicketGratter", function()
    TriggerEvent("core:CloseInv")
    local randomNumber = math.random(1, totalSumChance)
    local add = 0
    while p == nil do 
        Wait(1)
    end
    if not IsPedInAnyVehicle(PlayerPedId()) then
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, true)
    end
    
    for key,priceInfo in pairs(TicketPrice) do
        local chance = priceInfo['chance']
        if randomNumber > add and randomNumber <= add + chance then
        local price_is_item = priceInfo['price']['item']['price_is_item']
        local amount = priceInfo['price']['item']['item_amount']
        local price_type, price = nil

        if not price_is_item then
            price = priceInfo['price']['price_money']
            price_type = 'money'
        else 
            price = priceInfo['price']['item']['item_name']
            price_type = 'item'
        end
        nuiOpenTicket(key, price, amount, price_type)
        return price
        end
        add = add + chance
    end
end)

RegisterNUICallback('deposit', function(data)
	checkWinTicket(data.key, data.price, data.amount, data.type)
end)

function checkWinTicket(key, price, amount, price_type)
    local priceAmount 
    local giveMoney = false
    local giveItem = false
    if type == 'money' then
        giveMoney = true
    else
        giveItem = true
    end
    for priceKey,priceInfo in pairs(TicketPrice) do
        if priceKey == key then
            priceAmount = priceInfo["price"]["item"]["item_amount"]
            -- ShowNotification(priceInfo['message'])

            -- New notif
            exports['vNotif']:createNotification({
              type = 'JAUNE',
              duration = 5, -- In seconds, default:  4
              content = "~s " .. priceInfo['message']
            })

            if type == 'item' and giveItem == true then
                if tonumber(amount) == priceAmount then
                    local item = priceInfo["price"]["item"]["item_name"]
                    TriggerSecurGiveEvent("core:addItemToInventory", token, item, priceAmount, {})
                end
            elseif type == 'money' and giveMoney == true then
                if tonumber(amount) == priceAmount then
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                end
            end
        end
    end
end

local inMenu = false

function nuiOpenTicket(key, price, amount, price_type)
    if inMenu then return end
    print(key, price, amount, price_type)
    SetNuiFocus(true, true)
    SendNUIMessage({
      type = 'openScratch',
      key = key,
      price = price,
      amount = amount,
      price_type = price_type,
      win_message = "Vous avez gagné",
      lose_message = "Vous avez perdu",
      currency = "$",
      scratchAmount = 85,
      resourceName = GetCurrentResourceName(),
    })
    --SendNUIMessage({
    --    type = 'openWebview',
    --    name = 'Scratch',
    --    data = {
    --        key = key,
    --        price = price,
    --        amount = amount,
    --       price_type = price_type,
    --        win_message = "Vous avez gagné",
    --        lose_message = "Vous avez perdu",
    --        currency = "$",
    --        scratchAmount = 85,
    --        resourceName = GetCurrentResourceName(),
    --    }
    --})
    inMenu = true
end

RegisterNUICallback('nuiCloseCard', function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeScratch'})
    --SendNUIMessage({
    --    type = "closeWebview",
    --    name = "Scratch"
    --})
    if IsPedUsingScenario(PlayerPedId(), "PROP_HUMAN_PARKING_METER") then
        ClearPedTasks(PlayerPedId())
    end
    inMenu = false
end)