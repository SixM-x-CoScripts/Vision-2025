function InitBlips()
    local blips = {} -- Useless pour l'instant
    local blips_configs = TriggerServerCallback("core:GetBlips")
    Citizen.CreateThread(function()
        for k, v in pairs(blips_configs) do
            AddBlip(vector3(v.pos.x, v.pos.y, v.pos.z), v.label, 4, 0.75, v.color, v.name)
        end
    end)

    function AddBlip(pos, sprite, display, scale, color, label)
        local blip = AddBlipForCoord(pos)
        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale(blip, scale)
        SetBlipColour(blip, color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(label)
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)

        return blip
    end
end

RegisterCommand("blipsInit", function()
    InitBlips()
end)
