local token = nil

CreateThread(function()
    while true do
        Wait(1000)
        if IsLoadingPromptBeingDisplayed() then
            RemoveLoadingPrompt()
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
            break
        end
    end
end)


TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


Modules.Identity = {}
Modules.Identity.MenCheckbox = false
Modules.Identity.WomenCheckbox = false
Modules.Identity.prenom = "Prénom"
Modules.Identity.nom = "Nom"
Modules.Identity.age = "Age (20)"
Modules.Identity.taille = 180
Modules.Identity.sex = "M"
Modules.Identity.LastCam = ""

function Modules.UI.DisplayRegisterIdentity()
    DisplayRadar(false)
    local w, h = Modules.UI.ConvertToPixel(1328, 640)
    Modules.UI.DrawSpriteNew("identity", "background_identity", 0.16041667759418, 0.14629629254341, w, h, 0, 255, 255,
        255, 255, {
            NoHover = true,
            CustomHoverTexture = false,
            NoSelect = true,
            devmod = false
        }, function(onSelected, onHovered)
        if onSelected then

        end
    end)

    --checkbox


    --men
    Modules.UI.DrawTexts(0.72708338499069, 0.34444442391396, Modules.Identity.prenom, true, 0.35, { 255, 255, 255, 255 }
        , 1, false, false)
    Modules.UI.DrawTexts(0.72708338499069, 0.39537036418915, Modules.Identity.nom, true, 0.35, { 255, 255, 255, 255 }, 1
        , false, false)
    Modules.UI.DrawTexts(0.72708338499069, 0.44629627466202, Modules.Identity.age, true, 0.35, { 255, 255, 255, 255 }, 1
        , false, false)
    Modules.UI.DrawTexts(0.72708338499069, 0.49722221493721, Modules.Identity.taille, true, 0.35, { 255, 255, 255, 255 }
        , 1, false, false)
    local w, h = Modules.UI.ConvertToPixel(273, 38)


    Modules.UI.DrawRectangle(vector2(0.65572917461395, 0.3388888835907), vector2(w, h), { 255, 255, 255, 0 }, true,
        { 255, 255, 255, 0 }, function()
            local name = KeyboardImput("Entrez votre prénom")
            if name ~= nil then
                Modules.Identity.prenom = name
            end
        end, nil, false, false)

    Modules.UI.DrawRectangle(vector2(0.65677088499069, 0.39166665077209), vector2(w, h), { 255, 255, 255, 0 }, true,
        { 255, 255, 255, 0 }, function()
            local name = KeyboardImput("Entrez votre nom")
            if name ~= nil then
                Modules.Identity.nom = name
            end
        end, nil, false, false)

    Modules.UI.DrawRectangle(vector2(0.65677088499069, 0.44166666269302), vector2(w, h), { 255, 255, 255, 0 }, true,
        { 255, 255, 255, 0 }, function()
            local name = KeyboardImput("Entrez votre âge")
            if tonumber(name) ~= nil and tonumber(name) >= 15 and tonumber(name) <= 90 then
                Modules.Identity.age = name
            else
                -- ShowNotification("Âge invalide")

                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Âge invalide'
                })

            end
        end, nil, false, false)

    Modules.UI.DrawRectangle(vector2(0.65833336114883, 0.48981481790543), vector2(w, h), { 255, 255, 255, 0 }, true,
        { 255, 255, 255, 0 }, function()
            local name = KeyboardImput("Entrez votre taille")

            if tonumber(name) ~= nil and tonumber(name) >= 130 and tonumber(name) <= 200 then
                Modules.Identity.taille = name
            else
                -- ShowNotification("Taille invalide")

                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Taille invalide'
                })

            end
        end, nil, false, false)

    local w, h = Modules.UI.ConvertToPixel(16, 16)
    if not Modules.Identity.MenCheckbox then
        Modules.UI.DrawSpriteNew("identity", "checkbox_hovered", 0.67760419845581, 0.59166663885117, w, h, 0, 255, 255,
            255, 255, {
                NoHover = true,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then

                if Modules.Identity.WomenCheckbox then
                    Modules.Identity.WomenCheckbox = false
                    Modules.Identity.MenCheckbox = true
                end

                if not Modules.Identity.WomenCheckbox then
                    Modules.Identity.MenCheckbox = true
                end
            end
        end)
    else
        Modules.UI.DrawSpriteNew("identity", "checkbox", 0.67760419845581, 0.59166663885117, w, h, 0, 255, 255, 255, 255
            , {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then
                if Modules.Identity.WomenCheckbox then
                    Modules.Identity.WomenCheckbox = false
                    Modules.Identity.MenCheckbox = false
                end

                if not Modules.Identity.WomenCheckbox then
                    Modules.Identity.MenCheckbox = false
                end
            end
        end)
    end

    if not Modules.Identity.WomenCheckbox then
        Modules.UI.DrawSpriteNew("identity", "checkbox_hovered", 0.73750001192093, 0.59166663885117, w, h, 0, 255, 255,
            255, 255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then

                if Modules.Identity.MenCheckbox then
                    Modules.Identity.WomenCheckbox = true
                    Modules.Identity.MenCheckbox = false
                end

                if not Modules.Identity.MenCheckbox then
                    Modules.Identity.WomenCheckbox = true
                end
            end
        end)
    else
        Modules.UI.DrawSpriteNew("identity", "checkbox", 0.73750001192093, 0.59166663885117, w, h, 0, 255, 255, 255, 255
            , {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then
                if Modules.Identity.MenCheckbox then
                    Modules.Identity.WomenCheckbox = false
                    Modules.Identity.MenCheckbox = false
                end

                if not Modules.Identity.MenCheckbox then
                    Modules.Identity.WomenCheckbox = false
                end
            end
        end)
    end


    --save

    Modules.UI.DrawTexts(0.73020839691162, 0.63611108064651, "Enregistrer", true, 0.35, { 255, 255, 255, 255 }, 1, false
        , false)
    local w, h = Modules.UI.ConvertToPixel(196, 40)
    Modules.UI.DrawSpriteNew("identity", "register", 0.68020838499069, 0.63518518209457, w, h, 0, 255, 255, 255, 255,
        {
            NoHover = false,
            CustomHoverTexture = { "identity", "register_hovered" },
            NoSelect = false,
            devmod = false
        }, function(onSelected, onHovered)
        if onSelected then

            if Modules.Identity.prenom ~= "Prénom" and Modules.Identity.nom ~= "Nom" and
                Modules.Identity.age ~= "Age (20)" then
                if Modules.Identity.MenCheckbox then
                    Modules.Identity.sex = "M"
                    TriggerEvent("skinchanger:change", "arms", 15)
                    TriggerEvent("skinchanger:change", "torso_1", 15)
                    TriggerEvent("skinchanger:change", "tshirt_1", 15)
                    TriggerEvent("skinchanger:change", "pants_1", 61)
                    TriggerEvent("skinchanger:change", "pants_2", 4)
                    TriggerEvent("skinchanger:change", "shoes_1", 34)
                    TriggerEvent("skinchanger:change", "glasses_1", 0)
                    TriggerEvent("skinchanger:change", "skin", 5 / 10)
                    TriggerEvent("skinchanger:change", "face", 5 / 10)
                    TriggerEvent('skinchanger:change', "sex", 0)
                    RefreshData(false)
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                end
                if Modules.Identity.WomenCheckbox then
                    Modules.Identity.sex = "F"
                    TriggerEvent("skinchanger:change", "arms", 15)
                    TriggerEvent("skinchanger:change", "torso_1", 5)
                    TriggerEvent("skinchanger:change", "tshirt_1", 15)
                    TriggerEvent("skinchanger:change", "pants_1", 57)
                    TriggerEvent("skinchanger:change", "pants_2", 0)
                    TriggerEvent("skinchanger:change", "shoes_1", 35)
                    TriggerEvent("skinchanger:change", "glasses_1", -1)
                    TriggerEvent("skinchanger:change", "skin", 5 / 10)
                    TriggerEvent("skinchanger:change", "face", 5 / 10)
                    TriggerEvent('skinchanger:change', "sex", 1)
                    RefreshData(false)
                end
                TriggerServerEvent("core:CreateIdentity", Modules.Identity.nom, Modules.Identity.prenom,
                    Modules.Identity.age, Modules.Identity.sex, Modules.Identity.taille, "")

                -- ShowNotification("Votre carte d'identité a bien été ~g~sauvegardée.")

                exports['vNotif']:createNotification({
                    type = 'SYNC',
                    -- duration = 5, -- In seconds, default:  4
                    content = '~s Votre carte d\'identité a bien été sauvegardée.'
                })

                Modules.UI.SetPageInactive("register_identity")

                Cam.switchToCam("create_cloths", "identity", 3000)
                Modules.Identity.LastCam = "create_cloths"
                Modules.UI.RealWait(3000)
                DisplayRadar(true)
                ApparenceMenu()
            else
                -- ShowNotification("Remplissez les informations nécessaires.")

                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = 'Remplissez les informations nécessaires.'
                })

            end

        end
    end)

end

--RegisterCommand("test", function()
--     Modules.UI.SetPageActive("register_identity")
--end, false)
