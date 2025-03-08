inDuty = {
    ["lspd"] = {},
    ["ems"] = {},
    ["bcms"] = {},
    ["cayoems"] = {},
    ["weazelnews"] = {},
    ["lifeinvader"] = {},
    ["bennys"] = {},
    ["cayogarage"] = {},
    ["hayes"] = {},
    ["beekers"] = {},
    ["sunshine"] = {},
    ["taxi"] = {},
    ["ltdsud"] = {},
    ["ltdseoul"] = {},
    ["ltdmirror"] = {},
    ["sushistar"] = {},
    ["bahamas"] = {},
    ["vclub"] = {},
    ["club77"] = {},
    ["skyblue"] = {},
    ["rexdiner"] = {},
    ["burgershot"] = {},
    ["cardealerSud"] = {},
    ["unicorn"] = {},
    ["royalhotel"] = {},
    ["realestateagent"] = {},
    ["autoecole"] = {},
    ["justice"] = {},
    ["irs"] = {},
    ["avocat"] = {},
    ["avocat2"] = {},
    ["avocat3"] = {},
    ["tacosrancho"] = {},
    ["gouv"] = {},
    ["gouv2"] = {},
    ["usss"] = {},
    ["boi"] = {},
    ["concessvelo"] = {},
    ["heliwave"] = {},
    ["pawnshop"] = {},
    ["lsfd"] = {},
    ["lucky"] = {},
    ["athena"] = {},
    ["mostwanted"] = {},
    ["casse"] = {},
    ["tequilala"] = {},
    ["uwu"] = {},
    ["pizzeria"] = {},
    ["pearl"] = {},
    ["upnatom"] = {},
    ["hornys"] = {},
    ["mayansclub"] = {},
    ["ocean"] = {},
    ["concessentreprise"] = {},
    ["tattooSud"] = {},
    ["comrades"] = {},
    ["sultan"] = {},
    ["mirror"] = {},
    ["g6"] = {},
    ["usmc"] = {},
    ["barber"] = {},
    ["sandybeauty"] = {},
    --["barberNord"] = {},
    ["shenails"] = {},
    ["harmony"] = {},
    ["lssd"] = {},
    ["gcp"] = {},
    ["cardealerNord"] = {},
    ["bayviewLodge"] = {},
    ["bean"] = {},
    ["pops"] = {},
    ["cluckin"] = {},
    ["domaine"] = {},
    ["barber2"] = {},
    ["barbercayo"] = {},
    ["ammunation"] = {},
    ["vangelico"] = {},
    ["tattooNord"] = {},
    ["tattooCayo"] = {},
    ["amerink"] = {},
    ["don"] = {},
    ["records"] = {},
    ["emperium"] = {},
    ["lsevent"] = {},
    ["rockford"] = {},
    ["postop"] = {},
    ["yellowJack"] = {},
    ["blackwood"] = {},
    ["lst"] = {},
    ["bp"] = {},
}

local callActive = {
    ["lspd"] = { target = {} },
    ["ems"] = { target = {} },
    ["bcms"] = { target = {} },
    ["cayoems"] = { target = {} },
    ["bcms"] = { target = {} },
    ["lsfd"] = { target = {} },
    ["bennys"] = { target = {} },
    ["cayogarage"] = { target = {} },
    ["hayes"] = { target = {} },
    ["beekers"] = { target = {} },
    ["sunshine"] = { target = {} },
    ["taxi"] = { target = {} },
    ["ltdsud"] = { target = {} },
    ["ltdseoul"] = { target = {} },
    ["ltdmirror"] = { target = {} },
    ["weazelnews"] = { target = {} },
    ["lifeinvader"] = { target = {} },
    ["sushistar"] = { target = {} },
    ["bahamas"] = { target = {} },
    ["vclub"] = { target = {} },
    ["club77"] = { target = {} },
	["rexdiner"] = { target = {} },
	["skyblue"] = { target = {} },
    ["burgershot"] = { target = {} },
    ["cardealerSud"] = { target = {} },
    ["unicorn"] = { target = {} },
    ["royalhotel"] = { target = {} },
    ["realestateagent"] = { target = {} },
    ["autoecole"] = { target = {} },
    ["justice"] = { target = {} },
    ["irs"] = { target = {} },
    ["avocat"] = { target = {} },
    ["avocat2"] = { target = {} },
    ["avocat3"] = { target = {} },
    ["tacosrancho"] = { target = {} },
    ["gouv"] = { target = {} },
    ["gouv2"] = { target = {} },
    ["usss"] = { target = {} },
    ["boi"] = { target = {} },
    ["concessvelo"] = { target = {} },
    ["heliwave"] = { target = {} },
    ["pawnshop"] = { target = {} },
    ["lucky"] = { target = {} },
    ["athena"] = { target = {} },
    ["mostwanted"] = { target = {} },
    ["casse"] = { target = {} },
    ["tequilala"] = { target = {} },
    ["uwu"] = { target = {} },
    ["pizzeria"] = { target = {} },
    ["pearl"] = { target = {} },
    ["upnatom"] = { target = {} },
    ["hornys"] = { target = {} },
    ["mayansclub"] = { target = {} },
    ["concessentreprise"] = { target = {} },
    ["tattooSud"] = { target = {} },
    ["comrades"] = { target = {} },
    ["sultan"] = { target = {} },
    ["mirror"] = { target = {} },
    ["g6"] = { target = {} },
    ["usmc"] = { target = {} },
    ["barber"] = { target = {} },
    --["barberNord"] = { target = {} },
    ["shenails"] = { target = {} },
    ["harmony"] = { target = {} },
    ["ocean"] = { target = {} },
    ["lssd"] = { target = {} },
    ["gcp"] = { target = {} },
    ["cardealerNord"] = { target = {} },
    ["bayviewLodge"] = { target = {} },
    ["bean"] = { target = {} },
    ["pops"] = { target = {} },
    ["cluckin"] = { target = {} },
    ["domaine"] = { target = {} },
    ["barber2"] = { target = {} },
    ["barbercayo"] = { target = {} },
    ["sandybeauty"] = { target = {} },
    ["ammunation"] = { target = {} },
    ["vangelico"] = { target = {} },
    ["don"] = { target = {} },
    ["records"] = { target = {} },
    ["emperium"] = { target = {} },
    ["lsevent"] = { target = {} },
    ["rockford"] = { target = {} },
    ["postop"] = { target = {} },
    ["yellowJack"] = { target = {} },
    ["blackwood"] = { target = {} },
    ["tattooNord"] = { target = {} },
    ["tattooCayo"] = { target = {} },
    ["amerink"] = { target = {} },
    ["lst"] = { target = {} },
    ["bp"] = { target = {} },
}

local isProduction = false

RegisterServerCallback("core:isInDuty", function(source)
    local obj = GetPlayer(source)
    local job = obj:getJob()
    if obj ~= nil then
        if job ~= nil then
            if inDuty[job] ~= nil then
                for k, v in pairs(inDuty[job]) do
                    if k == source then
                        return true
                    end
                end
            end
        end
    end
    return false
end)

RegisterNetEvent("core:DutyOn")
AddEventHandler("core:DutyOn", function(job)
    local src = source
    -- Protection cheater
    local ply = GetPlayer(src)
    if not ply then return end 
    if ply:getJob() ~= job then return end
    if job ~= nil then
        --table.insert(inDuty[job], source)
        SetDuty(src, job, true)
        SendDiscordLog("dutyon", "Prise de service", src, string.sub(GetDiscord(src), 9, -1), GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), job)

        if job == "lspd" or job == "lssd" or job == "ems" or job == "lsfd" then
			if ply:getDiscord() == nil then
				print("^8[ERROR]^0 MDT: Discord ID is nil : ^6", source, job, "^0")
				return
			end

			local discord = ply:getDiscord():sub(9)

			local service = string.upper(job)

			if (job == "ems" or job == "lsfd") then
				service = "EMS"
			end
			
            exports['knid-mdt']:api().agents.service.start(discord, service,
                function(cb)
					if cb == 200 then
						print("^2[" .. cb .. "]^0 MDT: Duty ON : ^6", src, discord, service, "^0")
					elseif cb == 409 then
						print("^8[" .. cb .. "]^0 MDT: Duty already ON : ^6", src, discord, service, "^0")
					else
						print("^8[" .. cb .. "]^0 MDT: Error on Duty ON : ^6", src, discord, service, "^0")
					end
				end)
        end
    else
        print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
    end
end)

RegisterNetEvent("core:DutyOff")
AddEventHandler("core:DutyOff", function(job)
    local source = source
    -- Protection cheater
    local ply = GetPlayer(source)
    if not ply then return end 
    if ply:getJob() ~= job then return end
    if job ~= nil and job ~= "aucun" then
        SetDuty(source, job, false)
        if source and GetPlayer(source) then 
            SendDiscordLog("dutyoff", "Fin de service", source, string.sub(GetDiscord(source), 9, -1), GetPlayer(source):getLastname() .. " " .. GetPlayer(source):getFirstname(), job)

			if job == "lspd" or job == "lssd" or job == "ems" or job == "lsfd" then
				if ply:getDiscord() == nil then
					print("^8[ERROR]^0 MDT: Discord ID is nil : ^6", source, job, "^0")
					return
				end

				local discord = ply:getDiscord():sub(9)

				local service = string.upper(job)

				if (job == "ems" or job == "lsfd") then
					service = "EMS"
				end
				
				
				exports['knid-mdt']:api().agents.service.stop(discord, service,
					function(cb)
						if cb == 200 then
							print("^2[" .. cb .. "]^0 MDT: Duty OFF : ^6", source, discord, service, "^0")
						elseif cb == 409 then
							print("^3[" .. cb .. "]^0 MDT: Duty already OFF : ^6", source, discord, service, "^0")
						else
							print("^8[" .. cb .. "]^0 MDT: Error on Duty OFF : ^6", source, discord, service, "^0")
						end
					end)
			end
        end
    elseif job ~= "aucun" then
        print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
    end
end)

RegisterNetEvent("core:ForceDutyOff")
AddEventHandler("core:ForceDutyOff", function(playerId)
    local src = source 
    local ply = GetPlayer(src)
    if not ply then return end 
    local perm = ply:getPermission()
    if perm < 2 then 
        SunWiseKick(src, "Tentative de core:ForceDutyOff sans permission")
        return 
    end
    local obj = GetPlayer(playerId)
    if obj ~= nil then
        local job = obj:getJob()
        if job == nil then return end
        SetDuty(playerId, job, false)
        TriggerClientEvent("__atoshi::createNotification", playerId, {
            type = 'ROUGE',
            --duration = 10,
            content = "Vous avez été retiré de votre service."
        })
        SendDiscordLog("dutyoff", "Fin de service (Forcée)", playerId, string.sub(GetDiscord(playerId), 9, -1), GetPlayer(playerId):getLastname() .. " " .. GetPlayer(playerId):getFirstname(), job)
    else
        print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
    end
end)

AddEventHandler("playerDropped", function()
    local src = source
    local obj = GetPlayer(src)
    if obj ~= nil then
        local job = obj:getJob()
        if job ~= nil and inDuty[job] then
            if inDuty[job][src] then
                inDuty[job][src] = nil
                if GlobalState['serviceCount_' .. job] and GlobalState['serviceCount_' .. job] > 0 then
                    print("playerDropped | event", src, job)
                    GlobalState['serviceCount_' .. job] = (GlobalState['serviceCount_' .. job] or 1) - 1
                end
            end
        end
    end
end)

function makeCallGreatAgain(job, pos, msg, typee)
    callActive[job].target = {
        id = 0,
        lastName = '',
        name = 'Inconnu(e)',
    }
    for k, v in pairs(inDuty[job]) do
        TriggerClientEvent("core:callIncoming", k, job, pos, callActive[job].target, msg, typee)
    end
end

RegisterNetEvent("core:advancedCall", function(job, netid, blipsprite, blipname)
    local goodentity = NetworkGetEntityFromNetworkId(netid)

    local timer = 0
    while DoesEntityExist(goodentity) and timer < 8 do 
        Wait(15000)
        timer = time + 1
        TriggerClientEvents("core:advancedCall", GetAllJobsIds({ "lspd", "lssd" }), GetEntityCoords(goodentity),blipsprite, blipname)
    end
    TriggerClientEvents("core:advancedCall", GetAllJobsIds({ "lspd", "lssd" }), nil)
end)

RegisterNetEvent("core:makeCall")
AddEventHandler("core:makeCall", function(time, secu, job, pos, isPnjCall, msg, sonnette, type)
    if job == nil or callActive[job] == nil then return end
    local source = source
    
    if not CheckTrigger(source, time, secu, "core:makeCall") then
        return
    end
    
    if not isPnjCall then
        if source == nil then return end

        if callActive[job] and callActive[job].target and callActive[job].target.id == source then
            if type ~= 'illegal' then
                TriggerClientEvent('core:takeCall', callActive[job].target.id, 'callAlrdyActive')
                return
            end
        end

        local ply = GetPlayer(source)
        if ply then
            callActive[job].target = {
                id = source,
                lastName = ply:getLastname(),
                name = ply:getFirstname(),
            }
        end
    else
        callActive[job].target = {
            id = source,
            lastName = '',
            name = 'Inconnu(e)',
        }
    end

    if sonnette then
        -- get the label of the job
        local label = ''
        for k, v in pairs(Jobs) do
            if v.name == job then
                label = v.label
            end
        end
        -- TriggerClientEvent("core:ShowNotification", callActive[job].target.id, "Vous venez d'appeler l'entreprise ~g~" .. label)

        -- New notif
		TriggerClientEvent("__atoshi::createNotification", callActive[job].target.id, {
			type = 'CLOCHE',
			-- duration = 5, -- In seconds, default:  4
			content = "Vous venez d'appeler l'entreprise : ~s" .. label
		})
    end

    for k, v in pairs(inDuty[job]) do
        TriggerClientEvent("core:callIncoming", k, job, pos, callActive[job].target, msg, type)
    end

    if not isPnjCall then
        SetTimeout(60000, function()
            if next(callActive[job].target) then
                if type ~= 'illegal' then
                    TriggerClientEvent('core:takeCall', callActive[job].target.id, 'noAnswer')
                end
                callActive[job].target = {}
            end
        end)
    end
end)

RegisterNetEvent("core:callAccept")
AddEventHandler("core:callAccept", function(job, pos, targetData, typee)
    local isPnj = false
    if callActive[job].target.name == 'Inconnu(e)' then
        isPnj = true
    end
    callActive[job].target = {}

    for k, v in pairs(inDuty[job]) do
        if k == source then
            TriggerClientEvent("core:callAccepted", k, job, pos, targetData, typee)
        end
    end

    if typee == "drugs" or typee == "illegal" then return end
    if not isPnj then
        if not next(callActive[job].target) then
            if typee == nil then
                TriggerClientEvent('core:takeCall', targetData.id, 'callTake')
            end
        end
    end
end)

local function sendDutyApi(source, status)
    local player = GetPlayer(source)
    if not player then return end
    local jobname = player:getJob()
    if jobname ~= "lspd" and jobname ~= "lssd" and jobname ~= "usss" then return end

    local lastname = player:getLastname()
    local firstname = player:getFirstname()
    local discordId, _ = string.gsub(GetDiscord(source), "^discord:", "")
    local url = "http://srvdev.visionrp.fr:6420/fa/society/startDuty"

    print("sendDutyApi", status, source, jobname, discordId, lastname, firstname)

    if status == "start" then
        url = "http://srvdev.visionrp.fr:6420/fa/society/startDuty"
    elseif status == "end" then
        url = "http://srvdev.visionrp.fr:6420/fa/society/endDuty"
    end

    local token = "jWjSNf5wtC8gctwEuQdjgEA8BmgwjctYmQMe9wG6ME3v7RWWnnrD8cX1hyveAKCQfFehWvsDnRdfC7cSHNgwCYajUUCqVZuL7VPP7avWKyW2QbK2nwuTdLWZ"
    local data = {
        ["jobname"] = jobname,
        ["id_discord"] = discordId,
        ["timestamp"] = os.time(),
        ["lastname"] = lastname,
        ["firstname"] = firstname
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
end

function SetDuty(plySource, name, bool)
    if bool then
        local currentCount = GlobalState['serviceCount_' .. name] or 0
        --print("setDuty | OnDuty", plySource, name)
        GlobalState['serviceCount_' .. name] = currentCount + 1
        if not inDuty[name] then inDuty[name] = {} end
        inDuty[name][plySource] = true
        sendDutyApi(plySource, "start")
    else
        if inDuty[name] then
            if GlobalState['serviceCount_' .. name] and GlobalState['serviceCount_' .. name] > 0 then
                --print("setDuty | OffDuty", plySource, name)
                GlobalState['serviceCount_' .. name] = (GlobalState['serviceCount_' .. name] or 1) - 1
            end
            inDuty[name][plySource] = nil
            sendDutyApi(plySource, "end")
        end
    end
end

function GetInServiceCount(job)
    return GlobalState['serviceCount_' .. job] or 0
end

Citizen.CreateThread(function()
    while RegisterServerCallback == nil do Wait(1000) end

    RegisterServerCallback("core:getNumberOfDuty", function(source, token, job)
        if CheckPlayerToken(source, token) then
            if job ~= "aucun" then
                if inDuty[job] ~= nil then
                    if #inDuty[job] ~= nil then
                        return #inDuty[job]
                    else
                        return 0
                    end
                else
                    print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
                    return 0
                end
            else
                return 0
            end
        end
    end)
    
    -- RegisterServerCallback("core:getNumberOfDuties", function(source, token, job)
    --     local toadd = 0
    --     if CheckPlayerToken(source, token) then
    --         if type(job) == "table" then
    --             for k,v in pairs(job) do 
    --                 if inDuty[v] ~= nil then
    --                     if #inDuty[v] ~= nil then
    --                         toadd = toadd + #inDuty[v]
    --                     end
    --                 end
    --                 Wait(50)
    --             end
    --         end
    --     end
    --     return toadd
    -- end)

    RegisterServerCallback("core:GetHoraire", function(source, token)
        if CheckPlayerToken(source, token) then
            return os.date("%H")
        end
    end)

    function getOnDuty(job)
        if job ~= "aucun" then
            if inDuty[job] ~= nil then
                if inDuty[job] ~= nil then
                    return inDuty[job]
                else
                    return false
                end
            else
                print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
                return false
            end
        else
            return false
        end
    end

    RegisterServerCallback("core:getOnDuty", function(source, token, job)
        if CheckPlayerToken(source, token) then
            return getOnDuty(job)
        end
    end)

    RegisterServerCallback("core:getOnDutyNames", function(source, token, job)
        if CheckPlayerToken(source, token) then
            if job ~= "aucun" then
                if inDuty[job] ~= nil then
                    if inDuty[job] ~= nil then
                        local names = {}
                        for k, v in pairs(inDuty[job]) do
                            local obj = GetPlayer(k)
                            if obj then
                                table.insert(names, obj:getLastname() .. " " .. obj:getFirstname())
                            end
                        end
                        return names
                    else
                        return false
                    end
                else
                    print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
                    return false
                end
            else
                return false
            end
        end
    end)
end)

RegisterCommand("checkjobcount", function(source, args, rawCommand)
    if source == 0 or HasPermission(source, 5) then
        if inDuty[args[1]] then
            print("inDuty[" .. args[1] .. "] = " .. #inDuty[args[1]])
        end
    end
end, false)

exports("getOnDuty", function(job)
    if job ~= "aucun" or job ~= nil then
        if inDuty[job] ~= nil then
            return inDuty[job]
        else
            print("^1[ERROR]: ^7the job " .. job .. " is invalid^7")
            return 0
        end
    else
        return 0
    end
end)

CreateThread(function()
    -- thread to check all the players in duty and if they are still connected
    while true do
        Wait(2 * 60000) -- 2 minutes
        for k, v in pairs(inDuty) do
            if inDuty[k] and next(inDuty[k]) then 
                local count = 0

                for x, y in pairs(inDuty[k]) do
                    if GetPlayer(x) == nil then
                        if inDuty[k][x] then
                            inDuty[k][x] = nil
                            -- if GlobalState['serviceCount_' .. k] and GlobalState['serviceCount_' .. k] > 0 then
                            --     print("playerDropped | thread", x, k)
                            --     GlobalState['serviceCount_' .. k] = (GlobalState['serviceCount_' .. k] or 1) - 1
                            -- end
                        end
                    else
                        count = count + 1
                    end
                end
                GlobalState['serviceCount_' .. k] = count
            else 
                GlobalState['serviceCount_' .. k] = 0
            end
        end
    end
end)

-- AddEventHandler('onResourceStart', function(resourceName)
--     if GetCurrentResourceName() == resourceName and isProduction then
--         PerformHttpRequest("http://141.94.99.95:3003/time/restart", function(err, text, headers) end, 'POST',
--             json.encode({ token = "54bbe11b-040c-4b98-b895-47ef16f46dc3" })
--             , { ['Content-Type'] = 'application/json' }
--         )
--         return
--     end
--     --sp_switchFrequence = {} 
--     --MySQL.Async.fetchAll("SELECT * FROM frequency", {}, function(result)
--     --    if result[1] ~= nil then
--     --        for k, v in pairs(result) do
--     --            sp_switchFrequence[v.job] = v.freq
--     --        end
--     --    end
--     --end)
-- end)


--RegisterServerCallback("radio:askfreq", function(source)
--    return sp_switchFrequence
--end)
