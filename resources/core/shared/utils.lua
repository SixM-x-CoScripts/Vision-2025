function print_(msg)
    print(json.encode(msg))
end

function _TRGSE(input)
    local encrypted = ""
    for i = 1, #input do
        local char = input:sub(i, i)
        local encryptedChar = substitutionTable[char] or char
        encrypted = encrypted .. encryptedChar
    end
    return encrypted
end

weaponsNames = {
	'WEAPON_DAGGER',
	'WEAPON_BAT',
	'WEAPON_BOTTLE',
	'WEAPON_CROWBAR',
	'WEAPON_UNARMED',
	'WEAPON_FLASHLIGHT',
	'WEAPON_GOLFCLUB',
	'WEAPON_HAMMER',
	'WEAPON_HATCHET',
	'WEAPON_KNUCKLE',
	'WEAPON_KNIFE',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_WRENCH',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_STONE_HATCHET',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_STUNGUN',
	'WEAPON_PISTOL50',
	'WEAPON_SNSPISTOL',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_REVOLVER',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_DOUBLEACTION',
	'WEAPON_RAYPISTOL',
	'WEAPON_CERAMICPISTOL',
	'WEAPON_NAVYREVOLVER',
	'WEAPON_GADGETPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_SMG_MK2',
	'WEAPON_ASSAULTSMG',
	'WEAPON_COMBATPDW',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_MINISMG',
	'WEAPON_RAYCARBINE',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_MUSKET',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_RPG',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMBATSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_ASSAULTRIFLE_MK2',
	'WEAPON_CARBINERIFLE',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_HEAVYRIFLE',
	'WEAPON_TACTICALRIFLE',
	'WEAPON_MILITARYRIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_SPECIALCARBINE_MK2',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_BULLPUPRIFLE_MK2',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MILITARYRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_COMBATMG_MK2',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_HEAVYSNIPER_MK2',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_MARKSMANRIFLE_MK2',
	'weapon_emplauncher',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_GRENADELAUNCHER_SMOKE',
	'WEAPON_MINIGUN',
	'WEAPON_FIREWORK',
	'WEAPON_RAILGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_RAYMINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_STICKYBOMB',
	'WEAPON_PROXMINE',
	'WEAPON_SNOWBALL',
	'WEAPON_PIPEBOMB',
	'WEAPON_BALL',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_FLARE',
	'WEAPON_PETROLCAN',
	'WEAPON_FIREEXTINGUISHER',
	'WEAPON_HAZARDCAN'
}

weaponHashes = {}

for k,v in pairs(weaponsNames) do
	weaponHashes[GetHashKey(v)] = v
end































-----------------------------------------------------------------------------------------------
------------------------ NE PAS MONTRER CETTE PARTIE A N'IMPORTE QUI --------------------------
-----------------------------------------------------------------------------------------------




substitutionTable = {
    ["a"] = "8", ["b"] = "@", ["c"] = "#", ["d"] = "4",
    ["e"] = "1", ["f"] = "!", ["g"] = "9", ["h"] = "0",
    ["i"] = "2", ["j"] = "&", ["k"] = "3", ["l"] = "$",
    ["m"] = "5", ["n"] = "%", ["o"] = "7", ["p"] = "*",
    ["q"] = "6", ["r"] = "(", ["s"] = ")", ["t"] = "-",
    ["u"] = "_", ["v"] = "+", ["w"] = "=", ["x"] = "[",
    ["y"] = "]", ["z"] = "{",

    ["A"] = "Q", ["B"] = "W", ["C"] = "E", ["D"] = "R",
    ["E"] = "T", ["F"] = "Y", ["G"] = "U", ["H"] = "I",
    ["I"] = "O", ["J"] = "P", ["K"] = "A", ["L"] = "S",
    ["M"] = "D", ["N"] = "F", ["O"] = "G", ["P"] = "H",
    ["Q"] = "J", ["R"] = "K", ["S"] = "L", ["T"] = "Z",
    ["U"] = "X", ["V"] = "C", ["W"] = "V", ["X"] = "B",
    ["Y"] = "N", ["Z"] = "M",

    ["0"] = "t", ["1"] = "u", ["2"] = "v", ["3"] = "w",
    ["4"] = "x", ["5"] = "y", ["6"] = "z", ["7"] = "a",
    ["8"] = "b", ["9"] = "c",

    [" "] = " ", ["_"] = "?"
}


-- substitutionTable = {                    --------------- TEST MATHIAS ---------------
--     ["a"] = "l", ["b"] = "|", ["c"] = "i", ["d"] = "l",
--     ["e"] = "|", ["f"] = "i", ["g"] = "|", ["h"] = "l",
--     ["i"] = "i", ["j"] = "|", ["k"] = "l", ["l"] = "i",
--     ["m"] = "|", ["n"] = "l", ["o"] = "i", ["p"] = "l",
--     ["q"] = "l", ["r"] = "i", ["s"] = "|", ["t"] = "|",
--     ["u"] = "i", ["v"] = "|", ["w"] = "l", ["x"] = "i",
--     ["y"] = "|", ["z"] = "i",

--     ["A"] = "i", ["B"] = "|", ["C"] = "l", ["D"] = "i",
--     ["E"] = "i", ["F"] = "|", ["G"] = "l", ["H"] = "i",
--     ["I"] = "i", ["J"] = "|", ["K"] = "l", ["L"] = "i",
--     ["M"] = "i", ["N"] = "|", ["O"] = "l", ["P"] = "i",
--     ["Q"] = "i", ["R"] = "|", ["S"] = "l", ["T"] = "i",
--     ["U"] = "i", ["V"] = "|", ["W"] = "l", ["X"] = "i",
--     ["Y"] = "i", ["Z"] = "|",

--     ["0"] = "|", ["1"] = "l", ["2"] = "|", ["3"] = "|",
--     ["4"] = "|", ["5"] = "l", ["6"] = "|", ["7"] = "|",
--     ["8"] = "|", ["9"] = "l",

--     [" "] = "i", ["_"] = "i"
-- }
