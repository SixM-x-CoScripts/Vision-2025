local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function rendervAdminMainMenu()
    --  D'abord la checkbox
    vAdminMain.Checkbox("Mode Administration", nil, false, AdminInAction, function(_checked)
        updateAdminOverlay()
        AdminChecked = _checked;
        TriggerServerEvent("core:StaffInAction", token, AdminChecked)
        AdminInAction = _checked
        if not _checked then
            nbReport = nil

            if vAdminMods.playerNames then
                vAdminMods.playerNames = false
                UseBlipsName(false)
                DestroyPlayerNames()
            end
            DevPrint = false

            if vAdminMods.blips then
                vAdminMods.blips = false
                UseBlipsName(false)
                DestroyGamerTag()
            end

            TriggerServerEvent("core:staffActionLog", token, "Stop blips", "Soi-même")
        else
            CreateThread(function()
                while AdminInAction do
                    nbPlayers = GlobalState["nbJoueur"]
                    Wait(30000) 
                end
            end)

            vAdmin.isInDevMode = true
            
            DevPrint = true
            vAdmin.PrintPropsAndEntities = true

            vAdminMods.playerNames = true
            vAdminMods.blips = true
            TogglePlayerNames()
            ToggleGamerTag()

            TriggerServerEvent("core:staffActionLog", token, "Start blips", "Soi-même")
            UseBlipsName(true)
        end
        vAdminAdminData.showAllPlayers = false

        vAdminMain.refresh()
    end)

    -- Ensuite les autres boutons si AdminInAction
    if AdminInAction then 
        vAdminMain.Separator(nil)
        
        vAdminMain.Button(
            "Liste des Reports",
            nil,
            nil,
            "chevron",
            false,
            function()end,
            vAdminReports
        )
        vAdminMain.Button(
            "Liste des Joueurs",
            nil,
            nil,
            "chevron",
            false,
            function()end,
            vAdminPlayers
        )
        vAdminMain.Button(
            "Liste des Modérateurs & Staff",
            nil,
            nil,
            "chevron",
            p:getPermission() <= 4,
            function()end,
            vAdminModerators
        )
        vAdminMain.Button(
            "Outils de Modération",
            nil,
            nil,
            "chevron",
            false,
            function()
                if inNoClip then
                    vAdminMods.noclip = true
                end
                if IsEntityVisible(p:ped()) then
                    vAdminMods.invisible = false
                else
                    vAdminMods.invisible = true
                end
            end,
            vAdminModerationTools
        )
        vAdminMain.Button(
            "Outils de Développement",
            nil,
            nil,
            "chevron",
            p:getPermission() <= 1,
            function()end,
            vAdminDeveloperTools
        )
        vAdminMain.Button(
            "Gestion Serveur", 
            nil, 
            nil, 
            "chevron", 
            p:getPermission() <= 2,
            function()end, 
            vAdminServerManagement
        )
        -- if p:getPermission() == 69 then
        --     vAdminMain.Button(
        --         "Menu Troll", 
        --         nil, 
        --         nil, 
        --         "chevron", 
        --         p:getPermission() <= 68,
        --         function()end, 
        --         vAdminDeveloperToolTkt
        --     )
        -- end
    else
        vAdminMain.Textbox("L'utilisation des permissions est réservé exclusivement dans le cadre de la modération In Game. Une utilisation non autorisé entrainera un retrait des permissions de manière définitive.", "Attention!")
    end
end

function renderServerManagement()
    vAdminServerManagement.Button(
        "Gestion",
        "joueurs",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementPlayers
    )
    vAdminServerManagement.Button(
        "Gestion",
        "legal",
        nil,
        "chevron",
        p:getPermission() <= 4,
        function()end,
        vAdminManagementLegal
    )
    vAdminServerManagement.Button(
        "Gestion",
        "illégal",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementIllegal
    )
    vAdminServerManagement.Button(
        "Gestion",
        "Interface",
        nil,
        "chevron",
        false,
        function()end,
        vAdminManagementInterface
    )
    vAdminServerManagement.Button(
        "Gestion",
        "Permissions",
        nil,
        "lock",
        true,
        function()end,
        vAdminManagementPerms
    )
    vAdminServerManagement.Button(
        "Gestion",
        "Boutique",
        nil,
        "chevron",
        p:getPermission() <= 4,
        function()end,
        vAdminManagementBoutique
    )
end