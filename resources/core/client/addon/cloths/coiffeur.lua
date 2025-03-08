local token = nil
local BarberOpen = false
local anim = "misshair_shop@hair_dressers"
local anims = false
local anims2 = false
local invisbleped = nil
local actualCoiffeurData = {}
local choice = nil
InPrevisuCatalogueBarber = false
oldSkinCoiffeur = {}
local cached = {}
local index = {
    color = {
        primary = { 1, 1 },
        secondary = { 1, 1 },
    },
    percentage = 1,
}
local opacityPercent = 0
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


local dataHair = {}

local heading = 0
local Gradender = {}
GradenderByed = {}
local choice = nil

RegisterNetEvent("core:InreractWithBarber1")
AddEventHandler("core:InreractWithBarber1", function(data)
    choice = data.category
    if data.category == "Degradé" then
        ClearPedDecorations(PlayerPedId())
        ClearGradender()
        if type(data.info) == "table" then
            if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then 
                --if data.info.HashNameMale ~= "" then
                --    GradenderByed = {Collection = data.info.Collection,HashName = data.info.HashNameMale }
                --end
                --AddPedDecorationFromHashes(p:ped(), GetHashKey(data.info.Collection),GetHashKey(data.info.HashNameMale))
                SkinChangeFake("degrade_collection", GetHashKey(data.info.Collection), true)
                SkinChangeFake("degrade_hashname", GetHashKey(data.info.HashNameMale), true)
            else
                --if data.info.HashNameFemale ~= "" then
                --    GradenderByed = {Collection = data.info.Collection, HashName = data.info.HashNameFemale}
                --end
            -- AddPedDecorationFromHashes(p:ped(), GetHashKey(data.info.Collection),GetHashKey(data.info.HashNameFemale))
                SkinChangeFake("degrade_collection", GetHashKey(data.info.Collection), true)
                SkinChangeFake("degrade_hashname", GetHashKey(data.info.HashNameFemale), true)
            end
        else
            SkinChangeFake("degrade_collection", 0, true)
            SkinChangeFake("degrade_hashname", 0, true)
        end
    elseif data.category == "Barbe" then
        SkinChangeFake("beard_1", data.id, true)
        SkinChangeFake("beard_2", 100, true)
    elseif data.category == "Sourcils" then
        SkinChangeFake("eyebrows_1", data.id, true)
        SkinChangeFake("eyebrows_2", 100, true)
    elseif data.category == "Coupe" then
        SkinChangeFake("hair_1", data.id, true)
    elseif data.category == "Yeux" then
        SkinChangeFake("eye_color", data.id, true)
    end
end)

RegisterNetEvent("core:InreractWithBarber2")
AddEventHandler("core:InreractWithBarber2", function(data)
    if choice == "Coupe" then
        if data.type and data.type == "color1" then
            SkinChangeFake("hair_color_1", data.value-1, true)
        elseif data.type == "color2" then
            SkinChangeFake("hair_color_2", data.value-1, true)
        end
    elseif choice == "Barbe" then
        if data.type and data.type == "color1" then
            SkinChangeFake("beard_3", data.value-1, true)
        elseif data.type == "opacity" then
            SkinChangeFake("beard_2", tonumber(data.value), true)
        elseif data.type == "color2" then 
            SkinChangeFake("beard_4", data.value-1, true)
        end
    end
end)

RegisterNetEvent("core:InreractWithBarbercayo")
AddEventHandler("core:InreractWithBarbercayo", function(data)
    if choice == "Coupe" then
        if data.type and data.type == "color1" then
            SkinChangeFake("hair_color_1", data.value-1, true)
        elseif data.type == "color2" then
            SkinChangeFake("hair_color_2", data.value-1, true)
        end
    elseif choice == "Barbe" then
        if data.type and data.type == "color1" then
            SkinChangeFake("beard_3", data.value-1, true)
        elseif data.type == "opacity" then
            SkinChangeFake("beard_2", tonumber(data.value), true)
        elseif data.type == "color2" then 
            SkinChangeFake("beard_4", data.value-1, true)
        end
    end
end)

RegisterNetEvent("core:PlacePlayerOnSeatClient")
AddEventHandler("core:PlacePlayerOnSeatClient", function(data)
    --print("Player On seat", json.encode(data))
    if HasSecondHair() then 
        SetFirstHair()
    end
    Coiffeur_Gochair(data)
end)

RegisterNetEvent("core:ExitPlayerOnSeatClient")
AddEventHandler("core:ExitPlayerOnSeatClient", function(data)
    BarberOpen = false
    Coiffeur_Stopchair(data)
    p:setSkin(oldSkinCoiffeur)
    p:saveSkin()
    collectgarbage("collect")
    cleanGradenderPlayer()
end)


RegisterNetEvent("core:applySkinBarberClient")
AddEventHandler("core:applySkinBarberClient", function(changedData)
    local newSkin = GetFakeSkin()
    p:setSkin(newSkin)
    p:saveSkin()
    if changedData and next(changedData) then
        for k,v in pairs(changedData) do 
            if k == "Degradé" then 
                if type(v.item.info) == "table" then
                    if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
                        GradenderByed = {Collection = v.item.info.Collection,HashName = v.item.info.HashNameMale }
                        p:setDegrader(GradenderByed)
                    else
                        GradenderByed = {Collection = v.item.info.Collection,HashName = v.item.info.HashNameFemale }
                        p:setDegrader(GradenderByed)
                    end
                else
                    GradenderByed = {Collection = nil,HashName = nil }
                    p:setDegrader(GradenderByed)
                end
            end
        end
    end
    oldSkinCoiffeur = newSkin
    collectgarbage("collect")
    cleanGradenderPlayer()
end)


function HasSecondHair()
    local skin = SkinChangerGetSkin()
    return skin["secondhair"]
end

function SetFirstHair()
    SkinChangerChange("secondhair", 0)
    ApplySkin(p:skin())
end

function changeHair()
    if second then
        p:PlayAnim("clothingtie", "check_out_a", 51)
        Wait(2000)
        ClearPedTasks(p:ped())
        SkinChangerChange("secondhair", 0)
        ApplySkin(oldSkin)
        second = false
    else
        p:PlayAnim("clothingtie", "check_out_a", 51)
        Wait(2000)
        ClearPedTasks(p:ped())
        SkinChangerChange("secondhair", tonumber(coupe2))
        ApplySkin(oldSkin)
        second = true
    end
end

local firstStart = 0
RegisterNetEvent("core:RefreshCoiffeur") --- A CALL LORS D'UN SWITCH DE PERSO
AddEventHandler("core:RefreshCoiffeur", function()
    firstStart = 0
end)
function OpenCoiffeurMenu(data)
    BarberOpen = true
    InPrevisuCatalogueBarber = true
    oldSkinCoiffeur = p:skin()
    ApplySkinFake(oldSkinCoiffeur)
    forceHideRadar()
    actualCoiffeurData = data
    if firstStart == 0 then
        firstStart = 1
        DataToSendCoiffeur = {
            buttons= {
                {
                    name= 'Coupe',
                    width= 'full',
                    image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/cheveux.svg',
                    hoverStyle= 'fill-black stroke-black',
                    opacity= false,
                    color1= false,
                    color2= false
                },
                {
                    name= 'Degradé',
                    width= 'full',
                    image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/degrader.svg',
                    hoverStyle= 'fill-black stroke-black',
                    opacity= false,
                    color1= false,
                    color2= false
                    
                },
                {
                    name= 'Yeux',
                    width= 'full',
                    image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/yeux.svg',
                    hoverStyle= 'fill-black stroke-black',
                    opacity= false,
                    color1= false,
                    color2= false
                },
                {
                    name= 'Barbe',
                    width= 'full',
                    image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/barbe.svg',
                    hoverStyle= 'fill-black stroke-black',
                    opacity= false,
                    color1= false,
                    color2= false
                },
                {
                    name= 'Sourcils',
                    width= 'full',
                    image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/shenails/eyebrow.svg',
                    hoverStyle= 'fill-black stroke-black',
                    opacity= true,
                    color1= true,
                    color2= true
                },
            },
            catalogue = {},
            headerIcon= 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
            headerIconName= 'HOMME',
            hideItemList= {'Degradé'},
            headerImage= 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_barbershop.webp',
            callbackName= 'MenuGrosCatalogueCoiffeur',
            showTurnAroundButtons= true,
            disableSubmit= true
        }
        local tattoos = getDegrader()
        local sex = "Homme"
        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then 
            sex = "Femme"
            DataToSendCoiffeur.headerIconName = "FEMME" 
            DataToSendCoiffeur.buttons = {}
            table.insert(DataToSendCoiffeur.buttons,
            { 
                name= 'Coupe',
                width= 'full',
                image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/cheveux.svg',
                hoverStyle= 'fill-black stroke-black',
                opacity= false,
                color1= false,
                color2= false
            })
            Wait(10)
            table.insert(DataToSendCoiffeur.buttons,
            { 
                name= 'Degradé',
                width= 'full',
                image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/cheveux.svg',
                hoverStyle= 'fill-black stroke-black',
            })
            Wait(10)
            table.insert(DataToSendCoiffeur.buttons,
            { 
                name= 'Yeux',
                width= 'full',
                image= 'https://cdn.sacul.cloud/v2/vision-cdn/svg/barber/yeux.svg',
                hoverStyle= 'fill-black stroke-black',
            })
        end
        table.insert(DataToSendCoiffeur.catalogue, {
            id= 0,
            label = "Dégrader N°0",
            image= "",
            ownCallbackName = 'previewCoiffeurCB',
            category= "Degradé",
            info = "aucun"
        })
        for i = 1, #tattoos do
            if tattoos[i].Zone == "ZONE_HEAD" then
                if p:isMale() and tattoos[i].HashNameMale ~= "" then
                    table.insert(DataToSendCoiffeur.catalogue, {
                        id= i,
                        label = "Dégrader N°" .. i,
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/".. sex .."/Degrader/"..i..".webp",
                        ownCallbackName = 'previewCoiffeurCB',
                        category= "Degradé",
                        info = tattoos[i]
                    })
                elseif not p:isMale() and tattoos[i].HashNameFemale ~= "" then
                    table.insert(DataToSendCoiffeur.catalogue, {
                        id= i,
                        label = "Dégrader N°" .. i,
                        image= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/".. sex .."/Degrader/"..i..".webp",
                        ownCallbackName = 'previewCoiffeurCB',
                        category= "Degradé",
                        info = tattoos[i]
                    })
                end
            end
        end
        for i = 0, 31 do
            table.insert(DataToSendCoiffeur.catalogue, {
                id= i,
                label = "Yeux N°" .. i,
                image= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/".. sex .."/Yeux/"..i..".webp",
                ownCallbackName = 'previewCoiffeurCB',
                category= "Yeux",
            })
        end
        for i = 0, GetNumberOfPedDrawableVariations(p:ped(), 2) do
            if i ~= 190 or i ~= 90 then
                table.insert(DataToSendCoiffeur.catalogue, {
                    id= i,
                    label = "Coiffure N°" .. i,
                    image= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/".. sex .."/Coupes/"..i..".webp",
                    ownCallbackName = 'previewCoiffeurCB',
                    category= "Coupe",
                })
            end
        end
        for i = 1, GetNumHeadOverlayValues(1) - 1 do
            table.insert(DataToSendCoiffeur.catalogue, {
                id= i,
                label = "Barbe N°" .. i,
                image= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/".. sex .."/Barbes/"..i..".webp",
                ownCallbackName = 'previewCoiffeurCB',
                category= "Barbe",
                
            })
        end
        
        -- Sourcils
        for i = 0, GetNumHeadOverlayValues(2)-1 do 
            local add = i+1
            table.insert(DataToSendCoiffeur.catalogue, {
                id= i,
                label = "Sourcils N°" .. i,
                image= "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/".. sex .."/Sourcils/"..add..".webp",
                ownCallbackName = 'previewCoiffeurCB',
                category= "Sourcils",
            })
        end
    end
    forceHideRadar()
    SetNuiFocusKeepInput(true)
    CreateThread(function()
        while BarberOpen do 
            Wait(1)
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 322, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true) 
            DisableControlAction(0, 25, true) 
            DisableControlAction(0, 263, true) 
            DisableControlAction(0, 264, true) 
            DisableControlAction(0, 257, true) 
            DisableControlAction(0, 140, true) 
            DisableControlAction(0, 141, true) 
            DisableControlAction(0, 142, true) 
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
            if IsDisabledControlPressed(0, 38) then 
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+0.8)
            elseif IsDisabledControlPressed(0, 44) then 
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-0.8)
            end
        end
    end)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogueColor',
        data = DataToSendCoiffeur
    }))
end

RegisterNUICallback("focusOut", function(data, cb)
    if InPrevisuCatalogueBarber then 
        p:setSkin(oldSkinCoiffeur)
        InPrevisuCatalogueBarber = false
    end
end)

RegisterNUICallback("previewCoiffeurCB", function(data)
    if InPrevisuCatalogueBarber then 
        if data.category == "Degradé" then
            ClearPedDecorations(PlayerPedId())
            ClearGradender()
            if type(data.info) == "table" then
                if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then 
                    SkinChangeFake("degrade_collection", GetHashKey(data.info.Collection), true)
                    SkinChangeFake("degrade_hashname", GetHashKey(data.info.HashNameMale), true)
                else
                    SkinChangeFake("degrade_collection", GetHashKey(data.info.Collection), true)
                    SkinChangeFake("degrade_hashname", GetHashKey(data.info.HashNameFemale), true)
                end
            else
                SkinChangeFake("degrade_collection", 0, true)
                SkinChangeFake("degrade_hashname", 0, true)
            end
        elseif data.category == "Barbe" then
            SkinChangeFake("beard_1", data.id, true)
            SkinChangeFake("beard_2", 100, true)
        elseif data.category == "Sourcils" then
            SkinChangeFake("eyebrows_1", data.id, true)
            SkinChangeFake("eyebrows_2", 100, true)
        elseif data.category == "Coupe" then
            SkinChangeFake("hair_1", data.id, true)
        elseif data.category == "Yeux" then
            SkinChangeFake("eye_color", data.id, true)
        end
    end
end)

RegisterNUICallback("focusOut", function (data, cb)
    if BarberOpen then
        BarberOpen = false
        playerInSeat = false
        Coiffeur_Stopchair(actualCoiffeurData)
        openRadarProperly()
    end
end)


local dataSelected = nil
function Coiffeur_Gochair(data)
    heading = 0
    dataSelected = data
    local playerInSeat = true
    oldSkinCoiffeur = p:skin()
    ApplySkinFake(oldSkinCoiffeur)
    RequestAndWaitDict("misshair_shop@barbers")
    RequestAndWaitDict("misshair_shop@hair_dressers")
    local pos = data.posI + vec3(0.0, 0.0, 1.4)
    TaskPlayAnimAdvanced(p:ped(), anim, "player_enterchair", data.posI, data.anim_pos, 1000.0, -1000.0, -1, 5642, 0.0, 2, 1)
    while not HasEntityAnimFinished(p:ped(), anim, "player_enterchair", 3) do
        Wait(0)
    end
    TaskPlayAnimAdvanced(p:ped(), anim, "player_base", data.posI, data.anim_pos, 1000.0, -8.0, -1, 5641, 0.0, 2, 1)
    CreateThread(function()
        while playerInSeat do
            if BarberOpen then 
                if IsControlJustPressed(0, 211) and playerInSeat then
                    playerInSeat = false
                    Coiffeur_Stopchair(dataSelected)
                    openRadarProperly()
                    p:setSkin(oldSkinCoiffeur)
                    collectgarbage("collect")
                    cleanGradenderPlayer()
                    ClearGradender()
                    p:saveSkin()
                end
            else
                playerInSeat = false
            end
            Wait(0)
        end
    end)
end

function cleanGradenderPlayer()
    ClearPedDecorations(p:ped())
    if tattoosByed then
        for i = 1, #tattoosByed, 1 do
            if tattoosByed[i] ~= nil then
                AddPedDecorationFromHashes(p:ped(), GetHashKey(tattoosByed[i].Collection),
                    GetHashKey(tattoosByed[i].HashName))
            end
        end
    end
    if GradenderByed then
        if GradenderByed.HashName ~= nil then
            AddPedDecorationFromHashes(p:ped(), GetHashKey(GradenderByed.Collection),
                GetHashKey(GradenderByed.HashName))
        end
    end
end

function ClearGradender()
    ClearPedDecorations(p:ped())
    if tattoosByed then
        for i = 1, #tattoosByed, 1 do
            if tattoosByed[i] ~= nil then
                AddPedDecorationFromHashes(p:ped(), GetHashKey(tattoosByed[i].Collection),
                    GetHashKey(tattoosByed[i].HashName))
            end
        end
    end
end

function Coiffeur_Stopchair(info)
    playerInSeat = false
    if info then
        TaskPlayAnimAdvanced(p:ped(), anim, "exitchair_female", info.posI, info.anim_pos, 1000.0, -1000.0, -1, 5642, 0.2, 2,1)
    end
    Wait((GetAnimDuration(anim, "exitchair_female") * 1000) - 3000)
    RemoveAnimDict("misshair_shop@barbers")
    RemoveAnimDict("misshair_shop@hair_dressers")
    Wait(1500)
    ClearPedTasks(PlayerPedId())
    Wait(1000)
end
