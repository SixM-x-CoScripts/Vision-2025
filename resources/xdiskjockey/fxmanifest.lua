fx_version "cerulean"
games { "gta5" }

dependencies {
	"/server:4752",
}

client_scripts {
	"locales/*.lua",

	"config.lua",

	"xSound/effects/*.lua",
	"xSound/exports/*.lua",
	"xSound/*.lua",

	"utils/class.lua",
	"client/*.lua",
}

server_script {
	"config.lua",
	"@oxmysql/lib/MySQL.lua",
	"server/mysql.lua",
	
	"locales/*.lua",
	"server/playerIdentifier.lua",
	"server/server.lua",
}

shared_scripts {
	"utils/shared.lua",
}

escrow_ignore {
	"locales/*.lua",
	"config.lua",
	"utils/*.lua",
	"server/mysql.lua",
	"server/playerIdentifier.lua",

	"xSound/effects/*.lua",
	"xSound/exports/*.lua",
	"xSound/*.lua",
}


ui_page "html/index.html"

files {
	"html/*.html",
	"html/css/*.css",
	"html/css/img/*.png",
	"html/scripts/*.js",

	"html/xSound/*.js",
	"html/xSound/*.html",
	"html/xSound/*.css",
}

lua54 "yes"
dependency '/assetpacks'