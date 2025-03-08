fx_version 'cerulean'

game 'gta5'

description 'BlipCreator by Pr3stor'

author 'Pr3stor'

lua54 "yes"

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/*.lua',
}

client_scripts {
	'client/*.lua',
}

files({
	'html/*.html',
	"html/**/*",
	
})

ui_page('html/index.html')

exports {
	"blipCreator"
}

dependency '/assetpacks'
dependency '/assetpacks'