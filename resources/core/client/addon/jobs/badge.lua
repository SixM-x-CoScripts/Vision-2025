local pos = {
    {job = "lspd", x = -1096.95, y = -818.51, z = 19.04},
    {job = "lssd", x = 2829.47, y = 4748.12, z = 48.63},
    {job = "usss", x = 2510.8, y = -443.09, z = 99.11},
}

InPapierBadge = false

while p == nil do Wait(1000) end

for k, v in pairs(pos) do
    if p:getJob() == v.job and p:getJobGrade() >= 4 then
        zone.addZone(
            "badge_"..v.job,
            vector3(v.x, v.y, v.z),
            "Appuyer sur ~INPUT_CONTEXT~ pour demander un badge",
            function()
                if p:getJob() == v.job and p:getJobGrade() >= 4 then
                    if InPapierBadge then return end
                    TriggerEvent("nuiPapier:client:startCreation", 8)
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas le métier ou le grade nécessaire pour demander un badge.",
                    })
                end
            end,
            false, -- Avoir un marker ou non
            -1,    -- Id / type du marker
            0.6,   -- La taille
            { 0, 0, 0 }, -- RGB
            0,     -- Alpha
            2.0,
            true,
            "bulleDemander"
        )
    end
end

RegisterNUICallback("focusOut", function()
    if InPapierBadge then
        InPapierBadge = false
    end
end)

function OpenBadge(service, name, matricule, grade, photo, divisions)
    SendNUIMessage({
        type = "openWebview",
        name = "policeID",
        data = {
            service = service,
            name = name,
            matricule = matricule,
            grade = grade,
            photo = photo,
            divisions = divisions
        }
    })
end

RegisterNetEvent('core:UseBadge')
AddEventHandler("core:UseBadge", function(service, name, matricule, grade, photo, divisions)
    OpenBadge(service, name, matricule, grade, photo, divisions)
    Wait(7000)
    SendNUIMessage({
        type = "closeWebview",
        name = "policeID"
    })
end)