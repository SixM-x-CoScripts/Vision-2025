fx_version "cerulean"
game "gta5"

ui_page 'web/dist/index.html'

files {
	'web/dist/index.html',
    'web/dist/assets/*.js',
    'web/dist/assets/*.css',
    'web/dist/assets/*.mp3',
    'web/dist/assets/banners/*.webp',
    'web/dist/assets/icons/*.webp',
    'web/dist/assets/sounds/*.mp3',
}

client_scripts {
    'callbacks.lua',
    'keybinds.lua',
    'vui.lua',
}

server_scripts {}

exports {}