fx_version 'cerulean'

game 'gta5'

description 'Radars by Pr3stor'

author 'Pr3stor'

lua54 "yes"

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

client_scripts {
	'client/*.lua',
	'config.lua',
}

-- ui_page('html/index.html')

-- files({
-- 	"html/**/*"
-- })

dependency '/assetpacks'

escrow_ignore {
    "config.lua",
	"client/sharedClient.lua",
	"server/sharedServer.lua",
}
dependency '/assetpacks'