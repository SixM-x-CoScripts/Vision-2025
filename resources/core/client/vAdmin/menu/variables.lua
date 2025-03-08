local VUI = exports["VUI"]

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local function split(str, sep)
    local _sep = sep or ':'
    local _fields = {}
    local _pattern = string.format("([^%s]+)", _sep)
    str:gsub(_pattern, function(c) _fields[#_fields + 1] = c end)
    return _fields
end

local function UpdateVariable(_table, name, value)
    local levels = {}
    for level in name:gmatch("[^%.]+") do
      table.insert(levels, level)
    end

    local currentTable = _table
    for i = 1, #levels - 1 do
      local level = levels[i]
      if not currentTable[level] or type(currentTable[level]) ~= "table" then
        currentTable[level] = {}
      end
      currentTable = currentTable[level]
    end
    currentTable[levels[#levels]] = value
end

function renderManagementInterfaceVariable()

    vAdminManagementInterfaceVariable.Title(
        "Variable",
        "test"
    )

    for name, value in pairs(vAdminVariables) do
        vAdminManagementInterfaceVariableArray[name] = VUI:CreateSubMenu(vAdminManagementInterfaceVariable, name, "administration", true)
        print(vAdminManagementInterfaceVariableArray[name])
        vAdminManagementInterfaceVariableArray[name].OnOpen(function()
            print(vAdminManagementInterfaceVariableArray[name])
            renderManagementInterfaceVariableRecurve(value, name)
        end)
        vAdminManagementInterfaceVariable.Button(
            name,
            nil,
            nil,
            "chevron",
            false,
            function()
                print(name)
            end,
            vAdminManagementInterfaceVariableArray[name]
        )
    end
end

function renderManagementInterfaceVariableRecurve(table, prefix)
    local _value = ''
    local _name = ''
    for name, value in pairs(table) do
        if type(value) == 'table' and value.x == nil and value.y == nil and value.z == nil then
            vAdminManagementInterfaceVariableArray[prefix.. '.' .. name] = VUI:CreateSubMenu(vAdminManagementInterfaceVariableArray[prefix], name, "administration", true)
            vAdminManagementInterfaceVariableArray[prefix.. '.' .. name].OnOpen(function()
                print(vAdminManagementInterfaceVariableArray[prefix.. '.' .. name])
                renderManagementInterfaceVariableRecurve(value, prefix.. '.' .. name)
            end)
            vAdminManagementInterfaceVariableArray[prefix].Button(
                name,
                nil,
                nil,
                "chevron",
                false,
                function()
                    print(name)
                end,
                vAdminManagementInterfaceVariableArray[prefix.. '.' .. name]
            )
        else
            if type(value) == 'table' then
                _value = "🗺️"
            elseif type(value) == "string" and string.len(value) > 10 then
                _value = string.sub(value, 1, 10) .. '...'
            else
                if value == "true" then
                    _value = true
                elseif value == "false" then
                    _value = false
                else _value = value end
            end
            if prefix ~= nil then
                _name = prefix.. '.' ..name
            else
                _name = name
            end
            if type(_value) == "boolean" then
                vAdminManagementInterfaceVariableArray[prefix].Checkbox(
                    _name,
                    "",
                    false,
                    _value,
                    function(checked)
                        _value = checked
                        local varname = split(_name, '.')[1]
                        UpdateVariable(vAdminVariables, _name, checked)
                        TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                        vAdminManagementInterfaceVariableArray[prefix].refresh()
                    end
                )
            else
                vAdminManagementInterfaceVariableArray[prefix].Button(
                _name,
                "",
                _value,
                "chevron",
                false,
                function()
                    if type(value) == "table" then
                        local pos = p:pos()
                        local varname = split(_name, '.')[1]
                        UpdateVariable(vAdminVariables, _name, {
                            x = pos.x,
                            y = pos.y,
                            z = pos.z
                        })
                        TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                    else 
                        local _input = KeyboardImput('Redéfinir '.. _name)
                        if _input ~= nil or _input ~= "" then
                            local varname = split(_name, '.')[1]
                            UpdateVariable(vAdminVariables, _name, _input)
                            TriggerServerEvent("core:updateVariable", token, varname, vAdminVariables[varname])
                            _value = _input
                        end
                    end
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        content = "Vous avez redéfini la variable ~s~" .. _name
                    })
                    vAdminManagementInterfaceVariableArray[prefix].refresh()
                end
            )
            end
        end
    end
end