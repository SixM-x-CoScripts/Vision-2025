Config = {}

--Max Amount Of Fires At Once
Config.MaxFires = 20
--Max Flames That Can Be Created Via Command
Config.MaxFlames = 40
--Max Spread That Can Be Created Via Command
Config.MaxSpread = 40

--Discord Webhooks
Config.Discord = {
    UseWebHooks = true,
    WEB_HOOK = "https://discord.com/api/webhooks/1317960310560133171/qY5_hGXPyA6J5YXVGQooiMfVaoaZagkROaudBvrczzdzX-w9G6UfAYjc88fKaGVsRQQu",
    STEAM_API = "",
    WEB_IMAGE = "https://www.cdiscount.com/pdt2/2/6/9/1/550x550/auc0723260467269/rw/nouveau-pat-patrouille-paw-patrol-police-chiens-bl.jpg",
    BOT_NAME = "Marcus",
}

--If you dont use esx nor use qbus set UseESX to false and UseQBUS to false
--You can then use the job identifier whitelist as standalone

--If you use esx enable this
Config.UseESX = false

--If you use qbus enable this
Config.UseQBUS = false

--Required Job To Use The FireHose
Config.Job = { "lsfd" }

--This is a whitelist for the firefighers (Standalone Only)
Config.UseFireJobWhitelist = false
Config.FireJobIdentifiers = {
    "steam:11000012430xfa",
    "license:1123d12313"
}

--Identifier Admin whitelist
--Set UseWhitelist To True To Use The Whitelist (Standalone Only)
--Set this to true to enable the admin whitelist so that no one can use the admin commands
Config.UseWhitelist = false
Config.Identifiers = {
    "steam:11000012430xfa",
    "license:1123d12313"
}


--This Is The Fire Blips
--Check https://docs.fivem.net/docs/game-references/blips/ For The Blip Sprites And Colors
Config.FireWarnings = {
    Ping = {
        Enabled = true,
        Radius = 40.0,
        FadeTimer = 40,
        Color = 1,--Color 1 Is Red
        StartAlpha = 255,--Alpha Is The Opacity
    },
    Blip = {
        Enabled = true,
        Name = "Active Fire",
        Sprite = 436,
        Color = 1,--Color 1 Is Red
        Alpha = 255,--Alpha Is The Opacity
    },
    Message = {
        Enabled = true,
    }
}

--Lifetime is the life of the flame, how hard it is to take out
--Some flames are considered a fire on their own which makes them not affected by water, add isFireScript = true to fix that
--The Smoke is added after or before the flame is out, and the timeout is the amount of time it stays
Config.FireTypes = {
    ["normal"] = {
        dict = "scr_trevor3", 
        part = "scr_trev3_trailer_plume", 
        scale = 0.7, 
        lifetime = 15, 
        zoffset = 0.4, 
        isFireScript = false,
        smoke = {
            dict = "core",
            part = "ent_amb_stoner_vent_smoke",
            scale = 1,
            timeout = 15,--In Seconds
            playduring = true,
            playafter = true,
            zoffset = 1.0
        }
    },
    ["normal2"] = {
        dict = "core", 
        part = "fire_wrecked_truck_vent", 
        scale = 3, 
        lifetime = 18, 
        zoffset = 0.4, 
        isFireScript = false,
        smoke = {
            dict = "core",
            part = "ent_amb_smoke_factory_white",
            scale = 1,
            timeout = 15,--In Seconds
            playduring = true,
            playafter = true,
            zoffset = 0.0
        }
    },
    ["chemical"] = {
        dict = "core", 
        part = "fire_petroltank_truck", 
        scale = 4, 
        lifetime = 24, 
        zoffset = 0.0, 
        isFireScript = false,
        smoke = {
            dict = "core",
            part = "ent_amb_smoke_general",
            scale = 1,
            timeout = 15,--In Seconds
            playduring = true,
            playafter = true,
            zoffset = 1.0
        }
    },
    ["electrical"] = {
        dict = "core", 
        part = "ent_ray_meth_fires", 
        scale = 1, 
        lifetime = 30, 
        zoffset = 0.0, 
        isFireScript = true,
        smoke = {
            dict = "core",
            part = "ent_amb_smoke_foundry",
            scale = 1,
            timeout = 15,--In Seconds
            playduring = true,
            playafter = true,
            zoffset = 1.0
        }
    },
    ["bonfire"] = {
        dict = "scr_michael2", 
        part = "scr_mich3_heli_fire", 
        scale = 1, 
        lifetime = 36, 
        zoffset = 0.0, 
        isFireScript = true,
        smoke = {
            dict = "scr_agencyheistb",
            part = "scr_env_agency3b_smoke",
            scale = 1,
            timeout = 15,--In Seconds
            playduring = true,
            playafter = true,
            zoffset = 1.0
        }
    }
}

--Random Fires Configurations
--Select The Type From The Fire Types
--Fire timeout is to set the fire off if it hasn't been taken out
Config.RandomFires = {
    Enabled = true,
    AOP = "LS",--Current AOP
    Delay = 30,--In Minutes
    Locations = {
        ["LS"] = {--
            [1] = { --Lossantos Is The AOP
                position = vector3(122.14, -223.04, 54.56),--Clothes shop
                location = "Clothes Shop",
                flames = 20,
                spread = 15,
                type = "normal",
                timeout = 650--In Seconds
            },
            [2] = {
                position = vector3(-41.45, -1097.81, 26.42),--Dealership
                location = "Dealer Ship",
                flames = 20,
                spread = 15,
                type = "electrical",
                timeout = 650--In Seconds
            },
            [3] = {
                position = vector3(265.09, -1259.29, 29.14),--Gas Station
                location = "Gas Station",
                flames = 20,
                spread = 15,
                type = "chemical",
                timeout = 650--In Seconds
            },
            [4] = {
                position = vector3(855.61, -285.82, 65.52),--Skate Park
                location = "Skate Park",
                flames = 20,
                spread = 20,
                type = "bonfire",
                timeout = 650--In Seconds
            },
            [5] = {
                position = vector3(-1185.92, -2910.13, 12.95),--LSIA
                location = "LSIA",
                flames = 20,
                spread = 15,
                type = "normal",
                timeout = 650--In Seconds
            },
            [6] = {
                position = vector3(-1689.12, -1099.78, 12.15),--Fête Forraine
                location = "Stand Fête Foireuse",
                flames = 30,
                spread = 25,
                type = "bonfire",
                timeout = 650--In Seconds
            },
            [7] = {
                position = vector3(1072.66, -3292.13, 4.9),--Vagon Port LS
                location = "Vagon HT Port",
                flames = 25,
                spread = 20,
                type = "chemical",
                timeout = 650--In Seconds
            },
            [8] = {
                position = vector3(-587.03, -1605.08, 26.01),--Usine Decharge
                location = "Usine de Coton",
                flames = 25,
                spread = 20,
                type = "normal2",
                timeout = 650--In Seconds
            },
            [9] = {
                position = vector3(-25.08, -81.1, 56.25),--Quartier de cong
                location = "Quartier Rockford Plaza",
                flames = 25,
                spread = 25,
                type = "normal",
                timeout = 650--In Seconds
            },
            [10] = {
                position = vector3(-104.5, -431.44, 35.13),--Parc Rockford Plaza
                location = "Parc Rockford Plaza",
                flames = 25,
                spread = 25,
                type = "normal",
                timeout = 650--In Seconds
            },
            [11] = {
                position = vector3(38.51, -384.65, 44.56),--Chantier
                location = "Chantier",
                flames = 35,
                spread = 25,
                type = "normal2",
                timeout = 650--In Seconds
            },
            [12] = {
                position = vector3(-1561.74, -417.93, 41.38),--Quartier Bloods
                location = "Quartier Bloods",
                flames = 35,
                spread = 20,
                type = "normal2",
                timeout = 650--In Seconds
            },
            [13] = {
                position = vector3(-3427.02, 968.22, 7.35),--Pont chumash 
                location = "Chumash",
                flames = 15,
                spread = 5,
                type = "normal",
                timeout = 650--In Seconds
            },
        },
        ["SA"] = {--Sandy Is The AOP
            [1] = {
                position = vector3(1963.77, 3744.05, 32.34),--24/7
                location = "24/7",
                flames = 10,
                spread = 5,
                type = "normal2",
                timeout = 650--In Seconds
            },
            [2] = {
                position = vector3(1963.82, 3744.7, 31.34),--LTD Sandy PDS
                location = "LTD Sandy Shore",
                flames = 20,
                spread = 15,
                type = "normal",
                timeout = 650--In Seconds 
            },
            [3] = {
                position = vector3(2056.83, 3687.32, 33.59),--PHT Sandy
                location = "Poste Haute Tension",
                flames = 40,
                spread = 20,
                type = "electrical",
                timeout = 650--In Seconds 
            },
            [4] = {
                position = vector3(2411.78, -2079.47, 26.73),--Fôret DHS
                location = "Fôret",
                flames = 30,
                spread = 15,
                type = "bonfire",
                timeout = 650--In Seconds
            },
            [5] = {
                position = vector3(1525.98, 1732.93, 109.3),--Maison abandonée FB
                location = "Fuentes Blanca",
                flames = 30,
                spread = 25,
                type = "bonfire",
                timeout = 650--In Seconds
            }, 
            [6] = {
                position = vector3(553.0, 2806.01, 41.27),--Arrière boutique PetShop
                location = "Poubelle PetShop",
                flames = 25,
                spread = 15,
                type = "normal2",
                timeout = 650--In Seconds 
            },
            [7] = {
                position = vector3(2840.18, 1554.43, 23.57),--Palmer Station
                location = "Palmer Station",
                flames = 10,
                spread = 20,
                type = "electrical",
                timeout = 650--In Seconds
            },
            [8] = {
                position = vector3(60.31, 3686.31, 38.83),--Stab City
                location = "Stab City",
                flames = 25,
                spread = 10,
                type = "normal",
                timeout = 650--In Seconds
            },
            [9] = {
                position = vector3(3599.77, 3662.9, 41.61),--Human's Lab
                location = "Human's Lab",
                flames = 45,
                spread = 35,
                type = "electrical",
                timeout = 650--In Seconds
            },
        },
        ["PB"] = {--Paleto Bay Is The AOP
            [1] = {
                position = vector3(-92.22, 6415.5, 31.47),--Gas Station
                location = "Gas Station",
                flames = 20,
                spread = 10,
                type = "normal2",
                timeout = 650--In Seconds
            },
            [2] = {
                position = vector3(-499.59, 5266.08, 79.61),--Scierie Paleto Bay
                location = "Scierie",
                flames = 40,
                spread = 15,
                type = "bonfire",
                timeout = 650--In Seconds
            },
            [3] = {
                position = vector3(3424.94, 5172.2, 6.38),--Phare
                location = "Phare Paleto",
                flames = 40,
                spread = 20,
                type = "bonfire",
                timeout = 650--In Seconds
            },
            [4] = {
                position = vector3(2569.04, 6196.85, 159.17),--Forêt Thomas Reserve
                location = "Reserve Thomas Lake",
                flames = 40,
                spread = 20,
                type = "normal2",
                timeout = 650--In Seconds 2568.19, 6573.48, 24.21
            },
            [5] = {
                position = vector3(2568.19, 6573.48, 24.21),--Forêt Thomas Reserve
                location = "Reserve Thomas",
                flames = 20,
                spread = 20,
                type = "normal2",
                timeout = 650--In Seconds
            },
            [6] = {
                position = vector3(355.83, 6522.73, 27.31),--Ferme Paleto
                location = "Ferme Paleto",
                flames = 20,
                spread = 20,
                type = "normal",
                timeout = 650--In Seconds
            },
            [7] = {
                position = vector3(-447.72, 6011.07, 30.72),--PDS Paleto
                location = "Sheriff Office Paleto",
                flames = 10,
                spread = 5,
                type = "normal",
                timeout = 650--In Seconds
            }, 
            [8] = {
                position = vector3(-2358.95, 3250.48, 100.45),--TDC Base Militaire
                location = "Tour de Contrôle Zancudo",
                flames = 20,
                spread = 15,
                type = "normal",
                timeout = 650--In Seconds
            }, 
            [9] = {
                position = vector3(-164.38, 6159.02, 30.21),--Job Train PB
                location = "Stockage Chimique Ferovière",
                flames = 25,
                spread = 15,
                type = "chemical",
                timeout = 650--In Seconds
            },
            [10] = {
                position = vector3(3616.85, 5024.15, 10.39),--île paumée
                location = "Île Abandonée PB",
                flames = 30,
                spread = 20,
                type = "normal2",
                timeout = 650--In Seconds
            },
        }
    }
}


--[[Smoke Particles
This is more of a spark for like an electric fire
smokedict = "core",
smokepart = "ent_amb_elec_crackle",

smokedict = "scr_agencyheistb",
smokepart = "scr_env_agency3b_smoke",

smokedict = "core",
smokepart = "ent_amb_stoner_vent_smoke",

smokedict = "core",
smokepart = "ent_amb_smoke_general",

smokedict = "core",
smokepart = "ent_amb_smoke_foundry",

smokedict = "core",
smokepart = "ent_amb_smoke_factory_white",

This is a large white fog
smokedict = "core",
smokepart = "ent_amb_fbi_smoke_fogball",

smokedict = "core",
smokepart = "ent_amb_generator_smoke",
]]--
