local GUIZMO_MODULE <const> = exports.deco:DecoModule()
local RPEMOTES <const> = exports["rpemotes"]

local function MoovePlayerGuizmo()
	DecoModule.Cancel()
    local PED <const> = PlayerPedId()
    local dict, anim = RPEMOTES:GetPedAnimation()
    if (dict and anim) and IsEntityPlayingAnim(PED, dict, anim, 3) then
        local clonedPed = ClonePed(PED, 1, false, false)
        print("PED, Model:", PED, GetEntityModel(PED))
        -- Cloneped de base mais pour test PlayerPedId 
        DecoModule.Use(PlayerPedId(), "PlayerPedId()") -- POURQUOI CA NE FONCTIONNE PAS ?
        SetEntityNoCollisionEntity(PED, clonedPed, false)
        SetEntityCoords(clonedPed, GetEntityCoords(PED))
        SetEntityHeading(clonedPed, GetEntityHeading(PED))
        TaskPlayAnim(clonedPed, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
        while true do 
            Wait(1)
            SetEntityLocallyInvisible(PED)
            if IsControlJustPressed(0, 191) then 
                SetEntityLocallyInvisible(clonedPed)
                SetEntityCoords(PED, GetEntityCoords(clonedPed))
                TaskPlayAnim(PED, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
                DeleteEntity(clonedPed)
                SetEntityLocallyVisible(PED)
                DecoModule.Cancel()
                break
            end
        end
    else
        print("Vous n'êtes pas en train de jouer une animation", dict, anim)
    end
end

RegisterCommand("moove", function()
    MoovePlayerGuizmo()
end)