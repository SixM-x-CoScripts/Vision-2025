function cleanPlayer()
    ClearPedDecorations(p:ped())
    if tattoosByed then
        for i = 1, #tattoosByed, 1 do
            if tattoosByed[i] ~= nil then
                AddPedDecorationFromHashes(p:ped(), GetHashKey(tattoosByed[i].Collection),
                    GetHashKey(tattoosByed[i].HashName))
            end
        end
    end
    -- TriggerEvent('rcore_tattoos:applyOwnedTattoos')

    if GradenderByed then
        if GradenderByed.HashName ~= nil then
            AddPedDecorationFromHashes(p:ped(), GetHashKey(GradenderByed.Collection),
                GetHashKey(GradenderByed.HashName))
        end
    end
end

exports("cleanPlayer", function()
	return cleanPlayer()
end)
