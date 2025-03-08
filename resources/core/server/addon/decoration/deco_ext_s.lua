PlacedPropsExt = {}

RegisterNetEvent("core:premium:placedProp", function(name, net)
    local src = source 
    local id = GetPlayer(src):getLicense()
    if not PlacedPropsExt[id] then 
        PlacedPropsExt[id] = 1 
    else
        PlacedPropsExt[id] += 1
    end 
end)

RegisterServerCallback("core:canPlaceProp", function(source)
    local id = GetPlayer(source):getLicense()
    return PlacedPropsExt[id]
end)

RegisterNetEvent("core:premium:removeProp", function(prop)
    local src = source 
    local id = GetPlayer(src):getLicense()
    if PlacedPropsExt[id] then
        PlacedPropsExt[id] = PlacedPropsExt[id] - 1
    end
end)