staff_menu = {
    {
        label = "Action sur joueur",
        menu = {},
        customData = false,
        data = {
            {
                permission = 2,
                label = "TP Sur point GPS",
                action = function()
                    GotoMarker()
                end
            },
            {
                permission = 2,
                label = "Activer / Désactiver le no clip",
                action = function()
                    ToogleNoClip()
                end
            },
            {
                permission = 2,
                label = "Activer / Désactiver les blips joueurs",
                action = function()
                    DisplayPlayersBlips()
                end
            }
        }
    },
    {
        label = "Véhicule",
        menu = {},
        customData = false,
        data = {
            {
                permission = 2,
                label = "Spawn un véhicule",
                action = function()
                    local vehName = KeyboardImput("Nom de spawn du véhicule")
                    if vehName ~= nil then
                        SpawnCar(vehName)
                    end
                end
            }
        }
    },
    {
        label = "Jobs",
        menu = {},
        customData = true,
    },
}
