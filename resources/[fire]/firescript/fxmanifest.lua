fx_version 'bodacious'
games {'gta5'}

-- Resource stuff
name 'Fire Script'
description 'Dynamic Fire Script By ToxicScripts'
version 'v1'
author 'Toxic Scripts'

-- Adds additional logging, useful when debugging issues.
client_debug_mode 'false'
server_debug_mode 'false'

-- Leave this set to '0' to prevent compatibility issues 
-- and to keep the save files your users.
experimental_features_enabled '0'

files {
    'settings.ini',
}

-- Files & scripts
shared_script 'config.lua'

client_scripts {
    'FireScript.net.dll',
    'client/client.lua'
}
server_scripts {
    'server/server.lua',
    'server/random.lua'
}