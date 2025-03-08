local MenuForVeh = {
    [1131912276] = { 
        {
            icon = "ramasser",
            label = "Prendre le vélo",
            action = "TaskTakeBike"
        } },
    [1127861609] = { 
        {
            icon = "ramasser",
            label = "Prendre le vélo",
            action = "TaskTakeBike"
        } },
    [joaat("surfboard")] = { 
        {
            icon = "ramasser",
            label = "Prendre la planche",
            action = "TakeSurfBeach"
        } },
    [joaat("fixter")] = { 
        {
            icon = "ramasser",
            label = "Prendre le vélo",
            action = "TaskTakeBike"
        } },
    [joaat("cruiser")] = { 
        {
            icon = "ramasser",
            label = "Prendre le vélo",
            action = "TaskTakeBike"
        } },
    [joaat("scorcher")] = { 
        {
            icon = "ramasser",
            label = "Prendre le vélo",
            action = "TaskTakeBike"
        } },
    [joaat("iak_wheelchair")] = { 
        {
            icon = "ramasser",
            label = "Prendre la chaise roulante",
            action = "TaskTakeWheel"
        } },
    [joaat("tribike2")] = { 
        {
            icon = "ramasser",
            label = "Prendre le vélo",
            action = "TaskTakeBike"
        } }
}

function GetContextActionForVeh(model)
    if MenuForVeh[model] ~= nil then
        return MenuForVeh[model]
    else
        return {}
    end
end

function GetContextActionForVehV2(entity, entityModel)
    if MenuForVeh[entityModel] ~= nil then
        local actions = {}

        for i, action in ipairs(MenuForVeh[entityModel]) do
            table.insert(actions, {
                0,
                action.label,
                function() _G[action.action](entity) end
            })
        end

        return actions
    else
        return {}
    end
end