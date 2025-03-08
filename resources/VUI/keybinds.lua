local function Keybind(key, command, name, callback)
    Wait(150)
    RegisterCommand("+vui_" .. command, callback, false)
    RegisterKeyMapping("+vui_" .. command, name, "keyboard", key)
end

-- If arrow up is pressed once, send a message to the NUI to go up in the menu
-- If is maintained, wait 500ms, and if it's still maintained, send a message to the NUI to go up in the menu every 100ms
-- If the arrow is pressed multiple times, it will send multiple messages to the NUI it should not wait 500ms
CreateThread(function()
    local timer = 0
    while true do
        Wait(0)
        if not VUI_CurrentMenu then Wait(300) end
        if IsControlJustPressed(0, 172) then
            SendNUIMessage({
                action = "vui:menu:up"
            })
        end
        if IsControlPressed(0, 172) then
            timer = timer + 1
            if timer > 15 then
                SendNUIMessage({
                    action = "vui:menu:up"
                })
                Wait(50)
            end
        else
            timer = 0
        end
    end
end)


-- Add a keybind on arrow down
CreateThread(function()
    local timer = 0
    while true do
        Wait(0)
        if not VUI_CurrentMenu then Wait(300) end
        if IsControlJustPressed(0, 173) then
            SendNUIMessage({
                action = "vui:menu:down"
            })
        end
        if IsControlPressed(0, 173) then
            timer = timer + 1
            if timer > 20 then
                SendNUIMessage({
                    action = "vui:menu:down"
                })
                Wait(50)
            end
        else
            timer = 0
        end
    end
end)

-- Add a keybind on left arrow
Keybind("left", "menu_left", "Menu Left", function()
    if not VUI_CurrentMenu then return end
    SendNUIMessage({
        action = "vui:menu:left"
    })
end)

-- Add a keybind on right arrow
Keybind("right", "menu_right", "Menu Right", function()
    if not VUI_CurrentMenu then return end
    SendNUIMessage({
        action = "vui:menu:right"
    })
end)

-- Add a keybind on enter key
Keybind("return", "menu_click_item", "Menu Click item", function()
    if not VUI_CurrentMenu then return end
    SendNUIMessage({
        action = "vui:menu:click"
    })
end)

-- Add a keybind on backspace key (name is not backspace because it's not working)
Keybind("back", "menu_back", "Menu Back", function()
    if not VUI_CurrentMenu then return end
    if VUI_CurrentMenu.parent then
        local parent = VUI_CurrentMenu.parent
        VUI_CurrentMenu.close()
        VUI_CurrentMenu = parent
        VUI_CurrentMenu.open()
    else
        VUI_CurrentMenu.close()
        VUI_CurrentMenu = nil
    end
end)