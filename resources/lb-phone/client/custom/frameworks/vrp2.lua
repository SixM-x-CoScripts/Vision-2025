---@diagnostic disable: deprecated

local name = "lbphone" .. 1

if GetCurrentResourceName() == "vrp" then
	print("loaded in vrp")
	---@diagnostic disable: undefined-global
	local lbphone = class(name, vRP.Extension)

	lbphone.user = class("User")
	lbphone.proxy = {}
	lbphone.event = {}
	lbphone.tunnel = {}

	local hasSpawned = false

	local function firstSpawn()
		hasSpawned = true

		TriggerEvent("lb-phone:vrp:firstSpawn")
	end

	function lbphone.event:playerSpawn()
		if hasSpawned then
			return
		end

		firstSpawn()
	end

	function lbphone.tunnel:setCharacterId(id)
		print("got character id:", id)
	end

	if vRP.EXT.Base.cid then
		firstSpawn()
	end

	function lbphone.proxy:spawnVehicle(vehicleData, coords)
		local model = vehicleData.model

		RequestModel(model)

		while not HasModelLoaded(model) do
			Wait(0)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, 0.0, true, false)

		SetVehicleOnGroundProperly(vehicle)
		SetModelAsNoLongerNeeded(model)

		return vehicle
	end

	function lbphone.proxy:applyVehicleMods(vehicle, vehicleData)
		vRP.EXT.Garage:setVehicleState(vehicle, vehicleData)
	end

	vRP:registerExtension(lbphone)

	return
end

Wait(500)

if Config.Framework ~= "vrp" then
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

RegisterNetEvent("lb-phone:vrp:firstSpawn", function()
	loaded = true
end)

vRP.loadScript(GetCurrentResourceName(), "client/custom/frameworks/vrp2")

local lbphone = proxy.getInterface("vRP.EXT." .. name)

-- TODO: check if has phone item

---@param number? string
---@return boolean
function HasPhoneItem(number)
	print("HAS PHONE ITEM??", number)

	return true
end

---Apply vehicle mods
---@param vehicle number
---@param vehicleData table
function ApplyVehicleMods(vehicle, vehicleData)
	lbphone.applyVehicleMods(vehicle, vehicleData)
end

---Create a vehicle and apply vehicle mods
---@param vehicleData table
---@param coords vector3
---@return number? vehicle
function CreateFrameworkVehicle(vehicleData, coords)
	local vehicle = lbphone.spawnVehicle(vehicleData, coords)

	ApplyVehicleMods(vehicle, vehicleData)

    return vehicle
end
