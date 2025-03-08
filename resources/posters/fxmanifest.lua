fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/**/**',
    'web/dist/assets/**',
    'web/dist/assets/*.css',
    'web/dist/assets/*.js',
    'web/dist/assets/*.ttf',
    'web/dist/assets/*.woff',
    'web/dist/assets/*.woff2',
}

client_scripts {
    'source/client.lua'
}

server_scripts {
    'source/server.lua'
}

shared_scripts {
    'source/shared.lua'
}