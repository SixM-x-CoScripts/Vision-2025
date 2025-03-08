local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local CurrentFiltre = nil
local CurrentFiltre2 = nil
local CurrentFiltre3 = nil
local CurrentFiltre4 = nil

local function getPlayerGradeName(perm)
    if perm == 2 then
        return "Helpeur"
    elseif perm == 3 then
        return "Modérateur"
    elseif perm == 4 then
        return "Responsable"
    elseif perm == 5 then
        return "Staff"
    elseif perm >= 69 then
        return "Développeur"
    else 
        return "Inconnu (" .. perm .. ")"
    end
end

function renderPlayerList()
    vAdminPlayers.Button(
        --"Rechercher",
        vAdminAdminData.query == nil and "Rechercher" or "Recherche:",
        vAdminAdminData.query == nil and "un joueur" or vAdminAdminData.query,
        nil,
        "search",
        false,
        function()
            vAdminAdminData.showAllPlayers = false

            if vAdminAdminData.query ~= nil then 
                vAdminAdminData.query = nil
                vAdminAdminData.players = nil
                vAdminPlayers.refresh()
                return
            end

            local query = KeyboardImput("Entrez un ID / Prénom / Nom / Discord")
            if query == nil or query == "" then return end
            
            vAdminAdminData.players = nil
            vAdminAdminData.players = TriggerServerCallback("core:QueryPlayers", token, query)

            while vAdminAdminData.players == nil do
                Wait(1)
            end

            vAdminAdminData.query = query
            vAdminPlayers.refresh()
        end
    )
    
    for k, v in pairs(vAdminAdminData.players) do
        if v.firstname == nil or v.lastname == nil then
            v.firstname = "Utilisateur"
            v.lastname = "Inconnu"
        end

        vAdminPlayers.Button(
            v.name,
            v.firstname .. " " .. v.lastname,
            v.id,
            nil,
            false,
            function()
                local playerData = TriggerServerCallback("core:GetAllPlayerInfo", token, v.id)
                while playerData == nil do
                    Wait(1)
                end
                Admindata = nil
                Admindata = playerData
                Admindata.name = v.name
                Admindata.id = v.id
                Admindata.firstname = v.firstname
                Admindata.lastname = v.lastname
            end,
            vAdminPlayer
        ) 
    end

    if vAdminAdminData.query == nil then
        vAdminPlayers.Checkbox(
            "Afficher",
            "la liste de tous les joueurs",
            false,
            vAdminAdminData.showAllPlayers,
            function(checked)
                vAdminAdminData.showAllPlayers = checked

                if checked then
                    vAdminAdminData.players = nil
                    vAdminAdminData.players = TriggerServerCallback("core:GetAllPlayer", token)

                    while vAdminAdminData.players == nil do Wait(1) end
                end
                vAdminPlayers.refresh()
            end
        )
    end
end

function renderModeratorList()
    if CurrentFiltre == nil then
        vAdminModerators.Button(
            "Rechercher",
            "un joueur",
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil
                local TargetId = KeyboardImput("Entrez un ID / Prénom / Nom")
                TargetId = tostring(TargetId)
                
                if TargetId ~= nil and string.len(TargetId) ~= 0 then
                    if type(TargetId) == 'string' then
                        CurrentFiltre = TargetId
                        
                        vAdminModerators.refresh()
                    end
                else
                    CurrentFiltre = nil
                    
                    vAdminModerators.refresh()
                end
                
            end
        )
    else
        vAdminModerators.Button(
            CurrentFiltre,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil
                
                vAdminModerators.refresh()
            end
        )
    end
    
    for k, v in pairs(vAdminAdminData.players) do
        if v.name == nil then
            v.name = "Utilisateur inconnu"
        end

        if v.permission >= 2 then 
            if CurrentFiltre ~= nil then
                if v.id == tonumber(CurrentFiltre) or
                    string.find(string.lower(v.firstname), string.lower(CurrentFiltre)) ~= nil or
                    string.find(string.lower(v.lastname), string.lower(CurrentFiltre)) ~= nil or
                    string.find(string.lower(v.name), string.lower(CurrentFiltre)) ~= nil then
    
                    vAdminModerators.Button(
                        v.name,
                        v.firstname .. " " .. v.lastname,
                        getPlayerGradeName(v.permission),
                        nil,
                        false,
                        function()
                            local playerData = TriggerServerCallback("core:GetAllPlayerInfo", token, v.id)
                            while playerData == nil do
                                Wait(1)
                            end
                            Admindata = nil
                            Admindata = playerData
                            Admindata.name = v.name
                            Admindata.id = v.id
                            Admindata.firstname = v.firstname
                            Admindata.lastname = v.lastname
                        end,
                        vAdminPlayer
                    )
                end
            else
                vAdminModerators.Button(
                        v.name,
                        v.firstname .. " " .. v.lastname,
                        getPlayerGradeName(v.permission),
                        nil,
                        false,
                        function()
                            local playerData = TriggerServerCallback("core:GetAllPlayerInfo", token, v.id)
                            while playerData == nil do
                                Wait(1)
                            end
                            Admindata = nil
                            Admindata = playerData
                            Admindata.name = v.name
                            Admindata.id = v.id
                            Admindata.firstname = v.firstname
                            Admindata.lastname = v.lastname
                        end,
                        vAdminPlayer
                    ) 
            end 
        end
    end
end

function getPlayerInfoById(playerTable, id)
    for _, player in ipairs(playerTable.player.players) do
        if player.id == id then
            return player
        end
    end
    return nil
end

RegisterCommand("openplayer", function(source, args, rawCommand)
    if p:getPermission() >= 2 then
        openPlayerOnAdminMenu(args[1])
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "Vous n'avez pas la permission d'utiliser cette commande."
        })
    end
end, false)

function renderPlayerMenu()
    vAdminPlayer.Title(Admindata.name, Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)
    vAdminPlayer.Separator(
        "Premium", 
        Admindata.premium >= 1 and "Oui" or "Non",
        "V Coins", 
        Admindata.credit
    )
    vAdminPlayer.Separator(
        "JOB", 
        Admindata.job .. " • " .. Admindata.jobGrade,
        "CREW", 
        Admindata.crew
    )
    vAdminPlayer.Separator("BANQUE", (Admindata.bank and Admindata.bank.balance or "?"), "COMPTE", (Admindata.bank and Admindata.bank.account_number or "?"))

    vAdminPlayer.Button(
        #Admindata.warns or 0,
        "Warn(s)",
        nil,
        "chevron",
        Admindata.warns == nil or #Admindata.warns == 0,
        function() end,
        vAdminPlayerWarns
    )

    vAdminPlayer.Title(nil)

    vAdminPlayer.Button(
        "Discord ID",
        Admindata.discord,
        nil,
        nil,
        false,
        function()
            TriggerEvent("addToCopy", Admindata.discord)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez copié l'ID Discord de ~s " .. Admindata.firstname .. " " .. Admindata.lastname
            })
        end
    )
    vAdminPlayer.Button(
        "Changer",
        "le job",
        nil,
        "chevron",
        p:getPermission() <= 2,
        function() end,
        vAdminPlayerJob
    )
    vAdminPlayer.Button(
        "Changer",
        "le crew",
        nil,
        "chevron",
        p:getPermission() <= 2,
        function() end,
        vAdminPlayerCrew
    )
    vAdminPlayer.Button(
        "Give",
        "un item",
        nil,
        "chevron",
        false,
        function() end,
        vAdminPlayerGiveItem
    )
    vAdminPlayer.Button(
        "Inventaire",
        "du joueur",
        nil,
        "chevron",
        false,
        function() end,
        vAdminPlayerInventory
    )
    vAdminPlayer.Button(
        "Vehicules",
        "du joueur",
        nil,
        "chevron",
        false,
        function() end,
        vAdminPlayerVehicleMenu
    )
    vAdminPlayer.Button(
        "Envoyer",
        "un message",
        nil,
        "chevron",
        false,
        function()
            local msg = KeyboardImput("Message", "")

            if msg ~= nil or msg ~= "" then
                TriggerServerEvent("core:SendMessage", token, Admindata.id, msg)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Message envoyé à ~s " .. Admindata.firstname .. " " .. Admindata.lastname
                })
            end
        end
    )
    vAdminPlayer.Button(
        "Envoyer",
        "un message chiant",
        nil,
        "chevron",
        false,
        function()
            local msg = KeyboardImput("Message", "")

            if msg ~= nil or msg ~= "" then
                TriggerServerEvent("core:vnotif:createAlert:player", token, msg, Admindata.id)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Message chiant envoyé à ~s " .. Admindata.firstname .. " " .. Admindata.lastname
                })
            end
        end
    )
    vAdminPlayer.Button(
        "Revive",
        "le joueur",
        nil,
        "heart",
        false,
        function()
            TriggerServerEvent("core:staffActionLog", token, "/revive", Admindata.id)
            TriggerServerEvent("core:RevivePlayer", token, Admindata.id)
            TriggerServerEvent("core:createvNotif", token, tonumber(Admindata.id), 'VERT', "Vous avez été réanimé par un membre du staff.", 5)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez revive ~s " .. Admindata.firstname .. " " .. Admindata.lastname
            })
        end
    )
    vAdminPlayer.Button(
        "Heal",
        "le joueur",
        nil,
        "heart",
        false,
        function()
            TriggerServerEvent("core:HealthPlayer", token, Admindata.id)
            TriggerServerEvent("core:createvNotif", token, tonumber(Admindata.id), 'VERT', "Vous avez été soigné par un membre du staff.", 5)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez heal ~s " .. Admindata.firstname .. " " .. Admindata.lastname
            })
        end
    )
    vAdminPlayer.Checkbox(
        "Spectate",
        "le joueur",
        p:getPermission() <= 2,
        vAdminpPlayer.spectate,
        function(checked)
            vAdminpPlayer.spectate = checked
            if checked then
                TriggerServerEvent("core:staffActionLog", token, "/spectate", Admindata.id)
                TriggerServerEvent("core:StaffSpectate", token, Admindata.id)
            else
                TriggerServerEvent("core:staffActionLog", token, "/unspectate", Admindata.id)
                TriggerServerEvent("core:StaffSpectate", token, Admindata.id)
            end
        end
    )
    vAdminPlayer.Button(
        "Définir",
        "un waypoint",
        nil,
        "chevron",
        p:getPermission() <= 2,
        function() 
            local playerCoords = TriggerServerCallback("core:CoordsOfPlayer", token, Admindata.id)
            SetNewWaypoint(playerCoords.x, playerCoords.y)
        end
    )
    vAdminPlayer.Button(
        "Go to",
        nil,
        nil,
        "chevron",
        false,
        function()
            TriggerServerEvent("core:staffActionLog", token, "/goto", Admindata.id)
            TriggerServerEvent("core:GotoBring", token, nil, Admindata.id)
        end
    )
    vAdminPlayer.Button(
        "Bring",
        nil,
        nil,
        "chevron",
        false,
        function()
            local playerID = tonumber(Admindata.id)
            local coords = TriggerServerCallback("core:CoordsOfPlayer", token, playerID)
            bringData[playerID] = {coords = coords}
            TriggerServerEvent("core:staffActionLog", token, "/bring", playerID)
            TriggerServerEvent("core:GotoBring", token, playerID, nil)
            vAdminPlayer.refresh()
        end
    )
    if bringData[tonumber(Admindata.id)] then
        vAdminPlayer.Button(
            "Return",
            nil,
            nil,
            "chevron",
            false,
            function()
                local playerID = tonumber(Admindata.id)
                local data = bringData[playerID]
                TriggerServerEvent("core:staffActionLog", token, "/return", playerID)
                TriggerServerEvent("core:ReturnPositionPlayer", token, playerID, data.coords)
                bringData[playerID] = nil -- Remove player from bring data after return
                vAdminPlayer.refresh()
            end
        )
    else
        vAdminPlayer.Button(
            "Return",
            nil,
            nil,
            "lock",
            true,
            function()
                vAdminPlayer.refresh()
            end
        )
    end    
    vAdminPlayer.Checkbox(
        "Freeze",
        "le joueur",
        p:getPermission() <= 2,
        vAdminpPlayer.freeze,
        function(checked)
            vAdminpPlayer.freeze = checked
            if checked then
                TriggerServerEvent("core:staffActionLog", token, "/freeze", Admindata.id)
                TriggerServerEvent("core:FreezePlayer", token, Admindata.id, true)
            else
                TriggerServerEvent("core:staffActionLog", token, "/unfreeze", Admindata.id)
                TriggerServerEvent("core:FreezePlayer", token, Admindata.id, false)
            end
        end
    )
    vAdminPlayer.Button(
        "Warn",
        nil,
        nil,
        "chevron",
        false,
        function()
            local reason = KeyboardImput("Raison du warn")

            if reason ~= nil and reason ~= "" then
                TriggerServerEvent("core:warn:addwarn", token, Admindata.license, Admindata.discord, reason, Admindata.id)
                
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez warn ~s " .. Admindata.firstname .. " " .. Admindata.lastname
                })

                vAdminPlayer.refresh()
            end
        end
    )
    vAdminPlayer.Button(
        "Kick",
        nil,
        nil,
        "chevron",
        false,
        function()
            local reason = KeyboardImput("Raison du kick")

            if reason ~= nil and reason ~= "" then
                TriggerServerEvent("core:staffSuivi", token, "kick", tonumber(Admindata.id), reason)
                TriggerServerEvent("core:KickPlayer", token, Admindata.id, reason)
            end
        end
    )
    vAdminPlayer.List(
        "Ban",
        nil,
        p:getPermission() <= 2,
        tableBan,
        Idtblban,
        function(index, item)
            local reason = KeyboardImput("Raison du ban")
            local time = nil
            if item ~= "Perm" then
                time = KeyboardImput("Temps")
            else
                time = 0
            end
            if reason ~= nil and reason ~= "" and time ~= nil and time ~= "" then
                -- TriggerServerEvent("core:staffSuivi", token, "ban", tonumber(Admindata.id), reason, tonumber(time), item)
                TriggerServerEvent("core:staffBanAction", token, "/ban", Admindata.id .. "** - Raison :** " .. reason .. "** - Temps : **" .. time)
                TriggerServerEvent("core:ban:banplayer", token, tonumber(Admindata.id), reason, tonumber(time), GetPlayerServerId(PlayerId()), item)
            end
        end
    )
    vAdminPlayer.Button(
        "Screen",
        "écran du joueur",
        nil,
        "chevron",
        p:getPermission() <= 2,
        function()
            TriggerServerEvent("core:TakeScreenBiatch", token, Admindata.id)

            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "Vous avez pris un screen de ~s " .. Admindata.firstname .. " " .. Admindata.lastname
            })
        end
    )



    if Admindata.instance ~= 0 then
        if InsideInstanceAdmin == 0 then
            vAdminPlayer.Button(
                "Rejoindre",
                "l'instance du joueur",
                nil,
                "chevron",
                false,
                function()
                    InsideInstanceAdmin = Admindata.instance
                    TriggerServerEvent("core:InstancePlayer", token, Admindata.instance, "Menu : Ligne 415")
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Vous avez rejoint l'instance n°" .. Admindata.instance .. "."
                    })
                end
            )
        else
            vAdminPlayer.Button(
                "Quitter",
                "l'instance du joueur",
                nil,
                "chevron",
                false,
                function()
                    InsideInstanceAdmin = 0
                    TriggerServerEvent("core:InstancePlayer", token, 0, "Menu : Ligne 426")
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Vous avez quitté l'instance n°" .. Admindata.instance .. "."
                    })
                end
            )
        end
    end
end

function renderPlayerWarns()
    vAdminPlayerWarns.Title("Warns", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    if CurrentFiltre == nil then 
        vAdminPlayerWarns.Button(
            "Rechercher",
            "un warn par raison",
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil
                local TargetWarn = KeyboardImput("Entrer une raison de warn")
                TargetWarn = tostring(TargetWarn)
                if TargetWarn ~= nil and string.len(TargetWarn) ~= 0 then
                    if type(TargetWarn) == 'string' then
                        CurrentFiltre = TargetWarn
                    
                        vAdminPlayerWarns.refresh()
                    end
                else
                    CurrentFiltre = nil
                
                    vAdminPlayerWarns.refresh()
                end
            end
        )
    else
        vAdminPlayerWarns.Button(
            CurrentFiltre,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil

                vAdminPlayerWarns.refresh()
            end
        )
    end

    vAdminPlayerWarns.Separator(nil)

    for k, v in pairs(Admindata.warns) do
        if CurrentFiltre ~= nil then
            if v.id == tonumber(CurrentFiltre) or string.find(string.lower(v.reason), string.lower(tostring(CurrentFiltre))) then
                vAdminPlayerWarns.Button(
                    "Warn ID",
                    v.id,
                    v.by or "CONSOLE",
                    nil,
                    false,
                    function()
                        if p:getPermission() >= 5 then
                            local confirmation = ChoiceInput("Voulez-vous vraiment supprimer ce warn ?")

                            if confirmation == true then
                                TriggerServerEvent("core:warn:removewarn", token, v.id)
                                TriggerServerEvent("core:warn:getwarns", token)

                                vAdminPlayerWarns.refresh()
                            end
                        end
                    end
                )
            end
        else
            vAdminPlayerWarns.Button(
                "Warn ID",
                v.id,
                v.by or "CONSOLE",
                nil,
                false,
                function()
                    if p:getPermission() >= 5 then
                        local confirmation = ChoiceInput("Voulez-vous vraiment supprimer ce warn ?")

                        if confirmation == true then
                            TriggerServerEvent("core:warn:removewarn", token, v.id)
                            TriggerServerEvent("core:warn:getwarns", token)

                            vAdminPlayerWarns.refresh()
                        end
                    end
                end
            )
        end
    end
end

function renderPlayerJob()
    vAdminPlayerJob.Title("Job", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    vAdminPlayerJob.Button(
        "Changer",
        "le job par nom",
        nil,
        "chevron",
        false,
        function()
            local job = KeyboardImput("Nom du job")
            if job ~= nil or job ~= "" then
                local level = KeyboardImput("Choisir le grade de 1 à 5") 
                if level ~= nil or level ~= "" then
                    if jobs[job] ~= nil then
                        if tonumber(level) >= 1 and tonumber(level) <= 5 then
                            TriggerServerEvent("core:staffActionLog", token, "/setjob", Admindata.id .. " - Job : " .. job .. " - Grade : " .. level)
                            TriggerEvent("jobs:unloadcurrent")
                            TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(Admindata.id), job, tonumber(level))

                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                content = "~s Vous avez changé le job de " .. Admindata.firstname .. " " .. Admindata.lastname .. " en " .. job .. " grade " .. level
                            })
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "~s Le grade n'existe pas"
                            })
                        end
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "~s Le job n'existe pas"
                        })
                    end
                end
            end
        end
    )

    if CurrentFiltre3 == nil then 
        vAdminPlayerJob.Button(
            "Rechercher",
            "un job par nom",
            nil,
            "search",
            false,
            function()
                CurrentFiltre3 = nil
                local TargetJob = KeyboardImput("Entrer un nom de job")
                TargetJob = tostring(TargetJob)
                if TargetJob ~= nil and string.len(TargetJob) ~= 0 then
                    if type(TargetJob) == 'string' then
                        CurrentFiltre3 = TargetJob
                    
                        vAdminPlayerJob.refresh()
                    end
                else
                    CurrentFiltre3 = nil
                
                    vAdminPlayerJob.refresh()
                end
            end
        )
    else
        vAdminPlayerJob.Button(
            CurrentFiltre3,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre3 = nil

                vAdminPlayerJob.refresh()
            end
        )
    end

    vAdminPlayerJob.Separator(nil)

    for k, v in pairs(jobs) do
        if CurrentFiltre3 ~= nil then
            if k == tonumber(CurrentFiltre3) or string.find(string.lower(k), string.lower(tostring(CurrentFiltre3))) or string.find(string.lower(v.label), string.lower(tostring(CurrentFiltre3))) then
                vAdminPlayerJob.Button(
                    v.label or "Inconnu",
                    nil,
                    k or "Inconnu",
                    nil,
                    false,
                    function()
                        local level = KeyboardImput("Choisir le grade de 1 à 5") 
                        if level ~= nil or level ~= "" then
                            if tonumber(level) >= 1 and tonumber(level) <= 5 then
                                TriggerServerEvent("core:staffActionLog", token, "/setjob", Admindata.id .. " - Job : " .. k .. " - Grade : " .. level)
                                TriggerEvent("jobs:unloadcurrent")
                                TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(Admindata.id), k, tonumber(level))
    
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "~s Vous avez changé le job de " .. Admindata.firstname .. " " .. Admindata.lastname .. " en " .. k .. " grade " .. level
                                })
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "~s Le grade n'existe pas"
                                })
                            end
                        end
                    end
                )
            end
        else
            vAdminPlayerJob.Button(
                v.label or "Inconnu",
                nil,
                k or "Inconnu",
                nil,
                false,
                function()
                    local level = KeyboardImput("Choisir le grade de 1 à 5") 
                    if level ~= nil or level ~= "" then
                        if tonumber(level) >= 1 and tonumber(level) <= 5 then
                            TriggerServerEvent("core:staffActionLog", token, "/setjob", Admindata.id .. " - Job : " .. k .. " - Grade : " .. level)
                            TriggerEvent("jobs:unloadcurrent")
                            TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(Admindata.id), k, tonumber(level))

                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                content = "~s Vous avez changé le job de " .. Admindata.firstname .. " " .. Admindata.lastname .. " en " .. k .. " grade " .. level
                            })
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s Le grade n'existe pas"
                            })
                        end
                    end
                end
            )
        end
    end
end

function renderPlayerCrew()
    vAdminPlayerCrew.Title("Crew", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    vAdminPlayerCrew.Button(
        "Changer",
        "le crew par nom",
        nil,
        "chevron",
        false,
        function()
            local crew = KeyboardImput("Nom du crew")
            local rank = KeyboardImput("Rank du crew 1-5")
            if crew ~= nil and crew ~= "" then
                for k,v in pairs(vAdminAllCrews) do
                    if v.name == crew then
                        TriggerSecurEvent("core:setCrew", token, Admindata.id, crew, rank or 1)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            content = "~s Vous avez changé le crew de " .. Admindata.firstname .. " " .. Admindata.lastname .. " en " .. crew
                        })

                        return
                    end
                end
            end
        end
    )

    if CurrentFiltre4 == nil then 
        vAdminPlayerCrew.Button(
            "Rechercher",
            "un crew par nom",
            nil,
            "search",
            false,
            function()
                CurrentFiltre4 = nil
                local TargetCrew = KeyboardImput("Entrer un nom de crew")
                TargetCrew = tostring(TargetCrew)
                if TargetCrew ~= nil and string.len(TargetCrew) ~= 0 then
                    if type(TargetCrew) == 'string' then
                        CurrentFiltre4 = TargetCrew
                    
                        vAdminPlayerCrew.refresh()
                    end
                else
                    CurrentFiltre4 = nil
                
                    vAdminPlayerCrew.refresh()
                end
            end
        )
    else
        vAdminPlayerCrew.Button(
            CurrentFiltre4,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre4 = nil

                vAdminPlayerCrew.refresh()
            end
        )
    end

    vAdminPlayerCrew.Separator(nil)

    if vAdminAllCrews == nil then
        vAdminPlayerCrew.Separator("Aucun", "crew à afficher")
    end

    for k, v in pairs(vAdminAllCrews) do
        if CurrentFiltre4 ~= nil then
            if v == tonumber(CurrentFiltre4) or string.find(string.lower(v.name), string.lower(tostring(CurrentFiltre4))) then
                vAdminPlayerCrew.Button(
                    Admindata.crew == v.name and "Retirer" or "Recruter",
                    v.name or "Inconnu",
                    v.id,
                    "chevron",
                    false,
                    function()
                        --TriggerServerEvent("core:setCrew", token, Admindata.id, v.name, 1)

                        if Admindata.crew == v.name then
                            TriggerSecurEvent("core:unsetCrew", token, Admindata.id, v.name, 0)
                        else
                            local keyboardIn = KeyboardImput("Rank du crew 1-5")
                            if keyboardIn and keyboardIn ~= "" then
                                keyboardIn = tonumber(keyboardIn)
                                if keyboardIn and keyboardIn >= 1 and keyboardIn <= 5 then
                                    TriggerSecurEvent("core:setCrew", token, Admindata.id, v.name, keyboardIn)
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "~s Le rank doit être compris entre 1 et 5"
                                    })
                                end
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "~s Le rank doit être compris entre 1 et 5"
                                })
                            end
                        end
                    
                        vAdminPlayerCrew.refresh()
                    end
                )
            end
        else
            vAdminPlayerCrew.Button(
                Admindata.crew == v.name and "Retirer" or "Recruter",
                v.name or "Inconnu",
                v.id,
                "chevron",
                false,
                function()
                    --TriggerServerEvent("core:setCrew", token, Admindata.id, v.name, 1)

                    if Admindata.crew == v.name then
                        TriggerSecurEvent("core:unsetCrew", token, Admindata.id, v.name, 0)
                    else
                        local keyboardIn = KeyboardImput("Rank du crew 1-5")
                        if keyboardIn and keyboardIn ~= "" then
                            keyboardIn = tonumber(keyboardIn)
                            if keyboardIn and keyboardIn >= 1 and keyboardIn <= 5 then
                                TriggerSecurEvent("core:setCrew", token, Admindata.id, v.name, keyboardIn)
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "~s Le rank doit être compris entre 1 et 5"
                                })
                            end
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "~s Le rank doit être compris entre 1 et 5"
                            })
                        end
                    end

                    vAdminPlayerCrew.refresh()
                end
            )
        end
    end
end

checkIfItemIsBlacklisted = function(item) 
    local itemsBlacklist = {
        ["money"] = 2,
        ["giletc4"] = 4,
        ["weapon_rpg"] = 4,
        ["weapon_raypistol"] = 4,
        ["weapon_emplauncher"] = 4,
        ["weapon_minigun"] = 4,
        ["weapon_raycarbine"] = 4,
        ["weapon_heavyrifle"] = 4,
        ["weapon_tacticalrifle"] = 60,
        ["weapon_militaryrifle"] = 60,
        ["weapon_grenadelauncher"] = 4,
        ["weapon_sniperrifle"] = 4,
        ["tunertablet"] = 4,
        ["ammobox_rocket"] = 4,
        ["ammo_rocket"] = 4,
        ["ammobox_snip"] = 4,
        ["ammo_snip"] = 4,
        ["ammobox_global"] = 4,
        ["weapon_mg"] = 4,
        ["weapon_combatmg"] = 4,
        ["weapon_combatmg_mk2"] = 4,
        ["weapon_heavysniper"] = 4,
        ["weapon_heavysniper_mk2"] = 4,
        ["weapon_marksmanrifle"] = 4,
        ["weapon_marksmanrifle_mk2"] = 4,
        ["weapon_precisionrifle"] = 4,
        ["weapon_grenadelauncher_smoke"] = 4,
        ["weapon_firework"] = 4,
        ["weapon_railgun"] = 4,
        ["weapon_hominglauncher"] = 4,
        ["weapon_compactlauncher"] = 4,
        ["weapon_rayminigun"] = 4,
        ["weapon_railgunxm3"] = 4,
        ["weapon_pistol_mk2"] = 4,
        ["weapon_snspistol_mk2"] = 4,
        ["weapon_revolver_mk2"] = 4,
        ["weapon_navyrevolver"] = 4,
        ["weapon_gadgetpistol"] = 4,
        ["weapon_stungun"] = 4,
        ["weapon_appistol"] = 4,
        ["weapon_marksmanpistol"] = 4,
        ["weapon_smg_mk2"] = 4,
        ["weapon_ceramicpistol"] = 4,
        ["weapon_assaultsmg"] = 4,
        ["weapon_tecpistol"] = 4,
        ["weapon_combatpdw"] = 4,
        ["weapon_pumpshotgun_mk2"] = 4,
        ["weapon_assaultrifle_mk2"] = 4,
        ["weapon_carbinerifle_mk2"] = 4,
        ["weapon_advancedrifle"] = 4,
        ["weapon_specialcarbine_mk2"] = 4,
        ["weapon_bullpuprifle_mk2"] = 4,
        ["weapon_militaryrifle"] = 4,
        ["weapon_tacticalrifle"] = 4,
        ["weapon_grenade"] = 4,
        ["weapon_flare"] = 4
    }

    local itemConfig = itemsBlacklist[item]
    if itemConfig and p:getPermission() <= itemConfig then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~s Non, non, non, seulement le staff peut donner cet item"
        })
        return true
    else 
        return false
    end
end

function renderPlayerGiveItem()
    vAdminPlayerGiveItem.Button(
        "Give",
        "un item par nom",
        nil,
        "chevron",
        false,
        function()
            local item = KeyboardImput("ID de l'item")

            if item ~= nil or item ~= "" then
                
                if checkIfItemIsBlacklisted(item) then return end

                local amount = KeyboardImput("Quantité")

                if amount ~= nil or amount ~= "" then
                    TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(Admindata.id), item, tonumber(count), {})
                    TriggerServerEvent("core:staffActionLog", token, "Give d'item", Admindata.id .. " - Item : " .. item .. " - Quantité : " .. tonumber(count))

                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "~s Vous avez donné " .. amount .. " " .. item .. " à " .. Admindata.firstname .. " " .. Admindata.lastname
                    })
                end
            end
        end
    )
    if CurrentFiltre2 == nil then 
        vAdminPlayerGiveItem.Button(
            "Rechercher",
            "un item par nom",
            nil,
            "search",
            false,
            function()
                CurrentFiltre2 = nil
                local TargetItem = KeyboardImput("Entrer un nom d'item")
                TargetItem = tostring(TargetItem)
                if TargetItem ~= nil and string.len(TargetItem) ~= 0 then
                    if type(TargetItem) == 'string' then
                        CurrentFiltre2 = TargetItem
                    
                        vAdminPlayerGiveItem.refresh()
                    end
                else
                    CurrentFiltre2 = nil
                
                    vAdminPlayerGiveItem.refresh()
                end
            end
        )
    else
        vAdminPlayerGiveItem.Button(
            CurrentFiltre2,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre2 = nil

                vAdminPlayerGiveItem.refresh()
            end
        )
    end

    vAdminPlayerGiveItem.Separator(nil)

    for k, v in pairs(items) do
        if k ~= "maxWeight" then
            if CurrentFiltre2 ~= nil then 
                if k == tonumber(CurrentFiltre2) or string.find(string.lower(k), string.lower(tostring(CurrentFiltre2))) or string.find(string.lower(v.label), string.lower(tostring(CurrentFiltre2))) then
                    vAdminPlayerGiveItem.Button(
                        v.label or "Inconnu",
                        k or "Inconnu",
                        v.weight .. " kg" or "Inconnu",
                        nil,
                        false,
                        function()

                            if checkIfItemIsBlacklisted(k) then return end
                            
                            local count = KeyboardImput("Quantité à donner")
    
                            if count ~= nil or count ~= "" then
                                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(Admindata.id), k, tonumber(count), {})
                                TriggerServerEvent("core:staffActionLog", token, "Give d'item", tonumber(Admindata.id) .. " - Item : " .. k .. " - Quantité : " .. tonumber(count))

                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "~s Vous avez donné " .. count .. " " .. k .. " à " .. Admindata.firstname .. " " .. Admindata.lastname
                                })
                            end
                        end
                    )
                end
            else
                vAdminPlayerGiveItem.Button(
                    v.label or "Inconnu",
                    k or "Inconnu",
                    v.weight .. " kg" or "Inconnu",
                    nil,
                    false,
                    function()

                        if checkIfItemIsBlacklisted(k) then return end

                        local count = KeyboardImput("Quantité à donner")

                        if count ~= nil or count ~= "" then
                            TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(Admindata.id), k, tonumber(count), {})
                            TriggerServerEvent("core:staffActionLog", token, "Give d'item", tonumber(Admindata.id) .. " - Item : " .. k .. " - Quantité : " .. tonumber(count))

                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                content = "~s Vous avez donné " .. count .. " " .. k .. " à " .. Admindata.firstname .. " " .. Admindata.lastname
                            })
                        end
                    end
                )
            end
        end
    end
end

function renderPlayerInventory()
    vAdminPlayerInventory.Title("Inventaire", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    vAdminPlayerInventory.Button(
        "Items",
        nil,
        nil,
        "chevron",
        false,
        function()
            vAdminDataItem = {}
            for k, v in pairs(Admindata.inv) do
                if v.type == "items" then
                    table.insert(vAdminDataItem, v)
                    vAdminDataItemName = "Items"
                end
            end 
        end,
        vAdminPlayerInventoryData
    )
    vAdminPlayerInventory.Button(
        "Armes",
        nil,
        nil,
        "chevron",
        false,
        function()
            vAdminDataItem = {}
            for k, v in pairs(Admindata.inv) do
                if v.type == "weapons" then
                    table.insert(vAdminDataItem, v)
                    vAdminDataItemName = "Armes"
                end
            end 
        end,
        vAdminPlayerInventoryData
    )
    vAdminPlayerInventory.Button(
        "Vêtements",
        nil,
        nil,
        "chevron",
        false,
        function()
            vAdminDataItem = {}
            for k, v in pairs(Admindata.inv) do
                if v.type == "clothes" then
                    table.insert(vAdminDataItem, v)
                    vAdminDataItemName = "Vêtements"
                end
            end 
        end,
        vAdminPlayerInventoryData
    )
end

function renderPlayerInventoryData()
    vAdminPlayerInventoryData.Title("Inventaire " .. vAdminDataItemName, "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    if vAdminDataItem.count == 0 then
        vAdminPlayerInventoryData.Separator("Aucun", vAdminDataItemName .. " a afficher")
    end

    for i = 1, #vAdminDataItem do
        vAdminPlayerInventoryData.Button(
            vAdminDataItem[i].name,
            vAdminDataItem[i].label,
            vAdminDataItem[i].count,
            nil,
            false,
            function()
                local count = KeyboardImput("Quantité à retirer")

                if count ~= nil or count ~= "" then
                    TriggerServerEvent("core:RemoveItemToInventoryStaff", token, tonumber(Admindata.id), vAdminDataItem[i].name, tonumber(count), vAdminDataItem[i].metadatas)
                    TriggerServerEvent("core:staffActionLog", token, "Retrait d'item", tonumber(Admindata.id) .. " - Item : " .. vAdminDataItem[i].name .. " - Quantité : " .. tonumber(count))
                end
            end
        )
    end
end

function renderPlayerVehicleMenu()
    vAdminPlayerVehicleMenu.Title("Véhicules", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    vAdminPlayerVehicleMenu.Separator(
        "Owned", 
        #Admindata.veh.owned or 0,
        "Co-owned",
        #Admindata.veh.coowned or 0
    )
    vAdminPlayerVehicleMenu.Separator(
        "Job", 
        #Admindata.veh.job or 0,
        "Crew",
        #Admindata.veh.crew or 0
    )

    vAdminPlayerVehicleMenu.Separator(nil)

    vAdminPlayerVehicleMenu.Button(
        "Owned",
        nil,
        nil,
        "chevron",
        #Admindata.veh.owned == 0,
        function()
        end,
        vAdminPlayerVehicleOwned
    )
    vAdminPlayerVehicleMenu.Button(
        "Co-owned",
        nil,
        nil,
        "chevron",
        #Admindata.veh.coowned == 0,
        function()
        end,
        vAdminPlayerVehicleCoOwned
    )
    vAdminPlayerVehicleMenu.Button(
        "Job",
        nil,
        nil,
        "chevron",
        #Admindata.veh.job == 0,
        function()
        end,
        vAdminPlayerVehicleJob
    )
    vAdminPlayerVehicleMenu.Button(
        "Crew",
        nil,
        nil,
        "chevron",
        #Admindata.veh.crew == 0,
        function()
        end,
        vAdminPlayerVehicleCrew
    )

end

function renderPlayerVehicleOwned()
    vAdminPlayerVehicleOwned.Title("Owned Véhicules", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    vAdminPlayerVehicleOwned.Textbox(
        "Si le véhicule est en fourrière vous pouvez le sortir en appuyant sur ENTER, sinon il sera mit en fourrière.",
        "Information"
    )

    if Admindata.veh.owned ~= nil then
        for k, v in pairs(Admindata.veh.owned) do
            if v.stored == 1 then
                vAdminPlayerVehicleOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Sorti(e)",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleOwned.refresh()
                    end
                )
            end

            if v.stored == 2 then
                vAdminPlayerVehicleOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Fourrière",
                    nil,
                    false,
                    function()
                        local playerPos = GetEntityCoords(PlayerPedId())

                        if vehicle.IsSpawnPointClear(vector3(playerPos.x, playerPos.y, playerPos.z), 3.0) then
                            local vehProps = TriggerServerCallback("core:getVehProps", v.currentPlate)
                            local veh = vehicle.create(v.name, playerPos, vehProps)

                            TaskWarpPedIntoVehicle(p:ped(), veh, -1)
                            TriggerServerEvent("core:SetVehicleOut", string.upper(v.currentPlate), VehToNet(veh), veh)

                            SetVehicleFuelLevel(
                                veh,
                                GetVehicleHandlingFloat(veh, "CHandlingData", "fPetrolTankVolume")
                            )
                            
                            vAdminPlayerVehicleOwned.refresh()
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s Le véhicule " .. v.name .. " ne peut pas être spawn ici."
                            })
                        end
                    end
                )
            end

            if v.stored == 3 then
                vAdminPlayerVehicleOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Garage",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleOwned.refresh()
                    end
                )
            end

            if v.stored ~= 1 and v.stored ~= 2 and v.stored ~= 3 then
                vAdminPlayerVehicleOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Inconnu",
                    nil,
                    false,
                    function()end
                )
            end
        end
    else
        vAdminPlayerVehicleOwned.Separator("Aucun", "véhicule")
    end
end

function renderPlayerVehicleCoOwned()
    vAdminPlayerVehicleCoOwned.Title("Co-Owned Véhicules", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    if Admindata.veh.coowned ~= nil then
        for k, v in pairs(Admindata.veh.coowned) do
            if v.stored == 1 then
                vAdminPlayerVehicleCoOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Sorti(e)",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleCoOwned.refresh()
                    end
                )
            end

            if v.stored == 2 then
                vAdminPlayerVehicleCoOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Fourrière",
                    nil,
                    false,
                    function()end
                )
            end

            if v.stored == 3 then
                vAdminPlayerVehicleCoOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Garage",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleCoOwned.refresh()
                    end
                )
            end

            if v.stored ~= 1 and v.stored ~= 2 and v.stored ~= 3 then
                vAdminPlayerVehicleCoOwned.Button(
                    v.name,
                    v.currentPlate,
                    "Inconnu",
                    nil,
                    false,
                    function()end
                )
            end
        end
    else
        vAdminPlayerVehicleCoOwned.Separator("Aucun", "véhicule")
    end
end

function renderPlayerVehicleCrew()
    vAdminPlayerVehicleCrew.Title("Crew Véhicules", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    if Admindata.veh.job ~= nil then
        for k, v in pairs(Admindata.veh.job) do
            if v.stored == 1 then
                vAdminPlayerVehicleCrew.Button(
                    v.name,
                    v.currentPlate,
                    "Sorti(e)",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleCrew.refresh()
                    end
                )
            end

            if v.stored == 2 then
                vAdminPlayerVehicleCrew.Button(
                    v.name,
                    v.currentPlate,
                    "Fourrière",
                    nil,
                    false,
                    function()end
                )
            end

            if v.stored == 3 then
                vAdminPlayerVehicleCrew.Button(
                    v.name,
                    v.currentPlate,
                    "Garage",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleCrew.refresh()
                    end
                )
            end

            if v.stored ~= 1 and v.stored ~= 2 and v.stored ~= 3 then
                vAdminPlayerVehicleCrew.Button(
                    v.name,
                    v.currentPlate,
                    "Inconnu",
                    nil,
                    false,
                    function()end
                )
            end
        end
    else
        vAdminPlayerVehicleCrew.Separator("Aucun", "véhicule")
    end
end

function renderPlayerVehicleJob()
    vAdminPlayerVehicleJob.Title("Job Véhicules", "de " .. Admindata.firstname .. " " .. Admindata.lastname, Admindata.id, Admindata.uniqueID)

    if Admindata.veh.job ~= nil then
        for k, v in pairs(Admindata.veh.job) do
            if v.stored == 1 then
                vAdminPlayerVehicleJob.Button(
                    v.name,
                    v.currentPlate,
                    "Sorti(e)",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleJob.refresh()
                    end
                )
            end

            if v.stored == 2 then
                vAdminPlayerVehicleJob.Button(
                    v.name,
                    v.currentPlate,
                    "Fourrière",
                    nil,
                    false,
                    function()end
                )
            end

            if v.stored == 3 then
                vAdminPlayerVehicleJob.Button(
                    v.name,
                    v.currentPlate,
                    "Garage",
                    nil,
                    false,
                    function()
                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.currentPlate)
                        TriggerEvent("core:RefreshData", playerData)

                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Le véhicule " .. v.name .. " a été mit en fourrière."
                        })

                        vAdminPlayerVehicleJob.refresh()
                    end
                )
            end

            if v.stored ~= 1 and v.stored ~= 2 and v.stored ~= 3 then
                vAdminPlayerVehicleJob.Button(
                    v.name,
                    v.currentPlate,
                    "Inconnu",
                    nil,
                    false,
                    function()end
                )
            end
        end
    else
        vAdminPlayerVehicleJob.Separator("Aucun", "véhicule")
    end
end