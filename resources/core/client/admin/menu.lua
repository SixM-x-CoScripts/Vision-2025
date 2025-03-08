local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local variables = {}

local open = false
local checked = false
local AdminInAction = false
local InsideInstanceAdmin = 0
local nbReport = nil
local text = ""

local tableBan, Idtblban = {"Heures", "Jours", "Perm"}, 1

local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "vision", "Banner_Administration")

local report = RageUI.CreateSubMenu(main, "", "Report(s)", 0.0, 0.0, "vision", "Banner_Administration")
local report2 = RageUI.CreateSubMenu(report, "", "Report(s)", 0.0, 0.0, "vision", "Banner_Administration")

local players = RageUI.CreateSubMenu(main, "", "Joueurs", 0.0, 0.0, "vision", "Banner_Administration")
local mod = RageUI.CreateSubMenu(main, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")

local pedsMenu = RageUI.CreateSubMenu(mod, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")
local dataplayers = RageUI.CreateSubMenu(players, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")

local InvPlayer = RageUI.CreateSubMenu(dataplayers, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")
local dataInvPlayer = RageUI.CreateSubMenu(InvPlayer, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")

local vehJoueur = RageUI.CreateSubMenu(dataplayers, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")
local giveItemMenu = RageUI.CreateSubMenu(dataplayers, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")
local jobMenu = RageUI.CreateSubMenu(players, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")
local crewMenu = RageUI.CreateSubMenu(players, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")

local varMenu = RageUI.CreateSubMenu(mod, "", "Moderation", 0.0, 0.0, "vision", "Banner_Administration")

local ZoneSafe = RageUI.CreateSubMenu(mod, "", "Zone Safe", 0.0, 0.0, "vision", "Banner_Administration")
local listZoneSafe = RageUI.CreateSubMenu(ZoneSafe, "", "Zone Safe", 0.0, 0.0, "vision", "Banner_Administration")
local creationZoneSafe = RageUI.CreateSubMenu(ZoneSafe, "", "Zone Safe", 0.0, 0.0, "vision", "Banner_Administration") 

local illegalMenu = RageUI.CreateSubMenu(mod, "", "Gesion de l'illegal", 0.0, 0.0, "vision", "Banner_Administration")

local crewGestion = RageUI.CreateSubMenu(illegalMenu, "", "Gesion des crews", 0.0, 0.0, "vision", "Banner_Administration")
local crewInfos = RageUI.CreateSubMenu(crewGestion, "", "Info du crew", 0.0, 0.0, "vision", "Banner_Administration")
local playersCrew = RageUI.CreateSubMenu(crewInfos, "", "Info du crew", 0.0, 0.0, "vision", "Banner_Administration")
local playerCrew = RageUI.CreateSubMenu(playersCrew, "", "Info du crew", 0.0, 0.0, "vision", "Banner_Administration")
local createLabs = RageUI.CreateSubMenu(crewInfos, "", "Info des labs", 0.0, 0.0, "vision", "Banner_Administration")
local propertiesCrew = RageUI.CreateSubMenu(crewInfos, "", "Proprietes du crew", 0.0, 0.0, "vision", "Banner_Administration")
local propertiesCrewActions = RageUI.CreateSubMenu(propertiesCrew, "", "Proprietes du crew", 0.0, 0.0, "vision", "Banner_Administration")
local vehCrew = RageUI.CreateSubMenu(crewInfos, "", "Vehicules du crew", 0.0, 0.0, "vision", "Banner_Administration")
local vehCrewActions = RageUI.CreateSubMenu(vehCrew, "", "Vehicules du crew", 0.0, 0.0, "vision", "Banner_Administration")

local blips = {}
local data = {}
local dataItem = {}
modsAdmin = {
    noclip = false,
    freecam = false,
    godmode = false,
    invisible = false,
    blips = false
}

local AllCrews = nil
local crewInfo, crewMembers, crewGrade = nil, nil, nil
local playersInfo, playerInfo = nil, nil
local xpCrew, levelCrew = 0, 1
local typeLabs, labs = nil, nil
local labsType = {"coke", "weed", "meth", "fentanyl"}
local labsTypeList = 1
local crewTypes = {"normal", "pf", "gang", "mc", "orga", "mafia"}
local crewTypesList = 1
local propertiesCrewList, vehCrewList = {}, {}
local propertiesCrewAction, vehCrewAction = {}, {}
local perm3, perm4, perm5, perm69 = true, true, true, true
CreateThread(function()
    while p == nil do Wait(1) end
    --TriggerServerEvent("core:loadVariables", token)
    if p:getPermission() >= 3 then
        perm3 = true
    end
    if p:getPermission() >= 4 then
        perm4 = true
    end
    if p:getPermission() >= 5 then
        perm5 = true
    end
    if p:getPermission() >= 69 then
        perm69 = true
    end
end)

local function formatNumber(num)
    return tonumber(string.format("%.2f", num))
end

CanReturn = false
IdBring = nil
coordsLastBring = nil

Staff = {
    pLastPosition = nil,
    pLastId = nil,
    pLastIdSpectate = nil
}
local pPlayer = {
    freeze = false,
    spectate = false,
}

local reports = {}
local GamerTag = {}
local Player = {}

local CurrentFiltre = nil
local CurrentFiltre2 = nil
local CurrentFiltre3 = nil
local CurrentFiltre4 = nil
local CurrentFiltre5 = nil

local oldskin = nil
local playerOldSkin = nil
local notMe = false

local ReportSelected = nil

main.Closed = function()
    open = false
    RageUI.CloseAll()
end

--[[ CreateThread(function()
    while true do
        Wait(1000)
        updateAdminOverlay()
    end
end)

local function updateAdminOverlay()
    exports['aHUD']:updateAdminOverlay(AdminInAction,nbReport)
end ]]

--local function GetVariable(name)
--    return variables[name]
--end

-- Enlever les commentaires pour le FA

function showOption()
    CreateThread(function()
        while AdminInAction do
            Wait(0)
            if nbReport == nil then Wait(300) end
            Visual.Subtitle("~o~"..nbReport.." ~s~Report(s) en cours", 1)
        end
    end)
end

local function split(str, sep)
    local _sep = sep or ':'
    local _fields = {}
    local _pattern = string.format("([^%s]+)", _sep)
    str:gsub(_pattern, function(c) _fields[#_fields + 1] = c end)
    return _fields
end

local function UpdateVariable(_table, name, value)
    local levels = {}
    for level in name:gmatch("[^%.]+") do
      table.insert(levels, level)
    end

    local currentTable = _table
    for i = 1, #levels - 1 do
      local level = levels[i]
      if not currentTable[level] or type(currentTable[level]) ~= "table" then
        currentTable[level] = {}
      end
      currentTable = currentTable[level]
    end
    currentTable[levels[#levels]] = value
end

local subMenu = {}
local openMenu = false
function MenuFromTable(table, prefix)
    local _value = ''
    local _name = ''
    print("Loading", subMenu[prefix], prefix)
    openMenu = true
    Citizen.CreateThread(function()
        while openMenu do
            RageUI.IsVisible(subMenu[prefix], function()
                --print("LoadingIN", subMenu[prefix], prefix)
                for name, value in pairs(table) do
                    --print("name", name)
                    if type(value) == 'table' and value.x == nil and value.y == nil and value.z == nil then
                        -- check if table is not a position (x, y, z)
                        if prefix ~= nil then
                            --print("WARNING: table12", value, prefix, name, subMenu[prefix])
                            --print("WARNING: table22", value, prefix, name, subMenu[prefix.. '.' ..name])
                            subMenu[prefix.. "." ..name] = RageUI.CreateSubMenu(subMenu[prefix], "", prefix.. "." ..name, 0.0, 0.0, "vision", "Banner_Administration")
                            RageUI.Button(name, false, { RightLabel = ">" }, true, {
                                onSelected = function()
                                        print("WARNING: table222", value, prefix, name, subMenu[prefix])
                                        MenuFromTable(value, prefix.. '.' ..name)
                                    end
                                }, subMenu[prefix.. '.' ..name])
                            --print("WARNING: table32", value, prefix, name)
                        end
                    else
                        --subMenu[prefix.. '.' ..name] = RageUI.CreateSubMenu(subMenu[prefix], "", prefix.. '.' ..name, 0.0, 0.0, "vision", "Banner_Administration")
                        -- trim value to 10 characters
                        if type(value) == 'table' and value.w ~= nil then
                            _value = "🧭"
                        elseif type(value) == 'table' then
                            _value = "🗺️"
                        elseif type(value) == "string" and string.len(value) > 10 then
                            _value = string.sub(value, 1, 10) .. '...'
                        else
                            if value == "true" then
                                _value = true
                            elseif value == "false" then
                                _value = false
                            else _value = value end
                        end
                        if prefix ~= nil then
                            _name = prefix.. '.' ..name
                        else
                            _name = name
                        end
                        if type(_value) == "boolean" or string.lower(name) == "active" then
                            if type(_value) ~= "boolean" then 
                                _value = false
                            end
                            RageUI.Checkbox(name, false, _value, {}, {
                                onChecked = function()
                                    local varname = split(_name, '.')[1]
                                    UpdateVariable(vAdminVariables, _name, true)
                                    TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                                end,
                                onUnChecked = function()
                                    local varname = split(_name, '.')[1]
                                    UpdateVariable(vAdminVariables, _name, false)
                                    TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                                end
                            })
                        else
                            RageUI.Button(name, nil, { RightLabel = _value }, true, {
                                onSelected = function()
                                    if type(value) == "table" and value.w ~= nil then
                                        local coords = GetEntityCoords(PlayerPedId())
                                        local heading = GetEntityHeading(PlayerPedId())
                                        local varname = split(_name, '.')[1]
                                        UpdateVariable(vAdminVariables, _name, {
                                            x = formatNumber(coords.x),
                                            y = formatNumber(coords.y),
                                            z = formatNumber(coords.z),
                                            w = formatNumber(heading)
                                        })
                                        TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                                    elseif type(value) == "table" then
                                        local pos = p:pos()
                                        local varname = split(_name, '.')[1]
                                        UpdateVariable(vAdminVariables, _name, {
                                            x = formatNumber(pos.x),
                                            y = formatNumber(pos.y),
                                            z = formatNumber(pos.z)
                                        })
                                        TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                                    else 
                                        local _input = KeyboardImput('Redéfinir '.. _name)
                                        if _input ~= nil or _input ~= "" then
                                            local varname = split(_name, '.')[1]
                                            UpdateVariable(vAdminVariables, _name, _input)
                                            TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                                            _value = _input
                                        end
                                    end
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Vous avez redéfini la variable ~s~" .. _name
                                    })
                                end
                            })
                        end
                    end
                end
            end)
            Wait(1)
        end
    end)
end


local function OpenAdminMenu()
    if p:getPermission() < 3 then
        return
    end
    if open then
        open = false
        RageUI.CloseAll()
        return
    else
        open = true
        if inNoClip then
            modsAdmin.noclip = true
        end
        if IsEntityVisible(p:ped()) then
            modsAdmin.invisible = false
        else
            modsAdmin.invisible = true
        end
        RageUI.Visible(main, true)
        Citizen.CreateThread(function()
            while open do
                
                RageUI.IsVisible(main, function()
                    RageUI.Line()
                    RageUI.Separator('~o~Vision~s~ Modération')
                    RageUI.Checkbox("Mode Administration", nil, AdminChecked, {}, {
                        onSelected = function(_checked)
                            --updateAdminOverlay()
                            AdminChecked = _checked;
                            TriggerServerEvent("core:StaffInAction", token, AdminChecked)
                            AdminInAction = _checked
                            if not _checked then
                                nbReport = nil
                            end
                        end
                    })
                    RageUI.Line()
                    if AdminInAction then
                        RageUI.Button("Menu Reports", false, { RightLabel = ">" }, perm3, {
                            onSelected = function()
                                reports = nil 
                                reports = TriggerServerCallback("core:GetAllReports", token)
                            end
                        }, report)
                        RageUI.Button("Liste des joueurs", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                Player = nil
                                Player = TriggerServerCallback("core:GetAllPlayer", token)
                            end
                        }, players)
                        RageUI.Button("Outils de Modération", false, { RightLabel = ">" }, true, {}, mod)
                    end
                end)

                RageUI.IsVisible(report, function()
                    while reports == nil do 
                        Wait(10)
                        RageUI.Separator('')
                        RageUI.Separator('Chargement des reports...')
                        RageUI.Separator('')
                    end
                    if nbReport == 0 then
                        RageUI.Separator('')
                        RageUI.Separator('Aucun report en cours')
                        RageUI.Separator('')
                        RageUI.Button("Retour", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                RageUI.GoBack()
                            end
                        })
                    else
                        for k,v in pairs(reports) do
                            if k ~= nil then 
                                RageUI.Button("Report N°~b~"..k.."~s~ - ("..v.name..")",
                                "ID : ~b~"..v.id..
                                "\n~s~ID Unique : ~b~"..v.uniqueID..
                                "\n~s~Heure : ~b~"..v.time..
                                "\n~s~Message : ~b~"..v.msg
                                ,{RightLabel = ">"}, true, {
                                    onSelected = function()
                                        ReportSelected = nil 
                                        ReportSelected = k
                                        local VerifReport = TriggerServerCallback("core:VerifReport", ReportSelected)
                                    end
                                }, report2)
                            end
                        end
                    end
                end)

                RageUI.IsVisible(report2, function()
                    while ReportSelected == nil and  VerifReport == nil do 
                        Wait(10)
                        RageUI.Separator('')
                        RageUI.Separator('Chargement du report...')
                        RageUI.Separator('')
                    end
                    if VerifReport == false then
                        RageUI.Separator('')
                        RageUI.Separator('Report supprimé')
                        RageUI.Separator('')
                    else
                        RageUI.Line()
                        RageUI.Separator('Report N°~o~'..ReportSelected)
                        RageUI.Separator('~s~ID : ~o~'..reports[ReportSelected].id.."~s~ - ID Unique : ~o~"..reports[ReportSelected].uniqueID)
                        RageUI.Separator('~s~Nom : ~o~'..reports[ReportSelected].name)
                        RageUI.Line()
                        RageUI.Button("~r~Fermer le report", false,{}, true, {
                            onSelected = function()
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "Vous avez fermer le report n°"..ReportSelected.."."
                                })
                                TriggerServerEvent("core:delReport", ReportSelected)
                                reports = nil
                                reports = TriggerServerCallback("core:GetAllReports", token)
                                Wait(100)
                                RageUI.GoBack()
                            end
                        })
                        RageUI.Button("Envoyer un message", false, {}, perm3, {
                            onSelected = function()
                                local msg = KeyboardImput("Message")
                                if msg ~= nil or msg ~= "" then
                                    TriggerServerEvent("core:SendMessage", token, reports[ReportSelected].id, msg)
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Message envoyé à ~s " ..reports[ReportSelected].name
                                    })
    
                                end
                            end
                        }, nil)
                        RageUI.Checkbox("Spectate", false, pPlayer.spectate, {}, {
                            onChecked = function()
                                pPlayer.spectate = true
                                Staff.pLastPosition = p:pos()
                                TriggerServerEvent("core:staffActionLog", token, "/spectate", reports[ReportSelected].id)
                                TriggerServerEvent("core:StaffSpectate", token, reports[ReportSelected].id)
						        --NetworkSetInSpectatorMode(true, GetPlayerPed(reports[ReportSelected].id))
                            end,
                            onUnChecked = function()
                                pPlayer.spectate = false
                                TriggerServerEvent("core:staffActionLog", token, "/unspectate", reports[ReportSelected].id)
                                TriggerServerEvent("core:StaffSpectate", token, reports[ReportSelected].id)
						        --NetworkSetInSpectatorMode(false, GetPlayerPed(reports[ReportSelected].id))
                            end
                        })
                        RageUI.Button("Go to", false, {}, perm3, {
                            onSelected = function()
                                TriggerServerEvent("core:staffActionLog", token, "/goto", reports[ReportSelected].id)
                                TriggerServerEvent("core:GotoBring", token, nil, reports[ReportSelected].id)
                            end
                        }, nil)
                        RageUI.Button("Bring", false, {}, perm3, {
                            onSelected = function()
                                CanReturn = true
                                IdBring = tonumber(reports[ReportSelected].id)
                                coordsLastBring = TriggerServerCallback("core:CoordsOfPlayer", token, reports[ReportSelected].id)
                                TriggerServerEvent("core:staffActionLog", token, "/bring", reports[ReportSelected].id)
                                TriggerServerEvent("core:GotoBring", token, reports[ReportSelected].id, nil)
                            end
                        }, nil)
                        RageUI.Button("Return", false, {}, CanReturn and tonumber(IdBring) == tonumber(reports[ReportSelected].id), {
                            onSelected = function()
                                TriggerServerEvent("core:staffActionLog", token, "/return", reports[ReportSelected].id)
                                TriggerServerEvent("core:ReturnPositionPlayer", token, reports[ReportSelected].id, coordsLastBring)
                                coordsLastBring = nil
                                CanReturn = false
                                IdBring = nil
                            end
                        }, nil)
                        RageUI.Button("Revive", false, {}, perm3, {
                            onSelected = function()
                                TriggerServerEvent("core:staffActionLog", token, "/revive", reports[ReportSelected].id)
                                TriggerServerEvent("core:RevivePlayer", token, reports[ReportSelected].id)
                                TriggerServerEvent("core:createvNotif", token, tonumber(reports[ReportSelected].id), 'VERT', "Vous avez été réanimé par un membre du staff.", 5)
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "Vous avez revive ~s "..reports[ReportSelected].name
                                })

                            end
                        }, nil)
                        RageUI.Button("Heal", false, {}, perm3, {
                            onSelected = function()
                                TriggerServerEvent("core:HealthPlayer", token, reports[ReportSelected].id)
                                TriggerServerEvent("core:createvNotif", token, tonumber(reports[ReportSelected].id), 'VERT', "Vous avez été soigné par un membre du staff.", 5)
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "Vous avez heal ~s "..reports[ReportSelected].name
                                })

                            end
                        }, nil)
                        RageUI.Button("Prendre un screen de l'écran du joueur", false, {}, perm3, {
                            onSelected = function()
                                TriggerServerEvent("core:TakeScreenBiatch", token, reports[ReportSelected].id)
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(players, function()
                    if Player == nil then
                        RageUI.Separator('')
                        RageUI.Separator('Chargement des joueurs...')
                        RageUI.Separator('')
                    end
                    RageUI.Separator("~o~"..Player.count.."~s~ Joueurs connectés")
                    RageUI.Button("Rechercher un joueur", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            CurrentFiltre = nil
                            local TargetId = KeyboardImput("Entrer un ID / Nom / Prenom / FiveM")
                            TargetId = tostring(TargetId)
                            if TargetId ~= nil and string.len(TargetId) ~= 0 then
                                if type(TargetId) == 'string' then
                                    CurrentFiltre = TargetId
                                end
                            else
                                CurrentFiltre = nil
                            end
                        end
                    })

                    for k, v in pairs(Player.players) do
                        if v.name == nil then
                            v.name = "noname user: "..v.firstname.." "..v.lastname
                        end
                        if CurrentFiltre ~= nil then
                            if v.id == tonumber(CurrentFiltre) or
                                string.find(string.lower(v.name), string.lower(tostring(CurrentFiltre))) or
                                string.find(string.lower(v.firstname), string.lower(tostring(CurrentFiltre))) or
                                string.find(string.lower(v.lastname), string.lower(tostring(CurrentFiltre))) then
                                RageUI.Button('~o~[FILTRE] ~s~'.. v.id .. " - " .. v.name.." (~b~"..v.firstname.." "..v.lastname.."~s~)", nil, {}, true, {
                                    onSelected = function()
                                        data = nil
                                        data = TriggerServerCallback("core:GetAllPlayerInfo", token, v.id)
                                        data.name = v.name
                                        data.id = v.id
                                        data.firstname = v.firstname
                                        data.lastname = v.lastname
                                    end
                                }, dataplayers)
                            end
                        else
                            RageUI.Button(v.id .. " - " .. v.name.." (~b~"..v.firstname.." "..v.lastname.."~s~)", nil, {}, true, {
                                onSelected = function()
                                    data = nil
                                    data = TriggerServerCallback("core:GetAllPlayerInfo", token, v.id)
                                    data.name = v.name
                                    data.id = v.id
                                    data.firstname = v.firstname
                                    data.lastname = v.lastname
                                end
                            }, dataplayers)
                        end
                    end
                end)
                RageUI.IsVisible(dataplayers, function()
                    if data == nil then
                        RageUI.Separator('')
                        RageUI.Separator('Chargement des données...')
                        RageUI.Separator('')
                    end
                    RageUI.Separator("~o~" .. data.name)
                    RageUI.Separator("ID Joueur:~o~ " .. data.id.."~s~ - ID Unique :~o~ " .. data.uniqueID)
                    RageUI.Separator("Prénom :~o~ " .. data.firstname .. "~s~ Nom :~o~ " .. data.lastname)
                    RageUI.Separator("Job : ~o~"..data.job.."~s~ - Grade : ~o~"..data.jobGrade)
                    RageUI.Separator("Crew : ~o~"..data.crew)
                    RageUI.Separator("Banque : ~g~"..data.bank.balance.." $ ~s~- N° compte : ~g~"..data.bank.account_number)
                    RageUI.Button("Discord: " .. data.discord, false, {}, true, {
                        onSelected = function()
                            TriggerEvent("addToCopy", data.discord)
                        end
                    }, nil)
                    RageUI.Button("Changer le job", false, {RightLabel = ">"}, perm3, {}, jobMenu)
                    RageUI.Button("Changer le crew", false, {RightLabel = ">"}, perm3, {
                        onSelected = function()
                            if AllCrews == nil then
                                AllCrews = TriggerServerCallback("core:GetAllCrew", token)
                            end
                        end
                    }, crewMenu)
                    RageUI.Button("Give un item", false, {RightLabel = ">"}, perm3, {}, giveItemMenu)
                    RageUI.Button("Inventaire du joueur", false, { RightLabel = ">" }, perm3, {
                        onSelected = function()
                            data.inv = TriggerServerCallback("core:GetInventoryPlayer", token, data.id)
                        end
                    }, InvPlayer)
                    RageUI.Button("Véhicule du joueur", false, { RightLabel = ">" }, perm3, {
                        onSelected = function()
                            data.veh = TriggerServerCallback("core:GetAllVehPounder", data.id, false)
                        end
                    }, vehJoueur)
                    RageUI.Button("Envoyer un message", false, {}, perm3, {
                        onSelected = function()
                            local msg = KeyboardImput("Message")
                            if msg ~= nil or msg ~= "" then
                                TriggerServerEvent("core:SendMessage", token, data.id, msg)
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "Message envoyé à ~s " .. data.firstname .. " " .. data.lastname
                                })

                            end
                        end
                    }, nil)
                    RageUI.Button("Revive", false, {}, perm3, {
                        onSelected = function()
                            TriggerServerEvent("core:staffActionLog", token, "/revive", data.id)
                            TriggerServerEvent("core:RevivePlayer", token, data.id)
                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                content = "Vous avez revive ~s " .. data.firstname .. " " .. data.lastname
                            })

                        end
                    }, nil)
                    RageUI.Button("Heal", false, {}, perm3, {
                        onSelected = function()
                            TriggerServerEvent("core:HealthPlayer", token, data.id)
                            TriggerServerEvent("core:createvNotif", token, tonumber(data.id), 'VERT', "Vous avez été soigné par un membre du staff.", 5)
                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                content = "Vous avez heal ~s "  .. data.firstname .. " " .. data.lastname
                            })

                        end
                    }, nil)
                    if data.instance ~= 0 then 
                        if InsideInstanceAdmin == 0 then
                            RageUI.Button("Rejoindre l'instance du joueur", false, { RightLabel = ">" }, perm3, {
                                onSelected = function()
                                    InsideInstanceAdmin = data.instance
                                    TriggerServerEvent("core:InstancePlayer", token, data.instance, "Menu : Ligne 415")
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Vous avez rejoint l'instance n°" .. data.instance .. "."
                                    })
                                end
                            })
                        else
                            RageUI.Button("Quitter l'instance du joueur", false, { RightLabel = ">" }, perm3, {
                                onSelected = function()
                                    InsideInstanceAdmin = 0
                                    TriggerServerEvent("core:InstancePlayer", token, 0, "Menu : Ligne 426")
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Vous avez quitté l'instance n°" .. data.instance .. "."
                                    })
                                end
                            })
                        end
                    end
                    RageUI.Button("Go to", false, {}, perm3, {
                        onSelected = function()
                            TriggerServerEvent("core:staffActionLog", token, "/goto", data.id)
                            TriggerServerEvent("core:GotoBring", token, nil, data.id)
                        end
                    }, nil)
                    RageUI.Button("Bring", false, {}, perm3, {
                        onSelected = function()
                            CanReturn = true
                            IdBring = tonumber(data.id)
                            coordsLastBring = TriggerServerCallback("core:CoordsOfPlayer", token, data.id)
                            TriggerServerEvent("core:staffActionLog", token, "/bring", data.id)
                            TriggerServerEvent("core:GotoBring", token, data.id, nil)
                        end
                    }, nil)
                    RageUI.Button("Return", false, {}, CanReturn and tonumber(IdBring) == tonumber(data.id), {
                        onSelected = function()
                            TriggerServerEvent("core:staffActionLog", token, "/return", data.id)
                            TriggerServerEvent("core:ReturnPositionPlayer", token, data.id, coordsLastBring)
                            coordsLastBring = nil
                            CanReturn = false
                            IdBring = nil
                        end
                    }, nil)
                    RageUI.Button("Kick", false, {}, perm3, {
                        onSelected = function()
                            local reason = KeyboardImput("Raison du kick")
                            if reason ~= nil and reason ~= "" then
                                TriggerServerEvent("core:KickPlayer", token, data.id, reason)
                            end
                        end
                    }, nil)
                    RageUI.List("Ban", tableBan, Idtblban, false, {}, perm3, {
                        onListChange = function(Index)
                            Idtblban = Index
                        end,
                        onSelected = function()
                            local reason = KeyboardImput("Raison du ban")
                            local time = nil
                            if tableBan[Idtblban] ~= "Perm" then
                                time = KeyboardImput("Temps")
                            else
                                time = 0
                            end
                            if reason ~= nil and reason ~= "" and time ~= nil and time ~= "" then
                                TriggerServerEvent("core:staffBanAction", token, "/ban",
                                    data.id .. "** - Raison :** " .. reason .. "** - Temps : **" .. time)
                                TriggerServerEvent("core:ban:banplayer", token, tonumber(data.id), reason, tonumber(time), GetPlayerServerId(PlayerId()), tableBan[Idtblban])
                            end
                        end
                    }, nil)
                    if perm3 then
                        RageUI.Checkbox("Spectate", false, pPlayer.spectate, {}, {
                            onChecked = function()
                                pPlayer.spectate = true
                                Staff.pLastPosition = p:pos()
                                TriggerServerEvent("core:staffActionLog", token, "/spectate", data.id)
                                TriggerServerEvent("core:StaffSpectate", token, data.id)
						        --NetworkSetInSpectatorMode(true, GetPlayerPed(data.id))
                            end,
                            onUnChecked = function()
                                pPlayer.spectate = false
                                TriggerServerEvent("core:staffActionLog", token, "/unspectate", data.id)
                                TriggerServerEvent("core:StaffSpectate", token, data.id)
						        --NetworkSetInSpectatorMode(false, GetPlayerPed(data.id))
                            end
                        })
                    end
                    RageUI.Button("Prendre un screen de l'écran du joueur", false, {}, perm3, {
                        onSelected = function()
                            TriggerServerEvent("core:TakeScreenBiatch", token, data.id)
                        end
                    }, nil)
                    if perm3 then
                        RageUI.Checkbox("Freeze", false, pPlayer.freeze, {}, {
                            onChecked = function()
                                pPlayer.freeze = true
                                TriggerServerEvent("core:staffActionLog", token, "/freeze", data.id)
                                TriggerServerEvent("core:FreezePlayer", token, data.id, true)
                            end,
                            onUnChecked = function()
                                pPlayer.freeze = false
                                TriggerServerEvent("core:staffActionLog", token, "/unfreeze", data.id)
                                TriggerServerEvent("core:FreezePlayer", token, data.id, false)
                            end
                        })
                    end
                end)
                RageUI.IsVisible(crewMenu, function()
                    RageUI.Button("Changer avec le nom", false, {}, perm3, {
                        onSelected = function()
                            local crew = KeyboardImput("Nom du crew")
                            if crew ~= nil or crew ~= "" then
                                for k,v in pairs(AllCrews) do
                                    if v.name == crew then
                                        TriggerSecurEvent("core:setCrew", token, data.id, crew, 1)
                                        RageUI.GoBack()
                                        return
                                    end
                                end
                            end
                        end
                    })
                    RageUI.Button("Mettre / Enlever un filte", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            CurrentFiltre4 = nil
                            local TargetCrew = KeyboardImput("Entrer un nom de crew")
                            TargetCrew = tostring(TargetCrew)
                            if TargetCrew ~= nil and string.len(TargetCrew) ~= 0 then
                                if type(TargetCrew) == 'string' then
                                    CurrentFiltre4 = TargetCrew
                                end
                            else
                                CurrentFiltre4 = nil
                            end
                        end
                    })
                    if CurrentFiltre4 ~= nil then
                        RageUI.Separator("Filte activé : ~o~"..CurrentFiltre4)
                    end
                    RageUI.Line()
                    for k,v in pairs(AllCrews) do
                        if CurrentFiltre4 ~= nil then
                            if v == tonumber(CurrentFiltre4) or string.find(string.lower(v.name), string.lower(tostring(CurrentFiltre4))) then
                                RageUI.Button(v.name, nil, { RightLabel = "[~o~ID - "..v.id.."~s~]" }, true, {
                                    onSelected = function()
                                        TriggerSecurEvent("core:setCrew", token, data.id, v.name, 1)
                                        RageUI.GoBack()
                                    end
                                })
                            end
                        else
                            RageUI.Button(v.name, nil, { RightLabel = "[~o~ID - "..v.id.."~s~]" }, true, {
                                onSelected = function()
                                    TriggerSecurEvent("core:setCrew", token, data.id, v.name, 1)
                                    RageUI.GoBack()
                                end
                            })
                        end
                    end
                end)

                RageUI.IsVisible(jobMenu, function()
                    RageUI.Button("Changer avec le nom", false, {}, perm3, {
                        onSelected = function()
                            local job = KeyboardImput("Nom du job")
                            if job ~= nil or job ~= "" then
                                local level = KeyboardImput("Choisir le grade de 1 à 5") 
                                if level ~= nil or level ~= "" then
                                    if jobs[job] ~= nil then
                                        if tonumber(level) >= 1 and tonumber(level) <= 5 then
                                            TriggerServerEvent("core:staffActionLog", token, "/setjob", data.id .. " - Job : " .. job .. " - Grade : " .. level)
                                            TriggerEvent("jobs:unloadcurrent")
                                            TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(data.id), job, tonumber(level))
                                        else
                                            exports['vNotif']:createNotification({
                                                type = 'ROUGE',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "~s Le grade n'existe pas"
                                            })
                                        end
                                    else
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Le job n'existe pas"
                                        })
                                    end
                                end
                            end
                        end
                    })
                    RageUI.Button("Mettre / Enlever un filte", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            CurrentFiltre3 = nil
                            local TargetJob = KeyboardImput("Entrer un nom de job")
                            TargetJob = tostring(TargetJob)
                            if TargetJob ~= nil and string.len(TargetJob) ~= 0 then
                                if type(TargetJob) == 'string' then
                                    CurrentFiltre3 = TargetJob
                                end
                            else
                                CurrentFiltre3 = nil
                            end
                        end
                    })
                    if CurrentFiltre3 ~= nil then
                        RageUI.Separator("Filte activé : ~o~"..CurrentFiltre3)
                    end
                    RageUI.Line()
                    for k,v in pairs(jobs) do
                        if CurrentFiltre3 ~= nil then
                            if k == tonumber(CurrentFiltre3) or string.find(string.lower(k), string.lower(tostring(CurrentFiltre3))) or string.find(string.lower(v.label), string.lower(tostring(CurrentFiltre3))) then
                                RageUI.Button(v.label, nil, {RightLabel = "[~o~"..k.."~s~]"}, true, {
                                    onSelected = function()
                                        local level = KeyboardImput("Choisir le grade de 1 à 5") 
                                        if level ~= nil or level ~= "" then
                                            if tonumber(level) >= 1 and tonumber(level) <= 5 then
                                                TriggerServerEvent("core:staffActionLog", token, "/setjob", data.id .. " - Job : " .. k .. " - Grade : " .. level)
                                                TriggerEvent("jobs:unloadcurrent")
                                                TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(data.id), k, tonumber(level))
                                            else
                                                exports['vNotif']:createNotification({
                                                    type = 'ROUGE',
                                                    -- duration = 5, -- In seconds, default:  4
                                                    content = "~s Le grade n'existe pas"
                                                })
                                            end
                                        end
                                    end
                                })
                            end
                        else
                            RageUI.Button(v.label, nil, {RightLabel = "[~o~"..k.."~s~]"}, true, {
                                onSelected = function()
                                    local level = KeyboardImput("Choisir le grade de 1 à 5") 
                                    if level ~= nil or level ~= "" then
                                        if tonumber(level) >= 1 and tonumber(level) <= 5 then
                                            TriggerServerEvent("core:staffActionLog", token, "/setjob", data.id .. " - Job : " .. k .. " - Grade : " .. level)
                                            TriggerEvent("jobs:unloadcurrent")
                                            TriggerServerEvent("core:StaffRecruitPlayer", token, tonumber(data.id), k, tonumber(level))
                                        else
                                            exports['vNotif']:createNotification({
                                                type = 'ROUGE',
                                                -- duration = 5, -- In seconds, default:  4
                                                content = "~s Le grade n'existe pas"
                                            })
                                        end
                                    end
                                end
                            })
                        end
                    end
                end)


                RageUI.IsVisible(vehJoueur, function()
                    if data.veh ~= nil then
                        for k, v in pairs(data.veh) do
                            if v.stored == 2 then
                                RageUI.Button("[~b~" .. v.currentPlate .. "~s~] " .. v.name, false,
                                    { RightLabel = "~r~FOURRIERE" }, true, {})
                            else
                                RageUI.Button("[~b~" .. v.currentPlate .. "~s~] " .. v.name,
                                    "Appuyer sur ENTRER pour le mettre en fourrière", { RightLabel = "~b~SORTIE" }, true
                                    , {
                                    onSelected = function()
                                        TriggerServerEvent("police:SetVehicleInFourriere", token, v.plate)
                                        TriggerEvent("core:RefreshData", playerData)

                                        -- ShowNotification("Le véhicule à été mis en fourrière")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Le véhicule à été mis en fourrière"
                                        })

                                        RageUI.GoBack()
                                    end
                                })
                            end
                        end
                    end
                end)
                
                RageUI.IsVisible(giveItemMenu, function()
                    RageUI.Button("Give par le nom", false, {}, perm3, {
                        onSelected = function()
                            local item = KeyboardImput("item")
                            if item ~= nil or item ~= "" then
                                local count = KeyboardImput("nombre")
                                if count ~= nil or count ~= "" then
                                    TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(data.id), item, tonumber(count), {})
                                end
                            end
                        end
                    })
                    RageUI.Button("Mettre / Enlever un filte", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            CurrentFiltre2 = nil
                            local TargetItem = KeyboardImput("Entrer un nom d'item")
                            TargetItem = tostring(TargetItem)
                            if TargetItem ~= nil and string.len(TargetItem) ~= 0 then
                                if type(TargetItem) == 'string' then
                                    CurrentFiltre2 = TargetItem
                                end
                            else
                                CurrentFiltre2 = nil
                            end
                        end
                    })
                    if CurrentFiltre2 ~= nil then
                        RageUI.Separator("Filte activé : ~o~"..CurrentFiltre2)
                    end
                    RageUI.Line()
                    for k,v in pairs(items) do
                        if k ~= "maxWeight" then
                            if CurrentFiltre2 ~= nil then
                                if k == tonumber(CurrentFiltre2) or string.find(string.lower(k), string.lower(tostring(CurrentFiltre2))) or string.find(string.lower(v.label), string.lower(tostring(CurrentFiltre2))) then
                                    RageUI.Button(v.label.." - [~o~"..k.."~s~]", nil, {RightLabel = v.weight.." kg"}, true, {
                                        onSelected = function()
                                            local count = KeyboardImput("nombre")
                                            if count ~= nil or count ~= "" then
                                                TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(data.id), k, tonumber(count), {})
                                            end
                                        end
                                    })
                                end
                            else
                                RageUI.Button(v.label.." - [~o~"..k.."~s~]", nil, {RightLabel = v.weight.." kg"}, true, {
                                    onSelected = function()
                                        local count = KeyboardImput("nombre")
                                        if count ~= nil or count ~= "" then
                                            TriggerServerEvent("core:addItemToInventoryStaff", token, tonumber(data.id), k, tonumber(count), {})
                                        end
                                    end
                                })
                            end
                        end
                    end
                end)

                RageUI.IsVisible(InvPlayer, function()
                    RageUI.Button("Items", false, {}, true, {
                        onSelected = function()
                            dataItem = {}
                            for k, v in pairs(data.inv) do
                                if v.type == "items" then
                                    table.insert(dataItem, v)
                                end
                            end
                        end
                    }, dataInvPlayer)
                    RageUI.Button("Armes", false, {}, true, {
                        onSelected = function()
                            dataItem = {}
                            for k, v in pairs(data.inv) do
                                if v.type == "weapons" then
                                    table.insert(dataItem, v)
                                end
                            end
                        end
                    }, dataInvPlayer)
                    RageUI.Button("Vêtements", false, {}, true, {
                        onSelected = function()
                            dataItem = {}
                            for k, v in pairs(data.inv) do
                                if v.type == "clothes" then
                                    table.insert(dataItem, v)
                                end
                            end
                        end
                    }, dataInvPlayer)

                end)
                RageUI.IsVisible(dataInvPlayer, function()
                    for i = 1, #dataItem do
                        RageUI.Button("[~b~" .. dataItem[i].count .. "~s~] " .. dataItem[i].label .. "( " .. dataItem[i].name .. " )", false, {}, true, {
                            onSelected = function()
                                local count = KeyboardImput("Nombre à retirer")
                                if count ~= nil or count ~= "" then
                                    TriggerServerEvent("core:RemoveItemToInventoryStaff", token, tonumber(data.id), dataItem[i].name, tonumber(count), {})
                                end
                            end
                        }, nil)
                    end
                end)
                RageUI.IsVisible(mod, function()
                    RageUI.Button('Annonce', false, {}, perm3, {
                        onSelected = function()
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
                    })
                    RageUI.Button("Revive", false, { RightBadge = RageUI.BadgeStyle.Heart }, perm3, {
                        onSelected = function()
                            openRadarProperly()
                            SendNuiMessage(json.encode({
                                type = 'closeWebview',
                            }))
                            TriggerScreenblurFadeOut(10)
                            TriggerServerEvent("core:staffActionLog", token, "/revive", "Soi-même")
                            p:setPos(GetEntityCoords(p:ped()))
                            TriggerEvent("core:IsDeadStatut", false)
                            NetworkResurrectLocalPlayer(p:pos(), p:heading(), true, false)
                            p:setHealth(200)
                            p:setHunger(50)
                            p:setThirst(50)
                        end
                    }, nil)
                    if perm3 then
                        RageUI.Checkbox("Noclip", false, modsAdmin.noclip, {}, {
                            onChecked = function()
                                modsAdmin.noclip = true
                                ToogleNoClip()
                            end,
                            onUnChecked = function()
                                modsAdmin.noclip = false
                                ToogleNoClip()
                            end
                        })
                        RageUI.Checkbox("GodMod", false, modsAdmin.godmode, {}, {
                            onChecked = function()
                                modsAdmin.godmode = true
                                TriggerServerEvent("core:staffActionLog", token, "Start godmod", "Soi-même")
                                SetEntityInvincible(p:ped(), true)
                            end,
                            onUnChecked = function()
                                modsAdmin.godmode = false
                                TriggerServerEvent("core:staffActionLog", token, "Stop godmod", "Soi-même")
                                SetEntityInvincible(p:ped(), false)
                            end
                        })
                        RageUI.Checkbox("Invisible", false, modsAdmin.invisible, {}, {
                            onChecked = function()
                                modsAdmin.invisible = true
                                TriggerServerEvent("core:staffActionLog", token, "Start invisible", "Soi-même")
                                SetEntityVisible(p:ped(), false, 0)
                            end,
                            onUnChecked = function()
                                modsAdmin.invisible = false
                                TriggerServerEvent("core:staffActionLog", token, "Stop invisible", "Soi-même")
                                SetEntityVisible(p:ped(), true, 0)
                            end
                        })
                        RageUI.Checkbox("Nom des joueurs / blips", false, modsAdmin.blips, {}, {
                            onChecked = function()
                                modsAdmin.blips = true
                                TriggerServerEvent("core:staffActionLog", token, "Start blips", "Soi-même")
                                UseBlipsName(true)
                                ToggleGamerTag()
                            end,
                            onUnChecked = function()
                                modsAdmin.blips = false
                                TriggerServerEvent("core:staffActionLog", token, "Stop blips", "Soi-même")
                                UseBlipsName(false)
                                DestroyGamerTag()
                            end
                        })
                    end
                    RageUI.Button("TP sur le point", false, { RightBadge = RageUI.BadgeStyle.Tick }, perm3, {
                        onSelected = function()
                            TriggerServerEvent("core:staffActionLog", token, "TP sur le point", "Soi-même")
                            GotoMarker()
                        end
                    }, nil)
                    -- RageUI.Button("Se transformer en ped", false, { RightLabel = ">" }, perm3, {
                    --     onSelected = function()
                    --         oldskin = p:skin()
                    --         notMe = false
                    --     end
                    -- }, pedsMenu)
                    RageUI.Button("Création de coffres", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            coffresList = TriggerServerCallback("core:coffre:all", token)
                        end
                    }, coffres)

                    RageUI.Button("Création Zone Safe", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                        end
                    }, ZoneSafe)

                    RageUI.Button("Récuperer les clés du véhicule", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            --local veh = GetVehiclePedIsIn(p:ped(), false)
                            local veh, dst = GetClosestVehicle()
                            if DoesEntityExist(veh) and dst < 3.0 then
                                plate = GetVehicleNumberPlateText(veh)
                                model = GetEntityModel(veh)
                            else
                                plate = KeyboardImput("Plaque du véhicule", "", 8)
                                model = GetHashKey(KeyboardImput("Modèle du véhicule", "", 25))
                                -- if not IsModelValid(model) then
                                --     return exports['vNotif']:createNotification({
                                --         type = 'ROUGE',
                                --         content = "Modèle invalide"
                                --     })
                                -- end
                            end
                            
                            if plate ~= "" and model ~= "" and plate ~= nil and model ~= nil then
                                local id = KeyboardImput("ID du joueur", "", 8)
                                if id ~= "" and id ~= nil then
                                    TriggerServerEvent("core:admin:giveKeys", token, id, plate, model)
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        content = "Clés données avec succès"
                                    })
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        content = "ID invalide"
                                    })
                                end
                            end
                        end
                    }, nil)
                    RageUI.Button("Donner les permissions", "Entrer l'id du joueur en question ! ",
                        { RightLabel = ">" }, perm5, {
                            onSelected = function()
                                local id = KeyboardImput("Id du joueur")
                                local perm = KeyboardImput("Perm entre 0 et 5")
                                if tonumber(id) ~= nil then
                                    if tonumber(perm) ~= nil and tonumber(perm) >= 0 and tonumber(perm) <= 5 then
                                        if id == GetPlayerServerId(PlayerId()) then print("Demander à une autre personne de vous setPerm") return end
                                        TriggerServerEvent("core:staffActionLog", token, "Donner les permissions",id .. "** - Grade : **" .. perm)
                                        TriggerServerEvent("core:setPermAdmin", token, tonumber(id), tonumber(perm))
                                        if tonumber(perm) >= 3 then
                                            TriggerServerEvent("core:RefreshPermSTAFFs", token, tonumber(id), tonumber(perm))
                                        end
                                    end
                                end
                            end
                        },
                    nil)
                    RageUI.Button("Gestion variables", false, { RightLabel = ">" }, perm5, {}, varMenu)
                    RageUI.Button("Gestion illegal", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            AllCrews = TriggerServerCallback("core:crew:getAllCrew")
                        end
                    }, illegalMenu)
                end)

                --illegal

                RageUI.IsVisible(ZoneSafe, function()
                    RageUI.Button("Liste des zones", "", {}, true, {}, listZoneSafe)
                    RageUI.Button("Créer une zone", "", {}, true, {
                        onSelected = function()
                            local name = KeyboardImput("Nom de la zone")
                            local radius = KeyboardImput("Rayon de la zone")
                            if name ~= "" and name ~= nil and radius ~= "" and radius ~= nil then
                                TriggerServerEvent("core:admin:createZoneSafe", name, GetEntityCoords(p:ped()), tonumber(radius))
                            end
                        end
                    }, nil)
                end)
                
                RageUI.IsVisible(listZoneSafe, function()
                    for k,v in pairs(AllSafeZone) do
                        RageUI.Button(k, "", {RigthLabel}, true, {
                            onSelected = function()
                                TriggerServerEvent("core:admin:deleteZoneSafe", k)
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    content = "Zone supprimée avec succès"
                                })
                                RageUI.GoBack()
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(illegalMenu, function()
                    RageUI.Button("Créer un crew", "", {}, true, {
                        onSelected = function()
                            local typeCrew = KeyboardImput("normal - pf - gang - mc - orga - mafia")
                            local idPlayer = KeyboardImput("id joueur ingame")
                            if typeCrew and idPlayer and (string.lower(typeCrew) == "normal" or string.lower(typeCrew) == "pf" or string.lower(typeCrew) == "gang" or string.lower(typeCrew) == "mc" or string.lower(typeCrew) == "orga" or string.lower(typeCrew) == "mafia") then
                                if p:getPermission() >= 3 then
                                    TriggerServerEvent("core:createCrewCreation", idPlayer, string.lower(typeCrew))
                                else
                                    exports['vNotif']:createNotification({
                                        type = 'ROUGE',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "vous n'avez pas les permissions"
                                    })
                                end
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Commande incomplète remplir les deux champs avec les bonnes infos"
                                })
                            end
                        end
                    }, nil)
                    RageUI.Button("Gestion crews", false, { RightLabel = ">" }, true, {
                        onSelected = function()
                            AllCrews = TriggerServerCallback("core:crew:getAllCrew")
                        end
                    }, crewGestion)
                end)
                --illegal/crewGestion

                RageUI.IsVisible(crewGestion, function()
                    RageUI.Separator('filtre crew')
                    RageUI.Line()
                    RageUI.Button("Mettre / Enlever un filte", nil, { RightLabel = ">" }, true, {
                        onSelected = function()
                            CurrentFiltre5 = nil
                            local TargetCrew = KeyboardImput("Entrer un nom de crew")
                            TargetCrew = tostring(TargetCrew)
                            if TargetCrew ~= nil and string.len(TargetCrew) ~= 0 then
                                if type(TargetCrew) == 'string' then
                                    CurrentFiltre5 = TargetCrew
                                end
                            else
                                CurrentFiltre5 = nil
                            end
                        end
                    })
                    if CurrentFiltre5 ~= nil then
                        RageUI.Separator("Filte activé : ~o~"..CurrentFiltre5)
                    end
                    RageUI.Line()
                    for k,v in pairs(AllCrews) do
                        if CurrentFiltre5 ~= nil then
                            if v == tonumber(CurrentFiltre5) or string.find(string.lower(v.name), string.lower(tostring(CurrentFiltre5))) then
                                RageUI.Button(v.name, "", { RightLabel = crewInfo.typeCrew }, true, {
                                    onSelected = function()
                                        crewInfo = TriggerServerCallback("core:crew:getCrewByName", v.name)
                                        levelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", v.name)
                                        xpCrew = TriggerServerCallback("core:crew:getCrewXpByName", v.name)
                                    end
                                }, crewInfos)
                            end
                        else
                            RageUI.Button(v.name, "", {}, true, {
                                onSelected = function()
                                    crewInfo = TriggerServerCallback("core:crew:getCrewByName", v.name)
                                    levelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", v.name)
                                    xpCrew = TriggerServerCallback("core:crew:getCrewXpByName", v.name)
                                end
                            }, crewInfos)
                        end
                    end
                end)
                --illegal/infocrew
                RageUI.IsVisible(crewInfos, function()
                    RageUI.Separator('information crew')
                    RageUI.Line()
                    RageUI.Button("Nom: ", "", {
                            RightLabel = crewInfo.name
                        }, true, {
                            onSelected = function() end
                    }, nil)
                    RageUI.Button("Devise: ", "", {
                            RightLabel = crewInfo.devise
                        }, true, {
                            onSelected = function() end
                    }, nil)
                    RageUI.Button("Couleur: ", "", {
                            RightLabel = crewInfo.color
                        }, true, {
                            onSelected = function() end
                    }, nil)
                    RageUI.Button("Type de crew: ", "", {
                            RightLabel = crewInfo.typeCrew
                        }, true, {
                            onSelected = function() end
                    }, nil)
                    RageUI.Button("Xp: ", "", {
                            RightLabel = xpCrew
                        }, true, {
                            onSelected = function() end
                    }, nil)
                    RageUI.Button("Level: ", "", {
                            RightLabel = levelCrew
                        }, true, {
                            onSelected = function() end
                    }, nil)
                    RageUI.Button("Membres", "", {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                playersInfo = crewInfo.members
                            end
                    }, playersCrew)
                    RageUI.Line()
                    RageUI.Separator('Action crew')
                    RageUI.Line()
                    RageUI.Button("Changer le nom", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local newName = KeyboardImput("nom")
                                if not newName then return end
                                TriggerServerEvent("core:crew:changeName", token, crewInfo.name, newName)
                                crewInfo.name = newName
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                    RageUI.Button("Changer la devise", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local devise = KeyboardImput("devise")
                                if not devise then return end
                                TriggerServerEvent("core:crew:changeDevise", token, crewInfo.name, devise)
                                crewInfo.devise = devise
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                    RageUI.Button("Changer la couleur", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local color = KeyboardImput("couleur")
                                if not color then return end
                                TriggerServerEvent("core:crew:changeColor", token, crewInfo.name, color)
                                crewInfo.color = color
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                    RageUI.Button("Laboratoire", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            labs = TriggerServerCallback("core:labo:hasLabs", crewInfo.name)
                        end
                    }, createLabs)
                    RageUI.Button("Proprietés", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            propertiesCrewList = TriggerServerCallback("core:getPropertyCrew", crewInfo.name)
                        end
                    }, propertiesCrew)
                    RageUI.Button("Vehicules", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            vehCrewList = TriggerServerCallback("core:vehicle:getCrewVeh", crewInfo.name)
                        end
                    }, vehCrew)
                    RageUI.Button("Ajouter de l'xp", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local xp = KeyboardImput("xp")
                                if not xp then return end
                                TriggerSecurEvent("core:crew:updateXp", token, tonumber(xp), "add", crewInfo.name, "admin")
                                levelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", crewInfo.name)
                                xpCrew = TriggerServerCallback("core:crew:getCrewXpByName", crewInfo.name)
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                    RageUI.Button("Retirer l'xp", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local xp = KeyboardImput("xp")
                                if not xp then return end
                                TriggerSecurEvent("core:crew:updateXp", token, tonumber(xp), "remove", crewInfo.name, "admin")
                                levelCrew = TriggerServerCallback("core:crew:getCrewLevelByName", crewInfo.name)
                                xpCrew = TriggerServerCallback("core:crew:getCrewXpByName", crewInfo.name)
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                    RageUI.List("Changer le type de crew:",crewTypes,crewTypesList,nil,{},true,{
                        onListChange = function(Index)
                            crewTypesList = Index
                        end,
                        onSelected = function(index)
                            if p:getPermission() >= 5 then
                                TriggerServerEvent("core:crew:changeTypeCrew", token, crewInfo.name, crewTypes[index])
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    })
                    RageUI.Button("Supprimer le crew", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local delete = KeyboardImput("etes vous sur de supprimer le crew" .. crewInfo.name)
                                if string.lower(delete) == 'oui' then 
                                    TriggerServerEvent("core:crew:deleteCrew", token, crewInfo.name, true)
                                    crewInfo = TriggerServerCallback("core:crew:getCrewByName", v.name)
                                    RageUI.GoBack()
                                end
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                    RageUI.Button("Supprimer le crew avec les joueurs du crew", "", { RightLabel = ">" }, true, {
                        onSelected = function()
                            if p:getPermission() >= 5 then
                                local delete = KeyboardImput("etes vous sur de supprimer le crew" .. crewInfo.name .. " ainci que les joueurs")
                                if string.lower(delete) == 'oui' then 
                                    TriggerServerEvent("core:crew:deleteCrew", token, crewInfo.name, false)
                                    for k, v in pairs(crewInfo.members) do
                                        TriggerServerEvent("core:crew:deletePlayer", token, {
                                            id = v.id,
                                            license = v.license,
                                        })
                                    end
                                    crewInfo = TriggerServerCallback("core:crew:getCrewByName", v.name)
                                    RageUI.GoBack()
                                end
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "vous n'avez pas les permissions"
                                })
                            end
                        end
                    }, nil)
                end)
                --illegal/createlabs
                RageUI.IsVisible(createLabs, function()
                    if not labs then
                        RageUI.List('Crée le labo de type : ', labsType, labsTypeList, "Sélectionner le type de labo", {}, true, {
                            onListChange = function(index)
                                labsTypeList = index
                            end,
                            onSelected = function(index)
                                TriggerServerEvent("core:CreateLaboratory", crewInfo.name, GetEntityCoords(PlayerPedId()), labsType[index])
                            end
                        })
                    else
                        if labs.minutes and labs.minutes ~= 0 then 
                            RageUI.Separator("Production en cours")
                            RageUI.Separator("Temps restant : " .. labs.minutes)
                        end
                        RageUI.Button("Se TP au laboratoire", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                local posLabs = json.decode(labs.data).coords
                                SetEntityCoords(PlayerPedId(), posLabs.x, posLabs.y, posLabs.z)
                            end 
                        })  
                        RageUI.Button("Supprimer le laboratoire", false, { RightLabel = ">" }, true, {
                            onSelected = function()
                                exports['vNotif']:createNotification({
                                    type = 'VERT',
                                    duration = 10,
                                    content = "Appuyer sur ~K Y pour ~s accepter"
                                })
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    duration = 10,
                                    content = "Appuyer sur ~K N pour ~s ignorer"
                                })
                                local breakable = 1
                                while true do 
                                    Wait(1)
                                    if IsControlJustPressed(0, 246) then -- Y
                                        TriggerServerEvent("core:labo:deleteLabo", token, labs.id)
                                        RageUI.GoBack()
                                        break
                                    end
                                    if IsControlJustPressed(0, 306) then -- K
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = "~s Vous avez ignoré"
                                        })
                                        break
                                    end
                                    breakable = breakable + 1
                                    if breakable > 600 then 
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            content = "~s Vous avez ignoré"
                                        })
                                        break
                                    end
                                end
                            end 
                        })          
                    end
                end)
                --illegal/property
                RageUI.IsVisible(propertiesCrew, function()
                    for k, v in pairs(propertiesCrewList) do
                        RageUI.Button(v.name, "", { RightLabel = v.type }, true, {
                            onSelected = function()
                                propertiesCrewAction = v
                            end
                        }, propertiesCrewActions)
                    end
                end)
                RageUI.IsVisible(propertiesCrewActions, function()
                    RageUI.Separator(propertiesCrewAction.name)
                    RageUI.Line()
                    RageUI.Button("Supprimer", "", {}, true, {
                        onSelected = function()
                            TriggerServerEvent("core:property:delete", token,  propertiesCrewAction.id)
                            propertiesCrewList = TriggerServerCallback("core:getPropertyCrew", crewInfo.name)
                            RageUI.GoBack()
                        end
                    }, nil)
                    RageUI.Button("Aller", "", {}, true, {
                        onSelected = function()
                            SetEntityCoords(PlayerPedId(), propertiesCrewAction.enter_pos.x, propertiesCrewAction.enter_pos.y, propertiesCrewAction.enter_pos.z)
                        end
                    }, nil)
                end)
                --illegal/vehicle
                RageUI.IsVisible(vehCrew, function()
                    for k, v in pairs(vehCrewList) do
                        RageUI.Button(v.currentPlate, "", { RightLabel = v.name }, true, {
                            onSelected = function()
                                vehCrewAction = v
                            end
                        }, vehCrewActions)
                    end
                end)
                RageUI.IsVisible(vehCrewActions, function()
                    RageUI.Separator(vehCrewAction.currentPlate)
                    RageUI.Line()
                    RageUI.Button("Supprimer", "", {}, true, {
                        onSelected = function()
                            TriggerServerEvent("core:deleteVehCrew", vehCrewAction.plate)
                            vehCrewList = TriggerServerCallback("core:vehicle:getCrewVeh", crewInfo.name)
                            RageUI.GoBack()
                        end
                    }, nil)
                end)
                --illegal/players
                RageUI.IsVisible(playersCrew, function()
                    for k, v in pairs(playersInfo) do
                        RageUI.Button(v.firstName .. " " .. v.lastName, "", { RightLabel = ">" }, true, {
                            onSelected = function()
                                playerInfo = v
                            end
                        }, playerCrew)
                    end
                end)
                RageUI.IsVisible(playerCrew, function()
                    RageUI.Separator(playerInfo.firstName .. " " .. playerInfo.lastName)
                    RageUI.Line()
                    RageUI.Button("Retirer du crew", "", {}, true, {
                        onSelected = function()
                            TriggerServerEvent("core:crew:removePlayerFromCrew", token, crewInfo.name, playerInfo.id)
                            crewInfo = TriggerServerCallback("core:crew:getCrewByName", crewInfo.name)
                            playersInfo = crewInfo.members
                            RageUI.GoBack()
                        end
                    }, nil)
                end)

                RageUI.IsVisible(pedsMenu, function()
                    -- for i = 0, #playersList do
                    --     RageUI.Button(playersList[i].name, "", {}, true, {}, nil)
                    -- end
                    if not notMe then
                        RageUI.Button("Remettre son skin", "", {}, true, {
                            onSelected = function()
                                p:setSkin(oldskin)
                            end
                        }, nil)
                        for k, v in pairs(Peds) do
                            RageUI.Button(v, false, {}, true, {
                                onSelected = function()
                                    if LoadModel(v) then
                                        if IsModelInCdimage(v) and IsModelValid(v) then
                                            SetPlayerModel(PlayerId(), v)
                                            SetPedDefaultComponentVariation(p:ped())
                                        end
                                    end
                                end
                            }, nil)
                        end
                    else
                        RageUI.Button("Remettre son skin", "", {}, true, {
                            onSelected = function()
                                -- p:setSkin(oldskin)
                            end
                        }, nil)
                        for k, v in pairs(Peds) do
                            RageUI.Button(v, false, {}, true, {
                                onSelected = function()
                                    local ID = KeyboardImput("ID")
                                    if ID ~= nil then
                                    end
                                end
                            }, nil)
                        end
                    end
                end)

                RageUI.IsVisible(varMenu, function()
                    for name, value in pairs(vAdminVariables) do
                        subMenu[name] = RageUI.CreateSubMenu(varMenu, "", name, 0.0, 0.0, "vision", "Banner_Administration")
                        --print("WARNING: table1", value, prefix, name)
                        subMenu[name].Closed = function()
                            openMenu = false
                        end
                        RageUI.Button(name, false, { RightLabel = ">" }, true, {
                                onSelected = function()
                                    --print("WARNING: table11", value, prefix, name, subMenu[name])
                                    MenuFromTable(value, name)
                                end
                            }, subMenu[name])
                    end
                end)
                Wait(1)
            end
        end)
    end
end

RegisterCommand("menuAdmin", function()     
    OpenAdminMenu()
end)
--[[ StaffUsingName = {} ]]

local tagBoucle = false
local perm_checked = {}
--[[ function ToggleGamerTag()
    tagBoucle = true
    local perm
    local myPlayerId = PlayerId()
    GamerTag = {}
    Citizen.CreateThread(function()
        blips = {}
        while tagBoucle do
            for k, v in pairs(GetActivePlayers()) do
                if #(p:pos() - GetEntityCoords(GetPlayerPed(v))) < 100.0 then
                    local serverId = GetPlayerServerId(v)
                    if perm_checked[serverId] == nil then
                        perm = TriggerServerCallback("core:getPermAdmin", serverId)
                        perm_checked[serverId] = perm
                    else
                        perm = perm_checked[serverId]
                    end
                    GamerTag[serverId] = CreateFakeMpGamerTag(GetPlayerPed(v),
                        "[" .. serverId .. "] " .. GetPlayerName(v), false, false, "", 0)
                    SetMpGamerTagAlpha(GamerTag[serverId], 4, 255)
                    SetMpGamerTagAlpha(GamerTag[serverId], 2, 255)
                    SetMpGamerTagAlpha(GamerTag[serverId], 10, 255)
                    SetMpGamerTagsUseVehicleBehavior(false)
                    local isPlayerTalking = MumbleIsPlayerTalking(v)
                    SetMpGamerTagColour(GamerTag[serverId], 0, 0)
                    if perm >= 5 then
                        SetMpGamerTagColour(GamerTag[serverId], 0, 7)
                    elseif perm == 4 then
                        SetMpGamerTagColour(GamerTag[serverId], 0, 127)
                    elseif perm == 3 then
                        SetMpGamerTagColour(GamerTag[serverId], 0, 149)
                    elseif perm == 2 then
                        SetMpGamerTagColour(GamerTag[serverId], 0, 25)
                    elseif perm == 1 then
                        SetMpGamerTagColour(GamerTag[serverId], 0, 48)
                    end
                    if StaffUsingName[serverId] == true and GetPlayerServerId(myPlayerId) ~= serverId then
                        SetMpGamerTagVisibility(GamerTag[serverId], 10, true)
                    else
                        SetMpGamerTagVisibility(GamerTag[serverId], 10, false)
                    end
                    SetMpGamerTagVisibility(GamerTag[serverId], 4, isPlayerTalking)
                    -- see the health
                    SetMpGamerTagVisibility(GamerTag[serverId], 2, true)
                    if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(serverId))) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverId))), -1) == GetPlayerPed(GetPlayerFromServerId(serverId)) then
                        SetMpGamerTagVisibility(GamerTag[serverId], 8, true)
                    else
                        SetMpGamerTagVisibility(GamerTag[serverId], 8, false)
                    end
                    -- SetMpGamerTagVisibility(GamerTag[serverId], 7, true) -- VIP
                end
            end
            for k, v in pairs(blips) do
                RemoveBlip(v)
            end
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() and NetworkIsPlayerActive(player) then
                    local playerPed = GetPlayerPed(player)
                    local playerName = GetPlayerName(player)

                    if not IsEntityDead(playerPed) and modsAdmin.blips then
                        local new_blip = AddBlipForEntity(playerPed)
                        SetBlipNameToPlayerName(new_blip, player)
                        SetBlipColour(new_blip, 4)
                        SetBlipCategory(new_blip, 0)
                        SetBlipScale(new_blip, 1.0)
                        blips[player] = new_blip
                    end
                end
            end
            Wait(500)
        end
    end)
end

function DestroyGamerTag()
    for k, v in pairs(GamerTag) do
        RemoveMpGamerTag(v)
    end
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    tagBoucle = false
    GamerTag = {}
end ]]

--[[ RegisterNetEvent("core:RefreshPermSTAFFc")
AddEventHandler("core:RefreshPermSTAFFc", function(level)
    if tonumber(level) >= 3 then
        perm3 = true
    elseif tonumber(level) == 4 then
        perm4 = true
    end
    if tonumber(level) >= 5 then
        perm5 = true
    end
end)

RegisterNetEvent("core:NbReportsForStaff")
AddEventHandler("core:NbReportsForStaff", function(number)
    nbReport = number
end) ]]


--[[ Keys.Register("F10", "F10", "Menu Admin", function()
    if p:getPermission() >= 3 then
        OpenAdminMenu()
    end
end) ]]

--[[ RegisterCommand("createscreen", function()
    if p:getPermission() >= 3 then
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        RequestModel(GetHashKey("prop_huge_display_01"))
        while not HasModelLoaded(GetHashKey("prop_huge_display_01")) do Wait(1) end
        local obj = CreateObject(GetHashKey("prop_huge_display_01"), x,y,z-1.0, 1)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId())-190)
        FreezeEntityPosition(obj, true)
        SetEntityAsMissionEntity(obj, 1, 1)
    else
    end
end)

RegisterCommand("deletescreen", function()
    if p:getPermission() >= 3 then
        local coords = GetEntityCoords(PlayerPedId())
        RequestModel(GetHashKey("prop_huge_display_01"))
        local obj = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_huge_display_01"), 1)
        DeleteEntity(obj)
    else
    end
end) ]]


-- Fonction pour calculer la distance entre deux coordonnées
local function GetDistance(x1, y1, z1, x2, y2, z2)
    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Commande pour compter les joueurs dans un rayon donné autour du joueur
--[[ RegisterCommand("GetPlayersInZone", function(source, args)
    if p:getPermission() >= 3 then
        if #args < 1 then
            return
        end

        local playerCoords = GetEntityCoords(p:ped())

        local radius = tonumber(args[1])

        if not radius then
            return
        end

        -- Compter le nombre de joueurs dans le rayon
        local playerCount = 0
        for _, player in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)

            -- Calculer la distance entre le joueur cible et le joueur source
            local distance = GetDistance(
                playerCoords.x, playerCoords.y, playerCoords.z,
                targetCoords.x, targetCoords.y, targetCoords.z
            )

            -- Vérifier si le joueur cible est dans le rayon
            if distance <= radius then
                playerCount = playerCount + 1
            end
        end

        print("Il y a " .. playerCount .. " joueurs dans un rayon de : " .. radius)
    else
        print('Vous n\'avez pas les permissions requises !')
    end
end) ]]

--RegisterNetEvent("core:getVariables")
--AddEventHandler("core:getVariables", function(data)
--    variables = data
--end)

--RegisterNetEvent("core:updateVariable")
--AddEventHandler("core:updateVariable", function(name, value)
--    variables[name] = value
--end)
