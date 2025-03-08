IsInMissionIll = false

RegisterNetEvent("core:taggedMot", function(mot)
    if IsInMissionIll then 
        if IsInMissionIll.missiontype and string.lower(IsInMissionIll.missiontype) == "tag" then 
            local pos = GetEntityCoords(PlayerPedId())
            
        end
    end
end)