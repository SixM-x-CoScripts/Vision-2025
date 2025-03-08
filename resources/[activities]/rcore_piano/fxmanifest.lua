fx_version 'cerulean'
games { 'gta5' }

client_scripts {
    "client/music/*.lua",
    "config.lua",

    "shared/*.lua",
    "shared/locales/*.lua",

    "dump_table.lua",
    "utils.lua",

    "client/*.lua",

    "client/buildedstuff/records_desks/item_music.lua",

    "client/buildedstuff/records_desks/rick.lua",
    "client/buildedstuff/records_desks/pirate.lua",
    "client/buildedstuff/records_desks/rasputin.lua",
    "client/buildedstuff/records_desks/revenge.lua",

    "client/buildedstuff/*.lua",
}

server_scripts {
    "client/music/*.lua",
    "config.lua",

    "shared/*.lua",
    "shared/locales/*.lua",

    "dump_table.lua",
    "utils.lua",

    "server/*.lua",
}

dependencies {
    'rcore_piano_object',
    '/server:4752',
}

ui_page "html/index.html"

files {
	"html/*.html",
	"html/scripts/*.js",
    --"html/scripts/*/*.js",
    "html/scripts/**/*.js",
	"html/css/*.css",
	"html/css/*.png",
    "html/css/*.jpg",

    "html/css/*.jpg",
    "html/css/*.jpg",

    "html/piano/classic/*.mp3",
}

lua54 'yes'

escrow_ignore {
    "dump_table.lua",
    "utils.lua",
    "client/music/*.lua",
    "config.lua",
    "client/notify.lua",
    "shared/locales/*.lua",
    "shared/*.lua",
    "stream/*.*",
    "client/buildedstuff/**/*.lua",
    "client/buildedstuff/*.lua",
    "server/place_piano.lua",
}
dependency '/assetpacks'