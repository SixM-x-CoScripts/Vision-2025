RegisterServerEvent("Vision::AutoRestart:checkTime")
AddEventHandler('Vision::AutoRestart:checkTime', function()
	-- Get system time
	checkTime = os.date('%H:%M:%S', os.time())
	local serverTime = checkTime

	-- 6am warnings
	if serverTime == '07:45:00' then
        TriggerClientEvent("__atoshi::createNotification", -1, {
            type  = 'ABSOLUTE',
            name  = "ABSOLUTE",
            content = "Le serveur va redémarrer dans 15 minutes.",
            typeannonce = "ADMINISTRATION",
            labeltype = "ANNONCE",
            duration = 10,
        })
	elseif serverTime == '07:50:00' then
		TriggerClientEvent("__atoshi::createNotification", -1, {
            type  = 'ABSOLUTE',
            name  = "ABSOLUTE",
            content = "Le serveur va redémarrer dans 10 minutes.",
            typeannonce = "ADMINISTRATION",
            labeltype = "ANNONCE",
            duration = 10,
        })
	elseif serverTime == '07:55:00' then
		TriggerClientEvent("__atoshi::createNotification", -1, {
            type  = 'ABSOLUTE',
            name  = "ABSOLUTE",
            content = "Le serveur va redémarrer dans 5 minutes.",
            typeannonce = "ADMINISTRATION",
            labeltype = "ANNONCE",
            duration = 10,
        })
	elseif serverTime == '07:59:00' then
		TriggerClientEvent("__atoshi::createNotification", -1, {
            type  = 'ABSOLUTE',
            name  = "ABSOLUTE",
            content = "Redémarrage du serveur imminent, 45 secondes restante.",
            typeannonce = "ADMINISTRATION",
            labeltype = "ANNONCE",
            duration = 10,
        })

        Wait(1000*45)

        local players = GetPlayers()

        local count = 0

        for k,v in pairs(players) do
            DropPlayer(v, "🌙 Redémarrage du serveur en cours...\nMerci de patienter que l'annonce soit faite.")
            count = count + 1
        end

        LogsMoiCaConnard(true, count)
    end
end)

local timercount = 1000


local function restart_server()

    print("Démarrage du système d'auto restart")

	SetTimeout(timercount, function()

        checkTime = os.date('%H', os.time())
        local serverTime = checkTime

        --[[ print("Il est".. serverTime .. "Et je check toutes les :".. timercount) ]]

        if serverTime == '07' or serverTime == '08' then
            timercount = 1000
            --[[ print("Il est".. serverTime .. "Et je check toutes les :".. timercount) ]]
            TriggerEvent('Vision::AutoRestart:checkTime')
            restart_server()
        else 
            timercount = 60000
            --[[ print("Il est".. serverTime .. "Et je check toutes les :".. timercount) ]]
        end

	end)
end

local function LogsMoiCaConnard(isStop, number)
    local embed

    if isStop then
        embed = {
            {
                ["type"]="rich",
                ["color"] = 16023551,
                ["description"] = "<:adsys_startagain:945669399921193020> Redémarrage du serveur **Free Access** en cours...\n - `".. number .."` joueurs étaient connecté sur le serveur.",
                ["footer"]=  {
                    ["text"] = "Absolute FA - "..os.date("%x %X  %p"),
                },
            }
        }
    else
        embed = {
            {
                ["type"]="rich",
                ["color"] = 15750074,
                ["description"] = "<:checkmark:891340495194828820> Le serveur **Free Access** a bien été redémarré correctement...",
                ["footer"]=  {
                    ["text"] = "Absolute FA - "..os.date("%x %X  %p"),
                },
            }
        }
    end
    PerformHttpRequest("https://discord.com/api/webhooks/1186015267696934952/nv1dEisJheTBoRi3bBy2CUam2P6CoIHEbbJ82WiYiumcVby-n-FxpZSBrj41SMwqGdql", function(err, text, headers) end, 'POST', json.encode({ username = "ABSOLUTE", content = "<@297077339135803392>" ,embeds = embed}), { ['Content-Type'] = 'application/json' })
end

--restart_server()


AddEventHandler('onResourceStart', function(resourceName)

    checkTime = os.date('%H', os.time())

    local serverTime = checkTime

    if serverTime == '07' or serverTime == '08' then
        if resourceName == GetCurrentResourceName() then
            LogsMoiCaConnard(false)
        end
    end
end)
