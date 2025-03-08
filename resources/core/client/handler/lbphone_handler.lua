
CreateThread(function()
   while p == nil do
        Wait(1000)
    end

    Wait(4900)



    local added, errorMessage = exports['lb-phone']:AddCustomApp(
        {
            identifier = "lifeinvader", -- The identifier of the app, must be unique
            name = "Life Invader", -- The name of the app, shown to the user
            description = "Réseaux Social", -- The description of the app, shown to the user
            developer = "Sacul & Flozii", -- OPTIONAL the developer of the app
            defaultApp = false, -- OPTIONAL if set to true, app should be added without having to download it,
            game = false, -- OPTIONAL if set to true, app will be added to the game section
            size = 59812, -- OPTIONAL in kB
            images = {
                "https://cdn.sacul.cloud/v2/vision-cdn/Vision/IMG_8848.png",
                "https://cdn.sacul.cloud/v2/vision-cdn/Vision/IMG_8849.png"
            }, -- OPTIONAL array of images for the app on the app store
            ui = "https://lifeinvader.visionrp.fr/login?access_key=" .. LI_UNIQUE_ACCESS_KEY,
            icon = "https://lifeinvader.visionrp.fr/logo192.png", -- OPTIONAL app icon
            price = 0, -- OPTIONAL, Make players pay with in-game money to download the app
            landscape = false, -- OPTIONAL, if set to true, the app will be displayed in landscape mode
            keepOpen = true, -- OPTIONAL, if set to true, the app will not close when the player opens the app (only works if ui is not defined)
        }
    )
    if not added then
        print("Could not add app: " .. errorMessage)
    end
end)
