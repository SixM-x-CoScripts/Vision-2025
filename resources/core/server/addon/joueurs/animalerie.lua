local ObjAnimaux = {}

CreateThread(function()
	local btData = LoadResourceFile(GetCurrentResourceName(), 'server/addon/joueurs/animalerie.json')
	ObjAnimaux = btData and json.decode(btData) or {}
    while true do 
        Wait(60000)        
        SaveResourceFile(GetCurrentResourceName(), 'server/addon/joueurs/animalerie.json', json.encode(ObjAnimaux))
    end
end)

RegisterServerCallback("core:getAnimaux", function(source)
    local license = GetPlayer(source):getLicense()
    local Table = {}
    for k,v in pairs(ObjAnimaux) do 
        if v.license == license then 
            table.insert(Table, v)
        end
    end
    return Table
end)

RegisterNetEvent("core:buyAnimal", function(ped)
    local src = source
    local license = GetPlayer(src):getLicense()
    table.insert(ObjAnimaux, {license = license, ped = ped, name = "Aucun"})
end)