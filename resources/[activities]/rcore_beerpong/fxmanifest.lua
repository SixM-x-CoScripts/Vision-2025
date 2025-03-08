fx_version 'bodacious'
games { 'gta5' }

dependencies {
    '/server:4752',
    '/onesync',
}

client_scripts {
    "config.lua",
    "Utils/Utils.lua",
    "client/Utils_editable.lua",

    "client/Menu/exports/*.lua",
    "client/Menu/system/*.lua",
    "client/Menu/module/*.lua",
    "client/Menu/*.lua",
    "shared/*.lua",

    "locales/*.lua",

    "Utils/CallBack/client.lua",

    "drunk/main.lua",

    "client/MaterialList.lua",
    "client/Groups_editable.lua",
    "client/AnimLib/*.lua",
    "client/Animations_editable.lua",
    "client/ButtonScaleForm_editable.lua",
    "client/Camera.lua",
    "client/Client.lua",
    "client/CreateGameLogic.lua",
    "client/Menu_editable.lua",
    "client/Events_editable.lua",
    "client/ThrowAction.lua",
    "client/ThrowEvent.lua",
    "client/BeerPongClass.lua",
    "client/OnStart.lua",
    "client/Physics.lua",
}

server_scripts {
    "config.lua",
    "shared/*.lua",

    "locales/*.lua",

    "Utils/CallBack/server.lua",
    "server/qbcore/*.lua",

    "server/server.lua",
    "server/payment.lua",
    "server/SpawnGameWithItem.lua",
}

escrow_ignore {
    "locales/*.lua",
    "config.lua",
    "utils/*.lua",
    "client/Menu_editable.lua",
    "shared/*.lua",
    "client/Animations_editable.lua",
    "client/Camera.lua",
    "Utils/Utils.lua",
    "client/Utils_editable.lua",
    "Utils/CallBack/server.lua",
    "Utils/CallBack/client.lua",

    "client/Groups_editable.lua",

    "client/Menu/exports/*.lua",
    "client/Menu/system/*.lua",
    "client/Menu/module/*.lua",
    "client/Menu/*.lua",
    "shared/*.lua",

    "server/qbcore/*.lua",

    "server/payment.lua",
    "server/SpawnGameWithItem.lua",
    "server/server.lua",
    "client/ButtonScaleForm_editable.lua",
    "client/Events_editable.lua",
}

lua54 "yes"


files {
    "html/*.html",
    "html/scripts/*.js",
    "html/css/*.css",
    "html/sounds/*.mp3",
    "html/img/*.png",
}

ui_page "html/index.html"
dependency '/assetpacks'