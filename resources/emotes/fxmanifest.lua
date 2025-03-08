fx_version 'cerulean'
game 'gta5'
author 'Flozii & Sacul mon amour'
description 'ABSOLUTE emotes'
version '1.0.0'
lua54 'yes'

dependencies {
    '/server:5848',
    '/onesync',
}

client_scripts {
    'client/utils.lua',
    'client/favorites.lua',
    'client/menu.lua',
    'client/events.lua',
    'client/crouch.lua',
}

shared_scripts {
    'shared/emotes.lua',
    'shared/emotes_custom.lua',
}

server_scripts {
    'server/main.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/taymckenzienz_rpemotes.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/brummie_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/apple_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/kaykaymods_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/knjgh_pizzas.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/natty_props_lollipops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ultra_ringcase.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/pata_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ems_props.ytyp'
