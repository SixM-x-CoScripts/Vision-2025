CreateThread(function()
    -- Désactiver les tirs a l'ammunation
	ClearAmbientZoneState("collision_ybmrar", false)
	SetAmbientZoneState("collision_ybmrar", false, false)
end)