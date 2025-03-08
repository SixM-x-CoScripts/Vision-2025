local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


local helicoptere = {
    {
        id=0,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=1,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=2,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=3,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=4,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=5,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=6,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=7,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=8,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
    {
        id=9,
        image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img2.webp",
        name="helicoptere",
        categorie="helicoptere"
    },
}


--[[ RegisterCommand("lspdhelicoptere", function(source, args, rawCommand)   
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Menu_LSPD_helicoptere',
        data = helicoptere
    }));
end, false) ]]


RegisterNUICallback("valider_achatrapide_bike", function(data, cb)
    if p:pay(data.choiceUser.prix) then
        data.choiceUser.name = "saumon"
        TriggerSecurGiveEvent("core:addItemToInventory", token, data.choiceUser.name, 1, {})
        -- ShowNotification("Vous venez d'acheter un(e) "..data.choiceUser.name)

        -- New notif
        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            duration = 5, -- In seconds, default:  4
            content = "Vous venez d'acheter ~s un(e) "..data.choiceUser.name
        })

    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    TriggerScreenblurFadeOut(0.5)
    openRadarProperly()

end)