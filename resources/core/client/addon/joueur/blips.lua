local blips = {
    -- Bars et restaurants
    { title = "Rex Diner's",           colour = 1,     id = 488,    x = 2542.720703,      y = 2588.763916,      z = 38.49749756 },
    -- { title = "Pop's Diner",           colour = 30,    id = 267,    x = 1594.431152,      y = 6447.321777,      z = 25.31702042 },
    { title = "Pearl's",               colour = 30,    id = 356,    x = -1805.906494,     y = -1183.487549,     z = 13.01787472 },
    -- { title = "VClub",                 colour = 27,    id = 93,     x = -14.46076393,     y = 239.6986542,      z = 109.5539474 },
    -- { title = "Club 77",               colour = 61,    id = 93,     x = 247.393,          y = -3187.8,          z = 0.5539474 },
    { title = "Pizza This",            colour = 17,    id = 570,    x = 800.3843384,      y = -751.0249023,     z = 37.74677658 },
    { title = "Yellow Jack",           colour = 70,    id = 93,     x = 1990.201294,      y = 3051.650635,      z = 46.39722443 },
    -- { title = "Horny's",               colour = 1,     id = 80,     x = 1247.680298,      y = -361.3826294,     z = 69.08210754 },
    { title = "Le Mirroir",            colour = 1,     id = 78,     x = 1113.08,      	  y = -646.62,     		z = 58.04 },
    { title = "Tacos Rancho",          colour = 28,    id = 79,     x = 419.2044067,      y = -1920.23999,      z = 31.17249107 },
    { title = "Bean Machine",          colour = 21,    id = 106,    x = -628.2904663,     y = 233.5039825,      z = 81.88162994 },
    { title = "Blackwoods Saloons",    colour = 21,    id = 93,     x = -302.546814,      y = 6267.904785,      z = 31.52687836 },
    { title = "Bayview Lodge",    	   colour = 21,    id = 93,     x = -700.03,      	  y = 5804.11,      	z = 16.33 },
    { title = "Skyblue",   			   colour = 21,    id = 120,    x = -1138.46,         y = -199.82,     		z = 36.96 },
    { title = "Burgershot",    		   colour = 1,     id = 106,    x = 1247.680298,      y = -361.3826294,     z = 69.08210754 },
    { title = "Vanilla Unicorn",       colour = 48,    id = 121,    x = 114.6701355,      y = -1293.665527,     z = 35.0110321 },
    -- { title = "Bahama Mamas",          colour = 27,    id = 93,     x = -1388.157227,     y = -609.6325073,     z = 36.18535233 },
    -- { title = "UwU Café",              colour = 34,    id = 304,    x = -585.5067139,     y = -1057.513794,     z = 22.34418869 },
    -- { title = "Comrades bar",          colour = 36,    id = 362,    x = -1594.302734,     y = -990.934082,      z = 13.07522583 },
    { title = "Angels Tavern Pub",     colour = 2,       id = 93, x = 1844.02, y = 3830.89, z = 33.05 },

    -- Commerce
    { title = "Taxi",                  	colour = 46,    id = 198,    x = 903.5290527,      y = -153.7855072,     z = 74.14694214 },
    { title = "Dynasty 8",    			colour = 25,    id = 374,    x = -706.3028564,     y = 268.5766296,      z = 83.1473465 },
    { title = "Beauty Bar",            	colour = 48,    id = 279,    x = -767.3425903,     y = -158.6407928,     z = 37.48794556 },
    { title = "Pawn Shop",             	colour = 81,    id = 267,    x = -295.0291748,     y = -106.3585815,     z = 47.05137253 },
    { title = "Ammunation",          	colour = 1,     id = 313,    x = 11.35808754,      y = -1106.982056,     z = 29.79720497 },
    { title = "O'Sheas Barber",        	colour = 2,     id = 71,     x = -817.2774658,     y = -177.2144928,     z = 48.16550446 },
    { title = "Vangelico",             	colour = 38,    id = 617,    x = -621.9736938,     y = -230.7476807,     z = 38.05703354 },
    { title = "Rockford Records",      	colour = 40,    id = 136,    x = -1009.69,         y = -271.22,     	 z = 38.04 },
    { title = "Rex Store",             	colour = 1,     id = 52,     x = 2541.035645,      y = 2639.229248,      z = 37.94542694 },
    { title = "Post Op",              	 colour = 21,    id = 478,    x = -426.2055054,    y = -2808.394287,     z = 5.994943142 },
    -- { title = "Hôtel Royal",           colour = 83,    id = 475,    x = 399.3845825,    y = -2.504624605,     z = 91.93530273 },
    { title = "Weazel News",           	colour = 1,     id = 184,    x = -588.1992188,     y = -924.2962646,     z = 23.81571198 },
    
    
    -- Garage et concessions
    { title = "American Motors",       colour = 29,    id = 225,    x = -247.8470917,     y = 6212.800293,      z = 31.94389343 },
    { title = "LS Motors",             colour = 29,    id = 225,    x = -44.21479797,     y = -1097.549194,     z = 29.14666748 },
    { title = "Heliwave",              colour = 73,    id = 404,    x = -803.9783936,     y = -1356.129028,     z = 7.358842373 },
    { title = "Benny's",               colour = 49,    id = 446,    x = -212.4542389,     y = -1325.876099,     z = 34.20493317 },
    { title = "Hayes Auto",            colour = 38,    id = 225,    x = -1415.268555,     y = -446.7616882,     z = 35.90968704 },
    { title = "Harmony's Repair",      colour = 64,    id = 446,    x = 2524.101318,      y = 2635.753174,      z = 43.69556046 },
    { title = "Beekers garage",        colour = 10,    id = 446,    x = 158.5703125,      y = 6375.534668,      z = 30.94210052 },
    { title = "Auto Exotic",           colour = 38,    id = 446,    x = 549.15,           y = -177.42,          z = 53.51 },
    -- 911
    { title = "Los Santos Sheriff Department (LSSD)",     	colour = 5,     id = 60,     x = 1714.69,          y = 3873.55,          z = 34.03, },
    { title = "Los Santos Sheriff Department (LSSD)",     	colour = 5,     id = 60,     x = 2808.08,          y = 4755.95,          z = 47.28, },
    { title = "Gouvernement",          						colour = 37,    id = 419,    x = -410.7909241,     y = 6144.388672,      z = 32.31295013 },
    { title = "Gouvernement",         						colour = 37,    id = 419,    x = -546.1376343,     y = -202.4210205,     z = 38.21968079 },
    { title = "Los Santos Police Department (LSPD)",        colour = 3,     id = 60,     x = -1095.264771,     y = -833.4752197,     z = 37.67462158 }, -- VP
    { title = "Los Santos Police Department (LSPD)",        colour = 3,     id = 60,     x = 440.03,     	  y = -982.71,     		z = 29.69 }, -- MR
    { title = "Los Santos Police Department (LSPD)",        colour = 3,     id = 60,     x = 620.52,     	  y = 19.06,     		z = 86.95 }, -- VINEWOOD
    { title = "Hôpital",  			   						colour = 75,    id = 61,     x = 366.21,           y = -593.7,           z = 27.7 },
    { title = "Hôpital",    		   						colour = 75,    id = 61,     x = -54.87,          y = 6526.17,          z = 30.46 },
    { title = "LSFD",                  						colour = 49,    id = 436,    x = -1044.71,      	  y = -1398.86,      		z = 4.08 },
    { title = "G6",                    						colour = 25,    id = 487,    x = 760.49,      	  y = -1388.35, 		z = 26.09 },
    { title = "Justice Court",         						colour = 0,     id = 419,    x = 234.37,           y = -415.42,          z = 47.1 },
    -- { title = "IRS",                   colour = 13,    id = 685,    x = -1374.357422,     y = -491.9956055,     z = 33.16191101 },


    -- Events
    { title = "Studio Vinewood",       colour = 60,    id = 135,    x = -258.3291321,     y = 237.5116577,      z = 92.09402466 },
    { title = "Maze Bank Arena",       colour = 75,    id = 685,    x = -324.1612854,     y = -1968.447021,     z = 21.60749435 },
    --{title="~y~Vote", colour=29, id=280, x=-279.29153442383, y=-1931.2640380859, z=30.149223327637},
    
    -- Jobs interims
    { title = "Facteur",               colour = 26,    id = 525,    x = -258.2807922,     y = -844.2767944,     z = 31.3861599 },
    { title = "Routier",               colour = 3,     id = 479,    x = 861.7963867,      y = -3184.998535,     z = 6.034949303 },
    { title = "Go Postal",             colour = 26,    id = 541,    x = 63.67985153,      y = 120.9262314,      z = 79.13076019 },
    { title = "Éboueur",               colour = 26,    id = 318,    x = -429.7324524,     y = -1728.139771,     z = 19.78383827 },
    { title = "Livreur de pizza",      colour = 26,    id = 559,    x = 287.2937927,      y = -962.9272461,     z = 29.41863632 },
    { title = "Pompiste",              colour = 3,     id = 648,    x = -1053.125244,     y = -2032.430786,     z = 13.16157341 },
    { title = "Mine",                  colour = 26,    id = 527,    x = 2827.881592,      y = 2810.957031,      z = 57.41151047 },
    { title = "Pêche",                 colour = 3,     id = 68,     x = -290.1379395,     y = -2768.925293,     z = 2.195296049 },
    { title = "Ferme",                 colour = 26,    id = 85,     x = 1969.226318,      y = 5168.993164,      z = 47.63908768 },
    { title = "Pilote d'avion",        premium = true, colour = 46, id = 572,             x = -992.7682495,     y = -2942.412109,   z = 13.95703506 },
    { title = "Canadair",              premium = true, colour = 46, id = 580,             x = 2137.99,          y = 4797.1,         z = 40.13 },
    { title = "Chasse",                colour = 3,     id = 442,    x = -1493.080933,     y = 4978.165527,      z = 63.51357651 },
    { title = "Tramway",               premium = true, colour = 46, id = 532,             x = -534.940979,      y = -674.9927368,   z = 11.80863762 },
    { title = "Secouriste",            premium = true, colour = 46, id = 574,             x = 318.17,           y = -1476.46,       z = 28.97 },
    { title = "Train",                 premium = true, colour = 46, id = 660,             x = -140.036087,      y = 6147.339355,    z = 32.33512497 },
    { title = "Intérim Fourrière",     premium = true, colour = 46, id = 68,              x = -229.8452759,     y = -1170.916382,   z = 23.04404449 },
    
    -- Superettes
    { title = "Superette",                   colour = 2,     id = 52,    x = 1159.222656,      y = -324.3786621,     z = 69.20510101 },
    { title = "Superette",                   colour = 2,     id = 52,    x = -1825.355469,     y = 792.7280884,      z = 138.1907349 },
    { title = "Superette",                   colour = 2,     id = 52,    x = -710.2194824,     y = -911.7474365,     z = 19.21558762 },
    { title = "Superette",                   colour = 2,     id = 52,    x = 1700.782471,      y = 4927.62207,       z = 42.06362915 },
    { title = "Superette",                   colour = 2,     id = 52,    x = -49.41556168,     y = -1753.133667,     z = 29.42100525 },
    { title = "Superette",                  colour = 2,     id = 52,     x = 547.9741211,      y = 2669.033447,      z = 42.15653229 },
    --{ title = "Superette",                  colour = 2,     id = 52,     x = 1629.84,      y = 3661.56,      z = 33.89 },
    { title = "Superette",                  colour = 2,     id = 52,     x = 2679.195801,      y = 3283.783447,      z = 55.24111938 },
    { title = "Superette",                  colour = 2,     id = 52,     x = 29.00147247,      y = -1344.226562,     z = 29.49703217 },
    { title = "Superette",                  colour = 2,     id = 52,     x = 377.5913086,      y = 326.9878845,      z = 103.5664139 },
    { title = "Superette",                  colour = 2,     id = 52,     x = -3040.970947,     y = 588.434082,       z = 7.908928871 },
    { title = "Superette",                  colour = 2,     id = 52,     x = 2556.461914,      y = 385.5475769,      z = 108.6230392 },
    { title = "Superette",                  colour = 2,     id = 52,     x = -3244.375488,     y = 1005.512817,      z = 12.83070564 },
    { title = "Superette",             colour = 2,     id = 52,     x = 163.2957153,      y = 6643.749512,      z = 31.69888115 },
    { title = "Superette",             colour = 2,     id = 52,     x = 1165.589111,      y = 2708.709473,      z = 38.1577034 },
    { title = "Superette",             colour = 2,     id = 52,     x = -1487.665649,     y = -380.3517761,     z = 40.16341019 },
    { title = "Superette",             colour = 2,     id = 52,     x = 1137.499146,      y = -981.5336304,     z = 46.41584778 },
    { title = "Superette",             colour = 2,     id = 52,     x = -2969.327148,     y = 389.9371338,      z = 15.04297352 },
    { title = "Superette",             colour = 2,     id = 52,     x = -1223.22168,      y = -906.5662842,     z = 12.32634735 },
    --{ title = "Superette",             colour = 2,     id = 52,     x = 1745.9,      y = 3612.93,     z = 33.89 },
    { title = "Superette",             colour = 2,     id = 52,     x = -673.11,      y = 5837.03,     z = 16.33 },
    
    -- Magasin de Vêtements
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 1692.297485,      y = 4826.229492,      z = 42.06292725 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 1.856332183,      y = 6512.854492,      z = 31.87766457 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 617.8620605,      y = 2753.53418,       z = 42.08826447 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 1196.234863,      y = 2707.729004,      z = 38.22244263 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 77.05722046,      y = -1391.36853,      z = 29.37596893 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = -1193.710327,     y = -771.4956055,     z = 17.32312393 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = -1451.368652,     y = -236.8556976,     z = 49.80834198 },
    { title = "Magasin de Vêtements",             colour = 40,    id = 73,     x = -160.4676666,     y = -304.2297668,     z = 41.61060333 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 124.823822,       y = -219.2211914,     z = 54.55768585 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = -709.4398193,     y = -152.6104889,     z = 37.41521835 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = -3170.054688,     y = 1049.887451,      z = 20.86334419 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = -822.6627197,     y = -1076.553223,     z = 11.32792854 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = -1101.583862,     y = 2707.850098,      z = 19.10768127 },
    { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 424.5715027,      y = -801.5020752,     z = 32.40452576 },
    -- { title = "Magasin de Vêtements",                 colour = 40,    id = 73,     x = 1779.94,      y = 3637.65,     z = 33.89 }, -- Sandy 
    
    -- Shops
    { title = "Salon de coiffure",     colour = 2,     id = 71,     x = -1287.254272,     y = -1116.379395,     z = 10.15929413 },
    --{ title = "Salon de coiffure",     colour = 2,     id = 71,     x = 1931.774048,      y = 3729.393311,      z = 32.84466553 },
    { title = "Salon de coiffure",     colour = 2,     id = 71,     x = 136.380249,       y = -1708.409302,     z = 29.29184914 },
    { title = "Salon de tatouage",     colour = 10,    id = 75,     x =  1786.67,          y = 3799.44,          z = 33.02 },
    { title = "Salon de tatouage",     colour = 10,    id = 75,     x = 325.1223755,      y = 183.7508545,      z = 104.7749557 },
    { title = "Salon de tatouage",     colour = 10,    id = 75,     x = -291.4418335,     y = 6198.131836,      z = 31.48464775 },
    { title = "Magasin de masque",     colour = 19,    id = 671,    x = -1218.195557,     y = -1433.456665,     z = 4.37387991 },
    { title = "Animalerie",            colour = 29,    id = 273,    x = 562.4279175,      y = 2737.297119,      z = 42.06309509 },
    { title = "Magasin bio",           colour = 2,     id = 628,    x = -1252.831787,     y = -1442.884277,     z = 4.373885632 },
    { title = "Digital Den",           colour = 83,    id = 521,    x = -1212.264893,     y = -1503.043335,     z = 4.373884201 },
    
    -- Banques
    { title = "Fleeca",                colour = 2,     id = 108,    x = -103.7177887,     y = 6468.63623,       z = 31.63628578 },
    { title = "Fleeca",                colour = 2,     id = 108,    x = 1179.1604,        y = 2706.937256,      z = 38.0877037 },
    { title = "Fleeca",                colour = 2,     id = 108,    x = -1212.865356,     y = -331.1850891,     z = 37.78069305 },
    { title = "Fleeca",                colour = 2,     id = 108,    x = 314.0101013,      y = -279.1563416,     z = 54.16449738 },
    { title = "Fleeca",                colour = 2,     id = 108,    x = 149.528595,       y = -1041.546143,     z = 29.36777496 },
    { title = "Fleeca",                colour = 2,     id = 108,    x = -2962.24707,      y = 482.9809265,      z = 15.6976757 },
    { title = "Fleeca",                colour = 2,     id = 108,    x = -351.5339966,     y = -49.52899933,     z = 50.77180862 },
    --{ title = "Fleeca",                colour = 2,     id = 108,    x = 1839.8,           y = 3795.36,          z = 32.38 },
    { title = "Pacific Bank Vinewood", colour = 2,     id = 108,    x = 238.9759521,      y = 220.4615784,      z = 106.2821121 },
    
    { title = "Auto-Ecole",            colour = 3,     id = 498,    x = 234.3714447,      y = 370.0597839,      z = 106.134697 },
    { title = "Fourrière",         colour = 36,    id = 50,     x = -190.4690094,     y = -1163.863159,     z = 23.67140579 }, 
    { title = "Fourrière",         colour = 36,    id = 50,     x = 1590.3,      y = 3746.96,      z = 33.81 },
    
    { title = "Diamond Casino",        colour = 0,     id = 679,    x = 930.0,            y = 44.0,             z = 80.0 },
    { title = "Parc d'attractions",    colour = 4,     id = 266,    x = -1664.129272,     y = -1124.545288,     z = 13.30527496 },
    
    { title = "Vendeur de légumes",    colour = 2,     id = 85,     x = 417.4570923,      y = 6520.724121,      z = 27.71557045 },
    { title = "Vente de Poisson",      colour = 3,     id = 68,     x = 3373.423828,      y = 5183.482422,      z = 1.460241437 },
    { title = "Pêche",                 colour = 3,     id = 68,     x = 3867.070068,      y = 4462.510742,      z = 2.725242615 },
    { title = "Pêche",                 colour = 3,     id = 68,     x = -1614.878906,     y = 5261.052246,      z = 3.974103212 },
    
    -- Station service
    { title = "Station service",       colour = 2,     id = 361,    x = 263.8940125,      y = 2606.462891,      z = 47.99251938 },
    { title = "Station service",       colour = 2,     id = 361,    x = 1039.958008,      y = 2671.134033,      z = 43.75426483 },
    { title = "Station service",       colour = 2,     id = 361,    x = 1580.17,      y = 3750.31,      z = 33.76 },
    { title = "Station service",       colour = 2,     id = 361,    x = 1699.847534,      y = 6417.233887,      z = 35.46548843 },
    { title = "Station service",       colour = 2,     id = 361,    x = 179.8569946,      y = 6602.838867,      z = 35.0916481 },
    { title = "Station service",       colour = 2,     id = 361,    x = -2096.24292,      y = -320.2860107,     z = 14.16800022 },
    { title = "Station service",       colour = 2,     id = 361,    x = -319.2919922,     y = -1471.714966,     z = 44.96069717 },
    
    { title = "Voyage Cayo",           colour = 0,     id = 423,    x = 4436.5322265625,  y = -4487.3408203125, z = 4.2469692230225 },
    { title = "Voyage Cayo",           colour = 0,     id = 423,    x = -1040.7633056641, y = -2742.9753417969, z = 12.9449577331 },

    -- Project Epsilon
    { title = "Epsilon",           colour = 0,     id = 206,    x = -1688.34, y = -280.69, z = 66.71 }, -- LS
    { title = "Epsilon",           colour = 0,     id = 206,    x = -319.73, y = 2805.37, z = 71.28 }, -- Sandy
    { title = "Epsilon",           colour = 0,     id = 206,    x = -313.71, y = 6150.38, z = 31.31 }, -- Paleto Bay
}

function createBlip(info)
    local blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(blip, info.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.75)
    SetBlipColour(blip, info.colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    while not p do Wait(500) end
    for _, info in pairs(blips) do
        if info.premium then
            if p:getSubscription() > 0 then
                createBlip(info)
            end
        else
            createBlip(info)
        end
    end
    Wait(5000)
    if CanAccessAction('Brinks') then 
        createBlip({title = "Braquage Brinks", colour=1, id=67, x=11.095767974854, y=-664.18542480469, z=32.448928833008})
    end
    if CanAccessAction('Yatch') then 
        createBlip({title = "Braquage Yatch", colour=1, id=455, x=-2085.3852539062, y=-1018.4896240234, z=12.579319000244})
    end
    if CanAccessAction('Gofast') then 
        createBlip({title = "Braquage GoFast", colour=1, id=225, x=723.822265625, y=-932.26776123047, z=24.475807189941})
        createBlip({title = "Braquage GoFast Maritime", colour=1, id=427, x=604.28, y=-3252.77, z=6.07})
    end
end)
