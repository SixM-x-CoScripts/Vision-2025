-- local proximity = plyState.proximity
-- print(proximity.index) -- prints the index of the proximity as seen in Cfg.voiceModes
-- print(proximity.distance) -- prints the distance of the proximity
-- print(proximity.mode) -- prints the mode name of the proximity

local token = nil
--      {1.5, "Whisper"}, -- Whisper speech distance in gta distance units
-- 		{5.0, "Normal"}, -- Normal speech distance in gta distance units
-- 		{12.0, "Shouting"} -- Shou
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


-- RegisterCommand('vocal', function()
--     state = TriggerServerCallback('core:GetStateMicrophone', token)
--     Modules.UI.SetPageActive("ui_vocal")
-- end)

StateTalking = 2
function Modules.UI.DisplayVocal()
    if StateTalking == 2 then
        local w, h = Modules.UI.ConvertToPixel(50, 50)
        Modules.UI.DrawSpriteNew("vocal", "unknown", 0.158, 0.925, w, h, 0, 255, 255
            ,
            255, 150, {
                NoHover = true,
                CustomHoverTexture = false,
                NoSelect = true,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then
            end
        end)
    elseif StateTalking == 1 then
        local w, h = Modules.UI.ConvertToPixel(50, 50)
        Modules.UI.DrawSpriteNew("vocal", "voc_green", 0.158, 0.925, w, h, 0, 255, 255
            ,
            255, 150, {
                NoHover = true,
                CustomHoverTexture = false,
                NoSelect = true,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then
            end
        end)
    elseif StateTalking == 3 then
        local w, h = Modules.UI.ConvertToPixel(50, 50)
        Modules.UI.DrawSpriteNew("vocal", "voc_red", 0.158, 0.925, w, h, 0, 255, 255
            ,
            255, 150, {
                NoHover = true,
                CustomHoverTexture = false,
                NoSelect = true,
                devmod = false
            }, function(onSelected, onHovered)
            if onSelected then
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(250)
        if MumbleIsPlayerTalking(PlayerId()) == 1 then
            Modules.UI.SetPageActive("ui_vocal")
        else
            Modules.UI.SetPageInactive("ui_vocal")
        end
    end
end)

function GetProximity(modee)
    StateTalking = modee
end

exports("GetProximity", GetProximity)