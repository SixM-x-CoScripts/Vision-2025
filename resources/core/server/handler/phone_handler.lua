CreateThread(function()
    MySQL.Async.fetchAll('DELETE FROM `phone_notifications` WHERE timestamp < CURTIME() - INTERVAL 7 DAY') --250k
    MySQL.Async.fetchAll('DELETE FROM `phone_message_messages` WHERE timestamp < CURTIME() - INTERVAL 10 DAY') --340k
    MySQL.Async.fetchAll('DELETE FROM `phone_darkchat_messages` WHERE timestamp < CURTIME() - INTERVAL 10 DAY')
    --MySQL.Async.fetchAll('DELETE FROM `phone_marketplace_posts` WHERE timestamp < CURTIME() - INTERVAL 1 MONTH')
    MySQL.Async.fetchAll('DELETE FROM `phone_phone_calls` WHERE timestamp < CURTIME() - INTERVAL 10 DAY') --158k
    MySQL.Async.fetchAll('DELETE FROM `phone_services_channels` WHERE timestamp < CURTIME() - INTERVAL 10 DAY')--3.5k
    MySQL.Async.fetchAll('DELETE FROM `phone_services_messages` WHERE timestamp < CURTIME() - INTERVAL 10 DAY')--14k
    --MySQL.Async.fetchAll('DELETE FROM `phone_yellow_pages_posts` WHERE timestamp < CURTIME() - INTERVAL 1 MONTH')
    --MySQL.Async.fetchAll('DELETE FROM `phone_photos` WHERE timestamp < CURTIME() - INTERVAL 3 MONTH')
    MySQL.Async.fetchAll('DELETE FROM `phone_message_members` WHERE deleted = 1') -- Inshallah je casse pas tout
end)

AddEventHandler("phone:server:resetNumber")
RegisterNetEvent('phone:server:resetNumber', function(id)
    exports["lb-phone"]:FactoryReset(exports["lb-phone"]:GetEquippedPhoneNumber(id))
end)

AddEventHandler("phone:server:resetPin")
RegisterNetEvent('phone:server:resetPin', function(id)
    exports["lb-phone"]:ResetSecurity(exports["lb-phone"]:GetEquippedPhoneNumber(id))
end)