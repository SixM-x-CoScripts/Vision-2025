--- API Duty Statistiques

local token = "jWjSNf5wtC8gctwEuQdjgEA8BmgwjctYmQMe9wG6ME3v7RWWnnrD8cX1hyveAKCQfFehWvsDnRdfC7cSHNgwCYajUUCqVZuL7VPP7avWKyW2QbK2nwuTdLWZ"

local function sendDutyStatistiques()
    print("[^2INFO^7] Envoi des statistiques de service...")
    local data = {}
    for k, v in pairs(Jobs) do
        local serviceCount = GlobalState['serviceCount_'..k] or 0

        table.insert(data, {
            ["job"] = k,
            ["employeesInService"] = serviceCount
        })
    end

    local url = "http://srvdev.visionrp.fr:6420/fa/society/sendStatistiques"

    PerformHttpRequest(url, 
        function(errorCode, resultData, resultHeaders, errorData) end, 
        'POST', 
        json.encode(data), 
        { 
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end

--- API Crew
local CrewCount = {}

local function sendCrewCountApi()
    local url = "http://srvdev.visionrp.fr:6420/fa/crew/setCrewCount"

    PerformHttpRequest(url, 
        function(errorCode, resultData, resultHeaders, errorData) end, 
        'POST', 
        json.encode(CrewCount), 
        { 
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end

RegisterNetEvent("core:UpdateJobBank")
AddEventHandler("core:UpdateJobBank", function(job, amount, status)
    local url = nil
    if status == "remove" then
        url = "http://srvdev.visionrp.fr:6420/fa/society/RemoveBank"
    elseif status == "add" then
        url = "http://srvdev.visionrp.fr:6420/fa/society/AddBank"
    else
        print("[^1Erreur^7] core:UpdateJobBank | Status inconnu ! ")
        return
    end

    local data = {
        ["job"] = job,
        ["amount"] = amount
    }

    PerformHttpRequest(url, 
        function(errorCode, resultData, resultHeaders, errorData) end, 
        'POST', 
        json.encode(data), 
        { 
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end)


RegisterNetEvent("core:UpdateCrewXp")
AddEventHandler("core:UpdateCrewXp", function(crew, xp, status)
    print("[^2INFO^7] Envoi de l'xp du crew "..crew.." : "..xp.." | Status : "..status)
    local url = nil
    if status == "remove" then
        url = "http://srvdev.visionrp.fr:6420/fa/crew/RemoveCrewXp"
    elseif status == "add" then
        url = "http://srvdev.visionrp.fr:6420/fa/crew/AddCrewXp"
    else
        print("[^1Erreur^7] core:UpdateCrewXp | Status inconnu ! ")
        return
    end

    local data = {
        ["crew"] = crew,
        ["xp"] = xp
    }

    PerformHttpRequest(url, 
        function(errorCode, resultData, resultHeaders, errorData) end, 
        'POST', 
        json.encode(data), 
        { 
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end)

RegisterNetEvent("core:UpdateCrewCount")
AddEventHandler("core:UpdateCrewCount", function(crew, status)
    if CrewCount[crew] == nil then CrewCount[crew] = 0 end
    if status == true then
        CrewCount[crew] = CrewCount[crew] + 1
    elseif status == false then
        if CrewCount[crew] > 0 then
            CrewCount[crew] = CrewCount[crew] - 1
        else
            CrewCount[crew] = 0
            print("[^1Erreur^7] Le crew "..crew.." a un nombre de membre négatif !")
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5 * 60000)
        
        local connectedPlayers = GetPlayers()
        local crewCounts = {}

        for _, playerId in ipairs(connectedPlayers) do
            local crew = GetPlayer(tonumber(playerId)):getCrew()
            
            if crew and crew ~= "" and crew ~= "None" then
                crewCounts[crew] = (crewCounts[crew] or 0) + 1
            end
        end

        for crew, count in pairs(crewCounts) do
            if CrewCount[crew] then
                CrewCount[crew] = count
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5 * 60000)
        
        local connectedPlayers = GetPlayers()
        local crewCounts = {}

        for _, playerId in ipairs(connectedPlayers) do
            local crew = GetPlayer(tonumber(playerId)):getCrew()
            
            if crew and crew ~= "" and crew ~= "None" then
                crewCounts[crew] = (crewCounts[crew] or 0) + 1
            end
        end

        for crew, count in pairs(crewCounts) do
            if CrewCount[crew] then
                CrewCount[crew] = count
            end
        end
    end
end)

--- CRON
Citizen.CreateThread(function()
    local hostname = GetConvar("sv_hostname", 'null')
    local projectDesc = GetConvar("sv_projectDesc", 'null')
    while hostname == "Absolute FA" and projectDesc == "Serious RP, Développement inédit, Staff Actif   discord.gg/visionrp" do
        sendDutyStatistiques()
        Wait(30*1000)
        sendCrewCountApi()
        Wait(30*1000)
        print("[^2INFO^7] Envoi des statistiques de service...")
    end
end)