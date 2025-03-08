local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

Citizen.Wait(1000)

local idInstructionalButtons = { generateUniqueID(), generateUniqueID() }
local spectating = false
local lastPos = nil
local players = {}
local currentSpectateIndex = 1
local target = { ped = nil, id = nil, pos = nil }

local function shuffleTable(tbl)
    local n = #tbl
    math.randomseed(GetGameTimer())
    for i = n, 2, -1 do
        local j = math.random(1, i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

local function spectatePlayer(targetId)
    SetNoClipAttributes(PlayerPedId(), nil, true)
    target.id = tonumber(targetId)
    TriggerServerEvent("core:GotoBring", token, nil, target.id)

    local cID = GetPlayerFromServerId(target.id)

    Citizen.CreateThread(function()
        for i = 1, 5000 do
            cID = GetPlayerFromServerId(target.id)
            if cID and cID ~= -1 then break end
            Citizen.Wait(10)
        end

        target.ped = GetPlayerPed(GetPlayerFromServerId(target.id))
        print(target.ped)

        if target.ped and target.ped ~= PlayerPedId() then
            print(json.encode(target))
            print("Spectating player: ", target.id)
            AttachEntityToEntity(PlayerPedId(), target.ped, 31086, 0.0, 0, 50.0, 0, 0, 0, true, true, false, true, 1, false)
            NetworkSetInSpectatorMode(true, target.ped)
        else
            print("Erreur : le joueur cible est invalide.")
        end
    end)
end

-- local function stopSpectating()
--     instructionalButtons[idInstructionalButtons[1]] = {}

--     SetEntityNoCollisionEntity(PlayerPedId(), target.ped, false)
--     DetachEntity(PlayerPedId(), true, true)
--     NetworkSetInSpectatorMode(false, target.ped)
--     SetNoClipAttributes(PlayerPedId(), nil, false)

--     if lastPos then
--         local _, z = GetGroundZFor_3dCoord(lastPos.x, lastPos.y, lastPos.z, true, 0)
--         SetEntityCoords(PlayerPedId(), lastPos.x, lastPos.y, z)
--     end

--     target = { ped = nil, id = nil }
--     lastPos = nil
--     spectating = false
--     currentSpectateIndex = 1
--     players = {}
-- end

local function stopSpectating()
    instructionalButtons[idInstructionalButtons[1]] = {}

    SetEntityNoCollisionEntity(PlayerPedId(), targetPed, false)
    NetworkSetInSpectatorMode(false, targetPed)
    SetNoClipAttributes(PlayerPedId(), nil, false)
    DetachEntity(PlayerPedId(), true, true)
    local get, z = GetGroundZFor_3dCoord(lastPos.x, lastPos.y, lastPos.z, true, 0)
    SetEntityCoords(PlayerPedId(), lastPos.x, lastPos.y, z)
    targetPed = nil
    spectating = false
end

RegisterCommand('spectatedev', function()
    if p:getPermission() < 69 then return end

    if spectating then
        stopSpectating()
        return
    end

    lastPos = GetEntityCoords(PlayerPedId())

    local allPlayers = TriggerServerCallback("core:GetAllPlayerId", token)
    while allPlayers == nil do
        Citizen.Wait(0)
    end
    
    for i = #allPlayers, 1, -1 do
        if allPlayers[i] == GetPlayerServerId(PlayerId()) then
            table.remove(allPlayers, i)
            break
        end
    end    

    if #allPlayers > 0 then
        players = shuffleTable(allPlayers)
        currentSpectateIndex = 1
        spectating = true

        spectatePlayer(players[currentSpectateIndex])

        instructionalButtons[idInstructionalButtons[1]] = {
            { control = 175, label = "Passer au joueur suivant" },
            { control = 174, label = "Passer au joueur précédent" },
            { control = 172, label = "Ouvrir le profil du joueur" },
            { control = 194, label = "" },
            { control = 203, label = "" },
            { control = 202, label = "Quitter le mode spectate" },
        }

        Citizen.CreateThread(function()
            while spectating do
                if IsControlJustReleased(1, 175) then
                    currentSpectateIndex = (currentSpectateIndex % #players) + 1
                    spectatePlayer(players[currentSpectateIndex])
                end

                if IsControlJustReleased(1, 174) then
                    currentSpectateIndex = (currentSpectateIndex - 2 + #players) % #players + 1
                    spectatePlayer(players[currentSpectateIndex])
                end

                if IsControlJustReleased(0, 172) and target.id then
                    ExecuteCommand("openplayer " .. target.id)
                end

                if IsControlJustPressed(1, 202) or IsControlJustPressed(1, 194) or IsControlJustPressed(1, 203) then
                    stopSpectating()
                end

                Citizen.Wait(0)
            end
        end)
    else
        print("Aucun joueur à spectate.")
    end
end, false)
addChatSuggestion(68, "spectatedev", "Permet de passer en mode spectate.")