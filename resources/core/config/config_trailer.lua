ConfigTrailer = {}

ConfigTrailer.VehicleCanTrail = {
    {name = 'GUARDIAN', class = {8, 9}},
    {name = 'SQUADDIE', class = {8, 9}},
    {name = 'BENSON', class = {8, 9}},
    {name = 'EVERON', class = {8, 9}},
    {name = 'TITAN', class = {8, 9}},
    {name = 'SANDKING', class = {8, 9}},
    {name = 'SANDKIN2', class = {8, 9}},
    {name = 'DUBSTA3', class = {8, 9}},
    {name = 'BOBCATXL', class = {8, 9}},
    {name = 'SANDSTORMXL', class = {8, 9}},
    {name = 'BOATTRAILER', class = {14}},
    {name = 'WASTLNDR', class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},
    {name = 'TRAILER', class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},
    {name = 'trailerflat2', class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},
    {name = '20fttrailer', class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},
    {name = 'enclosedbiketrail', class = {8, 9}},
    {name = 'flatbed3', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},

}

ConfigTrailer.Lang = {    
    ["TrailerNotFind"] = 'Remorque non trouvé',
    ["RampeAlreadySet"] = 'Une rampe existe deja',
    ["NoVehicleSet"] = 'Pas de vehicule attaché',
    ["CantSetThisType"] = 'Ce vehicule ne peut pas etre attaché à cette remorque',
    ["NotGoodJob"] = 'Vous n\'avez pas le bon job',
    ["PressToOpen"] = 'Appuyez sur E pour ouvrir',
    ["NotInVehicle"] = 'vous n\'etes pas dans un vehicule',
}

ConfigTrailer.SendNotification = function(msg, source)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        msg
    })
end

ConfigTrailer.ShowHelpNotification = function(msg, source)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        msg
    })
end

ConfigTrailer.GetJob = function()
    if ConfigTrailer.FrameWork == "ESX" then
        return ESX.PlayerData.job.name
    elseif ConfigTrailer.FrameWork == "QBCore" then
        return PlayerJob.name
    end
end

ConfigTrailer.Command = {
    ["attachtrailer"] = "attachtrailer",
    ["detachtrailer"] = "detachtrailer",

    -- TR2 TRAILER
    ["openrampetr2"] = "openrampetr2",
    ["opentrunktr2"] = "opentrunktr2",
    ["closerampetr2"] = "closerampetr2",
    ["closetrunktr2"] = "closetrunktr2",

    -- 20fttrailer
    ["rampOut20ft"] = "rampOut20ft",
    ["rampIn20ft"] = "rampIn20ft",
}
