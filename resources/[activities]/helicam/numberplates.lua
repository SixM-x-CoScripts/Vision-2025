-- Yes, I went trough every single GTA 5 vehicle, please send help.
local vehicleNumberPlates = {
    ['default'] = {
        front = { static = true },
        rear = { static = true }
    },

    -- Commercials --
    -- Benson (benson)
    [2053223216] = {
        front = { onBumper = true },
        rear = false
    },
    -- Biff (biff)
    [850991848] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Apocalypse Cerberus (cerberus)
    [-801550069] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Future Shock (cerberus2)
    [679453769] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Nightmare (cerberus3)
    [1909700336] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Hauler (hauler)
    [1518533038] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Hauler Custom (hauler2)
    [387748548] = {
        front = false,
        rear = { static = true }
    },
    -- Mule (mule)
    [904750859] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Mule, Ramp door variant (mule2)
    [-1050465301] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Mule, Heist variant (mule3)
    [-2052737935] = {
        front = false,
        rear = { static = true }
    },
    -- Mule Custom (mule4)
    [1945374990] = {
        front = false,
        rear = { static = true }
    },
    -- Packer (packer)
    [569305213] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Phantom (phantom)
    [-2137348917] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Phantom Wedge (phantom2)
    [-1649536104] = {
        front = false,
        rear = { static = true }
    },
    -- Phantom Custom (phantom3)
    [177270108] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Pounder (pounder)
    [2112052861] = {
        front = { onBumper = true },
        rear = false
    },
    -- Pounder Custom (pounder2)
    [1653666139] = {
        front = { onBumper = true },
        rear = false
    },
    -- Stockade (stockade)
    [1747439474] = {
        front = false,
        rear = { static = true }
    },
    -- Stockade, Bobcat Security/Snow variant (stockade3)
    [-214455498] = {
        front = false,
        rear = false
    },
    -- Terrorbyte (terbyte)
    [-1988428699] = {
        front = { static = true },
        rear = { static = true }
    },

    -- Compacts --
    -- Asbo (asbo)
    [1118611807] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Blista (blista)
    [-344943009] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Blista Compact (blista2)
    [1039032026] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Go Go Monkey Blista (blista3)
    [-591651781] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Brioso
    [1549126457] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Brioso2
    [1429622905] = {
        front = false,
        rear = { onHood = true }
    },
    -- Brioso 300 Widebody (brioso3)
    [15214558] = {
        front = { onBumper = true },
        rear = { onHood = true }
    },
    -- Club (club)
    [-2098954619] = {
        front = false,
        rear = { static = true }
    },
    -- Dilettante
    [-1130810103] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Dilettante2
    [1682114128] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Issi (issi2)
    [-1177863319] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Issi Classic (issi3)
    [931280609] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Apocalypse Issi (issi4)
    [628003514] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Future Shock Issi (issi5)
    [1537277726] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Nightmare Issi (issi6)
    [1239571361] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Issi Sport (issi7)
    [1854776567] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Blista Kanjo (kanjo)
    [409049982] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Panto
    [-431692672] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Prairie
    [-1450650718] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Rhapsody
    [841808271] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Weevil
    [1644055914] = {
        front = { onBumper = true },
        rear = { onHood = true }
    },

    -- Coupes --
    -- CogCabrio
    [330661258] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Exemplar
    [-5153954] = {
        front = false,
        rear = { onBumper = true }
    },
    -- F620,
    [-591610296] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Felon
    [-391594584] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Felon2
    [-89291282] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Jackal
    [-624529134] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Kanjo SJ (kanjosj)
    [-64075878] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Oracle XS (oracle)
    [1348744438] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Oracle (oracle2)
    [-511601230] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Postlude (postlude)
    [-294678663] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Previon
    [1416471345] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Sentinel
    [1349725314] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Sentinel2
    [873639469] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Sentinel Classic (sentinel3)
    [1104234922] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Sentinel Classic Widebody (sentinel4)
    [-1356880839] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Windsor
    [1581459400] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Windsor2
    [-1930048799] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Zion
    [-1122289213] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Zion2
    [-1193103848] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },

    -- Emergency --
    -- Ambulance (ambulance)
    [1171614426] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- FIB Buffalo (fbi)
    [1127131465] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- FIB Granger (fbi2)
    [-1647941228] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- FireTruck (firetruk)
    [1938952078] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Prison Bus (pbus)
    [-2007026063] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Police Cruiser (police)
    [2046537925] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Police Buffalo (police2)
    [-1627000575] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Police Cruiser (police3)
    [1912215274] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Unmarked Cruiser (police4)
    [-1973172295] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Police Rancher (policeold1)
    [-1536924937] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Police Roadcruiser (policeold2)
    [-1779120616] = {
        front = false,
        rear = { static = true }
    },
    -- Police Transporter (policet)
    [456714581] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Police Bike (policeb)
    [-34623805] = {
        front = false,
        rear = { static = true }
    },
    -- Police Maverick (polmav)
    [353883353] = {
        front = false,
        rear = false
    },
    -- Park Ranger (pranger)
    [741586030] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Police Predator (predator)
    [-488123221] = {
        front = false,
        rear = false
    },
    -- Police Riot (riot)
    [-1205689942] = {
        front = false,
        rear = false
    },
    -- RCV (riot2)
    [-693015116] = {
        front = false,
        rear = { static = true }
    },
    -- Sheriff Cruiser (sheriff)
    [-1683328900] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Sheriff SUV (sheriff2)
    [1922257928] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },

    -- Industrial --
    -- Bulldozer
    [1886712733] = {
        front = false,
        rear = false
    },
    -- Cutter
    [-1006919392] = {
        front = false,
        rear = false
    },
    -- Dump
    [-2130482718] = {
        front = false,
        rear = false
    },
    -- Flatbed
    [1353720154] = {
        front = { onBumper = true },
        rear = false
    },
    -- Guardian
    [-2107990196] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Handler
    [444583674] = {
        front = false,
        rear = false
    },
    -- Mixer
    [-784816453] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Mixer2
    [475220373] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Rubble
    [-1705304628] = {
        front = { onBumper = true },
        rear = false
    },
    -- TipTruck
    [48339065] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- TipTruck2
    [-947761570] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    
    -- Military --
    -- Anti-Aircraft Trailer (trailersmall2)
    [-1881846085] = {
        front = false,
        rear = false
    },
    -- APC (apc)
    [562680400] = {
        front = false,
        rear = false
    },
    -- Barracks (barracks)
    [-823509173] = {
        front = false,
        rear = false
    },
    -- Barracks Semi (barracks2)
    [1074326203] = {
        front = false,
        rear = false
    },
    -- Barrage (barrage)
    [-212993243] = {
        front = false,
        rear = { static = true }
    },
    -- Half-track (halftrack)
    [-32236122] = {
        front = false,
        rear = false
    },
    -- Chernobog (chernobog)
    [-692292317] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Crusader (crusader)
    [321739290] = {
        front = false,
        rear = false
    },
    -- Invade and Persuade Tank (minitank)
    [-1254331310] = {
        front = false,
        rear = false
    },
    -- Rhino Tank (rhino)
    [782665360] = {
        front = false,
        rear = false
    },
    -- Apocalypse Scarab (scarab)
    [-1146969353] = {
        front = false,
        rear = false
    },
    -- Future Shock Scarab (scarab2)
    [1542143200] = {
        front = false,
        rear = false
    },
    -- Nightmare Scarab (scarab3)
    [-579747861] = {
        front = false,
        rear = false
    },
    -- Thruster (thruster)
    [1489874736] = {
        front = false,
        rear = false
    },
    -- TM-02 Khanjali (khanjali)
    [-1435527158] = {
        front = false,
        rear = false
    },
    -- Vetir (vetir)
    [2014313426] = {
        front = false,
        rear = false
    },

    -- Motorcycles --
    -- Akuma
    [1672195559] = {
        front = false,
        rear = false
    },
    -- Avarus
    [-2115793025] = {
        front = false,
        rear = { static = true }
    },
    -- Bagger
    [-2140431165] = {
        front = false,
        rear = { static = true }
    },
    -- Bati 801 (bati)
    [-114291515] = {
        front = false,
        rear = { static = true }
    },
    -- Bati 801RR (bati2)
    [-891462355] = {
        front = false,
        rear = { static = true }
    },
    -- BF400
    [86520421] = {
        front = false,
        rear = false
    },
    -- CarbonRS
    [11251904] = {
        front = false,
        rear = { static = true }
    },
    -- Chimera
    [6774487] = {
        front = false,
        rear = { static = true }
    },
    -- Cliffhanger
    [390201602] = {
        front = false,
        rear = false
    },
    -- Daemon (daemon)
    [2006142190] = {
        front = false,
        rear = { static = true }
    },
    -- Daemon (daemon2)
    [-1404136503] = {
        front = false,
        rear = { static = true }
    },
    -- Apocalypse Deathbike (deathbike)
    [-27326686] = {
        front = false,
        rear = false
    },
    -- Future Shock Deathbike (deathbike2)
    [-1812949672] = {
        front = false,
        rear = false
    },
    -- Nightmare Deathbike (deathbike3)
    [-1374500452] = {
        front = false,
        rear = false
    },
    -- Defiler
    [822018448] = {
        front = false,
        rear = { static = true }
    },
    -- Double
    [-1670998136] = {
        front = false,
        rear = false
    },
    -- Enduro
    [1753414259] = {
        front = false,
        rear = false
    },
    -- Esskey
    [2035069708] = {
        front = false,
        rear = { static = true }
    },
    -- Faggio
    [-1842748181] = {
        front = false,
        rear = { static = true }
    },
    -- Faggio2
    [55628203] = {
        front = false,
        rear = { static = true }
    },
    -- Faggio3
    [-1289178744] = {
        front = false,
        rear = { static = true }
    },
    -- Fcr2
    [-757735410] = {
        front = false,
        rear = false
    },
    -- Fcr
    [627535535] = {
        front = false,
        rear = { static = true }
    },
    -- Gargoyle
    [741090084] = {
        front = false,
        rear = false
    },
    -- Hakuchou2
    [-255678177] = {
        front = false,
        rear = false
    },
    -- Hakuchou
    [1265391242] = {
        front = false,
        rear = { static = true }
    },
    -- Hexer
    [301427732] = {
        front = false,
        rear = { static = true }
    },
    -- Innovation
    [-159126838] = {
        front = false,
        rear = false
    },
    -- Lectro
    [640818791] = {
        front = false,
        rear = { static = true }
    },
    -- Manchez
    [-1523428744] = {
        front = false,
        rear = false
    },
    -- Manchez2
    [1086534307] = {
        front = false,
        rear = false
    },
    -- Manchez Scout C (manchez3)
    [1384502824] = {
        front = false,
        rear = false
    },
    -- Nemesis
    [-634879114] = {
        front = false,
        rear = { static = true }
    },
    -- Nightblade
    [-1606187161] = {
        front = false,
        rear = { static = true }
    },
    -- Oppressor (oppressor)
    [884483972] = {
        front = false,
        rear = false
    },
    -- Oppressor Mk II (oppressor2)
    [2069146067] = {
        front = false,
        rear = false
    },
    -- PCJ
    [-909201658] = {
        front = false,
        rear = { static = true }
    },
    -- Powersurge (powersurge)
    [-1386336041] = {
        front = false,
        rear = { static = true }
    },
    -- Ratbike
    [1873600305] = {
        front = false,
        rear = false
    },
    -- Rampant Rocket (rrocket)
    [916547552] = {
        front = false,
        rear = { static = true }
    },
    -- Reever (reever)
    [1993851908] = {
        front = false,
        rear = { static = true }
    },
    -- Ruffian
    [-893578776] = {
        front = false,
        rear = { static = true }
    },
    -- Sanchez2
    [-1453280962] = {
        front = false,
        rear = false
    },
    -- Sanchez
    [788045382] = {
        front = false,
        rear = false
    },
    -- Sanctus
    [1491277511] = {
        front = false,
        rear = { static = true }
    },
    -- Shinobi (shinobi)
    [1353120668] = {
        front = false,
        rear = { static = true }
    },
    -- Shotaro
    [-405626514] = {
        front = false,
        rear = false
    },
    -- Sovereign
    [743478836] = {
        front = false,
        rear = { static = true }
    },
    -- Stryder (stryder)
    [301304410] = {
        front = false,
        rear = { static = true }
    },
    -- Thrust
    [1836027715] = {
        front = false,
        rear = { static = true }
    },
    -- Vader
    [-140902153] = {
        front = false,
        rear = false
    },
    -- Vindicator
    [-1353081087] = {
        front = false,
        rear = { static = true }
    },
    -- Vortex
    [-609625092] = {
        front = false,
        rear = { static = true }
    },
    -- Wolfsbane
    [-618617997] = {
        front = false,
        rear = false
    },
    -- Zombiea
    [-1009268949] = {
        front = false,
        rear = false
    },
    -- Zombieb
    [-570033273] = {
        front = false,
        rear = false
    },

    -- Muscle --
    -- Blade
    [-1205801634] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Broadway (broadway)
    [-1933242328] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Buccaneer
    [-682211828] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Buccaneer2
    [-1013450936] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Buffalo STX (buffalo4)
    [-619930876] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Chino
    [349605904] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Chino2
    [-1361687965] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Clique (clique)
    [-1566607184] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Deviant (deviant)
    [1279262537] = {
        front = false,
        rear = { static = true }
    },
    -- Dominator
    [80636076] = {
        front = false,
        rear = { static = true }
    },
    -- Dominator2
    [-915704871] = {
        front = false,
        rear = { static = true }
    },
    -- Dominator GTX (dominator3)
    [-986944621] = {
        front = false,
        rear = { static = true }
    },
    -- Apocalypse Dominator (dominator4)
    [-688189648] = {
        front = false,
        rear = false
    },
    -- Future Shock Dominator (dominator5)
    [-1375060657] = {
        front = false,
        rear = false
    },
    -- Nightmare Dominator (dominator6)
    [-1293924613] = {
        front = false,
        rear = false
    },
    -- Dominator ASP (dominator7)
    [426742808] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Dominator GTT (dominator8)
    [736672010] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Dukes
    [723973206] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Dukes2
    [-326143852] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Beater Dukes(dukes3)
    [2134119907] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Ellie (ellie)
    [-1267543371] = {
        front = false,
        rear = { static = true }
    },
    -- Eudora (eudora)
    [-1249788006] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Faction
    [-2119578145] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Faction2
    [-1790546981] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Faction3
    [-2039755226] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Gauntlet
    [-1800170043] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Gauntlet2
    [349315417] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Gauntlet3
    [722226637] = {
        front = false,
        rear = { static = true }
    },
    -- Gauntlet4
    [1934384720] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Gauntlet Classic Custom (gauntlet5)
    [-2122646867] = {
        front = false,
        rear = { static = true }
    },
    -- Greenwood (greenwood)
    [40817712] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Hermes (hermes)
    [15219735] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Hotknife
    [37348240] = {
       front = false,
       rear = { static = true }
    },
    -- Hustler (hustler)
    [600450546] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Impaler (impaler)
    [-2096690334] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Apocalypse Impaler (impaler2)
    [1009171724] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Future Shock Impaler (impaler3)
    [-1924800695] = {
        front = { static = true },
        rear = { onBumper = true }
    },
    -- Nightmare Impaler (impaler4)
    [-1744505657] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Apocalypse Imperator (imperator)
    [444994115] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Future Shock Imperator (imperator2)
    [1637620610] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Nightmare Imperator (imperator3)
    [-755532233] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Lurcher
    [2068293287] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Moonbeam
    [525509695] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Moonbeam2
    [1896491931] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Nightshade
    [-1943285540] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Phoenix
    [-2095439403] = {
        front = false,
        rear = { static = true }
    },
    -- Picador
    [1507916787] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Rat-Loader (ratloader)
    [-667151410] = {
        front = { static = true },
        rear = { onExtra = 1 }
    },
    -- Rat-Truck (ratloader2)
    [-589178377] = {
        front = false,
        rear = { static = true }
    },
    -- Peyote Gasser (peyote2)
    [-1804415708] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Ruiner
    [-227741703] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Ruiner2
    [941494461] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Wrecked Ruiner (ruiner3)
    [777714999] = {
        front = false,
        rear = false
    },
    -- Ruiner ZZ-8 (ruiner4)
    [1706945532] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- SabreGT
    [-1685021548] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- SabreGT2
    [223258115] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- SlamVan
    [729783779] = {
        front = false,
        rear = { onBumper = true }
    },
    -- SlamVan2
    [833469436] = {
        front = false,
        rear = { onBumper = true }
    },
    -- SlamVan3
    [1119641113] = {
        front = false,
        rear = { static = true }
    },
    -- Apocalypse Slamvan (slamvan4)
    [-2061049099] = {
        front = false,
        rear = false
    },
    -- Apocalypse Future Shock (slamvan5)
    [373261600] = {
        front = false,
        rear = false
    },
    -- Nightmare Slamvan (slamvan6)
    [1742022738] = {
        front = false,
        rear = false
    },
    -- Stalion
    [1923400478] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Stalion2
    [-401643538] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Tahoma Coupe (tahoma)
    [-461850249] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Tampa
    [972671128] = {
        front = { static = true },
        rear = { onBumper = true }
    },
    -- Tampa3
    [-1210451983] = {
        front = { static = true },
        rear = { onBumper = true }
    },
    -- Tulip (tulip)
    [1456744817] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Vamos (vamos)
    [-49115651] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Vigero
    [-825837129] = {
        front = { static = true },
        rear = false
    },
    -- Vigero ZX (vigero2)
    [-1758379524] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Virgo
    [-498054846] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Virgo2
    [-899509638] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Virgo3
    [16646064] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Voodoo
    [2006667053] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Voodoo2
    [523724515] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Weevil Custom (weevil2)
    [-994371320] = {
        front = false,
        rear = { onHood = true }
    },
    -- Yosemite (yosemite)
    [1871995513] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Drift Yosemite (yosemite2)
    [1693751655] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Yosemite Rancher (yosemite3)
    [67753863] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },

    -- Off-Road --
    -- BfInjection
    [1126868326] = {
        front = false,
        rear = { static = true }
    },
    -- Bifta
    [-349601129] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Blazer
    [-2128233223] = {
        front = false,
        rear = { static = true }
    },
    -- Blazer2
    [-48031959] = {
        front = false,
        rear = false
    },
    -- Blazer3
    [-1269889662] = {
        front = false,
        rear = false
    },
    -- Blazer4
    [-440768424] = {
        front = false,
        rear = { static = true }
    },
    -- Blazer5
    [-1590337689] = {
        front = false,
        rear = { static = true }
    },
    -- Bodhi2
    [-1435919434] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Boor (boor)
    [996383885] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Brawler
    [-1479664699] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Apocalypse Bruiser (bruiser)
    [668439077] = {
        front = false,
        rear = false
    },
    -- Future Shock Bruiser (bruiser2)
    [-1694081890] = {
        front = false,
        rear = false
    },
    -- Nightmare Bruiser (bruiser3)
    [-2042350822] = {
        front = false,
        rear = false
    },
    -- Apocalypse Brutus (brutus)
    [2139203625] = {
        front = false,
        rear = { static = true }
    },
    -- Future Shock Brutus (brutus2)
    [-1890996696] = {
        front = false,
        rear = { static = true }
    },
    -- Nightmare Brutus (brutus3)
    [2038858402] = {
        front = false,
        rear = { static = true }
    },
    -- Caracara (caracara)
    [1254014755] = {
        front = false,
        rear = { static = true }
    },
    -- Caracara 4x4 (caracara2)
    [-1349095620] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Duneloader (dLoader)
    [1770332643] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Draugur (draugur)
    [-768236378] = {
        front = false,
        rear = false
    },
    -- Dune
    [-1661854193] = {
        front = false,
        rear = false
    },
    -- Dune2
    [534258863] = {
        front = false,
        rear = false
    },
    -- Dune FAV (dune3)
    [1897744184] = {
        front = false,
        rear = false
    },
    -- Dune4
    [-827162039] = {
        front = false,
        rear = false
    },
    -- Dune5
    [-312295511] = {
        front = false,
        rear = false
    },
    -- Everon (everon)
    [-1756021720] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Hellion (hellion)
    [-362150785] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Freecrawler (freecrawler)
    [-54332285] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Insurgent Pick-Up (insurgent)
    [-1860900134] = {
        front = false,
        rear = { static = true }
    },
    -- Insurgent (insurgent2)
    [2071877360] = {
        front = false,
        rear = { static = true }
    },
    -- Insurgent Pick-Up Custom (insurgent3)
    [-1924433270] = {
        front = false,
        rear = { static = true }
    },
    -- Kalahari
    [92612664] = {
        front = { static = true },
        rear = { onTrunk = true }
    },
    -- Kamacho (kamacho)
    [-121446169] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Lguard
    [469291905] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Marshall
    [1233534620] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Menacer (menacer)
    [2044532910] = {
        front = false,
        rear = { static = true }
    },
    -- Mesa
    [914654722] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Mesa2
    [-748008636] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Mesa3
    [-2064372143] = {
        front = false,
        rear = { static = true }
    },
    -- Liberator (monster)
    [-845961253] = {
        front = false,
        rear = false
    },
    -- Apocalypse Sasquatch (monster3)
    [1721676810] = {
        front = false,
        rear = false
    },
    -- Future Shock Sasquatch (monster4)
    [840387324] = {
        front = false,
        rear = false
    },
    -- Nightmare Sasquatch (monster5)
    [-715746948] = {
        front = false,
        rear = false
    },
    -- Nightshark
    [433954513] = {
        front = false,
        rear = { static = true }
    },
    -- Outlaw (outlaw)
    [408825843] = {
        front = false,
        rear = { static = true }
    },
    -- RancherXL
    [1645267888] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- RancherXL2
    [1933662059] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- RC Bandito (rcbandito)
    [-286046740] = {
        front = false,
        rear = false
    },
    -- Rebel
    [-1207771834] = {
        front = { onBumper = true },
        rear = false
    },
    -- Rebel2
    [-2045594037] = {
        front = { onBumper = true },
        rear = false
    },
    -- Riata (riata)
    [-1532697517] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Sandking
    [-1189015600] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Sandking2
    [989381445] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Squaddie (squaddie)
    [-102335483] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Technical
    [-2096818938] = {
        front = { onBumper = true },
        rear = false
    },
    -- Technical2
    [1180875963] = {
        front = { onBumper = true },
        rear = false
    },
    -- Technical3
    [1356124575] = {
        front = { onBumper = true },
        rear = false
    },
    -- TrophyTruck
    [101905590] = {
        front = false,
        rear = false
    },
    -- TrophyTruck2
    [-663299102] = {
        front = false,
        rear = false
    },
    -- Vagrant (vagrant)
    [740289177] = {
        front = false,
        rear = { static = true }
    },
    -- Verus
    [298565713] = {
        front = false,
        rear = { static = true }
    },
    -- Winky
    [-210308634] = {
        front = false,
        rear = { static = true }
    },
    -- Zhaba (zhaba)
    [1284356689] = {
        front = false,
        rear = { static = true }
    },

    -- SUV's --
    -- Astron (astron)
    [629969764] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- BJXL
    [850565707] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Baller (baller)
    [-808831384] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Baller (Second Generation) (baller2)
    [142944341] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Baller LE (baller3)
    [1878062887] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Baller LE LWB (baller4)
    [634118882] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Baller LE (Armored) (baller5)
    [470404958] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Baller LE LWB (Armored) (baller6)
    [666166960] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Baller ST (baller7)
    [359875117] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Cavalcade
    [2006918058] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Cavalcade2
    [-789894171] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Contender
    [683047626] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Dubsta
    [1177543287] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Dubsta2
    [-394074634] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Dubsta3
    [-1237253773] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- FQ2
    [-1137532101] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Granger
    [-1775728740] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Granger 3600LX (granger2)
    [-261346873] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Gresley
    [-1543762099] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Habanero
    [884422927] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Huntley
    [486987393] = {
        front = { static = true },
        rear = { onTrunk = true }
    },
    -- Issi Rally (issi8)
    [1550581940] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- I-Wagen (iwagen)
    [662793086] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Jubilee (jubilee)
    [461465043] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Landstalker
    [1269098716] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Landstalker XL (landstalker2)
    [-838099166] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Novak (novak)
    [-1829436850] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Patriot
    [-808457413] = {
        front = { static = true },
        rear = { onTrunk = true }
    },
    -- Patriot Stretch (patriot2)
    [-420911112] = {
        front = { static = true },
        rear = { onTrunk = true }
    },
    -- Patriot Mil-Spec (patriot3)
    [-670086588] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Radi
    [-1651067813] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Rebla (rebla)
    [83136452] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Rocoto
    [2136773105] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Seminole
    [1221512915] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Seminole Frontier (seminole2)
    [-1810806490] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Serrano
    [1337041428] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Toros (toros)
    [-1168952148] = {
        front = false,
        rear = { static = true }
    },
    -- XLS
    [1203490606] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- XLS2
    [-432008408] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },

    -- Sedans --
    -- Asea
    [-1809822327] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Asea2
    [-1807623979] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Asterope
    [-1903012613] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Cog55
    [906642318] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Cog552
    [704435172] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Cognoscenti
    [-2030171296] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Cognoscenti2
    [-604842630] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Cinquemila (cinquemila)
    [-1527436269] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Deity (deity)
    [1532171089] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Emperor
    [-685276541] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Emperor2
    [-1883002148] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Emperor3
    [-1241712818] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Fugitive
    [1909141499] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Glendale
    [75131841] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Glendale Custom (glendale2)
    [-913589546] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Ingot
    [-1289722222] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Intruder
    [886934177] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Limo2
    [-114627507] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Premier
    [-1883869285] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Primo
    [-1150599089] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Primo2
    [-2040426790] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Regina
    [-14495224] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Rhinehart (rhinehart)
    [-1855505138] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Romero
    [627094268] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Superd
    [1123216662] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Stafford (stafford)
    [321186144] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Stanier
    [-1477580979] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Stratum
    [1723137093] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Stretch
    [-1961627517] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Surge
    [-1894894188] = {
        front = false,
        rear = { static = true }
    },
    -- Tailgater
    [-1008861746] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Tailgater2
    [-1244461404] = {
        front = { static = true },
        rear = { onTrunk = true }
    },
    -- Warrener
    [1373123368] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Warrener2
    [579912970] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Washington
    [1777363799] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },

    -- Service --
    -- Airbus
    [1283517198] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Brickade
    [-305727417] = {
        front = false,
        rear = false
    },
    -- Brickade 6x6 (brickade2)
    [-1576586413] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Bus
    [-713569950] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Coach
    [-2072933068] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Festival Bus (pbus2)
    [345756458] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Rallytruck
    [-2103821244] = {
        front = { onBumper = true },
        rear = false
    },
    -- RentalBus
    [-1098802077] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Taxi (taxi)
    [-956048545] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Tourbus
    [1941029835] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Trash
    [1917016601] = {
        front = false,
        rear = { static = true }
    },
    -- Trash2
    [-1255698084] = {
        front = false,
        rear = { static = true }
    },

    -- Sports --
    -- Alpha
    [767087018] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Ardent
    [159274291] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Banshee
    [-1041692462] = {
        front = false,
        rear = { static = true }
    },
    -- Banshee2
    [633712403] = {
        front = false,
        rear = { static = true }
    },
    -- BestiaGTS
    [1274868363] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Buffalo
    [-304802106] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Buffalo2
    [736902334] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Buffalo3
    [237764926] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Calico
    [-1193912403] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Carbonizzare
    [2072687711] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Comet2
    [-1045541610] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Comet3
    [-2022483795] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Comet Safari (comet4)
    [1561920505] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Comet SR (comet5)
    [661493923] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Comet6
    [-1726022652] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Comet S2 Cabrio (comet7)
    [1141395928] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Coquette
    [108773431] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Coquette D10 (coquette4)
    [-1728685474] = {
        front = false,
        rear = { static = true }
    },
    -- Cypher
    [1755697647] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- 8F Drafter (drafter)
    [686471183] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Elegy
    [196747873] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Elegy2
    [-566387422] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Hotring Everon (everon2)
    [-131348178] = {
        front = false,
        rear = false
    },
    -- Euros
    [2038480341] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Feltzer2
    [-1995326987] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Feltzer3
    [-1566741232] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Flash GT (flashgt)
    [-1259134696] = {
        front = false,
        rear = { static = true }
    },
    -- Furoregt
    [-1089039904] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Fusilade
    [499169875] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Futo
    [2016857647] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Futo2
    [-1507230520] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Hotring Sabre (hotring)
    [1115909093] = {
        front = false,
        rear = false
    },
    -- GB200 (gb200)
    [1909189272] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Growler
    [1304459735] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Imorgon (imorgon)
    [-1132721664] = {
        front = false,
        rear = { static = true }
    },
    -- Infernus2
    [-1405937764] = {
        front = false,
        rear = { static = true }
    },
    -- Itali GTO (italigto)
    [-331467772] = {
        front = false,
        rear = { static = true }
    },
    -- Italirsx
    [-1149725334] = {
        front = false,
        rear = { static = true }
    },
    -- Jester
    [-1297672541] = {
        front = false,
        rear = { static = true }
    },
    -- Jester2
    [-1106353882] = {
        front = false,
        rear = { static = true }
    },
    -- Jester Classic (jester3)
    [-214906006] = {
        front = false,
        rear = { static = true }
    },
    -- Jester4
    [-1582061455] = {
        front = false,
        rear = { static = true }
    },
    -- Jugular (jugular)
    [-208911803] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Khamelion
    [544021352] = {
        front = false,
        rear = { static = true }
    },
    -- Komoda (komoda)
    [-834353991] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Kuruma
    [-1372848492] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Kuruma2
    [410882957] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Locust (locust)
    [-941272559] = {
        front = false,
        rear = { static = true }
    },
    -- Lynx
    [482197771] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Massacro
    [-142942670] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Massacro2
    [-631760477] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Neon (neon)
    [-1848994066] = {
        front = false,
        rear = { static = true }
    },
    -- Ninef
    [1032823388] = {
        front = false,
        rear = { static = true }
    },
    -- Ninef2
    [-1461482751] = {
        front = false,
        rear = { static = true }
    },
    -- Omnis
    [-777172681] = {
        front = false,
        rear = { static = true }
    },
    -- Omnis e-GT (omnisegt)
    [-505223465] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Panthere (panthere)
    [2100457220] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Paragon R (paragon)
    [-447711397] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Paragon R (Armored) (paragon2)
    [1416466158] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Pariah (pariah)
    [867799010] = {
        front = false,
        rear = { static = true }
    },
    -- Penumbra
    [-377465520] = {
        front = { static = true },
        rear = { onTrunk = true }
    },
    -- Penumbra FF (penumbra2)
    [-631322662] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- 300R (r300)
    [1076201208] = {
        front = false,
        rear = { static = true }
    },
    -- Raiden (raiden)
    [-1529242755] = {
        front = false,
        rear = { onBumper = true }
    },
    -- RapidGT
    [-1934452204] = {
        front = false,
        rear = { onBumper = true }
    },
    -- RapidGT2
    [1737773231] = {
        front = false,
        rear = { onBumper = true }
    },
    -- RapidGT3
    [2049897956] = {
        front = false,
        rear = { static = true }
    },
    -- Raptor
    [-674927303] = {
        front = false,
        rear = { static = true }
    },
    -- Remus
    [1377217886] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Revolter (revolter)
    [-410205223] = {
        front = { static = true },
        rear = { static = true }
    },
    -- RT3000
    [-452604007] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Ruston
    [719660200] = {
        front = false,
        rear = { onBumper = true }
    },
    -- SM722 (sm722)
    [775514032] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Schafter2
    [-1255452397] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Schafter3
    [-1485523546] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Schafter4
    [1489967196] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Schafter5
    [-888242983] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Schafter6
    [1922255844] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Schlagen GT (schlagen)
    [-507495760] = {
        front = false,
        rear = { static = true }
    },
    -- Schwarzer
    [-746882698] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Seven70
    [-1757836725] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Specter
    [1886268224] = {
        front = false,
        rear = { static = true }
    },
    -- Specter2
    [1074745671] = {
        front = false,
        rear = { static = true }
    },
    -- Streiter (streiter)
    [1741861769] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Sugoi (sugoi)
    [987469656] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Sultan
    [970598228] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Sultan Classic (sultan2)
    [872704284] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Sultan3
    [-291021213] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Surano
    [384071873] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Tampa2
    [-1071380347] = {
        front = false,
        rear = { onBumper = true }
    },
    -- 10F (tenf)
    [-893984159] = {
        front = false,
        rear = { onBumper = true }
    },
    -- 10F Widebody (tenf2)
    [274946574] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Tropos
    [1887331236] = {
        front = false,
        rear = { static = true }
    },
    -- Vectre
    [-1540373595] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Verlierer2
    [1102544804] = {
        front = false,
        rear = { static = true }
    },
    -- Veto
    [-857356038] = {
        front = false,
        rear = false
    },
    -- Veto2
    [-1492917079] = {
        front = false,
        rear = false
    },
    -- V-STR (vstr)
    [1456336509] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- ZR350
    [-39359943] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Apocalypse ZR380 (zr380)
    [540101442] = {
        front = false,
        rear = { static = true }
    },
    -- Future Shock ZR380 (zr3802)
    [-1106120762] = {
        front = false,
        rear = { static = true }
    },
    -- Nightmare ZR380 (zr3803)
    [-1478704292] = {
        front = false,
        rear = { static = true }
    },

    -- Sports Classics --
    -- BType
    [117401876] = {
        front = false,
        rear = { onBumper = true }
    },
    -- BType2
    [-831834716] = {
        front = false,
        rear = false
    },
    -- BType3
    [-602287871] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Casco
    [941800958] = {
        front = false,
        rear = { static = true }
    },
    -- Cheburek (cheburek)
    [-988501280] = {
        front = false,
        rear = { static = true }
    },
    -- Cheetah2
    [223240013] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Coquette2
    [1011753235] = {
        front = false,
        rear = { static = true }
    },
    -- Coquette3
    [784565758] = {
        front = false,
        rear = { static = true }
    },
    -- Deluxo (deluxo)
    [1483171323] = {
        front = false,
        rear = { static = true }
    },
    -- Dynasty (dynasty)
    [310284501] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Fagaloa (fagaloa)
    [1617472902] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- GT500 (gt500)
    [-1791613625] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- JB700
    [1051415893] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- JB 700W (jb7002)
    [394110044] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Mamba
    [-1660945322] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Michelli GT (michelli)
    [1046206681] = {
        front = false,
        rear = { static = true }
    },
    -- Manana
    [-2124201592] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Manana Custom (manana2)
    [1717532765] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Monroe
    [-433375717] = {
        front = false,
        rear = { static = true }
    },
    -- Nebula (nebula)
    [-882629065] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Peyote
    [1830407356] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Peyote Custom (peyote3)
    [1107404867] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Pigalle
    [1078682497] = {
        front = { static = true },
        rear = { static = true }
    },
    -- Retinue (retinue)
    [1841130506] = {
        front = false,
        rear = { static = true }
    },
    -- Retinue Mk II (retinue2)
    [2031587082] = {
        front = false,
        rear = { static = true }
    },
    -- Savestra (savestra)
    [903794909] = {
        front = false,
        rear = { static = true }
    },
    -- Stromberg (stromberg)
    [886810209] = {
        front = false,
        rear = { static = true }
    },
    -- Stinger
    [1545842587] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- StingerGT
    [-2098947590] = {
        front = false,
        rear = { onHood = true }
    },
    -- Swinger (swinger)
    [500482303] = {
        front = false,
        rear = { static = true }
    },
    -- Toreador
    [1455990255] = {
        front = false,
        rear = { static = true }
    },
    -- Torero
    [1504306544] = {
        front = false,
        rear = { static = true }
    },
    -- Tornado
    [464687292] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Tornado2
    [1531094468] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Tornado3
    [1762279763] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Tornado4
    [-2033222435] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Tornado5
    [-1797613329] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Tornado6
    [-1558399629] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Viseris (viseris)
    [-391595372] = {
        front = false,
        rear = { static = true }
    },
    -- 190z (z190)
    [838982985] = {
        front = false,
        rear = { static = true }
    },
    -- Zion Classic (zion3)
    [1862507111] = {
        front = { onBumper = true },
        rear = { static = true }
    },

    -- Super --
    -- Adder
    [-1216765807] = {
        front = false,
        rear = { static = true }
    },
    -- Autarch (autarch)
    [-313185164] = {
        front = false,
        rear = { static = true }
    },
    -- Bullet
    [-1696146015] = {
        front = false,
        rear = { static = true }
    },
    -- Champion (champion)
    [-915234475] = {
        front = false,
        rear = { static = true }
    },
    -- Cheetah
    [-1311154784] = {
        front = false,
        rear = { static = true }
    },
    -- Corsita (corsita)
    [-754687673] = {
        front = false,
        rear = { static = true }
    },
    -- Cyclone
    [1392481335] = {
        front = false,
        rear = { static = true }
    },
    -- Deveste Eight (deveste)
    [1591739866] = {
        front = false,
        rear = false
    },
    -- Emerus (emerus)
    [1323778901] = {
        front = false,
        rear = { static = true }
    },
    -- EntityXF
    [-1291952903] = {
        front = false,
        rear = { static = true }
    },
    -- Entity XXR (entity2)
    [-2120700196] = {
        front = false,
        rear = { static = true }
    },
    -- Entity MT (entity3)
    [1748565021] = {
        front = false,
        rear = { static = true }
    },
    -- FMJ
    [1426219628] = {
        front = false,
        rear = { static = true }
    },
    -- Furia (furia)
    [960812448] = {
        front = false,
        rear = { static = true }
    },
    -- GP1
    [1234311532] = {
        front = false,
        rear = { static = true }
    },
    -- Ignus (ignus)
    [-1444114309] = {
        front = false,
        rear = { static = true }
    },
    -- Infernus
    [418536135] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Italigtb
    [-2048333973] = {
        front = false,
        rear = { static = true }
    },
    -- Italigtb2
    [-482719877] = {
        front = false,
        rear = { static = true }
    },
    -- Krieger (krieger)
    [-664141241] = {
        front = false,
        rear = { static = true }
    },
    -- RE7B (le7b)
    [-1232836011] = {
        front = false,
        rear = false
    },
    -- LM87 (lm87)
    [-10917683] = {
        front = false,
        rear = { static = true }
    },
    -- Neo (neo)
    [-1620126302] = {
        front = false,
        rear = { static = true }
    },
    -- Nero
    [1034187331] = {
        front = false,
        rear = { static = true }
    },
    -- Nero2
    [1093792632] = {
        front = false,
        rear = { static = true }
    },
    -- Osiris
    [1987142870] = {
        front = false,
        rear = { static = true }
    },
    -- Penetrator
    [-1758137366] = {
        front = false,
        rear = { static = true }
    },
    -- Pfister811
    [-1829802492] = {
        front = false,
        rear = { static = true }
    },
    -- Prototipo
    [2123327359] = {
        front = false,
        rear = { static = true }
    },
    -- Reaper
    [234062309] = {
        front = false,
        rear = { static = true }
    },
    -- S80RR (s80)
    [-324618589] = {
        front = false,
        rear = false
    },
    -- SC1 (sc1)
    [1352136073] = {
        front = false,
        rear = { static = true }
    },
    -- Scramjet (scramjet)
    [-638562243] = {
        front = false,
        rear = false
    },
    -- Sheava
    [819197656] = {
        front = false,
        rear = { static = true }
    },
    -- SultanRS
    [-295689028] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- T20
    [1663218586] = {
        front = false,
        rear = { static = true }
    },
    -- Taipan (taipan)
    [-1134706562] = {
        front = false,
        rear = { static = true }
    },
    -- Tempesta
    [272929391] = {
        front = false,
        rear = { static = true }
    },
    -- Tezeract (tezeract)
    [1031562256] = {
        front = false,
        rear = { static = true }
    },
    -- Thrax (thrax)
    [1044193113] = {
        front = false,
        rear = { static = true }
    },
    -- Tigon (tigon)
    [-1358197432] = {
        front = false,
        rear = { onHood = true }
    },
    -- Torero XO (torero2)
    [-165394758] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Turismo2
    [-982130927] = {
        front = false,
        rear = { static = true }
    },
    -- Turismor
    [408192225] = {
        front = false,
        rear = { static = true }
    },
    -- Tyrant (tyrant)
    [-376434238] = {
        front = false,
        rear = { static = true }
    },
    -- Tyrus
    [2067820283] = {
        front = false,
        rear = { static = true }
    },
    -- Vacca
    [338562499] = {
        front = false,
        rear = { static = true }
    },
    -- Vagner
    [1939284556] = {
        front = false,
        rear = { static = true }
    },
    -- Vigilante
    [-1242608589] = {
        front = false,
        rear = false
    },
    -- Visione
    [-998177792] = {
        front = false,
        rear = { static = true }
    },
    -- Virtue (virtue)
    [669204833] = {
        front = false,
        rear = { static = true }
    },
    -- Voltic
    [-1622444098] = {
        front = false,
        rear = { static = true }
    },
    -- Voltic2
    [989294410] = {
        front = false,
        rear = { static = true }
    },
    -- Zentorno
    [-1403128555] = {
        front = false,
        rear = { static = true }
    },
    -- XA21
    [917809321] = {
        front = false,
        rear = { static = true }
    },
    -- Zeno (zeno)
    [655665811] = {
        front = false,
        rear = { static = true }
    },
    -- ZType
    [75889561] = {
        front = false,
        rear = { static = true }
    },
    -- Zorrusso (zorrusso)
    [-682108547] = {
        front = false,
        rear = { onBumper = true }
    },

    -- Trailer --
    -- ArmyTanker
    [-1207431159] = {
        front = false,
        rear = false
    },
    -- Army Trailer (armytrailer)
    [-1476447243] = {
        front = false,
        rear = false
    },
    -- Army Trailer (armytrailer2)
    [-1637149482] = {
        front = false,
        rear = false
    },
    -- BaleTrailer
    [-399841706] = {
        front = false,
        rear = false
    },
    -- BoatTrailer
    [524108981] = {
        front = false,
        rear = false
    },
    -- CableCar
    [-960289747] = {
        front = false,
        rear = false
    },
    -- DockTrailer
    [-2140210194] = {
        front = false,
        rear = false
    },
    -- Freight Trailer (freighttrailer)
    [-777275802] = {
        front = false,
        rear = false
    },
    -- GrainTrailer
    [1019737494] = {
        front = false,
        rear = false
    },
    -- PropTrailer
    [356391690] = {
        front = false,
        rear = false
    },
    -- RakeTrailer
    [390902130] = {
        front = false,
        rear = false
    },
    -- TR2
    [2078290630] = {
        front = false,
        rear = false
    },
    -- TR3
    [1784254509] = {
        front = false,
        rear = false
    },
    -- TR4
    [2091594960] = {
        front = false,
        rear = false
    },
    -- TRFlat
    [-1352468814] = {
        front = false,
        rear = false
    },
    -- TVTrailer
    [-1770643266] = {
        front = false,
        rear = false
    },
    -- Tanker
    [-730904777] = {
        front = false,
        rear = false
    },
    -- Tanker2
    [1956216962] = {
        front = false,
        rear = false
    },
    -- TrailerLogs
    [2016027501] = {
        front = false,
        rear = false
    },
    -- TrailerSmall
    [712162987] = {
        front = false,
        rear = false
    },
    -- Trailers
    [-877478386] = {
        front = false,
        rear = false
    },
    -- Trailers2
    [-1579533167] = {
        front = false,
        rear = false
    },
    -- Trailers3
    [-2058878099] = {
        front = false,
        rear = false
    },

    -- Utility --
    -- Airtug
    [1560980623] = {
        front = false,
        rear = false
    },
    -- Caddy
    [1147287684] = {
        front = false,
        rear = false
    },
    -- Caddy2
    [-537896628] = {
        front = false,
        rear = false
    },
    -- Caddy3
    [-769147461] = {
        front = false,
        rear = false
    },
    -- Docktug
    [-884690486] = {
        front = false,
        rear = false
    },
    -- Forklift
    [1491375716] = {
        front = false,
        rear = false
    },
    -- Mower
    [1783355638] = {
        front = false,
        rear = false
    },
    -- Ripley
    [-845979911] = {
        front = false,
        rear = false
    },
    -- Sadler
    [-599568815] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Sadler2
    [734217681] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Scrap
    [-1700801569] = {
        front = false,
        rear = false
    },
    -- Slamtruck
    [-1045911276] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- TowTruck
    [-1323100960] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- TowTruck2
    [-442313018] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Tractor
    [1641462412] = {
        front = false,
        rear = false
    },
    -- Tractor2
    [-2076478498] = {
        front = false,
        rear = false
    },
    -- Tractor3
    [1445631933] = {
        front = false,
        rear = false
    },
    -- Mobile Operations Center (trailerlarge)
    [1502869817] = {
        front = false,
        rear = { static = true }
    },
    -- TrailerS4
    [-1100548694] = {
        front = false,
        rear = false
    },
    -- UtilliTruck
    [516990260] = {
        front = false,
        rear = { static = true }
    },
    -- UtilliTruck2
    [887537515] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- UtilliTruck3
    [2132890591] = {
        front = { onBumper = true },
        rear = { static = true }
    },

    -- Vans --
    -- Bison
    [-16948145] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Bison2
    [2072156101] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Bison3
    [1739845664] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- BobcatXL
    [1069929536] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Boxville
    [-1987130134] = {
        front = false,
        rear = { static = true }
    },
    -- Boxville2
    [-233098306] = {
        front = false,
        rear = { static = true }
    },
    -- Boxville3
    [121658888] = {
        front = false,
        rear = { static = true }
    },
    -- Boxville4
    [444171386] = {
        front = false,
        rear = { static = true }
    },
    -- Boxville5
    [682434785] = {
        front = false,
        rear = { static = true }
    },
    -- Burrito
    [-1346687836] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Burrito2
    [-907477130] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Burrito3
    [-1743316013] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Burrito4
    [893081117] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Burrito5
    [1132262048] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Camper
    [1876516712] = {
        front = { onBumper = true },
        rear = false
    },
    -- GBurrito
    [-1745203402] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- GBurrito2
    [296357396] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Journey
    [-120287622] = {
        front = false,
        rear = { onBumper = true }
    },
    -- Journey II (journey2)
    [-1627077503] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Minivan
    [-310465116] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Minivan2
    [-1126264336] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Paradise
    [1488164764] = {
        front = { onBumper = true },
        rear = { onDoor = 3 }
    },
    -- Pony
    [-119658072] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Pony2
    [943752001] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Rumpo
    [1162065741] = {
        front = false,
        rear = { onDoor = 3 }
    },
    -- Rumpo2
    [-1776615689] = {
        front = false,
        rear = { onDoor = 3 }
    },
    -- Rumpo3
    [1475773103] = {
        front = false,
        rear = { onTrunk = true }
    },
    -- Speedo
    [-810318068] = {
        front = { onBumper = true },
        rear = { onDoor = 3 }
    },
    -- Speedo2
    [728614474] = {
        front = { onBumper = true },
        rear = { onDoor = 3 }
    },
    -- Speedo Custom (speedo4)
    [219613597] = {
        front = { onBumper = true },
        rear = { onDoor = 3 }
    },
    -- Surfer (surfer)
    [699456151] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Rusty Surfer (surfer2)
    [-1311240698] = {
        front = false,
        rear = false
    },
    -- Surfer Custom (surfer3)
    [-1035489563] = {
        front = { onBumper = true },
        rear = { static = true }
    },
    -- Taco
    [1951180813] = {
        front = false,
        rear = { static = true }
    },
    -- Youga
    [65402552] = {
        front = { onBumper = true },
        rear = { onBumper = true }
    },
    -- Youga2
    [1026149675] = {
        front = { onBumper = true },
        rear = { onTrunk = true }
    },
    -- Youga Classic 4x4 (youga3)
    [1802742206] = {
        front = { onBumper = true },
        rear = { door = 3 }
    },
    -- Youga Custom (youga4)
    [1486521356] = {
        front = false,
        rear = { onTrunk = true }
    }
}

local noPlateClasses = {
    -- Cycles, Boats, Helicopters, Planes, Trains, Open Wheel
    [13] = true, [14] = true, [15] = true, [16] = true, [21] = true, [22] = true
}

local doorBones = {
    [0] = 'door_dside_f',
	[1] = 'door_dside_r',
	[2] = 'door_pside_f',
	[3] = 'door_pside_r',
}

local noModelCache = {}

local function IsBoneAttachedToVehicle(vehicle, bone)
    local boneIndex = GetEntityBoneIndexByName(vehicle, bone)
    if boneIndex ~= -1 then
        local rotation = GetEntityBoneRotation(vehicle, boneIndex)
        if math.abs(rotation.x + rotation.y + rotation.z) > 0.01 then
            return true
        end
    end
    return false
end

local function IsPlateVisible(vehicle, plate, type, vehicleRotation, cameraRotation)
    if not plate then
        return false
    end

    if plate.onBumper then
        local bumperBone = nil
        if type == 'rear' then
            bumperBone = "bumper_r"
        else
            bumperBone = "bumper_f"
        end

        local isBumperAttached = IsBoneAttachedToVehicle(vehicle, bumperBone)
        if not isBumperAttached then
            return false
        end
    elseif plate.onTrunk then
        local isTrunkAttached = IsBoneAttachedToVehicle(vehicle, "boot")
        if not isTrunkAttached then
            return false
        end
    elseif plate.onHood then
        local isHoodAttached = IsBoneAttachedToVehicle(vehicle, "bonnet")
        if not isHoodAttached then
            return false
        end
    elseif plate.onDoor then
        local doorBone = doorBones[plate.onDoor]
        local isDoorAttached = IsBoneAttachedToVehicle(vehicle, doorBone)
        if not isDoorAttached then
            return false
        end
    elseif plate.onExtra then
        local isExtraEnabled = IsVehicleExtraTurnedOn(vehicle, plate.onExtra)
        if not isExtraEnabled then
            return false
        end
    end

    -- Checks Angle
    if Config.CheckLicensePlateAngle then
        local vehicleRotZ = vehicleRotation.z
        if type == 'rear' then
            vehicleRotZ = vehicleRotZ + 180.0
        end

        local zDifference = math.abs(vehicleRotZ - cameraRotation.z)
        if zDifference < 110.0 or zDifference > 250.0 then
            return false
        end

        local xDifference = math.abs(vehicleRotation.x - cameraRotation.x)
        if xDifference > 60.0 then
            return false
        end
    end

    return true
end

function GetVehicleNumberPlate(vehicle, vehicleRotation, cameraRotation)
    local class = GetVehicleClass(vehicle)
    if noPlateClasses[class] then
        return false, nil
    end

    local model = GetEntityModel(vehicle)
    local plate = vehicleNumberPlates[model]
    if not plate then
        plate = vehicleNumberPlates['default']
        if not noModelCache[model] then
            noModelCache[model] = true
            print("^3No plate data was found for vehicle model: "..model..", please add it to the numberplates.lua file.^0")
        end
    end

    if IsPlateVisible(vehicle, plate.front, 'front', vehicleRotation, cameraRotation) or IsPlateVisible(vehicle, plate.rear, 'rear', vehicleRotation, cameraRotation) then
        return true, GetVehicleNumberPlateText(vehicle)
    end

    return false, nil
end
