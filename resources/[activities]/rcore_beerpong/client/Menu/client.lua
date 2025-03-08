CachedMenu = {}
OpenMenu = false
--------------
-- Sending info about changing item in menu
--------------
RegisterKey(function()
    SendNUIMessage({ type_menu = "up" })
end, "menuapiup_beerpong", "menu go up", "UP")

RegisterKey(function()
    SendNUIMessage({ type_menu = "down" })
end, "menuapidown_beerpong", "menu go down", "DOWN")

-----

RegisterKey(function()
    SendNUIMessage({ type_menu = "up" })
end, "menuapiup_beerpongmouse.", "menu go up", "IOM_WHEEL_UP", "MOUSE_WHEEL")

RegisterKey(function()
    SendNUIMessage({ type_menu = "down" })
end, "menuapidown_beerpongmouse.", "menu go down", "IOM_WHEEL_DOWN", "MOUSE_WHEEL")
--------------
-- Sending info about selecting item
--------------
RegisterKey(function()
    SendNUIMessage({ type_menu = "enter" })
end, "menuapie_beerpong_mouseaa", "Mouse right", "MOUSE_LEFT", "MOUSE_BUTTON")

RegisterKey(function()
    SendNUIMessage({ type_menu = "enter" })
end, "menuapie_beerpong", "Key E", "E")

RegisterKey(function()
    SendNUIMessage({ type_menu = "enter" })
end, "menuapienter_beerpong", "Key ENTER", "RETURN")
--------------
-- closing menu keys
--------------
RegisterKey(function()
    ExitAllOpenedMenu()
end, "menuapiesc_beerpong", "Key ESC", "escape")

RegisterKey(function()
    ExitAllOpenedMenu()
end, "menuapiescaper_beerpong", "Key backspace", "back")
--------------