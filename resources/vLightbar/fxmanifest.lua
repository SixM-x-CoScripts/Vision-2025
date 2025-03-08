fx_version 'cerulean'
game 'gta5'

name "vLightbar"
author "Zerkay"
description "Pas touche ou je te nique"
version "1.0.0"

shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

ui_page 'UI/index.html'

files{
	"UI/*.css",
	"UI/*.html",
	"UI/*.js",
	"UI/**.ttf",
	"shared/*.json",
	'data/vehicles.meta',
	'data/carcols.meta',
	'data/carvariations.meta',
}

data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'


exports {
	'loadLightbarInCar',
	--exports.vLightbar:loadLightbarInCar(vehicle);
}