fx_version "cerulean"
game 'gta5'

name 'speedometer'
author "unknown"
version '1.0.0'
lua54 'yes'

ui_page "ui/index.html"

files {
	"ui/index.html",
	"ui/assets/clignotant-droite.svg",
	"ui/assets/clignotant-gauche.svg",
	"ui/assets/feu-position.svg",
	"ui/assets/feu-route.svg",
	"ui/assets/fuel.svg",
	"ui/assets/engine.svg",
	--"ui/fonts/fonts/Roboto-Bold.ttf",
	--"ui/fonts/fonts/Roboto-Regular.ttf",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js"
}

client_scripts {
	"client.lua",
}
