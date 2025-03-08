Config = Config or { }

--- Used to encrypt the discord identifier in the token
--- @type string
Config.SecretKey = '6f46b571-9b60-4fae-abcd-d96292a4047a'

--- Print debug messages
--- @type integer
---   0 : No debug
---   1 : Debug
---   2 : Debug + API calls
Config.DebugLevel = 0

Config.IsAllowed = function(source, callback)
	local allowedJobs = { 'lspd', 'lssd', 'ems', 'lsfd', 'usss', 'justice', 'avocat', 'avocat2', 'avocat3' }

	local player = exports['core']:GetPlayerTarget(source)

	for _, job in ipairs(allowedJobs) do
		if player.job == job then
			return callback(true)
		end
	end

	return callback(false)
end

--- This function is called SERVER SIDE if the user is not allowed to access the MDT via the Config.IsAllowed function
--- @param source number
--- @return nil
Config.UserIsNotAllowed = function(source)
  	TriggerClientEvent("__atoshi::createNotification", source, {
		type = 'JAUNE',
		content = "Seul les services de secours peuvent accéder au MDT.",
	})
end