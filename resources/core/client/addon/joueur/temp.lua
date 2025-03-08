local active = false

function DoTemporaryStuff()
    if not active then return end
    local hasAsked = TriggerServerCallback("core:hasChangedVetements")
    if not hasAsked then 
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            TriggerEvent("skinchanger:change", "arms", 15)
            TriggerEvent("skinchanger:change", "arms_2", 0)
            TriggerEvent("skinchanger:change", "torso_1", 15)
            TriggerEvent("skinchanger:change", "torso_2", 0)
            TriggerEvent("skinchanger:change", "tshirt_1", 15)
            TriggerEvent("skinchanger:change", "tshirt_2", 0)
            TriggerEvent("skinchanger:change", "pants_1", 61)
            TriggerEvent("skinchanger:change", "pants_2", 4)
            TriggerEvent('skinchanger:change','bproof_1',0)
            TriggerEvent("skinchanger:change", "shoes_1", 34)
            TriggerEvent("skinchanger:change", "shoes_2", 0)
            TriggerEvent('skinchanger:change','glasses_1',0)
            TriggerEvent("skinchanger:change", "bracelet_1", 0)
        elseif GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            TriggerEvent('skinchanger:change', "sex", 1)
            TriggerEvent("skinchanger:change", "arms", 15)
            TriggerEvent("skinchanger:change", "arms_2", 0)
            TriggerEvent("skinchanger:change", "torso_1", 5)
            TriggerEvent("skinchanger:change", "tshirt_1", 15)
            TriggerEvent("skinchanger:change", "pants_1", 57)
            TriggerEvent("skinchanger:change", "pants_2", 0)
            TriggerEvent("skinchanger:change", "shoes_1", 34)
            TriggerEvent("skinchanger:change", "shoes_2", 0)
            TriggerEvent('skinchanger:change','glasses_1',0)
            TriggerEvent("skinchanger:change", "bracelet_1", 0)
        end
        Wait(10000)
        exports['vNotif']:createNotification({
            type = 'ILLEGAL',
            name = "Binco",
            label = "+5000$",
            labelColor = "#38DC66",
            logo = "https://cdn.sacul.cloud/vision-cdn/icons/binco.png?format=webp",
            mainMessage = "Rendez-vous au Magasin de vêtements pour vous refaire une garde robe.",
            duration = 10,
        })
    end
end
