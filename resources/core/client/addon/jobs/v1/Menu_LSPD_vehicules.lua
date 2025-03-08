local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


local mes_vehicules = {
        {
            id=0,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=1,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=2,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=3,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=4,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=5,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=6,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=7,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=8,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
        {
            id=9,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="mes_vehicules"
        },
    }
local catalogue_item = {
        {
            id=0,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="rookie"
        },
        {
            id=1,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="rookie"
        },
        {
            id=2,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="rookie"
        },
        {
            id=3,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_1"
        },
        {
            id=4,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_1"
        },
        {
            id=5,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_2"
        },
        {
            id=6,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_2"
        },
        {
            id=7,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_3"
        },
        {
            id=8,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_3"
        },
        {
            id=9,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="slo"
        },
        {
            id=10,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="slo"
        },
        {
            id=11,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="sergeant"
        },
        {
            id=12,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="sergeant"
        },
        {
            id=13,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="cs"

        },
        {
            id=14,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="cs"
        },
        {
            id=15,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_1"
        },
        {
            id=16,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="officier_1"
        },
        {
            id=17,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="grades",
            sous_categorie="cs"
        },
        {
            id=18,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img4.webp",
            name="anis",
            categorie="divisions",
            sous_categorie="trafic_division"
        },
        {
            id=19,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img4.webp",
            name="anis",
            categorie="divisions",
            sous_categorie="trafic_division"
        },
        {
            id=20,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img4.webp",
            name="anis",
            categorie="divisions",
            sous_categorie="trafic_division"
        },
        {
            id=21,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="gnd"

        },
        {
            id=22,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="gnd"
        },
        {
            id=23,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="swat"
        },
        {
            id=24,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="swat"
        },
        {
            id=25,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="swat"
        },
        {
            id=26,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="anti_emeute"
        },
        {
            id=27,
            image="https://cdn.sacul.cloud/v2/vision-cdn/LSPD/img0.webp",
            name="véhicule",
            categorie="divisions",
            sous_categorie="anti_emeute"
        },
}


--[[ RegisterCommand("lspdveh", function(source, args, rawCommand)   
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Menu_LSPD_vehicules',
        catalogue_item = catalogue_item,
        mes_vehicules = mes_vehicules
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