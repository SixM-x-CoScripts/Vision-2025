local token = nil
canOpenDeco = false
local loaded = false
propertyIdDeco = 0
local BlockCamera = false
local InsideDeco = false
local speedMultiplier = 0.25
local decorationPropsPlaced = {}
local InsideFocus = false

-- exports 
DecoModule = exports.deco:DecoModule()

Editor = {
	AllObjects = {},
	Started = false,
    LastObject = nil,
	Cam = nil,
}

local decorationsProps = {
	['Consommables'] = { "ng_proc_food_bag01a", "ng_proc_food_burg01a", "ng_proc_sodacup_01a", "prop_amb_beer_bottle", "prop_bar_fruit", "prop_bar_shots", 
	"prop_beer_bottle", "prop_bikerset", "prop_champset", "prop_cocktail", "prop_drink_whisky", "prop_mug_04", "prop_whiskey_glasses", "prop_wine_rose", 
	"v_res_tt_pizzaplate", "v_ret_247_noodle2", "v_ret_247_popbot4", "v_ret_fh_pizza02", "v_ret_ml_beeram", "v_ret_ml_chips4", "ng_proc_coffee_01a",
	-- no photo
	"prop_food_bs_coffee", "prop_food_bs_chips", "prop_food_bs_cups01", "prop_food_bs_juice03", "prop_food_bs_tray_02", "prop_food_bs_tray_03", "prop_food_cb_bag_02", 
	"prop_food_cb_burg02", "prop_food_ketchup", "prop_food_mustard", "prop_watercooler", "prop_choc_ego", "prop_choc_pq"},
	
	['Bureaux'] = { "prop_office_desk_01", "xm_prop_base_staff_desk_01", "xm_prop_lab_desk_02",
	-- no photo
	"v_med_p_desk", "xm_base_cia_desk1"},
	
	['Canapés'] = { "apa_mp_h_stn_sofa_daybed_01", "apa_mp_h_stn_sofa_daybed_02", "apa_mp_h_stn_sofacorn_06", "apa_mp_h_stn_sofacorn_10", "apa_mp_h_yacht_sofa_01", 
	"ex_mp_h_off_sofa_02", "hei_heist_stn_sofa2seat_02", "hei_heist_stn_sofa3seat_02", "hei_heist_stn_sofa3seat_06", "hei_heist_stn_sofacorn_05", 
	"p_yacht_sofa_01_s", "prop_couch_01", "prop_couch_lg_02", "prop_couch_lg_08", "prop_rub_couch04", "prop_t_sofa", "prop_wait_bench_01", "prop_yaught_sofa_01" },
	
	['Chaises'] = { "xm_lab_easychair_01", "apa_mp_h_din_chair_09", "apa_mp_h_stn_chairarm_02", "apa_mp_h_stn_chairarm_12", "apa_mp_h_stn_chairarm_26", 
	"apa_mp_h_stn_chairstrip_07", "ex_mp_h_stn_chairstrip_07", "ex_mp_h_stn_chairstrip_011", "gr_prop_highendchair_gr_01a", "hei_heist_din_chair_01", 
	"hei_heist_din_chair_04", "hei_heist_din_chair_06", "hei_heist_stn_chairstrip_01", "hei_prop_hei_skid_chair", "p_armchair_01_s", "prop_chair_01a", 
	"prop_off_chair_01", "prop_table_01_chr_b", "v_corp_offchair", "xm_lab_chairarm_25", "xm_lab_chairstool_12", 
	-- no photo
	"prop_cs_office_chair" },

	['Autres Divers'] = { "v_res_mousemat", "bkr_prop_money_sorted_01", "hei_prop_drug_statue_01", "lux_prop_cigar_01_luxe", "p_new_j_counter_02", 
	"prop_50s_jukebox", "prop_acc_guitar_01", "prop_bong_01", "prop_coffee_mac_02", "prop_dart_bd_cab_01", "prop_fridge_03", "prop_game_clock_02", 
	"prop_pooltable_02", "prop_speaker_02", "prop_table_tennis", "prop_tv_cabinet_03", 
	-- no photo
	"prop_attache_case_01", "prop_bskball_01", "prop_champ_box_01", "prop_cs_package_01", "prop_cs_panties", "prop_cs_shopping_bag", "prop_shopping_bags02",
	"prop_el_guitar_02", "prop_el_guitar_03", "prop_mr_rasberryclean", "prop_mr_raspberry_01", "prop_novel_01", "prop_pap_camera_01" },
	
	['Étagères'] = { "v_ret_ml_liqshelfe", "apa_mp_h_str_shelffreel_01", "apa_mp_h_str_shelfwallm_01", "prop_cabinet_01b", "prop_devin_box_closed", "prop_towel_shelf_01", 
	"prop_tshirt_shelf_1" },
	
	['Lampes'] = { "ex_mp_h_lit_lightpendant_01", "prop_spot_clamp_02", "v_ilev_fh_lampa_on", "apa_mp_h_lit_floorlamp_10", "apa_mp_h_lit_floorlamp_17", 
	"apa_mp_h_lit_floorlampnight_05", "apa_mp_h_lit_floorlampnight_07", "apa_mp_h_lit_lamptable_02", "apa_mp_h_lit_lamptablenight_24", "apa_mp_h_lit_lightpendant_05b"},
	
	['Lits'] = { "apa_mp_h_bed_double_08", "apa_mp_h_bed_wide_05", "apa_mp_h_bed_with_table_02", "apa_mp_h_yacht_bed_02", "ex_prop_exec_bed_01", "gr_prop_bunker_bed_01", 
	"imp_prop_impexp_campbed_01", "p_lestersbed_s", "p_mbbed_s" },
	
	['Plantes'] = { "apa_mp_h_acc_plant_palm_01", "ex_mp_h_acc_plant_tall_01", "p_int_jewel_plant_02", "prop_plant_int_02a", "prop_plant_int_03b", "prop_plant_int_04b", 
	"prop_plant_int_04c", "prop_pot_plant_05b", "prop_pot_plant_6b", "prop_pot_plant_inter_03a", "bkr_prop_weed_01_small_01a", "bkr_prop_weed_med_01b" },
	
	['Visuels'] = { "hei_prop_heist_pic_12", "hei_prop_heist_pic_13", "v_ilev_ra_doorsafe", "ex_office_swag_paintings01", "ex_office_swag_paintings02", 
	"ex_office_swag_paintings03", "hei_heist_acc_artgolddisc_02", "hei_prop_heist_pic_05", "hei_prop_heist_pic_08" },
	
	['Tables'] = { "apa_mp_h_yacht_coffee_table_02", "apa_mp_h_yacht_side_table_01", "ex_mp_h_din_table_05", "gr_dlc_gr_yacht_props_table_03", "prop_ld_farm_table01", 
	"prop_table_01", "prop_table_03b_cs", "prop_table_05", "prop_table_07", "v_ilev_liconftable_sml" },
	
	['Tapis'] = { "apa_mp_h_acc_rugwooll_04", "apa_mp_h_acc_rugwoolm_01", "apa_mp_h_acc_rugwoolm_02", "apa_mp_h_acc_rugwoolm_03", "apa_mp_h_acc_rugwoolm_04", 
	"apa_mp_h_acc_rugwools_01", "apa_mp_h_acc_rugwools_03", "hei_heist_acc_rughidel_01", "hei_heist_acc_rugwooll_02", "hei_heist_acc_rugwooll_03", "p_yoga_mat_02_s", 
	"prop_yoga_mat_01", "prop_yoga_mat_03" },

	["Electronique"] = {
		"prop_tv_flat_02", "prop_tv_flat_01", "prop_laptop_01a", "prop_arcade_01",
		-- no photo
		"prop_fan_01", "prop_fax_01", "prop_off_phone_01", "prop_office_phone_tnt", "prop_printer_01", "prop_printer_02", "prop_shredder_01", "prop_amb_phone",
		"prop_cs_aircon_fan", "prop_cs_tablet", 
	}
}

AllDecorationsProps = {
    items = {
        { name = 'main', type = 'buttons', elements = {
			{ name = 'Mobilier', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_mobilier.svg', hoverStyle = 'fill-black' },
			{ name = 'Décoration', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_decoration.svg', hoverStyle = 'fill-black' },
			--{ name = 'Revetements', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_revetement.svg', hoverStyle = 'fill-black' },
			{ name = 'Éclairage', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_eclairage.svg', hoverStyle = 'fill-black' },
			{ name = 'Divers', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_divers.svg', hoverStyle = 'fill-black' },
		}},
		{ name = 'Mobilier', type = 'buttons', elements = {
			{ name = 'Bureaux', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_bureau.svg', hoverStyle = 'fill-black' },
			{ name = 'Canapés', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_canape.svg', hoverStyle = 'fill-black' },
			{ name = 'Chaises', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_chaise.svg', hoverStyle = 'fill-black' },
			{ name = 'Lits', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_lit.svg', hoverStyle = 'fill-black' },
			{ name = 'Tables', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_table.svg', hoverStyle = 'fill-black' },
			{ name = 'Étagères', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_etagere.svg', hoverStyle = 'fill-black' },
			{ name = 'Electronique', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_etagere.svg', hoverStyle = 'fill-black' },
		}},
		{ name = 'Décoration', type = 'buttons', elements = {
			{ name = 'Plantes', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_decoration.svg', hoverStyle = 'fill-black' },
			{ name = 'Visuels', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_visuel.svg', hoverStyle = 'fill-black' },
			{ name = 'Tapis', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_tapis.svg', hoverStyle = 'fill-black' },
		}},
		{ name = 'Revetements', type = 'buttons', elements = {
			-- Il n'y a rien dans cette catégorie ?
		}},
		{ name = 'Éclairage', type = 'buttons', elements = {
			{ name = 'Lampes', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_eclairage.svg', hoverStyle = 'fill-black' },
		}},
		{ name = 'Divers', type = 'buttons', elements = {
			{ name = 'Consommables', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/main_divers.svg', hoverStyle = 'fill-black' },
			{ name = 'Autres Divers', width = 'full', image = 'https://cdn.sacul.cloud/v2/vision-cdn/MenuDecoration/svg/ico_autre.svg', hoverStyle = 'fill-black' },
		}},
        { name = 'Consommables', type = 'elements', elements = {}},
        { name = 'Bureaux', type = 'elements', elements = {}},
        { name = 'Canapés', type = 'elements', elements = {}},
        { name = 'Chaises', type = 'elements', elements = {}},
        { name = 'Autres Divers', type = 'elements', elements = {}},
        { name = 'Étagères', type = 'elements', elements = {}},
        { name = 'Lampes', type = 'elements', elements = {}},
        { name = 'Lits', type = 'elements', elements = {}},
        { name = 'Plantes', type = 'elements', elements = {}},
        { name = 'Visuels', type = 'elements', elements = {}},
        { name = 'Tables', type = 'elements', elements = {}},
        { name = 'Tapis', type = 'elements', elements = {}},
        { name = 'Electronique', type = 'elements', elements = {}},
    },
}

TriggerEvent('core:RequestTokenAcces', 'core', function(newToken)
    token = newToken
end)

-- Get all decorations props
-- @return boolean
local function GetDecorationsProps()
	-- Consommables
	for k, v in pairs(decorationsProps['Consommables']) do
		table.insert(AllDecorationsProps.items[7].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Consommables/' .. v .. '.webp',
			category = 'Consommables',
			label = k
		})
	end
	
	-- Bureaux
	for k, v in pairs(decorationsProps['Bureaux']) do
		table.insert(AllDecorationsProps.items[8].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Bureaux/'.. v ..'.webp',
			category = 'Bureaux',
			label = k
		})
	end
	
	-- Canapés
	for k, v in pairs(decorationsProps['Canapés']) do
		table.insert(AllDecorationsProps.items[9].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Canapes/' .. v .. '.webp',
			category = 'Canapés',
			label = k
		})
	end
	
	-- Chaises
	for k, v in pairs(decorationsProps['Chaises']) do
		table.insert(AllDecorationsProps.items[10].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Chaises/' .. v .. '.webp',
			category = 'Chaises',
			label = k
		})
	end
	
	-- Autres Divers
	for k, v in pairs(decorationsProps['Autres Divers']) do
		table.insert(AllDecorationsProps.items[11].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Autres/' .. v .. '.webp',
			category = 'Autres Divers',
			label = k
		})
	end
	
	-- Étagères
	for k, v in pairs(decorationsProps['Étagères']) do
		table.insert(AllDecorationsProps.items[12].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Etageres/' .. v .. '.webp',
			category = 'Étagères',
			label = k
		})
	end
	
	-- Lampes
	for k, v in pairs(decorationsProps['Lampes']) do
		table.insert(AllDecorationsProps.items[13].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Lampes/' .. v .. '.webp',
			category = 'Lampes',
			label = k
		})
	end
	
	-- Lits
	for k, v in pairs(decorationsProps['Lits']) do
		--print('https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Lits/' .. v .. '.webp')
		table.insert(AllDecorationsProps.items[14].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Lits/' .. v .. '.webp',
			category = 'Lits',
			label = k
		})
	end
	
	-- Plantes
	for k, v in pairs(decorationsProps['Plantes']) do
		table.insert(AllDecorationsProps.items[15].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Plantes/' .. v .. '.webp',
			category = 'Plantes',
			label = k
		})
	end
	
	-- Visuels
	for k, v in pairs(decorationsProps['Visuels']) do
		table.insert(AllDecorationsProps.items[16].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Visuels/' .. v .. '.webp',
			category = 'Visuels',
			label = k
		})
	end
	-- Tables
	for k, v in pairs(decorationsProps['Tables']) do
		table.insert(AllDecorationsProps.items[17].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Tables/' .. v .. '.webp',
			category = 'Tables',
			label = k
		})
	end
	-- Tapis
	for k, v in pairs(decorationsProps['Tapis']) do
		table.insert(AllDecorationsProps.items[18].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Tapis/' .. v .. '.webp',
			category = 'Tapis',
			label = k
		})
	end
	for k,v in pairs(decorationsProps['Electronique']) do 
		table.insert(AllDecorationsProps.items[19].elements, {
			id = k,
			prop = v,
			image = 'https://cdn.sacul.cloud/v2/vision-cdn/Habitation/Deco/Electronique/' .. v .. '.webp',
			category = 'Electronique',
			label = k
		})
	end
	return true
end

local function LoadingPrompt(loadingText, spinnerType)
    if BusyspinnerIsOn() then
        BusyspinnerOff()
    end
    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end
    EndTextCommandBusyString(spinnerType)
end

-- Open the decoration menu
-- @return void
function OpenDecorationMenu(isDLC)
	InsideDeco = isDLC
	if not loaded then
		loaded = true
		local bool = GetDecorationsProps()
		while not bool do
			Wait(1)
			LoadingPrompt("Chargement des images...", 2)
		end
	end
	BusyspinnerOff()
	InsideFocus = true
	SendNuiMessage(json.encode({
		type = 'openWebview',
		name = 'MenuDecoration',
		data = AllDecorationsProps
	}))
end

-- Spawn the selected decoration prop
-- @return void
function SpawnDecoration(object)
	DecoModule.Cancel()
	local placed = false
	local ignore = false
	local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
	local objS = entity:CreateObjectLocal(object, coords)
	PlaceObjectOnGroundProperly(objS.id)

	if not InsideDeco then
		Editor.Object = objS
		Editor.Object.name = object
		SetEntityAlpha(objS.id, 215, true)
		Wait(200)
		SetCamActive(Editor.Cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(Editor.Cam, coords)
		SetCamRot(Editor.Cam, 0.0, 0.0, 0.0)
		DecoModule.Use(objS.id, object)
	else
		local heading = p:heading()
		local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
		local objCoords = (coords + forward * 2.5)
		local placed = false
		FreezeEntityPosition(objS.id, true)
		while not placed do
			coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
			objCoords = (coords + forward * 2.5)
			objS:setPos(objCoords)
			PlaceObjectOnGroundProperly(objS.id)
			objS:setAlpha(170)
			SetEntityNoCollisionEntity(PlayerPedId(), objS.id, true)
			SetEntityNoCollisionEntity(objS.id, PlayerPedId(), true)
			
			if IsControlPressed(0, 190) then
				heading = heading + 0.5
			elseif IsControlPressed(0, 189) then
				heading = heading - 0.5
			end
	
			SetEntityHeading(objS.id, heading)
	
			ShowHelpNotification("~INPUT_CONTEXT~ Valider\n~INPUT_FRONTEND_LEFT~ ou ~INPUT_FRONTEND_RIGHT~ Pivoter")
			if IsControlJustPressed(0, 38) then
				placed = true
			end
			Wait(0)
		end
		SetEntityCollision(objS.id, true, true)
		objS:resetAlpha()
		table.insert(Editor.AllObjects, {
			prop = object,
			object = objS.id,
			id = objS.id,
			coords = GetEntityCoords(objS.id),
			heading = GetEntityHeading(objS.id)
		})
		OpenDecoUI()
	end
	return objS.id, object
end

-- RegisterCommand('deco', function()
-- 	if p and p:getSubscription() >= 1 then
-- 		if canOpenDeco then		
-- 			OpenDecorationMain()
-- 		else
-- 			exports['vNotif']:createNotification({
-- 				type = 'ROUGE',
-- 				content = "~sVous ne pouvez décorer uniquement dans une propriété vide"
-- 			})
-- 		end
-- 	else
-- 		exports['vNotif']:createNotification({
-- 			type = 'ROUGE',
-- 			-- duration = 5, -- In seconds, default:  4
-- 			content = "~c Vous devez avoir le premium pour pouvoir utiliser la décoration d'interieur"
-- 		})
-- 	end
-- end, false)

--RegisterNetEvent('core:unloadDecorationProperty', function()
--	for i, propData in pairs(Editor.AllObjects) do
--		DeleteEntity(propData.object)
--		table.remove(Editor.AllObjects, i)
--	end
--end)

RegisterNetEvent("core:getDeco", function(decorations)
	Wait(1000)
	local props = TriggerServerCallback("core:deco:getInstancedObjects", propertyIdDeco)
	if props == 1 then return end
	if next(Editor.AllObjects) then return end 
	for k, v in pairs(decorations) do
		local objid = nil
		local coords = vector3(v.coords.x, v.coords.y, v.coords.z)
		for i,z in pairs(props) do 
			if z.coords == coords then 
				objid = NetToObj(z.entity)
			end
		end
		table.insert(Editor.AllObjects, {
			prop = v.prop,
			object = objid,
			id = objid,
			coords = coords,
			heading = v.heading
		})
	end
end)

AppartementObjects = {}

RegisterNetEvent('core:unloadDecorationProperty', function()
	for k,v in pairs(AppartementObjects) do 
		DeleteEntity(AppartementObjects[k].id)
	end
end)

RegisterNetEvent('core:loadDecorationProperty', function(decorations)
	Wait(250)
	if decorations == nil then return end
	for k, v in pairs(decorations) do
		local coords = vector3(v.coords.x, v.coords.y, v.coords.z)
		--print("LOAD INTERIOR", v.prop, coords, v.heading)
		if not v.prop then return end
		local objS = entity:CreateObjectLocal(v.prop, coords)
		objS:setFreeze(true)
		objS:setPos(coords)
		objS:setHeading(v.heading)
		--PlaceObjectOnGroundProperly(objS.id)
		SetNetworkIdExistsOnAllMachines(ObjToNet(objS.id), true)
		SetNetworkIdAlwaysExistsForPlayer(ObjToNet(objS.id), PlayerId(), true)
		SetEntityAsMissionEntity(objS.id, true, true)
		--TriggerServerEvent("core:deco:instanceobject", ObjToNet(objS.id), coords, propertyIdDeco)
		table.insert(Editor.AllObjects, {
			prop = v.prop,
			object = objS.id,
			coords = coords,
			heading = v.heading
		})
	end
end)

RegisterNetEvent('core:useDecorationProperty', function(propertyData, flag)
	canOpenDeco = flag
	if not flag then
		propertyIdDeco = 0
		print("Editor.AllObjects", json.encode(Editor.AllObjects))
		for k,v in pairs(Editor.AllObjects) do 
			if v.object then 
				DeleteEntity(v.object)
			end
		end
		Wait(200)
		Editor.AllObjects = {}
	else
		propertyIdDeco = propertyData.id
		--StartThreadHandlingDecoration()
	end
end)

RegisterNUICallback('MenuDecoration', function(data, cb)
	TriggerServerEvent('core:updateDecorationProperty', token, Editor.AllObjects, propertyIdDeco)
end)

RegisterNUICallback('MenuBincoClickButton', function(data, cb)
	if data.item then
		--print("prop label", data.item.prop, data.item.label)
		local prop = data.item.prop
		local label = data.item.label
		InsideFocus = false
		SendNuiMessage(json.encode({
			type = 'closeWebview'
		}))
		SpawnDecoration(prop)
	end
end)

Editor.CamRayCast = function(cam, ignore)
	local ignore = ignore or PlayerPedId()
	local camCoords = GetCamCoord(cam)
	local right, forward, up, at = GetCamMatrix(cam)
	local forwardCoords = camCoords + forward * 1000.0
	local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords.x, camCoords.y, camCoords.z, forwardCoords.x, forwardCoords.y, forwardCoords.z, -1, ignore,  0)

	return GetRaycastResult(rayHandle)
end

OpenDecorationMain = function()
	--TriggerEvent("sw:allowfrrr", 1)
	local playerPed = PlayerPedId()
	--if not DoesCamExist(Editor.Cam) then
	--	Editor.Cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	--	SetCamActive(Editor.Cam, true)
	--	RenderScriptCams(true, false, 0, true, true)                
	--	local coords = GetEntityCoords(playerPed)                
	--	SetCamCoord(Editor.Cam, coords.x, coords.y, coords.z)
	--	SetCamRot(Editor.Cam, 0.0, 0.0, 0.0)
	--	--SetEntityCollision(playerPed, false, false)
	--end
	--DecoModule.Start(GetCamCoord(Editor.Cam), GetCamRot(Editor.Cam))
	--DecoModule.Start()
	Editor.Started = true
	CreateThread(function()
		while Editor.Started do 
			Wait(1)
			--DecoModule.UpdatePosRot(GetCamCoord(Editor.Cam), GetCamRot(Editor.Cam))
			--local camdistance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetCamCoord(Editor.Cam))
			--if camdistance and camdistance > 35.0 then 
			--	SetCamCoord(Editor.Cam, GetEntityCoords(PlayerPedId()))
			--end
			if IsDisabledControlJustPressed(0, 38) then 
				OpenDecorationMenu()
			end
			if IsControlJustPressed(0, 194) then  -- quitter
				SetCamActive(Editor.Cam, false)
				RenderScriptCams(false, false, 0, true, true)
				SetEntityCollision(PlayerPedId(), true, true)
				Editor.Cam = nil				
				DecoModule.Cancel()
				Editor.Started = false
				TriggerEvent("sw:allowfrrr", 0)
				if Editor.Object then 
					DeleteEntity(Editor.Object.id)
					Editor.Object = nil
				end
			end
			if next(Editor.AllObjects) then 
				if IsDisabledControlJustPressed(0, 24) then 
					local _rayHandle, hit, surface, raycoords, entity = Editor.CamRayCast(Editor.Cam)
					for k,v in pairs(Editor.AllObjects) do 
						if v.coords then 
							if type(v.coords) == "table" then v.coords = vector3(v.coords.x, v.coords.y, v.coords.z) end
							local distance = Vdist(v.coords, surface)
							--print("distnace", distance)
							if distance < 1.35 then 
								if Editor.Object == nil then 
									local newobj = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 2.0, GetHashKey(v.prop))
									if newobj ~= 0 then
										NetworkRequestControlOfEntity(newobj)
										while not NetworkHasControlOfEntity(newobj) do Wait(1) print("req", newobj) end
										Editor.Object = v
										Editor.Object.name = v.prop
										Editor.Object.id = newobj
										v.object = newobj
										--print("Deco use ", newobj, v.prop)
										DecoModule.Use(newobj, v.prop)
										SetEntityAlpha(newobj, 215, true)
									end
								else
									--print("Editor.Object.id ", Editor.Object.id)
									break
								end
							end
						end
					end
				end
				if Editor.Object == nil then
					if IsControlJustPressed(0, 191) then  -- SAUVEGARDE
						TriggerServerEvent('core:updateDecorationProperty', token, Editor.AllObjects, propertyIdDeco)					
					end
				end
			end
			if Editor.Object then 
				local heading = GetEntityHeading(Editor.Object.id)
				if not InsideFocus then
				--	ShowHelpNotification("~INPUT_PICKUP~ Menu props\n~INPUT_FRONTEND_RRIGHT~ Retour\n\n~INPUT_AIM~ ou ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ pour placer l'objet\n~INPUT_COVER~ ~INPUT_PICKUP~ pour tourner l'objet\n~INPUT_WEAPON_WHEEL_PREV~ ~INPUT_WEAPON_WHEEL_NEXT~ pour monter/descendre l'objet\n~INPUT_CELLPHONE_OPTION~ pour supprimer l'objet\n~INPUT_LOOK_BEHIND~ pour dupliquer l'objet\n~INPUT_FRONTEND_RDOWN~ pour valider le positionnement de l'objet\n\n~INPUT_DETONATE~ pour bloquer la caméra")
					ShowHelpNotification("~INPUT_PICKUP~ Menu props\n~INPUT_FRONTEND_RRIGHT~ Retour\n\n~INPUT_MP_TEXT_CHAT_TEAM~ Position\n~INPUT_RELOAD~ Rotation\n~INPUT_CELLPHONE_OPTION~ Supprimer\n~INPUT_LOOK_BEHIND~ Dupliquer\n~INPUT_FRONTEND_RDOWN~ Valider\n\n~INPUT_DETONATE~ Bloquer la caméra")	
				end
				if IsControlJustPressed(0, 47) or IsDisabledControlJustPressed(0, 47) then 
					BlockCamera = not BlockCamera
				end
				--if IsDisabledControlPressed(0, 25) then 
				--	local _rayHandle, hit, surface, raycoords, entity = Editor.CamRayCast(Editor.Cam, Editor.Object.id)
				--	PlaceObjectOnGroundProperly(Editor.Object.id)
				--	SetEntityCoords(Editor.Object.id, surface)
				--end
				--if IsControlPressed(0, 174) then 
				--	local right, forward, up, at = GetCamMatrix(Editor.Cam)
				--	local x,y,z = table.unpack(GetEntityCoords(Editor.Object.id))
				--	local coords = vector3(x,y,z) + right * (-0.01)
				--	SetEntityCoords(Editor.Object.id, coords.x, coords.y, z)
				--end
				--if IsControlPressed(0, 175) then 
				--	local right, forward, up, at = GetCamMatrix(Editor.Cam)
				--	local x,y,z = table.unpack(GetEntityCoords(Editor.Object.id))
				--	local coords = vector3(x,y,z) + right * 0.01
				--	SetEntityCoords(Editor.Object.id, coords.x, coords.y, z)
				--end
				--if IsDisabledControlPressed(0, 38) then
				--	heading = heading + 0.40
				--end
				--if IsDisabledControlPressed(0, 44) then
				--	heading = heading - 0.40
				--end
				--if IsControlPressed(0, 15) then -- up
				--	local x,y,z = table.unpack(GetEntityCoords(Editor.Object.id))
				--	SetEntityCoords(Editor.Object.id, x,y,z+0.1)
				--end
				if IsControlJustPressed(0, 26) then
					--print("Editor.Object.name", Editor.Object.name)
					SetEntityAlpha(Editor.Object.id, 255, true)
					ResetEntityAlpha(Editor.Object.id)
					local nmae = Editor.Object.name
					--DecoModule.Cancel()
					--Wait(30)
					--print("GetEntityCoords(Editor.Object.id)", GetEntityCoords(Editor.Object.id))
					local objS = entity:CreateObjectLocal(Editor.Object.name, GetEntityCoords(Editor.Object.id))
					SetEntityRotation(objS.id, GetEntityRotation(Editor.Object.id))
					SetEntityDynamic(objS.id, true)
					FreezeEntityPosition(objS.id, true)
					SetEntityAlpha(objS.id, 215, true)
					--PlaceObjectOnGroundProperly(objS.id)
					--DecoModule.Start(GetCamCoord(Editor.Cam), GetCamRot(Editor.Cam))
					table.insert(Editor.AllObjects, {
						id = objS.id,
						object = objS.id,
						heading = GetEntityHeading(objS.id),
						coords = GetEntityCoords(objS.id),
						prop = Editor.Object.name
					})
					BlockCamera = false
					--Wait(30)

					DecoModule.Use(objS.id, Editor.Object.name)
					Editor.Object = objS
					Editor.Object.name = nmae
				end
				--if IsControlPressed(0, 14) then -- down
				--	local x,y,z = table.unpack(GetEntityCoords(Editor.Object.id))
				--	SetEntityCoords(Editor.Object.id, x,y,z-0.1)
				--end
				if IsControlJustPressed(0, 178) then -- Delete
					DecoModule.Cancel()
					BlockCamera = false
					DeleteEntity(Editor.Object.id)
					for k,v in pairs(Editor.AllObjects) do 
						if Editor.Object.id == v.id then 
							table.remove(Editor.AllObjects, k)
							break
						end
					end
					Editor.Object = nil
				end
				if IsControlJustPressed(0, 191) then 
					DecoModule.Cancel()
					table.insert(Editor.AllObjects, {
						id = Editor.Object.id,
						object = Editor.Object.id,
						heading = GetEntityHeading(Editor.Object.id),
						coords = GetEntityCoords(Editor.Object.id),
						prop = Editor.Object.name
					})
					BlockCamera = false
					SetEntityDynamic(Editor.Object.id, true)
					FreezeEntityPosition(Editor.Object.id, true)
					SetEntityAlpha(Editor.Object.id, 255, true)
					ResetEntityAlpha(Editor.Object.id)
					Editor.Object.id = nil
					Editor.Object = nil
				end
				if Editor.Object then 
					SetEntityHeading(Editor.Object.id, heading)
				end
			else
				if next(Editor.AllObjects) then 
					if not InsideFocus then
						ShowHelpNotification("~INPUT_PICKUP~ Menu props\n~INPUT_FRONTEND_RRIGHT~ Retour\n~INPUT_WEAPON_WHEEL_PREV~ ~INPUT_WEAPON_WHEEL_NEXT~ pour changer la vitesse\n~INPUT_ATTACK~ pour sélectionner un objet\n\n~INPUT_FRONTEND_RDOWN~ pour sauvegarder vos objets")
					end
				else
					if not InsideFocus then
						ShowHelpNotification("~INPUT_PICKUP~ Menu props\n~INPUT_FRONTEND_RRIGHT~ Retour")
					end
				end
			end
			--SetEntityLocallyInvisible(PlayerPedId())
			--DisableControlAction(0, 30,   true) -- MoveLeftRight
			--DisableControlAction(0, 31,   true) -- MoveUpDown
			--DisableControlAction(0, 1,    true) -- LookLeftRight
			--DisableControlAction(0, 44,   true) -- Cover
			--DisableControlAction(0, 45,   true) -- Reload
			--DisableControlAction(0, 38,   true) -- INPUT TRUC
			--DisableControlAction(0, 2,    true) -- LookUpDown
			--DisableControlAction(0, 25,   true) -- Input Aim
			--DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override
			--DisableControlAction(0, 24,   true) -- Input Attack
			--DisableControlAction(0, 140,  true) -- Melee Attack Alternate
			--DisableControlAction(0, 141,  true) -- Melee Attack Alternate
			--DisableControlAction(0, 142,  true) -- Melee Attack Alternate
			--DisableControlAction(0, 257,  true) -- Input Attack 2
			--DisableControlAction(0, 263,  true) -- Input Melee Attack
			--DisableControlAction(0, 264,  true) -- Input Melee Attack 2
			--Editor.HandleFreeCamThisFrame()
		end
	end)
end

Editor.HandleFreeCamThisFrame = function()
	local camCoords = GetCamCoord(Editor.Cam)
	local right, forward, up, at = GetCamMatrix(Editor.Cam)

	if IsControlPressed(0, 32) then-- fwrd
		local newCamPos = camCoords + forward * speedMultiplier
		SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 8) then -- back
		local newCamPos = camCoords + forward * -speedMultiplier
		SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 34) then
		local newCamPos = camCoords + right * -speedMultiplier
		SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 9) then
		local newCamPos = camCoords + right * speedMultiplier
		SetCamCoord(Editor.Cam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	--if not Editor.Object then
		if IsControlPressed(0, 181) then -- up
			speedMultiplier = speedMultiplier + 0.1
		end
		
		if IsControlPressed(0, 180) then -- down
			if speedMultiplier < 0.1 then
				speedMultiplier = 0.1
			else
				speedMultiplier = speedMultiplier - 0.1		
			end
		end
	--end
		
	if speedMultiplier < 0.1 then
		speedMultiplier = 0.1
	end

	if not BlockCamera then
		local xMagnitude = GetDisabledControlNormal(0,  1);
		local yMagnitude = GetDisabledControlNormal(0,  2);
		local camRot = GetCamRot(Editor.Cam)

		local x = camRot.x - yMagnitude * 10
		local y = camRot.y
		local z = camRot.z - xMagnitude * 10

		if x < -75.0 then
			x = -75.0
		end

		if x > 100.0 then
			x = 100.0
		end

		SetCamRot(Editor.Cam, x, y, z)
	end
end


RegisterNUICallback("focusOut", function()
	if Editor.Started then 
		local camcoord = GetCamCoord(Editor.Cam)
		local camrot = GetCamRot(Editor.Cam)
		DestroyCam(Editor.Cam)
		InsideFocus = false
		Editor.Cam = nil 
		Wait(90)
		if Editor.Started then 
			Editor.Cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			SetCamActive(Editor.Cam, true)
			RenderScriptCams(true, false, 0, true, true)
			SetCamCoord(Editor.Cam, camcoord)
			SetCamRot(Editor.Cam, camrot)
		end
		TriggerEvent("sw:allowfrrr", 0)
	end
end)