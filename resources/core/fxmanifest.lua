fx_version 'adamant'
game 'gta5'
lua54 "yes"

loadscreen_manual_shutdown "yes"

shared_script {
    'config/items_use.lua',
    'config/ltd.lua',
    'shared/**/*',
    "server/addon/*.json"
}

escrow_ignore {
    "client/**/*.mp3",
    "client/**/*.webp",
    "client/**/*.ttf",
    "client/**/*.otf",
    "client/loadscreen/*.html",
    "client/loadscreen/*.css",
    "client/loadscreen/*.js",
    "client/loadscreen/*.webm",
    "config/*.json",
    "config/*.txt",
    "stream/**/*.gfx",
    "stream/*.gfx",
    "stream/*.ydr",
    "stream/*.ytd",
    "server/**/*.lua"
}

data_file 'DLC_ITYP_REQUEST' 'stream/prop/rcnk_letter.ytyp'

files {
    'client/webapp/*.html',
    -- 'client/webapp/js/*.js',
    -- 'client/webapp/img/*.webp',

    -- 'client/webapp/css/*.css',
    'client/webapp/**/*',
    "client/**/*.ttf",
    'client/loadscreen/*',
    'config/cutscenes.json',

    -- 'client/addon/dev/anim/animations.txt',
    '@Visionhttps://cdn.sacul.cloud/v2/vision-cdn/**/*.webp',
}

ui_page 'client/webapp/index.html'
loadscreen 'client/loadscreen/index.html'

client_scripts {
    --'@GolfActivity/**/*.lua',
    'client/security/*.lua',
    "client/modules/handler/module_handler.lua",
    "client/modules/module/native_ui.lua",
    "client/modules/module/*.lua",
    'client/RageUI/RMenu.lua',
    'client/RageUI/menu/RageUI.lua',
    'client/RageUI/menu/Menu.lua',
    'client/RageUI/menu/MenuController.lua',
    'client/RageUI/components/*.lua',
    'client/RageUI/menu/elements/*.lua',
    'client/RageUI/menu/items/*.lua',
    'client/RageUI/menu/panels/*.lua',
    'client/RageUI/menu/windows/*.lua',

    -- Config
    'config/coffreveh.lua',
    'config/3dme.lua',
    'config/clothsban.lua',
    'config/config.lua',
    'config/items.lua',
    'config/jobs.lua',
    'config/realisticveh.lua',
    'config/djcfg.lua',
    'config/staff.lua',
    'config/casino_config_c.lua',
    'config/casino_config_sh.lua',
    -- 'config/ems.lua',
    'config/animation.lua',
    'config/blips.lua',
    'config/dev.lua',
    'config/vehicle_shop.lua',
    'config/garage.lua',
    'config/cloths.lua',
    'config/default_cloths_value.lua',
    'config/weapons.lua',
    'config/doors.lua',
    -- 'config/usms.lua',
    -- 'config/police.lua',
    'config/weazel.lua',
    -- 'config/market.lua',
    'config/property.lua',
    'config/tattoos.lua',
    'config/superette_holdup.lua',
    'config/robbery_market.lua',
    -- 'config/licences.lua',
    'config/house_heist_data.lua',
    'config/vangelico_heist_config.lua',
    'config/config_trailer.lua',
    -- Client
    'client/admin/**/*.lua',
    'client/vAdmin/**/*.lua',


    'zerotrust.internal.lua',

    'client/class/*.lua',
    'client/utils/*.lua',
    'client/RubyUI/*.lua',

    -- 'client/lib/**/**/*.lua',

    'client/data/*.lua',
    'client/handler/*.lua',
    'client/function/*.lua',
    'client/command/*.lua',
    'client/addon/**/**/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/**/*.lua',
    'config/3dme.lua',
    'config/jobs.lua',
    'config/coffreveh.lua',
    'config/logs.lua',
    'config/items.lua',
    'config/casino_config_sh.lua',
    'config/clothsban.lua',

    'server/utils/utils.lua',

    'server/class/**/*.lua',
    'server/handler/**/*.lua',
    'server/security/**/*.lua',
    'server/addon/**/*.lua',
    'server/command/**/*.lua',
    'server/crew/**/*.lua',

    'server/data/**/*.lua',
    'server/utils/**/*.lua',

    'server/vAdmin/*.lua',
}

exports {
    'TriggerServerCallback',
    'cleanPlayer',
    'GROSNIBARD',
    'GetMoneyPlayer',
    'getMoneyPhone',
    'GetJobPlayerData',
    'getId',
    'GetPlayer',
    'AddMoneyToSociety',
    'GetPlayerPerm',
    'GiveItemToPlayer',
    'RemoveItemToPlayer',
    'DoesPlayerHaveItemCount',
    'getPermission',
    'GetPlayerIdbdd',
    'GetPlayerFullname',
    'ChoicePlayersInZone',
    'KeyboardImput',
    'TriggerSWEvent'
}
