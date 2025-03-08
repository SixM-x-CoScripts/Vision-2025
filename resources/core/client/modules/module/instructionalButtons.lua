function createVariableWatcher(table, callback)
    local proxy = {}
    local mt = {
        __index = table,
        __newindex = function(t, key, value)
            local oldValue = table[key]
            table[key] = value
            if json.encode(oldValue) ~= json.encode(value) then
                callback(key, oldValue, value)
            end
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

function generateUniqueID(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local length = tonumber(length) or 6
    local id = ''

    for i = 1, length do
        local randomIndex = math.random(#chars)
        id = id .. chars:sub(randomIndex, randomIndex)
    end

    return id
end

local parametersButtons = {
    hide = false
}

local function updateInstructionalButtons(buttons)
    if parametersButtons.hide then
        buttons = {}
    end

    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "TOGGLE_MOUSE_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "CREATE_CONTAINER")
    EndScaleformMovieMethod()

    for i, button in ipairs(buttons) do
        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(i)
        ScaleformMovieMethodAddParamTextureNameString(GetControlInstructionalButton(2, button.control, true))
        ScaleformMovieMethodAddParamTextureNameString(button.label)
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(-1)
    EndScaleformMovieMethod()

    Citizen.CreateThread(function()
        while #buttons > 0 do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Citizen.Wait(5)
        end
    end)
end

local tableButtons = {}
instructionalButtons = createVariableWatcher(tableButtons, function(key, oldValue, newValue)
    local combinedButtons = {}

    for _, buttons in pairs(tableButtons) do
        for _, button in pairs(buttons) do
            table.insert(combinedButtons, button)
        end
    end

    updateInstructionalButtons(combinedButtons)
end)

parametersInstructionalButtons = createVariableWatcher(parametersButtons, function(key, oldValue, newValue)
    local combinedButtons = {}

    for _, buttons in pairs(tableButtons) do
        for _, button in pairs(buttons) do
            table.insert(combinedButtons, button)
        end
    end

    updateInstructionalButtons(combinedButtons)
end)

function CreateInstrucButtons()
    return instructionalButtons
end

exports('CreateInstrucButtons', CreateInstrucButtons)
exports('generateUniqueID', generateUniqueID)