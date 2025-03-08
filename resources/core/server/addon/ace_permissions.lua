RegisterNetEvent("core:playerLoaded", function(ply)
    local source = ply
    local ply = GetPlayer(ply)
    if ply:getSubscription() >= 1 then 
        --ExecuteCommand("add_principal identifier."..ply:getLicense().." group.sub")
    end
    if ply:getPermission() >= 3 and ply:getPermission() < 5 then 
        --ExecuteCommand("add_principal identifier."..ply:getLicense().." group.moderator")
    end
    if ply:getPermission() >= 5 then 
        --ExecuteCommand("add_principal identifier."..ply:getLicense().." group.admin")
        --ExecuteCommand("add_principal identifier."..ply:getLicense().." group.sub")
    end

    ply:setFiveMID(GetIDFiveM(source))

    ply:setDiscord(GetDiscord(source))


    -- print("FiveM ID " .. ply:getFiveMID() .. " Discord : " .. ply:getDiscord())

    SetPlayerCullingRadius(ply, 350)
end)