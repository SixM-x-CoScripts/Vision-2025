local pos = {
    ["6"] = vector3(-1097.79, -849.89, 37.26),
    ["5"] = vector3(-1097.79, -849.89, 33.37),
    ["4"] = vector3(-1097.79, -849.89, 29.76),
    ["3"] = vector3(-1097.79, -849.89, 25.83),
    ["2"] = vector3(-1097.79, -849.89, 22.04),
    ["1"] = vector3(-1097.79, -849.89, 18.0),
    ["0"] = vector3(-1097.79, -849.89, 18.0),
    ["-1"] = vector3(-1097.79, -849.89, 12.69),
    ["-2"] = vector3(-1097.79, -849.89, 9.28),
    ["-3"] = vector3(-1097.79, -849.89, 3.89),
}

local pos2 = {
    ["3"] = vector3(-1067.77, -833.2, 26.04),
    ["2"] = vector3(-1067.72, -833.23, 22.04),
    ["1"] = vector3(-1067.73, -833.23, 18.05),
    ["0"] = vector3(-1067.73, -833.23, 18.05),
    ["-1"] = vector3(-1067.81, -833.22, 13.88),
    ["-2"] = vector3(-1067.85, -833.21, 10.04),
    ["-3"] = vector3(-1067.83, -833.21, 4.48),
}

local lastbulle = 1
RegisterNUICallback("focusOut", function()
    Bulle.show("lspd_ascenseur"..lastbulle)
    Bulle.show("lspd_ascenseur2"..lastbulle)
end)

local one = false
function OpenAscenseur(k, pos)
    one = pos
    SendNUIMessage({
        type = "openWebview",
        name = "ascenseur",
        data = {
            floor = k
        }
    })
    -- ---AffichageNui
    -- etage = k
    -- SetEntityCoordsNoOffset(p:ped(), pos[1].x, pos[1].y, pos[1].z, 0, 0, 1)
end

for k, v in pairs(pos) do
    zone.addZone(
        "lspd_ascenseur" .. k,
        vector3(v.x, v.y, v.z + 1.25),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            lastbulle = k
            Bulle.hide("lspd_ascenseur" ..k)
            OpenAscenseur(k, true)
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        1.25,
        true,
        "bulleAscenseur"
    )

end

for k, v in pairs(pos2) do
    zone.addZone(
        "lspd_ascenseur2" .. k,
        vector3(v.x, v.y, v.z + 1.25),
        "~INPUT_CONTEXT~ Intéragir",
        function()
            lastbulle = k
            Bulle.hide("lspd_ascenseur2" ..k)
            OpenAscenseur(k, false)
        end, false,
        27,
        1.5,
        { 255, 255, 255 },
        170,
        1.25,
        true,
        "bulleAscenseur"
    )

end




RegisterNUICallback('elevator__callback', function(data, cb)
    if data.floor ~= nil and data.floor ~= "0" then
        if one then
            if #(p:pos() - vector3(pos[data.floor].x, pos[data.floor].y, pos[data.floor].z)) >= 2.0 then

                Modules.UI.RealWait(2000)
                SetNuiFocus(false, false)
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }));

                SetEntityCoordsNoOffset(p:ped(), pos[data.floor].x, pos[data.floor].y, pos[data.floor].z, 0, 0, 1)
            else
                -- ShowNotification("Vous êtes déjà à cet étage")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous êtes déjà à cet étage"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }));
            end
        else
            if data.floor == "4" or data.floor == "5" or data.floor == "6" then
                --ShowNotification("Mince étage pas disponible")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Mince, ~c étage pas disponible"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }));
            else
                if #(p:pos() - vector3(pos2[data.floor].x, pos2[data.floor].y, pos2[data.floor].z)) >= 2.0 then

                    Modules.UI.RealWait(3000)
                    SetNuiFocus(false, false)
                    SendNuiMessage(json.encode({
                        type = 'closeWebview',
                    }));

                    SetEntityCoordsNoOffset(p:ped(), pos2[data.floor].x, pos2[data.floor].y, pos2[data.floor].z, 0, 0, 1)
                else
                    -- ShowNotification("Vous êtes déjà à cet étage")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous êtes déjà à cet étage"
                    })

                    SendNuiMessage(json.encode({
                        type = 'closeWebview',
                    }));
                end
            end
        end
    else
        -- ShowNotification("Étage en travaux")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Étage en travaux"
        })

        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }));
    end


end)
