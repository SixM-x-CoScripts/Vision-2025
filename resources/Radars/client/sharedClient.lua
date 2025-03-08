function PenaltyMoney(upSpeed) -- return penalty amount
    return 50
    if upSpeed > 0 and upSpeed <= 10 then return 75
    elseif upSpeed > 10 and upSpeed <= 20 then return 150
    elseif upSpeed > 20 and upSpeed <= 30 then return 225
    elseif upSpeed > 30 and upSpeed <= 40 then return 300
    elseif upSpeed > 40 and upSpeed <= 50 then return 350
    elseif upSpeed > 50 and upSpeed <= 60 then return 400
    elseif upSpeed > 60 and upSpeed <= 70 then return 450
    elseif upSpeed > 70 and upSpeed <= 80 then return 500 end
    return 500
end

function notification(amount, carModel, numberplate, radarName, catchSpeed, maxSpeed) -- method to notify
    print("Notification", amount, carModel, numberplate, radarName, catchSpeed, maxSpeed)
    -- exports['vNotif']:createNotification({
    --     type = 'JAUNE',
    --     duration = 6, -- In seconds, default:  4
    --     content = "~c Vous venez de vous faire flasher à " .. catchSpeed .. "km/h au lieu de " .. maxSpeed .. "km/h vous avez recu une mmande de ~s " .. amount .. "$"
    -- })
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "POLICE",
        label = "Radar",
        labelColor = "#135DD8",
        logo = "https://e7.pngegg.com/pngimages/795/985/png-clipart-traffic-enforcement-camera-traffic-sign-speed-limit-warning-sign-camera-card-angle-driving-thumbnail.png",
        mainMessage = "Vous venez de vous faire flasher à " .. catchSpeed .. "km/h au lieu de " .. maxSpeed .. "km/h vous avez recu une amende de " .. amount .. "$",
        duration = 10,
    })
end

function getJob()
   return exports["core"]:GetJobPlayer()
end
