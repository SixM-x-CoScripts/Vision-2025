fx_version 'cerulean'

game 'gta5'

ui_page 'html/index.html'

files {
    'html/*.js',
    'html/*.css',
    'html/styles/*.css',
    'html/*.html',
    'html/*.png',
    'html/toast/img/*.svg',
    'html/toast/*.js',
    'html/toast/*.css',
    'server/standard_handlings.json',
}

client_scripts {
    -- '@extendedmode/import.lua',
    'configs/config.lua',
    'configs/client_config.lua',
    'configs/config.js',
    'client/main.lua',
    'client/vehicleevents.lua',
}

server_scripts {
    -- '@extendedmode/import.lua',
    '@oxmysql/lib/MySQL.lua',
    'configs/config.lua',
    'configs/server_config.lua',
    'server/main.lua',
}

shared_scripts {
    'vehicles_data.js',
}

escrow_ignore {
    '/configs/*.lua',
    '/configs/*.js',
}

-- dependency 'extendedmode'

lua54 'yes'



dependency '/assetpacks'