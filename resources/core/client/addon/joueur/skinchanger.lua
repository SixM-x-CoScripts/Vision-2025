local Components = {
	{ label = ('sexe'), name = 'sex', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('visage'), name = 'face', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('Head'), name = 'head', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('Variation'), name = 'head_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('peau'), name = 'skin', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('cheveux 1'), name = 'hair_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('cheveux 2'), name = 'hair_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('couleur cheveux 1'), name = 'hair_color_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('couleur cheveux 2'), name = 'hair_color_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = ('t-Shirt 1'), name = 'tshirt_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 8 },
	{ label = ('t-Shirt 2'), name = 'tshirt_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		textureof = 'tshirt_1' },
	{ label = ('torse 1'), name = 'torso_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 11 },
	{ label = ('torse 2'), name = 'torso_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, textureof = 'torso_1' },
	{ label = ('calques 1'), name = 'decals_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 10 },
	{ label = ('calques 2'), name = 'decals_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		textureof = 'decals_1' },
	{ label = ('bras'), name = 'arms', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('bras 2'), name = 'arms_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('jambes 1'), name = 'pants_1', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.5, componentId = 4 },
	{ label = ('jambes 2'), name = 'pants_2', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.5, textureof = 'pants_1' },
	{ label = ('chaussures 1'), name = 'shoes_1', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.8, componentId = 6 },
	{ label = ('chaussures 2'), name = 'shoes_2', value = 0, min = 0, zoomOffset = 0.8, camOffset = -0.8,
		textureof = 'shoes_1' },
	{ label = ('masque 1'), name = 'mask_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, componentId = 1 },
	{ label = ('masque 2'), name = 'mask_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, textureof = 'mask_1' },
	{ label = ('gilet pare-balle 1'), name = 'bproof_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		componentId = 9 },
	{ label = ('gilet pare-balle 2'), name = 'bproof_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		textureof = 'bproof_1' },
	{ label = ('chaine 1'), name = 'chain_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, componentId = 7 },
	{ label = ('chaine 2'), name = 'chain_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, textureof = 'chain_1' },
	{ label = ('casque 1'), name = 'helmet_1', value = -1, min = -1, zoomOffset = 0.6, camOffset = 0.65, componentId = 0 },
	{ label = ('casque 2'), name = 'helmet_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65,
		textureof = 'helmet_1' },
	{ label = ('lunettes 1'), name = 'glasses_1', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65, componentId = 1 },
	{ label = ('lunettes 2'), name = 'glasses_2', value = 0, min = 0, zoomOffset = 0.6, camOffset = 0.65,
		textureof = 'glasses_1' },
	{ label = ('montre 1'), name = 'watches_1', value = -1, min = -1, zoomOffset = 0.75, camOffset = 0.15, componentId = 6 },
	{ label = ('montre 2'), name = 'watches_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		textureof = 'watches_1' },
	{ label = ('bracelet 1'), name = 'bracelets_1', value = -1, min = -1, zoomOffset = 0.75, camOffset = 0.15,
		componentId = 7 },
	{ label = ('bracelet 2'), name = 'bracelets_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		textureof = 'bracelets_1' },
	{ label = ('sac'), name = 'bags_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15, componentId = 5 },
	{ label = ('couleur sac'), name = 'bags_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15,
		textureof = 'bags_1' },
	{ label = ('lentilles colorées'), name = 'eye_color', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('taille sourcils'), name = 'eyebrows_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('type sourcils'), name = 'eyebrows_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur sourcils 1'), name = 'eyebrows_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur sourcils 2'), name = 'eyebrows_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('type maquillage'), name = 'makeup_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('épaisseur maquillage'), name = 'makeup_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur maquillage 1'), name = 'makeup_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur maquillage 2'), name = 'makeup_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('type lipstick'), name = 'lipstick_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('épaisseur lipstick'), name = 'lipstick_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur lipstick 1'), name = 'lipstick_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur lipstick 2'), name = 'lipstick_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('accessoire oreilles'), name = 'ears_1', value = -1, min = -1, zoomOffset = 0.4, camOffset = 0.65,
		componentId = 2 },
	{ label = ('couleur accessoire'), name = 'ears_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65,
		textureof = 'ears_1' },
	{ label = ('pillositée torse'), name = 'chest_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('opacité pillositée'), name = 'chest_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('couleur pillositée'), name = 'chest_3', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('imperfections du corps'), name = 'bodyb_1', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('opacité imperfections'), name = 'bodyb_2', value = 0, min = 0, zoomOffset = 0.75, camOffset = 0.15 },
	{ label = ('rides'), name = 'age_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('épaisseur rides'), name = 'age_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('Boutons'), name = 'blemishes_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('opacité des boutons'), name = 'blemishes_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('rougeur'), name = 'blush_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('opacité rougeur'), name = 'blush_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur rougeur'), name = 'blush_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('teint'), name = 'complexion_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('opacité teint'), name = 'complexion_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('dommages UV'), name = 'sun_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('opacité dommages UV'), name = 'sun_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('taches de rousseur'), name = 'moles_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('opacité rousseur'), name = 'moles_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('type barbe'), name = 'beard_1', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('taille barbe'), name = 'beard_2', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur barbe 1'), name = 'beard_3', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = ('couleur barbe 2'), name = 'beard_4', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },

	{ label = 'Héritage mère', name = 'mom', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'Héritage père', name = 'dad', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'nose_width', name = 'nose_1', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'nose_height', name = 'nose_2', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'nose_peak', name = 'nose_3', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'nose_bone', name = 'nose_4', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'nose_peak_2', name = 'nose_5', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'nose', name = 'nose_6', value = 0.0, min = 0, zoomOffset = 0.6, camOffset = 0.65 },
	{ label = 'eyebrows_depth', name = 'eyebrows_5', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'eyebrows_height', name = 'eyebrows_6', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'cheekbones_height', name = 'cheeks_1', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'cheekbones_width', name = 'cheeks_2', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'cheek_width', name = 'cheeks_3', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'opening_eyes', name = 'eye_open', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'lips_thick', name = 'lips_thick', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'jaw_width', name = 'jaw_1', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'jaw_length', name = 'jaw_2', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'chin_height', name = 'chin_height', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'chin_lenght', name = 'chin_lenght', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'chin_width', name = 'chin_width', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'chin_hole', name = 'chin_hole', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'neck_thick', name = 'neck_thick', value = 0.0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },

	{ label = 'Degrade Collection', name = 'degrade_collection', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
	{ label = 'Degrade Name', name = 'degrade_hashname', value = 0, min = 0, zoomOffset = 0.4, camOffset = 0.65 },
}

local LastSex       = -1
local LoadSkin      = nil
local LoadClothes   = nil
local Character     = {}
local fakeCharacter = {}

for i = 1, #Components, 1 do
	Character[Components[i].name] = Components[i].value
end

function LoadDefaultModel(malePed, cb)
	local playerPed = PlayerPedId()
	local characterModel
	local health = GetEntityHealth(PlayerPedId())
	if malePed == nil then
		malePed = p:skin().sex
	end
	if malePed == 0 then
		characterModel = GetHashKey('mp_m_freemode_01')
	elseif malePed == 1 then
		characterModel = GetHashKey('mp_f_freemode_01')
	elseif malePed ~= 1 and malePed ~= 0 and malePed ~= nil then
		characterModel = GetHashKey(PedsCharCreator[malePed - 1])

	end

	RequestModel(characterModel)

	Citizen.CreateThread(function()
		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Citizen.Wait(0)
		end

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(playerPed)
		end

		SetEntityHealth(PlayerPedId(), health)
		SetModelAsNoLongerNeeded(characterModel)

		if cb ~= nil then
			cb()
		end

		TriggerEvent('skinchanger:modelLoaded')
	end)
end

function GetMaxVals()
	local playerPed = PlayerPedId()
	local degrade = getDegrader()

	local data = {
		sex          = #PedsCharCreator + 3,
		face         = 45,
		head         = GetNumberOfPedDrawableVariations(playerPed, 0),
		head_2       = GetNumberOfPedTextureVariations(playerPed, 0, Character['head']) - 1,
		skin         = 45,
		age_1        = GetNumHeadOverlayValues(3) - 1,
		age_2        = 10,
		beard_1      = GetNumHeadOverlayValues(1) - 1,
		beard_2      = 10,
		beard_3      = GetNumHairColors() - 1,
		beard_4      = GetNumHairColors() - 1,
		hair_1       = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
		hair_2       = GetNumberOfPedTextureVariations(playerPed, 2, Character['hair_1']) - 1,
		hair_color_1 = GetNumHairColors() - 1,
		hair_color_2 = GetNumHairColors() - 1,
		eye_color    = 31,
		eyebrows_1   = GetNumHeadOverlayValues(2) - 1,
		eyebrows_2   = 10,
		eyebrows_3   = GetNumHairColors() - 1,
		eyebrows_4   = GetNumHairColors() - 1,
		makeup_1     = GetNumHeadOverlayValues(4) - 1,
		makeup_2     = 10,
		makeup_3     = GetNumHairColors() - 1,
		makeup_4     = GetNumHairColors() - 1,
		lipstick_1   = GetNumHeadOverlayValues(8) - 1,
		lipstick_2   = 10,
		lipstick_3   = GetNumHairColors() - 1,
		lipstick_4   = GetNumHairColors() - 1,
		blemishes_1  = GetNumHeadOverlayValues(0) - 1,
		blemishes_2  = 10,
		blush_1      = GetNumHeadOverlayValues(5) - 1,
		blush_2      = 10,
		blush_3      = GetNumHairColors() - 1,
		degrade_collection = -1719270477,
		degrade_hashname = -1824026490,
		complexion_1 = GetNumHeadOverlayValues(6) - 1,
		complexion_2 = 10,
		sun_1        = GetNumHeadOverlayValues(7) - 1,
		sun_2        = 10,
		moles_1      = GetNumHeadOverlayValues(9) - 1,
		moles_2      = 10,
		chest_1      = GetNumHeadOverlayValues(10) - 1,
		chest_2      = 10,
		chest_3      = GetNumHairColors() - 1,
		bodyb_1      = GetNumHeadOverlayValues(11) - 1,
		bodyb_2      = 10,
		ears_1       = GetNumberOfPedPropDrawableVariations(playerPed, 2) - 1,
		ears_2       = GetNumberOfPedPropTextureVariations(playerPed, 2, Character['ears_1'] - 1),
		tshirt_1     = GetNumberOfPedDrawableVariations(playerPed, 8) - 1,
		tshirt_2     = GetNumberOfPedTextureVariations(playerPed, 8, Character['tshirt_1']) - 1,
		torso_1      = GetNumberOfPedDrawableVariations(playerPed, 11) - 1,
		torso_2      = GetNumberOfPedTextureVariations(playerPed, 11, Character['torso_1']) - 1,
		decals_1     = GetNumberOfPedDrawableVariations(playerPed, 10) - 1,
		decals_2     = GetNumberOfPedTextureVariations(playerPed, 10, Character['decals_1']) - 1,
		arms         = GetNumberOfPedDrawableVariations(playerPed, 3) - 1,
		arms_2       = 10,
		pants_1      = GetNumberOfPedDrawableVariations(playerPed, 4) - 1,
		pants_2      = GetNumberOfPedTextureVariations(playerPed, 4, Character['pants_1']) - 1,
		shoes_1      = GetNumberOfPedDrawableVariations(playerPed, 6) - 1,
		shoes_2      = GetNumberOfPedTextureVariations(playerPed, 6, Character['shoes_1']) - 1,
		mask_1       = GetNumberOfPedDrawableVariations(playerPed, 1) - 1,
		mask_2       = GetNumberOfPedTextureVariations(playerPed, 1, Character['mask_1']) - 1,
		bproof_1     = GetNumberOfPedDrawableVariations(playerPed, 9) - 1,
		bproof_2     = GetNumberOfPedTextureVariations(playerPed, 9, Character['bproof_1']) - 1,
		chain_1      = GetNumberOfPedDrawableVariations(playerPed, 7) - 1,
		chain_2      = GetNumberOfPedTextureVariations(playerPed, 7, Character['chain_1']) - 1,
		bags_1       = GetNumberOfPedDrawableVariations(playerPed, 5) - 1,
		bags_2       = GetNumberOfPedTextureVariations(playerPed, 5, Character['bags_1']) - 1,
		helmet_1     = GetNumberOfPedPropDrawableVariations(playerPed, 0) - 1,
		helmet_2     = GetNumberOfPedPropTextureVariations(playerPed, 0, Character['helmet_1']) - 1,
		glasses_1    = GetNumberOfPedPropDrawableVariations(playerPed, 1) - 1,
		glasses_2    = GetNumberOfPedPropTextureVariations(playerPed, 1, Character['glasses_1'] - 1),
		watches_1    = GetNumberOfPedPropDrawableVariations(playerPed, 6) - 1,
		watches_2    = GetNumberOfPedPropTextureVariations(playerPed, 6, Character['watches_1']) - 1,
		bracelets_1  = GetNumberOfPedPropDrawableVariations(playerPed, 7) - 1,
		bracelets_2  = GetNumberOfPedPropTextureVariations(playerPed, 7, Character['bracelets_1'] - 1)
	}

	return data
end

function ApplySkin(skin, clothes, freezeface)
	local playerPed = PlayerPedId()

	for k, v in pairs(skin) do
		Character[k] = v
	end

	if clothes ~= nil then
		for k, v in pairs(clothes) do
			if k ~= 'sex' and
				k ~= 'face' and
				k ~= 'skin' and
				k ~= 'age_1' and
				k ~= 'age_2' and
				k ~= 'eye_color' and
				k ~= 'beard_1' and
				k ~= 'beard_2' and
				k ~= 'beard_3' and
				k ~= 'beard_4' and
				k ~= 'hair_1' and
				k ~= 'secondhair' and
				k ~= 'hair_2' and
				k ~= 'hair_color_1' and
				k ~= 'hair_color_2' and
				k ~= 'eyebrows_1' and
				k ~= 'eyebrows_2' and
				k ~= 'eyebrows_3' and
				k ~= 'eyebrows_4' and
				k ~= 'makeup_1' and
				k ~= 'makeup_2' and
				k ~= 'makeup_3' and
				k ~= 'makeup_4' and
				k ~= 'lipstick_1' and
				k ~= 'lipstick_2' and
				k ~= 'lipstick_3' and
				k ~= 'lipstick_4' and
				k ~= 'blemishes_1' and
				k ~= 'blemishes_2' and
				k ~= 'blush_1' and
				k ~= 'blush_2' and
				k ~= 'blush_3' and
				k ~= 'degrade_collection' and
				k ~= 'degrade_hashname' and
				k ~= 'complexion_1' and
				k ~= 'complexion_2' and
				k ~= 'sun_1' and
				k ~= 'sun_2' and
				k ~= 'moles_1' and
				k ~= 'moles_2' and
				k ~= 'chest_1' and
				k ~= 'chest_2' and
				k ~= 'chest_3' and
				k ~= 'bodyb_1' and
				k ~= 'bodyb_2'
			then
				Character[k] = v
			end
		end
	end

	-- TODO: Rework avec une meilleurs logique pour l'optimisation. Actuellement toute les valeur son refresh dès qu'une valeur est changer, c'est super mauvais niveau performance (Exemple le coiffeur, la variantion d'opacité de la barbe fait monté le script à 4ms)


	SetPedComponentVariation(playerPed, 8, Character['tshirt_1'], Character['tshirt_2'], 2) -- Tshirt
	SetPedComponentVariation(playerPed, 11, Character['torso_1'], Character['torso_2'], 2) -- torso parts
	SetPedComponentVariation(playerPed, 3, Character['arms'], Character['arms_2'], 2) -- Amrs
	SetPedComponentVariation(playerPed, 10, Character['decals_1'], Character['decals_2'], 2) -- decals
	SetPedComponentVariation(playerPed, 4, Character['pants_1'], Character['pants_2'], 2) -- pants
	SetPedComponentVariation(playerPed, 6, Character['shoes_1'], Character['shoes_2'], 2) -- shoes
	SetPedComponentVariation(playerPed, 1, Character['mask_1'], Character['mask_2'], 2) -- mask
	SetPedComponentVariation(playerPed, 9, Character['bproof_1'], Character['bproof_2'], 2) -- bulletproof
	SetPedComponentVariation(playerPed, 7, Character['chain_1'], Character['chain_2'], 2) -- chain
	SetPedComponentVariation(playerPed, 5, Character['bags_1'], Character['bags_2'], 2) -- Bag

	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2) -- Helmet
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2) -- Glasses
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex(playerPed, 6, Character['watches_1'], Character['watches_2'], 2) -- Watches
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed, 7)
	else
		SetPedPropIndex(playerPed, 7, Character['bracelets_1'], Character['bracelets_2'], 2) -- Bracelets
	end

	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2) -- Ears Accessories
	end

	if not freezeface then
		local Face = { 
			[0] = 'nose_1', 
			[1] = 'nose_2', 
			[2] = 'nose_3', 
			[3] = 'nose_4', 
			[4] = 'nose_5', 
			[5] = 'nose_6',
			[6] = 'eyebrows_5', 
			[7] = 'eyebrows_6', 
			[8] = 'cheeks_2', 
			[9] = 'cheeks_1', 
			[10] = 'cheeks_3', 
			[11] = 'eye_open',
			[12] = 'lips_thick', 
			[13] = 'jaw_1', 
			[14] = 'jaw_2', 
			[15] = 'chin_height', 
			[16] = 'chin_lenght', 
			[17] = 'chin_width',
			[18] = 'chin_hole', 
			[19] = 'neck_thick' 
		}

		for k, v in pairs(Face) do
			if Character[v] then
				SetPedFaceFeature(PlayerPedId(), k, Character[v])
			end
		end
	end

	if p:skin().sex > 1 then 
		return
	end

	if not freezeface then
		SetPedHeadBlendData(playerPed, Character['dad'], Character['mom'], nil, Character['dad'], Character['mom'], nil,Character['face'], Character['skin'], nil, true)
		SetPedComponentVariation(playerPed, 0, Character['head'], Character['head_2'], 2) -- Hair
	end

	SetPedHairColor(playerPed, Character['hair_color_1'], Character['hair_color_2']) -- Hair Color
	SetPedHeadOverlay(playerPed, 3, Character['age_1'], (Character['age_2'] / 10) + 0.0) -- Age + opacity
	SetPedHeadOverlay(playerPed, 0, Character['blemishes_1'], (Character['blemishes_2'] / 10) + 0.0) -- Blemishes + opacity
	SetPedHeadOverlay(playerPed, 1, Character['beard_1'], (Character['beard_2'] / 10) + 0.0) -- Beard + opacity
	SetPedEyeColor(playerPed, Character['eye_color'], 0, 1) -- Eyes color
	SetPedHeadOverlay(playerPed, 2, Character['eyebrows_1'], (Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
	SetPedHeadOverlay(playerPed, 4, Character['makeup_1'], (Character['makeup_2'] / 10) + 0.0) -- Makeup + opacity
	SetPedHeadOverlay(playerPed, 8, Character['lipstick_1'], (Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
	if Character["secondhair"] and Character["secondhair"] ~= 0 then
		SetPedComponentVariation(playerPed, 2, Character['secondhair'], Character['hair_2'], 2) -- Second Hair (pince)
	else
		SetPedComponentVariation(playerPed, 2, Character['hair_1'], Character['hair_2'], 2) -- Hair
	end
	SetPedHeadOverlayColor(playerPed, 1, 1, Character['beard_3'], Character['beard_4']) -- Beard Color
	SetPedHeadOverlayColor(playerPed, 2, 1, Character['eyebrows_3'], Character['eyebrows_4']) -- Eyebrows Color
	SetPedHeadOverlayColor(playerPed, 4, 1, Character['makeup_3'], Character['makeup_4']) -- Makeup Color
	SetPedHeadOverlayColor(playerPed, 8, 1, Character['lipstick_3'], Character['lipstick_4']) -- Lipstick Color
	SetPedHeadOverlay(playerPed, 5, Character['blush_1'], (Character['blush_2'] / 10) + 0.0) -- Blush + opacity
	SetPedHeadOverlayColor(playerPed, 5, 2, Character['blush_3']) -- Blush Color
	SetPedHeadOverlay(playerPed, 6, Character['complexion_1'], (Character['complexion_2'] / 10) + 0.0) -- Complexion + opacity
	SetPedHeadOverlay(playerPed, 7, Character['sun_1'], (Character['sun_2'] / 10) + 0.0) -- Sun Damage + opacity
	SetPedHeadOverlay(playerPed, 9, Character['moles_1'], (Character['moles_2'] / 10) + 0.0) -- Moles/Freckles + opacity
	SetPedHeadOverlay(playerPed, 10, Character['chest_1'], (Character['chest_2'] / 10) + 0.0) -- Chest Hair + opacity
	SetPedHeadOverlayColor(playerPed, 10, 1, Character['chest_3']) -- Torso Color
	SetPedHeadOverlay(playerPed, 11, Character['bodyb_1'], (Character['bodyb_2'] / 10) + 0.0) -- Body Blemishes + opacity

	ClearPedDecorations(PlayerPedId())
	ClearGradender()
	AddPedDecorationFromHashes(playerPed, Character['degrade_collection'], Character['degrade_hashname'])
end

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
	LoadDefaultModel(loadMale, cb)
end)

AddEventHandler('skinchanger:getData', function(cb)
	local components = json.decode(json.encode(Components))
	for k, v in pairs(Character) do
		for i = 1, #components, 1 do
			if k == components[i].name then
				components[i].value = v
			end
		end
	end

	cb(components, GetMaxVals())
end)

AddEventHandler('skinchanger:change', function(key, val, freezeface)
	Character[key] = val

	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', Character)
	else
		ApplySkin(Character, nil, freezeface)
	end
end)

AddEventHandler('skinchanger:changeNoEffect', function(key, val)
	Character[key] = val

	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', Character)
	end
end)

function SkinChangeFake(key, val, feezeface)
	fakeCharacter[key] = val
	ApplySkinFake(fakeCharacter, val, feezeface)
end

function SkinChangeFakePed(ped, key, val, freezeface)
	fakeCharacter[key] = val
	ApplySkinOnAPed(ped, fakeCharacter, val, freezeface)
end

function ResetFakeChange()
	fakeCharacter = {}
end

function GetFakeSkin()
	return fakeCharacter
end

function SkinChangerChange(key, val, freezeface)
	Character[key] = val

	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', Character)
	else
		ApplySkin(Character, nil, freezeface)
	end
end

AddEventHandler('skinchanger:getSkin', function(cb)
	cb(Character)
end)

function SkinChangerGetSkin()
	return Character
end

AddEventHandler('skinchanger:modelLoaded', function()
	ClearPedProp(PlayerPedId(), 0)

	if LoadSkin ~= nil then
		ApplySkin(LoadSkin)
		LoadSkin = nil
	end

	if LoadClothes ~= nil then
		ApplySkin(LoadClothes.playerSkin, LoadClothes.clothesSkin)
		LoadClothes = nil
	end
	cleanPlayer()
	-- cleanGradenderPlayer()
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	if skin['sex'] ~= LastSex then
		LoadSkin = skin

		if skin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', 0, cb)
		elseif skin['sex'] == 1 then
			TriggerEvent('skinchanger:loadDefaultModel', 1, cb)
		elseif skin['sex'] ~= 1 and skin['sex'] ~= 0 then
			TriggerEvent('skinchanger:loadDefaultModel', skin['sex'], cb)
		end
	else
		ApplySkin(skin)

		if cb ~= nil then
			cb()
		end
	end

	LastSex = skin['sex']
end)

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(playerSkin, clothesSkin)
	if playerSkin['sex'] ~= LastSex then
		LoadClothes = {
			playerSkin = playerSkin,
			clothesSkin = clothesSkin
		}

		if playerSkin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', 0)
		elseif playerSkin['sex'] == 1 then
			TriggerEvent('skinchanger:loadDefaultModel', 1)
		elseif playerSkin['sex'] ~= 0 and playerSkin['sex'] ~= 1 then
			TriggerEvent('skinchanger:loadDefaultModel', playerSkin['sex'])
		end
	else
		ApplySkin(playerSkin, clothesSkin)
	end

	LastSex = playerSkin['sex']
end)

function ApplySkinF(skin)
	local playerPed = PlayerPedId()

	for k, v in pairs(skin) do
		Character[k] = v
	end

	SetPedHeadBlendData(playerPed, Character['dad'], Character['mom'], nil, Character['dad'], Character['mom'], nil,
		Character['face'], Character['skin'], nil, true)
	SetPedComponentVariation(playerPed, 0, Character['head'], Character['head_2'], 2) -- Hair
	local Face = { [0] = 'nose_1', [1] = 'nose_2', [2] = 'nose_3', [3] = 'nose_4', [4] = 'nose_5', [5] = 'nose_6',
		[6] = 'eyebrows_5', [7] = 'eyebrows_6', [8] = 'cheeks_2', [9] = 'cheeks_1', [10] = 'cheeks_3', [11] = 'eye_open',
		[12] = 'lips_thick', [13] = 'jaw_1', [14] = 'jaw_2', [15] = 'chin_height', [16] = 'chin_lenght', [17] = 'chin_width',
		[18] = 'chin_hole', [19] = 'neck_thick' }

	for k, v in pairs(Face) do
		if Character[v] then
			SetPedFaceFeature(PlayerPedId(), k, Character[v])
		end
	end
	SetPedHairColor(playerPed, Character['hair_color_1'], Character['hair_color_2']) -- Hair Color
	SetPedHeadOverlay(playerPed, 3, Character['age_1'], (Character['age_2'] / 10) + 0.0) -- Age + opacity
	SetPedHeadOverlay(playerPed, 1, Character['beard_1'], (Character['beard_2'] / 10) + 0.0) -- Beard + opacity
	SetPedEyeColor(playerPed, Character['eye_color'], 0, 1) -- Eyes color
	SetPedHeadOverlay(playerPed, 2, Character['eyebrows_1'], (Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
	SetPedHeadOverlay(playerPed, 4, Character['makeup_1'], (Character['makeup_2'] / 10) + 0.0) -- Makeup + opacity
	SetPedHeadOverlay(playerPed, 8, Character['lipstick_1'], (Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
	if Character["secondhair"] and Character["secondhair"] ~= 0 then
		SetPedComponentVariation(playerPed, 2, Character['secondhair'], Character['hair_2'], 2) -- Second Hair (pince)
	else
		SetPedComponentVariation(playerPed, 2, Character['hair_1'], Character['hair_2'], 2) -- Hair
	end
	SetPedHeadOverlayColor(playerPed, 1, 1, Character['beard_3'], Character['beard_4']) -- Beard Color
	SetPedHeadOverlayColor(playerPed, 2, 1, Character['eyebrows_3'], Character['eyebrows_4']) -- Eyebrows Color
	SetPedHeadOverlayColor(playerPed, 4, 1, Character['makeup_3'], Character['makeup_4']) -- Makeup Color
	SetPedHeadOverlayColor(playerPed, 8, 1, Character['lipstick_3'], Character['lipstick_4']) -- Lipstick Color
	SetPedHeadOverlay(playerPed, 5, Character['blush_1'], (Character['blush_2'] / 10) + 0.0) -- Blush + opacity
	SetPedHeadOverlayColor(playerPed, 5, 2, Character['blush_3']) -- Blush Color
	SetPedHeadOverlay(playerPed, 6, Character['complexion_1'], (Character['complexion_2'] / 10) + 0.0) -- Complexion + opacity
	SetPedHeadOverlay(playerPed, 7, Character['sun_1'], (Character['sun_2'] / 10) + 0.0) -- Sun Damage + opacity
	SetPedHeadOverlay(playerPed, 9, Character['moles_1'], (Character['moles_2'] / 10) + 0.0) -- Moles/Freckles + opacity
	SetPedHeadOverlay(playerPed, 10, Character['chest_1'], (Character['chest_2'] / 10) + 0.0) -- Chest Hair + opacity
	SetPedHeadOverlayColor(playerPed, 10, 1, Character['chest_3']) -- Torso Color
	SetPedHeadOverlay(playerPed, 11, Character['bodyb_1'], (Character['bodyb_2'] / 10) + 0.0) -- Body Blemishes + opacity
	AddPedDecorationFromHashes(playerPed, Character['degrade_collection'], Character['degrade_hashname'])

	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2) -- Ears Accessories
	end

	SetPedComponentVariation(playerPed, 8, Character['tshirt_1'], Character['tshirt_2'], 2) -- Tshirt
	SetPedComponentVariation(playerPed, 11, Character['torso_1'], Character['torso_2'], 2) -- torso parts
	SetPedComponentVariation(playerPed, 3, Character['arms'], Character['arms_2'], 2) -- Amrs
	SetPedComponentVariation(playerPed, 10, Character['decals_1'], Character['decals_2'], 2) -- decals
	SetPedComponentVariation(playerPed, 4, Character['pants_1'], Character['pants_2'], 2) -- pants
	SetPedComponentVariation(playerPed, 6, Character['shoes_1'], Character['shoes_2'], 2) -- shoes
	SetPedComponentVariation(playerPed, 1, Character['mask_1'], Character['mask_2'], 2) -- mask
	SetPedComponentVariation(playerPed, 9, Character['bproof_1'], Character['bproof_2'], 2) -- bulletproof
	SetPedComponentVariation(playerPed, 7, Character['chain_1'], Character['chain_2'], 2) -- chain
	SetPedComponentVariation(playerPed, 5, Character['bags_1'], Character['bags_2'], 2) -- Bag

	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2) -- Helmet
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2) -- Glasses
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex(playerPed, 6, Character['watches_1'], Character['watches_2'], 2) -- Watches
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed, 7)
	else
		SetPedPropIndex(playerPed, 7, Character['bracelets_1'], Character['bracelets_2'], 2) -- Bracelets
	end
end

function ApplySkinFake(skin, info, feezeface, ismask)
	local playerPed = PlayerPedId()

	for k, v in pairs(skin) do
		fakeCharacter[k] = v
	end
	if fakeCharacter['ears_1'] then
		if fakeCharacter['ears_1'] == -1 then
			ClearPedProp(playerPed, 2)
		else
			SetPedPropIndex(playerPed, 2, fakeCharacter['ears_1'], fakeCharacter['ears_2'], 2) -- Ears Accessories
		end
	end
	if not feezeface or ismask then
		if info ~= nil then
			if feezeface then
				SetPedHeadBlendData(playerPed, fakeCharacter['head'], fakeCharacter['head'], nil, fakeCharacter['dad'],
					fakeCharacter['mom'], nil,
					fakeCharacter['face'], fakeCharacter['skin'], nil, true)
				SetPedComponentVariation(playerPed, 0, fakeCharacter['head'], fakeCharacter['head_2'], 2) -- head
			end
			if ismask then
				local Face = { [0] = 'nose_1', [1] = 'nose_2', [2] = 'nose_3', [3] = 'nose_4', [4] = 'nose_5', [5] = 'nose_6',
				[6] = 'eyebrows_5', [7] = 'eyebrows_6', [8] = 'cheeks_2', [9] = 'cheeks_1', [10] = 'cheeks_3', [11] = 'eye_open',
				[12] = 'lips_thick', [13] = 'jaw_1', [14] = 'jaw_2', [15] = 'chin_height', [16] = 'chin_lenght', [17] = 'chin_width',
				[18] = 'chin_hole', [19] = 'neck_thick' }
				for k, v in pairs(Face) do
					if fakeCharacter[v] then
						SetPedFaceFeature(PlayerPedId(), k, 0.0)
					end
				end
			end
		end
	end

	-- SetPedHeadBlendData(playerPed, fakeCharacter['face'], fakeCharacter['face'], nil, fakeCharacter['face'], fakeCharacter['skin'], nil,
	-- fakeCharacter['skin'], fakeCharacter['skin'], nil, true)


	SetPedHeadOverlay(playerPed, 3, fakeCharacter['age_1'], (fakeCharacter['age_2'] / 10) + 0.0) -- Age + opacity

	if fakeCharacter["secondhair"] and fakeCharacter["secondhair"] ~= 0 then
		SetPedComponentVariation(playerPed, 2, fakeCharacter['secondhair'], fakeCharacter['hair_2'], 2) -- Second Hair (pince)
	else
		SetPedComponentVariation(playerPed, 2, fakeCharacter['hair_1'], fakeCharacter['hair_2'], 2) -- Hair
	end
	SetPedHeadOverlay(playerPed, 8, fakeCharacter['lipstick_1'], (fakeCharacter['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
	SetPedHeadOverlayColor(playerPed, 8, 1, fakeCharacter['lipstick_3'], fakeCharacter['lipstick_4']) -- Lipstick Color
	SetPedHairColor(playerPed, fakeCharacter['hair_color_1'], fakeCharacter['hair_color_2']) -- Hair Color
	SetPedHeadOverlay(playerPed, 1, fakeCharacter['beard_1'], (fakeCharacter['beard_2'] / 10) + 0.0) -- Beard + opacity
	SetPedEyeColor(playerPed, fakeCharacter['eye_color'], 0, 1) -- Eyes color
	SetPedHeadOverlayColor(playerPed, 1, 1, fakeCharacter['beard_3'], fakeCharacter['beard_4']) -- Beard Color
	SetPedHeadOverlay(playerPed, 4, fakeCharacter['makeup_1'], (fakeCharacter['makeup_2'] / 10) + 0.0) -- Makeup + opacity
	SetPedHeadOverlayColor(playerPed, 4, 1, fakeCharacter['makeup_3'], fakeCharacter['makeup_4']) -- Makeup Color
	SetPedHeadOverlay(playerPed, 2, fakeCharacter['eyebrows_1'], (fakeCharacter['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity

	SetPedComponentVariation(playerPed, 8, fakeCharacter['tshirt_1'], fakeCharacter['tshirt_2'], 2) -- Tshirt
	SetPedComponentVariation(playerPed, 11, fakeCharacter['torso_1'], fakeCharacter['torso_2'], 2) -- torso parts
	SetPedComponentVariation(playerPed, 3, fakeCharacter['arms'], fakeCharacter['arms_2'], 2) -- Amrs
	SetPedComponentVariation(playerPed, 10, fakeCharacter['decals_1'], fakeCharacter['decals_2'], 2) -- decals
	SetPedComponentVariation(playerPed, 4, fakeCharacter['pants_1'], fakeCharacter['pants_2'], 2) -- pants
	SetPedComponentVariation(playerPed, 6, fakeCharacter['shoes_1'], fakeCharacter['shoes_2'], 2) -- shoes
	SetPedComponentVariation(playerPed, 1, fakeCharacter['mask_1'], fakeCharacter['mask_2'], 2) -- mask
	SetPedComponentVariation(playerPed, 9, fakeCharacter['bproof_1'], fakeCharacter['bproof_2'], 2) -- bulletproof
	SetPedComponentVariation(playerPed, 7, fakeCharacter['chain_1'], fakeCharacter['chain_2'], 2) -- chain
	SetPedComponentVariation(playerPed, 5, fakeCharacter['bags_1'], fakeCharacter['bags_2'], 2) -- Bag
	SetPedHeadOverlay(playerPed, 10, fakeCharacter['chest_1'], (fakeCharacter['chest_2'] / 10) + 0.0) -- Chest Hair + opacity
	SetPedHeadOverlay(playerPed, 5, fakeCharacter['blush_1'], (fakeCharacter['blush_2'] / 10) + 0.0) -- Blush + opacity
	SetPedHeadOverlayColor(playerPed, 5, 2, fakeCharacter['blush_3']) -- Blush Color
	AddPedDecorationFromHashes(playerPed, fakeCharacter['degrade_collection'], fakeCharacter['degrade_hashname'])
	SetPedHeadOverlayColor(playerPed, 2, 1, fakeCharacter['eyebrows_3'], fakeCharacter['eyebrows_4']) -- Eyebrows Color
	SetPedHeadOverlayColor(playerPed, 10, 1, fakeCharacter['chest_3']) -- Torso Color

	if fakeCharacter['helmet_1'] then
		if fakeCharacter['helmet_1'] == -1 then
			ClearPedProp(playerPed, 0)
		else
			SetPedPropIndex(playerPed, 0, fakeCharacter['helmet_1'], fakeCharacter['helmet_2'], 2) -- Helmet
		end
	end

	if fakeCharacter['glasses_1'] then
		if fakeCharacter['glasses_1'] == -1 then
			ClearPedProp(playerPed, 1)
		else
			SetPedPropIndex(playerPed, 1, fakeCharacter['glasses_1'], fakeCharacter['glasses_2'], 2) -- Glasses
		end
	end

	if fakeCharacter['watches_1'] then
		if fakeCharacter['watches_1'] == -1 then
			ClearPedProp(playerPed, 6)
		else
			SetPedPropIndex(playerPed, 6, fakeCharacter['watches_1'], fakeCharacter['watches_2'], 2) -- Watches
		end
	end

	if fakeCharacter['bracelets_1'] then
		if fakeCharacter['bracelets_1'] == -1 then
			ClearPedProp(playerPed, 7)
		else
			SetPedPropIndex(playerPed, 7, fakeCharacter['bracelets_1'], fakeCharacter['bracelets_2'], 2) -- Bracelets
		end
	end
end

function ApplySkinOnAPed(ped, skin, info, feezeface)
	local playerPed = ped

	for k, v in pairs(skin) do
		fakeCharacter[k] = v
	end
	if fakeCharacter['ears_1'] then
		if fakeCharacter['ears_1'] == -1 then
			ClearPedProp(playerPed, 2)
		else
			SetPedPropIndex(playerPed, 2, fakeCharacter['ears_1'], fakeCharacter['ears_2'], 2) -- Ears Accessories
		end
	end
	if not feezeface or ismask then
		if info ~= nil then
			if feezeface then
				SetPedHeadBlendData(playerPed, fakeCharacter['head'], fakeCharacter['head'], nil, fakeCharacter['dad'],
					fakeCharacter['mom'], nil,
					fakeCharacter['face'], fakeCharacter['skin'], nil, true)
				SetPedComponentVariation(playerPed, 0, fakeCharacter['head'], fakeCharacter['head_2'], 2) -- head
			end
			if ismask then
				local Face = { [0] = 'nose_1', [1] = 'nose_2', [2] = 'nose_3', [3] = 'nose_4', [4] = 'nose_5', [5] = 'nose_6',
				[6] = 'eyebrows_5', [7] = 'eyebrows_6', [8] = 'cheeks_2', [9] = 'cheeks_1', [10] = 'cheeks_3', [11] = 'eye_open',
				[12] = 'lips_thick', [13] = 'jaw_1', [14] = 'jaw_2', [15] = 'chin_height', [16] = 'chin_lenght', [17] = 'chin_width',
				[18] = 'chin_hole', [19] = 'neck_thick' }
				for k, v in pairs(Face) do
					if fakeCharacter[v] then
						SetPedFaceFeature(PlayerPedId(), k, 0.0)
					end
				end
			end
		end
	end

	-- SetPedHeadBlendData(playerPed, fakeCharacter['face'], fakeCharacter['face'], nil, fakeCharacter['face'], fakeCharacter['skin'], nil,
	-- fakeCharacter['skin'], fakeCharacter['skin'], nil, true)


	SetPedHeadOverlay(playerPed, 3, fakeCharacter['age_1'], (fakeCharacter['age_2'] / 10) + 0.0) -- Age + opacity

	if fakeCharacter["secondhair"] and fakeCharacter["secondhair"] ~= 0 then
		SetPedComponentVariation(playerPed, 2, fakeCharacter['secondhair'], fakeCharacter['hair_2'], 2) -- Second Hair (pince)
	else
		SetPedComponentVariation(playerPed, 2, fakeCharacter['hair_1'], fakeCharacter['hair_2'], 2) -- Hair
	end
	SetPedHeadOverlay(playerPed, 8, fakeCharacter['lipstick_1'], (fakeCharacter['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
	SetPedHeadOverlayColor(playerPed, 8, 1, fakeCharacter['lipstick_3'], fakeCharacter['lipstick_4']) -- Lipstick Color
	SetPedHairColor(playerPed, fakeCharacter['hair_color_1'], fakeCharacter['hair_color_2']) -- Hair Color
	SetPedHeadOverlay(playerPed, 1, fakeCharacter['beard_1'], (fakeCharacter['beard_2'] / 10) + 0.0) -- Beard + opacity
	SetPedEyeColor(playerPed, fakeCharacter['eye_color'], 0, 1) -- Eyes color
	SetPedHeadOverlayColor(playerPed, 1, 1, fakeCharacter['beard_3'], fakeCharacter['beard_4']) -- Beard Color
	SetPedHeadOverlay(playerPed, 4, fakeCharacter['makeup_1'], (fakeCharacter['makeup_2'] / 10) + 0.0) -- Makeup + opacity
	SetPedHeadOverlayColor(playerPed, 4, 1, fakeCharacter['makeup_3'], fakeCharacter['makeup_4']) -- Makeup Color
	SetPedHeadOverlay(playerPed, 2, fakeCharacter['eyebrows_1'], (fakeCharacter['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity

	SetPedComponentVariation(playerPed, 8, fakeCharacter['tshirt_1'], fakeCharacter['tshirt_2'], 2) -- Tshirt
	SetPedComponentVariation(playerPed, 11, fakeCharacter['torso_1'], fakeCharacter['torso_2'], 2) -- torso parts
	SetPedComponentVariation(playerPed, 3, fakeCharacter['arms'], fakeCharacter['arms_2'], 2) -- Amrs
	SetPedComponentVariation(playerPed, 10, fakeCharacter['decals_1'], fakeCharacter['decals_2'], 2) -- decals
	SetPedComponentVariation(playerPed, 4, fakeCharacter['pants_1'], fakeCharacter['pants_2'], 2) -- pants
	SetPedComponentVariation(playerPed, 6, fakeCharacter['shoes_1'], fakeCharacter['shoes_2'], 2) -- shoes
	SetPedComponentVariation(playerPed, 1, fakeCharacter['mask_1'], fakeCharacter['mask_2'], 2) -- mask
	SetPedComponentVariation(playerPed, 9, fakeCharacter['bproof_1'], fakeCharacter['bproof_2'], 2) -- bulletproof
	SetPedComponentVariation(playerPed, 7, fakeCharacter['chain_1'], fakeCharacter['chain_2'], 2) -- chain
	SetPedComponentVariation(playerPed, 5, fakeCharacter['bags_1'], fakeCharacter['bags_2'], 2) -- Bag
	SetPedHeadOverlay(playerPed, 10, fakeCharacter['chest_1'], (fakeCharacter['chest_2'] / 10) + 0.0) -- Chest Hair + opacity
	SetPedHeadOverlay(playerPed, 5, fakeCharacter['blush_1'], (fakeCharacter['blush_2'] / 10) + 0.0) -- Blush + opacity
	SetPedHeadOverlayColor(playerPed, 5, 2, fakeCharacter['blush_3']) -- Blush Color
	AddPedDecorationFromHashes(playerPed, fakeCharacter['degrade_collection'], fakeCharacter['degrade_hashname'])
	SetPedHeadOverlayColor(playerPed, 2, 1, fakeCharacter['eyebrows_3'], fakeCharacter['eyebrows_4']) -- Eyebrows Color
	SetPedHeadOverlayColor(playerPed, 10, 1, fakeCharacter['chest_3']) -- Torso Color

	if fakeCharacter['helmet_1'] then
		if fakeCharacter['helmet_1'] == -1 then
			ClearPedProp(playerPed, 0)
		else
			SetPedPropIndex(playerPed, 0, fakeCharacter['helmet_1'], fakeCharacter['helmet_2'], 2) -- Helmet
		end
	end

	if fakeCharacter['glasses_1'] then
		if fakeCharacter['glasses_1'] == -1 then
			ClearPedProp(playerPed, 1)
		else
			SetPedPropIndex(playerPed, 1, fakeCharacter['glasses_1'], fakeCharacter['glasses_2'], 2) -- Glasses
		end
	end

	if fakeCharacter['watches_1'] then
		if fakeCharacter['watches_1'] == -1 then
			ClearPedProp(playerPed, 6)
		else
			SetPedPropIndex(playerPed, 6, fakeCharacter['watches_1'], fakeCharacter['watches_2'], 2) -- Watches
		end
	end

	if fakeCharacter['bracelets_1'] then
		if fakeCharacter['bracelets_1'] == -1 then
			ClearPedProp(playerPed, 7)
		else
			SetPedPropIndex(playerPed, 7, fakeCharacter['bracelets_1'], fakeCharacter['bracelets_2'], 2) -- Bracelets
		end
	end
end