local CTXM = exports["ContextMenu"]

local weathers = {
    "Clear",
    "Extrasunny",
    "Clouds",
    "Overcast",
    "Rain",
    "Clearing",
    "Thunder",
    "Smog",
    "Foggy",
    "Xmas",
    "Snowlight",
    "Blizzard"
}

local times = {
    { "Morning", 8 },
    { "Afternoon", 12 },
    { "Evening", 18 },
    { "Night", 22 },
}

function getServerActions(token, hitEntity)
    if p:getPermission() >= 6 then
        local submenuServer = CTXM:AddSubmenu(0, "Gestion Serveur")

        -- Change weather
        local submenuWeather = CTXM:AddSubmenu(submenuServer, "Changement de météo")
        for i = 1, #weathers, 1 do
            local itemWeather = CTXM:AddItem(submenuWeather, weathers[i])
            CTXM:OnActivate(itemWeather, function()
                ExecuteCommand("weather " .. weathers[i])
            end)
        end

        -- Change time
        local submenuTime = CTXM:AddSubmenu(submenuServer, "Changement de temps")
        for i = 1, #times, 1 do
            local itemTime = CTXM:AddItem(submenuTime, times[i][1])
            CTXM:OnActivate(itemTime, function()
                ExecuteCommand("time " .. times[i][2].. " 00")
            end)
        end
    end
end