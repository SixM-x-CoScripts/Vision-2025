local VUI = exports["VUI"]

local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function AdminKeybind(key, command, name, callback)
    RegisterCommand("+vadmin_" .. command, callback, false)
    RegisterKeyMapping("+vadmin_" .. command, name, "keyboard", key)
end

AdminChecked = false
AdminInAction = false
InsideInstanceAdmin = 0
nbReport = nil
nbPlayers = 0
latestReport = nil
listDev = {}
bypassMpGamerTag = false

vAdminVariables = {}
vAdminVariablesLoaded = false

tableBan, Idtblban = { "Heures", "Jours", "Perm" }, 1
tableBanOffline, IdtblbanOffline = { "heures", "jours", "perm" }, 1
tablePlayertags, IdtblPlayertags = { "Pseudo", "Nom RP" }, 1
tablePerms, IdtblPerms = { "id", "id discord" }, 1
tableDjs, IdtblDjs = { "TP", "Supprimer" }, 1
AdminData = {}
vAdminStaffInAction = {}
 
-- Menu
vAdminMain = VUI:CreateMenu("Menu Administration", "administration", true)

vAdminPlayers = VUI:CreateSubMenu(vAdminMain, "Liste des Joueur(s)", "administration", true)
vAdminModerators = VUI:CreateSubMenu(vAdminMain, "Liste des Modérateur(s)", "administration", true)
vAdminReports = VUI:CreateSubMenu(vAdminMain, "Liste des Report(s)", "administration", true)
vAdminModerationTools = VUI:CreateSubMenu(vAdminMain, "Outils de Modération", "administration", true)
vAdminDeveloperTools = VUI:CreateSubMenu(vAdminMain, "Outils de Développement", "administration", true)
vAdminDeveloperToolTkt = VUI:CreateSubMenu(vAdminDeveloperTools, "le menu caca pipi", "administration", true)
vAdminDeveloperWp = VUI:CreateSubMenu(vAdminDeveloperToolTkt, "le menu des pistolet", "administration", true)
vAdminServerManagement = VUI:CreateSubMenu(vAdminMain, "Gestion Serveur", "administration", true)

vAdminReport = VUI:CreateSubMenu(vAdminReports, "Report", "administration", true)

vAdminPlayer = VUI:CreateSubMenu(vAdminPlayers, "Joueur", "administration", true)
vAdminPlayerWarns = VUI:CreateSubMenu(vAdminPlayer, "Warns", "administration", true)
vAdminPlayerJob = VUI:CreateSubMenu(vAdminPlayer, "Job", "administration", true)
vAdminPlayerCrew = VUI:CreateSubMenu(vAdminPlayer, "Crew", "administration", true)
vAdminPlayerGiveItem = VUI:CreateSubMenu(vAdminPlayer, "Give Item", "administration", true)
vAdminPlayerInventory = VUI:CreateSubMenu(vAdminPlayer, "Inventaire", "administration", true)
vAdminPlayerInventoryData = VUI:CreateSubMenu(playerInventory, "Inventaire", "administration", true)
vAdminPlayerVehicleMenu = VUI:CreateSubMenu(vAdminPlayer, "Vehicules", "administration", true)
vAdminPlayerVehicleOwned = VUI:CreateSubMenu(vAdminPlayerVehicleMenu, "Vehicules", "administration", true)
vAdminPlayerVehicleCoOwned = VUI:CreateSubMenu(vAdminPlayerVehicleMenu, "Vehicules", "administration", true)
vAdminPlayerVehicleJob = VUI:CreateSubMenu(vAdminPlayerVehicleMenu, "Vehicules", "administration", true)
vAdminPlayerVehicleCrew = VUI:CreateSubMenu(vAdminPlayerVehicleMenu, "Vehicules", "administration", true)

vAdminManagementPlayers = VUI:CreateSubMenu(vAdminServerManagement, "Gestion Joueurs", "administration", true)
vAdminManagementLegal = VUI:CreateSubMenu(vAdminServerManagement, "Gestion Legal", "administration", true)
vAdminCreateDJ = VUI:CreateSubMenu(vAdminManagementLegal, "Gestion Legal", "administration", true)
vAdminDJSets = VUI:CreateSubMenu(vAdminManagementLegal, "Gestion Legal", "administration", true)
vAdminZoneSafes = VUI:CreateSubMenu(vAdminManagementLegal, "Gestion Legal", "administration", true)
vAdminCreateZoneSafe = VUI:CreateSubMenu(vAdminManagementLegal, "Gestion Legal", "administration", true)
vAdminCreateDoorlock = VUI:CreateSubMenu(vAdminManagementLegal, "Gestion Doorlock", "administration", true)
vAdminManagementIllegal = VUI:CreateSubMenu(vAdminServerManagement, "Gestion Illegal", "administration", true)
vAdminManagementInterface = VUI:CreateSubMenu(vAdminServerManagement, "Gestion Interface", "administration", true)
vAdminManagementPerms = VUI:CreateSubMenu(vAdminServerManagement, "Gestion Permissions", "administration", true)
vAdminManagementBoutique = VUI:CreateSubMenu(vAdminServerManagement, "Gestion Boutique", "administration", true)

vAdminManagementPlayersBans = VUI:CreateSubMenu(vAdminManagementPlayers, "Gestion Bans", "administration", true)

vAdminManagementTerritoire = VUI:CreateSubMenu(vAdminManagementIllegal, "Territoire", "administration", true)
vAdminManagementTerritoireGestion = VUI:CreateSubMenu(vAdminManagementTerritoire, "Territoire", "administration", true)
vAdminManagementTerritoireCreation = VUI:CreateSubMenu(vAdminManagementTerritoire, "Territoire", "administration", true)
vAdminManagementTerritoireCreationZone = VUI:CreateSubMenu(vAdminManagementTerritoireCreation, "Territoire", "administration", true)
vAdminManagementTerritoireGestionInfo = VUI:CreateSubMenu(vAdminManagementTerritoireGestion, "Territoire", "administration", true)

vAdminManagementIllegalCrew = VUI:CreateSubMenu(vAdminManagementIllegal, "Gestion Crew", "administration", true)
vAdminManagementIllegalCrewInfo = VUI:CreateSubMenu(vAdminManagementIllegalCrew, "Crew Info", "administration", true)
vAdminManagementIllegalCrewMembers = VUI:CreateSubMenu(vAdminManagementIllegalCrewInfo, "Crew Membres", "administration", true)
vAdminManagementIllegalCrewLabs = VUI:CreateSubMenu(vAdminManagementIllegalCrewInfo, "Crew Labs", "administration", true)
vAdminManagementIllegalCrewProperty = VUI:CreateSubMenu(vAdminManagementIllegalCrewInfo, "Crew Propriétés", "administration", true)
vAdminManagementIllegalCrewVehicle = VUI:CreateSubMenu(vAdminManagementIllegalCrewInfo, "Crew Véhicules", "administration", true)
vAdminManagementInterfaceVariable = VUI:CreateSubMenu(vAdminManagementInterface, "Variables", "administration", true)
vAdminManagementInterfaceVariableArray = {}

vAdminDeveloperToolsVehicle = VUI:CreateSubMenu(vAdminDeveloperTools, "Véhicules", "administration", true)

local blips = {}
vAdminDataItem = {}
vAdminDataItemName = ""
vAdminMods = {
    noclip = false,
    freecam = false,
    godmode = false,
    invisible = false,
    blips = false,
    playerNames = false,
}
vAdminAllCrews = nil
vAdminCrewInfo, vAdminCrewMembers, vAdminCrewGrade = nil, nil, nil
vAdminPlayersInfo, vAdminPlayerInfo = nil, nil
vAdminXpCrew, vAdminLevelCrew = 0, 1
vAdminLabs = nil
vAdminProperty = nil
vAdminVehicle = nil

CanReturn = false
IdBring = nil
coordsLastBring = nil

Staff = {
    pLastPosition = nil,
    pLastId = nil,
    pLastIdSpectate = nil
}
vAdminpPlayer = {
    freeze = false,
    spectate = false,
}

vAdminAdminData = {
    player = {
        players = nil,
        query = nil,
        showAllPlayers = false,
        count = 0,
    },
    reports = nil,
	showRPNamesOnPlayerTags = false
}

vAdmin = {
    isInDevMode = false,
    PrintPropsAndEntities = false,
    InfiniteAmmo = false,
    vehGodmode = false,
    bans = nil,
    warns = nil,
}

local GamerTag = {}
local Blips = {}
ReportSelected = nil

CreateThread(function()
    while p == nil do Wait(10) end
    Wait(2550)
   
    local tmpms = 0
    vAdminVariables = {}
    vAdminVariables = TriggerServerCallback("core:loadVariables")

    while not vAdminVariables do Wait(1) end
    vAdminVariablesLoaded = true

    if p:getPermission() >= 2 then
        TriggerServerEvent("core:warn:getwarns", token)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        updateAdminOverlay()
    end
end)

function updateAdminOverlay()
    exports['aHUD']:updateAdminOverlay(AdminInAction, nbReport, nbPlayers)
end

local hasreq = {}
function GetVariable(name)
    while not vAdminVariables do Wait(1) end
    return vAdminVariables[name] or {}
end

local function split(str, sep)
    local _sep = sep or ":"
    local _fields = {}
    local _pattern = string.format("([^%s]+)", _sep)
    str:gsub(_pattern, function(c) _fields[#_fields + 1] = c end)
    return _fields
end

function SendToVariable(name, table)
    TriggerServerEvent("core:createVar", name, table)
end

local function setFooter(text)
    vAdminMain.Footer(text)
end

--[[ local function getOnlinePerm2()
    return TriggerServerCallback("core:GetOnlinePlayersWithPermission", token, 2)
end

local function getOnlinePerm3()
    return TriggerServerCallback("core:GetOnlinePlayersWithPermission", token, 3) + TriggerServerCallback("core:GetOnlinePlayersWithPermission", token, 4)
end

local function getOnlinePerm5()
    return TriggerServerCallback("core:GetOnlinePlayersWithPermission", token, 5)
end ]]

local function getNumberOfStaffInAction()
    return TriggerServerCallback("core:GetOnlinePlayersInModAction", token)
end

local function getPlayersAround()
    local MaBite = {}
    for k, v in pairs(GetActivePlayers()) do
        table.insert(MaBite, GetPlayerServerId(v))
    end
    return MaBite
end

vAdminMain.OnOpen(function()
    print("vAdminMain.OnOpen")
    if vAdminAdminData.players == nil then vAdminAdminData.players = TriggerServerCallback("core:GetAllPlayersAround", token, getPlayersAround()) end
    rendervAdminMainMenu()

    --[[ if AdminInAction then 
        --setFooter(getOnlinePerm3() .. " Modérateur(s) en ligne • " .. getOnlinePerm5() .. " Staff en ligne")
        setFooter(getOnlinePerm2() .. " Helpeur(s) en ligne • " .. getOnlinePerm3() .. " Modérateur(s) en ligne • " .. getOnlinePerm5() .. " Staff en ligne")
    end ]]
end)

vAdminReports.OnOpen(function()
    print("reports.OnOpen")
    vAdminAdminData.reports = nil
    vAdminAdminData.reports = TriggerServerCallback("core:GetAllReports", token)
    renderReportsList()
    setFooter(nil)
end)

vAdminPlayers.OnOpen(function()
    print("vAdminPlayers.OnOpen")
    if vAdminAdminData.query == nil and not vAdminAdminData.showAllPlayers then
        vAdminAdminData.players = nil
        vAdminAdminData.players = TriggerServerCallback("core:GetAllPlayersAround", token, getPlayersAround())
    elseif vAdminAdminData.showAllPlayers then
        vAdminAdminData.players = nil
        vAdminAdminData.players = TriggerServerCallback("core:GetAllPlayer", token)
    end
    renderPlayerList()
    setFooter(nil)
end)

vAdminModerators.OnOpen(function()
    print("vAdminModerators.OnOpen")
    vAdminAdminData.players = nil
    vAdminAdminData.players = TriggerServerCallback("core:GetAllPlayer", token, getPlayersAround())
    renderModeratorList()
    setFooter(nil)
end)

vAdminModerationTools.OnOpen(function()
    print("moderationTools.OnOpen")
    renderModerationTools()
    setFooter(nil)
end)

vAdminDeveloperTools.OnOpen(function()
    print("developerTools.OnOpen")
    renderDeveloperTools()
    setFooter(nil)
end)

vAdminDeveloperToolTkt.OnOpen(function()
    print("vAdminDeveloperToolTkt.OnOpen")
    renderDeveloperToolTkt()
    setFooter(nil)
end)

vAdminDeveloperWp.OnOpen(function()
    print("vAdminDeveloperWp.OnOpen")
    renderDeveloperWp()
    setFooter(nil)
end)

vAdminDeveloperToolsVehicle.OnOpen(function()
    print("developerToolsVehicle.OnOpen")
    renderDeveloperToolsVehicle()
    setFooter(nil)
end)

vAdminPlayer.OnOpen(function()
    print("player.OnOpen")
    renderPlayerMenu()
    setFooter(nil)
end)

vAdminReport.OnOpen(function()
    print("report.OnOpen")
    renderReportMenu()
    setFooter(nil)
end)

vAdminPlayerWarns.OnOpen(function()
    print("playerWarns.OnOpen")
    renderPlayerWarns()
    setFooter(nil)
end)

vAdminPlayerJob.OnOpen(function()
    print("playerJon.OnOpen")
    renderPlayerJob()
    setFooter(nil)
end)

vAdminPlayerCrew.OnOpen(function()
    print("playerCrew.OnOpen")
    local newData = nil
    newData = TriggerServerCallback("core:GetAllPlayerInfo", token, Admindata.id)

    vAdminAllCrews = nil
    vAdminAllCrews = TriggerServerCallback("core:crew:getAllCrew")
    
    if newData ~= nil then
        Admindata.crew = newData.crew
    end

    renderPlayerCrew()

    setFooter(nil)
end)

vAdminPlayerGiveItem.OnOpen(function()
    print("playerGiveItem.OnOpen")
    renderPlayerGiveItem()
    setFooter(nil)
end)

vAdminPlayerInventory.OnOpen(function()
    print("playerInventory.OnOpen")
    Admindata.inv = nil
    Admindata.inv = TriggerServerCallback("core:GetInventoryPlayer", token, Admindata.id)
    renderPlayerInventory()
    setFooter(nil)
end)

vAdminPlayerInventoryData.OnOpen(function()
    print("playerInventoryData.OnOpen")
    renderPlayerInventoryData()
    setFooter(nil)
end)

vAdminPlayerVehicleMenu.OnOpen(function()
    print("vAdminPlayerVehicleMenu.OnOpen")
    Admindata.veh = nil
    Admindata.veh = TriggerServerCallback("core:vAdmin:GetAllVehicle", Admindata.id)
    renderPlayerVehicleMenu()
    setFooter(nil)
end)

vAdminPlayerVehicleOwned.OnOpen(function()
    print("playerVehicleOwned.OnOpen")
    renderPlayerVehicleOwned()
    setFooter(nil)
end)

vAdminPlayerVehicleCoOwned.OnOpen(function()
    print("playerVehicleCoOwned.OnOpen")
    renderPlayerVehicleCoOwned()
    setFooter('Appuyer sur ENTER pour envoyer en fourrière')
end)

vAdminPlayerVehicleJob.OnOpen(function()
    print("playerVehicleJob.OnOpen")
    renderPlayerVehicleJob()
    setFooter('Appuyer sur ENTER pour envoyer en fourrière')
end)

vAdminPlayerVehicleCrew.OnOpen(function()
    print("playerVehicleCrew.OnOpen")
    renderPlayerVehicleCrew()
    setFooter('Appuyer sur ENTER pour envoyer en fourrière')
end)

vAdminServerManagement.OnOpen(function()
    print("serverManagement.OnOpen")
    renderServerManagement()
    setFooter(nil)
end)

vAdminReports.OnIndexChange(function(index, item)
    -- find the report based on item.props.title (remove N°)
    local reportId = tonumber(string.sub(item.props.title, 4))
    local report = vAdminAdminData.reports[reportId]

    print("reports.OnIndexChange" .. " " .. reportId .. " " .. json.encode(report))

    if report then
        vAdminMain.ReportPreview(reportId, report.time, report.msg)
    else
        vAdminMain.CloseReportPreview()
    end
end)

vAdminReports.OnClose(function()
    vAdminMain.CloseReportPreview()
end)

vAdminManagementIllegal.OnOpen(function()
    print("managementIllegal.OnOpen")
    renderManagementIllegal()
    setFooter(nil)
end)

vAdminManagementIllegalCrew.OnOpen(function()
    print("managementIllegalCrew.OnOpen")
    vAdminAllCrews = nil
    vAdminAllCrews = TriggerServerCallback("core:crew:getAllCrew")

    renderManagementIllegalCrew()
    setFooter(nil)
end)

vAdminManagementTerritoireGestionInfo.OnOpen(function()
    renderManagementTerritoireGestionInfo()
    setFooter(nil)
end)

vAdminManagementTerritoire.OnOpen(function() -- 
    print("managementTerritoire.OnOpen")

    renderManagementTerritoire()
    setFooter(nil)
end)

vAdminManagementTerritoireCreation.OnOpen(function()
    print("managementTerritoire.OnOpen")

    renderManagementTerritoireCreation()
    setFooter(nil)
end)

vAdminManagementTerritoireCreationZone.OnOpen(function()
    renderManagementTerritoireCreationZone()
    setFooter(nil)
end)

vAdminManagementTerritoireGestion.OnOpen(function()
    print("managementTerritoire.OnOpen")
    
    renderManagementTerritoireGestion()
    setFooter(nil)
end)

vAdminManagementIllegalCrewInfo.OnOpen(function()
    print("managementIllegalCrewInfo.OnOpen")
    vAdminAllCrews = nil
    vAdminAllCrews = TriggerServerCallback("core:crew:getAllCrew")

    renderManagementIllegalCrewInfo()
    setFooter(nil)
end)

vAdminManagementIllegalCrewMembers.OnOpen(function()
    print("managementIllegalCrewMembers.OnOpen")
    renderManagementIllegalCrewMembers()
    setFooter("Appuyer sur ENTER pour retirer le joueur du crew")
end)

vAdminManagementIllegalCrewLabs.OnOpen(function()
    print("managementIllegalCrewLabs.OnOpen")
    renderManagementIllegalCrewLabs()
    setFooter(nil)
end)

vAdminManagementIllegalCrewProperty.OnOpen(function()
    print("managementIllegalCrewProperty.OnOpen")
    renderManagementIllegalCrewProperty()
    setFooter(nil)
end)

vAdminManagementIllegalCrewVehicle.OnOpen(function()
    print("managementIllegalCrewVehicle.OnOpen")
    renderManagementIllegalCrewVehicle()
    setFooter("Appuyer sur ENTER pour supprimer le véhicule du crew")
end)

vAdminManagementInterface.OnOpen(function()
    print("managementInterface.OnOpen")
    renderManagementInterface()
    setFooter(nil)
end)

vAdminManagementBoutique.OnOpen(function()
    print("managementBoutique.OnOpen")
    renderManagementBoutique()
    setFooter(nil)
end)

vAdminManagementInterfaceVariable.OnOpen(function()
    print("managementInterfaceVariable.OnOpen")
    renderManagementInterfaceVariable()
    setFooter(nil)
end)

vAdminManagementPlayers.OnOpen(function()
    print("managementPlayers.OnOpen")
    renderManagementPlayers()
    setFooter(nil)
end)

vAdminManagementLegal.OnOpen(function()
    renderManagementLegal()
    setFooter(nil)
end)

vAdminManagementPlayersBans.OnOpen(function()
    print("managementPlayersBans.OnOpen")
    renderManagementPlayersBans()
    setFooter(nil)
end)

vAdminManagementPlayersBans.OnIndexChange(function(index, item)
    local banId = item.props.subtitle

    local ban = nil
    for k, v in pairs(vAdmin.bans) do
        if v.id == banId then
            ban = v
            break
        end
    end

    if not ban then
        vAdminMain.CloseBanPreview()
        return
    end

    local banRaison = ban.raison or "Inconnu"
    local banAt = ban.banDate or "Inconnu"
    local banExpiration = ban.expiration or "Jamais"
    local banIdentifiers = ban.ids or "Inconnu"

    vAdminMain.BanPreview(banId, banRaison, banAt, banExpiration, banIdentifiers)
end)

vAdminManagementPlayersBans.OnClose(function()
    vAdminMain.CloseBanPreview()
end)

vAdminPlayerWarns.OnIndexChange(function(index, item)
    local warnId = item.props.subtitle

    local warn = nil
    for k, v in pairs(vAdmin.warns) do
        if v.id == warnId then
            warn = v
            break
        end
    end

    if not warn then
        vAdminMain.CloseWarnPreview()
        return
    end

    local warnRaison = warn.reason or "Inconnu"
    local warnAt = warn.at or "Inconnu"
    local warnBy = warn.by or "Inconnu"
    local warnLicense = warn.license or "Inconnu"
    local warnDiscord = warn.discord or "Inconnu"

    vAdminMain.WarnPreview(warnId, warnRaison, warnAt, warnBy, warnLicense, warnDiscord)
end)

vAdminPlayer.OnClose(function()
    vAdminMain.CloseWarnPreview()
end)

StaffUsingName = {}
local playersJob = nil
RegisterNetEvent("core:UseBlipsNameClient")
AddEventHandler("core:UseBlipsNameClient", function(player, status)
    StaffUsingName[player] = status
    if status then
        playersJob = TriggerServerCallback('core:GetPlayersJob')
    end
end)

function UseBlipsName(status)
    if not bypassMpGamerTag then
        TriggerServerEvent("core:UseBlipsName", status)
    end
end

RegisterNetEvent("core:updatePlayerJob")
AddEventHandler("core:updatePlayerJob", function(playersJob)
    print(json.encode(playersJob))
    playersJob = playersJob
end)

RegisterNetEvent("core:updateListDev")
AddEventHandler("core:updateListDev", function(player)
    if listDev[player] then
        listDev[player] = not listDev[player]
    else
        listDev[player] = true
    end
    for k, v in pairs(GamerTag) do
        RemoveMpGamerTag(v)
    end
    GamerTag = {}
end)

local tagBoucle = false
local nameBoucle = false

local perm_checked = {}
local sub_checked = {}
local fullname_checked = {}

RegisterNetEvent("core:updatePerm")
AddEventHandler("core:updatePerm", function(player, perm)
    perm_checked[player] = perm
    for k, v in pairs(GamerTag) do
        RemoveMpGamerTag(v)
    end
    GamerTag = {}
end)

function isInListDev(player)
    for k, v in pairs(listDev) do
        if v and k == player then return true end
    end
    return false
end

function ToggleGamerTag()
    tagBoucle = true
    local perm
    local myPlayerId = PlayerId()
    Citizen.CreateThread(function()
        blips = {}
        while tagBoucle do
            for k, v in pairs(blips) do
                RemoveBlip(v)
            end
            for _, player in ipairs(GetActivePlayers()) do
                local pId = tonumber(GetPlayerServerId(player))
                if player ~= PlayerId() and NetworkIsPlayerActive(player) then
                    local playerPed = GetPlayerPed(player)
                    local playerName = GetPlayerName(player)
                    if not isInListDev(pId) then
                        if vAdminMods.blips then
                            local new_blip = AddBlipForEntity(playerPed)
                            SetBlipNameToPlayerName(new_blip, player)
                            SetBlipColour(new_blip, perm_checked[pId] == nil and 4 or perm_checked[pId] == 0 and 4 or perm_checked[pId] == 2 and 2 or perm_checked[pId] == 3 and 61 or perm_checked[pId] == 4 and 44 or perm_checked[pId] == 5 and 41 or perm_checked[pId] == 69 and 41)--26)
                            SetBlipCategory(new_blip, 0)
                            SetBlipScale(new_blip, 1.0)
							ShowHeadingIndicatorOnBlip(new_blip, true)
                            blips[player] = new_blip
                        end
                    end
                end
            end
            Wait(1000)
        end
    end)
end

function TogglePlayerNames() 
    nameBoucle = true
    local perm
    local sub
    local fullname
    local myPlayerId = PlayerId()
    GamerTag = {}
    Citizen.CreateThread(function()
        while nameBoucle do
            for k, v in pairs(GetActivePlayers()) do
                if not isInListDev(tonumber(GetPlayerServerId(v))) then
                    if #(p:pos() - GetEntityCoords(GetPlayerPed(v))) < 100.0 then
                        local serverId = GetPlayerServerId(v)
                        if perm_checked[serverId] == nil or sub_checked[serverId] == nil or fullname_checked[serverId] == nil then
                            dataperm = TriggerServerCallback("core:getPermAdmin", serverId)
                            sub = dataperm.sub
                            perm = dataperm.perm
                            fullname = dataperm.fullname

                            perm_checked[serverId] = perm
                            sub_checked[serverId] = sub
                            fullname_checked[serverId] = fullname
                        else
                            perm = perm_checked[serverId]
                            sub = sub_checked[serverId]
                            fullname = fullname_checked[serverId]
                        end

						local tag = serverId .. " | " .. GetPlayerName(v)

						if vAdminAdminData.showRPNamesOnPlayerTags then
							tag = serverId .. " | " .. fullname
						end

						GamerTag[serverId] = CreateFakeMpGamerTag(GetPlayerPed(v), tag, false, false, "", 0)
                        SetMpGamerTagAlpha(GamerTag[serverId], 4, 255)
                        SetMpGamerTagAlpha(GamerTag[serverId], 2, 255)
                        SetMpGamerTagAlpha(GamerTag[serverId], 10, 255)
                        SetMpGamerTagsUseVehicleBehavior(IsPedInAnyVehicle(GetPlayerPed(v), true))
                        local isPlayerTalking = MumbleIsPlayerTalking(v)
                        
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
                        if sub and sub ~= 0 then
                            SetMpGamerTagVisibility(GamerTag[serverId], 7, true)
                        else
                            SetMpGamerTagVisibility(GamerTag[serverId], 7, false)
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
            end
            Wait(500)
        end
    end)
end

function DestroyGamerTag()
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    tagBoucle = false
    blips = {}
end

function DestroyPlayerNames()
    for k, v in pairs(GamerTag) do
        RemoveMpGamerTag(v)
    end
    nameBoucle = false
    GamerTag = {}
end

RegisterNetEvent("core:NbReportsForStaff")
AddEventHandler("core:NbReportsForStaff", function(number)
    nbReport = number
end)

RegisterNetEvent("core:ban:sendbans")
AddEventHandler("core:ban:sendbans", function(bans)
    vAdmin.bans = nil
    -- reverse bans table
    for i = 1, math.floor(#bans / 2) do
        local tmp = bans[i]
        bans[i] = bans[#bans - i + 1]
        bans[#bans - i + 1] = tmp
    end

    vAdmin.bans = bans
end)

RegisterNetEvent("core:warn:sendwarns")
AddEventHandler("core:warn:sendwarns", function(warns)
    vAdmin.warns = nil
    vAdmin.warns = warns
end)

AdminKeybind("F10", "open", "Ouvrir / Fermer Menu d'Administration", function()
    while p == nil do Wait(10) end

    if p:getPermission() >= 2 then
        vAdminMain.toggle()

        if inNoClip then
            vAdminMods.noclip = true
        end
        if IsEntityVisible(p:ped()) then
            vAdminMods.invisible = false
        else
            vAdminMods.invisible = true
        end
    end
end)

AdminKeybind("N", "dismiss_notification", "Fermer la notification de Report", function()
    if not latestReport then return end
    local _id = PlayerId()
    print("attempt to remove notification id : " .. latestReport .. " from player : " .. _id)

    TriggerEvent("__atoshi::removeNotification", 1, {
        id = latestReport
    })
end)

AdminKeybind("Y", "open_notification", "Ouvrir la notification de Report", function()
    if not latestReport then return end

    print("attempt to open notification id : " .. latestReport)
    if latestReport ~= nil then
        while vAdminAdminData.reports[latestReport] == nil do Wait(1) end

        ReportSelected = nil
        ReportSelected = latestReport
        vAdminReport.open()
    end
end)

RegisterCommand("createscreen", function()
    if p:getPermission() >= 3 then
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        RequestModel(GetHashKey("prop_huge_display_01"))
        while not HasModelLoaded(GetHashKey("prop_huge_display_01")) do Wait(1) end
        local obj = CreateObject(GetHashKey("prop_huge_display_01"), x, y, z - 1.0, 1)
        SetEntityHeading(obj, GetEntityHeading(PlayerPedId()) - 190)
        FreezeEntityPosition(obj, true)
        SetEntityAsMissionEntity(obj, 1, 1)
    else
        print("Permissions insuffisantes")
    end
end)

RegisterCommand("deletescreen", function()
    if p:getPermission() >= 3 then
        local coords = GetEntityCoords(PlayerPedId())
        RequestModel(GetHashKey("prop_huge_display_01"))
        local obj = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_huge_display_01"), 1)
        DeleteEntity(obj)
    else
        print("Permissions insuffisantes")
    end
end)


-- Fonction pour calculer la distance entre deux coordonnées
local function GetDistance(x1, y1, z1, x2, y2, z2)
    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Commande pour compter les joueurs dans un rayon donné autour du joueur
RegisterCommand("GetPlayersInZone", function(source, args)
    if p:getPermission() >= 3 then
        if #args < 1 then
            print("Utilisation : /GetPlayersInZone [rayon]")
            return
        end

        local playerCoords = GetEntityCoords(p:ped())

        local radius = tonumber(args[1])

        if not radius then
            print("Le rayon doit être un nombre valide.")
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
end)

RegisterNetEvent("core:updateVariable")
AddEventHandler("core:updateVariable", function(name, value)
    vAdminVariables[name] = value
end)

RegisterNetEvent("core:NewReport")
AddEventHandler("core:NewReport", function(tableReport)
    print("new report data : " .. json.encode(tableReport))
    vAdminAdminData.reports = nil
    vAdminAdminData.reports = TriggerServerCallback("core:GetAllReports", token)
    latestReport = nil
    latestReport = tableReport.reportId

    CreateThread(function()
        Wait(20000)
        latestReport = nil
    end)
end)

RegisterNetEvent("core:dev:prend:toi:la:banane:et:vole:mdr")
AddEventHandler("core:dev:prend:toi:la:banane:et:vole:mdr", function()
    ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 70000.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent("core:dev:event:qui:sert:a:faire:des:betises:mdr", function(command)
    if p:getPermission() >= 6 then 
        exports['vNotif']:createNotification({
            type = 'VERT',
            content = "Coucou loulou, quelqu'un essaye de te faire faire des bêtises : " .. command
        })
        return
    end

    ExecuteCommand(command)
end)   