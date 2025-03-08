local function UpdatePosition(source, pos)
    local player = GetPlayer(source)
    if not player then return end

    player:setPos(pos)
    MarkPlayerPosAsNonSaved(source)
end


RegisterNetEvent("core:UpdatePlayerPosition")
AddEventHandler("core:UpdatePlayerPosition", function(pos)
    UpdatePosition(source, pos)
end)