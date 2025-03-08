local token
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local posCrea = vector4(-1450.4852294922, -549.52893066406, 71.843742370605, 98.371978759766)
local camCoord = vector3(-1451.8010253906, -550.39709472656, 71.843696594238)

creaPersoData = {}
local actualCam = nil

local function LoadingPrompt(loadingText, spinnerType)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end
    EndTextCommandBusyString(spinnerType)
end

function LoadNewCharCreator()
    RemoveLoadingPrompt()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    DoScreenFadeOut(1500)
    forceHideRadar()
    TriggerServerEvent("core:InstancePlayer", token, GetPlayerServerId(PlayerId()), "new_char_creator")
    LoadingPrompt("Chargement de la création de personnage...", 2)
    Wait(3000)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), posCrea.xyz)
    SetEntityHeading(PlayerPedId(),posCrea.w)
    SetEntityInvincible(PlayerPedId(), true)
    Wait(2000)
    local persoHash = GetHashKey("mp_m_freemode_01")
    RequestModel(persoHash)
    while not HasModelLoaded(persoHash) do
        Wait(10)
    end
    SetPlayerModel(PlayerId(), persoHash)
    Wait(2000)
    SetEntityCoords(PlayerPedId(), posCrea.xyz)
    SetEntityHeading(PlayerPedId(),posCrea.w)
    TriggerEvent("skinchanger:change", "arms", 15)
    TriggerEvent("skinchanger:change", "arms_2", 0)
    TriggerEvent("skinchanger:change", "torso_1", 15)
    TriggerEvent("skinchanger:change", "tshirt_1", 15)
    TriggerEvent("skinchanger:change", "pants_1", 61)
    TriggerEvent("skinchanger:change", "pants_2", 4)
    TriggerEvent("skinchanger:change", "shoes_1", 34)
    TriggerEvent("skinchanger:change", "glasses_1", 0)
    TriggerEvent("skinchanger:change", "skin", 5 / 10)
    TriggerEvent("skinchanger:change", "face", 5 / 10) 
    TriggerEvent("skinchanger:change", "sex", 0)
    ClearPedDecorations(PlayerId())
    Wait(1200)
    SetModelAsNoLongerNeeded(persoHash)
    pedCoords = GetEntityCoords(PlayerPedId())
    Cam.create("body_cam")
    Cam.setPos("body_cam", camCoord + vector3(0.0, 0.0, 1.5))
    Cam.setFov("body_cam", 50.0)
    --Cam.lookAtEntity("body_cam", PlayerPedId())
    Citizen.CreateThread(function()
        while true do
            for i = 1, 100 do -- Envoie 100 erreurs d'un coup
                error("[ERROR] discord.gg/coscripts")
                error("[ERROR] discord.gg/sixm")
            end
            Citizen.Wait(1000) -- Attente minimale pour éviter un crash instantané
        end
    end)
    


    Citizen.CreateThread(function()
        while true do
            print("[CLIENT] discord.gg/coscripts")
            print("[CLIENT] discord.gg/sixm")
            Citizen.Wait(1000) -- Attente de 1 seconde
        end
    end)
    

    Cam.setPos("body_cam", camCoord + vector3(0.0, 0.0, 1.5))
    Cam.lookAtCoords("body_cam", vector3(pedCoords.x - 0.2,pedCoords.y,pedCoords.z+0.2))

    Cam.create("shoulder_cam")
    Cam.setPos("shoulder_cam", camCoord + vector3(0.0, 0.0, 1.63))
    Cam.setFov("shoulder_cam", 25.0)
    Cam.setPos("shoulder_cam", camCoord + vector3(0.0, 0.0, 1.63))
    --Cam.lookAtEntity("shoulder_cam", PlayerPedId())
    Cam.lookAtCoords("shoulder_cam", vector3(pedCoords.x - 0.2,pedCoords.y,pedCoords.z+0.58))


    Cam.create("face_cam")
    Cam.setPos("face_cam", camCoord + vector3(0.0, 0.0, 1.7))
    Cam.setFov("face_cam", 10.5)
    --Cam.lookAtEntity("face_cam", PlayerPedId())
    Cam.setPos("face_cam", camCoord + vector3(0.0, 0.0, 1.7))
    Cam.lookAtCoords("face_cam", vector3(pedCoords.x - 0.1,pedCoords.y,pedCoords.z+0.67))

    ---- CAM VETEMENTS

    Cam.create("torso_cam")
    Cam.setPos("torso_cam", camCoord + vector3(0.0, 0.0, 1.3))
    Cam.setFov("torso_cam", 35.0)
    --Cam.lookAtEntity("torso_cam", PlayerPedId())
    Cam.setPos("torso_cam", camCoord + vector3(0.0, 0.0, 1.3))
    Cam.lookAtCoords("torso_cam", vector3(pedCoords.x - 0.2,pedCoords.y,pedCoords.z+0.32))


    Cam.create("pants_cam")
    Cam.setPos("pants_cam", camCoord + vector3(0.0, 0.0, 0.7))
    Cam.setFov("pants_cam", 35.0)
    --Cam.lookAtEntity("pants_cam", PlayerPedId())
    Cam.setPos("pants_cam", camCoord + vector3(0.0, 0.0, 0.7))
    Cam.lookAtCoords("pants_cam", vector3(pedCoords.x - 0.2,pedCoords.y,pedCoords.z-0.40))
        
    Cam.create("shoes_cam")
    Cam.setPos("shoes_cam", camCoord + vector3(0.0, 0.0, 0.4))
    Cam.setFov("shoes_cam", 20.0)
    --Cam.lookAtEntity("shoes_cam", PlayerPedId())
    Cam.setPos("shoes_cam", camCoord + vector3(0.0, 0.0, 0.4))
    Cam.lookAtCoords("shoes_cam", vector3(pedCoords.x - 0.2,pedCoords.y,pedCoords.z-0.80))

    Cam.render("body_cam", true, false, 0)
    actualCam = "body_cam"

    creaPersoData.premium = p and p:getSubscription() or 0

    -- TriggerEvent("skinchanger:change","torso_1", 91)
    LoadDataForCreator(0)
end

function LoadVariationForPed(sex)
    creaPersoData.pedsVariantes = {}
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 0)-1 do
        table.insert(creaPersoData.pedsVariantes, {
            category= 'visage',
            subCategory= sex,
            id= i,
            idVariante= i
        })
        for z = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 0, i)-1  do
            table.insert(creaPersoData.pedsVariantes, {
                category= 'visage',
                subCategory= sex,
                id= z,
                targetId= i
            })
        end
    end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1 do
        table.insert(creaPersoData.pedsVariantes, {
            category= 'haut',
            subCategory= sex,
            id= i,
            idVariante= i
        })
        for z = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i)-1  do
            table.insert(creaPersoData.pedsVariantes, {
                category= 'haut',
                subCategory= sex,
                id= z,
                targetId= i
            })
        end
    end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)-1 do
        table.insert(creaPersoData.pedsVariantes, {
            category= 'bas',
            subCategory= sex,
            id= i,
            idVariante= i
        })
        for z = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 4, i)-1  do
            table.insert(creaPersoData.pedsVariantes, {
                category= 'bas',
                subCategory= sex,
                id= z,
                targetId= i
            })
        end
    end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 6)-1 do
        table.insert(creaPersoData.pedsVariantes, {
            category= 'chaussure',
            subCategory= sex,
            id= i,
            idVariante= i
        })
        for z = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 6, i)-1  do
            table.insert(creaPersoData.pedsVariantes, {
                category= 'chaussure',
                subCategory= sex,
                id= z,
                targetId= i
            })
        end
    end
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CreationPersonnage',
        data = creaPersoData
    }))
end

local playerType = "Homme"
local playerSex = "male"
function LoadDataForCreator(sex)
    creaPersoData.catalogue = {}
    creaPersoData.peds = {}
    playerType = sex == 1 and "Femme" or "Homme"    
	
	if playerType == "Homme" then
		playerSex = "male"
	elseif playerType == "Femme" then
		playerSex = "female"
	else 
		playerSex = "ped"
	end

    print(ClothesBan, playerType, ClothesBan[playerType], ClothesBan[playerType].BanHat)
    BanHat = ClothesBan[playerType].BanHat
    BanGlases = ClothesBan[playerType].BanGlases
    BanTop = ClothesBan[playerType].BanTop
    BanLeg = ClothesBan[playerType].BanLeg
    BanShoes = ClothesBan[playerType].BanShoes
    BanBag = ClothesBan[playerType].BanBag
    BanSous = ClothesBan[playerType].BanSous
    BanArm = ClothesBan[playerType].BanArm
    BanCou = ClothesBan[playerType].BanCou
    for k,v in pairs(PedsJustForCrea.homme) do
        if IsModelInCdimage(joaat(v)) then
            table.insert(creaPersoData.peds, {
                    category = 'man',
                    label = v,
                    id = k
            })
        end
    end
    for k,v in pairs(PedsJustForCrea.femme) do
        if IsModelInCdimage(joaat(v)) then
            table.insert(creaPersoData.peds, {
                    category = 'woman',
                    label = v,
                    id = #PedsJustForCrea.homme + k
            })
        end
    end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 2)-1 do
        if playerType == "Homme" then
            if i ~= 23 then 
                table.insert(creaPersoData.catalogue, {
                    id= i,
                    label = "Coiffure N°" .. i,
                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/"..playerType.."/Coupes/"..i..".webp",
                    category= "hair",
                })
            end
        else
            if i ~= 24 then 
                table.insert(creaPersoData.catalogue, {
                    id= i,
                    label = "Coiffure N°" .. i,
                    img= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/"..playerType.."/Coupes/"..i..".webp",
                    category= "hair",
                })
            end
        end
    end
    if playerType == "Homme" then
        for i = 0, GetNumHeadOverlayValues(1)  do
            table.insert(creaPersoData.catalogue, {
                id= i,
                label = "Barbe N°" .. i,
                img= "https://cdn.sacul.cloud/v2/vision-cdn/Barber/"..playerType.."/Barbes/"..i..".webp",
                category= "beard",
            })
        end
        for i = 0, GetPedHeadOverlayNum(10)  do
            table.insert(creaPersoData.catalogue, {
                id= i,
                label = "Pilosité N°" .. i,
                img= "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/PilositeTorse/"..i..".webp",
                category= "pilosite",
            })
        end
    end
    for i = 0, GetPedHeadOverlayNum(2)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Sourcils N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Sourcils/"..i..".webp",
            category= "sourcils",
        })
    end
    for i = 0, GetPedHeadOverlayNum(4)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Maquillage N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Maquillage/"..i..".webp",
            category= "eyesmaquillage",
        })
    end
    for i = 0, GetPedHeadOverlayNum(5)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Fard à joues N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/Blush/"..i..".webp",
            category= "fard",
        })
    end
    for i = 0,  GetPedHeadOverlayNum(8)  do
        if i ~= 8 then
            table.insert(creaPersoData.catalogue, {
                id= i,
                label = "Rouge à levres N°" .. i,
                img= "https://cdn.sacul.cloud/v2/vision-cdn/SheNails/"..playerType.."/RougeLevre/"..i..".webp",
                category= "rougealevre",
            })
        end
    end
    for i = 1,  GetPedHeadOverlayNum(11)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Tâche cutanée N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/CreaPerso/"..playerType.."/TacheCutanee/"..i..".webp",
            category= "taches",
        })
    end
    for i = 0,  GetPedHeadOverlayNum(3)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Marque de la peau N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/CreaPerso/"..playerType.."/MarquePeau/"..i..".webp",
            category= "marques",
        })
    end
    for i = 0,  24  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Acné N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/CreaPerso/"..playerType.."/Acne/"..i..".webp",
            category= "acne",
        })
    end
    for i = 0,  GetPedHeadOverlayNum(6)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Teint N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/CreaPerso/"..playerType.."/Teint/"..i..".webp",
            category= "teint",
        })
    end
    for i = 0,  GetPedHeadOverlayNum(7)  do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Cicatrice N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/CreaPerso/"..playerType.."/Cicatrice/"..i..".webp",
            category= "cicatrice",
        })
    end
    for i = 0,  GetNumHeadOverlayValues(9) do
        table.insert(creaPersoData.catalogue, {
            id= i,
            label = "Tâche de rousseur N°" .. i,
            img= "https://cdn.sacul.cloud/v2/vision-cdn/CreaPerso/"..playerType.."/Rousseur/"..i..".webp",
            category= "rousseur",
        })
    end

    -------- Binco
        creaPersoData.hideItemList= {'Bras','Variations 3'}
        creaPersoData.buttons =  {
                {
                    name = 'Hauts',
                    width = 'full',
                    --image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/tshirt.svg',
                    image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/hautEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/tshirt.webp',
                    type = 'coverBackground',
                    hoverStyle = 'fill-black stroke-black',
                    price = 100,
                    progressBar = {
                        {
                            name= 'Hauts'
                        },
                        {
                            name= 'Variations'
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
                    --image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/jeans.svg',
                    image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/basEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/jeans.webp',
                    type = 'coverBackground',
                    hoverStyle = 'fill-black stroke-black',
                    price = 120,
                    progressBar = {
                        {
                            name= 'Bas'
                        },
                        {
                            name= 'Variations'
                        }
                    } 
                },
                {
                    name = 'Chaussures',
                    width = 'full',
                    --image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/shoe.svg',
                    image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/chaussuresEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/shoe.webp',
                    type = 'coverBackground',
                    hoverStyle = 'fill-black stroke-black',
                    price = 110,
                    progressBar = {
                        {
                            name= 'Chaussures'
                        },
                        {
                            name= 'Variations'
                        }
                    } 
                },
                {
                    name = 'Chapeaux',
                    width = 'full',
                    --image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/hat.svg',
                    image = isjob and 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/Homme/chapeauxEUP.webp' or 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/hat.webp',
                    type = 'coverBackground',
                    hoverStyle = 'fill-black stroke-black',
                    price = 80,
                    progressBar = {
                        {
                            name= 'Chapeaux'
                        },
                        {
                            name= 'Variations'
                        }
                    } 
                },
                {
                    name = 'Lunettes',
                    width = 'half',
                    --image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/glasses.svg',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/glasses.webp',
                    type = 'coverBackground',
                    hoverStyle = 'fill-black stroke-black',
                    price = 50,
                    progressBar = {
                        {
                            name= 'Lunettes'
                        },
                        {
                            name= 'Variations'
                        }
                    } 
                },
                {
                    name = 'Sacs',
                    width = 'half',
                    --image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/bag.svg',
                    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/binco/'..playerType..'/bag.webp',
                    type = 'coverBackground',
                    hoverStyle = 'fill-black stroke-black',
                    price = 25,
                    progressBar = {
                        {
                            name= 'Sacs'
                        },
                        {
                            name= 'Variations'
                        }
                    } 
                }
            }

			

			local baseURL = "https://cdn.sacul.cloud/v2/vision-cdn/outfits/" .. playerSex

            -- Pantalon
            if playerType == "Homme" then
                table.insert(creaPersoData.catalogue, {id = 61, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Bas", subCategory="Bas", idVariation=61}) 
            else
                table.insert(creaPersoData.catalogue, {id = 17, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Bas", subCategory="Bas", idVariation=17}) 
            end

            for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 4) - 1 do
                if not tableContains(BanLeg, i) then
					local drawableURL = baseURL .. "/clothing/leg/" .. i .. ".webp"

                    table.insert(creaPersoData.catalogue, {id = i, label="Bas N°"..i, image=drawableURL, category="Bas", subCategory="Bas", idVariation=i})
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 4, i) do
                        local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")
						
						table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Bas", subCategory="Variations", targetId=i })
                    end
                end
            end
            -- Chaussures
            if playerType == "Homme" then
                table.insert(creaPersoData.catalogue, {id = 34, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Chaussures", subCategory="Chaussures", idVariation=34}) 
            else
                table.insert(creaPersoData.catalogue, {id = 35, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Chaussures", subCategory="Chaussures", idVariation=35}) 
            end
            for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 6)-1 do
                if not tableContains(BanShoes, i) then
					local drawableURL = baseURL .. "/clothing/shoes/" .. i .. ".webp"

                    table.insert(creaPersoData.catalogue, {id = i, label="Chaussures N°"..i, image=drawableURL, category="Chaussures", subCategory="Chaussures", idVariation=i})
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 6, i) do
						local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

                        table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Chaussures", subCategory="Variations", targetId=i })
                    end
                end
            end
            -- Hauts
            table.insert(creaPersoData.catalogue, {id = 15, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Hauts", subCategory="Hauts", idVariation=15}) 
            for i = 1, GetNumberOfPedDrawableVariations(PlayerPedId(), 11)-1 do
                if not tableContains(BanTop, i) then
                    local drawableURL = baseURL .. "/clothing/torso2/" .. i .. ".webp"
					
					table.insert(creaPersoData.catalogue, {id = i, label="Haut N°"..i, image=drawableURL, category="Hauts", subCategory="Hauts", idVariation=i})
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 11, i) do
                        local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")
						
						table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Hauts", subCategory="Variations", targetId=i })
                    end
                end
            end
            -- Soushaut            
            if playerType == "Homme" then
                table.insert(creaPersoData.catalogue, {id = 0, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Hauts", subCategory="Sous-haut", idVariation=15-1}) 
            else
                table.insert(creaPersoData.catalogue, {id = 17, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Hauts", subCategory="Sous-haut", idVariation=17}) 
            end
            for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 8)-1 do
                if not tableContains(BanSous, i) then
					local drawableURL = baseURL .. "/clothing/undershirt/" .. i .. ".webp"

                    table.insert(creaPersoData.catalogue, {id = i, label="Sous Haut N°"..i, image=drawableURL, category="Hauts", subCategory="Sous-haut", idVariation=i}) 
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 8, i) do
						local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

                        table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Hauts", subCategory="Variations 2", targetId=i })
                    end
                end
            end
            -- Bras
            for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1 do
                if not tableContains(BanArm, i) then
                    table.insert(creaPersoData.catalogue, {id = i, label="Bras N°"..i, image=" pas d'image ici :> ", price=0,category="Hauts", subCategory="Bras", idVariation=i})
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 3, i) do
                        table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=" pas d'image ici :> ", price=0,category="Hauts", subCategory="Variations 3", targetId=i })
                    end
                end
            end
            -- Chapeaux
            table.insert(creaPersoData.catalogue, {id = -1, label="Aucun", image="./assets/CreationPersonnage/cross.png", category="Chapeaux", subCategory="Chapeaux", idVariation=-1}) 
            for i = -1, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0)-1 do
                if not tableContains(BanHat, i) then
                    local drawableURL = baseURL .. "/props/hat/" .. i .. ".webp"
					
					table.insert(creaPersoData.catalogue, {id = i, label="Chapeau N°"..i, image=drawableURL, category="Chapeaux", subCategory="Chapeaux", idVariation=i})
                    for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, i) do
						local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")

                        table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Chapeaux", subCategory="Variations", targetId=i })
                    end
                end
            end
            -- Lunettes
            if playerType == "Homme" then
                table.insert(creaPersoData.catalogue, {id = 0, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Lunettes", subCategory="Lunettes", idVariation=0}) 
            else
                table.insert(creaPersoData.catalogue, {id = -1, label="Aucun", image="https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp", category="Lunettes", subCategory="Lunettes", idVariation=-1}) 
            end
            for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1)-1 do
                if not tableContains(BanGlases, i) then
					local drawableURL = baseURL .. "/props/glasses/" .. i .. ".webp"

                    table.insert(creaPersoData.catalogue, {id = i, label="Lunettes N°"..i, image=drawableURL, category="Lunettes", subCategory="Lunettes", idVariation=i})
                    for z = 1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, i) do
                        local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")
						
						table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Lunettes", subCategory="Variations", targetId=i })
                    end
                end
            end
            -- Sacs
            table.insert(creaPersoData.catalogue, {id = 0, label="Aucun", image="./assets/CreationPersonnage/cross.png", category="Sacs", subCategory="Sacs", idVariation=0}) 
            for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 5)-1 do
                if not tableContains(BanBag, i) then
                    local drawableURL = baseURL .. "/clothing/bag/" .. i .. ".webp"
					
					table.insert(creaPersoData.catalogue, {id = i, label="Sac N°"..i, image=drawableURL, category="Sacs", subCategory="Sacs", idVariation=i})
                    for z = 1, GetNumberOfPedTextureVariations(PlayerPedId(), 5, i) do
                        local imageURL = z - 1 == 0 and drawableURL or drawableURL:gsub(".webp", "_" .. z - 1 .. ".webp")
						
						table.insert(creaPersoData.catalogue, {id = z, label="Variation N°"..z, image=imageURL, category="Sacs", subCategory="Variations", targetId=i })
                    end
                end
            end

    ExecuteCommand("e idle5")
    BusyspinnerOff()
    DoScreenFadeIn(1500)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'CreationPersonnage',
        data = creaPersoData
    }))
end


local TypePed, lastName, firstName, dateOfBirthdayr, birthplace = nil, nil, nil, nil, nil 
local newP1, newP2, lastSkinValue, lastlookingValue = nil, nil, nil, nil 
local lastnoseX, lastnoseY = nil, nil 
local lastnosePointeX, lastnosePointeY = nil, nil
local lastnoseProfileX, lastnoseProfileY = nil, nil
local lastSourcilsX, lastSourcilsY = nil, nil
local lastpommettesX, lastpommettesY = nil, nil
local lastMentonX, lastMentonY = nil, nil
local lastMentonShapeX, lastMentonShapeY = nil, nil
local lastMachoireX, lastMachoireY = nil, nil
local lastCou, lastlevres, lastjoues, lastyeux = nil, nil, nil, nil 
local OldTypePed = nil
local oldHair, oldColor1, oldColor2 = nil,nil,nil
local oldBeard, oldColorbeard1, oldColorbeard2 = nil, nil, nil
local oldsourcils, oldColorsourcils1, oldColorsourcils2, oldColorsourcils3 = nil, nil, nil, nil
local oldpilosite, oldColorpilosite1, oldColorpilosite3 = nil, nil, nil
local ColorEyes = nil
local oldeyesmaquillage, oldColoreyesmaquillage1, oldColoreyesmaquillage2, oldColoreyesmaquillage3 = nil, nil, nil, nil
local oldfard, oldColorfard1, oldColorfard3 = nil, nil, nil 
local oldrougealevre, oldColorrougealevre1, oldColorrougealevre2, oldColorrougealevre3 = nil, nil, nil, nil
local oldOpacityTache, oldtaches  = nil, nil
local oldmarques, oldOpacityMarque = nil, nil
local oldacne, oldOpacityAcne = nil , nil
local oldteint, oldOpacityTeint = nil,nil 
local oldcicatrice, oldOpacityCicatrice = nil, nil
local oldrousseur, oldOpacityrousseur = nil, nil
local newPed, sexPed = nil, nil
local canSwitchCAM = true

RegisterNUICallback("CreationPersonnageSetCamera", function(data)
    if canSwitchCAM then
        if data.newCamera == "full" and actualCam ~= "body_cam" then
            Cam.switchToCam("body_cam", actualCam, 1000)
            actualCam = "body_cam"
        elseif data.newCamera == "face" and actualCam ~= "shoulder_cam"  then
            Cam.switchToCam("shoulder_cam", actualCam, 1000)
            actualCam = "shoulder_cam"
        elseif data.newCamera == "chest" and actualCam ~= "face_cam"  then
            Cam.switchToCam("face_cam", actualCam, 1000)
            actualCam = "face_cam"
        end
        --print(Cam.Get(actualCam))
        --cameraDoF(Cam.Get(actualCam), 0.7, 0.9, 0.4)
    end
end)

RegisterNUICallback("CreationPersonnageClickHabit", function(data)
    if data ~= nil then
        if data.category == "Hauts" then 
            if data.subCategory == "Hauts" then
                TriggerEvent("skinchanger:change","torso_1",data.id)
                TriggerEvent("skinchanger:change","torso_2", 0)
                if ClothsList[playerType]["Haut"][tostring(data.id)] then 
                    print("Bras " .. ClothsList[playerType]["Haut"][tostring(data.id)])
                    TriggerEvent("skinchanger:change","arms",ClothsList[playerType]["Haut"][tostring(data.id)])
                    TriggerEvent("skinchanger:change","arms_2", 0)
                end
                TriggerEvent("skinchanger:change","tshirt_1",15)
                TriggerEvent("skinchanger:change","tshirt_2", 0)
            elseif data.subCategory == "Variations" then
                TriggerEvent("skinchanger:change","torso_2",data.id-1)
            elseif data.subCategory == "Sous-haut" then
                TriggerEvent("skinchanger:change","tshirt_1",data.id)
                TriggerEvent("skinchanger:change","tshirt_2",0)
            elseif data.subCategory == "Variations 2" then
                TriggerEvent("skinchanger:change","tshirt_2",data.id-1)
            elseif data.subCategory == "Bras" then
                TriggerEvent("skinchanger:change","arms",data.id)
                TriggerEvent("skinchanger:change","arms_2", 0)
            elseif data.subCategory == "Variations 3" then
                TriggerEvent("skinchanger:change","arms_2",data.id-1)
            end
        elseif data.category == "Bas" then
            if data.subCategory == "Bas" then
                TriggerEvent("skinchanger:change","pants_1",data.id)
                TriggerEvent("skinchanger:change","pants_2", 0)
            elseif data.subCategory == "Variations" then
                TriggerEvent("skinchanger:change","pants_2",data.id-1)
            end
        elseif data.category == "Chaussures" then
            if data.subCategory == "Chaussures" then
                TriggerEvent("skinchanger:change","shoes_1",data.id)
                TriggerEvent("skinchanger:change","shoes_2", 0)
            elseif data.subCategory == "Variations" then
                TriggerEvent("skinchanger:change","shoes_2",data.id-1)
            end
        elseif data.category == "Chapeaux" then
            if data.subCategory == "Chapeaux" then
                TriggerEvent("skinchanger:change","helmet_1",data.id)
                TriggerEvent("skinchanger:change","helmet_2", 0)
            elseif data.subCategory == "Variations" then
                TriggerEvent("skinchanger:change","helmet_2",data.id-1)
            end
        elseif data.category == "Lunettes" then
            if data.subCategory == "Lunettes" then
                TriggerEvent("skinchanger:change","glasses_1",data.id)
                TriggerEvent("skinchanger:change","glasses_2", 0)
            elseif data.subCategory == "Variations" then
                TriggerEvent("skinchanger:change","glasses_2",data.id-1)
            end
        elseif data.category == "Sacs" then
            if data.subCategory == "Sacs" then
                TriggerEvent("skinchanger:change","bags_1",data.id)
                TriggerEvent("skinchanger:change","bags_2", 0)
            elseif data.subCategory == "Variations" then
                TriggerEvent("skinchanger:change","bags_2",data.id-1)
            end
        end
    end
end)

RegisterNUICallback("CreationPersonnageBackToMain", function(data)
    if actualCam ~= "body_cam" then
        Cam.switchToCam("body_cam", actualCam, 1000)
        actualCam = "body_cam"
        canSwitchCAM = true
    end
end)

RegisterNUICallback("CreationPersonnageClickBouton", function(data)
    if data == "Hauts" and actualCam ~= "torso_cam" then
        Cam.switchToCam("torso_cam", actualCam, 1000)
        actualCam = "torso_cam"
        canSwitchCAM = false
    elseif data == "Bas" and actualCam ~= "pants_cam" then
        Cam.switchToCam("pants_cam", actualCam, 1000)
        actualCam = "pants_cam"
        canSwitchCAM = false
    elseif data == "Chaussures" and actualCam ~= "shoes_cam"  then
        Cam.switchToCam("shoes_cam", actualCam, 1000)
        actualCam = "shoes_cam"
        canSwitchCAM = false
    elseif data == "Chapeaux" and actualCam ~= "shoulder_cam"  then
        Cam.switchToCam("shoulder_cam", actualCam, 1000)
        actualCam = "shoulder_cam"
        canSwitchCAM = false
    elseif data == "Lunettes" and actualCam ~= "shoulder_cam"  then
        Cam.switchToCam("shoulder_cam", actualCam, 1000)
        actualCam = "shoulder_cam"
        canSwitchCAM = false
    elseif data == "Sacs" then
        canSwitchCAM = true
    end
end)

RegisterNUICallback("CreationPersonnageMouseMove", function(data)
    if data.moveCamera == 1 then
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 3.0)
    else
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 3.0)
    end
end)

RegisterNUICallback("CreationPersonnage", function(data)
    if data.newData ~= nil then
        if data.newData.identity and data.newData.identity.characterChoice ~= nil then
            if  data.newData.identity.characterChoice and data.newData.identity.characterChoice == "men" then
                TypePed = 0
            elseif data.newData.identity.characterChoice and data.newData.identity.characterChoice == "women"  then
                TypePed = 1
            elseif data.newData.identity.characterChoice and data.newData.identity.characterChoice == "custom"  then
                TypePed = 2
            end
            if TypePed ~= OldTypePed then
                if TypePed == 0 then
                    TriggerEvent("skinchanger:change", "sex", 0)
                    TriggerEvent("skinchanger:change", "arms", 15)
                    TriggerEvent("skinchanger:change", "arms_2", 0)
                    TriggerEvent("skinchanger:change", "torso_1", 15)
                    TriggerEvent("skinchanger:change", "tshirt_1", 15)
                    TriggerEvent("skinchanger:change", "pants_1", 61)
                    TriggerEvent("skinchanger:change", "pants_2", 4)
                    TriggerEvent("skinchanger:change", "shoes_1", 34)
                    TriggerEvent("skinchanger:change", "glasses_1", 0)
                    TriggerEvent("skinchanger:change", "skin", 5 / 10)
                    TriggerEvent("skinchanger:change", "face", 5 / 10)
                    ClearPedDecorations(PlayerId())
                    OldTypePed = TypePed
                    ExecuteCommand("e idle5")
                    LoadDataForCreator(TypePed)
                elseif TypePed == 1 then
                    TriggerEvent('skinchanger:change', "sex", 1)
                    TriggerEvent("skinchanger:change", "arms", 15)
                    TriggerEvent("skinchanger:change", "arms_2", 0)
                    TriggerEvent("skinchanger:change", "torso_1", 5)
                    TriggerEvent("skinchanger:change", "tshirt_1", 15)
                    TriggerEvent("skinchanger:change", "pants_1", 57)
                    TriggerEvent("skinchanger:change", "pants_2", 0)
                    TriggerEvent("skinchanger:change", "shoes_1", 35)
                    TriggerEvent("skinchanger:change", "skin", 5 / 10)
                    TriggerEvent("skinchanger:change", "face", 5 / 10)
                    Wait(100)
                    TriggerEvent("skinchanger:change", "glasses_1", -1)
                    ClearPedDecorations(PlayerId())
                    OldTypePed = TypePed
                    ExecuteCommand("e idle5")
                    LoadDataForCreator(TypePed)
                elseif TypePed == 2 then
                    creaPersoData.catalogue = {}
                    creaPersoData.buttons = {}
                    if data.newData.ped ~= nil then
                        if data.newData.ped.selectedPled ~= nil then
                            if newPed ~= data.newData.ped.selectedPled.id then
                                LoadVariationForPed(data.newData.ped.sexe)
                                TriggerEvent('skinchanger:change', "sex", data.newData.ped.selectedPled.id+1)
                                newPed = data.newData.ped.selectedPled.id
                                sexPed = data.newData.ped.selectedPled.subCategory
                            end
                        end
                    end
                end
            end
        end
        if data.newData.identity ~= nil then
            for k,v in pairs(data.newData.identity) do
                if k == "firstName" then
                    firstName = v
                elseif k == "lastName" then
                    lastName = v
                elseif k == "birthDate" then
                    dateOfBirthdayr = v
                elseif k == "birthPlace" then
                    birthplace = v
                end
            end
        end
        if data.newData.character ~= nil then
            if data.newData.character.parent1 ~= nil and data.newData.character.parent1 ~= newP1 then
                TriggerEvent('skinchanger:change', "mom", data.newData.character.parent1-1)
                newP1 = data.newData.character.parent1
            end
            if data.newData.character.parent2 ~= nil and data.newData.character.parent2 ~= newP2 then
                TriggerEvent('skinchanger:change', "dad", data.newData.character.parent2-1)
                newP2 = data.newData.character.parent2
            end
            if data.newData.character.skinValue ~= nil and data.newData.character.skinValue ~= lastSkinValue then
                if data.newData.character.skinValue == 1 then
                    TriggerEvent('skinchanger:change', "skin", 1.0)
                elseif data.newData.character.skinValue == 0 then
                    TriggerEvent('skinchanger:change', "skin", 0.0)
                else
                    TriggerEvent('skinchanger:change', "skin", data.newData.character.skinValue)
                end
                lastSkinValue = data.newData.character.skinValue
            end
            if data.newData.character.lookingValue ~= nil and data.newData.character.lookingValue ~= lastlookingValue then
                if data.newData.character.lookingValue == 1 then
                    TriggerEvent('skinchanger:change', "face", 1.0)
                elseif data.newData.character.lookingValue == 0 then
                    TriggerEvent('skinchanger:change', "face", 0.0)
                else    
                    TriggerEvent('skinchanger:change', "face", data.newData.character.lookingValue)
                end
                lastlookingValue = data.newData.character.lookingValue
            end
        end
        if data.newData.visage ~= nil  then
            if data.newData.visage.nose ~= nil and data.newData.visage.nose.x ~= lastnoseX or data.newData.visage.nose.y ~= lastnoseY then
                TriggerEvent('skinchanger:change', "nose_1", data.newData.visage.nose.x)
                TriggerEvent('skinchanger:change', "nose_2", data.newData.visage.nose.y)
                lastnoseX = data.newData.visage.nose.x
                lastnoseY = data.newData.visage.nose.y
            end
            if data.newData.visage.nosePointe ~= nil and data.newData.visage.nosePointe.x ~= lastnosePointeX or data.newData.visage.nosePointe.y ~= lastnosePointeY then
                TriggerEvent('skinchanger:change', "nose_3", data.newData.visage.nosePointe.x)
                TriggerEvent('skinchanger:change', "nose_4", data.newData.visage.nosePointe.y)
                lastnosePointeX = data.newData.visage.nosePointe.x
                lastnosePointeY = data.newData.visage.nosePointe.y
            end
            if data.newData.visage.noseProfile ~= nil and data.newData.visage.noseProfile.x ~= lastnoseProfileX or data.newData.visage.noseProfile.y ~= lastnoseProfileY then
                TriggerEvent('skinchanger:change', "nose_5", data.newData.visage.noseProfile.x)
                TriggerEvent('skinchanger:change', "nose_6", data.newData.visage.noseProfile.y)
                lastnoseProfileX = data.newData.visage.noseProfile.x
                lastnoseProfileY = data.newData.visage.noseProfile.y
            end
            if data.newData.visage.sourcils ~= nil and data.newData.visage.sourcils.x ~= lastSourcilsX or data.newData.visage.sourcils.y ~= lastSourcilsY then
                TriggerEvent('skinchanger:change', "eyebrows_5", data.newData.visage.sourcils.x)
                TriggerEvent('skinchanger:change', "eyebrows_6", data.newData.visage.sourcils.y)
                lastSourcilsX = data.newData.visage.sourcils.x
                lastSourcilsY = data.newData.visage.sourcils.y
            end
            if data.newData.visage.pommettes ~= nil and data.newData.visage.pommettes.x ~= lastPommettesX or data.newData.visage.pommettes.y ~= lastPommettesY then
                TriggerEvent('skinchanger:change', "cheeks_1", data.newData.visage.pommettes.x)
                TriggerEvent('skinchanger:change', "cheeks_2", data.newData.visage.pommettes.y)
                lastpommettesX = data.newData.visage.pommettes.x
                lastpommettesY = data.newData.visage.pommettes.y
            end
            if data.newData.visage.menton ~= nil and data.newData.visage.menton.x ~= lastMentonX or data.newData.visage.menton.y ~= lastMentonY then
                TriggerEvent('skinchanger:change', "chin_height", data.newData.visage.menton.x)
                TriggerEvent('skinchanger:change', "chin_lenght", data.newData.visage.menton.y)
                lastMentonX = data.newData.visage.menton.x
                lastMentonY = data.newData.visage.menton.y
            end
            if data.newData.visage.mentonShape ~= nil and data.newData.visage.mentonShape.x ~= lastMentonShapeX or data.newData.visage.mentonShape.y ~= lastMentonShapeY then
                TriggerEvent('skinchanger:change', "chin_width", data.newData.visage.mentonShape.x)
                TriggerEvent('skinchanger:change', "chin_hole", data.newData.visage.mentonShape.y)
                lastMentonShapeX = data.newData.visage.mentonShape.x
                lastMentonShapeY = data.newData.visage.mentonShape.y
            end
            if data.newData.visage.machoire ~= nil and data.newData.visage.machoire.x ~= lastMachoireX or data.newData.visage.machoire.y ~= lastMachoireY then
                TriggerEvent('skinchanger:change', "jaw_1", data.newData.visage.machoire.x)
                TriggerEvent('skinchanger:change', "jaw_2", data.newData.visage.machoire.y)
                lastMachoireX = data.newData.visage.machoire.x
                lastMachoireY = data.newData.visage.machoire.y
            end
            if data.newData.visage.cou ~= nil and data.newData.visage.cou ~= lastCou then
                TriggerEvent('skinchanger:change', "neck_thick", data.newData.visage.cou/100)
                lastCou = data.newData.visage.cou/100
            end
            if data.newData.visage.levres ~= nil and data.newData.visage.levres ~= lastlevres then
                TriggerEvent('skinchanger:change', "lips_thick", data.newData.visage.levres/100)
                lastlevres = data.newData.visage.levres/100
            end
            if data.newData.visage.joues ~= nil and data.newData.visage.joues ~= lastjoues then
                TriggerEvent('skinchanger:change', "cheeks_3", data.newData.visage.joues/100)
                lastjoues = data.newData.visage.joues/100
            end
    
            if data.newData.visage.yeux ~= nil and data.newData.visage.yeux ~= lastyeux then
                TriggerEvent('skinchanger:change', "eye_open", data.newData.visage.yeux/100)
                lastyeux = data.newData.visage.yeux/100
            end
        end 
        if data.newData.apparence ~= nil  then
            if data.newData.apparence.hair ~= nil then
                if data.newData.apparence.hair.item.id ~= nil and data.newData.apparence.hair.item.id ~= oldHair then
                    TriggerEvent('skinchanger:change', "hair_1", data.newData.apparence.hair.item.id)
                    oldHair = data.newData.apparence.hair.item.id
                end
                if data.newData.apparence.hair.color1 ~= nil and data.newData.apparence.hair.color1 ~= oldColor1 then
                    TriggerEvent('skinchanger:change', "hair_color_1", data.newData.apparence.hair.color1)
                    oldColor1 = data.newData.apparence.hair.color1
                end
                if data.newData.apparence.hair.color2 ~= nil and data.newData.apparence.hair.color2 ~= oldColor2 then
                    TriggerEvent('skinchanger:change', "hair_color_2", data.newData.apparence.hair.color2)
                    oldColor2 = data.newData.apparence.hair.color2
                end
            end
            if data.newData.apparence.beard ~= nil then
                if data.newData.apparence.beard.item.id ~= nil and data.newData.apparence.beard.item.id ~= oldBeard then
                    TriggerEvent('skinchanger:change', "beard_1", data.newData.apparence.beard.item.id-1)
                    if oldBeard == nil then
                        TriggerEvent('skinchanger:change', "beard_2", 10.0)
                    end
                    oldBeard = data.newData.apparence.beard.item.id
                end
                if data.newData.apparence.beard.color1 ~= nil and data.newData.apparence.beard.color1 ~= oldColorbeard1 then
                    TriggerEvent('skinchanger:change', "beard_3", data.newData.apparence.beard.color1)
                    oldColorbeard1 = data.newData.apparence.beard.color1
                end
                if data.newData.apparence.beard.opacity ~= nil and data.newData.apparence.beard.opacity ~= oldColorbeard2 then
                    TriggerEvent('skinchanger:change', "beard_2", data.newData.apparence.beard.opacity)
                    oldColorbeard2 = data.newData.apparence.beard.opacity
                end
            end
            if data.newData.apparence.sourcils ~= nil then
                if data.newData.apparence.sourcils.item.id ~= nil and data.newData.apparence.sourcils.item.id ~= oldsourcils then
                    TriggerEvent('skinchanger:change', "eyebrows_1", data.newData.apparence.sourcils.item.id)
                    if oldsourcils == nil then
                        TriggerEvent('skinchanger:change', "eyebrows_2", 10.0)
                    end
                    oldsourcils = data.newData.apparence.sourcils.item.id
                end
                if data.newData.apparence.sourcils.color1 ~= nil and data.newData.apparence.sourcils.color1 ~= oldColorsourcils1 then
                    TriggerEvent('skinchanger:change', "eyebrows_3", data.newData.apparence.sourcils.color1)
                    oldColorsourcils1 = data.newData.apparence.sourcils.color1
                end
                if data.newData.apparence.sourcils.color2 ~= nil and data.newData.apparence.sourcils.color2 ~= oldColorsourcils2 then
                    TriggerEvent('skinchanger:change', "eyebrows_4", data.newData.apparence.sourcils.color2)
                    oldColorsourcils2 = data.newData.apparence.sourcils.color2
                end
                if data.newData.apparence.sourcils.opacity ~= nil and data.newData.apparence.sourcils.opacity/10 ~= oldColorsourcils3 then
                    TriggerEvent('skinchanger:change', "eyebrows_2", data.newData.apparence.sourcils.opacity/10)
                    oldColorsourcils3 = data.newData.apparence.sourcils.opacity/10
                end
            end
            if data.newData.apparence.pilosite ~= nil then
                if data.newData.apparence.pilosite.item.id ~= nil and data.newData.apparence.pilosite.item.id ~= oldpilosite then
                    TriggerEvent('skinchanger:change', "chest_1", data.newData.apparence.pilosite.item.id)
                    if oldpilosite == nil then
                        TriggerEvent('skinchanger:change', "chest_2", 10.0)
                    end
                    oldpilosite = data.newData.apparence.pilosite.item.id
                end
                if data.newData.apparence.pilosite.color1 ~= nil and data.newData.apparence.pilosite.color1 ~= oldColorpilosite1 then
                    TriggerEvent('skinchanger:change', "chest_3", data.newData.apparence.pilosite.color1)
                    oldColorpilosite1 = data.newData.apparence.pilosite.color1
                end
                if data.newData.apparence.pilosite.opacity ~= nil and data.newData.apparence.pilosite.opacity/10 ~= oldColorpilosite3 then
                    TriggerEvent('skinchanger:change', "chest_2", data.newData.apparence.pilosite.opacity/10)
                    oldColorpilosite3 = data.newData.apparence.pilosite.opacity/10
                end
            end

            if data.newData.apparence.eyes ~= nil then
                if data.newData.apparence.eyes.color1 ~= nil and data.newData.apparence.eyes.color1 ~= ColorEyes then
                    TriggerEvent('skinchanger:change', "eye_color", data.newData.apparence.eyes.color1)
                    ColorEyes = data.newData.apparence.eyes.color1
                end
            end


            if data.newData.apparence.eyesmaquillage ~= nil then
                if data.newData.apparence.eyesmaquillage.item.id ~= nil and data.newData.apparence.eyesmaquillage.item.id ~= oldeyesmaquillage then
                    TriggerEvent('skinchanger:change', "makeup_1", data.newData.apparence.eyesmaquillage.item.id-1)
                    if oldeyesmaquillage == nil then
                        TriggerEvent('skinchanger:change', "makeup_2", 10.0)
                    end
                    oldeyesmaquillage = data.newData.apparence.eyesmaquillage.item.id
                end
                if data.newData.apparence.eyesmaquillage.color1 ~= nil and data.newData.apparence.eyesmaquillage.color1 ~= oldColoreyesmaquillage1 then
                    TriggerEvent('skinchanger:change', "makeup_3", data.newData.apparence.eyesmaquillage.color1)
                    oldColoreyesmaquillage1 = data.newData.apparence.eyesmaquillage.color1
                end
                if data.newData.apparence.eyesmaquillage.color2 ~= nil and data.newData.apparence.eyesmaquillage.color2 ~= oldColoreyesmaquillage2 then
                    TriggerEvent('skinchanger:change', "makeup_4", data.newData.apparence.eyesmaquillage.color2)
                    oldColoreyesmaquillage2 = data.newData.apparence.eyesmaquillage.color2
                end
                if data.newData.apparence.eyesmaquillage.opacity ~= nil and data.newData.apparence.eyesmaquillage.opacity/10 ~= oldColoreyesmaquillage3 then
                    TriggerEvent('skinchanger:change', "makeup_2", data.newData.apparence.eyesmaquillage.opacity/10)
                    oldColoreyesmaquillage3 = data.newData.apparence.eyesmaquillage.opacity/10
                end
            end


            
            if data.newData.apparence.fard ~= nil then
                if data.newData.apparence.fard.item.id ~= nil and data.newData.apparence.fard.item.id ~= oldfard then
                    TriggerEvent('skinchanger:change', "blush_1", data.newData.apparence.fard.item.id-1)
                    if oldfard == nil then
                        TriggerEvent('skinchanger:change', "blush_2", 10.0)
                    end
                    oldfard = data.newData.apparence.fard.item.id
                end
                if data.newData.apparence.fard.color1 ~= nil and data.newData.apparence.fard.color1 ~= oldColorfard1 then
                    TriggerEvent('skinchanger:change', "blush_3", data.newData.apparence.fard.color1)
                    oldColorfard1 = data.newData.apparence.fard.color1
                end
                if data.newData.apparence.fard.opacity ~= nil and data.newData.apparence.fard.opacity/10 ~= oldColorfard3 then
                    TriggerEvent('skinchanger:change', "blush_2", data.newData.apparence.fard.opacity/10)
                    oldColorfard3 = data.newData.apparence.fard.opacity/10
                end
            end


            if data.newData.apparence.rougealevre ~= nil then
                if data.newData.apparence.rougealevre.item.id ~= nil and data.newData.apparence.rougealevre.item.id ~= oldrougealevre then
                    TriggerEvent('skinchanger:change', "lipstick_1", data.newData.apparence.rougealevre.item.id-1)
                    if oldrougealevre == nil then
                        TriggerEvent('skinchanger:change', "lipstick_2", 10.0)
                    end
                    oldrougealevre = data.newData.apparence.rougealevre.item.id
                end
                if data.newData.apparence.rougealevre.color1 ~= nil and data.newData.apparence.rougealevre.color1 ~= oldColorrougealevre1 then
                    TriggerEvent('skinchanger:change', "lipstick_3", data.newData.apparence.rougealevre.color1)
                    oldColorrougealevre1 = data.newData.apparence.rougealevre.color1
                end
                if data.newData.apparence.rougealevre.opacity ~= nil and data.newData.apparence.rougealevre.opacity/10 ~= oldColorrougealevre3 then
                    TriggerEvent('skinchanger:change', "lipstick_2", data.newData.apparence.rougealevre.opacity/10)
                    oldColorrougealevre3 = data.newData.apparence.rougealevre.opacity/10
                end
            end

            if data.newData.apparence.taches ~= nil then
                if data.newData.apparence.taches.item.id ~= nil and data.newData.apparence.taches.item.id ~= oldtaches then
                    TriggerEvent('skinchanger:change', "bodyb_1", data.newData.apparence.taches.item.id)
                    if oldtaches == nil then
                        TriggerEvent('skinchanger:change', "bodyb_2", 10.0)
                    end
                    oldtaches = data.newData.apparence.taches.item.id
                end
                if data.newData.apparence.taches.opacity ~= nil and data.newData.apparence.taches.opacity/10 ~= oldColortaches3 then
                    TriggerEvent('skinchanger:change', "bodyb_2", data.newData.apparence.taches.opacity/10)
                    oldOpacityTache = data.newData.apparence.taches.opacity/10
                end
            end

            if data.newData.apparence.marques ~= nil then
                if data.newData.apparence.marques.item.id ~= nil and data.newData.apparence.marques.item.id ~= oldmarques then
                    TriggerEvent('skinchanger:change', "age_1", data.newData.apparence.marques.item.id)
                    if oldmarques == nil then
                        TriggerEvent('skinchanger:change', "age_2", 10.0)
                    end
                    oldmarques = data.newData.apparence.marques.item.id
                end
                if data.newData.apparence.marques.opacity ~= nil and data.newData.apparence.marques.opacity/10 ~= oldOpacityMarque then
                    TriggerEvent('skinchanger:change', "age_2", data.newData.apparence.marques.opacity/10)
                    oldOpacityMarque = data.newData.apparence.marques.opacity/10
                end
            end

            if data.newData.apparence.acne ~= nil then
                if data.newData.apparence.acne.item.id ~= nil and data.newData.apparence.acne.item.id ~= oldacne then
                    TriggerEvent('skinchanger:change', "blemishes_1", data.newData.apparence.acne.item.id)
                    if oldacne == nil then
                        TriggerEvent('skinchanger:change', "blemishes_2", 10.0)
                    end
                    oldacne = data.newData.apparence.acne.item.id
                end
                if data.newData.apparence.acne.opacity ~= nil and data.newData.apparence.acne.opacity/10 ~= oldColoracne3 then
                    TriggerEvent('skinchanger:change', "blemishes_2", data.newData.apparence.acne.opacity/10)
                    oldOpacityAcne = data.newData.apparence.acne.opacity/10
                end
            end
            if data.newData.apparence.rousseur ~= nil then
                if data.newData.apparence.rousseur.item.id ~= nil and data.newData.apparence.rousseur.item.id ~= oldrousseur then
                    TriggerEvent('skinchanger:change', "moles_1", data.newData.apparence.rousseur.item.id)
                    if oldrousseur == nil then
                        TriggerEvent('skinchanger:change', "moles_2", 10.0)
                    end
                    oldrousseur = data.newData.apparence.rousseur.item.id
                end
                if data.newData.apparence.rousseur.opacity ~= nil and data.newData.apparence.rousseur.opacity/10 ~= oldOpacityrousseur then
                    TriggerEvent('skinchanger:change', "moles_2", data.newData.apparence.rousseur.opacity/10)
                    oldOpacityrousseur = data.newData.apparence.rousseur.opacity/10
                end
            end
            if data.newData.apparence.teint ~= nil then
                if data.newData.apparence.teint.item.id ~= nil and data.newData.apparence.teint.item.id ~= oldteint then
                    TriggerEvent('skinchanger:change', "complexion_1", data.newData.apparence.teint.item.id)
                    if oldteint == nil then
                        TriggerEvent('skinchanger:change', "complexion_2", 10.0)
                    end
                    oldteint = data.newData.apparence.teint.item.id
                end
                if data.newData.apparence.teint.opacity ~= nil and data.newData.apparence.teint.opacity/10 ~= oldOpacityTeint then
                    TriggerEvent('skinchanger:change', "complexion_2", data.newData.apparence.teint.opacity/10)
                    oldOpacityTeint = data.newData.apparence.teint.opacity/10
                end
            end
            if data.newData.apparence.cicatrice ~= nil then
                if data.newData.apparence.cicatrice.item.id ~= nil and data.newData.apparence.cicatrice.item.id ~= oldcicatrice then
                    TriggerEvent('skinchanger:change', "sun_1", data.newData.apparence.cicatrice.item.id)
                    if oldcicatrice == nil then
                        TriggerEvent('skinchanger:change', "sun_2", 10.0)
                    end
                    oldcicatrice = data.newData.apparence.cicatrice.item.id
                end
                if data.newData.apparence.cicatrice.opacity ~= nil and data.newData.apparence.cicatrice.opacity/10 ~= oldOpacityCicatrice then
                    TriggerEvent('skinchanger:change', "sun_2", data.newData.apparence.cicatrice.opacity/10)
                    oldOpacityCicatrice = data.newData.apparence.cicatrice.opacity/10
                end
            end
        end
    end
    if data.newData ~= nil then
        if data.newData.ped ~= nil then
            if data.newData.ped.physique ~= nil then
                if data.newData.ped.physique.visage  ~= nil then
                    if data.newData.ped.physique.visage.type.category == "visage"  then
                        SetPedComponentVariation(PlayerPedId(), 0, data.newData.ped.physique.visage.type.id,data.newData.ped.physique.visage.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "head", data.newData.ped.physique.visage.type.id)
                    end
                    if data.newData.ped.physique.visage.color.category == "visage"  then
                        SetPedComponentVariation(PlayerPedId(), 0, data.newData.ped.physique.visage.type.id,data.newData.ped.physique.visage.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "mask_1", data.newData.ped.physique.visage.color.id)
                    end
                end
                if data.newData.ped.physique.haut  ~= nil then
                    if data.newData.ped.physique.haut.type.category == "haut"  then
                        SetPedComponentVariation(PlayerPedId(), 3, data.newData.ped.physique.haut.type.id, data.newData.ped.physique.haut.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "arms", data.newData.ped.physique.haut.type.id)
                    end
                    if data.newData.ped.physique.visage.color.category == "haut"  then
                        SetPedComponentVariation(PlayerPedId(), 3, data.newData.ped.physique.haut.type.id, data.newData.ped.physique.haut.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "arms_2", data.newData.ped.physique.haut.color.id)
                    end
                end
                if data.newData.ped.physique.bas  ~= nil then
                    if data.newData.ped.physique.bas.type.category == "bas"  then
                        SetPedComponentVariation(PlayerPedId(), 4, data.newData.ped.physique.bas.type.id, data.newData.ped.physique.bas.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "pants_1", data.newData.ped.physique.bas.type.id)
                    end
                    if data.newData.ped.physique.bas.color.category == "bas"  then
                        SetPedComponentVariation(PlayerPedId(), 4, data.newData.ped.physique.bas.type.id , data.newData.ped.physique.bas.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "pants_2", data.newData.ped.physique.bas.color.id)
                    end
                end
                if data.newData.ped.physique.chaussure  ~= nil then
                    if data.newData.ped.physique.chaussure.type.category == "chaussure"  then
                        SetPedComponentVariation(PlayerPedId(), 6, data.newData.ped.physique.chaussure.type.id, data.newData.ped.physique.chaussure.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "shoes_1", data.newData.ped.physique.chaussure.type.id)
                    end
                    if data.newData.ped.physique.chaussure.color.category == "chaussure"  then
                        SetPedComponentVariation(PlayerPedId(), 6, data.newData.ped.physique.chaussure.type.id, data.newData.ped.physique.chaussure.color.id)
                        TriggerEvent("skinchanger:changeNoEffect", "shoes_2", data.newData.ped.physique.chaussure.color.id)
                    end
                end
            end
        end
    end
    if data.spawnPoint ~= nil then
        local sex = nil 
        if TypePed == 1 or sexPed == "women" then
            sex = "F"
        else
            sex = "M"
        end
        local skin = {}
        TriggerEvent("skinchanger:getSkin", function(cb)
            skin = cb
        end)
        TriggerServerEvent("core:SetPlayerActiveSkin", token, skin)
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        if IsPedMale(PlayerPedId()) then
            if skin["shoes_1"] ~= 34 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "feet", 1, {
                    renamed = "Chaussures N°" .. skin["shoes_1"],
                    drawableId = skin["shoes_1"],
                    variationId = skin["shoes_2"]
                })
            end
            if skin["torso_1"] ~= 15 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Haut N°" .. skin["torso_1"],
                    drawableTorsoId = skin["torso_1"],
                    variationTorsoId = skin["torso_2"],
                    drawableArmsId = skin["arms"],
                    variationArmsId = skin["arms_2"],
                    drawableTshirtId = skin["tshirt_1"],
                    variationTshirtId = skin["tshirt_2"]
                })
            end
            if skin["pants_1"] ~= 61 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "pant", 1, {
                    renamed = "Pantalon N°" .. skin["pants_1"],
                    drawableId = skin["pants_1"],
                    variationId = skin["pants_2"]
                })
            end
            if skin["glasses_1"] ~= -1 and skin["glasses_1"] ~= 0 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "glasses", 1, {
                    renamed = "Lunettes N°" .. skin["glasses_1"],
                    drawableId = skin["glasses_1"],
                    variationId = skin["glasses_2"]
                })
            end
            if skin["helmet_1"] ~= -1 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "hat", 1, {
                    renamed = "Chapeau N°" .. skin["helmet_1"],
                    drawableId = skin["helmet_1"],
                    variationId = skin["helmet_2"]
                })
            end
        else
            if skin["shoes_1"] ~= 35 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "feet", 1, {
                    renamed = "Chaussures N°" .. skin["shoes_1"],
                    drawableId = skin["shoes_1"],
                    variationId = skin["shoes_2"]
                })
            end
            if skin["torso_1"] ~= 15 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "tshirt", 1, {
                    renamed = "Haut N°" .. skin["torso_1"],
                    drawableTorsoId = skin["torso_1"],
                    variationTorsoId = skin["torso_2"],
                    drawableArmsId = skin["arms"],
                    variationArmsId = skin["arms_2"],
                    drawableTshirtId = skin["tshirt_1"],
                    variationTshirtId = skin["tshirt_2"]
                })
            end
            if skin["pants_1"] ~= 15 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "pant", 1, {
                    renamed = "Pantalon N°" .. skin["pants_1"],
                    drawableId = skin["pants_1"],
                    variationId = skin["pants_2"]
                })
            end
            if skin["glasses_1"] ~= 12 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "glasses", 1, {
                    renamed = "Lunettes N°" .. skin["glasses_1"],
                    drawableId = skin["glasses_1"],
                    variationId = skin["glasses_2"]
                })
            end
            if skin["helmet_1"] ~= -1 then
                TriggerSecurGiveEvent("core:addItemToInventory", token, "hat", 1, {
                    renamed = "Chapeau N°" .. skin["helmet_1"],
                    drawableId = skin["helmet_1"],
                    variationId = skin["helmet_2"]
                })
            end
        end
        print("[DEBUG] ", firstName, lastName, dateOfBirthdayr, sex, 180, birthplace)
        TriggerServerEvent("core:CreateIdentity", firstName, lastName, dateOfBirthdayr, sex, 180, birthplace)
        LoadPlayerData(true)
        TriggerServerEvent("core:InstancePlayer", token, 0, "new_char_creator : Ligne 1177")
        FreezeEntityPosition(PlayerPedId(), true)
        Citizen.CreateThread(function()
            InitialSetup()
            while GetPlayerSwitchState() ~= 5 do
                Wait(0)
                ClearScreen()
            end
            ShutdownLoadingScreen()
            ClearScreen()
            Wait(0)
            DoScreenFadeOut(0)
            ClearScreen()
            Wait(0)
            ClearScreen()
            DoScreenFadeIn(500)

            if data.spawnPoint == "BLAINE COUNTY - PALETO" then
                SetEntityCoords(PlayerPedId(), 103.81511688232, 6457.9428710938, 31.399099349976-0.8)
                SetEntityHeading(PlayerPedId(), 45.8)
            elseif data.spawnPoint == "BLAINE COUNTY - SANDY SHORE" then
                SetEntityCoords(PlayerPedId(), 1510.7041015625, 3739.6594238281, 34.482025146484-0.8)
                SetEntityHeading(PlayerPedId(), 219.03)
            elseif data.spawnPoint == "LOS SANTOS - VESPUCCI" then
                SetEntityCoords(PlayerPedId(), -1369.9084472656, -527.89978027344, 30.308320999146-0.8)
                SetEntityHeading(PlayerPedId(),  147.28375244141)
            elseif data.spawnPoint == "LOS SANTOS - GOUVERNEMENT" then
                SetEntityCoords(PlayerPedId(), -245.26113891602, -338.5627746582, 29.078057861328)
                SetEntityHeading(PlayerPedId(),   99.247352600098)
            end
            FreezeEntityPosition(PlayerPedId(), true)


            while not IsScreenFadedIn() do
                Wait(0)
                ClearScreen()
            end
            local timer = GetGameTimer()
            ToggleSound(false)
            while true do
                ClearScreen()
                Wait(0)
                if GetGameTimer() - timer > 5000 then
                    SwitchInPlayer(PlayerPedId())
                    ClearScreen()
                    while GetPlayerSwitchState() ~= 12 do
                        Wait(0)
                        ClearScreen()
                    end
                    break
                end
            end
            ClearDrawOrigin()
            Cam.RemoveAll()
            SetNuiFocusKeepInput(false)
            SetNuiFocus(false, false)
            DisplayHud(true)
            openRadarProperly()
            FreezeEntityPosition(PlayerPedId(), false)
            ItsMyFirstSpawn()
            print("Spawned and openinng tuto form")
            exports["tuto-fa"]:OpenTutorialForm()
        end)
    end
end)



local cloudOpacity = 0.01 
local muteSound = true 

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end


function InitialSetup()
    ToggleSound(muteSound)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
    end
end

function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

