Config = {}
Config.Debug = false -- Set to true to enable debug mode

Config.DatabaseChecker = {}
Config.DatabaseChecker.Enabled = true -- if true, the phone will check the database for any issues and fix them if possible
Config.DatabaseChecker.AutoFix = true

--[[ FRAMEWORK OPTIONS ]] --
Config.Framework = "standalone"
--[[
    Supported frameworks:
        * auto: auto-detect framework (ONLY WORKS WITH THE ONES LISTED BELOW)
        * esx: es_extended, https://github.com/esx-framework/esx-legacy
        * qb: qb-core, https://github.com/qbcore-framework/qb-core
        * ox: ox_core, https://github.com/overextended/ox_core
        * vrp2: vrp 2.0 (ONLY THE OFFICIAL vRP 2.0, NOT CUSTOM VERSIONS)
        * standalone: no framework, note that framework specific apps will not work unless you implement the functions
]]
Config.CustomFramework = true -- if set to true and you use standalone, you will be able to use framework specific apps
Config.QBMailEvent = false -- if you want this script to listen for qb email events, enable this.
Config.QBOldJobMethod = false -- use the old method to check job in qb-core? this is slower, and only needed if you use an outdated version of qb-core.

Config.Item = {}
Config.Item.Require = true -- require a phone item to use the phone
Config.Item.Name = "phone" -- name of the phone item

Config.Item.Unique = false -- should each phone be unique? https://docs.lbscripts.com/phone/configuration/#unique-phones
Config.Item.Inventory = "auto" --[[
    The inventory you use, IGNORE IF YOU HAVE Config.Item.Unique DISABLED.
    Supported:
        * auto: auto-detect inventory (ONLY WORKS WITH THE ONE LISTED BELOW)
        * ox_inventory - https://github.com/overextended/ox_inventory
        * qb-inventory - https://github.com/qbcore-framework/qb-inventory
        * lj-inventory - https://github.com/loljoshie/lj-inventory
        * core_inventory - https://www.c8re.store/package/5121548
        * mf-inventory - https://modit.store/products/mf-inventory?variant=39985142268087
        * qs-inventory - https://buy.quasar-store.com/package/4770732
        * codem-inventory - https://codem.tebex.io/package/5900973
]]

Config.ServerSideSpawn = false -- should entities be spawned on the server? (phone prop, vehicles)

Config.PhoneModel = 'lb_phone_prop' -- the prop of the phone, if you want to use a custom phone model, you can change this here
Config.PhoneRotation = vector3(0.0, 0.0, 0.0) -- the rotation of the phone when attached to a player
Config.PhoneOffset = vector3(0.0, -0.005, 0.0) -- the offset of the phone when attached to a player

Config.DynamicIsland = true -- if enabled, the phone will have a Iphone 14 Pro inspired Dynamic Island.
Config.SetupScreen = true -- if enabled, the phone will have a setup screen when the player first uses the phone.

Config.AutoDeleteNotifications = true -- notifications that are more than X hours old, will be deleted. set to false to disable. if set to true, it will delete 1 week old notifications.
Config.MaxNotifications = 100 -- the maximum amount of notifications a player can have. if they have more than this, the oldest notifications will be deleted. set to false to disable
Config.DisabledNotifications = { -- an array of apps that should not send notifications, note that you should use the app identifier, found in config.json
    -- "DarkChat",
}

Config.WhitelistApps = {
    -- ["test-app"] = {"police", "ambulance"}
}

Config.BlacklistApps = {
    -- ["DarkChat"] = {"police"}
}

Config.ChangePassword = {
    ["Trendy"] = true,
    ["InstaPic"] = true,
    ["Birdy"] = true,
    ["DarkChat"] = true,
    ["Mail"] = true,
}

Config.DeleteAccount = {
    ["Trendy"] = false,
    ["InstaPic"] = false,
    ["Birdy"] = false,
    ["DarkChat"] = false,
    ["Mail"] = false,
    ["Spark"] = false,
}

Config.Companies = {}
Config.Companies.Enabled = true -- allow players to call companies?
Config.Companies.MessageOffline = true -- if true, players can message companies even if no one in the company is online
Config.Companies.DefaultCallsDisabled = false -- should receiving company calls be disabled by default?
Config.Companies.AllowAnonymous = false -- allow players to call companies with "hide caller id" enabled?
Config.Companies.SeeEmployees = "everyone" -- who should be able to see employees? they will see name, online status & phone number. options are: "everyone", "employees" or "none"
Config.Companies.DeleteConversations = true -- allow employees to delete conversations?
Config.Companies.Services = {
    {
        job = "lspd",
        name = "LSPD",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/LSPD.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vespucci",
            coords = {
                x = -1112.6,
                y = -824.4,
            }
        }
    },
    {
        job = "lssd",
        name = "LSSD",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820595129700402LSSD.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Grapeseed",
            coords = {
                x = 2779.47,
                y = 4711.18,
            }
        }
    },
    {
        job = "ems",
        name = "SAMS",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820596593512478SAMS.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Capital Boulevard",
            coords = {
                x = 366.21,
                y = -593.7,
            }
        }
    },
    {
        job = "bcms",
        name = "BCMS",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820596593512478SAMS.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Paleto Boulevard",
            coords = {
                x = -251.58,
                y = 6318.84,
            }
        }
    },
    {
        job = "lsfd",
        name = "LSFD",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820580571254945LSFD.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vinewood Boulevard",
            coords = {
                x = -1054.56,
                y = -1396.34,
            }
        }
    },
    --{
    --    job = "bcms",
    --    name = "BCMS",
    --    icon = "https://cdn.discordapp.com/attachments/498529074717917195/1143563338522034257/dsq.png",
    --    canCall = true, -- if true, players can call the company
    --    canMessage = true, -- if true, players can message the company
    --    location = {
    --        name = "Paleto Bay",
    --        coords = {
    --            x = -251.80661010742,
    --            y = 6334.732910156,
    --        }
    --    }
    --},
    --{
    --    job = "bp",
    --    name = "USBP",
    --    icon = "https://cdn.discordapp.com/attachments/1060640646781730888/1131590086241288282/Logo0.png",
    --    canCall = true, -- if true, players can call the company
    --    canMessage = true, -- if true, players can message the company
    --    location = {
    --        name = "Sandy Shores",
    --        coords = {
    --            x = 2826.3,
    --            y = 4727.4,
    --         }
    --    }
    --},
    {
        job = "usss",
        name = "USSS",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820614071156906USSS.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "United States Secret Services",
            coords = {
                x = -572.3,
                y = -149.5,
            }
        }
    },
    {
        job = "gouv",
        name = "Gouvernement LS",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820578939674675Gouvernement.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Burton",
            coords = {
                x = -546.13763427734,
                y = -202.42102050781,
            }
        }
    },
    {
        job = "gouv2",
        name = "Gouvernement BC",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/gouv2.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Paleto Boulevard",
            coords = {
                x = -546.13763427734,
                y = -202.42102050781,
            }
        }
    },
    {
        job = "g6",
        name = "Gruppe Sechs (G6)",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/g6.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vespucci Boulevard",
            coords = {
                x = -228.54,
                y = -849.43,
            }
        }
    },
    {
        job = "usmc",
        name = "United States Marine Corps",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/usmc.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Fort Zancudo",
            coords = {
                x = -2348.66,
                y = 3087.48,
            }
        }
    },
    {
        job = "irs",
        name = "Internal Revenue",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/IRS.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Del perro",
            coords = {
                x = -1379.5872802734,
                y = -499.90454101562,
            }
        }
    },
    {
        job = "justice",
        name = "Department Of Justice",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/10606406467817308881105820577962397716DOJ.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Occupation Avenue",
            coords = {
                x = 234.37,
                y = -415.42,
            }
        }
    },
    {
        job = "avocat",
        name = "Barreau de San Andreas",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Barreaudesanandreas.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Occupation Avenue",
            coords = {
                x = 236.05,
                y = -337.74,
            }
        }
    },
    -- {
    --     job = "avocat2",
    --     name = "Avocat Arlington",
    --     icon = "https://cdn.discordapp.com/attachments/1169425615682805871/1169425616471339158/screen02.png?ex=65555b79&is=6542e679&hm=2d6d21033665e52a20b3b420b80ae8bfe3fb9071b5cdde7e08241ac745c567f4&",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "San Andreas Avenue",
    --         coords = {
    --             x = -589.7105102539,
    --             y = -716.3446044921,
    --         }
    --     }
    -- },
    -- {
    --     job = "avocat3",
    --     name = "Avocat De Vignac Lawyers",
    --     icon = "https://cdn.discordapp.com/attachments/1151267951790522500/1185637796833136680/LOGO_DVLC.png",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "San Andreas Avenue",
    --         coords = {
    --             x = -587.62811279297,
    --             y = -721.24523925781,
    --         }
    --     }
    -- },
    {
        job = "taxi",
        name = "Taxi",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Taxi.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Tangerine Street",
            coords = {
                x = 907.3,
                y = -162.6,
            }
        }
    },
    {
        job = "cardealerSud",
        name = "LS Motors",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/cardealerSud.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Adam's Apple Blvd",
            coords = {
                x = -42.2920,
                y = -1098.0633,
            }
        }
    },
    {
        job = "emperium",
        name = "Emperium Records",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/emperium.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vinewood, Spanish Avenue",
            coords = {
                x = 201.87724304199,
                y = -13.821105003357,
            }
        }
    },
    {
        job = "realestateagent",
        name = "Dynasty 8",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Dynasty.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "West Eclipse Blvd",
            coords = {
                x = -706.6,
                y = 268.7,
            }
        }
    },
    {
        job = "pawnshop",
        name = "Pawnshop",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/pawnshop.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "San Vitus Blvd",
            coords = {
                x = -306.16,
                y = -102.4,
            }
        }
    },
    -- {
    --     job = "casse",
    --     name = "Casse",
    --     icon = "https://media.discordapp.net/attachments/1118930689497239693/1122678375903920129/Logo_casse.png",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Sandy Shores",
    --         coords = {
    --             x = 2337.4365234375,
    --             y = 3131.85546875,
    --         }
    --     }
    -- },
    {
        job = "vangelico",
        name = "Vangelico",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Vangelico.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Portola Drive",
            coords = {
                x = -633.1,
                y = -238.8,
            }
        }
    },
    {
        job = "postop",
        name = "Post OP",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/PostOp.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Plaice Place",
            coords = {
                x = -421.8,
                y = -2787.5,
            }
        }
    },
    {
        job = "weazelnews",
        name = "Weazel News",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Weazel.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Little Seoul",
            coords = {
                x = -589.4,
                y = -929.8,
            }
        }
    },
    {
        job = "amerink",
        name = "Amér'ink",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/amerink.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Amér'ink",
            coords = {
                x = 1863.7,
                y = 3748.2,
            }
        }
    },
    --{
    --    job = "records",
    --    name = "50 Label Records",
    --    icon = "https://cdn.discordapp.com/attachments/976949769039659068/1134531540311871568/50record.png",
    --    canCall = true, -- if true, players can call the company
    --    canMessage = true, -- if true, players can message the company
    --    location = {
    --        name = "Spanish Avenue",
    --        coords = {
    --            x = -1020.9,
    --            y = -263.3,
    --        }
    --    }
    --},
    --{
    --    job = "rockford",
    --    name = "69 Music",
    --    icon = "https://cdn.discordapp.com/attachments/1060640646781730888/1123223616524402718/69music.png",
    --    canCall = true, -- if true, players can call the company
    --    canMessage = true, -- if true, players can message the company
    --    location = {
    --        name = "South Blvd Del Perro",
    --        coords = {
    --            x = -1017.228,
    --            y = -265.191,
    --        }
    --    }
    --},
    {
        job = "bennys",
        name = "Benny's",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Bennys.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Alta Street",
            coords = {
                x = -206.8,
                y = -1323.9,
            }
        }
    },
    -- {
    --     job = "cayogarage",
    --     name = "El Rey Motors",
    --     icon = "https://media.discordapp.net/attachments/1164264406956384388/1166644554687070248/IMG_6277.png?ex=654b3d69&is=6538c869&hm=d2adc59e12dca5e3f601eea0555f25cb0da774f0f4382b5ff55b68d81d7c2377&=",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Cayo Perico",
    --         coords = {
    --             x = 5122.604,
    --             y = -5132.94,
    --         }
    --     }
    -- },
    -- {
    --     job = "hayes",
    --     name = "Hayes Auto",
    --     icon = "",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "POS",
    --         coords = {
    --             x = -11206.8,-- pos à mettre
    --             y = -11323.9,
    --         }
    --     }
    -- },
    -- {
    --     job = "beekers",
    --     name = "Beekers Garage & Parts",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/BeekerGarage.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Paleto bay",
    --         coords = {
    --             x = 152.50891113281, -- pos à mettre
    --             y = 6397.6323242188,
    --         }
    --     }
    -- },
    {
        job = "rockford",
        name = "Rockford Studio",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/RockfordStudio.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "POS",
            coords = {
                x = -1007.3261108398,
                y = -269.92852783203,
            }
        }
    },
    {
        job = "harmony",
        name = "Harmony Repair",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/HarmonyRepair.webp",
        canCall = true,    --if true, players can call the company
        canMessage = true, --if true, players can message the company
        location = {
            name = "Senora Way",
            coords = {
                x = 2524.7,
                y = 2630.5,
            }
        }
    },
    {
        job = "ocean",
        name = "Auto Exotic",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/autoexotic.webp",
        canCall = true, -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vinewood",
            coords = {
                x = 539.0112,
                y = -183.9149,
            }
        }
    },
    -- {
    --     job = "bahamas",
    --     name = "Bahamas",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Bahamas.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Marathon Avenue",
    --         coords = {
    --             x = -1386.5,
    --             y = -601.2,
    --         }
    --     }
    -- },
    {
        job = "unicorn",
        name = "Unicorn",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Unicorn.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Elgin Avenue",
            coords = {
                x = 127.6,
                y = -1298.6,
            }
        }
    },
	{
        job = "burgershot",
        name = "Burgershot",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/burgershot.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Mirror Park",
            coords = {
                x = 1240.7067874,
                y = -368.0466008,
            }
        }
    },
	-- {
    --     job = "skyblue",
    --     name = "Skyblue",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/skyblue.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Morningwood Blvd",
    --         coords = {
    --             x = -1138.45,
    --             y = -199.83,
    --         }
    --     }
    -- },
    --[[ {
        job = "royalhotel",
        name = "Royal Hotel",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/royalhotel.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vinewood Centre",
            coords = {
                x = 392.97222900391,
                y = -0.37851917743683,
            }
        }
    }, ]]
    --[[ {
        job = "comrades",
        name = "Comrades bar",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Comrades_.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Red Desert Avenue",
            coords = {
                x = -1583.4,
                y = -992.3,
            }
        }
    }, ]]
    {
        job = "bayviewLodge",
        name = "Bayview Lodge",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/BayviewLodge.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Procopio Promenade",
            coords = {
                x = -702.3,
                y = -5805.4,
            }
        }
    },
    {
        job = "yellowJack",
        name = "YellowJack",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/yellowJack.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Route 68 / Panorama Drive",
            coords = {
                x = 1992.6,
                y = 3057.4,
            }
        }
    },
    -- {
    --     job = "blackwood",
    --     name = "BlackWood Saloon",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/blackwood.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Paleto Bay",
    --         coords = {
    --             x = -300.19,
    --             y = 6256.19,
    --         }
    --     }
    -- },
     {
        job = "uwu",
        name = "uWu Cafe",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/UwUCafe.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Little Seoul",
            coords = {
                x = -579.3,
                y = -1070.9,
            }
        }
    },
    {
        job = "pizzeria",
        name = "Pizza This",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/pizzeria.webp",
        canCall = true,    --if true, players can call the company
        canMessage = true, --if true, players can message the company
        location = {
            name = "Popular Street",
            coords = {
                x = 805.0,
                y = -752.41,
            }
        }
    },
    -- {
    --     job = "pearl",
    --     name = "Pearl",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/pearls.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Del Perro Beach",
    --         coords = {
    --             x = -1827.4,
    --             y = -1194.7,
    --         }
    --     }
    -- },
    --  {
    --      job = "upnatom",
    --      name = "Up'n Atom",
    --      icon = "https://media.discordapp.net/attachments/498529074717917195/1143526855165607946/Up-n-Atom.png?width=1440&height=645",
    --      canCall = true, -- if true, players can call the company
    --      canMessage = true, -- if true, players can message the company
    --      location = {
    --          name = "vinewood Boulevard",
    --          coords = {
    --              x = 85.5,
    --              y = 287.0,
    --          }
    --      }
    --  },
    --  {
    --      job = "hornys",
    --      name = "Horny's",
    --      icon = "https://cdn.discordapp.com/attachments/498529074717917195/1209110497023107092/hornys.png?ex=65e5bae6&is=65d345e6&hm=84b76f12fa50a3591b82b2e915d45cf7f4ab6b6d17b2afc72c04572939842d40&",
    --      canCall = true, -- if true, players can call the company
    --      canMessage = true, -- if true, players can message the company
    --      location = {
    --          name = "Mirror Park Boulevard",
    --          coords = {
    --              x = 1244.4,
    --              y = -355.7,
    --          }
    --      }
    --  },
    -- {
    --     job = "cluckin",
    --     name = "Cluckin Bell",
    --     icon = "https://media.discordapp.net/attachments/1060640646781730888/1105820550850416670/cluckin.png",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Rockford Plaza",
    --         coords = {
    --             x = -142.92512512207,
    --             y = -260.79776000977,
    --         }
    --     }
    -- },
    -- {
    --     job = "bean",
    --     name = "Bean Machine",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/beanmachine.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Vinewood, Eclipse Boulevard",
    --         coords = {
    --             x = -628.45965576172,
    --             y = 234.06652832031,
    --         }
    --     }
    -- },
    {
        job = "mirror",
        name = "Le Miroir",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/mirror.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Mirror Park",
            coords = {
                x = 1124.2,
                y = -646.6,
            }
        }
    },
    {
        job = "rexdiner",
        name = "Rex Diner",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/rexdiner.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Sandy Shores",
            coords = {
                x = 2540.1069335938,
                y = 2588.9208984375,
            }
        }
    },
    -- {
    --     job = "pops",
    --     name = "Pop's Diner",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/PopsDiner.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Paleto Bay",
    --         coords = {
    --             x = 1586.2,
    --             y = 6448.8,
    --         }
    --     }
    -- },
    -- {
    --     job = "hornys",
    --     name = "Horny's",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Hornys.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Mirror Park",
    --         coords = {
    --             x = 1240.7067874,
    --             y = -368.0466008,
    --         }
    --     }
    -- },
    {
        job = "tacosrancho",
        name = "Tacos 2 Rancho",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/TacosRancho.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Rancho",
            coords = {
                x = 409.09194989,
                y = -1910.4439266,
            }
        }
    },
    {
        job = "ltdsud",
        name = "LTD",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/LTD.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "LTD Grove Street",
            coords = {
                x = -54.1,
                y = -1758.1,
            }
        }
    },
    {
        job = "ltdseoul",
        name = "LTD Seoul",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/LTD.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "LTD Little Séoul",
            coords = {
                x = -709.4,
                y = -912.1,
            }
        }
    },
    {
        job = "don",
        name = "Rex Store",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/RexStore.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Grand senora",
            coords = {
                x = 2540.9372558594,
                y = 2637.624267575,
            }
        }
    },
    {
        job = "sandybeauty",
        name = "Beauty Bar",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Beauty.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Portola Drive",
            coords = {
                x = -764.49102783203,
                y = -156.89491271973,
            }
        }
    },
    {
        job = "domaine",
        name = "Vigneron",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Vigneron.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Buen Vino Road",
            coords = {
                x = -1890.13,
                y = 2046.05,
            }
        }
    },
    -- {
    --     job = "hayes",
    --     name = "Hayes Auto",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Hayes.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Del Perro",
    --         coords = {
    --             x = -1427.7088047,
    --             y = -440.78134273,
    --         }
    --     }
    -- },
    {
        job = "barber2",
        name = "O'Sheas Barber",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/OSheasBarber.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Carson Avenue",
            coords = {
                x = -1290.75,
                y = -1118.1810,
            }
        }
    },
    {
        job = "barber",
        name = "Hair Top",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/HairTop.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Rockford Hills",
            coords = {
                x = -826.01,
                y = -186.25,
            }
        }
    },
    -- {
    --     job = "barbercayo",
    --     name = "Barber de CayoPerico",
    --     icon = "https://cdn.discordapp.com/attachments/1054171163154202777/1141425982444667011/image.psd_3.png",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Cayo Perico",
    --         coords = {
    --             x = 5149.097,
    --             y = -5135.342,
    --         }
    --     }
    -- },
    --[[{
        job = "barberNord",
        name = "Murph'Hair",
        icon = "https://media.discordapp.net/attachments/1060640646781730888/1126814147510808576/index.png",
        canCall = true, -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Sandy Shores",
            coords = {
                x = 1934.3594970703,
                y = 3724.2487792969,
            }
        }
    },]]
    {
        job = "tattooSud",
        name = "Tattoo King",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/tattooking.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vinewood Blvd",
            coords = {
                x = 320.3,
                y = 176.5,
            }
        }
    },
    -- {
    --     job = "tacosrancho",
    --     name = "Tacos Rancho",
    --     icon = "https://cdn.discordapp.com/attachments/1151234432334823426/1151234434356490363/tacos2rancho.png",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Carson Avenue",
    --         coords = {
    --             x = 413.4,
    --             y = -1910.6,
    --         }
    --     }
    -- },
    {
        job = "tattooNord",
        name = "Tattoo Paleto",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/MayansTattoo.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Sandy Shores",
            coords = {
                x = -293.80157470703,
                y = 6199.09375,
            }
        }
    },
    {
        job = "cluckin",
        name = "Cluckin' Bell",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/cluckin.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Vinewood",
            coords = {
                x = -142.03291320801,
                y = -263.01803588867,
            }
        }
    },
    --{
    --job = "domaine",
    --    name = "Domaine Fitzgerald",
    --    icon = "https://media.discordapp.net/attachments/1060640646781730888/1105862851299655730/domaine.png",
    --    canCall = true, -- if true, players can call the company
    --    canMessage = true, -- if true, players can message the company
    --    location = {
    --        name = "Buen Vino Road",
    --        coords = {
    --            x = -1890.13,
    --            y = 2046.05,
    --        }
    --    }
    --},
    {
        job = "heliwave",
        name = "Heliwave",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Heliwave.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Tackle Street",
            coords = {
                x = -807.09,
                y = -1335.45,
            }
        }
    },
    -- {
    --     job = "emperium",
    --     name = "Emperium Records",
    --     icon = "https://media.discordapp.net/attachments/1152038925481807902/1152038929168617502/Empirum_Records.png?width=671&height=671",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Los Santos",
    --         coords = {
    --             x = -440.2,
    --             y = 160.7,
    --         }
    --     }
    -- },
    {
        job = "cardealerNord",
        name = "American Motors",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/cardealerNord.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Route 68",
            coords = {
                x = -238.35510253906,
                y = 6182.705078125,
            }
        }
    },
    {
        job = "ammunation",
        name = "Ammunation",
        icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/Ammunation.webp",
        canCall = true,    -- if true, players can call the company
        canMessage = true, -- if true, players can message the company
        location = {
            name = "Adam's Apple Boulevard",
            coords = {
                x = 6.4061846733093,
                y = -1107.3282470703,
            }
        }
    },
    -- {
    --     job = "vclub",
    --     name = "VClub",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/vclub.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Route 68",
    --         coords = {
    --             x = -14.803745269775,
    --             y = 241.90148925781,
    --         }
    --     }
    -- },
    -- {
    --     job = "club77",
    --     name = "Club 77",
    --     icon = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/club77.webp",
    --     canCall = true,    -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Route 68",
    --         coords = {
    --             x = 196.105087,
    --             y = -3168.764404,
    --         }
    --     }
    -- },
    -- {
    -- job = "hayes",
    --     name = "Hayes Auto",
    --     icon = "https://cdn.discordapp.com/attachments/498529074717917195/1143526771120160848/HayesAuto.png",
    --     canCall = true, -- if true, players can call the company
    --     canMessage = true, -- if true, players can message the company
    --     location = {
    --         name = "Del Perro",
    --         coords = {
    --             x = -1422.1280517578,
    --             y = -439.032012939,
    --         }
    --     }
    -- },
}

Config.Companies.Contacts = { -- not needed if you use the services app, this will add the contact to the contacts app
    -- ["police"] = {
    --     name = "Police",
    --     photo = "https://cdn-icons-png.flaticon.com/512/7211/7211100.png"
    -- },
    ["lspd"] = {
        name = "LSPD",
        photo = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/lspd.webp"
    },
    ["lssd"] = {
        name = "LSSD",
        photo = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/lssd.webp"
    },
    ["ems"] = {
        name = "SAMS",
        photo = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/ems.webp"
    },
    ["lsfd"] = {
        name = "LSFD",
        photo = "https://cdn.sacul.cloud/v2/vision-cdn/ImagesEtp/lsfd.webp"
    }
}

Config.Companies.Management = {
    Enabled = false, -- if true, employees & the boss can manage the company

    Duty = true, -- if true, employees can go on/off duty
    -- Boss actions
    Deposit = true, -- if true, the boss can deposit money into the company
    Withdraw = true, -- if true, the boss can withdraw money from the company
    Hire = true, -- if true, the boss can hire employees
    Fire = true, -- if true, the boss can fire employees
    Promote = true, -- if true, the boss can promote employees
}

Config.CustomApps = {
} -- https://docs.lbscripts.com/phone/custom-apps/

Config.Valet = {}
Config.Valet.Enabled = false -- allow players to get their vehicles from the phone
Config.Valet.Price = 100 -- price to get your vehicle
Config.Valet.Model = 'S_M_Y_XMech_01'
Config.Valet.Drive = true -- should a ped bring the car, or should it just spawn in front of the player?
Config.Valet.DisableDamages = false -- disable vehicle damages (engine & body health) on esx
Config.Valet.FixTakeOut = false -- repair the vehicle after taking it out?

Config.HouseScript = "auto" --[[
    The housing script you use on your server
    Supported:
        * loaf_housing - https://store.loaf-scripts.com/package/4310850
        * qb-houses - https://github.com/qbcore-framework/qb-houses
        * qs-housing - https://buy.quasar-store.com/package/5677308
]]

--[[ VOICE OPTIONS ]] --
Config.Voice = {}
Config.Voice.CallEffects = true -- enable call effects while on speaker mode? (NOTE: This may create sound-issues if you have too many submixes registered in your server)
Config.Voice.System = "pma"
--[[
    Supported voice systems:
        * pma: pma-voice - HIGHLY RECOMMENDED
        * mumble: mumble-voip - Not recommended, update to pma-voice
        * salty: saltychat - Not recommended, change to pma-voice
        * toko: tokovoip - Not recommended, change to pma-voice
]]

Config.Voice.HearNearby = true --[[
    Only works with pma-voice

    If true, players will be heard on instagram live if they are nearby
    If false, only the person who is live will be heard

    If true, allow nearby players to listen to phone calls if speaker is enabled
    If false, only the people in the call will be able to hear each other

    This feature is a work in progress and may not work as intended. It may have an impact on performance.
]]

Config.Voice.RecordNearby = true --[[
    Should video recordings include nearby players?
]]

--[[ PHONE OPTIONS ]] --
Config.Locations = { -- Locations that'll appear in the maps app.
}

Config.Locales = { -- languages that the player can choose from when setting up a phone [Check the docs to see which languages the phone supports]
    {
        locale = "en",
        name = "English"
    },
    {
        locale = "de",
        name = "Deutsch"
    },
    {
        locale = "fr",
        name = "Français"
    },
    {
        locale = "es",
        name = "Español"
    },
    {
        locale = "nl",
        name = "Nederlands"
    },
    {
        locale = "dk",
        name = "Dansk"
    },
    {
        locale = "no",
        name = "Norsk"
    },
    {
        locale = "th",
        name = "ไทย"
    },
    {
        locale = "ar",
        name = "عربي"
    },
    {
        locale = "ru",
        name = "Русский"
    },
    {
        locale = "cs",
        name = "Czech"
    },
    {
        locale = "sv",
        name = "Svenska"
    },
    {
        locale = "pl",
        name = "Polski"
    },
    {
        locale = "hu",
        name = "Magyar"
    },
    {
        locale = "tr",
        name = "Türkçe"
    },
    {
        locale = "pt-br",
        name = "Português (Brasil)"
    },
    {
        locale = "pt-pt",
        name = "Português"
    },
    {
        locale = "it",
        name = "Italiano"
    },
    {
        locale = "ua",
        name = "Українська"
    }
}

Config.DefaultLocale = "fr"
Config.DateLocale = "fr-FR" -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat

Config.FrameColor = "#39334d" -- This is the color of the phone frame. Default (#39334d) is SILVER.
Config.AllowFrameColorChange = true -- Allow players to change the color of their phone frame?

Config.PhoneNumber = {}
Config.PhoneNumber.Format = "{3}{3}{4}" -- Don't touch unless you know what you're doing. IMPORTANT: The sum of the numbers needs to be equal to the phone number length + prefix length
Config.PhoneNumber.Length = 7 -- This is the length of the phone number WITHOUT the prefix.
Config.PhoneNumber.Prefixes = { -- These are the first numbers of the phone number, usually the area code. They all need to be the same length
    "555"
}

Config.Battery = {} -- WITH THESE SETTINGS, A FULL CHARGE WILL LAST AROUND 2 HOURS.
Config.Battery.Enabled = false -- Enable battery on the phone, you'll need to use the exports to charge it.
Config.Battery.ChargeInterval = { 5, 10 } -- How much battery
Config.Battery.DischargeInterval = { 50, 60 } -- How many seconds for each percent to be removed from the battery
Config.Battery.DischargeWhenInactiveInterval = { 80, 120 } -- How many seconds for each percent to be removed from the battery when the phone is inactive
Config.Battery.DischargeWhenInactive = true -- Should the phone remove battery when the phone is closed?

Config.CurrencyFormat = "$%s" -- ($100) Choose the formatting of the currency. %s will be replaced with the amount.
Config.MaxTransferAmount = 20000 -- The maximum amount of money that can be transferred at once via wallet / messages.

Config.TransferLimits = {}
Config.TransferLimits.Daily = false -- The maximum amount of money that can be transferred in a day. Set to false for unlimited.
Config.TransferLimits.Weekly = false -- The maximum amount of money that can be transferred in a week. Set to false for unlimited.

Config.EnableMessagePay = true -- Allow players to pay other players via messages?
Config.EnableVoiceMessages = true -- Allow players to send voice messages?

Config.CityName = "Los Santos" -- The name that's being used in the weather app etc.
Config.RealTime = true -- if true, the time will use real life time depending on where the user lives, if false, the time will be the ingame time.
Config.CustomTime = false -- NOTE: disable Config.RealTime if using this. you can set this to a function that returns custom time, as a table: { hour = 0-24, minute = 0-60 }

Config.EmailDomain = "vision.com"
Config.AutoCreateEmail = false -- should the phone automatically create an email for the player when they set up the phone?
Config.DeleteMail = true -- allow players to delete mails in the mail app?

Config.DeleteMessages = true -- allow players to delete messages in the messages app?

Config.SyncFlash = true -- should flashlights be synced across all players? May have an impact on performance
Config.EndLiveClose = false -- should InstaPic live end when you close the phone?

Config.AllowExternal = { -- allow people to upload external images? (note: this means they can upload nsfw / gore etc)
    Gallery = true, -- allow importing external links to the gallery?
    Birdy = true, -- set to true to enable external images on that specific app, set to false to disable it.
    InstaPic = true,
    Spark = true,
    Trendy = true,
    Pages = true,
    MarketPlace = true,
    Mail = true,
    Messages = true,
    Other = true, -- other apps that don't have a specific setting (ex: setting a profile picture for a contact, backgrounds for the phone etc)
}

-- Blacklisted domains for external images. You will not be able to upload from these domains.
Config.ExternalBlacklistedDomains = {
}

-- Whitelisted domains for external images. If this is not empty/nil/false, you will only be able to upload images from these domains.
Config.ExternalWhitelistedDomains = {
    -- "fivemanage.com"
}

-- Set to false/empty to disable
Config.UploadWhitelistedDomains = { -- domains that are allowed to upload images to the phone (prevent using devtools to upload images)
    "cdn.sacul.cloud",
}

Config.WordBlacklist = {}
Config.WordBlacklist.Enabled = false
Config.WordBlacklist.Apps = { -- apps that should use the word blacklist (if Config.WordBlacklist.Enabled is true)
    Birdy = true,
    InstaPic = true,
    Trendy = true,
    Spark = true,
    Messages = true,
    Pages = true,
    MarketPlace = true,
    DarkChat = true,
    Mail = true,
    Other = true,
}
Config.WordBlacklist.Words = {
    -- array of blacklisted words, e.g. "badword", "anotherbadword"
}

Config.AutoFollow = {}
Config.AutoFollow.Enabled = false

Config.AutoFollow.Birdy = {}
Config.AutoFollow.Birdy.Enabled = true
Config.AutoFollow.Birdy.Accounts = {} -- array of usernames to automatically follow when creating an account. e.g. "username", "anotherusername"

Config.AutoFollow.InstaPic = {}
Config.AutoFollow.InstaPic.Enabled = true
Config.AutoFollow.InstaPic.Accounts = {} -- array of usernames to automatically follow when creating an account. e.g. "username", "anotherusername"

Config.AutoFollow.Trendy = {}
Config.AutoFollow.Trendy.Enabled = true
Config.AutoFollow.Trendy.Accounts = {} -- array of usernames to automatically follow when creating an account. e.g. "username", "anotherusername"

Config.AutoBackup = true -- should the phone automatically create a backup when you get a new phone?

Config.Post = {} -- What apps should send posts to discord? You can set your webhooks in server/webhooks.lua
Config.Post.Birdy = true -- Announce new posts on Birdy?
Config.Post.InstaPic = true -- Anmnounce new posts on InstaPic?
Config.Post.Accounts = {
    Birdy = {
        Username = "Birdy",
        Avatar = "https://loaf-scripts.com/fivem/lb-phone/icons/Birdy.png"
    },
    InstaPic = {
        Username = "InstaPic",
        Avatar = "https://loaf-scripts.com/fivem/lb-phone/icons/InstaPic.png"
    }
}

Config.BirdyTrending = {}
Config.BirdyTrending.Enabled = true -- show trending hashtags?
Config.BirdyTrending.Reset = 7 * 24 -- How often should trending hashtags be reset on birdy? (in hours)

Config.BirdyNotifications = false -- should everyone get a notification when someone posts?

Config.PromoteBirdy = {}
Config.PromoteBirdy.Enabled = false -- should you be able to promote post?
Config.PromoteBirdy.Cost = 2500 -- how much does it cost to promote a post?
Config.PromoteBirdy.Views = 100 -- how many views does a promoted post get?

Config.TrendyTTS = {
    {"English (US) - Female", "en_us_001"},
    {"English (US) - Male 1", "en_us_006"},
    {"English (US) - Male 2", "en_us_007"},
    {"English (US) - Male 3", "en_us_009"},
    {"English (US) - Male 4", "en_us_010"},

    {"English (UK) - Male 1", "en_uk_001"},
    {"English (UK) - Male 2", "en_uk_003"},

    {"English (AU) - Female", "en_au_001"},
    {"English (AU) - Male", "en_au_002"},

    {"French - Male 1", "fr_001"},
    {"French - Male 2", "fr_002"},

    {"German - Female", "de_001"},
    {"German - Male", "de_002"},

    {"Spanish - Male", "es_002"},

    {"Spanish (MX) - Male", "es_mx_002"},

    {"Portuguese (BR) - Female 2", "br_003"},
    {"Portuguese (BR) - Female 3", "br_004"},
    {"Portuguese (BR) - Male", "br_005"},

    {"Indonesian - Female", "id_001"},

    {"Japanese - Female 1", "jp_001"},
    {"Japanese - Female 2", "jp_003"},
    {"Japanese - Female 3", "jp_005"},
    {"Japanese - Male", "jp_006"},

    {"Korean - Male 1", "kr_002"},
    {"Korean - Male 2", "kr_004"},
    {"Korean - Female", "kr_003"},

    {"Ghostface (Scream)", "en_us_ghostface"},
    {"Chewbacca (Star Wars)", "en_us_chewbacca"},
    {"C3PO (Star Wars)", "en_us_c3po"},
    {"Stitch (Lilo & Stitch)", "en_us_stitch"},
    {"Stormtrooper (Star Wars)", "en_us_stormtrooper"},
    {"Rocket (Guardians of the Galaxy)", "en_us_rocket"},

    {"Singing - Alto", "en_female_f08_salut_damour"},
    {"Singing - Tenor", "en_male_m03_lobby"},
    {"Singing - Sunshine Soon", "en_male_m03_sunshine_soon"},
    {"Singing - Warmy Breeze", "en_female_f08_warmy_breeze"},
    {"Singing - Glorious", "en_female_ht_f08_glorious"},
    {"Singing - It Goes Up", "en_male_sing_funny_it_goes_up"},
    {"Singing - Chipmunk", "en_male_m2_xhxs_m03_silly"},
    {"Singing - Dramatic", "en_female_ht_f08_wonderful_world"}
}

-- ICE Servers for WebRTC (ig live, live video). If you don't know what you're doing, leave this as it is.
-- see https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/RTCPeerConnection
-- Config.RTCConfig = {
--     iceServers = {
--         { urls = "stun:stun.l.google.com:19302" },
--     }
-- }

Config.Crypto = {}
Config.Crypto.Enabled = false
Config.Crypto.Coins = {}
Config.Crypto.Currency = "usd" -- currency to use for crypto prices. https://api.coingecko.com/api/v3/simple/supported_vs_currencies
Config.Crypto.Refresh = false -- how often should the crypto prices be refreshed (client cache)? (Default 5 minutes) 
Config.Crypto.QBit = true -- support QBit? (requires qb-crypto & qb-core)

Config.KeyBinds = {
    Open = { -- pour ouvrir le téléphone
        Command = "phone",
        Bind = "W",
        Description = "Ouvrir votre téléphone"
    },
    Focus = { -- raccourci pour basculer le curseur de la souris.
        Command = "togglePhoneFocus",
        Bind = "LMENU",
        Description = "Basculer le curseur sur votre téléphone"
    },
    StopSounds = { -- en cas de problème de son, vous pouvez utiliser cette commande pour arrêter tous les sons.
        Command = "stopSounds",
        Bind = false,
        Description = "Arrêter tous les sons du téléphone"
    },

    FlipCamera = {
        Command = "flipCam",
        Bind = "UP",
        Description = "Retourner la caméra du téléphone"
    },
    TakePhoto = {
        Command = "takePhoto",
        Bind = "RETURN",
        Description = "Prendre une photo / vidéo"
    },
    ToggleFlash = {
        Command = "toggleCameraFlash",
        Bind = "E",
        Description = "Activer/désactiver le flash"
    },
    LeftMode = {
        Command = "leftMode",
        Bind = "LEFT",
        Description = "Changer de mode"
    },
    RightMode = {
        Command = "rightMode",
        Bind = "RIGHT",
        Description = "Changer de mode"
    },

    AnswerCall = {
        Command = "answerCall",
        Bind = "RETURN",
        Description = "Répondre à l'appel entrant"
    },
    DeclineCall = {
        Command = "declineCall",
        Bind = "BACK",
        Description = "Refuser l'appel entrant"
    },
    UnlockPhone = {
        Bind = "SPACE",
        Description = "Déverrouiller votre téléphone",
    },
}

Config.KeepInput = true -- keep input when nui is focused (meaning you can walk around etc)

--[[ PHOTO / VIDEO OPTIONS ]] --
-- Set your api keys in lb-phone/server/apiKeys.lua
Config.UploadMethod = {}
-- You can edit the upload methods in lb-phone/shared/upload.lua
-- We recommend Fivemanage, https://fivemanage.com
-- A video tutorial for how to set up Fivemanage can be found here: https://www.youtube.com/watch?v=y3bCaHS6Moc
-- If you want to host uploads yourself, you can use LBUpload: https://github.com/lbphone/lb-upload
-- We STRONGLY discourage using Discord as an upload method, as uploaded files may become inaccessible after a while.
Config.UploadMethod.Video = "Custom" -- "Fivemanage" or "LBUpload" or "Custom"
Config.UploadMethod.Image = "Custom" -- "Fivemanage" or "LBUpload" or "Custom
Config.UploadMethod.Audio = "Custom" -- "Fivemanage" or "LBUpload" or "Custom"

Config.Video = {}
Config.Video.Bitrate = 400 -- video bitrate (kbps), increase to improve quality, at the cost of file size
Config.Video.FrameRate = 24 -- video framerate (fps), 24 fps is a good mix between quality and file size used in most movies
Config.Video.MaxSize = 25 -- max video size (MB)
Config.Video.MaxDuration = 60 -- max video duration (seconds)

Config.Image = {}
Config.Image.Mime = "image/webp" -- image mime type, "image/webp" or "image/png" or "image/jpg"
Config.Image.Quality = 1.0
