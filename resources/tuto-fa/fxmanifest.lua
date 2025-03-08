fx_version 'adamant'
game 'gta5'
lua54 "yes"

client_script 'client.lua'


files {
    -- Add all html, js, css and image files
    'web/index.html',
    'web/script.js',
    'web/style.css',
    'web/img/*.webp',
}

-- Add web files
ui_page 'web/index.html'