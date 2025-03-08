catalogue = {}
catalogue.nord = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false
}
catalogue.sud = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
    [9] = false
}

RegisterNetEvent("core:changeCatalogueUsed")
AddEventHandler("core:changeCatalogueUsed", function(token, index, used, pos)
    if CheckPlayerToken(source, token) then
        --TriggerClientEvent("core:changeCatalogueUsedClient", -1, index, used, pos)
        if pos == 'nord' then
            catalogue.nord[index] = used
            return
        end
        catalogue.sud[index] = used
        return
    end
end)

RegisterNetEvent("core:deleteVehCatalogue")
AddEventHandler("core:deleteVehCatalogue", function(token, ids, netid, idsend)
    local _source = source
    if CheckPlayerToken(_source, token) then
        for k,v in pairs(ids) do
            TriggerClientEvent("core:deleteVehCatalogue", v, netid)
        end
    end
end)


RegisterServerCallback('core:catalogueIsUse', function(source, pos, index) -- done
    if pos == 'nord' then
        return catalogue.nord[index]
    end
    return catalogue.sud[index]
end)

RegisterNetEvent("core:resetCatalogue")
AddEventHandler("core:resetCatalogue", function(pos)
    if pos == 'nord' then
        for k,v in pairs(catalogue.nord) do
            catalogue.nord[k] = false
        end
        return
    end
    for k,v in pairs(catalogue.sud) do 
        catalogue.sud[k] = false
    end 
    return
end)