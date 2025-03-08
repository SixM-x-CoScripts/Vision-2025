WATCHERS.Hitch = {}
WATCHERS.Hitch.HitchsPerMinutes = 0
WATCHERS.Hitch.Timer = 0
WATCHERS.Hitch.List = {}

Citizen.CreateThread(function()
    Wait(20*1000) -- Wait 20s before starting to count hitchs as server start can generate hitch that are not relevant to catch
    while true do
        local time = GetGameTimer()
        WATCHERS.Hitch.Timer = GetGameTimer()
        Wait(200)
        local result = (GetGameTimer() - time)
        if result > 250 then
            Trace.Warning("Hitch time catched: Last heartbeat from Watchers -> " .. result .. "ms")
            table.insert(WATCHERS.Hitch.List, {
                time = GetGameTimer(),
                hitch = result - 200,
            })
        else
            table.insert(WATCHERS.Hitch.List, {
                time = GetGameTimer(),
                hitch = result - 200,
            })
        end
    end
end)




Citizen.CreateThread(function()
    while true do
        -- Clear hitch after 60s
        local newHitch = 0
        for k,v in pairs(WATCHERS.Hitch.List) do
            if GetGameTimer() - v.time > 60 * 1000 then
                --print("Removing hitch: " .. v.hitch .. "ms")
                table.remove(WATCHERS.Hitch.List, k)
            else
                newHitch = newHitch + v.hitch
            end
        end

        WATCHERS.Hitch.HitchsPerMinutes = newHitch
        Wait(2500)
    end
end)