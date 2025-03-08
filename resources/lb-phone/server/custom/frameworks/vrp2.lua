if GetCurrentResourceName() == "vrp" then
	---@diagnostic disable: undefined-global
	local lbphone = class("lbphone", vRP.Extension)

	function lbphone:__construct()
		vRP.Extension.__construct(self)
	end

	lbphone.event = {}
	lbphone.tunnel = {}
	lbphone.proxy = {}

	function lbphone.proxy:getIdentifier(source)
		local user = vRP.users_by_source[source]

		if user and user.cid then
			return "vrp_" .. user.cid
		end
	end

	function lbphone.proxy:getCharacterName(source)
		local user = vRP.users_by_source[source]
		local identity = user and user.cid and vRP.EXT.Identity:getIdentity(user.cid)

		if identity then
			return identity.firstname, identity.name
		else
			return GetPlayerName(source), ""
		end
	end

	function lbphone.proxy:hasItem(source, item)
		local user = vRP.users_by_source[source]

		if user then
			return user:tryTakeItem(item, 1, true, true)
		else
			return false
		end
	end

	function lbphone.proxy:getBank(source)
		local user = vRP.users_by_source[source]

		if user then
			return user:getBank()
		end
	end

	function lbphone.proxy:giveBank(source, amount)
		local user = vRP.users_by_source[source]

		if user and amount > 0 then
			user:giveBank(amount)

			return true
		end

		return false
	end

	function lbphone.proxy:removeBank(source, amount)
		local user = vRP.users_by_source[source]
		local bank = user and user:getBank()

		if user and bank and amount > 0 and bank >= amount then

			user:setBank(math.abs(bank - amount))
			return true
		end

		return false
	end

	function lbphone.proxy:isAdmin(source)
		local user = vRP.users_by_source[source]

		return user and user:hasGroup("admin")
	end

	function lbphone.proxy:getJob(source)
		local user = vRP.users_by_source[source]

		return user and user:getGroupByType("job") or "citizen"
	end

	function lbphone.proxy:registerItem(item, name, description)
		vRP.EXT.Inventory:defineItem(item, name, description, nil, 0.2)
	end

	function lbphone.event:playerSpawn(user, firstSpawn)
		print("PLAYER SPAWNED!", user, firstSpawn)
	end

	function lbphone.event:characterLoad(user)
		print("character load", user)
	end

	function lbphone.event:characterUnload(user)
		print("character unload", user)
	end

	function lbphone.proxy:getPlayerVehicles(source)
		local user = vRP.users_by_source[source]

		if not user then
			return {}
		end

		---@type { [string]: number }[]
		local vehicles = user:getVehicles()
		local toSend = {}

		for model, stored in pairs(vehicles) do
			local vehicleState = user:getVehicleState(model)

			if not vehicleState then
				vehicleState = {
					customization = {},
					condition = {}
				}
			end

			toSend[#toSend+1] = {
				-- plate = vehicleState.customization.plate_txt or model,
				plate = model,
				type = "car",
				model = model,
				location = stored == 1 and "Garage" or "out",
				statistics = {
					engine = vehicleState.condition.engine_health or 1000.0,
					body = vehicleState.condition.body_health or 1000.0
				}
			}
		end

		return toSend
	end

	function lbphone.proxy:getVehicle(source, model)
		local user = vRP.users_by_source[source]

		if not user then
			return
		end

		local vehicle = user:getVehicleState(model)

		if not vehicle then
			return
		end

		vehicle.plate = model
		vehicle.model = GetHashKey(model)
		vehicle.type = "car"

		return vehicle
	end

	function lbphone.proxy:getEmployees(job)
		local users = vRP.users_by_source
		local employees = {}

		for src, user in pairs(users) do
			if user and user:getGroupByType("job") == job then
				employees[#employees+1] = src
			end
		end

		return employees
	end

	vRP:registerExtension(lbphone)

	print("^6[LB Phone]: ^2[INFO]^7: Loaded LB Phone vRP extension.")

	return
end

---@diagnostic disable: deprecated
if Config.Framework ~= "vrp2" then
	return
end

local utils = LoadResourceFile("vrp", "lib/utils.lua")

if not utils then
	print("^6[LB Phone] ^1[ERROR]^7: Failed to load vrp (could not find vrp/lib/utils.lua)")
	return
end

load(utils)()

local proxy = module("vrp", "lib/Proxy")
local tunnel = module("vrp", "lib/Tunnel")

if not proxy or not tunnel then
	print("^6[LB Phone] ^1[ERROR]^7: Failed to load vrp (could not load proxy/tunnel module)")
	return
end

local vRP = proxy.getInterface("vRP")

vRP.loadScript(GetCurrentResourceName(), "server/custom/frameworks/vrp2")

local lbphone = proxy.getInterface("vRP.EXT.lbphone")

lbphone.registerItem(Config.Item.Name, "Phone", "A phone")

---@param source number
---@return string | nil
function GetIdentifier(source)
	return lbphone.getIdentifier(source)
end

---@param source number
---@return string firstname
---@return string lastname
function GetCharacterName(source)
	return lbphone.getCharacterName(source)
end

---@param source number
---@param number string
---@return boolean
function HasPhoneItem(source, number)
	if not Config.Item.Require then
        return true
    end

	if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search(source, "count", Config.Item.Name) or 0) > 0
	end

	local hasItem = lbphone.hasItem(source, Config.Item.Name)

	if not hasItem then
		return false
	end

	return MySQL.Sync.fetchScalar("SELECT 1 FROM phone_phones WHERE id=@id AND phone_number=@number", {
        ["@id"] = GetIdentifier(source),
        ["@number"] = number
    }) ~= nil
end

---@param source number
---@return integer
function GetBalance(source)
	return lbphone.getBank(source)
end

---@param source number
---@param amount integer
---@return boolean # Success
function AddMoney(source, amount)
	return lbphone.giveBank(source, amount)
end

---@param source number
---@param amount integer
---@return boolean # Success
function RemoveMoney(source, amount)
	return lbphone.removeBank(source, amount)
end

---@param source number
---@return boolean
function IsAdmin(source)
	return lbphone.isAdmin(source)
end

---@param source number
---@return string
function GetJob(source)
	return lbphone.getJob(source)
end

---Get an array of player sources with a specific job
---@param job string
---@return number[] employees
function GetEmployees(job)
	return lbphone.getEmployees(job)
end

function RefreshCompanies()
	for i = 1, #Config.Companies.Services do
		local jobData = Config.Companies.Services[i]

		jobData.open = #lbphone.getEmployees(jobData.job) > 0
	end
end

function GetPlayerVehicles(source)
	return lbphone.getPlayerVehicles(source)
end

function GetVehicle(source, model)
	return lbphone.getVehicle(source, model)
end
