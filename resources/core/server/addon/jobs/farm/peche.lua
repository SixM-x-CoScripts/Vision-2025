local limit = {}

local pricesPoisson = {
    ["merlan"] = 100,
    ["carpe"] = 40,
    ["bar"] = 40,
    ["saumon"] = 110,
    ["calamar"] = 170,
    
    ["requin"] = 500,
    ["dauphin"] = 400,
    ["orc"] = 500,
    ["raie"] = 300,
    ["Esturgeon"] = 300,
}

CreateThread(function()
    while not GetVariable("jobcenter") do 
        Wait(1000)
    end 
    funcVariablesPricesPeche()
end)

function funcVariablesPricesPeche()
    if GetVariable("jobcenter") then
        local peche = GetVariable("jobcenter").peche
        if tonumber(peche.prices.merlan) and tonumber(peche.prices.carpe) and tonumber(peche.prices.bar) and tonumber(peche.prices.saumon) and tonumber(peche.prices.calamar) and tonumber(peche.prices.requin) and tonumber(peche.prices.dauphin) and tonumber(peche.prices.orc) and tonumber(peche.prices.raie) and tonumber(peche.prices.Esturgeon) then
            pricesPoisson["merlan"] = tonumber(peche.prices.merlan)
            pricesPoisson["carpe"] = tonumber(peche.prices.carpe)
            pricesPoisson["bar"] = tonumber(peche.prices.bar)
            pricesPoisson["saumon"] = tonumber(peche.prices.saumon)
            pricesPoisson["calamar"] = tonumber(peche.prices.calamar)
            pricesPoisson["requin"] = tonumber(peche.prices.requin)
            pricesPoisson["dauphin"] = tonumber(peche.prices.dauphin)
            pricesPoisson["orc"] = tonumber(peche.prices.orc)
            pricesPoisson["raie"] = tonumber(peche.prices.raie)
            pricesPoisson["Esturgeon"] = tonumber(peche.prices.Esturgeon)
        end
    end
end

RegisterNetEvent("core:SellPecheur")
AddEventHandler("core:SellPecheur", function (token)
    local source = source
    local sold1 = false
    local price = 0
    local oldAmount = 0
    funcVariablesPricesPeche()
    for x,z in pairs(pricesPoisson) do 
        if GetItemCount(source, x) ~= 0 then
            oldAmount = GetItemCount(source, x)
            if RemoveItemFromInventory(source, x, GetItemCount(source, x), {}) then
                for key, value in pairs(GetPlayer(source):getInventaire()) do
                    if value.name == "money" then 
                        AddItemToInventory(source, "money", pricesPoisson[x]*oldAmount, {})
                        price = price + pricesPoisson[x]*oldAmount
                        sold1 = true
                    end
                end
                if not sold1 then
                    AddItemToInventory(source, "money", pricesPoisson[x]*oldAmount, {})
                    price = price + pricesPoisson[x]*oldAmount
                    sold1 = true
                end
            end
            oldAmount = 0
        end
    end
    Wait(250)
    if price ~= 0 then
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'DOLLAR',
            content = "Vous avez récupéré ~s" .. price .. "$"
        })
    end
end)

CreateThread(function ()
    while RegisterServerCallback == nil do Wait(0) end

    RegisterServerCallback("core:addJournalier", function (source)
        local id = GetPlayer(source):getId()
        if limit[id] == nil then
            limit[id] = 1
        else
            limit[id] = limit[id] + 1
        end
        return limit[id]
    end)
end)