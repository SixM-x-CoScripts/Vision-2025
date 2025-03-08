HelicoCatalogue = {
    { label = "Luxor Deluxe", name = "luxor2", price = 1000000 },
    { label = "Alpha Z-1", name = "alphaz1", price = 625000 },
    { label = "Besra", name = "besra", price = 895000 },
    { label = "Dirigeable", name = "blimp3", price = 1500000 },
    { label = "Cuban 800", name = "cuban800", price = 595000 },
    { label = "Dodo", name = "dodo", price = 550000 },
    { label = "Howard NX-25", name = "howard", price = 675000 },
    { label = "Luxor", name = "luxor", price = 900000 },
    { label = "Mammatus", name = "mammatus", price = 500000 },
    { label = "ULM", name = "microlight", price = 35000 }, --Armé
    { label = "U.S Air Force Jet", name = "milijet", price = 2000000 },
    { label = "Nimbus", name = "nimbus", price = 800000 },
    { label = "P-45 Nokota", name = "nokota", price = 610000 },
    { label = "Rogue", name = "rogue", price = 710000 },
    { label = "Sea Breeze", name = "seabreeze", price = 495000 },
    { label = "Mallard", name = "mallard", price = 510000 },
    { label = "Velum", name = "velum2", price = 575000 },
    { label = "Vestra", name = "luxor", price = 625000 },
    { label = "Buzzard", name = "buzzard2", price = 550000 },
    { label = "Maverick LSPD", name = "lspdmav", price = 100 },
    { label = "Cargobob", name = "cargobob2", price = 750000 },
    { label = "Frogger", name = "frogger", price = 450000 },
    { label = "Havok", name = "havok", price = 350000 }, --Armé
    { label = "Maverick", name = "maverick", price = 500000 },
    { label = "Seasparrow", name = "seasparrow", price = 650000 }, --Armé
    { label = "Sparrow", name = "seasparrow2", price = 6250000 }, --Armé
    { label = "Super Volito", name = "supervolito", price = 675000 },
    { label = "Super Colito Carbon", name = "supervolito2", price = 700000 },
    { label = "Swift", name = "swift", price = 715000 },
    { label = "Swift Deluxe", name = "swift2", price = 1000000 },
    { label = "Volatus", name = "volatus", price = 950000 },
}

local open = false
local used = false
local previewPos = vector4(-976.44439697266, -2992.9401855469, 14.547943115234, 59.225292205811)
local camPos = vector3(-1001.236328125, -2996.4409179688, 22.560216903687)
local previewVeh
local previewModel
local main = RageUI.CreateMenu("", "Gestion", 0.0, 0.0, "root_cause", "shopui_title_premiumdeluxe")
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
main.Closed = function()
    if previewVeh ~= nil then
        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
        DeleteEntity(previewVeh)
    end
    previewVeh = nil
    Cam.render("nwar", false, true, 2000)
    Wait(2000)
    Cam.delete("nwar")
    used = TriggerServerCallback("core:EntrepriseCatalogueState", false)
	TriggerEvent("sw:allowfrrr", 0)
end

function OpenCatalogueHelicoMenu()
    if open then
        TriggerEvent("sw:allowfrrr", 0)
        open = false
        return
    else
        TriggerEvent("sw:allowfrrr", 1)
        open = true
        RageUI.Visible(main, true)
        used = TriggerServerCallback("core:EntrepriseCatalogueState", true)
        Cam.create("nwar")
        Cam.setPos("nwar", camPos)
        Cam.lookAtCoords("nwar", vector3(-976.44439697266, -2992.9401855469, 14.547943115234))
        Cam.render("nwar", true, true, 2000)
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k, v in pairs(HelicoCatalogue) do
                        RageUI.Button(v.label, false, { RightLabel = "~g~" .. v.price .. "$" }, true, {
                            onActive = function()
                                if previewModel == nil or previewModel ~= v.name then
                                    if previewVeh ~= nil then
                                        TriggerEvent('persistent-vehicles/forget-vehicle', previewVeh)
                                        DeleteEntity(previewVeh)
                                    end
                                    if not DoesEntityExist(previewVeh) then
                                        previewVeh = nil
                                        previewVeh = vehicle.create(v.name, previewPos,
                                            { plate = "VENTE" })
                                        previewModel = v.name
                                        FreezeEntityPosition(previewVeh, true)
                                        SetVehicleEngineOn(previewVeh, 1, 1, 0)
                                        SetVehicleDoorsLockedForAllPlayers(previewVeh, 1)
                                        SetVehicleLivery(previewVeh, v.liveries)
                                    end
                                end
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)
    end
end

-- -1317.7603759766, -1518.7332763672, 4.4247484207153

--[[Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone(
        "Helico_catalogue",
        vector3(-941.89874267578, -2955.1901855469, 12.945072174072), -- Position
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
                OpenCatalogueHelicoMenu()
            end
        end,
        true, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170-- Alpha
    )

end)]]
