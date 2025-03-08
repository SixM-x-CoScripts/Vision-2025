local zoneAmmunation = {
	{
		position =
			vector3(16.340728759766, -1109.4506835938, 30.097199249268),
		blip =
			vector3(12.806353569031, -1102.8748779297, 30.097027587891),
	},
	{
		position = vector3(4.960292339325, -1105.6232910156, 29.797210693359),
		blip = vector3(4.960292339325, -1105.6232910156, 28.797210693359),
	},
}

local zoneAmmunationNord = {
	{
		position =
			vector3(1695.6677246094, 3757.0515136719, 35.00532989502),
		blip =
			vector3(1695.6677246094, 3757.0515136719, 35.00532989502),
	}
}

local token
TriggerEvent("core:RequestTokenAcces", "core", function(t)
	token = t
end)

local AmmuShop = {
	open = false,
	cam = nil,
}

local AllService = 0

DataSendAmmu = {
	catalogue = {},
	buttons = {
		{
			name = 'Pistolets',
			width = 'full',
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/Ammunation/pistol.svg',
			hoverStyle = 'fill-black stroke-black',
		},
		--{
		--    name = 'Armes automatiques',
		--    width = 'full',
		--    image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/Ammunation/mitraillette.svg',
		--    hoverStyle = 'fill-black stroke-black',
		--},
		{
			name = 'Armes lourdes',
			width = 'full',
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/Ammunation/fusil.svg',
			hoverStyle = 'fill-black stroke-black',
		},
		{
			name = 'Armes blanches',
			width = 'full',
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/Ammunation/armeblanche.svg',
			hoverStyle = 'fill-black stroke-black',
		},
		{
			name = 'Munitions',
			width = 'full',
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/Ammunation/explosif.svg',
			hoverStyle = 'fill-black stroke-black',
		},
		{
			name = 'Utilitaire',
			width = 'full',
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/cut.svg',
			hoverStyle = 'fill-black stroke-black',
		},
	},
	headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/market-cart.webp',
	headerIconName = 'Ammunation',
	headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/headers/header_ammu.webp',
	callbackName = 'Menu_ammu_achat_callback',
	showTurnAroundButtons = false
}

local Charset = {}
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
local function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function GenerateWeaponID()
	math.randomseed(GetGameTimer())
	return tostring(string.upper(GetRandomLetter(2)) .. math.random(1111, 4444))
end

RegisterNUICallback("Menu_ammu_achat_callback", function(data)
	if data.reset then -- Reset button (bannière)
		ClearPedTasks(PlayerPedId())
	end
	if data.itemname and data.price then
		--if p:pay(tonumber(data.prix)) then
		if p:getJob() == "ammunation" then
			TriggerSecurGiveEvent("core:addItemToInventory", token, data.itemname, 1, {
				id = GenerateWeaponID()
			})
			exports['vNotif']:createNotification({
				type = 'VERT',
				content = "Vous avez reçu un/une " .. data.label
			})
			TriggerServerEvent("core:ammunationtake", data.price, p:getJob(), data.label)
		else
			if data.category == "Armes blanches" then
				if p:pay(data.price) then
					TriggerSecurGiveEvent("core:addItemToInventory", token, data.itemname, 1, {})
					exports['vNotif']:createNotification({
						type = 'VERT',
						content = "Vous avez reçu un/une " .. data.label
					})
				else
					exports['vNotif']:createNotification({
						type = 'ROUGE',
						content = "~c Vous n'avez ~s pas assez d'argent"
					})
				end
			else
				exports['vNotif']:createNotification({
					type = 'ROUGE',
					content = "~c Vous ne pouvez pas acheter ce type d'arme"
				})
			end
		end
		--else
		--    exports['vNotif']:createNotification({
		--        type = 'ROUGE',
		--        content = "~c Vous n'avez ~s pas assez d'argent"
		--    })
		--end
	end
end)

local idweapon = ""
local InCam = false
local tonpew
local lastweaponspawned = nil
local function CreateWeaponObj(idweapon, coord)
    DeleteEntity(lastweaponspawned)
    local model2 = idweapon
    if model2 ~= "" then
        RequestModel(GetHashKey(model2))
        while not HasModelLoaded(GetHashKey(model2)) do
            Wait(1)
        end
        lastweaponspawned = CreateObject(GetHashKey(model2), coord, false, false, false)
        SetEntityHeading(lastweaponspawned, 110.2)
    end
end

RegisterNUICallback("focusOut", function()
	if AmmuShop.open then
		SetNuiFocusKeepInput(false)
		SetNuiFocus(false, false)
		AmmuShop.open = false
		if lastweaponspawned ~= nil then
			DeleteEntity(lastweaponspawned)
		end
		FreezeEntityPosition(PlayerPedId(), false)
		InCam = false
		SetCamActive(tonpew, false)
		RenderScriptCams(false, true, 500, true, true)
		DestroyCam(tonpew)
		tonpew = nil
	end
end)

local scaleform = nil
function InitializeWeapStat(scaleform, price, vehName, speed, acce, brake, trac, manufactu)
	scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
    print("manufactu", manufactu)
    if manufactu == "BENEFAC" then 
        manufactu = "Benefactor"
    end
	PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
	PushScaleformMovieFunctionParameterString(vehName)
	PushScaleformMovieFunctionParameterString(price)
	PushScaleformMovieFunctionParameterString("MPCarHUD")
	PushScaleformMovieFunctionParameterString(manufactu or "Benefactor")
	PushScaleformMovieFunctionParameterString("Vitesse")
	PushScaleformMovieFunctionParameterString("Acceleration")
	PushScaleformMovieFunctionParameterString("Freinage")
	PushScaleformMovieFunctionParameterString("Traction")
	PushScaleformMovieFunctionParameterInt(speed or 100)
	PushScaleformMovieFunctionParameterInt(acce or 100)
	PushScaleformMovieFunctionParameterInt(brake or 100)
	PushScaleformMovieFunctionParameterInt(trac or 100)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

RegisterNUICallback("Menu_Ammu_preview_callback", function(data)
	FreezeEntityPosition(PlayerPedId(), true)
	CreateWeaponObj(data.model,GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.0))
	--scaleform = nil
	if not InCam then
		InCam = true
		local pPed = PlayerPedId()
		local oCoords = GetOffsetFromEntityInWorldCoords(pPed, 0.0, 0.5, 0.0)
		local CoordToPoint = GetOffsetFromEntityInWorldCoords(pPed, 0.8, 0.0, 0.3)
		tonpew = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
		SetCamActive(tonpew, 1)
		SetCamCoord(tonpew, CoordToPoint)
		SetCamFov(tonpew, 75.0)
        RenderScriptCams(1, 1, 1000, 0, 0)
        PointCamAtEntity(tonpew, lastweaponspawned)
	end
	--if data.category == "Armes lourdes" or data.category == "Pistolets" then 
	--	scaleform = InitializeWeapStat("mp_car_stats_01", (data.price or "Gratuit lol") .. "$", data.label, 0.0, 0.0, 0.0, 0.0, 0.0)
	--end
end)

local allweapons = {
	{ name = "Batte de baseball",    prix = 1015,  category = "Armes blanches", imagename = "Batte_de_baseball",       imagepath = "Armes_blanches", weapname = "weapon_bat", model = "w_me_bat"},
	--   {name = "Bouteille cassée", category = "Armes blanches", imagename = "Bouteille_cassee", imagepath = "Armes_blanches", weapname = "weapon_bottle"},
	{ name = "Clé anglaise",         prix = 945,   category = "Armes blanches", imagename = "Cle_anglaise",            imagepath = "Armes_blanches", weapname = "weapon_wrench", model = "v_ind_cs_wrench"},
	{ name = "Club de golf",         prix = 1015,  category = "Armes blanches", imagename = "Club_de_golf",            imagepath = "Armes_blanches", weapname = "weapon_golfclub", model = "w_me_gclub"},
	{ name = "Couteau",              prix = 1225,  category = "Armes blanches", imagename = "Couteau",                 imagepath = "Armes_blanches", weapname = "weapon_knife", model = "prop_w_me_knife_01"},
	{ name = "Pied de biche",        prix = 1015,  category = "Armes blanches", imagename = "Pied_de_biche",           imagepath = "Armes_blanches", weapname = "weapon_crowbar", model = "w_me_crowbar"},
	{ name = "Pelle",                prix = 945,   category = "Armes blanches", imagename = "Pelle",                   imagepath = "Armes_blanches", weapname = "weapon_pelle", model = "prop_tool_shovel006"},
	{ name = "Pioche",               prix = 945,   category = "Armes blanches", imagename = "Pioche",                  imagepath = "Armes_blanches", weapname = "weapon_pickaxe", model = "prop_tool_pickaxe"},
	{ name = "Poing americain",      prix = 2450,  category = "Armes blanches", imagename = "Poing_americain",         imagepath = "Armes_blanches", weapname = "weapon_knuckle", model = "w_me_knuckle_dmd"},
	-- {name = "Canette", category = "Armes blanches", imagename = "Canette", imagepath = "Armes_blanches", weapname = "weapon_canette"},
	--    {name = "Bouteille", category = "Armes blanches", imagename = "Bouteille", imagepath = "Armes_blanches", weapname = "weapon_bouteille"},
	{ name = "Queue de billard",     prix = 1015,  category = "Armes blanches", imagename = "Queue_de_billard",        imagepath = "Armes_blanches", weapname = "weapon_poolcue", model = "w_me_poolcue"},


	{ name = "Colt M4A1",            prix = 35000, category = "Armes lourdes",  imagename = "Carabine",                imagepath = "Armes_lourdes",  weapname = "weapon_carbinerifle", model = "w_ar_carbinerifle"},
	{ name = "H&K G36C",             prix = 42000, category = "Armes lourdes",  imagename = "Carabine_speciale",       imagepath = "Armes_lourdes",  weapname = "weapon_specialcarbine", model = "w_ar_specialcarbine"},
	{ name = "Remington 870E",       prix = 21000, category = "Armes lourdes",  imagename = "Fusil_a_pompe",           imagepath = "Armes_lourdes",  weapname = "weapon_pumpshotgun", model = "w_sg_pumpshotgunh4"},
	{ name = "H&K MP5A5",            prix = 28000, category = "Armes lourdes",  imagename = "Mitraillette",            imagepath = "Armes_lourdes",  weapname = "weapon_smg", model = "w_sb_smg"},
	{ name = "Mousquet",             prix = 8750,  category = "Armes lourdes",  imagename = "Mousquet",                imagepath = "Armes_lourdes",  weapname = "weapon_musket", model = "w_ar_musket"},


	{ name = "Beanbag",              prix = 3500,  category = "Utilitaire",     imagename = "Beanbag",                 imagepath = "Autres",         weapname = "weapon_beambag", model = "w_ar_musket"},
	{ name = "Pistol Magazine Box",  prix = 385,   category = "Munitions",      imagename = "ammobox_pistol",          imagepath = "Autres",         weapname = "ammobox_pistol", model = "v_ret_gc_ammo5"},
	{ name = "Sub Magazine Box",     prix = 560,   category = "Munitions",      imagename = "ammobox_sub",             imagepath = "Autres",         weapname = "ammobox_sub", model = "v_ret_gc_ammo5"},
	{ name = "Shotgun Magazine Box", prix = 700,   category = "Munitions",      imagename = "ammobox_shotgun",         imagepath = "Autres",         weapname = "ammobox_shotgun", model = "v_ret_gc_ammo5"},
	{ name = "Rifle Magazine Box",   prix = 770,   category = "Munitions",      imagename = "ammobox_rifle",           imagepath = "Autres",         weapname = "ammobox_rifle", model = "v_ret_gc_ammo5"},
	{ name = "Sniper Magazine Box",  prix = 875,   category = "Munitions",      imagename = "ammobox_snip",            imagepath = "Autres",         weapname = "ammobox_snip", model = "v_ret_gc_ammo5"},
	{ name = "Mousquet Ammo Box",    prix = 475,   category = "Munitions",      imagename = "ammobox_musquet",         imagepath = "Autres",         weapname = "ammobox_musquet", model = "v_ret_gc_ammo5"},
	{ name = "Heavy Magazine Box",   prix = 875,   category = "Munitions",      imagename = "ammobox_heavy",           imagepath = "Autres",         weapname = "ammobox_heavy", model = "v_ret_gc_ammo5"},
	{ name = "Beambag Magazine Box", prix = 665,   category = "Munitions",      imagename = "ammobox_beambag",         imagepath = "Autres",         weapname = "ammobox_beambag", model = "v_ret_gc_ammo5"},
	{ name = "Flaregun Ammo Box",    prix = 505,   category = "Munitions",      imagename = "ammobox_flare",           imagepath = "Autres",         weapname = "ammobox_flare", model = "v_ret_gc_ammo5"},

	{ name = "Poignée d'arme",       prix = 3150,  category = "Utilitaire",     imagename = "components_grip",         imagepath = "Autres",         weapname = "components_grip", model = "w_at_afgrip_2"},
	{ name = "Silencieux",           prix = 10500, category = "Utilitaire",     imagename = "components_suppressor",   imagepath = "Autres",         weapname = "components_suppressor", model = "w_me_flashlight"},
	{ name = "Lampe torche",         prix = 4550,  category = "Utilitaire",     imagename = "components_flashlight",   imagepath = "Autres",         weapname = "components_flashlight", model = "w_me_flashlight_flash"},

	{ name = "Fusée de détresse",    prix = 504,   category = "Utilitaire",     imagename = "weapon_flare",            imagepath = "Autres",         weapname = "weapon_flare", model = "w_pi_flaregun_shell"},

	{ name = "Coil X26P",            prix = 700,   category = "Utilitaire",     imagename = "Tazer",                   imagepath = "Autres",         weapname = "weapon_stungun_mp", model = "w_pi_stungun"},
	-- {name = "Gas lacrymogène", prix=700, category = "Utilitaire", imagename = "weapon_bzgas", imagepath = "Autres", weapname = "weapon_bzgas"},
	{ name = "Extincteur",           prix = 5250,  category = "Utilitaire",     imagename = "weapon_fireextinguisher", imagepath = "Autres",         weapname = "weapon_fireextinguisher", model = "prop_fire_exting_1a"},
	{ name = "Lampe",                prix = 700,   category = "Utilitaire",     imagename = "weapon_flashlight",       imagepath = "Autres",         weapname = "weapon_flashlight", model = "w_me_flashlight"},
	-- {name = "Grenade fumigène", prix=700, category = "Utilitaire", imagename = "weapon_smokelspd", imagepath = "Autres", weapname = "weapon_smokelspd"},
	{ name = "Matraque",             prix = 700,   category = "Utilitaire",     imagename = "Matraque",                imagepath = "Autres",         weapname = "weapon_nightstick", model = "w_me_nightstick"},
	{ name = "Pistolet de détresse", prix = 4550,  category = "Utilitaire",     imagename = "pistolet_de_detresse",    imagepath = "Autres",         weapname = "weapon_flaregun", model = "w_pi_flaregun"},
	{ name = "Herse",                prix = 700,   category = "Utilitaire",     imagename = "herse",                   imagepath = "Autres",         weapname = "herse", model = "p_ld_stinger_s"},
	{ name = "Marteau",              prix = 1015,  category = "Utilitaire",     imagename = "marteau",                 imagepath = "Autres",         weapname = "weapon_hammer", model = "prop_tool_hammer"},


	{ name = "Colt M45A1",           prix = 23975, category = "Pistolets",      imagename = "colt_911",                imagepath = "Pistolet",       weapname = "weapon_heavypistol", model = "w_pi_heavypistol_luxe"},
	{ name = "H&K P7M10",            prix = 11900, category = "Pistolets",      imagename = "Petoire",                 imagepath = "Pistolet",       weapname = "weapon_snspistol", model = "w_pi_sns_pistol_luxe"},
	{ name = "Beretta 92FS",         prix = 3500,  category = "Pistolets",      imagename = "Pistolet",                imagepath = "Pistolet",       weapname = "weapon_pistol", model = "w_pi_pistol"},
	{ name = "Glock 17",             prix = 2450,  category = "Pistolets",      imagename = "Pistolet_de_combat",      imagepath = "Pistolet",       weapname = "weapon_combatpistol", model = "w_pi_combatpistol"},
	{ name = "Taurus Raging bull",   prix = 29155, category = "Pistolets",      imagename = "Revolver",                imagepath = "Pistolet",       weapname = "weapon_revolver", model = "w_pi_revolver_g"},
	{ name = "FN Model 1922",        prix = 14105, category = "Pistolets",      imagename = "Vintage_Pistol",          imagepath = "Pistolet",       weapname = "weapon_vintagepistol", model = "w_pi_vintage_pistol"},
}

function OpenAmmunationUI()
	-- DataSendAmmu.catalogue = ammunation["weapons"].nibard
	DataSendAmmu.catalogue = {}
	if p:getJob() == "ammunation" then
		for k, v in pairs(allweapons) do
			table.insert(DataSendAmmu.catalogue,
				{
					id = k,
					image = "https://cdn.sacul.cloud/v2/vision-cdn/Ammunation/" ..
						v.imagepath .. "/" .. v.imagename .. ".webp",
					category = v.category,
					price = v.prix,
					model = v.model,
					itemname = v.weapname,
					label = v.name,
					ownCallbackName = 'Menu_Ammu_preview_callback'
				})
		end
		DataSendAmmu.disableSubmit = false
	else
		for k, v in pairs(allweapons) do
			table.insert(DataSendAmmu.catalogue,
				{
					id = k,
					image = "https://cdn.sacul.cloud/v2/vision-cdn/Ammunation/" ..
						v.imagepath .. "/" .. v.imagename .. ".webp",
					category = v.category,
					price = AllService and AllService > 0 and math.floor(v.prix * 1.15) or math.floor(v.prix * 1.35),
					itemname = v.weapname,
					model = v.model,
					label = v.name,
					ownCallbackName = 'Menu_Ammu_preview_callback'
				})
		end
		--if TriggerServerCallback("core:getNumberOfDuty", token, 'ammunation') > 0 then
		if (GlobalState['serviceCount_ammunation'] or 0) > 0 then
			DataSendAmmu.disableSubmit = true
		else
			DataSendAmmu.disableSubmit = false
		end
	end

	SendNuiMessage(json.encode({
		type = 'closeWebview',
	}))
	Wait(50)
	AmmuShop.open = true
	CreateThread(function()
		while AmmuShop.open do
			Wait(1)
			if lastweaponspawned then
				heading = GetEntityHeading(lastweaponspawned)
				SetEntityHeading(lastweaponspawned, heading )
			end
			if (scaleform ~= nil) then
				local x = 0.48
				local y = -0.12
				local width = 0.85
				local height = width / 1.0
				DrawScaleformMovie(scaleform, x, y, width, height)
			end
		end
	end)
	SendNUIMessage({
		type = "openWebview",
		name = "MenuGrosCatalogue",
		data = DataSendAmmu
	})
	forceHideRadar()
	SetNuiFocusKeepInput(true)
	CreateThread(function()
		local disablekeys = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 23, 24, 25, 26, 32, 33, 34, 35, 37, 44, 45, 61, 268, 270, 269, 266, 281, 280, 278, 279, 71, 72, 73, 74, 77, 87, 232, 62, 63, 69, 70, 140, 141, 142, 257, 263, 264 }
		while AmmuShop.open do
			Wait(1)
			for k, v in pairs(disablekeys) do
				DisableControlAction(0, v, true)
			end
			DisableControlAction(0, 1, true)
			DisableControlAction(0, 2, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 18, true)
			DisableControlAction(0, 322, true)
			DisableControlAction(0, 106, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 245, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 38, true)
			DisableControlAction(0, 44, true)
			if IsDisabledControlPressed(0, 38) then
				if lastweaponspawned then 
					SetEntityHeading(lastweaponspawned, GetEntityHeading(lastweaponspawned) + 0.8)
				end
			elseif IsDisabledControlPressed(0, 44) then
				if lastweaponspawned then 
					SetEntityHeading(lastweaponspawned, GetEntityHeading(lastweaponspawned) - 0.8)
				end
			end
		end
	end)
end

for k, v in pairs(zoneAmmunation) do
	CreateThread(function()
		while zone == nil do Wait(1) end

		zone.addZone(
			"Armureriesud" .. k,                          -- Nom
			v.position,                                   -- Position
			"Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie", -- Text afficher
			function()                                    -- Action qui seras fait
				if not AmmuShop.open then
					OpenAmmunationUI()                    -- Ouvrir le menu
				end
			end,
			false,  -- Avoir un marker ou non
			29,     -- Id / type du marker
			0.4,    -- La taille
			{ 50, 168, 82 }, -- RGB
			170,    -- Alpha
			2.0,
			true,
			"bulleArmes",
			true -- Hide bulle on focus ?
		)
		--AddBlip(v.blip,110,2,0.4, 5,'Armurie')
	end)
end

for k, v in pairs(zoneAmmunationNord) do
	CreateThread(function()
		while zone == nil do Wait(1) end

		zone.addZone(
			"Armurerienord" .. k,                         -- Nom
			v.position,                                   -- Position
			"Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'armurerie", -- Text afficher
			function()                                    -- Action qui seras fait
				if not AmmuShop.open then
					OpenAmmunationUI()                    -- Ouvrir le menu
				end
			end,
			false,  -- Avoir un marker ou non
			29,     -- Id / type du marker
			0.4,    -- La taille
			{ 50, 168, 82 }, -- RGB
			170,    -- Alpha
			2.0,
			true,
			"bulleArmes"
		)
		--AddBlip(v.blip,110,2,0.4, 5,'Armurie')
	end)
end

local pedAmmu = nil
CreateThread(function()
	while true do
		--AllService = TriggerServerCallback("core:getNumberOfDuty", token, 'ammunation')
		AllService = GlobalState['serviceCount_ammunation'] or 0
		if not AllService or AllService <= 0 then
			if not DoesEntityExist(pedAmmu) then
				local ped = entity:CreatePedLocal("s_m_y_ammucity_01",
					vector3(17.430704116821, -1107.1956787109, 28.797210693359), 159.71087646484)
				ped:setFreeze(true)
				SetEntityInvincible(ped.id, true)
				SetEntityAsMissionEntity(ped.id, 0, 0)
				SetBlockingOfNonTemporaryEvents(ped.id, true)
				pedAmmu = ped.id
			end
		else
			DeleteEntity(pedAmmu)
			pedAmmu = nil
		end
		Wait(30000)
	end
end)
