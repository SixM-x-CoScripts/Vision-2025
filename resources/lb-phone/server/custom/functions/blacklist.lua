local blacklistLookup = {}

if Config.WordBlacklist?.Enabled then
	for i = 1, #Config.WordBlacklist.Words do
		blacklistLookup[Config.WordBlacklist.Words[i]] = true
	end
end

---@param source number
---@param app string
---@param text string
---@return boolean
function ContainsBlacklistedWord(source, app, text)
	if not Config.WordBlacklist?.Enabled or not Config.WordBlacklist.Apps[app] or type(text) ~= "string" then
		return false
	end

	local blacklisted

	for word in text:lower():gmatch("%S+") do
		if blacklistLookup[word] then
			blacklisted = word
			break
		end
	end

	if blacklisted then
		infoprint("warning", ("Player %i (%s) tried to send a message containing a blacklisted word: %s"):format(source, GetPlayerName(source), blacklisted))
	end

	return blacklisted ~= nil
end

---@param source number
---@param text string
---@return boolean
exports("ContainsBlacklistedWord", function(source, text)
	return ContainsBlacklistedWord(source, "Other", text)
end)
