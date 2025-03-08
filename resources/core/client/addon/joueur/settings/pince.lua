local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local coupes = {
    current = 0,
    default = 51,
    items = {},
}


local oldSkin = nil
local secondhair = nil
local open = nil 
RegisterNetEvent("core:UsePinceBitche")
AddEventHandler("core:UsePinceBitche", function()
-- RegisterCommand("pince", function()
    local sex = "Homme"
    open = true 
    if p:isMale() ~= true then sex = "Femme" end
    -- playerCoords = GetEntityCoords(PlayerPedId())

    oldSkin = p:skin()
    secondhair = oldSkin.hair_2    
    coupes.current = secondhair
    coupes.default = secondhair

    for i = 0, GetNumberOfPedDrawableVariations(p:ped(), 2) do
        table.insert(coupes.items, {
            id= i,
            valeur = "Coiffure N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/".. sex .."/Coupes/"..i..".webp",
        })
    end
    -- cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    -- SetCamActive(cam, 1)
    -- SetCamCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.7)
    -- SetCamFov(cam, 30.0)
    -- PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 1.5)
    -- RenderScriptCams(true, 0, 3000, 1, 0)   
    -- FreezeEntityPosition(PlayerPedId(), true)

    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuPinceACheveux',
        data = coupes,
    }));
end)

RegisterNUICallback("PinceACheveux", function(data, cb)
    if data.hair ~= nil then
        SkinChangerChange("secondhair", data.hair.id)
    elseif data.submit ~= nil then
        SkinChangerChange("secondhair", data.submit.id)
        ApplySkin(p:skin())
        oldSkin = p:skin()
        secondhair = data.submit.id
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if open then
        SkinChangerChange("secondhair", secondhair)
        ApplySkin(oldSkin)
        open = false
    end
end)