-- ______  _  _                          _____  __  
-- |  ___|| |(_)                        |____ |/  | 
-- | |_   | | _  _ __ ___    __ _  _ __     / /`| | 
-- |  _|  | || || '_ ` _ \  / _` || '__|    \ \ | | 
-- | |    | || || | | | | || (_| || |   .___/ /_| |_
-- \_|    |_||_||_| |_| |_| \__,_||_|   \____/ \___/                                              

-- 𝘂𝗶𝗖𝗼𝗻𝘁𝗿𝗼𝗹                                  𝘃.𝟬.𝟬.𝟴



fx_version 'bodacious'
game 'gta5'
lua54 "yes"

author 'Flimar31'
description 'Capture de touches en UI sur FiveM'
version '0.0.8'

escrow_ignore {'exemple.lua'}

client_script {'KeyManager.lua'}
server_script {'version.lua'}

ui_page 'ui/index.html'

files {'ui/index.html'}

exports {'onKeyPress', 'removeKeyCallback', 'setDebugMode', 'registerListenerCallback'}
dependency '/assetpacks'