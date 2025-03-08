
openCrewRadial = false
MyCrewLevel = nil
MyCrewColor = nil

local levels = {
    {rank = "D", level = 5, xpRequired = 25000},
    {rank = "C", level = 10, xpRequired = 50000},
    {rank = "B", level = 25, xpRequired = 125000},
    {rank = "A", level = 50, xpRequired = 250000},
    {rank = "S", level = 100, xpRequired = 500000}
}

local function OpenRadialCrewMenu(crew)
    if p:getCrew() == "None" then return end
    if MyCrewLevel == nil then 
        MyCrewLevel, MyCrewColor = TriggerServerCallback('core:crew:getCrewInfosForRadial',p:getCrew())
    end
    if not openCrewRadial then
        openCrewRadial = true
        CreateThread(function()
            while openCrewRadial do
                Wait(0)
                DisableControlAction(0, 1, openCrewRadial)
                DisableControlAction(0, 2, openCrewRadial)
                DisableControlAction(0, 142, openCrewRadial)
                DisableControlAction(0, 18, openCrewRadial)
                DisableControlAction(0, 322, openCrewRadial)
                DisableControlAction(0, 106, openCrewRadial)
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
            end
        end)
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        Wait(200)
        CreateThread(function()

            function subRadialGestion()
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'RadialMenu',
                    data = { elements = {
                            {
                                name = "QUITTER LE CREW",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "leaveCrew"
                            },
                            {
                                name = "GESTION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/gestion.svg",
                                action = "openCrewGestion"
                            },
                            {
                                name = "RETOUR",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/leave.svg",
                                action = "mainCrewRadial"
                            },
                            {
                                name = "INVITER",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/gestion.svg",
                                action = "inviteCrew"
                            }
                        }, 
                        title = "Gestion",
                        key = "F2"
                    }
                }));
            end

            function getProgressionPercentage(xp)
                local previousLevelXP = 0
                local nextLevelXP = 0
                local level = 0
                if xp == nil then xp = 0 end
                
                for i, levelInfo in ipairs(levels) do
                    if xp < levelInfo.xpRequired then
                        nextLevelXP = levelInfo.xpRequired
                        level = levelInfo.level
                        break
                    end
                    previousLevelXP = levelInfo.xpRequired
                end
                
                -- Calcul du pourcentage de progression
                local progressXP = xp - previousLevelXP
                local totalXPNeeded = nextLevelXP - previousLevelXP
                local progressionPercentage = (progressXP / totalXPNeeded) * 100
                if previousLevelXP == 500000 then progressionPercentage = 100 end
                
                return progressionPercentage
            end
            
            function getProgressionLevel(xp)
                local level = 0
                local prestigeLevel = 0
                local xpreq = 0
                if xp == nil then xp = 0 end
                
                for i, levelInfo in ipairs(levels) do
                    if xp < levelInfo.xpRequired then
                        level = levelInfo.level
                        if i > 1 then
                            level = levels[i - 1].level
                            xpreq = levels[i - 1].xpRequired
                        end
                        if xp > xpreq then 
                            local nxp = (xp - xpreq)
                            if nxp > 0 then 
                                local nlvl = (nxp/5000)
                                if nlvl > 0 then 
                                    prestigeLevel = nlvl
                                end
                            end
                        end
                        break
                    elseif i == #levels then
                        level = levelInfo.level
                        if level == 100 then 
                            local nxp = (xp - levelInfo.xpRequired)
                            if nxp > 0 then 
                                local nlvl = (nxp/5000)
                                if nlvl > 0 then 
                                    prestigeLevel = nlvl
                                end
                            end
                        end
                    end
                end
                
                if prestigeLevel ~= 0 then 
                    level = level + prestigeLevel
                end
                
                return math.floor(level)
            end

            function mainCrewRadial()
                SendNuiMessage(json.encode({
                    type = 'openWebview',
                    name = 'RadialMenu',
                    data = { 
                        elements = {
                            {
                                name = "TERRITOIRE",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/territoire.svg",
                                action = "openMenuTerrioire"
                            },  
                            {
                                name = "GESTION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/gestion.svg",
                                action = "subRadialGestion"
                            },
                            {
                                name = "MISSION",
                                icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/mission.svg",
                                action = "OpenSecuroServCenter"
                            },
                            -- {
                            --     name = "OBJETS",
                            --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/objets.svg",
                            --     action = ""
                            -- }
                        },
                        title = "CREW",
                        key = "F2",
                        bar = {
                            crew = p:getCrew(),
                            time = "0",
                            color = MyCrewColor or "#33963C",
                            value = getProgressionPercentage(MyCrewLevel),
                            valueString = "Level " .. getProgressionLevel(MyCrewLevel),
                            rank = GetCrewRank(),
                            postAsync = {
                                url = "test",
                                data = {},
                            }
                        }
                    }
                }));
            end

            mainCrewRadial()
        end)
    else
        openCrewRadial = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        return
    end
end

RegisterNUICallback("focusOut", function(data, cb)
    if openCrewRadial then
        openCrewRadial = false
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
    end
    cb({})
end)

Keys.Register("F2", "F2", "Ouvrir le menu crew", function()
    print(not p:getInAction() and p:getCrew() ~= "None")
    if not p:getInAction() and p:getCrew() ~= "None" then
        OpenRadialCrewMenu(p:getCrew())
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            content = "~s Vous ne pouvez pas faire ça maintenant ..."
        })

    end
end)

CreateThread(function()
    while not p do Wait(1000) end
    Wait(5333)
    while true do 
        if p:getCrew() ~= "None" then
            MyCrewLevel, MyCrewColor = TriggerServerCallback('core:crew:getCrewInfosForRadial',p:getCrew())
        end
        Wait(30000)
    end
end)


function GetCrewRank()
    local xp = MyCrewLevel
    local rank = "D"
    if xp == nil then xp = 0 end
    
    for i, levelInfo in ipairs(levels) do
        if xp < levelInfo.xpRequired then
            rank = levelInfo.rank
            if i > 1 then
                rank = levels[i - 1].rank
            end
            break
        elseif i == #levels then
            rank = levelInfo.rank
        end
    end
    
    return rank
end