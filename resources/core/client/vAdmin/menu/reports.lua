local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function renderReportsList()
    if vAdminAdminData.reports == nil then
        vAdminReports.Separator("Aucun", "report en attente")
        return
    end

    for k, v in pairs(vAdminAdminData.reports) do

        if k == 1 then 
            vAdminMain.ReportPreview(k, v.time, v.msg)
        end

        vAdminReports.Button(
            "N°" .. k,
            v.name,
            v.id,
            nil,
            false,
            function()
                ReportSelected = nil
                ReportSelected = k
                local VerifReport = TriggerServerCallback("core:VerifReport", ReportSelected)
            end,
            vAdminReport
        )
    end
end

function renderReportMenu()
    if VerifReport == false then
        vAdminReport.Title("Report", "supprimé")
        vAdminReport.Button(
            "Retour",
            nil,
            nil,
            "chevron",
            false,
            function() end,
            vAdminReports
        )
    else
        vAdminReport.Title("Report N°" .. ReportSelected, "de " .. vAdminAdminData.reports[ReportSelected].name, vAdminAdminData.reports[ReportSelected].id, vAdminAdminData.reports[ReportSelected].uniqueID)
        vAdminReport.Textbox(vAdminAdminData.reports[ReportSelected].msg)

        vAdminReport.Title("Actions", "possibles")
        vAdminReport.Button(
            "Fermer",
            "le report",
            nil,
            "chevron",
            false,
            function()
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez fermer le report n°"..ReportSelected.."."
                })
                TriggerServerEvent("core:delReport", ReportSelected)
            end,
            vAdminReports
        )
        vAdminReport.Button(
            "Envoyer",
            "un message",
            nil,
            "chevron",
            false,
            function()
                local msg = KeyboardImput("Message", "")

                if msg ~= nil or msg ~= "" then
                    TriggerServerEvent("core:SendMessage", token, vAdminAdminData.reports[ReportSelected].id, msg)
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Message envoyé à ~s " .. vAdminAdminData.reports[ReportSelected].name
                    })
                end
            end
        )
        vAdminReport.Button(
            "Envoyer",
            "un message chiant",
            nil,
            "chevron",
            false,
            function()
                local msg = KeyboardImput("Message", "")

                if msg ~= nil or msg ~= "" then
                    TriggerServerEvent("core:vnotif:createAlert:player", token, msg, vAdminAdminData.reports[ReportSelected].id)
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Message chiant envoyé à ~s " .. vAdminAdminData.reports[ReportSelected].name
                    })
                end
            end
        )
        vAdminReport.Checkbox(
            "Spectate",
            "le joueur",
            p:getPermission() <= 2,
            vAdminpPlayer.spectate,
            function(checked)
                vAdminpPlayer.spectate = checked
                if checked then
                    TriggerServerEvent("core:staffActionLog", token, "/spectate", vAdminAdminData.reports[ReportSelected].id)
                    TriggerServerEvent("core:StaffSpectate", token, vAdminAdminData.reports[ReportSelected].id)
                else
                    TriggerServerEvent("core:staffActionLog", token, "/unspectate", vAdminAdminData.reports[ReportSelected].id)
                    TriggerServerEvent("core:StaffSpectate", token, vAdminAdminData.reports[ReportSelected].id)
                end
            end
        )
        vAdminReport.Button(
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
        vAdminReport.Button(
            "Go to",
            nil,
            nil,
            "chevron",
            false,
            function()
                TriggerServerEvent("core:staffActionLog", token, "/goto", vAdminAdminData.reports[ReportSelected].id)
                TriggerServerEvent("core:GotoBring", token, nil, vAdminAdminData.reports[ReportSelected].id)
            end
        )
        vAdminReport.Button(
            "Bring",
            nil,
            nil,
            "chevron",
            false,
            function()
                local playerID = tonumber(vAdminAdminData.reports[ReportSelected].id)
                local coords = TriggerServerCallback("core:CoordsOfPlayer", token, playerID)
                bringData[playerID] = {coords = coords}
                TriggerServerEvent("core:staffActionLog", token, "/bring", playerID)
                TriggerServerEvent("core:GotoBring", token, playerID, nil)
            end
        )   
        if bringData[tonumber(vAdminAdminData.reports[ReportSelected].id)] then
            vAdminReport.Button(
                "Return",
                nil,
                nil,
                "chevron",
                false,
                function()
                    local playerID = tonumber(vAdminAdminData.reports[ReportSelected].id)
                    local data = bringData[playerID]
                    TriggerServerEvent("core:staffActionLog", token, "/return", playerID)
                    TriggerServerEvent("core:ReturnPositionPlayer", token, playerID, data.coords)
                    bringData[playerID] = nil -- Remove player from bring data after return
                end
            )
        else
            vAdminReport.Button(
                "Return",
                nil,
                nil,
                "lock",
                true,
                function() end
            )
        end        
        vAdminReport.Button(
            "Revive",
            nil,
            nil,
            "heart",
            false,
            function()
                TriggerServerEvent("core:staffActionLog", token, "/revive", vAdminAdminData.reports[ReportSelected].id)
                TriggerServerEvent("core:RevivePlayer", token, vAdminAdminData.reports[ReportSelected].id)
                TriggerServerEvent("core:createvNotif", token, tonumber(vAdminAdminData.reports[ReportSelected].id), 'VERT', "Vous avez été réanimé par un membre du staff.", 5)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez revive ~s " .. vAdminAdminData.reports[ReportSelected].name
                })
            end
        )
        vAdminReport.Button(
            "Heal",
            nil,
            nil,
            "heart",
            false,
            function()
                TriggerServerEvent("core:HealthPlayer", token, vAdminAdminData.reports[ReportSelected].id)
                TriggerServerEvent("core:createvNotif", token, tonumber(vAdminAdminData.reports[ReportSelected].id), 'VERT', "Vous avez été heal par un membre du staff.", 5)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez heal ~s " .. vAdminAdminData.reports[ReportSelected].name
                })
            end
        )
        vAdminReport.Button(
            "Kick",
            nil,
            nil,
            "chevron",
            false,
            function()
                local reason = KeyboardImput("Raison du kick")

                if reason ~= nil and reason ~= "" then
                    TriggerServerEvent("core:KickPlayer", token, vAdminAdminData.reports[ReportSelected].id, reason)
                end
            end
        )
        vAdminReport.List(
            "Ban",
            nil,
            p:getPermission() <= 2,
            tableBan,
            Idtblban,
            function(index, item)
                local reason = KeyboardImput("Raison du ban")
                local time = nil
                if tableBan[Idtblban] ~= "Perm" then
                    time = KeyboardImput("Temps")
                else
                    time = 0
                end
                if reason ~= nil and reason ~= "" and time ~= nil and time ~= "" then
                    TriggerServerEvent("core:staffBanAction", token, "/ban",
                        vAdminAdminData.reports[ReportSelected].id .. "** - Raison :** " .. reason .. "** - Temps : **" .. time)
                    TriggerServerEvent("core:ban:banplayer", token, tonumber(vAdminAdminData.reports[ReportSelected].id), reason, tonumber(time),
                        GetPlayerServerId(PlayerId()), tableBan[Idtblban])
                end
            end
        )
        vAdminReport.Button(
            "Screen",
            "écran du joueur",
            nil,
            "chevron",
            false,
            function()
                TriggerServerEvent("core:TakeScreenBiatch", token, vAdminAdminData.reports[ReportSelected].id)

                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "Vous avez pris un screen de ~s " .. vAdminAdminData.reports[ReportSelected].name
                })
            end
        )
    end
end