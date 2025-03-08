VUI_CurrentMenu = nil

local function AddItem(t, item, index)
    
    if not index then
        index = #t + 1
    end

    item.Update = function(props)

        for k, v in pairs(props) do
            item.props[k] = v
        end

        SendNUIMessage({
            action = "vui:menu:update",
            data = {
                index = index - 1,
                item = {
                    type = item.type,
                    props = item.props
                }
            }
        })
    end

    table.insert(t, index, item)

    return item
end

function CreateMenu(title, banner, autoRefresh)
    local menu = {}
    local crtIdx = 1
    menu.title = title
    menu.banner = banner
    menu.index = 1
    menu.opened = false
    menu.items = {}
    menu.filterItems = {}
    menu.autoRefresh = autoRefresh or false
    menu._isFiltered = false
    menu._idxChangeFn = nil
    menu._closeFn = nil
    menu._openFn = nil
    menu._helpButtons = {}

    menu.ClearItems = function()
        menu.items = {}
        menu.filterItems = {}
        menu._isFiltered = false
        menu.index = 1
    end
    menu.OnIndexChange = function(fn)
        menu._idxChangeFn = fn
    end
    menu.OnClose = function(fn)
        menu._closeFn = fn
    end
    menu.OnOpen = function(fn)
        menu._openFn = fn
    end
    menu.AddHelpButton = function(key, text)
        menu._helpButtons[key] = text
    end
    menu.Footer = function(content, index)
        SendNUIMessage({
            action = "vui:menu:footer",
            data = {
                content = content,
                index = index
            }
        }, index)
    end
    menu.ReportPreview = function(reportId, reportTime, reportMsg, index)
        SendNUIMessage({
            action = "vui:menu:reportPreview",
            data = {
                reportId = reportId,
                reportTime = reportTime,
                reportMsg = reportMsg,
                index = index
            }
        }, index)
    end
    menu.CloseReportPreview = function(index)
        SendNUIMessage({
            action = "vui:menu:closeReportPreview",
            data = {
                index = index
            }
        }, index)
    end

    menu.ChangeBanner = function(banner)
        menu.banner = banner
    end

    menu.BanPreview = function(banId, banRaison, banAt, banExpiration, banIdentifiers, index)
        SendNUIMessage({
            action = "vui:menu:banPreview",
            data = {
                banId = banId,
                banRaison = banRaison,
                banAt = banAt,
                banExpiration = banExpiration,
                banIdentifiers = banIdentifiers,
            }
        }, index)
    end
    menu.CloseBanPreview = function(index)
        SendNUIMessage({
            action = "vui:menu:closeBanPreview",
            data = {
                index = index
            }
        }, index)
    end

    menu.WarnPreview = function(warnId, warnRaison, warnAt, warnBy, warnLicense, warnDiscord, index)
        SendNUIMessage({
            action = "vui:menu:warnPreview",
            data = {
                warnId = warnId,
                warnAt = warnAt,
                warnReason = warnRaison,
                warnBy = warnBy,
                warnLicense = warnLicense,
                warnDiscord = warnDiscord
            }
        }, index)
    end
    menu.CloseWarnPreview = function(index)
        SendNUIMessage({
            action = "vui:menu:closeWarnPreview",
            data = {
                index = index
            }
        }, index)
    end

    menu.Button = function(title, subtitle, rightLabel, icon, disabled, callback, submenu, index)
        return AddItem(menu.items, {
            type = "button",
            callback = callback,
            submenu = submenu,
            props = {
                title = title,
                subtitle = subtitle,
                rightLabel = rightLabel,
                icon = icon,
                disabled = disabled
            },
        }, index)
    end

    menu.UnSearchableButton = function(title, subtitle, rightLabel, icon, disabled, callback, submenu, index)
        return AddItem(menu.items, {
            type = "unsearchableButton",
            callback = callback,
            submenu = submenu,
            props = {
                title = title,
                subtitle = subtitle,
                rightLabel = rightLabel,
                icon = icon,
                disabled = disabled
            },
        }, index)
    end

    menu.ImageButton = function(title, image, disabled, callback, submenu, index)
        return AddItem(menu.items, {
            type = "imagebutton",
            callback = callback,
            submenu = submenu,
            props = {
                title = title,
                image = image,
                disabled = disabled
            },
        }, index)
    end

    menu.SearchInput = function(title, disabled, index)
        return AddItem(menu.items, {
            type = "searchinput",
            props = {
                title = title,
                disabled = disabled
            },
        }, index)
    end

    menu.Checkbox = function(title, subtitle, disabled, checked, callback, index)
        return AddItem(menu.items, {
            type = "checkbox",
            callback = callback,
            props = {
                title = title,
                subtitle = subtitle,
                disabled = disabled,
                checked = checked
            },
        }, index)
    end

    menu.List = function(title, subtitle, disabled, items, index, callback, submenu, _idx)
        return AddItem(menu.items, {
            type = "list",
            callback = callback,
            submenu = submenu,
            props = {
                title = title,
                subtitle = subtitle,
                disabled = disabled,
                items = items,
                index = index
            },
        }, _idx)
    end

    menu.Separator = function(leftLabel, leftValue, rightLabel, rightValue, index)
        return AddItem(menu.items, {
            type = "separator",
            props = {
                leftLabel = leftLabel,
                leftValue = leftValue,
                rightLabel = rightLabel,
                rightValue = rightValue,
                disabled = true,
            },
        }, index)
    end

    menu.Textbox = function(content, title, index)
        return AddItem(menu.items, {
            type = "textbox",
            props = {
                content = content,
                title = title,
                disabled = true,
            },
        }, index)
    end

    menu.Imagebox = function(image1, image2, index)
        return AddItem(menu.items, {
            type = "imagebox",
            props = {
                image1 = image1,
                image2 = image2,
                disabled = true,
            },
        }, index)
    end

    menu.Title = function(leftLabel, leftValue, rightLabel, rightValue, index)
        return AddItem(menu.items, {
            type = "title",
            props = {
                leftLabel = leftLabel,
                leftValue = leftValue,
                rightLabel = rightLabel,
                rightValue = rightValue,
                disabled = true,
            },
        }, index)
    end

    menu.Get = function(key)
        -- if key is a number, return the item at that index
        if type(key) == "number" then
            return menu.items[key]
        end
        -- if key is a string, return the first item with that title
        if type(key) == "string" then
            for _, item in ipairs(menu.items) do
                if item.props.title == key then
                    return item
                end
            end
        end
    end

    menu.open = function()
        if VUI_CurrentMenu and VUI_CurrentMenu.opened then
            VUI_CurrentMenu.close()
        end
        VUI_CurrentMenu = menu
        VUI_CurrentMenu.opened = true

        if menu._openFn then
            menu._openFn()
        end

        local _items = {}
        for _, item in ipairs(menu.items) do
            table.insert(_items, {
                type = item.type,
                props = item.props
            })
        end

        SendNUIMessage({
            action = "vui:menu",
            data = {
                title = menu.title,
                banner = menu.banner,
                index = menu.index - 1,
                helpButtons = menu._helpButtons,
                items = _items
            }
        })
    end

    menu.close = function()
        SendNUIMessage({
            action = "vui:menu:close"
        })
        menu.opened = false
        if menu._closeFn then
            menu._closeFn()
        end

        if menu.autoRefresh then
            menu.ClearItems()
        end

        VUI_CurrentMenu = nil
    end

    menu.refresh = function()
        crtIdx = menu.index
        menu.close()
        menu.index = crtIdx
        menu.open()
    end

    menu.toggle = function()
        if menu.opened then
            menu.close()
        else
            menu.open()
        end
    end

    menu.isFiltered = function()
        return menu._isFiltered
    end

    menu.filter = function(filter)
        menu._isFiltered = true
        menu.index = 1
        menu.filterItems = {}
        local _items = {}
        for _, item in ipairs(menu.items) do
            if filter(item) then
                table.insert(_items, {
                    type = item.type,
                    props = item.props
                })
                table.insert(menu.filterItems, item)
            end
        end
        -- Re open the menu with the filtered items
        SendNUIMessage({
            action = "vui:menu",
            data = {
                title = menu.title,
                banner = menu.banner,
                index = menu.index - 1,
                items = _items
            }
        })
    end

    menu.removeFilter = function()
        menu._isFiltered = false
        menu.filterItems = {}
        local _items = {}
        for _, item in ipairs(menu.items) do
            table.insert(_items, {
                type = item.type,
                props = item.props
            })
        end
        SendNUIMessage({
            action = "vui:menu",
            data = {
                title = menu.title,
                banner = menu.banner,
                index = menu.index - 1,
                items = _items
            }
        })
    end

    return menu
end

function CreateSubMenu(parent, title, banner, autoRefresh)
    local menu = CreateMenu(title, banner, autoRefresh)
    menu.parent = parent
    return menu
end

function ToggleStaffAlert(name, permission, message)
    SendNUIMessage({
        action = "vui:staffAlert",
        data = {
            name = name,
            permission = permission,
            message = message
        }
    })
end

exports("CreateMenu", CreateMenu)
exports("CreateSubMenu", CreateSubMenu)
exports("ToggleStaffAlert", ToggleStaffAlert)