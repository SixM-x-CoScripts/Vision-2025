fx_version 'bodacious'
games { 'gta5' }

description "Absolute v1 Map"
author "DarKy"
url "https://play.absoluterp.fr/"
version "1.0"

client_script {
    'client.lua'
}

ui_page('html/index.html')

files({
    "html/script.js",
    "html/*.css",
    "html/index.html",
    "html/sounds/*.ogg"
})
