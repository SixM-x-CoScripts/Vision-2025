-- RegisterCommand('testWeazel', function()
--     SendNuiMessage(json.encode({
--         type = 'openWebview',
--         name = 'cardNews',
--         data = {
--             title = "Test Weazel",
--             description = "Miam Miam Les pates c'est bon",
--             photo = "https://c8.alamy.com/compfr/gnx435/breaking-news-front-page-journal-annonce-gnx435.webp",
--             typeofcard = 2
--         }
--     }));

--     SetNuiFocus(false, false)
-- end, false)


local open = false
local main = RageUI.CreateMenu("Annonce", "Annonce")
local menuImage = RageUI.CreateSubMenu(main, "Annonce", "Annonce")
main.Closed = function()
    RageUI.Visible(main, false)
    open = false
end
function OpenAnnonceMenu()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        local title = "Weazel"
        local desc = "Description"
        local photo = "https://c8.alamy.com/compfr/gnx435/breaking-news-front-page-journal-annonce-gnx435.webp"
        local types = 1
        CreateThread(function()
            while open do
                Wait(1)
                RageUI.IsVisible(main, function()
                    RageUI.Button("Annonce avec image", false, {}, true, {
                        onSelected = function()
                            types = 1
                        end,
                    }, menuImage)
                    RageUI.Button("Annonce sans image", false, {}, true, {})
                    RageUI.Button("Breaking News", false, {}, true, {})
                    RageUI.Button("Envoyer l'annonce", false, {}, true, {
                        onSelected = function()
                            SendNuiMessage(json.encode({
                                type = 'openWebview',
                                name = 'cardNews',
                                data = {
                                    title = title,
                                    description = desc,
                                    photo = photo,
                                    typeofcard = types
                                }
                            }));
                        end,
                    })


                end)
                RageUI.IsVisible(menuImage, function()
                    RageUI.Button("Titre", false, {}, true, {
                        onSelected = function()
                            local name = KeyboardImput("Titre")
                            if name ~= nil then
                                title = name
                            end
                        end
                    })
                    RageUI.Button("Description", false, {}, true, {
                        onSelected = function()
                            local name = KeyboardImput("Description")
                            if name ~= nil then
                                desc = name
                            end
                        end,
                    })
                    RageUI.Button("Image", "Attention veuillez mettre une image en imgur.webp", {}, true, {
                        onSelected = function()
                            local name = KeyboardImput("Titre")
                            if name ~= nil then
                                photo = name
                            end
                        end,
                    })


                end)
            end
        end)

    end
end
