local CustomEmotesList = {}

AllEmotes = {}

CustomEmotesList.Expressions = {}
CustomEmotesList.Walks = {}
CustomEmotesList.Shared = {}
CustomEmotesList.Dances = {
    ["armswirl"] = {
        "custom@armswirl",
        "armswirl",
        "Tourbillon de bras",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["armwave"] = {
        "custom@armwave",
        "armwave",
        "Vague des bras",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["bellydance"] = {
        "custom@bellydance",
        "bellydance",
        "Danse du ventre",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["electroshuffle"] = {
        "custom@electroshuffle",
        "electroshuffle",
        "Dance LMFAO",
        AnimationOptions = {EmoteLoop = true}
    },
    ["floss"] = {
        "custom@floss",
        "floss",
        "Dance Floss",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hiphopslide"] = {
        "custom@hiphop_slide",
        "hiphop_slide",
        "Slide HipHop",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["hiphop1"] = {
        "custom@hiphop1",
        "hiphop1",
        "HipHop 1",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["hiphop2"] = {
        "custom@hiphop2",
        "hiphop2",
        "HipHop 2",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["hiphop3"] = {
        "custom@hiphop3",
        "hiphop3",
        "HipHop 3",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = false}
    },
    ["hiphopold"] = {
        "custom@hiphop90s",
        "hiphop90s",
        "HipHop Vieux",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["woowalk"] = {
        "div@woowalk@test",
        "woowalk",
        "Marche à pied Woo",
        AnimationOptions = {EmoteLoop = true}
    },
    ["drilldance"] = {
        "div@woowalk@test",
        "drilldance",
        "Dance Drill 1",
        AnimationOptions = {EmoteLoop = true}
    },
    ["cripwalk2"] = {
        "div@woowalk@test",
        "cripwalk2",
        "Marche de Crip",
        AnimationOptions = {EmoteLoop = true}
    },
    ["sturdy2"] = {
        "div@woowalk@test",
        "sturdy2",
        "Devenez robuste",
        AnimationOptions = {EmoteLoop = true}
    },
    ["bloodwalk2"] = {
        "div@woowalk@test",
        "bloodwalk2",
        "Faire des claquettes",
        AnimationOptions = {EmoteLoop = true}
    },
    ["blixkytwirl2"] = {
        "div@woowalk@test",
        "blixkytwirl2",
        "Tourbillon Blixky",
        AnimationOptions = {EmoteLoop = true}
    },

    -- Custom Dances: Ultra
    ["breakdance"] = {
        "export@breakdance",
        "breakdance",
        "Faire le robot",
        AnimationOptions = {EmoteLoop = true}
    },
    ["gangnamstyle"] = {
        "custom@gangnamstyle",
        "gangnamstyle",
        "Gangnam Style",
        AnimationOptions = {EmoteLoop = true}
    },
    ["macarena"] = {
        "custom@makarena",
        "makarena",
        "Macarena",
        AnimationOptions = {EmoteLoop = true}
    },
    ["maraschino"] = {
        "custom@maraschino",
        "maraschino",
        "Maraschino",
        AnimationOptions = {EmoteLoop = true}
    },
    ["salsa1"] = {
        "custom@salsa",
        "salsa",
        "Salsa",
        AnimationOptions = {EmoteLoop = true}
    },

    -- Custom Dances: Divine
    ["ddance1"] = {
        "divined@dances@new",
        "ddance1",
        "La danse divine D 1",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance2"] = {
        "divined@dances@new",
        "ddance2",
        "La danse divine D 6",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance3"] = {
        "divined@dances@new",
        "ddance3",
        "La danse divine D 7",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance4"] = {
        "divined@dances@new",
        "ddance4",
        "La danse divine D 8",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance5"] = {
        "divined@dances@new",
        "ddance5",
        "La danse divine D 9",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance6"] = {
        "divined@dances@new",
        "ddance6",
        "La danse divine D 10",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance7"] = {
        "divined@dances@new",
        "ddance7",
        "La danse divine D 11",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance8"] = {
        "divined@dances@new",
        "ddance8",
        "La danse divine D 12",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance9"] = {
        "divined@dances@new",
        "ddance9",
        "La danse divine D 13",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance10"] = {
        "divined@dances@new",
        "ddance10",
        "La danse divine D 2",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance11"] = {
        "divined@dances@new",
        "ddance11",
        "La danse divine D 3",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance12"] = {
        "divined@dances@new",
        "ddance12",
        "La danse divine D 4",
        AnimationOptions = {EmoteLoop = true}
    },
    ["ddance13"] = {
        "divined@dances@new",
        "ddance13",
        "La danse divine D 5",
        AnimationOptions = {EmoteLoop = true}
    },

    -- Version Two
    ["divdance1"] = {
        "divined@dancesv2@new",
        "divdance1",
        "Dance Custom 1",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance2"] = {
        "divined@dancesv2@new",
        "divdance2",
        "Dance Custom 7",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance3"] = {
        "divined@dancesv2@new",
        "divdance3",
        "Dance Custom 8",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance4"] = {
        "divined@dancesv2@new",
        "divdance4",
        "Dance Custom 9",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance5"] = {
        "divined@dancesv2@new",
        "divdance5",
        "Dance Custom 10",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance6"] = {
        "divined@dancesv2@new",
        "divdance6",
        "Dance Custom 11",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance7"] = {
        "divined@dancesv2@new",
        "divdance7",
        "Dance Custom 12",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance8"] = {
        "divined@dancesv2@new",
        "divdance8",
        "Dance Custom 13",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance9"] = {
        "divined@dancesv2@new",
        "divdance9",
        "Dance Custom 14",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance10"] = {
        "divined@dancesv2@new",
        "divdance10",
        "Dance Custom 2",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance11"] = {
        "divined@dancesv2@new",
        "divdance11",
        "Dance Custom 3",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance12"] = {
        "divined@dancesv2@new",
        "divdance12",
        "Dance Custom 4",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance13"] = {
        "divined@dancesv2@new",
        "divdance13",
        "Dance Custom 5",
        AnimationOptions = {EmoteLoop = true}
    },
    ["divdance14"] = {
        "divined@dancesv2@new",
        "divdance14",
        "Dance Custom 6",
        AnimationOptions = {EmoteLoop = true}
    },
    -- Divine Breakdance
    ["divbdance1"] = {
        "divined@breakdances@new",
        "divbdance1",
        "Break Dance divisée 1",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance2"] = {
        "divined@breakdances@new",
        "divbdance2",
        "Break Dance divisée 8",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance3"] = {
        "divined@breakdances@new",
        "divbdance3",
        "Break Dance divisée 9",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance4"] = {
        "divined@breakdances@new",
        "divbdance4",
        "Break Dance divisée 10",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance5"] = {
        "divined@breakdances@new",
        "divbdance5",
        "Break Dance divisée 11",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance6"] = {
        "divined@breakdances@new",
        "divbdance6",
        "Break Dance divisée 12",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance7"] = {
        "divined@breakdances@new",
        "divbdance7",
        "Break Dance divisée 13",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance8"] = {
        "divined@breakdances@new",
        "divbdance8",
        "Break Dance divisée 14",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance9"] = {
        "divined@breakdances@new",
        "divbdance9",
        "Break Dance divisée 15",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance10"] = {
        "divined@breakdances@new",
        "divbdance10",
        "Break Dance divisée 2",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance11"] = {
        "divined@breakdances@new",
        "divbdance11",
        "Break Dance divisée 3",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance12"] = {
        "divined@breakdances@new",
        "divbdance12",
        "Break Dance divisée 4",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance13"] = {
        "divined@breakdances@new",
        "divbdance13",
        "Break Dance divisée 5",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance14"] = {
        "divined@breakdances@new",
        "divbdance14",
        "Break Dance divisée 6",
        AnimationOptions = {EmoteLoop = false}
    },
    ["divbdance15"] = {
        "divined@breakdances@new",
        "divbdance14",
        "Break Dance divisée 7",
        AnimationOptions = {EmoteLoop = false}
    },
    ["sturdy"] = {
        "nito_sturdy18@animation",
        "nito_sturdy18_clip",
        "Danse vigoureuse",
        AnimationOptions = {EmoteLoop = true}
    },

    -- Divine Breakdance v3
    ["dbrdance1"] = {
        "divined@brdancesv2@new",
        "dbrdance1",
        "La danse divine 1",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance2"] = {
        "divined@brdancesv2@new",
        "dbrdance2",
        "La danse divine 5",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance3"] = {
        "divined@brdancesv2@new",
        "dbrdance3",
        "La danse divine 6",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance4"] = {
        "divined@brdancesv2@new",
        "dbrdance4",
        "La danse divine 7",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance5"] = {
        "divined@brdancesv2@new",
        "dbrdance5",
        "La danse divine 8",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance6"] = {
        "divined@brdancesv2@new",
        "dbrdance6",
        "La danse divine 9",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance7"] = {
        "divined@brdancesv2@new",
        "dbrdance7",
        "La danse divine 10",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance8"] = {
        "divined@brdancesv2@new",
        "dbrdance8",
        "La danse divine 11",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance9"] = {
        "divined@brdancesv2@new",
        "dbrdance9",
        "La danse divine 12",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance10"] = {
        "divined@brdancesv2@new",
        "dbrdance10",
        "La danse divine 2",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance11"] = {
        "divined@brdancesv2@new",
        "dbrdance11",
        "La danse divine 3",
        AnimationOptions = {EmoteLoop = false}
    },
    ["dbrdance12"] = {
        "divined@brdancesv2@new",
        "dbrdance12",
        "La danse divine 4",
        AnimationOptions = {EmoteLoop = false}
    },

    -- Divine: Trendy
    ["banddance"] = {
        "divined@tdances@new",
        "dtdance1",
        "Danse de groupe",
        AnimationOptions = {EmoteLoop = true}
    },
    ["bopdance"] = {
        "divined@tdances@new",
        "dtdance2",
        "Bop",
        AnimationOptions = {EmoteLoop = true}
    },
    ["bboydance"] = {
        "divined@tdances@new",
        "dtdance3",
        "Faire du breakdance",
        AnimationOptions = {EmoteLoop = true}
    },
    ["capoeiramove"] = {
        "divined@tdances@new",
        "dtdance4",
        "Mouvement de Capoeira",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hiphopdance"] = {
        "divined@tdances@new",
        "dtdance5",
        "Danse hip-hop",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hipsterdance"] = {
        "divined@tdances@new",
        "dtdance6",
        "Danse hipster",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hippiedance"] = {
        "divined@tdances@new",
        "dtdance7",
        "Danse hippie",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hiphoptaunt"] = {
        "divined@tdances@new",
        "dtdance8",
        "Taunt Hip Hop",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hilowave"] = {
        "divined@tdances@new",
        "dtdance9",
        "Vague Hi Lo",
        AnimationOptions = {EmoteLoop = true}
    },
    ["squaredance"] = {
        "divined@tdances@new",
        "dtdance10",
        "Danse carrée",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hotdance"] = {
        "divined@tdances@new",
        "dtdance11",
        "Danse chaude",
        AnimationOptions = {EmoteLoop = true}
    },
    ["hulahula"] = {
        "divined@tdances@new",
        "dtdance12",
        "Hula-Hula",
        AnimationOptions = {EmoteLoop = true}
    },
    ["dabloop"] = {
        "divined@tdances@new",
        "dtdance13",
        "Faire le dab infini",
        AnimationOptions = {EmoteLoop = true}
    },
    ["kingdance"] = {
        "divined@tdances@new",
        "dtdance14",
        "La danse du roi",
        AnimationOptions = {EmoteLoop = true}
    },
    ["linedance"] = {
        "divined@tdances@new",
        "dtdance15",
        "Ligne de danse",
        AnimationOptions = {EmoteLoop = true}
    },
    ["magicman"] = {
        "divined@tdances@new",
        "dtdance16",
        "L'homme magique",
        AnimationOptions = {EmoteLoop = true}
    },
    ["marat"] = {
        "divined@tdances@new",
        "dtdance17",
        "Marat",
        AnimationOptions = {EmoteLoop = true}
    },
    ["maskoff"] = {
        "divined@tdances@new",
        "dtdance18",
        "Mask Off",
        AnimationOptions = {EmoteLoop = true}
    },
    ["mellow"] = {
        "divined@tdances@new",
        "dtdance19",
        "Mellow",
        AnimationOptions = {EmoteLoop = true}
    },
    ["showroomdance"] = {
        "divined@tdances@new",
        "dtdance20",
        "Danse de salon",
        AnimationOptions = {EmoteLoop = true}
    },
    ["windmillfloss"] = {
        "divined@tdances@new",
        "dtdance21",
        "Fil à vent",
        AnimationOptions = {EmoteLoop = true}
    },
    ["woahdance"] = {
        "divined@tdances@new",
        "dtdance22",
        "Woah",
        AnimationOptions = {EmoteLoop = true}
    }
}
CustomEmotesList.AnimalEmotes = {
    ["chatsursaute"] = {
        "creatures@cat@amb@world_cat_sleeping_ground@exit",
        "exit_panic",
        "Chat - Sursauter de peur",
        AnimationOptions = {EmoteLoop = false}
    },
    ["chatallonger"] = {
        "creatures@cat@amb@world_cat_sleeping_ground@base",
        "base",
        "Chat - Allonger",
        AnimationOptions = {EmoteLoop = true}
    },
    ["chatettirement"] = {
        "creatures@cat@amb@peyote@enter",
        "enter",
        "Chat - Etirement",
        AnimationOptions = {EmoteLoop = false}
    }
}
CustomEmotesList.Exits = {}
CustomEmotesList.Emotes = {}
CustomEmotesList.GestesEmotes = {
    ["bodycam"] = {
        "bodycam@animation",
        "bodycam_clip",
        "Cacher sa bodycam",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["armsback"] = {
        "anim@miss@low@fin@vagos@",
        "idle_ped06",
        "Mains dans le dos",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["analyse"] = {
        "analyse@animation",
        "analyse_clip",
        "Analyse",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["cantsee"] = {
        "custom@cant_see",
        "cant_see",
        "Je ne vois pas",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["dab"] = {
        "custom@dab",
        "dab",
        "Faire un dab",
        AnimationOptions = {EmoteLoop = true}
    },
    ["sheesh"] = {
        "custom@sheeeeesh",
        "sheeeeesh",
        "Sheesh",
        AnimationOptions = {EmoteMoving = true, EmoteDuration = 8000}
    },
    ["secretservice"] = {
        "anim@secret_service",
        "open_door",
        "Ouvrir la porte (USSS)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["secretservice2"] = {
        "wristmic@animation",
        "wristmic4_clip",
        "Parler a sa radio (USSS)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["riflerelax"] = {
        "anim@fog_rifle_relaxed",
        "rifle_relaxed_clip",
        "Relaxed With Rifle (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["stack1"] = {
        "anim@stack_pointman",
        "pointman_clip",
        "Stack Formation Pointman (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["stack2"] = {
        "anim@stack_two_man",
        "two_man_clip",
        "Stack Formation 2nd Man (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["stack3"] = {
        "anim@stack_three_man",
        "three_man_clip",
        "Stack Formation Door (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["highlow1"] = {
        "anim@highlow_low_lean",
        "low_lean_clip",
        "High-Low Low Stance (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["highlow2"] = {
        "anim@highlow_high_lean",
        "high_lean_clip",
        "High-Low High Stance (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["highlow3"] = {
        "anim@tactical_highlow_high_leftlean",
        "high_leftlean_clip",
        "Highlow Left Lean High (Smos)",
        AnimationOptions = {EmoteLoop = false, EmoteMoving = false}
    },
    ["highlow4"] = {
        "anim@tactical_highlow_low_leftlean",
        "low_leftlean_clip",
        "Highlow Left Lean Low (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["kneeltalkie"] = {
        "anim@tactical_kneel_walkie",
        "kneel_walkie_clip",
        "Communication Relaxed Rifle (Smos)",
        AnimationOptions = {EmoteLoop = false, EmoteMoving = false}
    },
    ["aimkneel"] = {
        "anim@tactical_kneel_aiming",
        "kneel_aiming_clip",
        "Kneeling and Aiming Rifle (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["riflerelax1"] = {
        "anim@male_tactical_collapsed_lowready",
        "collapsed_lowready_clip",
        "Collapsed Lowready Relaxed Rifle (Smos)",
        AnimationOptions = {EmoteLoop = false, EmoteMoving = false}
    },
    ["riflerelax2"] = {
        "anim@male_tactical_highready_relaxed",
        "highready_relaxed_clip",
        "Highready Relaxed Rifle (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdingweapon2"] = {
        "anim@male@holding_weapon_2",
        "holding_weapon_2_clip",
        "Holding Weapon 2 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdingweapon4"] = {
        "anim@male@holding_weapon_4",
        "holding_weapon_4_clip",
        "Holding Weapon 4 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdweapkneel"] = {
        "anim@male@holding_weapon_kneel",
        "anim@male@holding_weapon_kneel_clip",
        "Holding Weapon Kneel (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdweapnvg1"] = {
        "anim@male@holding_weapon_nvg",
        "holding_weapon_nvg_clip",
        "Holding Weapon NVG (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdweapnvg2"] = {
        "anim@male@holding_weapon_nvg_2",
        "holding_weapon_nvg_2_clip",
        "Holding Weapon NVG (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["hugweapon1"] = {
        "anim@male@hug_weapon",
        "hug_weapon_clip",
        "Hug Weapon (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["hugweapon2"] = {
        "anim@male@hug_weapon_2",
        "hug_weapon_2_clip",
        "Hug Weapon 2 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["poseweapon1"] = {
        "anim@male@pose_weapon",
        "pose_weapon_clip",
        "Pose Weapon 1 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["poseweapon2"] = {
        "anim@male@pose_weapon_2",
        "pose_weapon_2_clip",
        "Pose Weapon 2 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["poseweapon3"] = {
        "anim@male@pose_weapon_3",
        "pose_weapon_3_clip",
        "Pose Weapon 3 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["aimweapon"] = {
        "anim@male@aim_weapon",
        "aim_weapon_clip",
        "Aim Weapon (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["preaimweap"] = {
        "anim@male@preaim_weapon",
        "preaim_weapon_clip",
        "Pre-Aim Weapon (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["runweapon"] = {
        "anim@male@run_weapon",
        "run_weapon_clip",
        "Run Weapon (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["tacticalkneel"] = {
        "anim@male@tactical_kneel",
        "tactical_kneel_clip",
        "Tactical Kneel (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdingvest1"] = {
        "anim@male@holding_vest",
        "holding_vest_clip",
        "Holding Vest (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdingvest2"] = {
        "anim@male@holding_vest_2",
        "holding_vest_2_clip",
        "Holding Vest 2 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdingsidevest"] = {
        "anim@holding_side_vest",
        "holding_side_vest_clip",
        "Holding Side Vest (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdsiegevest"] = {
        "anim@male@holding_vest_siege",
        "holding_vest_siege_clip",
        "Holding Siege Vest (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdsiegevest2"] = {
        "anim@male@holding_vest_siege_2",
        "holding_vest_siege_2_clip",
        "Holding Siege Vest 2 (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["holdsiegesidevest"] = {
        "anim@holding_siege_vest_side",
        "holding_siege_vest_side_clip",
        "Holding Siege Side Vest (Smos)",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
}
CustomEmotesList.PositionsEmotes = {
    ["pose1"] = {
        "custom@female_pose_1",
        "female_pose_1",
        "Pose 1",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["pose2"] = {
        "custom@female_pose_2",
        "female_pose_2",
        "Pose 2",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["pose3"] = {
        "custom@female_pose_3",
        "female_pose_3",
        "Pose 3",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["pose4"] = {
        "custom@male_pose_1",
        "male_pose_1",
        "Pose 4",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["pose5"] = {
        "custom@male_pose_2",
        "male_pose_2",
        "Pose 5",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["pose6"] = {
        "custom@male_pose_3",
        "male_pose_3",
        "Pose 6",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["sus"] = {
        "custom@suspect",
        "suspect",
        "Suspect",
        AnimationOptions = {EmoteMoving = false}
    },
    ["jsitchair1"] = {
        "timetable@trevor@smoking_meth@base",
        "base",
        "Assis de manière posé",
        AnimationOptions = {EmoteLoop = true}
    },
    ["suit"] = {
        "anim@suit",
        "holding_suit",
        "Tenir son costume",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["pockets"] = {
        "bzzz@animations@hands",
        "bz_hands",
        "Main dans les poches",
        AnimationOptions = {EmoteMoving = true, EmoteLoop = true}
    },
    ["watch"] = {
        "anim@random@shop_clothes@watches",
        "idle_a",
        "Montrer sa montre 1",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["watch2"] = {
        "anim@random@shop_clothes@watches",
        "idle_b",
        "Montrer sa montre 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["watch3"] = {
        "anim@random@shop_clothes@watches",
        "idle_c",
        "Montrer sa montre 3",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["watch4"] = {
        "anim@random@shop_clothes@watches",
        "idle_d",
        "Montrer sa montre 4",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["watch5"] = {
        "anim@random@shop_clothes@watches",
        "idle_e",
        "Montrer sa montre 5",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["saccouder2"] = {
        "missheistdockssetup1ig_12@base",
        "talk_gantry_idle_base_worker4",
        "Accouder flow 02",
        AnimationOptions = {EmoteLoop = true}
    },
    ["saccouder"] = {
        "missheistdockssetup1ig_12@base",
        "talk_gantry_idle_base_worker2",
        "Accouder flow 01",
        AnimationOptions = {EmoteLoop = true}
    }
}
CustomEmotesList.AutresEmotes = {
    ["dig"] = {
        "custom@dig",
        "dig",
        "Creuser",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["copsearch"] = {
        "custom@police",
        "police",
        "Recherche de flics",
        AnimationOptions = {EmoteMoving = false, EmoteDuration = 8000}
    },
    ["whatidk"] = {
        "custom@what_idk",
        "what_idk",
        "Quoi ? Je ne sais pas",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["jkhaby"] = {
        "missarmenian3@simeon_tauntsidle_b",
        "areyounotman",
        "C'est pas compliqué",
        AnimationOptions = {EmoteMoving = false, EmoteDuration = 2500}
    },
    ["jdepressed"] = {
        "oddjobs@bailbond_hobodepressed",
        "base",
        "Etre dépressif",
        AnimationOptions = {EmoteMoving = true}
    },
    ["jcarlowrider"] = {
        "anim@veh@lowrider@low@front_ds@arm@base",
        "sit",
        "Pose Lowrider",
        AnimationOptions = {EmoteMoving = true, EmoteLoop = true}
    },
    ["jselfie5"] = {
        "cellphone@self",
        "selfie",
        "Se filmer avec son téléphone",
        AnimationOptions = {
            EmoteMoving = false,
            Prop = "prop_npc_phone_02",
            PropBone = 28422,
            PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
            EmoteLoop = true
        }
    },
    ["jgangaim"] = {
        "combat@aim_variations@1h@gang",
        "aim_variation_b",
        "Braquer quelqu'un",
        AnimationOptions = {EmoteMoving = true, EmoteLoop = true}
    },
    ["jpbox"] = {
        "mp_am_hold_up",
        "purchase_beerbox_shopkeeper",
        "Donner un carton",
        AnimationOptions = {EmoteMoving = false, EmoteDuration = 2500}
    },
    ["jch"] = {
        "amb@code_human_police_investigate@idle_b",
        "idle_f",
        "Enquêter",
        AnimationOptions = {EmoteMoving = false, EmoteDuration = 7000}
    }
}
CustomEmotesList.ActivitesEmotes = {
    ["parcours01"] = {
        "parkour@anims",
        "big_jump_01",
        "Faire du parcours - 1",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours02"] = {
        "parkour@anims",
        "front_twist_flip",
        "Faire du parcours - 2",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours03"] = {
        "parkour@anims",
        "jump_over_01",
        "Faire du parcours - 3",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours04"] = {
        "parkour@anims",
        "jump_over_02",
        "Faire du parcours - 4",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours05"] = {
        "parkour@anims",
        "slide_kip_up",
        "Faire du parcours - 5",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours06"] = {
        "parkour@anims",
        "jump_over_03",
        "Faire du parcours - 6",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours07"] = {
        "parkour@anims",
        "slide_backside",
        "Faire du parcours - 7",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours08"] = {
        "parkour@anims",
        "slide",
        "Faire du parcours - 8",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours09"] = {
        "parkour@anims",
        "swing_jump",
        "Faire du parcours - 9",
        AnimationOptions = {EmoteLoop = false}
    },
    ["parcours10"] = {
        "parkour@anims",
        "wall_flip",
        "Faire du parcours - 10",
        AnimationOptions = {EmoteLoop = false}
    },
    ["pickfromground"] = {
        "custom@pickfromground",
        "pickfromground",
        "Choisir dans le sol",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["pluck"] = {
        "custom@pluck_fruits",
        "pluck_fruits",
        "Cueillir des fruits",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    },
    ["waiter"] = {
        "custom@waiter",
        "waiter",
        "Serveur",
        AnimationOptions = {EmoteMoving = true, EmoteLoop = true}
    }
}
CustomEmotesList.GangEmotes = {
    ["anim60s"] = {
        "60anim@animation",
        "60anim_clip",
        "Signe 60 Block",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["bal1"] = {
        "bal1@animation",
        "bal1_clip",
        "Ballas 1",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["bal2"] = {
        "bal2@animation",
        "bal2_clip",
        "Ballas 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["fam1"] = {
        "fam1@animation",
        "fam1_clip",
        "Families 1",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["fam2"] = {
        "fam2@animation",
        "fam2_clip",
        "Families 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["vag1"] = {
        "vag1@animation",
        "vag1_clip",
        "Vagos 1",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["vag2"] = {
        "vag2@animation",
        "vag2_clip",
        "Vagos 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["pipougang"] = {
        "custom@mgsign_01",
        "mgsign_01",
        "Pipou gang",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["gchoowook"] = {
        "94glockychoowook@animation",
        "choowook_clip",
        "Gang Sign CHOO/WOOK",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gdoaogzk"] = {
        "94glockydoaogzk@animation",
        "doaogzk_clip",
        "Gang Sign DOA/OGzK",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gmovin"] = {
        "94glockymovin@animation",
        "movin_clip",
        "Gang Sign M8v3N",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gmakk"] = {
        "94glockymakk@animation",
        "makkballa_clip",
        "Gang Sign Makk Balla",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["goyogzk"] = {
        "oyogzk@94glocky",
        "94glockyoyogzk_clip",
        "Gang Sign OYOGzK",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["anim60s2"] = {
        "anim@60sv2",
        "60sv2_clip",
        "Signe 60 Block 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsixfinger"] = {
        "anim@sixfingers",
        "six_clip",
        "Signe Six Finger",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gnhtnh"] = {
        "anim@nhtnh",
        "nhtnh_clip",
        "Signe NHTNH",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gnayba"] = {
        "anim@nayba",
        "nayba_clip",
        "Signe Nayba",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gfcktrays"] = {
        "anim@fcktrays",
        "fcktrays_clip",
        "Signe Fuck Trays",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["dhandsup"] = {
        "drillpack@karxem",
        "handsup",
        "Drill Hands Up",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["dpour"] = {
        "drillpack@karxem",
        "pour",
        "Drill Pour",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["dcrossfinger"] = {
        "drillpack@karxem",
        "crossfinger",
        "Drill Crossfinger",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["dnope"] = {
        "drillpack@karxem",
        "nope",
        "Drill Nope",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gplayboy"] = {
        "anim@playboyig",
        "playboy_clip",
        "Signe Playboy",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsureno"] = {
        "anim@sureno",
        "sureno_clip",
        "Signe Sureno",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsureno2"] = {
        "sureno@thrtn",
        "thrtn_clip",
        "Signe Sureno 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["grabbit1"] = {
        "sureno@rabbit1",
        "rabbit_clip",
        "Signe Rabbit",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["anim30s"] = {
        "sign@ninety",
        "ninety_clip",
        "Signe 30s",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["anim30s2"] = {
        "sign@ninety2",
        "ninety2_clip",
        "Signe 30s 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["anim90s"] = {
        "signs@30s",
        "thirty_clip",
        "Signe 90s",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["anim90s2"] = {
        "signs@30s2",
        "thirty2_clip",
        "Signe 90s 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign01"] = {
        "custom@gsign_05",
        "gsign_05",
        "Signe Gang 1",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["gsign02"] = {
        "custom@gsign_33",
        "gsign_33",
        "Signe Gang 2",
        AnimationOptions = {EmoteLoop = false}
    },
    ["gsign03"] = {
        "grapes@sign",
        "grapes",
        "Signe Gang 3",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign04"] = {
        "grapes@sign2",
        "grapes",
        "Signe Gang 4",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign05"] = {
        "grapes@sign3",
        "sign",
        "Signe Gang 5",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign06"] = {
        "grapes@sign4",
        "sign",
        "Signe Gang 6",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign07"] = {
        "anim@guttagang",
        "gutta_clip",
        "Signe Gang 7",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign08"] = {
        "byrd@sign",
        "sign",
        "Signe Gang 8",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign09"] = {
        "byrd@sign2",
        "sign",
        "Signe Gang 9",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign10"] = {
        "byrd@sign3",
        "sign",
        "Signe Gang 10",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign11"] = {
        "byrd@sign4",
        "sign",
        "Signe Gang 11",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign12"] = {
        "byrd@sign5",
        "sign",
        "Signe Gang 12",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign13"] = {
        "byrd@sign6",
        "sign",
        "Signe Gang 13",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign14"] = {
        "fucknapps@animation",
        "fucknapps_clip",
        "Signe Gang 14",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign15"] = {
        "hooversit@animation",
        "hooversit_clip",
        "Signe Gang 15",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign16"] = {
        "pistolstand@animation",
        "pistolstand_clip",
        "Signe Gang 16",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign17"] = {
        "hooverlean@animation",
        "hooverlean_clip",
        "Signe Gang 17",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign18"] = {
        "b_k@sharror",
        "b_k_clip_ierrorr",
        "Signe Gang 18",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign19"] = {
        "victory@sharror",
        "victory_clip_ierrorr",
        "Signe Gang 19",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign20"] = {
        "blood@sharror",
        "blood_clip_ierrorr",
        "Signe Gang 20",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign21"] = {
        "compton_crip@sharror",
        "compton_crip_clip_ierrorr",
        "Signe Gang 21",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign22"] = {
        "crip@sharror",
        "crip_clip_ierrorr",
        "Signe Gang 22",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign23"] = {
        "eastside@sharror",
        "eastside_clip_ierrorr",
        "Signe Gang 23",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign24"] = {
        "hoover_crip_gun@sharror",
        "hoover_crip_gun_clip_ierrorr",
        "Signe Gang 24",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign25"] = {
        "killa_gun@sharror",
        "killa_gun_clip_ierrorr",
        "Signe Gang 25",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign26"] = {
        "latin_kings@sharror",
        "latin_kings_clip_ierrorr",
        "Signe Gang 26",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign27"] = {
        "mafia_crips@sharror",
        "mafia_crips_clip_ierrorr",
        "Signe Gang 27",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign28"] = {
        "piru@sharror",
        "piru_clip_ierrorr",
        "Signe Gang 28",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign29"] = {
        "underground_crips@sharror",
        "underground_crips_clip_ierrorr",
        "Signe Gang 29",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign30"] = {
        "westcoast@sharror",
        "westcoast_clip_ierrorr",
        "Signe Gang 30",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    },
    ["gsign31"] = {
        "westside_westcoast@sharror",
        "westside_westcoast_clip_ierrorr",
        "Signe Gang 31",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = false}
    }
}
CustomEmotesList.SportEmotes = {
    ["circle_crunch"] = {
        "custom@circle_crunch",
        "circle_crunch",
        "Tourner ses mains en rond",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    }
}
CustomEmotesList.SanteEmotes = {
    ["convulsion"] = {
        "custom@convulsion",
        "convulsion",
        "Convulsion",
        AnimationOptions = {EmoteMoving = false, EmoteLoop = true}
    }
}
CustomEmotesList.PropEmotes = {
    ["card"] = {
        "card@animation",
        "card_clip",
        "Montrer sa carte d'identité",
        AnimationOptions = {
            Prop = "p_ld_id_card_01",
            PropBone = 60309,
            PropPlacement = {0.129, 0.035, 0.068, -80.0, 140.0, 0.0},
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["copradio"] = {
        "copradio@animation",
        "copradio_clip",
        "Radio de Police",
        AnimationOptions = {
            Prop = "prop_cs_walkie_talkie",
            PropBone = 28422,
            PropPlacement = {0.1, 0.07, 0.0, 40.0, 40.0, 170.0},
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["radio1"] = {
        "anim@radio_left",
        "radio_left_clip",
        "Parler a sa radio 1",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["radio2"] = {
        "anim@male@holding_radio",
        "holding_radio_clip",
        "Parler a sa radio 2",
        AnimationOptions = {EmoteLoop = true, EmoteMoving = true}
    },
    ["pallet1"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot 1",
        AnimationOptions = {
            Prop = "prop_pallettruck_01",
            PropBone = -1,
            PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pallet2"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot 2",
        AnimationOptions = {
            Prop = "prop_pallettruck_02",
            PropBone = -1,
            PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pallet3"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_one",
        "Charriot 3",
        AnimationOptions = {
            Prop = "prop_sacktruck_02b",
            PropBone = -1,
            PropPlacement = {0.0, 1.45, -0.8, -30.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pallet4"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot 4",
        AnimationOptions = {
            Prop = "prop_flattruck_01c",
            PropBone = -1,
            PropPlacement = {0.0, 1.3, -0.97, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pallet5"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot 5",
        AnimationOptions = {
            Prop = "prop_flattruck_01d",
            PropBone = -1,
            PropPlacement = {0.0, 1.3, -0.97, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pallet6"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot 6",
        AnimationOptions = {
            Prop = "prop_flattruck_01a",
            PropBone = -1,
            PropPlacement = {0.0, 1.3, -0.97, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["pallet7"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot 7",
        AnimationOptions = {
            Prop = "prop_rub_trolley01a",
            PropBone = -1,
            PropPlacement = {0.0, 1.1, -0.4, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["palletc2"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot avec poids 1",
        AnimationOptions = {
            Prop = "prop_pallettruck_01",
            PropBone = -1,
            PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            SecondProp = 'ex_prop_crate_jewels_racks_sc',
            SecondPropBone = -1,
            SecondPropPlacement = {0.0, 2.0, -1.0, 0.0, 0.0, 180.0},
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    },
    ["palletc3"] = {
        "anim@mp_ferris_wheel",
        "idle_a_player_two",
        "Charriot avec poids 2",
        AnimationOptions = {
            Prop = "prop_pallettruck_01",
            PropBone = -1,
            PropPlacement = {0.0, 1.6, -1.15, 0.0, 0.0, 180.0},
            WeightCapacitor = 'pallet',
            --
            SecondProp = 'ex_prop_crate_money_sc',
            SecondPropBone = -1,
            SecondPropPlacement = {0.0, 2.0, -1.0, 0.0, 0.0, 180.0},
            --
            EmoteLoop = true,
            EmoteMoving = true
        }
    }
}

-----------------------------------------------------------------------------------------
-- | I don't think you should change the code below unless you know what you are doing |--
-----------------------------------------------------------------------------------------

-- Add the custom emotes to RPEmotes main array
for arrayName, array in pairs(CustomEmotesList) do
    if EmotesList[arrayName] then
        for emoteName, emoteData in pairs(array) do
            EmotesList[arrayName][emoteName] = emoteData
        end
    end
    -- Free memory
    CustomEmotesList[arrayName] = nil
end
-- Free memory
CustomEmotesList = nil

-- Create a list of all emotes
for arrayName, array in pairs(EmotesList) do
    if arrayName ~= "Expressions" and arrayName ~= "Exits" and arrayName ~= "Walks" and arrayName ~= "Shared" then
        for emoteName, emoteData in pairs(array) do
            AllEmotes[emoteName] = emoteData
        end
    end
end