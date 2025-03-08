
function IsInLTDArea(coords) 
    -- boucler sur superette_epicerie pour voir si la distance en coords et v est < 4
    for k,v in pairs(superette_epicerie) do
        if #(vec3(coords.x, coords.y, coords.z) - vec3(v.x, v.y, v.z)) < 4 then
            return true
        end
    end
    for k,v in pairs(superette_robbery) do
        if #(vec3(coords.x, coords.y, coords.z) - vec3(v.pos.x, v.pos.y, v.pos.z)) < 4 then
            return true
        end
    end

    return false
end

function GetItemPriceFromLTD(item)
    -- check in table : catalogue_item_don, catalogue_item_ltd, catalogue_item_ltd_free_service (config/ltd.lua), if v.elements.item == item then return v.elements.price

    for k,v in pairs(catalogue_item_don.elements) do
        if v.item == item and v.price then
            return v.price
        end
    end
    for k,v in pairs(catalogue_item_ltd.elements) do
        if v.item == item and v.price then
            return v.price
        end
    end
    for k,v in pairs(catalogue_item_ltd_free_service.elements) do
        if v.item == item and v.price then
            return v.price
        end
    end

    return nil
end

RegisterNetEvent("core:buyFromLTD", function(item)
    local source = source
    local ltdArea = IsInLTDArea(GetEntityCoords(GetPlayerPed(source)))
    if not ltdArea then 
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Rapproche toi du magasin pour acheter un article"
        })
        return 
    end
    local price = GetItemPriceFromLTD(item)
    if price == nil then
        return
    end
    -- check if player has enough money
    local paid = CorePay(source, price)
    if paid then
        GiveItemToPlayer(source, item, 1, {})
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous avez acheté un(e) " .. item
        })
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous n'avez pas assez d'argent pour acheter cet article"
        })
    end
end)