local VUI = exports["VUI"]
local main = VUI:CreateMenu("Menu premium", "premium", true)

main.OnOpen(function()
    renderPremiumMenu()
    if p:getSubscription() > 1 then
        main.ChangeBanner("premiumplus")
    else 
        main.ChangeBanner("premium")
    end
end)

function renderPremiumMenu()
    if p:getSubscription() > 1 then
        main.Checkbox(
            "Salaire",
            "x2",
            true,
            true,
            function(checked)
                
            end
        )
    else 
        main.Checkbox(
            "Salaire",
            "x1.25",
            true,
            true,
            function(checked)
                
            end
        )
    end
    main.Checkbox(
        "VIP",
        "Casino",
        true,
        true,
        function(checked)
            
        end
    )
    main.Checkbox(
        "Aucune limite",
        "de Farm",
        true,
        true,
        function(checked)
            
        end
    )
    main.Button(
        "Liste de vos",
        "personnages",
        nil,
        "chevron",
        false,
        function()
            main.close()
            ExecuteCommand("personnage prem")
        end
    )
    main.Button(
        "Créer un",
        "nouveau personnage",
        nil,
        "chevron",
        false,
        function()
            main.close()
            ExecuteCommand("newpersonnage")
        end
    )
    main.Button(
        "Décoration",
        "d'interieur",
        nil,
        "chevron",
        false,
        function()
            main.close()
            ExecuteCommand("deco prem")
        end
    )
    main.Button(
        "Décoration",
        "d'extérieur",
        nil,
        "chevron",
        false,
        function()
            main.close()
            ExecuteCommand("props prem")
        end
    )
    main.Button(
        "Plaque",
        "d'immatriculation",
        nil,
        "chevron",
        false,
        function()
            if IsPedInAnyVehicle(p:ped()) then
                main.close()
                ExecuteCommand("plate prem")
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'êtes pas dans un véhicule"
                })
            end
        end
    )
    main.Button(
        "Jobs",
        "premium",
        nil,
        "chevron",
        false,
        function()
            SetNewWaypoint(-268.94, -956.13)
        end
    )
    main.Button(
        "Position",
        "chirugie",
        nil,
        "chevron",
        false,
        function()
            SetNewWaypoint(-681.86, -189.0945)
        end
    )
    main.Button(
        "Position",
        "animalerie",
        nil,
        "chevron",
        false,
        function()
            SetNewWaypoint(561.94110107422, 2749.1552734375)
        end
    )
end

local activatedPremiumKey = false
function SetPremiumKey()
    if p:getSubscription() > 0 and not activatedPremiumKey then
        activatedPremiumKey = true
        Keys.Register("F7", "F7", "Ouvrir le menu premium", function()
            if p:getSubscription() == 0 then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous n'êtes pas premium"
                })
                return
            end
            main.open()
        end)
    end
end

function openCb()
    main.open()
end
CreateThread(function()
    while not p do Wait(1000) end 
    SetPremiumKey()
end)