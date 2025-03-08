Modules.Sheets = {}
Modules.Sheets.list = {}


function Modules.Sheets.AddNew(dict, name, min, max)
    table.insert(Modules.Sheets.list, {
        name = name,
        min = min,
        max = max,
        dict = dict,
        actualLong = min,
    })
end
Modules.Sheets.AddNew("ui_loader_frames", "tiles_", 0, 13)
-- Modules.Sheets.AddNew("emblems", "ayhiz-whg3v_", 1, 16)
-- Modules.Sheets.AddNew("emblems", "dragoon_", 1, 16)
-- Modules.Sheets.AddNew("emblems", "plane_", 1, 12)
-- Modules.Sheets.AddNew("emblems", "elec_", 1, 12)
-- Modules.Sheets.AddNew("emblems", "shoot_", 1, 14)
-- Modules.Sheets.AddNew("emblems", "nuke_", 1, 15)
-- Modules.Sheets.AddNew("emblems", "prestige_max_", 1, 16)
-- Modules.Sheets.AddNew("emblems", "tron_event_", 1, 16)

function Modules.Sheets.IsSpriteAnimated(dict, name)
    for i, sheet in pairs(Modules.Sheets.list) do
        if sheet.dict == dict and sheet.name == name then
            return true
        end
    end
    return false
end

function Modules.Sheets.GetActualFrame(dict, name)
    for i, v in pairs(Modules.Sheets.list) do
        if v.dict == dict and v.name == name then
            return v.actualLong
        end
    end
    return nil
end



function Modules.Sheets.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        if cb ~= nil then
            cb(function(stop)
                if stop then
                    timer = 0
                    return
                end
            end)
        end
        Wait(0)
    end
end


Citizen.CreateThread(function()
    while true do

        for k,v in pairs(Modules.Sheets.list) do
            if v.actualLong < v.max then
                v.actualLong = v.actualLong + 1
                if v.actualLong > v.max then
                    v.actualLong = v.max
                end
            else
                v.actualLong = v.min
            end
        end


        Modules.Sheets.RealWait(70)
    end
end)
