fx_version 'bodacious'
game 'gta5'

description 'RCore Bowling'
version '1.0.0'

lua54 'yes'

client_scripts {
    'config.lua',
    'client/*.lua',
    'shared/shared.lua',
    'object.lua',
}

server_scripts {
    'config.lua',
    'server/*.lua',
    'shared/shared.lua',
    'server/framework/*',
    'object.lua',
}

ui_page 'assets/index.html'

files {
    'assets/index.html',
    'assets/*.png',
    'assets/*.ogg',
    'assets/assets/img/*.png',
    'assets/assets/js/app.js',
    'assets/assets/js/chunk-vendors.js',
    'assets/assets/css/app.css',
}

dependencies {
    '/server:4752',
    '/onesync',
    -- 'breze_bowling_map',
}

escrow_ignore {
    'config.lua',
    'object.lua',

    'server/framework/esx.lua',
    'server/framework/qbcore.lua',
    'server/framework/custom.lua',
    'server/player_remover.lua',
    'server/guidebook.lua',

    'client/client.lua',
    'client/debug.lua',
    'client/input.lua',
    'client/interaction.lua',
    'client/new_ball.lua',
    'client/nui.lua',
    'client/sim_playback.lua',
    'client/sound.lua',
    'client/blip.lua',

    'shared/shared.lua',

    'stream/export@bowlaim.ycd',
    'stream/export@bowlthrow.ycd',
}
dependency '/assetpacks'