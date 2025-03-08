local pos = {
    { job = "gouv",    x = -544.03, y = -179.5,  z = 42.7 },
    { job = "gouv2",   x = -403.8,  y = 6152.38, z = 32.31 },
    { job = "justice", x = 202.02,  y = -428.51, z = 47.52 },
}

InPapierPPA = false

while p == nil do Wait(1000) end

for k, v in pairs(pos) do
    if p:getJob() == v.job and p:getJobGrade() >= 4 then
        zone.addZone(
            "ppa_" .. v.job,
            vector3(v.x, v.y, v.z),
            "Appuyer sur ~INPUT_CONTEXT~ pour créer un ppa",
            function()
                if p:getJob() == v.job and p:getJobGrade() >= 4 then
                    if InPapierPPA then return end
                    TriggerEvent("nuiPapier:client:startCreation", 9)
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas le métier ou le grade nécessaire pour créer un ppa.",
                    })
                end
            end,
            false,       -- Avoir un marker ou non
            -1,          -- Id / type du marker
            0.6,         -- La taille
            { 0, 0, 0 }, -- RGB
            0,           -- Alpha
            2.0,
            true,
            "bulleDemander"
        )
    end
end

RegisterNUICallback("focusOut", function()
    if InPapierPPA then
        InPapierPPA = false
    end
end)

function OpenPPA(name, residence, address, occupation, business, issuer, photo)
    SendNUIMessage({
        type = "openWebview",
        name = "PPA",
        data = {
            name = name,
            residence = residence,
            address = address,
            occupation = occupation,
            business = business,
            issuer = issuer,
            photo = photo
        }
    })
end

RegisterNetEvent('core:UsePPA')
AddEventHandler("core:UsePPA", function(name, residence, address, occupation, business, issuer, photo)
    OpenPPA(name, residence, address, occupation, business, issuer, photo)
    Wait(7000)
    SendNUIMessage({
        type = "closeWebview",
        name = "PPA"
    })
end)
