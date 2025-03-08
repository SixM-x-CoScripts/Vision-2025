RegisterNetEvent('core:golfball')
AddEventHandler('core:golfball', function(type)
    exports["GolfActivity"]:spawnBallGolf(type)
end)