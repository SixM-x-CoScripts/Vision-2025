weaponsConfig = {
	{
		name = 'WEAPON_KNIFE',
		label = 'weapon_knife',
		components = {}
	},
    {
		name = 'WEAPON_NIGHTSTICK',
		label = 'weapon_nightstick',
		components = {}
	},
    {
		name = 'WEAPON_HAMMER',
		label = 'weapon_hammer',
		components = {}
	},
    {
		name = 'WEAPON_BAT',
		label = 'weapon_bat',
		components = {}
	},
    {
		name = 'WEAPON_GOLFCLUB',
		label = 'weapon_golfclub',
		components = {}
	},
    {
		name = 'WEAPON_CROWBAR',
		label = 'weapon_crowbar',
		components = {}
	},
    {
		name = 'WEAPON_PISTOL',
		label = 'weapon_pistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_PISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_PISTOL_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_PISTOL_VARMOD_LUXE') }
		}
	},
	{
		name = 'WEAPON_PISTOL_MK2',
		label = 'weapon_pistol_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_INCENDIARY') },
			{ name = 'hollow_point_rounds', label = 'component_hollow_point_rounds', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_FMJ') },
			{ name = 'mounted_scope', label = 'component_mounted_scope', hash = GetHashKey('COMPONENT_AT_PI_RAIL') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH_02') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
			{ name = 'compensator', label = 'component_compensator', hash = GetHashKey('COMPONENT_AT_PI_COMP') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_IND_01') },
			{ name = 'digital_camo_slide', label = 'component_digital_camo_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_SLIDE') },
			{ name = 'digital_camo_02_slide', label = 'component_digital_camo_02_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_02_SLIDE') },
			{ name = 'digital_camo_03_slide', label = 'component_digital_camo_03_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_03_SLIDE') },
			{ name = 'digital_camo_04_slide', label = 'component_digital_camo_04_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_04_SLIDE') },
			{ name = 'digital_camo_05_slide', label = 'component_digital_camo_05_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_05_SLIDE') },
			{ name = 'digital_camo_06_slide', label = 'component_digital_camo_06_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_06_SLIDE') },
			{ name = 'digital_camo_07_slide', label = 'component_digital_camo_07_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_07_SLIDE') },
			{ name = 'digital_camo_08_slide', label = 'component_digital_camo_08_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_08_SLIDE') },
			{ name = 'digital_camo_09_slide', label = 'component_digital_camo_09_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_09_SLIDE') },
			{ name = 'digital_camo_10_slide', label = 'component_digital_camo_10_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_10_SLIDE') },
			{ name = 'patriotic_slide', label = 'component_patriotic_slide', hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE') }

		}
	},
	{
		name = 'WEAPON_COMBATPISTOL',
		label = 'weapon_combatpistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER') }
		}
    },
    {
		name = 'WEAPON_APPISTOL',
		label = 'weapon_appistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_APPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_APPISTOL_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_APPISTOL_VARMOD_LUXE') }
		}
	},
    {
		name = 'WEAPON_PISTOL50',
		label = 'weapon_pistol50',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_PISTOL50_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_PISTOL50_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_PISTOL50_VARMOD_LUXE') }
		}
	},
    {
		name = 'WEAPON_REVOLVER',
		label = 'weapon_revolver',
		components = {}
	},
    {
		name = 'WEAPON_SNSPISTOL',
		label = 'weapon_snspistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_SNSPISTOL_VARMOD_LOWRIDER') }
		}
	},
	{
		name = 'WEAPON_SNSPISTOL_MK2',
		label = 'weapon_snspistol_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY') },
			{ name = 'hollow_point_rounds', label = 'component_hollow_point_rounds', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_FMJ') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH_03') },
			{ name = 'mounted_scope', label = 'component_mounted_scope', hash = GetHashKey('COMPONENT_AT_PI_RAIL_02') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP_02') },
			{ name = 'compensator', label = 'component_compensator', hash = GetHashKey('COMPONENT_AT_PI_COMP_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_IND_01') },
			{ name = 'digital_camo_slide', label = 'component_digital_camo_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE') },
			{ name = 'brushstroke_camo_slide', label = 'component_brushstroke_camo_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE') },
			{ name = 'woodland_camo_slide', label = 'component_woodland_camo_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE') },
			{ name = 'skull_slide', label = 'component_skull_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE') },
			{ name = 'sessanta_nove_slide', label = 'component_sessanta_nove_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE') },
			{ name = 'perseus_slide', label = 'component_perseus_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE') },
			{ name = 'leopard_slide', label = 'component_leopard_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE') },
			{ name = 'zebra_slide', label = 'component_zebra_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE') },
			{ name = 'geometric_slide', label = 'component_geometric_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE') },
			{ name = 'boom_slide', label = 'component_boom_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE') },
			{ name = 'patriotic_slide', label = 'component_patriotic_slide', hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE') }
		}
	},
    {
		name = 'WEAPON_HEAVYPISTOL',
		label = 'weapon_heavypistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_HEAVYPISTOL_VARMOD_LUXE') }
		}
	},
	{
		name = 'WEAPON_REVOLVER_MK2',
		label = 'weapon_revolver_mk2',
		components = {
			{ name = 'default_rounds', label = 'component_default_rounds', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_01') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY') },
			{ name = 'hollow_point_rounds', label = 'component_hollow_point_rounds', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_FMJ') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'compensator', label = 'component_compensator', hash = GetHashKey('COMPONENT_AT_PI_COMP_03') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_IND_01') }
		}
	},
    {
		name = 'WEAPON_VINTAGEPISTOL',
		label = 'weapon_vintagepistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_02') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},
	{
		name = 'weapon_ceramicpistol',
		label = 'weapon_ceramicpistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_CERAMICPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_CERAMICPISTOL_CLIP_02') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_CERAMICPISTOL_SUPP') }
		}
	},
    {
		name = 'WEAPON_MICROSMG',
		label = 'weapon_microsmg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_MICROSMG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_MICROSMG_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_PI_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_MICROSMG_VARMOD_LUXE') }
		}
	},
    {
		name = 'WEAPON_SMG',
		label = 'weapon_smg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_SMG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_SMG_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_SMG_CLIP_03') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_SMG_VARMOD_LUXE') }
		}
	},
	{
		name = 'WEAPON_SMG_MK2',
		label = 'weapon_smg_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_INCENDIARY') },
			{ name = 'hollow_point_rounds', label = 'component_hollow_point_rounds', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_FMJ') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS_SMG') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2') },
			{ name = 'medium_scope', label = 'component_medium_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_SMG_MK2') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_SB_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_SB_BARREL_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_ASSAULTSMG',
		label = 'weapon_assaultsmg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER') }
		}
	},
    {
		name = 'WEAPON_MINISMG',
		label = 'weapon_minismg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_MINISMG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_MINISMG_CLIP_02') }
		}
	},
    {
		name = 'WEAPON_MACHINEPISTOL',
		label = 'weapon_machinepistol',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_03') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_PI_SUPP') }
		}
	},
    {
		name = 'WEAPON_COMBATPDW',
		label = 'weapon_combatpdw',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_03') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') }
		}
	},
	{
		name = 'WEAPON_PUMPSHOTGUN',
		label = 'weapon_pumpshotgun',
		components = {
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_SR_SUPP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER') }
		}
	},
	{
		name = 'WEAPON_PUMPSHOTGUN_MK2',
		label = 'weapon_pumpshotgun_mk2',
		components = {
			{ name = 'default_shells', label = 'component_default_shells', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_01') },
			{ name = 'dragons_breath_shells', label = 'component_dragons_breath_shells', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY') },
			{ name = 'steel_buckshot_shells', label = 'component_steel_buckshot_shells', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING') },
			{ name = 'flechette_shells', label = 'component_flechette_shells', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT') },
			{ name = 'explosive_slugs', label = 'component_explosive_slugs', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2') },
			{ name = 'medium_scope', label = 'component_medium_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_SR_SUPP_03') },
			{ name = 'squared_muzzle_brake', label = 'component_squared_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_08') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_SAWNOFFSHOTGUN',
		label = 'weapon_sawnoffshotgun',
		components = {
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE') }
		}
	},
    {
		name = 'WEAPON_ASSAULTSHOTGUN',
		label = 'weapon_assaultshotgun',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},
    {
		name = 'WEAPON_BULLPUPSHOTGUN',
		label = 'weapon_bullpupshotgun',
		components = {
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},
    {
		name = 'WEAPON_HEAVYSHOTGUN',
		label = 'weapon_heavyshotgun',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_03') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') }
		}
	},
    {
		name = 'WEAPON_ASSAULTRIFLE',
		label = 'weapon_assaultrifle',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE') }
		}
	},
	{
		name = 'WEAPON_ASSAULTRIFLE_MK2',
		label = 'weapon_assaultrifle_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2') },
			{ name = 'large_scope', label = 'component_large_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_AR_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_AR_BARREL_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01') }

		}
    },
	{
		name = 'WEAPON_HEAVYRIFLE',
		label = 'weapon_heavyrifle',
		components = {
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_HEAVYRIFLE_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'Families Finish', label = 'Families Finish', hash = GetHashKey('COMPONENT_HEAVYRIFLE_CAMO1') },
		}
	},
    {
		name = 'WEAPON_CARBINERIFLE',
		label = 'weapon_carbinerifle',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02') },
			{ name = 'clip_box', label = 'component_clip_box', hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE') }
		}
	},
	{
		name = 'WEAPON_CARBINERIFLE_MK2',
		label = 'weapon_carbinerifle_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2') },
			{ name = 'large_scope', label = 'component_large_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_CR_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_CR_BARREL_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_ADVANCEDRIFLE',
		label = 'weapon_advancedrifle',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE') }
		}
	},
    {
		name = 'WEAPON_SPECIALCARBINE',
		label = 'weapon_specialcarbine',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_03') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER') }
		}
	},
	{
		name = 'WEAPON_SPECIALCARBINE_MK2',
		label = 'weapon_specialcarbine_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2') },
			{ name = 'large_scope', label = 'component_large_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_SC_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_SC_BARREL_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_BULLPUPRIFLE',
		label = 'weapon_bullpuprifle',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_VARMOD_LOW') }
		}
	},
	{
		name = 'WEAPON_BULLPUPRIFLE_MK2',
		label = 'weapon_bullpuprifle_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'small_scope', label = 'component_small_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_MK2') },
			{ name = 'medium_scope', label = 'component_medium_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_BP_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_BP_BARREL_02') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_COMPACTRIFLE',
		label = 'weapon_compactrifle',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_02') },
			{ name = 'clip_drum', label = 'component_clip_drum', hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_03') }
		}
	},
    {
		name = 'WEAPON_MG',
		label = 'weapon_mg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_MG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_MG_CLIP_02') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_MG_VARMOD_LOWRIDER') }
		}
	},
    {
		name = 'WEAPON_COMBATMG',
		label = 'weapon_combatmg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_COMBATMG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_COMBATMG_CLIP_02') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_COMBATMG_VARMOD_LOWRIDER') }
		}
	},
	{
		name = 'WEAPON_COMBATMG_MK2',
		label = 'weapon_combatmg_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_FMJ') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'medium_scope', label = 'component_medium_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2') },
			{ name = 'large_scope', label = 'component_large_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_MG_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_MG_BARREL_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_GUSENBERG',
		label = 'weapon_gusenberg',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_02') },
		}
	},
    {
		name = 'WEAPON_SNIPERRIFLE',
		label = 'weapon_sniperrifle',
		components = {
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE') },
			{ name = 'scope_advanced', label = 'component_scope_advanced', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_SNIPERRIFLE_VARMOD_LUXE') }
		}
	},
    {
		name = 'WEAPON_HEAVYSNIPER',
		label = 'weapon_heavysniper',
		components = {
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE') },
			{ name = 'scope_advanced', label = 'component_scope_advanced', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') }
		}
	},
	{
		name = 'WEAPON_HEAVYSNIPER_MK2',
		label = 'weapon_heavysniper_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_02') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ') },
			{ name = 'explosive_rounds', label = 'component_explosive_rounds', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE') },
			{ name = 'zoom_scope', label = 'component_zoom_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_MK2') },
			{ name = 'advanced_scope', label = 'component_advanced_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MAX') },
			{ name = 'night_vision_scope', label = 'component_night_vision_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_NV') },
			{ name = 'thermal_scope', label = 'component_thermal_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_THERMAL') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_SR_SUPP_03') },
			{ name = 'squared_muzzle_brake', label = 'component_squared_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_08') },
			{ name = 'bell_end_muzzle_brake', label = 'component_bell_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_09') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_SR_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_SR_BARREL_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_10') },
			{ name = 'patriotic', label = 'component_patriotic', hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_MARKSMANRIFLE',
		label = 'weapon_marksmanrifle',
		components = {
			{ name = 'clip_default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_01') },
			{ name = 'clip_extended', label = 'component_clip_extended', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_02') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'luxary_finish', label = 'component_luxary_finish', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_VARMOD_LUXE') }
		}
	},
	{
		name = 'WEAPON_MARKSMANRIFLE_MK2',
		label = 'weapon_marksmanrifle_mk2',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_01') },
			{ name = 'extended_clip', label = 'component_extended_clip', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_02') },
			{ name = 'tracer_rounds', label = 'component_tracer_rounds', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER') },
			{ name = 'incendiary_rounds', label = 'component_incendiary_rounds', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY') },
			{ name = 'armor_piercing_rounds', label = 'component_armor_piercing_rounds', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING') },
			{ name = 'full_metal_jacket_rounds', label = 'component_full_metal_jacket_rounds', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ') },
			{ name = 'holographic_sight', label = 'component_holographic_sight', hash = GetHashKey('COMPONENT_AT_SIGHTS') },
			{ name = 'large_scope', label = 'component_large_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2') },
			{ name = 'zoom_scope', label = 'component_zoom_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'suppressor', label = 'component_suppressor', hash = GetHashKey('COMPONENT_AT_AR_SUPP') },
			{ name = 'flat_muzzle_brake', label = 'component_flat_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_01') },
			{ name = 'tactical_muzzle_brake', label = 'component_tactical_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_02') },
			{ name = 'fat_end_muzzle_brake', label = 'component_fat_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_03') },
			{ name = 'precision_muzzle_brake', label = 'component_precision_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_04') },
			{ name = 'heavy_duty_muzzle_brake', label = 'component_heavy_duty_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_05') },
			{ name = 'slanted_muzzle_brake', label = 'component_slanted_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_06') },
			{ name = 'split_end_muzzle_brake', label = 'component_split_end_muzzle_brake', hash = GetHashKey('COMPONENT_AT_MUZZLE_07') },
			{ name = 'default_barrel', label = 'component_default_barrel', hash = GetHashKey('COMPONENT_AT_MRFL_BARREL_01') },
			{ name = 'heavy_barrel', label = 'component_heavy_barrel', hash = GetHashKey('COMPONENT_AT_MRFL_BARREL_02') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02') },
			{ name = 'digital_camo', label = 'component_digital_camo', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO') },
			{ name = 'brushstroke_camo', label = 'component_brushstroke_camo', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_02') },
			{ name = 'woodland_camo', label = 'component_woodland_camo', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_03') },
			{ name = 'skull', label = 'component_skull', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_04') },
			{ name = 'sessanta_nove', label = 'component_sessanta_nove', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_05') },
			{ name = 'perseus', label = 'component_perseus', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_06') },
			{ name = 'leopard', label = 'component_leopard', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_07') },
			{ name = 'zebra', label = 'component_zebra', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_08') },
			{ name = 'geometric', label = 'component_geometric', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_09') },
			{ name = 'boom', label = 'component_boom', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_10') },
			{ name = 'boom_ind', label = 'component_boom_ind', hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01') }

		}
	},
    {
		name = 'WEAPON_GRENADELAUNCHER',
		label = 'weapon_grenadelauncher',
		components = {
			{ name = 'default_clip', label = 'component_default_clip', hash = GetHashKey('COMPONENT_GRENADELAUNCHER_CLIP_01') },
			{ name = 'flashlight', label = 'component_flashlight', hash = GetHashKey('COMPONENT_AT_AR_FLSH') },
			{ name = 'grip', label = 'component_grip', hash = GetHashKey('COMPONENT_AT_AR_AFGRIP') },
			{ name = 'scope', label = 'component_scope', hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL') }
		}
	},
    {
		name = 'WEAPON_RPG',
		label = 'weapon_rpg',
		components = {}
	},
    {
		name = 'WEAPON_STINGER',
		label = 'weapon_stinger',
		components = {}
	},
    {
		name = 'WEAPON_MINIGUN',
		label = 'weapon_minigun',
		components = {}
	},
    {
		name = 'WEAPON_GRENADE',
		label = 'weapon_grenade',
		components = {}
	},
    {
		name = 'WEAPON_STICKYBOMB',
		label = 'weapon_stickybomb',
		components = {}
	},
    {
		name = 'WEAPON_SMOKEGRENADE',
		label = 'weapon_smokegrenade',
		components = {}
	},
    {
		name = 'WEAPON_BZGAS',
		label = 'weapon_bzgas',
		components = {}
	},
    {
		name = 'WEAPON_MOLOTOV',
		label = 'weapon_molotov',
		components = {}
	},
    {
		name = 'WEAPON_FIREEXTINGUISHER',
		label = 'weapon_fireextinguisher',
		components = {}
	},
    {
		name = 'WEAPON_PETROLCAN',
		label = 'weapon_petrolcan',
		components = {}
	},
    {
		name = 'WEAPON_DIGISCANNER',
		label = 'weapon_digiscanner',
		components = {}
	},
    {
		name = 'WEAPON_BALL',
		label = 'weapon_ball',
		components = {}
	},
    {
		name = 'WEAPON_BOTTLE',
		label = 'weapon_bottle',
		components = {}
	},
    {
		name = 'WEAPON_DAGGER',
		label = 'weapon_dagger',
		components = {}
	},
    {
		name = 'WEAPON_FIREWORK',
		label = 'weapon_firework',
		components = {}
	},
    {
		name = 'WEAPON_MUSKET',
		label = 'weapon_musket',
		components = {}
	},
    {
		name = 'WEAPON_STUNGUN',
		label = 'weapon_stungun',
		components = {}
	},
    {
		name = 'WEAPON_HOMINGLAUNCHER',
		label = 'weapon_hominglauncher',
		components = {}
	},
    {
		name = 'WEAPON_PROXMINE',
		label = 'weapon_proxmine',
		components = {}
	},
    {
		name = 'WEAPON_SNOWBALL',
		label = 'weapon_snowball',
		components = {}
	},
    {
		name = 'WEAPON_FLAREGUN',
		label = 'weapon_flaregun',
		components = {}
	},
    {
		name = 'WEAPON_GARBAGEBAG',
		label = 'weapon_garbagebag',
		components = {}
	},
    {
		name = 'WEAPON_HANDCUFFS',
		label = 'weapon_handcuffs',
		components = {}
	},
    {
		name = 'WEAPON_MARKSMANPISTOL',
		label = 'weapon_marksmanpistol',
		components = {}
	},
    {
		name = 'WEAPON_KNUCKLE',
		label = 'weapon_knuckle',
		components = {
			{ name = 'Base Model', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_BASE') },
			{ name = 'The Pimp', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_PIMP') },
			{ name = 'The Ballas', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_BALLAS') },
			{ name = 'The Hustler', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_DOLLAR') },
			{ name = 'The Rock', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_DIAMOND') },
			{ name = 'The Hater', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_HATE') },
			{ name = 'The Lover', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_LOVE') },
			{ name = 'The Player', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_PLAYER') },
			{ name = 'The King', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_KING') },
			{ name = 'Vagos', label = 'component_clip_default', hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_VAGOS') }
		}
	},
    {
		name = 'WEAPON_HATCHET',
		label = 'weapon_hatchet',
		components = {}
	},
    {
		name = 'WEAPON_RAILGUN',
		label = 'weapon_railgun',
		components = {}
	},
    {
		name = 'WEAPON_MACHETE',
		label = 'weapon_machete',
		components = {}
	},
    {
		name = 'WEAPON_SWITCHBLADE',
		label = 'weapon_switchblade',
		components = {
			{ name = 'Default', label = 'component_clip_default', hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_BASE') },
			{ name = 'VIP', label = 'component_clip_default', hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_VAR1') },
			{ name = 'Bodyguard', label = 'component_clip_default', hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_VAR2') },
		}
	},
    {
		name = 'WEAPON_DBSHOTGUN',
		label = 'weapon_dbshotgun',
		components = {}
	},
    {
		name = 'WEAPON_AUTOSHOTGUN',
		label = 'weapon_autoshotgun',
		components = {}
	},
    {
		name = 'WEAPON_BATTLEAXE',
		label = 'weapon_battleaxe',
		components = {}
	},
    {
		name = 'WEAPON_COMPACTLAUNCHER',
		label = 'weapon_compactlauncher',
		components = {}
	},
    {
		name = 'WEAPON_PIPEBOMB',
		label = 'weapon_pipebomb',
		components = {}
	},
    {
		name = 'WEAPON_POOLCUE',
		label = 'weapon_poolcue',
		components = {}
	},
    {
		name = 'WEAPON_WRENCH',
		label = 'weapon_wrench',
		components = {}
	},
    {
		name = 'WEAPON_FLASHLIGHT',
		label = 'weapon_flashlight',
		components = {}
	},
    {
		name = 'GADGET_NIGHTVISION',
		label = 'gadget_nightvision',
		components = {}
	},
    {
		name = 'GADGET_PARACHUTE',
		label = 'gadget_parachute',
		components = {}
	},
    {
		name = 'WEAPON_FLARE',
		label = 'weapon_flare',
		components = {}
	},
    {
		name = 'WEAPON_DOUBLEACTION',
		label = 'weapon_doubleaction',
		components = {}
	}
}