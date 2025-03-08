fx_version "cerulean"
game "gta5"
lua54 'yes'

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/Audio.lua",
    "RageUI/components/Enum.lua",
    "RageUI/components/Keys.lua",
    "RageUI/components/Rectangle.lua",
    "RageUI/components/Screen.lua",
    "RageUI/components/Sprite.lua",
    "RageUI/components/Text.lua",
    "RageUI/components/Visual.lua",
    "RageUI/menu/elements/ItemsBadge.lua",
    "RageUI/menu/elements/ItemsColour.lua",
    "RageUI/menu/elements/PanelColour.lua",
    "RageUI/menu/items/UIButton.lua",
    "RageUI/menu/items/UICheckBox.lua",
    "RageUI/menu/items/UIList.lua",
    "RageUI/menu/items/UIProgress.lua",
    "RageUI/menu/items/UISeparator.lua",
    "RageUI/menu/items/UISlider.lua",
    "RageUI/menu/items/UISliderHeritage.lua",
    "RageUI/menu/items/UISliderProgress.lua",
    "RageUI/menu/panels/UIColourPanel.lua",
    "RageUI/menu/panels/UIGridPanel.lua",
    "RageUI/menu/panels/UIGridPanelHorizontal.lua",
    "RageUI/menu/panels/UIGridPanelVertical.lua",
    "RageUI/menu/panels/UIPercentagePanel.lua",
    "RageUI/menu/panels/UIStatisticsPanel.lua",
    "RageUI/menu/windows/UIHeritage.lua",
}

client_scripts {
    "client/functions.lua",
    "client/menu/main.lua",
    "client/menu/spawnprop.lua",
    "client/menu/propslist.lua",
    "client/nui.lua",
    "client/threads.lua",
    "client/obj.lua",
}
server_scripts {
    "server/*.lua"
}

ui_page 'html/build/index.html'

files {
    'html/build/index.html',
    'html/build/**/*',
    'html/browser.js',
}

exports {
    "DecoModule"
}