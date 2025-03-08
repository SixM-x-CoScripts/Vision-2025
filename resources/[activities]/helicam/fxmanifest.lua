fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mads'
description 'Helicam'
version '1.0.9'

client_scripts {
	'config.lua',
	'numberplates.lua',
	'framework/standalone.lua',
	'framework/esx.lua',
	'framework/qb.lua',
	'client.lua'
}

server_script 'server.lua'

escrow_ignore {
	'config.lua',
	'numberplates.lua',
	'framework/standalone.lua',
	'framework/esx.lua',
	'framework/qb.lua',
	'client.lua',
	'server.lua'
}

ui_page('html/index.html')

files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/images/*.svg'
}

dependencies {
	'/server:5181',
	'/gameBuild:2060' -- Needed due to usage of game events.
}

dependency '/assetpacks'