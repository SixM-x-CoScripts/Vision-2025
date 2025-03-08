RegisterNetEvent('core:scissors')
AddEventHandler('core:scissors', function(token, id)
    -- Send a notification to the player
    TriggerClientEvent('__atoshi::createNotification', id, {
        type = 'JAUNE',
        content = "~s~Quelqu'un vous a coupé les cheveux !"
    })
    TriggerClientEvent("core:applySkinBarberClient", id, {
        Coupe = {
            item = {
                category = "Coupe",
                ownCallbackName = "previewCoiffeurCB",
                image = "https://cdn.sacul.cloud/v2/vision-cdn/Barber/Homme/Coupes/1.webp",
                label = "Coiffure N°1",
                id = 1
            }
        }
    })
end)