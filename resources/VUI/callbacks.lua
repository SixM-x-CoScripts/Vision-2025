RegisterNUICallback('vui:menu:click', function(data, cb)
    if not VUI_CurrentMenu then return end
    -- Get the item in VUI_CurrentMenu

    local item;

    if VUI_CurrentMenu.isFiltered() then
        item = VUI_CurrentMenu.filterItems[data.index + 1]
    else
        item = VUI_CurrentMenu.items[data.index + 1]
    end

    --[[ SendNUIMessage({
        action = "nique:ta:mere:le:lua:ici:ca:console:log:mieux",
        data = {
            type = item.type,
            props = item.props,
            callback = item.callback,
            submenu = item.submenu,
        }
    }) ]]

    -- Check if the item has a callback
    if item.callback then
        -- Call the callback
        if item.type == "checkbox" then
            item.props.checked = data.item.props.checked
            return item.callback(item.props.checked)
        elseif item.type == "list" then
            item.props.index = data.item.props.index
            return item.callback(item.props.index + 1, item.props.items[item.props.index + 1])
        end 

        item.callback()
    end

    -- Check if the item has a submenu
    if item.submenu then
        -- Close the current menu
        VUI_CurrentMenu.close()
        -- Set the current menu to the submenu
        VUI_CurrentMenu = item.submenu
        -- Open the submenu
        VUI_CurrentMenu.open()
    end
    cb()
end)

RegisterNUICallback('vui:menu:indexChange', function(data, cb)
    if not VUI_CurrentMenu then return end
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    VUI_CurrentMenu.index = data.index + 1
    if VUI_CurrentMenu._idxChangeFn then
        if VUI_CurrentMenu.isFiltered() then
            VUI_CurrentMenu._idxChangeFn(VUI_CurrentMenu.index, VUI_CurrentMenu.filterItems[VUI_CurrentMenu.index])
        else
            VUI_CurrentMenu._idxChangeFn(VUI_CurrentMenu.index, VUI_CurrentMenu.items[VUI_CurrentMenu.index])
        end
    end
    cb()
end)

local focusState = false
RegisterNUICallback('vui:menu:focus', function(data, cb)
    if not VUI_CurrentMenu then return end
    focusState = data.focus
    if focusState then
        SetNuiFocus(true, false)
    else
        SetNuiFocus(false, false)
    end
    cb()
end)

RegisterNUICallback('vui:menu:back', function(data, cb)
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
    cb()
end)

RegisterNUICallback("vui:menu:filteritems", function(data, cb)
    if VUI_CurrentMenu then
        VUI_CurrentMenu._isFiltered = true
        VUI_CurrentMenu.index = 1
        VUI_CurrentMenu.filterItems = {}
        for _, item in ipairs(VUI_CurrentMenu.items) do
            for _, _item in ipairs(data.items) do
                if item.type == _item.type and item.props.title == _item.props.title and item.props.subtitle == _item.props.subtitle then
                    table.insert(VUI_CurrentMenu.filterItems, item)
                end
            end
        end
    end
    cb()
end)

RegisterNUICallback("vui:menu:unfilteritems", function(data, cb)
    print("Received unfiltered items from NUI")
    if VUI_CurrentMenu then
        VUI_CurrentMenu._isFiltered = false
        VUI_CurrentMenu.filterItems = {}
    end
    cb()
end)