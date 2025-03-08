local deltas = {
	vector2(-1, -1),
	vector2(-1, 0),
	vector2(-1, 1),
	vector2(0, -1),
	vector2(1, -1),
	vector2(1, 0),
	vector2(1, 1),
	vector2(0, 1),
}
local bitShift = 2
local zoneRadius = 100

function GetGridChunk(x)
	return math.floor((x + 8192) / zoneRadius)
end

function GetGridBase(x)
	return (x * zoneRadius) - 8192
end

function GetChunkId(v)
	return v.x << bitShift | v.y
end

function GetMaxChunkId()
	return zoneRadius << bitShift
end

function GetCurrentChunk(pos)
	local chunk = vector2(GetGridChunk(pos.x), GetGridChunk(pos.y))
	local chunkId = GetChunkId(chunk)

	return chunkId
end

function GetNearbyChunks(pos)
    local nearbyChunksList = {}
	local nearbyChunks = {}
	
    for i = 1, #deltas do -- Get nearby chunks
        local chunkSize = pos.xy + (deltas[i] * 20) -- edge size
        local chunk = vector2(GetGridChunk(chunkSize.x), GetGridChunk(chunkSize.y)) -- get nearby chunk
        local chunkId = GetChunkId(chunk) -- Get id for chunk

		if not nearbyChunksList[chunkId] then		
			nearbyChunks[#nearbyChunks + 1] = chunkId
			nearbyChunksList[chunkId] = true
		end
    end

    return nearbyChunks
end

local CurrentChunk = nil
local CurrentChunks = {}

local all_zones = {
    ['AIRP'] = "Los Santos International Airport",
    ['ALAMO'] = "Alamo Sea",
    ['ALTA'] = "Alta",
    ['ARMYB'] = "Fort Zancudo",
    ['BANHAMC'] = "Banham Canyon Dr",
    ['BANNING'] = "Banning",
    ['BEACH'] = "Vespucci Beach",
    ['BHAMCA'] = "Banham Canyon",
    ['BRADP'] = "Braddock Pass",
    ['BRADT'] = "Braddock Tunnel",
    ['BURTON'] = "Burton",
    ['CALAFB'] = "Calafia Bridge",
    ['CANNY'] = "Raton Canyon",
    ['CCREAK'] = "Cassidy Creek",
    ['CHAMH'] = "Chamberlain Hills",
    ['CHIL'] = "Vinewood Hills",
    ['CHU'] = "Chumash",
    ['CMSW'] = "Chiliad Mountain State Wildernes",
    ['CYPRE'] = "Cypress Flats",
    ['DAVIS'] = "Davis",
    ['DELBE'] = "Del Perro Beach",
    ['DELPE'] = "Del Perro",
    ['DELSOL'] = "La Puerta",
    ['DESRT'] = "Grand Senora Desert",
    ['DOWNT'] = "Downtown",
    ['DTVINE'] = "Downtown Vinewood",
    ['EAST_V'] = "East Vinewood",
    ['EBURO'] = "El Burro Heights",
    ['ELGORL'] = "El Gordo Lighthouse",
    ['ELYSIAN'] = "Elysian Island",
    ['GALFISH'] = "Galilee",
    ['GOLF'] = "GWC and Golfing Society",
    ['GRAPES'] = "Grapeseed",
    ['GREATC'] = "Great Chaparral",
    ['HARMO'] = "Harmony",
    ['HAWICK'] = "Hawick",
    ['HORS'] = "Vinewood Racetrack",
    ['HUMLAB'] = "Humane Labs and Research",
    ['JAIL'] = "Bolingbroke Penitentiary",
    ['KOREAT'] = "Little Seoul",
    ['LACT'] = "Land Act Reservoir",
    ['LAGO'] = "Lago Zancudo",
    ['LDAM'] = "Land Act Dam",
    ['LEGSQU'] = "Legion Square",
    ['LMESA'] = "La Mesa",
    ['LOSPUER'] = "La Puerta",
    ['MIRR'] = "Mirror Park",
    ['MORN'] = "Morningwood",
    ['MOVIE'] = "Richards Majestic",
    ['MTCHIL'] = "Mount Chiliad",
    ['MTGORDO'] = "Mount Gordo",
    ['MTJOSE'] = "Mount Josiah",
    ['MURRI'] = "Murrieta Heights",
    ['NCHU'] = "North Chumash",
    ['NOOSE'] = "N.O.O.S.E",
    ['OCEANA'] = "Pacific Ocean",
    ['PALCOV'] = "Paleto Cove",
    ['PALETO'] = "Paleto Bay",
    ['PALFOR'] = "Paleto Forest",
    ['PALHIGH'] = "Palomino Highlands",
    ['PALMPOW'] = "Palmer-Taylor Power Station",
    ['PBLUFF'] = "Pacific Bluffs",
    ['PBOX'] = "Pillbox Hill",
    ['PROCOB'] = "Procopio Beach",
    ['RANCHO'] = "Rancho",
    ['RGLEN'] = "Richman Glen",
    ['RICHM'] = "Richman",
    ['ROCKF'] = "Rockford Hills",
    ['RTRAK'] = "Redwood Lights Track",
    ['SANAND'] = "San Andreas",
    ['SANCHIA'] = "San Chianski Mountain Range",
    ['SANDY'] = "Sandy Shores",
    ['SKID'] = "Mission Row",
    ['SLAB'] = "Stab City",
    ['STAD'] = "Maze Bank Arena",
    ['STRAW'] = "Strawberry",
    ['TATAMO'] = "Tataviam Mountains",
    ['TERMINA'] = "Terminal",
    ['TEXTI'] = "Textile City",
    ['TONGVAH'] = "Tongva Hills",
    ['TONGVAV'] = "Tongva Valley",
    ['VCANA'] = "Vespucci Canals",
    ['VESP'] = "Vespucci",
    ['VINE'] = "Vinewood",
    ['WINDF'] = "Ron Alternates Wind Farm",
    ['WVINE'] = "West Vinewood",
    ['ZANCUDO'] = "Zancudo River",
    ['ZP_ORT'] = "Port of South Los Santos",
    ['ZQ_UAR'] = "Davis Quartz",
    ['PROL'] = "North Yankton",
    ['ISHeist'] = "Cayo Perico Island",
}

RegisterCommand('getchunk', function()
    local chunk = GetNameOfZone(GetEntityCoords(p:ped()))

    
    print("Zone : ".. all_zones[chunk])

    print("--------------------------------")
    
end)


