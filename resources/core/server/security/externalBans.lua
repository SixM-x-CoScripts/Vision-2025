local AntiSpam = {}

function SunWiseKick(src, reason)
    local ply = GetPlayer(src)
    local shoundsend = true
    if ply then 
        if ply:getPermission() > 1 then 
            shoundsend = false
        end
    end
    if shoundsend then
        -- soon exports
        if not AntiSpam[src] then 
            AntiSpam[src] = 1
        end
        AntiSpam[src] += 1
        if AntiSpam[src] < 10 then
            SendToDiscIGAC(src, reason, true, "https://discord.com/api/webhooks/1138607188265418814/2RqftobRB8K_z2miaJPbaARA8RGKcsVRiY7uzhzLaxYpE9ilPdhkDrG48rQ7ChMjcD4X")
        end
    end
end