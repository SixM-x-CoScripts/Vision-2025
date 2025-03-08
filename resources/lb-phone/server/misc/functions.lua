local logTypes = {
    error = 16739179,
    warning = 16766566,
    success = 6750115,
    info = 6928383
}

local cachedUsers = {}

---@param id string
---@return { username: string, avatar: string } | nil
local function getForumUserFromId(id)
	if cachedUsers[id] then
		return cachedUsers[id]
	end

	local getPromise = promise.new()

	PerformHttpRequest("https://policy-live.fivem.net/api/getUserInfo/" .. id, function(statusCode, response, headers)
		if statusCode ~= 200 then
			getPromise:resolve()
		end

		local responseData = json.decode(response)

		getPromise:resolve({
			username = responseData.username,
			avatar = "https://forum.cfx.re/" .. responseData.avatar_template:gsub("{size}", "512")
		})
	end, "GET", "", {["Content-Type"] = "application/json"})

	local user = Citizen.Await(getPromise)

	if user then
		cachedUsers[id] = user
	end

	return user
end

---@param app string
---@param source number
---@param type string
---@param title string
---@param message string
---@param avatar? string
---@param image? string
local function log(app, source, type, title, message, avatar, image)
    local discordWebhook = LOGS[app]
	local cleanedUpIdentifiers = {}
	local accounts = {}
	local identifiers = GetPlayerIdentifiers(source) or {}
	local name = GetPlayerName(source) or ""
	local description = message
	local accountsCount = 0

	for i = 1, #identifiers do
		local identifierTypeIndex = identifiers[i]:find(":")

		if not identifierTypeIndex then
			goto continue
		end

		local identifierType = identifiers[i]:sub(1, identifierTypeIndex - 1)
		local identifier = identifiers[i]:sub(identifierTypeIndex + 1)

		if identifierType == "steam" then
			accountsCount += 1
			accounts[accountsCount] = "- Steam: https://steamcommunity.com/profiles/" .. tonumber(identifier, 16)
		elseif identifierType == "fivem" then
			local user = getForumUserFromId(identifier)

			if user then
                avatar = avatar or user.avatar
				accountsCount += 1
				accounts[accountsCount] = "- Forum account: [" .. user.username .. "](https://forum.cfx.re/u/" .. user.username .. ")"
			end
		elseif identifierType == "discord" then
			accountsCount += 1
			accounts[accountsCount] = "- Discord: <@" .. identifier .. ">"
		end

		if identifierType ~= "ip" then
			cleanedUpIdentifiers[identifierType] = identifier
		end

		::continue::
	end

	if accountsCount > 0 then
		description = description .. "\n\n**Accounts:**\n"
		for i = 1, accountsCount do
			description = description .. accounts[i] .. "\n"
		end
	end

	description = description .. "**Identifiers:**"

	for identifierType in pairs(cleanedUpIdentifiers) do
		description = description .. "\n- **" .. identifierType .. ":** " .. cleanedUpIdentifiers[identifierType]
	end

	local embed = {
		title = title,
		description = description,
		color = logTypes[type] or 15633643,
		timestamp = GetTimestampISO(),
		author = {
			name = name .. " | " .. source,
			icon_url = avatar or "https://winaero.com/blog/wp-content/uploads/2018/08/Windows-10-user-icon-big.png"
		},
        image = image and {
            url = image
        },
		footer = {
			text = "LB Phone",
			icon_url = "https://docs.lbscripts.com/images/icons/icon.png"
		}
	}

	PerformHttpRequest(discordWebhook, function() end, "POST", json.encode({
		username = app,
		avatar_url = "https://docs.lbscripts.com/images/icons/icon.png",
		embeds = {
            embed
        }
	}), {
		["Content-Type"] = "application/json"
	})
end

---@param app string
---@param source number
---@param type string
---@param title string
---@param message string
---@param avatar? string
---@param image? string
function Log(app, source, type, title, message, avatar, image)
    local webhook = LOGS[app]

    if not webhook or not source then
        return
    end

    if webhook:sub(-14) == "/api/webhooks/" then
        debugprint("Webhook not set for " .. app)
        return
    end

    CreateThread(function()
        log(app, source, type, title, message, avatar, image)
    end)
end

function GetTimestampISO()
    ---@diagnostic disable-next-line: param-type-mismatch
    local currentTime = os.time(os.date("!*t")) -- Get the current time in UTC

    return os.date("%Y-%m-%dT%H:%M:%S.000Z", currentTime)
end

local anyExternalAllowed = false

for _, v in pairs(Config.AllowExternal) do
    if v then
        anyExternalAllowed = true
    end
end

function IsMediaLinkAllowed(link)
    if not Config.UploadWhitelistedDomains or #Config.UploadWhitelistedDomains == 0 then
        return true
	elseif anyExternalAllowed and #Config.ExternalWhitelistedDomains == 0 and #Config.ExternalBlacklistedDomains == 0 then
        return true
    end

    local domain = link:match("[%w%.]*%.(%w+%.%w+)")

    if not anyExternalAllowed then
        return contains(Config.UploadWhitelistedDomains, domain)
	elseif #Config.ExternalBlacklistedDomains > 0 and contains(Config.ExternalBlacklistedDomains, domain) then
        return false
    elseif #Config.ExternalWhitelistedDomains > 0 and not contains(Config.ExternalWhitelistedDomains, domain) then
        return false
    end

    return true
end

AddEventHandler("playerDropped", function()
    local src = source
    local fivemId = GetPlayerIdentifierByType(src --[[@as string]], "fivem")

    if not fivemId then
        return
    end

    fivemId = fivemId:sub(7)

    if cachedUsers[fivemId] then
        cachedUsers[fivemId] = nil
        debugprint(src, "disconnected, removed cached forum account", fivemId)
    end
end)
