-- Désactivation du Job Vespucci Bike

--[[ local open = false
local used = false
local previewPos = vector4(-1318.068359375, -1515.7208251953, 3.424747467041, 109.71218109131)

local previewVeh
local previewModel
local main = RageUI.CreateMenu("", "Gestion", 0.0, 0.0, "vision", "Banner_VespucciBike")
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
main.Closed = function()
    if previewVeh ~= nil then
        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
        DeleteEntity(previewVeh)
    end
    used = TriggerServerCallback("core:VespucciBikeCatalogueState", false)
end

function OpenCatalogueVespucciMenu()
    if open then
        open = false
        return
    else
        open = true
        RageUI.Visible(main, true)
        used = TriggerServerCallback("core:VespucciBikeCatalogueState", true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k, v in pairs(VespucciBike) do
                        RageUI.Button(v.name, false, {}, true, {
                            onActive = function()
                                if previewModel == nil or previewModel ~= v.model then
                                    if previewVeh ~= nil then
                                        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
                                        DeleteEntity(previewVeh)
                                    end
                                    if not DoesEntityExist(previewVeh) then
                                        previewVeh = nil
                                        previewActive = true
                                        previewVeh = vehicle.create(v.model, previewPos,
                                            { plate = "VENTE" })
                                        previewModel = v.model
                                        FreezeEntityPosition(previewVeh, true)
                                        SetVehicleEngineOn(previewVeh, 1, 1, 0)
                                        SetVehicleDoorsLockedForAllPlayers(previewVeh, 1)
                                    end
                                end
                            end
                        })
                    end
                    RageUI.Button("Skate", false, {}, true, {
                        onActive = function()
                            if previewVeh ~= nil then
                                TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
                                DeleteEntity(previewVeh)
                            end
                            if not DoesEntityExist(previewVeh) then
                                previewVeh = nil
                                previewActive = true
                                previewVeh = entity:CreateObject("p_defilied_ragdoll_01_s", previewPos)
                                previewVeh = previewVeh.id
                                previewModel = "p_defilied_ragdoll_01_s"
                                FreezeEntityPosition(previewVeh, true)
                            end
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end

-- -1317.7603759766, -1518.7332763672, 4.4247484207153

Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone(
        "vespucciBike_catalogue",
        vector3(-1317.7603759766, -1518.7332763672, 4.4247484207153), -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function() -- Action qui seras fait
            used = TriggerServerCallback("core:GetUsed")
            if used then
                -- ShowNotification("~r~Quelqu'un utilise déjà le catalogue")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Quelqu'un utilise déjà le catalogue"
                })

                return
            else
                OpenCatalogueVespucciMenu()
            end
        end,
        false, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

end)
 ]]