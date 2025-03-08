fx_version 'cerulean'
game 'gta5'

author 'Knid'
description 'Knid MDT'
version '0.4.1'

client_scripts {
	'configs/client.lua',
	'client.lua'
}

server_scripts {
	'configs/client.lua',
	'configs/server.lua',
	'sha256.lua',
	'server.lua'
}

files {
  "ui/**/*",
}

escrow_ignore {
  'configs/client.lua',
  'configs/server.lua'
}

exports {
	'api',
	'open',
	'close',
	'opened'
}

ui_page "https://demo.lspd-mdt.com/fivem.html"

lua54 'yes'

dependency '/assetpacks'