local InSecuroServ = false

local securoserv = {
    vector4(473.2, -1311.66, 28.22, 239.37),
    vector4(2329.25, 2571.36, 45.72, 332.11)
}

local function objectToTable(obj)
    local tbl = {}
    for k, v in pairs(obj) do
        if v.positionActive == false then v.position = nil end
        table.insert(tbl, v)
    end
    return tbl
end

function GetRankBraquage(name)
    for k,v in pairs(objectToTable(GetVariable("securoserv"))) do 
        if v.name and name and string.lower(v.name) == string.lower(name) then 
            return v.rank
        end
    end
    return "D"
end

local function GetRankIndex(rank)
    local ranks = { "D", "C", "B", "A", "S" }
    for i, r in ipairs(ranks) do
        if r == rank then
            return i
        end
    end
    return nil
end

local noSpam = {}
function CanAccessAction(name)
    if noSpam[name] then 
        return noSpam[name].value
    end
    local crewRank = GetCrewRank()
    local actionRank = GetRankBraquage(name)

    local playerRankIndex = GetRankIndex(crewRank)
    local actionRankIndex = GetRankIndex(actionRank)

    printDev("Mon rank en index :", playerRankIndex, "Rank action index :", actionRankIndex)
    if playerRankIndex and actionRankIndex and playerRankIndex >= actionRankIndex then
        noSpam[name] = {value = true}
        return true
    else
        noSpam[name] = {value = false}
        return false
    end
end

function ResetNoSpamSecuro()
    noSpam = {}
end

function OpenSecuroServCenter()
    closeUI()
    InSecuroServ = true
    while not GetVariable do Wait(1) end
    SendNUIMessage({
        type = "openWebview",
        name = "MenuSecuroserv",
        data = {
            headerIcon = "https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp",
            headerIconName = "Securo Serv",
            premium = p:getSubscription(),
            items = objectToTable(GetVariable("securoserv")),
            headerRank = GetCrewRank()
        }
    })
end

local securoPeds = {}

local function createSecuroServ()
    for k, v in pairs(securoserv) do
        print("create", k)
        if p:getCrew() ~= "None" and (p:getCrewType() == "pf" or p:getCrewType() == "gang" or p:getCrewType() == "mc" or p:getCrewType() == "orga" or p:getCrewType() == "mafia") then
            securoPeds[k] = entity:CreatePedLocal("mp_m_securoguard_01", v.xyz, v.w)
            securoPeds[k]:setFreeze(true)
            SetEntityInvincible(securoPeds[k].id, true)
            SetEntityAsMissionEntity(securoPeds[k].id, 0, 0)
            SetBlockingOfNonTemporaryEvents(securoPeds[k].id, true)
            RequestAnimDict("anim@heists@heist_corona@single_team")
            while not HasAnimDictLoaded("anim@heists@heist_corona@single_team") do Wait(200) end
            TaskPlayAnim(securoPeds[k].id, "anim@heists@heist_corona@single_team", "single_team_loop_boss",  1000.0, -2.0, -1, 2, 1148846080, 0)
            
            local blip = AddBlipForCoord(v.xyz)
            SetBlipSprite(blip, 472)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.9)
            SetBlipColour(blip, 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Securo Serv")
            EndTextCommandSetBlipName(blip)

            zone.addZone(
                "securoserv"..k,
                v.xyz + vector3(0.0, 0.0, 2.0),
                "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le menu Securo Serv",
                function()
                    OpenSecuroServCenter()
                end,
                false,
                27,
                0.5,
                { 255, 255, 255 },
                170,
                7.5,
                true,
                "bulleSecuroServ",
                true
            )
        end
    end
end

function updateCrewPlayer(crew)
    print("crew", crew)
    for k, v in pairs(securoPeds) do
        print("delete", k)
        if DoesEntityExist(v.id) then
            DeleteEntity(v.id)
        end
    end
    for k, v in pairs(securoserv) do
        print("delete", k)
        zone.removeZone("securoserv"..k)
        zone.removeBulle("securoserv"..k)
    end

    print('info crew ', p:getCrew(), p:getCrewType())
    if p:getCrew() ~= "None" and (p:getCrewType() == "pf" or p:getCrewType() == "gang" or p:getCrewType() == "mc" or p:getCrewType() == "orga" or p:getCrewType() == "mafia") then
        print("create")
        createSecuroServ()
    end
end

CreateThread(function()
    while not p do Wait(100) end
    while not zone do Wait(100) end

    if p:getCrew() ~= "None" and (p:getCrewType() == "pf" or p:getCrewType() == "gang" or p:getCrewType() == "mc" or p:getCrewType() == "orga" or p:getCrewType() == "mafia") then
        createSecuroServ()
    end
end)

RegisterNUICallback("focusOut", function()
    if InSecuroServ then
        InSecuroServ = false
    end
end)

RegisterNUICallback("selectMission", function(missionName, cb)
    cb({})
    local missions = GetVariable("securoserv")
    for _, mission in pairs(missions) do
        if mission.name == missionName then
            -- Place a waypoint to job.position
            if not mission.position then return end
            SetNewWaypoint(mission.position.x, mission.position.y)
            exports['vNotif']:createNotification({
                type = 'VERT',
                content = "La position a été ajoutée à votre GPS"
            })
            break
        end
    end
    InSecuroServ = false
    closeUI()
end)