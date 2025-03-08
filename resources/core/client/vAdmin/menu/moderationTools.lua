local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function renderModerationTools()
    vAdminModerationTools.Button(
        "Annonce",
        "Serveur",
        nil,
        'chevron',
        p:getPermission() <= 2,
        function()
            local annonce = KeyboardImput("Entrez le contenu de l'annonce")
            if annonce ~= "" and type(annonce) == "string" then
                TriggerServerEvent("core:MaKeAnnounceVision", token, annonce)
            else
                -- ShowNotification("~r~Veuillez entrer un texte valide")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Veuillez entrer un texte valide"
                })
            end
        end
    )
    vAdminModerationTools.Button(
        "Annonce",
        "Serveur Chiante",
        nil,
        'chevron',
        p:getPermission() <= 4,
        function()
            local annonce = KeyboardImput("Entrez le contenu de l'annonce")
            if annonce ~= "" and type(annonce) == "string" then
                TriggerServerEvent("core:vnotif:createAlert:global", token, annonce)
            else
                -- ShowNotification("~r~Veuillez entrer un texte valide")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Veuillez entrer un texte valide"
                })
            end
        end
    )
    vAdminModerationTools.Button(
        "Annonce",
        "Modérateurs",
        nil,
        'chevron',
        p:getPermission() <= 2,
        function()
            local annonce = KeyboardImput("Entrez le contenu de l'annonce")
            if annonce ~= "" and type(annonce) == "string" then
                TriggerServerEvent("core:MaKeAnnounceVisionMod", token, annonce)
            else
                -- ShowNotification("~r~Veuillez entrer un texte valide")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Veuillez entrer un texte valide"
                })
            end
        end
    )
    vAdminModerationTools.Button(
        "Annonce",
        "Modérateurs Chiante",
        nil,
        'chevron',
        p:getPermission() <= 4,
        function()
            local annonce = KeyboardImput("Entrez le contenu de l'annonce")
            if annonce ~= "" and type(annonce) == "string" then
                TriggerServerEvent("core:vnotif:createAlert:staff", token, annonce)
            else
                -- ShowNotification("~r~Veuillez entrer un texte valide")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Veuillez entrer un texte valide"
                })
            end
        end
    )
    vAdminModerationTools.Button(
        "Revive",
        "",
        nil,
        "heart",
        false,
        function()
            openRadarProperly()
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
            TriggerScreenblurFadeOut(10)
            TriggerServerEvent("core:staffActionLog", token, "/revive", "Soi-même")
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez été réanimé"
            })
            p:setPos(GetEntityCoords(p:ped()))
            TriggerEvent("core:IsDeadStatut", false)
            NetworkResurrectLocalPlayer(p:pos(), p:heading(), true, false)
            p:setHealth(200)
            p:setHunger(100)
            p:setThirst(100)
        end
    )
    vAdminModerationTools.Button(
        "Heal",
        "",
        nil,
        "heart",
        false,
        function()
            TriggerServerEvent("core:staffActionLog", token, "/heal", "Soi-même")
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez été soigné"
            })
            p:setHealth(200)
            p:setHunger(100)
            p:setThirst(100)
        end
    )
    vAdminModerationTools.Checkbox(
        "NoClip",
        "",
        false,
        vAdminMods.noclip,
        function(checked)
            vAdminMods.noclip = checked
            ToogleNoClip()

            if vAdminMods.godmode then
                SetEntityInvincible(p:ped(), true)
            end
        end
    )
    vAdminModerationTools.Checkbox(
        "GodMod",
        "",
        p:getPermission() <= 3,
        vAdminMods.godmode,
        function(checked)
            vAdminMods.godmode = checked

            if checked then
                TriggerServerEvent("core:staffActionLog", token, "Start godmod", "Soi-même")
            else
                TriggerServerEvent("core:staffActionLog", token, "Stop godmod", "Soi-même")
            end
        end
    )
    vAdminModerationTools.Checkbox(
        "Invisible",
        "",
        p:getPermission() <= 2,
        vAdminMods.invisible,
        function(checked)
            vAdminMods.invisible = checked

            if checked then
                TriggerServerEvent("core:staffActionLog", token, "Start invisible", "Soi-même")
                SetEntityVisible(p:ped(), false)
            else
                TriggerServerEvent("core:staffActionLog", token, "Stop invisible", "Soi-même")
                SetEntityVisible(p:ped(), true)
            end
        end
    )
    vAdminModerationTools.Checkbox(
        "Nom des Joueurs",
        nil,
        false,
        vAdminMods.playerNames,
        function(checked)
            vAdminMods.playerNames = checked

            if checked then
                TriggerServerEvent("core:staffActionLog", token, "Start blips", "Soi-même")
                UseBlipsName(true)
                TogglePlayerNames()
            else
                TriggerServerEvent("core:staffActionLog", token, "Stop blips", "Soi-même")
                UseBlipsName(false)
                DestroyPlayerNames()
            end

			vAdminModerationTools.refresh()
        end
    )

	vAdminModerationTools.List(
        "Affichage",
        "des nametags",
        p:getPermission() <= 2,
        tablePlayertags,
        IdtblPlayertags,
        function(index, item)
			vAdminAdminData.showRPNamesOnPlayerTags = index == 2 and true or false

			if AdminInAction then
				UseBlipsName(false)
                DestroyPlayerNames()

				UseBlipsName(true)
                TogglePlayerNames()
			end
        end
    )

    vAdminModerationTools.Checkbox(
        "Blips",
        nil,
        false,
        vAdminMods.blips,
        function(checked)
            vAdminMods.blips = checked

            if checked then
                UseBlipsName(true)
                ToggleGamerTag()
            else
                UseBlipsName(false)
                DestroyGamerTag()
            end
        end
    )
    vAdminModerationTools.Button(
        "TP",
        "Sur le point",
        nil,
        "chevron",
        false,
        function()
            TriggerServerEvent("core:staffActionLog", token, "TP sur le point", "Soi-même")
            GotoMarker()
        end
    )
    vAdminModerationTools.Button(
        "Récupérer",
        "les clés du véhicule",
        nil,
        "chevron",
        false,
        function()
            local veh, dst = GetClosestVehicle()
            if DoesEntityExist(veh) and dst < 3.0 then
                plate = GetVehicleNumberPlateText(veh)
                model = GetEntityModel(veh)
            else
                plate = KeyboardImput("Plaque du véhicule", "", 8)
                model = GetHashKey(KeyboardImput("Modèle du véhicule", "", 25))
            end
            
            if plate ~= "" and model ~= "" and plate ~= nil and model ~= nil then
                local id = KeyboardImput("ID du joueur", "", 8)
                if id ~= "" and id ~= nil then
                    TriggerServerEvent("core:admin:giveKeys", token, id, plate, model)
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Vous avez donné les clés du véhicule "..plate.." au joueur n°"..id
                    })
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "L'ID du joueur est invalide"
                    })
                end
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "La plaque ou le modèle du véhicule est invalide"
                })
            end
        end
    )
    vAdminModerationTools.Button(
        "Soigner",
        "la zone",
        nil,
        "heart",
        p:getPermission() <= 4,
        function()
            local radius = KeyboardImput("Radius de la zone")
            if tonumber(radius) ~= nil and tonumber(radius) >= 0 then
                TreatZone(radius)
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "~sRayon invalide !"
                })
            end
        end
    )
    vAdminModerationTools.List(
        "Donner",
        "les permissions",
        p:getPermission() <= 4,
        tablePerms,
        IdtblPerms,
        function(index, item)
            if p:getPermission() >= 5 then
                local id = nil
                if item == "id discord" then
                    id = KeyboardImput("ID Dicord du joueur")
                else
                    id = KeyboardImput("ID du joueur")
                end
                local perm = KeyboardImput("Permissions (0 à 5)")
                if tonumber(id) ~= nil then
                    if tonumber(perm) ~= nil and tonumber(perm) >= 0 and tonumber(perm) <= 5 then
                        -- if tonumber(id) == GetPlayerServerId(PlayerId()) then
                        --     exports['vNotif']:createNotification({
                        --         type = 'ROUGE',
                        --         content = "Vous n'êtes pas autorisé à vous donner des permissions à vous même"
                        --     })
                        --     return 
                        -- end 

                        if item == "id" then
                            local playerData = TriggerServerCallback("core:GetAllPlayerInfoforMenu", token, tonumber(id))
                            while playerData == nil do
                                Wait(1)
                            end

                            local confirmation = ChoiceInput("Voulez-vous vraiment donner le grade " .. perm .. " à " .. playerData.name .. " ?")
                            if confirmation == true then
                                TriggerServerEvent("core:setPermAdmin", token, tonumber(id), tonumber(perm))
                                TriggerServerEvent("core:staffActionLog", token, "Donner les permissions", "<@"..playerData.discord.."> - "..playerData.name .. " - Grade : " .. perm)
                            end
                        elseif item == "id discord" then
                            local confirmation = ChoiceInput("Voulez-vous vraiment donner le grade " .. perm .. " à l'id discord " .. id .. " ?")
                            if confirmation == true then
                                TriggerServerEvent("core:setPermAdminWithDiscordId", token, tonumber(id), tonumber(perm))
                                TriggerServerEvent("core:staffActionLog", token, "Donner les permissions", "<@"..id.."> - Grade : " .. perm)
                            end
                        end
                    end
                end
            else 
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Cette action est réservée aux Staff FA par mesure de sécurité."
                })
                return 
            end
        end
    )
    vAdminModerationTools.List(
        "Ban",
        "un joueur offline",
        p:getPermission() <= 4,
        tableBanOffline,
        IdtblbanOffline,
        function(index, item)
            if p:getPermission() >= 5 then
                local identifiers = KeyboardImput("Identifiers du joueur (JSON)")
                if identifiers == nil or identifiers == "" then return end
                
                local reason = KeyboardImput("Raison du ban")
                if reason == nil or reason == "" then return end

                local time = nil
                if item ~= "perm" then
                    time = KeyboardImput("Durée du ban (en "..item..")")
                else
                    time = 32508259200
                end

                if time == nil or time == "" then return end    

                if reason ~= nil and reason ~= "" and time ~= nil and time ~= "" and tonumber(time) ~= nil and item ~= nil then
                    TriggerServerEvent("core:ban:banofflineplayer", token, identifiers, reason, tonumber(time), GetPlayerServerId(PlayerId()), item)
                end
            else 
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Cette action est réservée aux Staff FA par mesure de sécurité."
                })
                return 
            end
        end
    )
    vAdminModerationTools.Button(
        "Unban",
        "un joueur",
        nil,
        "chevron",
        p:getPermission() <= 3,
        function()
            local id = KeyboardImput("Ban ID")

            if id ~= nil and id ~= "" then
                TriggerServerEvent("core:staffActionLog", token, "/unban", id)
                TriggerServerEvent("core:ban:unbanplayer", token, id)

                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez unban le joueur n°" .. id .. "."
                })
            end
        end
    )
    vAdminModerationTools.Button(
        "Donner",
        "un permis",
        nil,
        "chevron",
        p:getPermission() <= 3,
        function()
            local idplayer = KeyboardImput("id du joueur")
            local kind = KeyboardImput("traffic_law, driving, moto, camion, bateau, helico")

            if idplayer ~= nil and idplayer ~= "" and kind ~= nil and (kind == "traffic_law" or kind == "driving" or kind == "moto" or kind == "camion" or kind == "bateau" or kind == "helico") then
                TriggerServerEvent("core:staffActionLog", token, "/permis", "id - " .. idplayer .. ", permis - " .. kind)
                TriggerServerEvent("core:addLicence", tonumber(idplayer), token, kind)

                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez donner le permis " .. kind .. " au joueur n°" .. idplayer .. "."
                })
            else
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "L'ID du joueur ou le type de permis est invalide"
                })
            end
        end
    )
end

