RegisterNUICallback("animalerie_suivre", function()
    followAnim()
end)

RegisterNUICallback("animalerie_attaquer", function()
    attackAnim()
end)

RegisterNUICallback("animalerie_vehicule", function()
    if IsPedInAnyVehicle(MyAnimalPed) then
        ExitVAnim()
    else
        EnterVAnim()
    end
end)


InsideAnimalerie = false
function OpenMenuAnimalerie()
    InsideAnimalerie = true
    OpenCaseMenu({
        headerName= "Gestion Animale",
        headerIcon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/info.webp",
        items= {
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/run.webp",
                title= "Suivre",
                action= "animalerie_suivre",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/warn.webp",
                title= "Attaquer",
                action= "animalerie_attaquer",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/veh.webp",
                title= "Véhicule",
                action= "animalerie_vehicule",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/CreationPersonnage/cross.webp",
                title= "Stop",
                action= "animalerie_stop",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/assis.webp",
                title= "Assis",
                action= "animalerie_assis",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/coucher.webp",
                title= "Coucher",
                action= "animalerie_coucher",
            },
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/patte.webp",
                title= "Patte",
                action= "animalerie_pate",
            },
            --{
            --    icon= "https://cdn.sacul.cloud/v2/vision-cdn/svg/animaux/play.webp",
            --    title= "Jouer",
            --    action= "animalerie_jouer",
            --},
            {
                icon= "https://cdn.sacul.cloud/v2/vision-cdn/deco/suppression.webp",
                title= "Ranger",
                action= "DespawnMyAnimal",
            },
        },
    })
end

RegisterNuiCallback("focusOut", function()
    if InsideAnimalerie then 
        InsideAnimalerie = false
    end
end)

RegisterNUICallback("RCB", function(data)
    if data.action then 
        if data.action == "animalerie_suivre" then 
            followAnim()
        elseif data.action == "animalerie_attaquer" then 
            attackAnim()
        elseif data.action == "animalerie_vehicule" then 
            if IsPedInAnyVehicle(MyAnimalPed) then
                ExitVAnim()
            else
                EnterVAnim()
            end
        elseif data.action == "animalerie_stop" then
            ClearPedTasksImmediately(MyAnimalPed)
        elseif data.action == "animalerie_assis" then
            poseSit()
        elseif data.action == "animalerie_pate" then 
            patte()
        elseif data.action == "DespawnMyAnimal" then
            CaseBuilderOpen = false
            closeUI()
            DespawnMyAnimal()
        elseif data.action == "animalerie_coucher" then
            couche()
        elseif data.action == "animalerie_jouer" then
            if p:haveItem("weapon_ball") then 
                SetCurrentPedWeapon(p:ped(), GetHashKey("weapon_ball"), 1)
            end
        end
    end
end)