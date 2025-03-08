local ClothShop = {
    open = false,
    cam = nil,
    oldSkin = nil
}
local lastdata = nil
VarIsJob = false

-- local PolosPremium = {567, 568, 569}
-- local ShirtsPremium = {576, 577, 578, 579}
-- local SweatPremium = {571 , 572 , 573 , 574 , 575}
-- local PullPremium = {580, 581, 582, 583}
-- local MaillotsPremium = {584, 585}
-- local CasquettesPremium = {212, 213, 214, 215}
-- local ChemisesPremium = {566}

-- NE PAS METTRE EN LOCAL PAR PITIE
PolosPremium = { 690, 691, 692 }
ShirtsPremium = { 699, 700, 701, 702 }
SweatPremium = { 694, 695, 696, 697, 698 }
PullPremium = { 703, 704, 705, 706 }
MaillotsPremium = { 707, 708, 709 }
CasquettesPremium = { 252, 253 }
ChemisesPremium = { 689 }

MaillotsCustom = {}

--MaillotsFemmePremium = {273, 724, 753}
MaillotsFemmePremium = { 724, 753 }
CroptopPremium = { 714, 715, 716, 717, 718 }
HautsFemmePremium = { 719, 720, 721, 722, 726, 732, 736, 737 }
JupesPremium = { 193, 196 }
RobesPremium = { 725, 727, 728, 729, 731, 738, 755, 756 }
PantalonsFemmePremium = { 275, 276, 277, 278, 279, 280 }

local token, nbStart, playerType, playerSex = nil, 0, nil, nil

RegisterNetEvent("core:RefreshBinco") --- A CALL LORS D'UN SWITCH DE PERSO
AddEventHandler("core:RefreshBinco", function()
    nbStart = 0
end)

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local function CreateCameraBinco(typevet)
    if ClothShop.cam == nil then
        ClothShop.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    SetCamActive(ClothShop.cam, 1)
    local coord = GetEntityCoords(PlayerPedId())
    local formattedcamval = { coord.x, coord.y, coord.z }
    if typevet == "Hauts" then
        if not IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) then
            PlayEmote("clothingshirt", "try_shirt_neutral_b", 49, -1)
        end
        formattedcamval = { coord.x + 2.0, coord.y, coord.z + 1.15, 30, 0.2 }
    elseif typevet == "Chaussures" then
        if not IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) then
            PlayEmote("clothingshoes", "try_shoes_neutral_d", 49, -1)
        end
        formattedcamval = { coord.x + 2.0, coord.y, coord.z - 0.9, 30, -0.65 }
    elseif typevet == "Bas" then
        if not IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
            PlayEmote("clothingtrousers", "try_trousers_neutral_d", 49, -1)
        end
        formattedcamval = { coord.x + 2.0, coord.y, coord.z - 0.6, 50, -0.2 }
    elseif typevet == "Accessoires" then
        if not IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) then
            PlayEmote("clothingshirt", "try_shirt_neutral_b", 49, -1)
        end
        formattedcamval = { coord.x + 2.0, coord.y, coord.z + 1.15, 30, 0.5 }
    elseif typevet == "Autres" then
        if not IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) then
            PlayEmote("clothingshirt", "try_shirt_neutral_b", 49, -1)
        end
        formattedcamval = { coord.x + 2.0, coord.y, coord.z + 1.15, 30, 0.2 }
    end
    SetCamCoord(ClothShop.cam, formattedcamval[1], formattedcamval[2], formattedcamval[3])
    PointCamAtCoord(ClothShop.cam, coord.x, coord.y, coord.z + formattedcamval[5])
    SetCamFov(ClothShop.cam, formattedcamval[4] + 0.1)
    Wait(20)
    local p1 = GetCamCoord(ClothShop.cam)
    local p2 = GetEntityCoords(PlayerPedId())
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    if typevet == "Autres" then
        heading = GetHeadingFromVector_2d(p2.x - p1.x, p2.y - p1.y)
    else
        heading = GetHeadingFromVector_2d(dx, dy)
    end
    SetEntityHeading(PlayerPedId(), heading)
    RenderScriptCams(true, 0, 3000, 1, 0)
end

RegisterNUICallback("MenuBincoClickButton", function(data)
    if data.button == "Hauts" or data.button == "Maillots" or data.button == "Chemises" or data.button == "Shirts" or data.button == "Pulls" or data.button == "Sweat" or data.button == "Polo" then
        CreateCameraBinco("Hauts")
    elseif data.button == "Bas" then
        CreateCameraBinco("Bas")
    elseif data.button == "Manuel" or data.button == "Autres" or data.button == "Kevlar" then
        CreateCameraBinco("Hauts")
    elseif data.button == "Accessoires" then
        CreateCameraBinco("Accessoires")
    elseif data.button == "Chaussures" then
        CreateCameraBinco("Chaussures")
    elseif data.button == "Cou" then
        --    SendNuiMessage(json.encode({
        --        type = 'closeWebview',
        --    }))
        --local playerSkin = p:skin()
        --ApplySkin(playerSkin)
        --if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
        --IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
        --IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
        --    ClearPedTasks(PlayerPedId())
        --end
        --SetNuiFocusKeepInput(false)
        --TriggerScreenblurFadeOut(0.5)
        --DisplayHud(true)
        --SetNuiFocus(false, false)
        --openRadarProperly()
        --RenderScriptCams(false, false, 0, 1, 0)
        --FreezeEntityPosition(PlayerPedId(), false)
        --ClothShop.open = false
        --ClothShop.cam = nil
        --DestroyCam(ClothShop.cam,false)
        --exports['vNotif']:createNotification({
        --    type = 'ROUGE',
        --    content = "Bientôt disponible"
        --})
        --closeUI()
        CreateCameraBinco("Accessoires")
    elseif data.button == "Chapeaux" or data.button == "Casquette" then
        CreateCameraBinco("Accessoires")
    elseif data.button == "Lunettes" then
        CreateCameraBinco("Accessoires")
    elseif data.button == "Sacs" then
        CreateCameraBinco("Autres")
    end
end)

RegisterNUICallback("MenuBincoClickHabit", function(data)
    printDev(json.encode(data, { indent = true })) -- DEV NE PAS ENLEVER
    if data.category == "Hauts" then
        if data.subCategory == "Hauts" then
            SkinChangeFake("torso_1", data.id)
            SkinChangeFake("torso_2", 0)
            if ClothsList[playerType]["Haut"][tostring(data.id)] then
                print("Bras " .. ClothsList[playerType]["Haut"][tostring(data.id)])
                SkinChangeFake("arms", ClothsList[playerType]["Haut"][tostring(data.id)])
                SkinChangeFake("arms_2", 0)
            end
            SkinChangeFake("tshirt_1", 15)
            SkinChangeFake("tshirt_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("torso_2", data.id - 1)
        elseif data.subCategory == "Sous-haut" then
            SkinChangeFake("tshirt_1", data.id)
            SkinChangeFake("tshirt_2", 0)
        elseif data.subCategory == "Variations 2" then
            SkinChangeFake("tshirt_2", data.id - 1)
        elseif data.subCategory == "Bras" then
            SkinChangeFake("arms", data.id)
            SkinChangeFake("arms_2", 0)
        elseif data.subCategory == "Variations 3" then
            SkinChangeFake("arms_2", data.id - 1)
        elseif data.subCategory == "pHauts" then
            lastdata = data.id
            SetPedComponentVariation(PlayerPedId(), 3, data.id, 0)
        elseif data.subCategory == "pVariations" then
            SetPedComponentVariation(PlayerPedId(), 3, lastdata, data.id - 1)
        end
    elseif data.category == "Autres" or data.category == "Manuel" then
        if data.subCategory == "Autres" then
            SkinChangeFake("torso_1", data.id)
            SkinChangeFake("torso_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("torso_2", data.id - 1)
        elseif data.subCategory == "Sous-haut" then
            SkinChangeFake("tshirt_1", data.id)
            SkinChangeFake("tshirt_2", 0)
        elseif data.subCategory == "Variations 2" then
            SkinChangeFake("tshirt_2", data.id - 1)
        elseif data.subCategory == "Bras" then
            SkinChangeFake("arms", data.id)
            SkinChangeFake("arms_2", 0)
        elseif data.subCategory == "Variations 3" then
            SkinChangeFake("arms_2", data.id - 1)
        end
    elseif data.category == "Metiers" then
        --print("data.all", json.encode(data.all))
        if data.all.haut1 then
            SkinChangeFake("torso_1", data.all.haut1)
        end
        if data.all.haut2 then
            SkinChangeFake("torso_2", data.all.haut2)
        end
        if data.all.soushaut1 then
            SkinChangeFake("tshirt_1", data.all.soushaut1)
        end
        if data.all.soushaut2 then
            SkinChangeFake("tshirt_2", data.all.soushaut2)
        end
        if data.all.bras1 then
            SkinChangeFake("arms", data.all.bras1)
        end
        if data.all.bras2 then
            SkinChangeFake("arms_2", data.all.bras2)
        end
        if data.all.bas1 then
            SkinChangeFake("pants_1", data.all.bas1)
        end
        if data.all.bas2 then
            SkinChangeFake("pants_2", data.all.bas2)
        end
        if data.all.shoes1 then
            SkinChangeFake("shoes_1", data.all.shoes1)
        end
        if data.all.shoes2 then
            SkinChangeFake("shoes_2", data.all.shoes2)
        end
        if data.all.helmet1 then
            SkinChangeFake("helmet_1", data.all.helmet1)
        end
        if data.all.helmet2 then
            SkinChangeFake("helmet_2", data.all.helmet2)
        end
    elseif data.category == "Maillots" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            SkinChangeFake("torso_1", data.id)
            SkinChangeFake("torso_2", data.idVdariationed - 1)
            SkinChangeFake("tshirt_1", 15)
            SkinChangeFake("tshirt_2", 0)
            if data.id == 709 then
                SkinChangeFake("arms", 0)
            else
                SkinChangeFake("arms", 5)
            end
            SkinChangeFake("arms_2", 0)
        else
            if data.id == 724 or data.id == 753 then
                SkinChangeFake("arms", 280)
            else
                SkinChangeFake("arms", 279)
            end
            SkinChangeFake("torso_1", data.id)
            SkinChangeFake("torso_2", data.idVdariationed - 1)
            SkinChangeFake("tshirt_1", 15)
            SkinChangeFake("tshirt_2", 0)
            SkinChangeFake("arms_2", 0)
        end
    elseif data.category == "SacsFemmes" then
        SkinChangeFake("bags_1", data.id)
        SkinChangeFake("bags_2", data.idVdariationed - 1)
    elseif data.category == "HautsFemmes" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        if data.id == 719 or data.id == 722 then
            SkinChangeFake("arms", 278)
        elseif data.id == 720 then
            SkinChangeFake("arms", 279)
        elseif data.id == 736 then
            SkinChangeFake("arms", 0)
        elseif data.id == 737 then
            SkinChangeFake("arms", 1)
        elseif data.id == 732 then
            SkinChangeFake("arms", 7)
        elseif data.id == 721 then
            SkinChangeFake("arms", 277)
        end
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Sweat" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 4)
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Robes" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        if data.id == 725 or data.id == 727 then
            SkinChangeFake("arms", 280)
        elseif data.id == 738 then
            SkinChangeFake("arms", 279)
        elseif data.id == 755 or data.id == 756 or data.id == 729 or data.id == 728 or data.id == 731 then
            SkinChangeFake("arms", 282)
        elseif data.id == 281 then
            SkinChangeFake("arms", 281)
        end
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Croptop" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        if data.id == 714 then
            SkinChangeFake("arms", 281)
        elseif data.id == 717 or data.id == 718 then
            SkinChangeFake("arms", 280)
        else
            SkinChangeFake("arms", 279)
        end
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Pulls" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 1)
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Polo" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 0)
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Shirts" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 11)
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Chemises" then
        SkinChangeFake("torso_1", data.id)
        SkinChangeFake("torso_2", data.idVdariationed - 1)
        SkinChangeFake("tshirt_1", 15)
        SkinChangeFake("tshirt_2", 0)
        SkinChangeFake("arms", 11)
        SkinChangeFake("arms_2", 0)
    elseif data.category == "Bas" then
        if data.subCategory == "Bas" then
            SkinChangeFake("pants_1", data.id)
            SkinChangeFake("pants_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("pants_2", data.id - 1)
        elseif data.subCategory == "pBas" then
            lastdata = data.id
            SetPedComponentVariation(PlayerPedId(), 4, data.id, 0)
        elseif data.subCategory == "pVariations" then
            SetPedComponentVariation(PlayerPedId(), 4, lastdata, data.id - 1)
        end
    elseif data.category == "Chaussures" then
        if data.subCategory == "Chaussures" then
            SkinChangeFake("shoes_1", data.id)
            SkinChangeFake("shoes_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("shoes_2", data.id - 1)
        end
    elseif data.category == "Cou" then
        if data.subCategory == "Cou" then
            SkinChangeFake("chain_1", data.id)
            SkinChangeFake("chain_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("chain_2", data.id - 1)
        end
    elseif data.category == "Casquette" then
        SkinChangeFake("helmet_1", tonumber(data.id))
        SkinChangeFake("helmet_2", tonumber(data.idVdariationed) - 1)
    elseif data.category == "Chapeaux" then
        if data.subCategory == "Chapeaux" then
            SkinChangeFake("helmet_1", data.id)
            SkinChangeFake("helmet_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("helmet_2", data.id - 1)
        elseif data.subCategory == "pChapeaux" then
            lastdata = data.id
            SetPedPropIndex(PlayerPedId(), 0, data.id, 0, true)
        elseif data.subCategory == "pVariations" then
            SetPedPropIndex(PlayerPedId(), 0, lastdata, data.id - 1, true)
        end
    elseif data.category == "Lunettes" then
        if data.subCategory == "Lunettes" then
            SkinChangeFake("glasses_1", data.id)
            SkinChangeFake("glasses_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("glasses_2", data.id - 1)
        elseif data.subCategory == "pLunettes" then
            lastdata = data.id
            SetPedPropIndex(PlayerPedId(), 1, data.id, 0, true)
        elseif data.subCategory == "pVariations" then
            SetPedPropIndex(PlayerPedId(), 1, lastdata, data.id - 1, true)
        end
    elseif data.category == "Sacs" then
        if data.subCategory == "Sacs" then
            SkinChangeFake("bags_1", data.id)
            SkinChangeFake("bags_2", 0)
        elseif data.subCategory == "Variations" then
            SkinChangeFake("bags_2", data.id - 1)
        end
    elseif data.category == "Accessoires" then
        if data.subCategory == "pAccessoires" then
            lastdata = data.id
            SetPedComponentVariation(PlayerPedId(), 8, data.id, 0)
        elseif data.subCategory == "pVariations" then
            SetPedComponentVariation(PlayerPedId(), 8, lastdata, data.id - 1)
        end
    end
end)


RegisterNUICallback("MenuBincoNomTenu", function(tenueName)
    local skin = SkinChangerGetSkin()
    local tenue = {
        ['tshirt_1'] = skin["tshirt_1"],
        ['tshirt_2'] = skin["tshirt_2"],
        ['torso_1'] = skin["torso_1"],
        ['torso_2'] = skin["torso_2"],
        ['decals_1'] = skin["decals_1"],
        ['decals_2'] = skin["decals_2"],
        ['arms'] = skin["arms"],
        ['arms_2'] = skin["arms_2"],
        ['pants_1'] = skin["pants_1"],
        ['pants_2'] = skin["pants_2"],
        ['shoes_1'] = skin["shoes_1"],
        ['shoes_2'] = skin["shoes_2"],
        ['bags_1'] = skin['bags_1'],
        ['bags_2'] = skin['bags_2'],
        ['chain_1'] = skin['chain_1'],
        ['chain_2'] = skin['chain_2'],
        ['helmet_1'] = skin['helmet_1'],
        ['helmet_2'] = skin['helmet_2'],
        ['ears_1'] = skin['ears_1'],
        ['ears_2'] = skin['ears_2'],
        ['mask_1'] = skin['mask_1'],
        ['mask_2'] = skin['mask_2'],
        ['glasses_1'] = skin['glasses_1'],
        ['glasses_2'] = skin['glasses_2'],
        ['bproof_1'] = skin['bproof_1'],
        ['bproof_2'] = skin['bproof_2'],
    }
    TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
        { premium = true, renamed = tenueName, data = tenue })
    -- ShowNotification("Vous venez de récupérer une tenue")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "~c Vous venez de récupérer ~s une tenue"
    })
end)

local BanHat, BanGlases, BanTop, BanLeg, BanShoes, BanBag, BanSous, BanSous, BanArm, BanCou = {}, {}, {}, {}, {}, {}, {},
    {}, {}, {}
local function GetDatas(isjob, ids, vbans)
    if not isPlayerPed() then
        local Skin = p:skin()
        ApplySkinFake(Skin)
    end
    --if nbStart == 0 then
    --    nbStart = 1
    DataSendBinco.buttons = {}
    DataSendBinco.catalogue = {}
    DataSendBinco.forceCategory = nil
    if isPlayerPed() then     --C'est un ped
        DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/glasses.svg'
        DataSendBinco.headerIconName = 'PED'
        playerType = "Ped"
		playerSex = "ped"
    elseif p:skin().sex == 0 then
        DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
        DataSendBinco.headerIconName = 'Binco Homme'
        playerType = "Homme"
		playerSex = "male"
    elseif p:skin().sex == 1 then
        DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
        DataSendBinco.headerIconName = 'Binco Femme'
        playerType = "Femme"
		playerSex = "female"
    end

	print("playerType", playerType, playerSex, p:skin().sex)

    if playerType == "Homme" then     --ban homme
        if not isjob then
            BanHat = ClothesBan["Homme"].BanHat
            BanGlases = ClothesBan["Homme"].BanGlases
            BanTop = ClothesBan["Homme"].BanTop
            BanLeg = ClothesBan["Homme"].BanLeg
            BanShoes = ClothesBan["Homme"].BanShoes
            BanBag = ClothesBan["Homme"].BanBag
            BanSous = ClothesBan["Homme"].BanSous
            BanArm = ClothesBan["Homme"].BanArm
            BanCou = ClothesBan["Homme"].BanCou
        else
            BanHat = vbans.hat.h
            for i = 0, ids.hat.h.debut do
                table.insert(BanHat, i)
            end
            for i = ids.hat.h.fin, 999 do
                table.insert(BanHat, i)
            end
            BanLeg = vbans.leg.h
            for i = 0, ids.leg.h.debut do
                table.insert(BanLeg, i)
            end
            for i = ids.leg.h.fin, 999 do
                table.insert(BanLeg, i)
            end
            BanTop = vbans.top.h
            for i = 0, ids.top.h.debut do
                table.insert(BanTop, i)
            end
            for i = ids.top.h.fin, 999 do
                table.insert(BanTop, i)
            end
            BanShoes = vbans.shoes.h
            for i = 0, ids.shoes.h.debut do
                table.insert(BanShoes, i)
            end
            for i = ids.shoes.h.fin, 999 do
                table.insert(BanShoes, i)
            end
            BanBag = vbans.bag.h
            for i = 0, ids.bag.h.debut do
                table.insert(BanBag, i)
            end
            for i = ids.bag.h.fin, 999 do
                table.insert(BanBag, i)
            end
            BanSous = vbans.sous.h
            for i = 0, ids.sous.h.debut do
                table.insert(BanSous, i)
            end
            for i = ids.sous.h.fin, 999 do
                table.insert(BanSous, i)
            end
            BanCou = vbans.cou.h
            for i = 0, ids.cou.h.debut do
                table.insert(BanCou, i)
            end
            for i = ids.cou.h.fin, 999 do
                table.insert(BanCou, i)
            end
        end
        priceTop = {
            [566] = 75,
            [567] = 115,
            [568] = 55,
            [569] = 55,
            [570] = 70,
            [571] = 650,
            [572] = 150,
            [573] = 650,
            [575] = 50,
            [576] = 55,
            [577] = 20,
            [578] = 55,
            [579] = 20,
            [580] = 45,
            [581] = 30,
            [583] = 40,
            [585] = 75,
            [586] = 45,
            [587] = 85,
            [588] = 40,
            [589] = 25,
            [590] = 30,
            [591] = 85,
            [592] = 180,
            [593] = 30,
            [594] = 25,
            [595] = 60,
            [596] = 45,
            [597] = 75,
            [598] = 45,
            [599] = 50,
            [600] = 130,
            [601] = 55,
            [602] = 125,
            [603] = 30,
            [605] = 15,
            [606] = 40,
            [607] = 75,
            [608] = 80,
            [609] = 85,
            [610] = 85,
            [611] = 60,
            [612] = 60,
            [613] = 30,
            [614] = 160,
            [615] = 75,
            [616] = 45,
            [617] = 1060,
            [618] = 70,
            [619] = 85,
            [621] = 25,
            [623] = 180,
            [624] = 30,
            [625] = 45,
            [626] = 60,
            [627] = 85,
            [628] = 75,
            [629] = 60,
            [630] = 230,
            [631] = 5,
            [632] = 30,
            [634] = 25,
            [635] = 1350,
            [636] = 25,
            [637] = 30,
            [638] = 45,
            [639] = 45,
            [640] = 50,
            [641] = 690,
            [642] = 550,
            [643] = 280,
            [644] = 295,
            [645] = 1500,
            [646] = 55,
            [647] = 150,
            [648] = 50,
            [649] = 455,
            [650] = 190,
            [651] = 250,
            [652] = 160,
            [653] = 95,
            [654] = 300,
            [655] = 200,
            [656] = 75,
            [657] = 815,
            [658] = 2700,
            [659] = 15,
            [660] = 25,
            [661] = 95,
            [662] = 15,
            [663] = 15,
            [665] = 75,
            [666] = 450,
            [667] = 150,
            [668] = 2500,
            [669] = 75,
            [670] = 150,
            [671] = 80,
            [672] = 75,
            [673] = 140,
            [674] = 480,
            [675] = 550,
            [676] = 655,
            [677] = 450,
            [678] = 570,
            [679] = 240,
            [680] = 75,
            [681] = 110,
            [682] = 625,
            [683] = 750,
            [684] = 500,
            [685] = 90,
            [686] = 90,
            [687] = 50,
            [688] = 80
        }

        priceLeg = {
            [207] = 100,
            [208] = 100,
            [209] = 100,
            [210] = 100,
            [211] = 100,
            [212] = 100,
            [213] = 100,
            [214] = 100,
            [215] = 100,
            [216] = 100,
            [217] = 350,
            [218] = 100,
            [219] = 150,
            [220] = 100,
            [221] = 40,
            [222] = 100,
            [223] = 100,
            [224] = 100,
            [225] = 200,
            [226] = 150,
            [227] = 100,
            [228] = 100,
            [229] = 100,
            [230] = 100,
            [231] = 100,
            [232] = 250,
            [233] = 400,
            [234] = 1200,
            [235] = 150,
            [236] = 150,
            [237] = 100,
            [238] = 100,
            [239] = 100,
            [240] = 250,
            [241] = 300,
            [242] = 350,
            [243] = 100,
            [244] = 100,
            [245] = 100,
            [246] = 1200,
            [247] = 300,
            [248] = 350,
            [249] = 100,
            [250] = 250,
            [251] = 350,
            [252] = 350,
            [253] = 200,
            [254] = 400,
            [255] = 250,
            [256] = 150,
            [257] = 350,
            [258] = 350,
            [259] = 150,
            [260] = 350,
            [261] = 400,
            [262] = 1000,
            [263] = 650,
            [264] = 1000,
            [265] = 500,
            [266] = 800,
            [267] = 1600,
            [268] = 300,
            [269] = 300,
            [270] = 500,
            [271] = 950,
            [272] = 100,
            [273] = 650,
            [274] = 250,
            [275] = 250,
            [276] = 1650,
            [277] = 650,
            [278] = 450,
            [279] = 450,
            [280] = 150,
            [281] = 350,
            [282] = 150,
            [283] = 150,
            [284] = 100,
            [285] = 150,
            [286] = 250,
            [287] = 350,
            [288] = 350
        }

        priceShoes = {
            [136] = 100,
            [137] = 400,
            [138] = 200,
            [139] = 150,
            [140] = 130,
            [141] = 100,
            [142] = 50,
            [143] = 170,
            [144] = 150,
            [145] = 130,
            [146] = 500,
            [147] = 170,
            [148] = 110,
            [149] = 120,
            [150] = 50,
            [151] = 80,
            [152] = 140,
            [153] = 80,
            [154] = 160,
            [155] = 900,
            [156] = 450,
            [157] = 140,
            [158] = 100,
            [159] = 160,
            [160] = 170,
            [161] = 130,
            [162] = 160,
            [163] = 140,
            [164] = 230,
            [165] = 400,
            [166] = 500,
            [167] = 1200,
            [168] = 160,
            [169] = 100,
            [170] = 300,
            [171] = 190,
            [172] = 200,
            [173] = 170,
            [174] = 130,
            [175] = 2000,
            [176] = 150,
            [177] = 130,
            [178] = 1400,
            [179] = 150,
            [180] = 500,
            [181] = 130,
            [182] = 140,
            [183] = 150,
            [184] = 600
        }

        priceHat = {
            [226] = 150,
            [227] = 90,
            [228] = 90,
            [229] = 60,
            [230] = 60,
            [231] = 70,
            [232] = 80,
            [233] = 100,
            [234] = 70,
            [235] = 80,
            [236] = 30,
            [237] = 100,
            [238] = 150,
            [239] = 130,
            [240] = 120,
            [241] = 200,
            [242] = 60,
            [243] = 90,
            [244] = 90,
            [245] = 80,
            [246] = 60,
            [247] = 70,
            [248] = 70,
            [249] = 90,
            [250] = 90,
            [251] = 120
        }

        priceGlass = {
            [1] = 0,
            [2] = 120,
            [3] = 90,
            [4] = 45,
            [5] = 150,
            [6] = 5,
            [7] = 75,
            [8] = 250,
            [9] = 115,
            [10] = 250,
            [11] = 5,
            [12] = 200,
            [13] = 125,
            [14] = 5,
            [15] = 145,
            [16] = 45,
            [17] = 210,
            [18] = 225,
            [19] = 150,
            [20] = 75,
            [21] = 5,
            [22] = 5,
            [23] = 75,
            [24] = 45,
            [25] = 85,
            [26] = 5,
            [27] = 5,
            [28] = 170,
            [29] = 300,
            [30] = 20,
            [31] = 90,
            [32] = 75,
            [33] = 150,
            [34] = 200,
            [35] = 125,
            [36] = 125,
            [37] = 100,
            [38] = 90,
            [39] = 90,
            [40] = 195,
            [41] = 195,
            [42] = 55,
            [43] = 20,
            [44] = 5,
            [45] = 225,
            [46] = 200,
            [47] = 5,
            [48] = 150,
            [49] = 150,
            [50] = 65,
            [51] = 85,
            [52] = 5,
            [53] = 75,
            [54] = 5,
            [55] = 85,
            [56] = 75,
            [57] = 75,
            [58] = 450,
            [59] = 850,
            [60] = 750,
            [61] = 55,
            [62] = 150,
            [63] = 150,
            [64] = 150,
            [65] = 650,
            [66] = 650,
            [67] = 150,
            [68] = 550,
            [69] = 350,
            [70] = 650,
            [71] = 800,
            [72] = 800,
            [73] = 150,
            [74] = 650
        }

        priceBag = {
            [40] = 200,
            [41] = 200,
            [44] = 200,
            [45] = 200,
            [81] = 200,
            [82] = 200,
            [85] = 200,
            [86] = 200,
            [111] = 30,
            [112] = 50,
            [113] = 50,
            [114] = 30,
            [115] = 30,
            [129] = 200,
            [134] = 150,
            [140] = 150,
            [146] = 150,
            [147] = 150,
            [148] = 150,
            [150] = 200,
            [153] = 400,
            [157] = 200,
            [161] = 120,
            [190] = 250,
            [191] = 70,
            [192] = 250,
            [193] = 250,
            [194] = 250,
            [196] = 200,
            [197] = 200,
            [198] = 200,
            [199] = 200,
            [200] = 200,
            [201] = 200,
            [202] = 250,
            [203] = 400,
            [204] = 350,
            [205] = 500,
            [206] = 500,
            [207] = 250,
            [208] = 250,
            [209] = 250
        }
    else     --ban femme
        if not isjob then
            BanHat = ClothesBan["Femme"].BanHat
            BanGlases = ClothesBan["Femme"].BanGlases
            BanTop = ClothesBan["Femme"].BanTop
            BanLeg = ClothesBan["Femme"].BanLeg
            BanShoes = ClothesBan["Femme"].BanShoes
            BanBag = ClothesBan["Femme"].BanBag
            BanSous = ClothesBan["Femme"].BanSous
            BanArm = ClothesBan["Femme"].BanArm
            BanCou = ClothesBan["Femme"].BanCou
        else
            BanHat = vbans.hat.f
            for i = 0, ids.hat.f.debut do
                table.insert(BanHat, i)
            end
            for i = ids.hat.f.fin, 999 do
                table.insert(BanHat, i)
            end
            BanLeg = vbans.leg.f
            for i = 0, ids.leg.f.debut do
                table.insert(BanLeg, i)
            end
            for i = ids.leg.f.fin, 999 do
                table.insert(BanLeg, i)
            end
            BanTop = vbans.top.f
            for i = 0, ids.top.f.debut do
                table.insert(BanTop, i)
            end
            for i = ids.top.f.fin, 999 do
                table.insert(BanTop, i)
            end
            BanShoes = vbans.shoes.f
            for i = 0, ids.shoes.f.debut do
                table.insert(BanShoes, i)
            end
            for i = ids.shoes.f.fin, 999 do
                table.insert(BanShoes, i)
            end
            BanBag = vbans.bag.f
            for i = 0, ids.bag.f.debut do
                table.insert(BanBag, i)
            end
            for i = ids.bag.f.fin, 999 do
                table.insert(BanBag, i)
            end
            BanSous = vbans.sous.f
            for i = 0, ids.sous.f.debut do
                table.insert(BanSous, i)
            end
            for i = ids.sous.f.fin, 999 do
                table.insert(BanSous, i)
            end
            BanCou = vbans.cou.f
            for i = 0, ids.cou.f.debut do
                table.insert(BanCou, i)
            end
            for i = ids.cou.f.fin, 999 do
                table.insert(BanCou, i)
            end
        end
        priceTop = {
            [586] = 250,
            [587] = 150,
            [588] = 100,
            [589] = 150,
            [590] = 150,
            [591] = 100,
            [592] = 100,
            [593] = 100,
            [594] = 100,
            [595] = 150,
            [596] = 200,
            [597] = 100,
            [598] = 350,
            [599] = 150,
            [600] = 75,
            [601] = 150,
            [602] = 150,
            [603] = 150,
            [604] = 100,
            [606] = 200,
            [607] = 350,
            [608] = 75,
            [609] = 250,
            [610] = 250,
            [611] = 75,
            [612] = 75,
            [613] = 100,
            [614] = 100,
            [615] = 100,
            [616] = 100,
            [617] = 100,
            [619] = 100,
            [620] = 250,
            [621] = 150,
            [622] = 100,
            [623] = 300,
            [624] = 100,
            [625] = 150,
            [626] = 200,
            [627] = 150,
            [628] = 150,
            [629] = 150,
            [630] = 100,
            [631] = 100,
            [632] = 300,
            [633] = 100,
            [634] = 150,
            [635] = 100,
            [636] = 150,
            [637] = 600,
            [638] = 75,
            [639] = 100,
            [640] = 100,
            [641] = 250,
            [642] = 100,
            [643] = 100,
            [644] = 250,
            [645] = 100,
            [646] = 100,
            [647] = 100,
            [648] = 150,
            [649] = 100,
            [650] = 100,
            [651] = 75,
            [652] = 150,
            [653] = 75,
            [654] = 75,
            [655] = 75,
            [656] = 75,
            [657] = 250,
            [658] = 200,
            [659] = 100,
            [660] = 150,
            [661] = 100,
            [662] = 100,
            [663] = 100,
            [664] = 350,
            [665] = 100,
            [666] = 200,
            [667] = 150,
            [668] = 150,
            [669] = 150,
            [670] = 250,
            [671] = 100,
            [672] = 100,
            [673] = 673,
            [674] = 150,
            [675] = 250,
            [676] = 100,
            [677] = 100,
            [678] = 300,
            [679] = 200,
            [680] = 150,
            [681] = 200,
            [682] = 100,
            [683] = 150,
            [684] = 150,
            [685] = 150,
            [686] = 150,
            [687] = 100,
            [688] = 100,
            [689] = 100,
            [690] = 100,
            [692] = 300,
            [693] = 150,
            [694] = 300,
            [695] = 150,
            [696] = 150,
            [698] = 250,
            [699] = 1250,
            [700] = 150,
            [701] = 150,
            [702] = 150,
            [703] = 150,
            [704] = 75,
            [705] = 150,
            [706] = 75,
            [707] = 75,
            [709] = 100,
            [712] = 150,
            [713] = 450
        }

        priceLeg = {
            [203] = 100,
            [204] = 500,
            [205] = 40,
            [206] = 500,
            [207] = 40,
            [208] = 100,
            [209] = 100,
            [210] = 100,
            [211] = 100,
            [212] = 100,
            [213] = 100,
            [214] = 100,
            [215] = 100,
            [216] = 100,
            [217] = 100,
            [218] = 100,
            [219] = 100,
            [220] = 100,
            [221] = 40,
            [223] = 100,
            [224] = 100,
            [225] = 100,
            [226] = 350,
            [227] = 100,
            [228] = 100,
            [229] = 100,
            [230] = 100,
            [231] = 100,
            [232] = 100,
            [233] = 100,
            [235] = 40,
            [237] = 40,
            [238] = 40,
            [239] = 40,
            [240] = 40,
            [241] = 40,
            [242] = 100,
            [243] = 100,
            [244] = 100,
            [245] = 95,
            [246] = 70,
            [247] = 50,
            [248] = 65,
            [249] = 70,
            [250] = 45,
            [251] = 40,
            [252] = 50,
            [253] = 70,
            [254] = 200,
            [255] = 70,
            [256] = 90,
            [257] = 75,
            [258] = 250,
            [259] = 1500,
            [260] = 90,
            [261] = 40,
            [262] = 90,
            [263] = 50,
            [264] = 60
        }

        priceShoes = {
            [140] = 100,
            [141] = 120,
            [142] = 200,
            [143] = 200,
            [144] = 300,
            [145] = 300,
            [146] = 200,
            [147] = 150,
            [148] = 250,
            [149] = 150,
            [150] = 500,
            [151] = 150,
            [152] = 500,
            [153] = 150,
            [154] = 100,
            [155] = 500,
            [156] = 40,
            [157] = 40,
            [158] = 40,
            [159] = 40,
            [160] = 40,
            [161] = 40,
            [162] = 40,
            [163] = 40,
            [164] = 300,
            [165] = 135,
            [166] = 100,
            [167] = 100,
            [168] = 100,
            [169] = 150,
            [170] = 100,
            [171] = 100
        }

        priceHat = {
            [226] = 150,
            [227] = 200,
            [228] = 100,
            [229] = 100,
            [230] = 150,
            [231] = 50,
            [232] = 20,
            [233] = 20,
            [234] = 20,
            [235] = 20,
            [236] = 20,
            [237] = 20,
            [238] = 20,
            [239] = 20,
            [240] = 20,
            [241] = 20,
            [242] = 20
        }

        priceGlass = {
            [1] = 20,
            [2] = 20,
            [3] = 20,
            [4] = 20,
            [5] = 20,
            [6] = 50,
            [7] = 20,
            [8] = 20,
            [9] = 20,
            [10] = 20,
            [11] = 50,
            [12] = 20,
            [13] = 20,
            [14] = 20,
            [15] = 50,
            [16] = 20,
            [17] = 20,
            [18] = 20,
            [19] = 20,
            [20] = 20,
            [21] = 20,
            [22] = 20,
            [23] = 20,
            [24] = 20,
            [25] = 20,
            [26] = 20,
            [27] = 20,
            [28] = 20,
            [29] = 20,
            [30] = 20,
            [31] = 20,
            [32] = 20,
            [33] = 20,
            [34] = 20,
            [35] = 20,
            [36] = 20,
            [37] = 20,
            [38] = 20,
            [39] = 20,
            [40] = 20,
            [41] = 20,
            [42] = 20,
            [43] = 20,
            [44] = 20,
            [45] = 20,
            [46] = 20,
            [47] = 20,
            [48] = 20,
            [49] = 20,
            [50] = 20,
            [51] = 20,
            [52] = 20,
            [53] = 20,
            [54] = 20,
            [55] = 20,
            [56] = 20,
            [57] = 20,
            [58] = 60,
            [59] = 200,
            [60] = 150,
            [61] = 50,
            [62] = 50,
            [63] = 200,
            [64] = 200,
            [65] = 50,
            [66] = 50,
            [67] = 100,
            [68] = 200,
            [69] = 150,
            [70] = 20,
            [71] = 20,
            [72] = 70,
            [73] = 150,
            [74] = 75,
            [75] = 175,
            [76] = 300,
            [77] = 225,
            [78] = 65,
            [79] = 65,
            [80] = 65
        }

        priceBag = {
            [111] = 200,
            [112] = 200,
            [113] = 200,
            [125] = 200,
            [129] = 200,
            [134] = 200,
            [135] = 200,
            [139] = 200,
            [152] = 100,
            [174] = 200,
            [175] = 200,
            [176] = 200,
            [177] = 200,
            [178] = 200,
            [179] = 30,
            [180] = 30,
            [181] = 30,
            [182] = 30,
            [183] = 30,
            [184] = 30,
            [185] = 200,
            [186] = 150,
            [187] = 350,
            [188] = 350,
            [189] = 250,
            [190] = 250,
            [191] = 200,
            [192] = 200
        }
    end

    if isPlayerPed() then
        DataSendBinco.buttons = {
            {
                name = 'Hauts',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/tshirt.svg',
                hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'pHauts'
                    },
                    {
                        name = 'pVariations'
                    }
                }
            },
            {
                name = 'Bas',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/jeans.svg',
                hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'pBas'
                    },
                    {
                        name = 'pVariations'
                    }
                }
            },
            {
                name = 'Accessoires',
                width = 'full',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/shoe.svg',
                hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'pAccessoires'
                    },
                    {
                        name = 'pVariations'
                    }
                }
            },
            {
                name = 'Chapeaux',
                width = 'half',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/hat.svg',
                hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'pChapeaux'
                    },
                    {
                        name = 'pVariations'
                    }
                }
            },
            {
                name = 'Lunettes',
                width = 'half',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/glasses.svg',
                hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'pLunettes'
                    },
                    {
                        name = 'pVariations'
                    }
                }
            },
        }
    else
        DataSendBinco.buttons = {
            {
                name = 'Hauts',
                width = 'full',
                hoverStyle = 'stroke-black',
                --image = 'https://cdn.discordapp.com/attachments/1063934823976144966/1143950049479512174/bd49bb3f81599c1dd8840e5935b016d3.webp',
                type = 'coverBackground',
                image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/hautEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' ..
                playerType .. '/tshirt.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'Hauts'
                    },
                    {
                        name = 'Variations'
                    },
                    --{
                    --    name= 'Sous-haut',
                    --},
                    --{
                    --    name= 'Variations 2'
                    --},
                    --{
                    --    name= 'Bras'
                    --},
                    --{
                    --    name= 'Variations 3'
                    --}
                }
            },
            {
                name = 'Bas',
                width = 'full',
                hoverStyle = 'stroke-black',
                --image = 'https://media.discordapp.net/attachments/498529074717917195/1144393305195552768/image.webp',
                type = 'coverBackground',
                image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/basEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType ..
                '/jeans.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'Bas'
                    },
                    {
                        name = 'Variations'
                    }
                }
            },
            {
                name = 'Chaussures',
                width = 'half',
                hoverStyle = 'stroke-black',
                --image = 'https://media.discordapp.net/attachments/498529074717917195/1144393364926627913/image.webp',
                type = 'coverBackground',
                image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/chaussuresEUP.webp' or
                'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/shoe.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'Chaussures'
                    },
                    {
                        name = 'Variations'
                    }
                }
            },
            {
                name = 'Chapeaux',
                width = 'full',
                hoverStyle = 'stroke-black',
                --image = 'https://media.discordapp.net/attachments/498529074717917195/1144393779575541780/image.webp',
                type = 'coverBackground',
                width = 'half',
                image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/chapeauxEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' ..
                playerType .. '/hat.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'Chapeaux'
                    },
                    {
                        name = 'Variations'
                    }
                }
            },
            {
                name = 'Lunettes',
                width = 'half',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/glasses.webp',
                --hoverStyle = 'fill-black stroke-black',
                hoverStyle = 'stroke-black',
                --image = 'https://media.discordapp.net/attachments/498529074717917195/1144394033012162610/image.webp',
                type = 'coverBackground',
                price = 20,
                progressBar = {
                    {
                        name = 'Lunettes'
                    },
                    {
                        name = 'Variations'
                    }
                }
            },
            {
                name = 'Sacs',
                width = 'half',
                hoverStyle = 'stroke-black',
                --image = 'https://media.discordapp.net/attachments/498529074717917195/1144393559659778078/image.webp',
                type = 'coverBackground',
                image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/sacEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/' .. playerType .. '/bag.webp',
                --hoverStyle = 'fill-black stroke-black',
                price = 20,
                progressBar = {
                    {
                        name = 'Sacs'
                    },
                    {
                        name = 'Variations'
                    }
                }
            },
            {
                name = 'Cou',
                width = 'half',
                hoverStyle = 'stroke-black',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951144393442533838939image.webp',
                type = 'coverBackground',
                price = 20,
                progressBar = {
                    {
                        name = 'Cou'
                    },
                    {
                        name = 'Variations'
                    }
                }
            },
            {
                name = 'Manuel',
                subName = "Gants, sous-haut",
                width = 'half',
                hoverStyle = 'stroke-black',
                -- Opérateur ternaire vu que je suis un goat
                image = playerType == "Homme" and
                'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951166695161590468649image.webp' or
                'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951166695371293073488image.webp',
                type = 'coverBackground',
                price = 50,
                progressBar = {
                    {
                        name = 'Autres'
                    },
                    {
                        name = 'Variations'
                    },
                    {
                        name = 'Sous-haut',
                    },
                    {
                        name = 'Variations 2'
                    },
                    {
                        name = 'Bras'
                    },
                    {
                        name = 'Variations 3'
                    }
                }
            },
        }

        if isjob then
            table.insert(DataSendBinco.buttons, {
                name = 'Kevlar',
                width = 'half',
                hoverStyle = 'stroke-black',
                type = 'coverBackground',
                image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/hautEUP.webp',
                price = 20,
                progressBar = {
                    {
                        name = 'Kevlar'
                    },
                }
            })
        end
    end


    --[[
        Pour les sans PED
        ]]
    -- Kevlar
    local kevlarsItem = {
        "kevlarle",
        "kevlarm",
        "kevlarlo",
        "lspdgiletj",
        "lspdkevle1",
        "lspdkevle2",
        "lspdkevle3",
        "lspdriot",
        "lspdkevm1",
        "lspdkevlo1",
        "lspdkevlo2",
        "lspdkevlo3",
        "lspdkevlourd",
        "lspdkevnegotiator",
        "lspdkevpc",
        "lspdkevpc2",
        "lspdgnd",
        "lspdswat",
        "lspdswat2",
        "lspdcnt1",
        "ussskev1",
        "ussskev2",
        "ussskev3",
        "ussskev4",
        "lssdkevlo1",
        "lssdkevlo2",
        "lssdkevlo3",
        "lssdkevlo4",
        "lssdkevlo5",
        "lssdkevlo6",
        "lssdkevlo7",
        "usbpkevlo1",
        "usbpkevlo2",
        "usbpkevlo3",
        "usbpkevlo4",
        "usbpkevlo5",
        "usbpkevpc",
        "dojkev",
        "gouvkev",
        "gouvernorkev",
        "irskev",
        "irscikev",
        "boikev",
        "samskev",
        "samskev2",
        "samskev3",
        "samskev4",
        "samskev5",
        "g6kev",
        "g6kev2",
        "lsfdkev",
        "lsfdkev2",
        "lsfdkev3",
        "lsfdkev4",
        "lsfdkev5",
        "wzkev",
        "keville1",
        "keville2",
        "keville3",
        "keville4",
        "keville5",
        "keville6",
        "keville7",
        "keville8",
        "keville9",
        "keville10",
        "keville11",
    }
    for k, v in pairs(kevlarsItem) do
        table.insert(DataSendBinco.catalogue,
            { id = k, price = 10, name = v, label = GetItemLabel(v), image = "https://cdn.sacul.cloud/v2/vision-cdn/inventory/items/" .. v .. ".webp", category =
            "Kevlar", subCategory = "Kevlar", idVariation = k })
    end

	local baseURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex
	
    -- Pantalon
    for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)-1 do
		if not tableContains(BanLeg, i) then
			local price = 40
			if priceLeg[i] ~= nil then price = priceLeg[i] end
			local drawableURL = baseURL .. "/clothing/leg/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Bas", subCategory="Bas", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 4, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")


				table.insert(DataSendBinco.catalogue, {id = z, label=z, price=666, image=imageURL, category="Bas", subCategory="Variations", targetId=i })
			end
		end
	end
    -- Chaussures
    for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 6)-1 do
		if not tableContains(BanShoes, i) then
			local price = 40
			if priceShoes[i] ~= nil then price = priceShoes[i] end
			local drawableURL = baseURL .. "/clothing/shoes/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Chaussures", subCategory="Chaussures", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 6, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Chaussures", subCategory="Variations", targetId=i })
			end
		end
	end
    -- Hauts
    table.insert(DataSendBinco.catalogue, { id = 15, price = 35, label = 1, image = "https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category = "Hauts", subCategory = "Hauts", idVariation = 15 })
    for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 11)-1 do
		if not tableContains(BanTop, i) then
			local price = 35
			if priceTop[i] ~= nil then price = priceTop[i] end
			local drawableURL = baseURL .. "/clothing/torso2/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Hauts", subCategory="Hauts", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 11, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Hauts", subCategory="Variations", targetId=i })
			end
		end
	end
    -- Soushaut
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 8)-1 do
		if not tableContains(BanSous, i) then
			local drawableURL = baseURL .. "/clothing/undershirt/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = 150, label=i, image=drawableURL, category="Hauts", subCategory="Sous-haut", idVariation=i}) 
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 8, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Hauts", subCategory="Variations 2", targetId=i })
			end
		end
	end
    -- Bras
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1 do
		if not tableContains(BanArm, i) then
			table.insert(DataSendBinco.catalogue, {id = i, price = 150, label=i, image=" pas d'image ici :> ", category="Hauts", subCategory="Bras", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i) do
				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=" pas d'image ici :> ",  category="Hauts", subCategory="Variations 3", targetId=i })
			end
		end
	end
    -- Cou
    if playerType == "Homme" then 
		for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 7)-1 do 
			if not tableContains(BanCou, i) then 
				local drawableURL = baseURL .. "/clothing/accessory/" .. i .. ".webp"

				table.insert(DataSendBinco.catalogue, {id = i, price = 50, label=i, image=drawableURL, category="Cou", subCategory="Cou", idVariation=i})
				for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i) do
					local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

					table.insert(DataSendBinco.catalogue, {id = z, label=z, price = 50, image=imageURL,  category="Cou", subCategory="Variations", targetId=i })
				end
			end
		end
	else
		for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 7)-1 do 
			if not tableContains(BanCou, i) then 
				local drawableURL = baseURL .. "/clothing/accessory/" .. i .. ".webp"

				table.insert(DataSendBinco.catalogue, {id = i, price = 50, label=i, image=drawableURL, category="Cou", subCategory="Cou", idVariation=i})
				for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i) do
					local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

					table.insert(DataSendBinco.catalogue, {id = z, label=z, price = 50, image=imageURL,  category="Cou", subCategory="Variations", targetId=i })
				end
			end
		end
	end

    -- Autres
    -- Hauts
    for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 11)-1 do
		if not tableContains(BanTop, i) then
			local price = 35
			if priceTop[i] ~= nil then price = priceTop[i] end
			local drawableURL = baseURL .. "/clothing/torso2/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Manuel", subCategory="Autres", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 11, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image= imageURL, category="Manuel", subCategory="Variations", targetId=i })
			end
		end
	end
    -- SousHauts
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 8)-1 do
		if not tableContains(BanSous, i) then
			local drawableURL = baseURL .. "/clothing/undershirt/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = 50, label=i, image=drawableURL, category="Manuel", subCategory="Sous-haut", idVariation=i}) 
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 8, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")
				
				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Manuel", subCategory="Variations 2", targetId=i })
			end
		end
	end
    -- Bras
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1 do
		if not tableContains(BanArm, i) then
			local drawableURL = baseURL .. "/clothing/torso/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = 50, label=i, image=drawable, category="Manuel", subCategory="Bras", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL,  category="Manuel", subCategory="Variations 3", targetId=i })
			end
		end
	end


    -- Chapeaux
    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0)-1 do
		if not tableContains(BanHat, i) then
			local price = 20
			if priceHat[i] ~= nil then price = priceHat[i] end
			local drawableURL = baseURL .. "/props/hat/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Chapeaux", subCategory="Chapeaux", idVariation=i})
			for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Chapeaux", subCategory="Variations", targetId=i })
			end
		end
	end
    -- Lunettes
    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1)-1 do
		if not tableContains(BanGlases, i) then
			local price = 20
			if priceGlass[i] ~= nil then price = priceGlass[i] end
			local drawableURL = baseURL .. "/props/glasses/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Lunettes", subCategory="Lunettes", idVariation=i})
			for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Lunettes", subCategory="Variations", targetId=i })
			end
		end
	end
    -- Sacs
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 5)-1 do
		if not tableContains(BanBag, i) then
			local price = 35
			if priceBag[i] ~= nil then price = priceBag[i] end
			local drawableURL = baseURL .. "/clothing/bag/" .. i .. ".webp"

			table.insert(DataSendBinco.catalogue, {id = i, price = price, label=i, image=drawableURL, category="Sacs", subCategory="Sacs", idVariation=i})
			for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 5, i) do
				local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

				table.insert(DataSendBinco.catalogue, {id = z, label=z, image=imageURL, category="Sacs", subCategory="Variations", targetId=i })
			end
		end
	end

    --table.insert(DataSendBinco.catalogue, {id = 0, price = 150, label="1", image="https://cdn.sacul.cloud/v2/vision-cdn/Binco/"..playerType.."/Chapeaux/1_1.webp", category="Cou", subCategory="Cou", idVariation=0})


    --[[
        Pour les PED
        ]]
        --Pantalons
        for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)-1 do
            --if not tableContains(BanLeg, i) then
                table.insert(DataSendBinco.catalogue, {id = i, label=i, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/clothing/leg/" .. i .. ".webp", category="Bas", subCategory="pBas", idVariation=i})
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 4, i) do
                    table.insert(DataSendBinco.catalogue, {id = z, label=z, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/clothing/leg/" .. i .. "_" .. z - 1 .. ".webp", category="Bas", subCategory="pVariations", targetId=i })
                end
            --end
        end
        -- Hauts
        for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1 do
            --if not tableContains(BanTop, i) then
                table.insert(DataSendBinco.catalogue, {id = i, label=i, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/clothing/torso2/" .. i .. ".webp", category="Hauts", subCategory="pHauts", idVariation=i})
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i) do
                    table.insert(DataSendBinco.catalogue, {id = z, label=z, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/clothing/torso2/" .. i .. "_" .. z - 1 .. ".webp", category="Hauts", subCategory="pVariations", targetId=i })
                end
            --end
        end
        for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 8)-1 do
            --if not tableContains(BanTop, i) then
                table.insert(DataSendBinco.catalogue, {id = i, label=i, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/clothing/torso2/" .. i .. ".webp", category="Accessoires", subCategory="pAccessoires", idVariation=i})
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 8, i) do
                    table.insert(DataSendBinco.catalogue, {id = z, label=z, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/clothing/torso2/" .. i .. "_" .. z - 1 .. ".webp", category="Accessoires", subCategory="pVariations", targetId=i })
                end
            --end
        end
        -- Chapeaux
        if GetEntityModel(PlayerPedId()) == 2064532783 then
            for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 0) do
                --if not tableContains(BanHat, i) then
                    table.insert(DataSendBinco.catalogue, {id = i, label=i, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/props/hat/" .. i .. ".webp", category="Chapeaux", subCategory="pChapeaux", idVariation=i})
                    for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, i) do
                        table.insert(DataSendBinco.catalogue, {id = z, label=z, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/props/hat/" .. i .. "_" .. z - 1 .. ".webp", category="Chapeaux", subCategory="pVariations", targetId=i })
                    end
                --end
            end
        else
            for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 0)-1 do
				table.insert(DataSendBinco.catalogue, {id = i, label=i, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/props/hat/" .. i .. ".webp", category="Chapeaux", subCategory="pChapeaux", idVariation=i})
				for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, i) do
					table.insert(DataSendBinco.catalogue, {id = z, label=z, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/props/hat/" .. i .. "_" .. z - 1 .. ".webp", category="Chapeaux", subCategory="pVariations", targetId=i })
				end
            end
        end
        -- Lunettes
        for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1)-1 do
			table.insert(DataSendBinco.catalogue, {id = i, label=i, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/props/glasses/" .. i .. ".webp", category="Lunettes", subCategory="pLunettes", idVariation=i})
			for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, i) do
				table.insert(DataSendBinco.catalogue, {id = z, label=z, image="https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex .. "/props/glasses/" .. i .. "_" .. z - 1 .. ".webp", category="Lunettes", subCategory="pVariations", targetId=i })
			end
        end
        -- Accesoire
    return true
end



RegisterNUICallback("MenuBinco", function(data)
    local choise = {}
    print("data", json.encode(data))
    if isPlayerPed() then
        if data.selections[1].category == "Hauts" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ptshirt", 1, {
                    renamed = "Haut N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })

                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut pour ~s " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Bas" then
            if p:pay(tonumber(DataSendBinco.buttons[2].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "ppant", 1, {
                    renamed = "Bas N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })

                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un bas pour ~s " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Chapeaux" then
            if p:pay(tonumber(DataSendBinco.buttons[4].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "phat", 1, {
                    renamed = "Chapeau N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })

                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un chapeau pour ~s " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Lunettes" then
            if p:pay(tonumber(DataSendBinco.buttons[5].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "pglasses", 1, {
                    renamed = "Lunettes N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })

                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter des lunettes pour ~s " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Accessoires" then
            if p:pay(tonumber(DataSendBinco.buttons[3].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "paccs", 1, {
                    renamed = "Accessoires N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })

                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un bas pour ~s " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
    else
        if data.selections[1].category == "Autres" or data.selections[1].category == "Manuel" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Haut N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[2].id - 1,
                    drawableArmsId = data.selections[5].id,
                    variationArmsId = data.selections[6].id - 1,
                    drawableTshirtId = data.selections[3].id,
                    variationTshirtId = data.selections[4].id - 1
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'adapter vos bras pour " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Kevlar" then
            TriggerSecurGiveEvent("core:addItemToInventory", token, data.selections[1].name, 1, {})
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "~c Vous avez récupéré votre kevlar"
            })
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
        end
        if data.selections[1].category == "Hauts" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Haut N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[2].id - 1,
                    drawableArmsId = ClothsList[playerType]["Haut"][tostring(data.selections[1].id)],
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut pour ~s " .. DataSendBinco.buttons[1].price .. "$"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Shirts" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "T-Shirt N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = 11,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Polo" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Polo N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = 0,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Pulls" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Pull N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = 1,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Croptop" then
            local arms = 281
            if data.selections[1].id == 714 then
                arms = 281
            elseif data.selections[1].id == 717 or data.selections[1].id == 718 then
                arms = 280
            else
                arms = 279
            end
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Croptop N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = arms,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "SacsFemmes" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "access", 1, {
                    renamed = "Jupe N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[1].idVdariationed - 1, --
                    name = "sac",
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter une jupe"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "HautsFemmes" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                local arms = 4
                if data.selections[1].id == 719 or data.selections[1].id == 726 or data.selections[1].id == 722 then
                    arms = 278
                elseif data.selections[1].id == 721 then
                    arms = 277
                elseif data.selections[1].id == 720 then
                    arms = 279
                elseif data.selections[1].id == 736 then
                    arms = 0
                elseif data.selections[1].id == 737 then
                    arms = 1
                elseif data.selections[1].id == 732 then
                    arms = 7
                end
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Haut N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = arms,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Robes" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                local arms = 4
                if data.selections[1].id == 738 then
                    arms = 279
                elseif data.selections[1].id == 755 or data.selections[1].id == 756 or data.selections[1].id == 729 or data.selections[1].id == 728 or data.selections[1].id == 731 then
                    arms = 282
                elseif data.selections[1].id == 725 or data.selections[1].id == 727 then
                    arms = 280
                end
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Robes N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = arms,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "BasFemmes" then
            if p:pay(tonumber(DataSendBinco.buttons[2].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "pant", 1, {
                    renamed = "Pantalon N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1,
                    premium = true
                })

                -- ShowNotification("Vous venez d'acheter un pantalon pour ~g~"..DataSendBinco.buttons[2].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter un pantalon pour ~s " .. DataSendBinco.buttons[2].price .. "$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Sweat" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Sweat N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = 4,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un haut"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Casquette" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "hat", 1, {
                    renamed = "Casquette N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[1].idVdariationed - 1, --
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter une casquette"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Maillots" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                        renamed = "Maillot N°" .. data.selections[1].id,
                        drawableTorsoId = data.selections[1].id,
                        variationTorsoId = data.selections[1].idVdariationed - 1, --
                        drawableArmsId = 0,
                        variationArmsId = 0,
                        drawableTshirtId = 15,
                        variationTshirtId = 0,
                        premium = true
                    })
                else
                    local arms = 279
                    if data.selections[1].id == 724 or data.selections[1].id == 753 then
                        arms = 280
                    end
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                        renamed = "Maillot N°" .. data.selections[1].id,
                        drawableTorsoId = data.selections[1].id,
                        variationTorsoId = data.selections[1].idVdariationed - 1, --
                        drawableArmsId = arms,
                        variationArmsId = 0,
                        drawableTshirtId = 15,
                        variationTshirtId = 0,
                        premium = true
                    })
                end
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter un maillot"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Chemises" then
            if p:pay(tonumber(DataSendBinco.buttons[1].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Chemise N°" .. data.selections[1].id,
                    drawableTorsoId = data.selections[1].id,
                    variationTorsoId = data.selections[1].idVdariationed - 1, --
                    drawableArmsId = 11,
                    variationArmsId = 0,
                    drawableTshirtId = 15,
                    variationTshirtId = 0,
                    premium = true
                })
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    content = "~c Vous venez d'acheter une chemise"
                })
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            end
        end
        if data.selections[1].category == "Bas" then
            if p:pay(tonumber(DataSendBinco.buttons[2].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "pant", 1, {
                    renamed = "Pantalon N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })

                -- ShowNotification("Vous venez d'acheter un pantalon pour ~g~"..DataSendBinco.buttons[2].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter un pantalon pour ~s " .. DataSendBinco.buttons[2].price .. "$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Chaussures" then
            if p:pay(tonumber(DataSendBinco.buttons[3].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "feet", 1, {
                    renamed = "Chaussures N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })
                -- ShowNotification("Vous venez d'acheter des chaussures pour ~g~"..DataSendBinco.buttons[3].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter des chaussures pour ~s " .. DataSendBinco.buttons[3].price .. "$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Chapeaux" then
            if p:pay(tonumber(DataSendBinco.buttons[4].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "hat", 1, {
                    renamed = "Chapeau N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })
                -- ShowNotification("Vous venez d'acheter un chapeau pour ~g~"..DataSendBinco.buttons[4].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter un chapeau pour ~s " .. DataSendBinco.buttons[4].price .. "$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Lunettes" then
            if p:pay(tonumber(DataSendBinco.buttons[5].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "glasses", 1, {
                    renamed = "Lunettes N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })
                -- ShowNotification("Vous venez d'acheter une paire de lunettes pour ~g~"..DataSendBinco.buttons[5].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter une paire de lunettes pour ~s " ..
                    DataSendBinco.buttons[5].price .. "$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Sacs" then
            if p:pay(tonumber(DataSendBinco.buttons[6].price)) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "access", 1, {
                    renamed = "Sac N°" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1,
                    name = "sac"
                })
                -- ShowNotification("Vous venez d'acheter un sac pour ~g~"..DataSendBinco.buttons[6].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter un sac pour ~s " .. DataSendBinco.buttons[6].price .. "$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
        if data.selections[1].category == "Cou" then
            if p:pay(50) then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "collier", 1, {
                    renamed = "Cou #" .. data.selections[1].id,
                    drawableId = data.selections[1].id,
                    variationId = data.selections[2].id - 1
                })
                -- ShowNotification("Vous venez d'acheter un sac pour ~g~"..DataSendBinco.buttons[6].price.."~s~ $")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'JAUNE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous venez d'acheter un accessoire pour ~s 50$"
                })

                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                local newSkin = GetFakeSkin()
                p:setSkin(newSkin)
                p:saveSkin()
            else
                -- ShowNotification("Vous n'avez pas assez d'argent")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~c Vous n'avez ~s pas assez d'argent"
                })
            end
        end
    end

    if data.selections[1].category == "Metiers" then
        if p:pay(tonumber(20)) then
            local tenue = {
                ['tshirt_1'] = data.selections[1].all.soushaut1,
                ['tshirt_2'] = data.selections[1].all.soushaut2,
                ['torso_1'] = data.selections[1].all.haut1,
                ['torso_2'] = data.selections[1].all.haut2,
                ['arms'] = data.selections[1].all.bras1,
                ['arms_2'] = data.selections[1].all.bras2,
                ['pants_1'] = data.selections[1].all.bas1,
                ['pants_2'] = data.selections[1].all.bas2,
                ['shoes_1'] = data.selections[1].all.shoes1,
                ['shoes_2'] = data.selections[1].all.shoes2,
                ['bags_1'] = data.selections[1].all.sac1,
                ['bags_2'] = data.selections[1].all.sac2,
                --['chain_1'] = skin['chain_1'],
                --['chain_2'] = skin['chain_2'],
                ['helmet_1'] = data.selections[1].all.helmet1,
                ['helmet_2'] = data.selections[1].all.helmet2,
                --['ears_1'] = skin['ears_1'],
                --['ears_2'] = skin['ears_2'],
                --['mask_1'] = skin['mask_1'],
                --['mask_2'] = skin['mask_2'],
                --['glasses_1'] = skin['glasses_1'],
                --['glasses_2'] = skin['glasses_2'],
                --['bproof_1'] = skin['bproof_1'],
                --['bproof_2'] = skin['bproof_2'],
            }
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                { renamed = data.selections[1].all.name, data = tenue })

            exports['vNotif']:createNotification({
                type = 'JAUNE',
                content = "~c Vous venez d'acheter une tenue pour ~s 20$"
            })
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                content = "~c Vous n'avez ~s pas assez d'argent"
            })
        end
    end
end)

local function OpenPremiumData(data, typehabit, labelH, idVetement, typePath)
    local playerType = "Homme"
    if isPlayerPed() then --C'est un ped
        DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/inventory/glasses.svg'
        playerType = "Ped"
    elseif p:skin().sex == 0 then
        DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
        playerType = "Homme"
    elseif p:skin().sex == 1 then
        DataSendBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
        playerType = "Femme"
    end
    DataSendBinco.headerIconName = typehabit
    DataSendBinco.buttons = {}
    DataSendBinco.buttons = {
        {
            name = typehabit,
            width = 'full',
            price = 100,
            hoverStyle = 'stroke-black',
            image = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/11439939849565184921154360683165663282MAILLOTS.webp',
            type = 'coverBackground',
            progressBar = {
                {
                    name = typehabit
                },
            }
        },
    }
    DataSendBinco.catalogue = {}
    DataSendBinco.forceCategory = typehabit

    if typehabit == "Casquette" then
        if type(idVetement) == "number" then
            local iM = idVetement
            for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, iM) do
                table.insert(DataSendBinco.catalogue,
                    { id = iM, price = 100, isPremium = true, label = z, image = "https://cdn.sacul.cloud/v2/vision-cdn/Binco/" ..
                    typePath .. "/" .. iM .. "_1.webp", category = typehabit, subCategory = typehabit, targetId = i, idVdariationed =
                    z })
            end
        elseif type(idVetement) == "table" then
            for k, v in pairs(idVetement) do
                --print("v", v)
                for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, v) do
                    --print("insert", v, z)
                    table.insert(DataSendBinco.catalogue,
                        { id = v, price = 100, isPremium = true, label = z, image =
                        "https://cdn.sacul.cloud/v2/vision-cdn/Binco/" .. typePath .. "/" .. v .. "_" .. z .. ".webp", category =
                        typehabit, subCategory = typehabit, targetId = i, idVdariationed = z })
                end
            end
        end
    else
        if type(idVetement) == "number" then
            local iM = idVetement
            for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 11, iM) do
                table.insert(DataSendBinco.catalogue,
                    { id = iM, price = 100, isPremium = true, label = z, image = "https://cdn.sacul.cloud/v2/vision-cdn/Binco/" ..
                    typePath .. "/" .. iM .. "_1.webp", category = typehabit, subCategory = typehabit, targetId = i, idVdariationed =
                    z })
            end
        elseif type(idVetement) == "table" then
            for k, v in pairs(idVetement) do
                for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 11, v) do
                    table.insert(DataSendBinco.catalogue,
                        { id = v, price = 100, isPremium = true, label = z, image =
                        "https://cdn.sacul.cloud/v2/vision-cdn/Binco/" .. typePath .. "/" .. v .. "_" .. z .. ".webp", category =
                        typehabit, subCategory = typehabit, targetId = i, idVdariationed = z })
                end
            end
        end
    end
    DataSendBinco.user.currentSubscription = p:getSubscription()
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    DataSendBinco.showTurnAroundButtons = true
    Wait(50)
    ClothShop.open = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuBinco',
        data = DataSendBinco
    }))
    CreateCameraBinco("Hauts")
    SetNuiFocusKeepInput(true)
    FreezeEntityPosition(PlayerPedId(), true)
    CreateThread(function()
        while ClothShop.open do
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
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
            if IsDisabledControlJustPressed(0, 194) or IsControlJustPressed(0, 194) then
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
                Wait(100)
                forceHideRadar()
                zone.hideNotif(ClothShopId)
                Bulle.hide(ClothShopId)
                DataSendOpenBinco.forceCategory = true
                DataSendOpenBinco.isPremium = p:getSubscription()
                DataSendOpenBinco.sex = playerType
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'MenuPreBinco',
                    data = DataSendOpenBinco
                }))
            end
            if IsDisabledControlPressed(0, 38) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 1.5)
            end
            if IsDisabledControlPressed(0, 44) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 1.5)
            end
        end
    end)
    forceHideRadar()
    zone.hideNotif(ClothShopId)
    Bulle.hide(ClothShopId)
end


RegisterNUICallback("BincoBoutiqueFA", function(data)
    print("data.button", data.button)
    if data.button == "vetement" then
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        OpenClothShopUI()
    elseif data.button == "premium-polos" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Polo", "Polo", PolosPremium, "Hauts", "Homme")
        end
    elseif data.button == "premium-shirts" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Shirts", "T-Shirt", ShirtsPremium, "Hauts", "Homme")
        end
    elseif data.button == "premium-sweats" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Sweat", "Sweat", SweatPremium, "Hauts", "Homme")
        end
    elseif data.button == "premium-pulls" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Pulls", "Pull", PullPremium, "Hauts", "Homme")
        end
    elseif data.button == "premium-maillots" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Maillots", "Maillot", MaillotsPremium, "Hauts", "Homme")
        else
            OpenPremiumData(data, "Maillots", "Maillot", MaillotsFemmePremium, "HautsFemmes", "Femme")
        end
    elseif data.button == "premium-chemises" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Chemises", "Chemises", ChemisesPremium, "Hauts", "Homme")
        end
    elseif data.button == "premium-chapeaux" then
        if GetEntityModel(PlayerPedId()) == `mp_m_freemode_01` then
            OpenPremiumData(data, "Casquette", "Casquette", CasquettesPremium, "Accessoires", "Homme")
        end
    elseif data.button == "premium-croptop" then
        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            OpenPremiumData(data, "Croptop", "Croptop", CroptopPremium, "Croptop", "Femme")
        end
    elseif data.button == "premium-hauts" then
        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            OpenPremiumData(data, "HautsFemmes", "HautsFemmes", HautsFemmePremium, "HautsFemmes", "Femme")
        end
    elseif data.button == "premium-jupes" then
        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            OpenPremiumData(data, "SacsFemmes", "SacsFemmes", JupesPremium, "Jupes", "Femme")
        end
    elseif data.button == "premium-robes" then
        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            OpenPremiumData(data, "Robes", "Robes", RobesPremium, "Robes", "Femme")
        end
    elseif data.button == "premium-pantalons" then
        if GetEntityModel(PlayerPedId()) == `mp_f_freemode_01` then
            OpenPremiumData(data, "Bas", "Bas", PantalonsFemmePremium, "BasFemmes", "Femme")
        end
    elseif data.button == "tenues" then
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        OpenTenuesShopUI()
    elseif data.button == "create" then
        local tenueName = data.name
        if p:getSubscription() >= 1 then
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            local skin = SkinChangerGetSkin()
            local tenue = {
                ['tshirt_1'] = skin["tshirt_1"],
                ['tshirt_2'] = skin["tshirt_2"],
                ['torso_1'] = skin["torso_1"],
                ['torso_2'] = skin["torso_2"],
                ['decals_1'] = skin["decals_1"],
                ['decals_2'] = skin["decals_2"],
                ['arms'] = skin["arms"],
                ['arms_2'] = skin["arms_2"],
                ['pants_1'] = skin["pants_1"],
                ['pants_2'] = skin["pants_2"],
                ['shoes_1'] = skin["shoes_1"],
                ['shoes_2'] = skin["shoes_2"],
                ['bags_1'] = skin['bags_1'],
                ['bags_2'] = skin['bags_2'],
                ['chain_1'] = skin['chain_1'],
                ['chain_2'] = skin['chain_2'],
                ['helmet_1'] = skin['helmet_1'],
                ['helmet_2'] = skin['helmet_2'],
                ['ears_1'] = skin['ears_1'],
                ['ears_2'] = skin['ears_2'],
                ['mask_1'] = skin['mask_1'],
                ['mask_2'] = skin['mask_2'],
                ['glasses_1'] = skin['glasses_1'],
                ['glasses_2'] = skin['glasses_2'],
                ['bproof_1'] = skin['bproof_1'],
                ['bproof_2'] = skin['bproof_2'],
            }
            TriggerSecurGiveEvent("core:addItemToInventory", token, "outfit", 1,
                { renamed = tenueName, premium = true, data = tenue })
            -- ShowNotification("Vous venez de récupérer une tenue")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous venez de récupérer ~s une tenue"
            })
            zone.showNotif(ClothShopId)
            Bulle.show(ClothShopId)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous devez avoir le premium pour pouvoir créer une tenue"
            })
        end
    end
end)


DataSendOpenBinco = {}

DataSendBinco = {
    catalogue = {},
    headerIconName = nil,
    headerIcon = nil,
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/binco.webp',
    hideItemList = { 'Bras', 'Variations 3', 'pHauts', 'pVariations', 'pBas', 'pAccessoires', 'pChapeaux', 'pLunettes' },
    showTurnAroundButtons = true,
    user = {
        currentSubscription = 0
    }
}

OpenClothShopUIBefore = function(isjob, ids, vbans)
    if isjob then
        if p:getJob() ~= isjob then
            return
        end
        VarIsJob = {}
        VarIsJob.isjob = isjob
        VarIsJob.ids = ids
        VarIsJob.vbans = vbans
    end
    local bool = GetDatas(isjob, ids, vbans)
    if not isPlayerPed() then
        local Skin = p:skin()
        ApplySkinFake(Skin)
    end
    DataSendOpenBinco.headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp'
    if isPlayerPed() then --C'est un ped
        DataSendOpenBinco.headerIconName = 'Binco Ped'
    elseif p:skin().sex == 0 then
        DataSendOpenBinco.headerIconName = 'Binco Homme'
    elseif p:skin().sex == 1 then
        DataSendOpenBinco.headerIconName = 'Binco Femme'
    else
        DataSendOpenBinco.headerIconName = 'Binco'
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    forceHideRadar()
    ClothShop.open = true
    DataSendOpenBinco.forceCategory = false
    DataSendOpenBinco.hidePremium = true -- TODO faire les vetements premium mdr
    DataSendOpenBinco.isPremium = p:getSubscription()
    DataSendOpenBinco.sex = playerType
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuPreBinco',
        data = DataSendOpenBinco
    }))
end

OpenTenuesShopUI = function()
    local bool = GetDatasTenues()
    DataSendBinco.user.currentSubscription = p:getSubscription()
    while not bool do
        Wait(1)
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    ClothShop.open = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuBinco',
        data = DataSendBinco
    }))
    forceHideRadar()
    SetNuiFocusKeepInput(true)
    FreezeEntityPosition(PlayerPedId(), true)
    CreateThread(function()
        while ClothShop.open do
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
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
            if IsDisabledControlPressed(0, 38) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 1.5)
            end
            if IsDisabledControlPressed(0, 44) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 1.5)
            end
            if IsControlJustPressed(0, 211) then
                RegisterNUICallback("focusOut", function(data, cb)
                    if ClothShop.open then
                        VarIsJob = false
                        if isPlayerPed() ~= 1885233650 then
                            if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
                                ClearPedTasks(PlayerPedId())
                            end
                            SetNuiFocusKeepInput(false)
                            TriggerScreenblurFadeOut(0.5)
                            DisplayHud(true)
                            openRadarProperly()
                            RenderScriptCams(false, false, 0, 1, 0)
                            FreezeEntityPosition(PlayerPedId(), false)
                            ClothShop.open = false
                            ClothShop.cam = nil
                            DestroyCam(ClothShop.cam, false)
                        else
                            local playerSkin = p:skin()
                            ApplySkin(playerSkin)
                            if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
                                ClearPedTasks(PlayerPedId())
                            end
                            SetNuiFocusKeepInput(false)
                            TriggerScreenblurFadeOut(0.5)
                            DisplayHud(true)
                            openRadarProperly()
                            RenderScriptCams(false, false, 0, 1, 0)
                            FreezeEntityPosition(PlayerPedId(), false)
                            ClothShop.open = false
                            ClothShop.cam = nil
                            DestroyCam(ClothShop.cam, false)
                        end
                    end
                end)
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            end
        end
    end)
end

OpenClothShopUI = function()
    local bool
    if VarIsJob then
        bool = GetDatas(VarIsJob.isjob, VarIsJob.ids, VarIsJob.vbans)
    else
        bool = GetDatas()
    end
    DataSendBinco.user.currentSubscription = p:getSubscription()
    while not bool do
        Wait(1)
    end
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(50)
    ClothShop.open = true
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuBinco',
        data = DataSendBinco
    }))
    forceHideRadar()
    SetNuiFocusKeepInput(true)
    FreezeEntityPosition(PlayerPedId(), true)
    CreateThread(function()
        while ClothShop.open do
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
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 44, true)
            if IsDisabledControlPressed(0, 38) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 1.5)
            end
            if IsDisabledControlPressed(0, 44) then
                SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 1.5)
            end
            if IsControlJustPressed(0, 211) then
                RegisterNUICallback("focusOut", function(data, cb)
                    if ClothShop.open then
                        VarIsJob = false
                        if isPlayerPed() ~= 1885233650 then
                            if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
                                ClearPedTasks(PlayerPedId())
                            end
                            SetNuiFocusKeepInput(false)
                            TriggerScreenblurFadeOut(0.5)
                            DisplayHud(true)
                            openRadarProperly()
                            RenderScriptCams(false, false, 0, 1, 0)
                            FreezeEntityPosition(PlayerPedId(), false)
                            ClothShop.open = false
                            ClothShop.cam = nil
                            DestroyCam(ClothShop.cam, false)
                        else
                            local playerSkin = p:skin()
                            ApplySkin(playerSkin)
                            if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
                                IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
                                ClearPedTasks(PlayerPedId())
                            end
                            SetNuiFocusKeepInput(false)
                            TriggerScreenblurFadeOut(0.5)
                            DisplayHud(true)
                            openRadarProperly()
                            RenderScriptCams(false, false, 0, 1, 0)
                            FreezeEntityPosition(PlayerPedId(), false)
                            ClothShop.open = false
                            ClothShop.cam = nil
                            DestroyCam(ClothShop.cam, false)
                        end
                    end
                end)
                SendNuiMessage(json.encode({
                    type = 'closeWebview',
                }))
            end
        end
    end)
end

RegisterNUICallback("focusOut", function(data, cb)
    if ClothShop.open then
        VarIsJob = false
        zone.showNotif(ClothShopId)
        Bulle.show(ClothShopId)
        openRadarProperly()
        if isPlayerPed() then
            if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
                IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
                IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
                ClearPedTasks(PlayerPedId())
            end
            SetNuiFocusKeepInput(false)
            TriggerScreenblurFadeOut(0.5)
            DisplayHud(true)
            openRadarProperly()
            RenderScriptCams(false, false, 0, 1, 0)
            FreezeEntityPosition(PlayerPedId(), false)
            ClothShop.open = false
            ClothShop.cam = nil
            DestroyCam(ClothShop.cam, false)
        else
            local playerSkin = p:skin()
            ApplySkin(playerSkin)
            if IsEntityPlayingAnim(PlayerPedId(), "clothingshirt", "try_shirt_neutral_b", 3) or
                IsEntityPlayingAnim(PlayerPedId(), "clothingshoes", "try_shoes_neutral_d", 3) or
                IsEntityPlayingAnim(PlayerPedId(), "clothingtrousers", "try_trousers_neutral_d", 3) then
                ClearPedTasks(PlayerPedId())
            end
            SetNuiFocusKeepInput(false)
            TriggerScreenblurFadeOut(0.5)
            DisplayHud(true)
            openRadarProperly()
            RenderScriptCams(false, false, 0, 1, 0)
            FreezeEntityPosition(PlayerPedId(), false)
            ClothShop.open = false
            ClothShop.cam = nil
            DestroyCam(ClothShop.cam, false)
        end
    end
end)

RegisterNUICallback("backPreBinco", function()
    -- Close the current UI
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
    Wait(100)
    -- Open prebinco UI
    OpenClothShopUIBefore()
end)

RegisterNUICallback('closePreBinco', function()
    -- Close the current UI
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)

local cloths_pos = {
    -- 1/14
    vector3(-1192.7222900391, -768.48229980469, 16.319890975952),
    vector3(-1201.4796142578, -772.94525146484, 16.316585540771),
    vector3(-1191.4781494141, -775.20910644531, 16.33099937439),

    -- 2/14
    vector3(72.575576782227, -1397.0140380859, 28.673578262329),
    vector3(79.366493225098, -1399.7071533203, 28.374492645264),
    vector3(78.15495300293, -1388.7877197266, 28.375967025757),

    -- 3/14
    vector3(-827.31665039063, -1073.1617431641, 10.625560760498),
    vector3(-826.37152099609, -1080.2418212891, 10.327923774719),
    vector3(-817.45465087891, -1074.4398193359, 10.327934265137),

    -- 4/14
    vector3(-1455.1694335938, -243.12908935547, 48.810997009277),
    vector3(-1447.3118896484, -229.51850891113, 48.804676055908),
    vector3(-1449.1491699219, -243.12033081055, 48.819778442383),

    -- 5/14
    vector3(-706.07836914063, -159.1233215332, 37.415233612061),
    vector3(-713.81811523438, -145.84474182129, 36.415256500244),
    vector3(-707.21813964844, -146.94940185547, 36.415225982666),

    -- 6/14
    vector3(-161.18197631836, -295.82052612305, 39.733341217041),
    vector3(-166.16139221191, -310.37774658203, 38.741817474365),
    vector3(-169.39254760742, -303.32083129883, 38.733371734619),

    -- 7/14
    vector3(125.39266967773, -223.72845458984, 53.557640075684),
    vector3(120.96505737305, -216.70620727539, 53.557670593262),
    vector3(130.26812744141, -215.03092956543, 53.557674407959),

    -- 8/14
    vector3(428.25308227539, -802.14630126953, 28.788578033447),
    vector3(421.25411987305, -799.63726806641, 28.490970611572),
    vector3(422.58068847656, -809.92919921875, 28.490955352783),

    -- 9/14
    vector3(-3171.31640625, 1043.3110351563, 19.86332321167),
    vector3(-3166.0554199219, 1051.7886962891, 19.863340377808),
    vector3(-3174.3806152344, 1049.7766113281, 19.863351821899),

    -- 10/14
    vector3(-1106.0561523438, 2709.8713378906, 18.405288696289),
    vector3(-1104.0347900391, 2703.4291992188, 18.107696533203),
    vector3(-1096.8111572266, 2710.8930664062, 18.107690811157),

    -- 11/14
    vector3(614.91442871094, 2763.8425292969, 41.088199615479),
    vector3(614.48748779297, 2753.3283691406, 41.088260650635),
    vector3(620.37664794922, 2759.1745605469, 41.08825302124),

    -- 12/14
    vector3(1192.6418457031, 2713.0952148438, 37.520042419434),
    vector3(1189.9182128906, 2706.1220703125, 37.222454071045),
    vector3(1200.2528076172, 2707.3637695312, 37.22244644165),

    -- 13/14
    vector3(1696.2141113281, 4827.2836914063, 41.360557556152),
    vector3(1689.6036376953, 4829.0249023438, 41.062942504883),
    vector3(1691.4825439453, 4818.7436523438, 41.062934875488),

    -- 14/14
    vector3(9.7189779281616, 6513.337890625, 31.175296783447),
    vector3(7.5095272064209, 6519.24609375, 30.877670288086),
    vector3(0.30953049659729, 6511.8823242188, 30.877674102783),

	-- place sandy shores
    vector3(1780.78, 3641.32, 34.19),
    vector3(1775.02, 3637.5, 33.89),
    vector3(1780.51, 3631.0, 33.89),
}

ClothShopId = 0

CreateThread(function()
    while zone == nil do
        Wait(1)
    end
    for k, v in pairs(cloths_pos) do
        zone.addZone("cloths_shop" .. k,
            vector3(v.x, v.y, v.z + 0.9),
            "~INPUT_CONTEXT~ Magasin de vêtements",
            function()
                if not ClothShop.open then
                    ClothShopId = "cloths_shop" .. k
                    zone.hideNotif(ClothShopId)
                    Bulle.hide(ClothShopId)
                    exports['tuto-fa']:GotoStep(5)
                    OpenClothShopUIBefore()
                end
            end, false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            5.5,
            true,
            "bulleVetement"
        )
    end

    for k, v in pairs(cloths_pos_services) do
        RequestModel(GetHashKey(v.ped))
        while not HasModelLoaded(GetHashKey(v.ped)) do Wait(1) end
        local ped = CreatePed(4, GetHashKey(v.ped), v.x, v.y, v.z, v.h, false, false)
        SetEntityAsMissionEntity(ped, 1, 1)
        SetEntityInvincible(ped, true)
        SetCanAttackFriendly(ped, false, false)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        zone.addZone("cloths_shopservice" .. k,
            vector3(v.x, v.y, v.z + 1.9),
            "~INPUT_CONTEXT~ Magasin de vêtements",
            function()
                if p:getJob() == v.job then
                    if not ClothShop.open then
                        ClothShopId = "cloths_shopservice" .. k
                        zone.hideNotif(ClothShopId)
                        Bulle.hide(ClothShopId)
                        exports['tuto-fa']:GotoStep(5)
                        OpenClothShopUIBefore(v.job, v.ids, v.bans)
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas le métier nécessaire"
                    })
                end
            end, false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            3.0,
            true,
            "bulleVetement"
        )
    end
end)

function isPlayerPed()
    if GetEntityModel(PlayerPedId()) ~= -1667301416 and GetEntityModel(PlayerPedId()) ~= 1885233650 then
        return true
    else
        return false
    end
end

exports("isPlayerPed", isPlayerPed)
