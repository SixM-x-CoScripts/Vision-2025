local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local CurrentFiltre = nil

function renderManagementPlayers()
    vAdminManagementPlayers.Button(
        "Liste",
        "des bans",
        nil,
        "chevron",
        not vAdmin.bans,
        function()
            TriggerServerEvent("core:ban:getbans", token)
        end,
        vAdminManagementPlayersBans
    )
end

function renderManagementPlayersBans()
    print(json.encode(vAdmin.bans))

    if CurrentFiltre == nil then
        vAdminManagementPlayersBans.Button(
            "Rechercher",
            "un bannissement",
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil
                local SearchInput = KeyboardImput("Rechercher un bannissement")
                SearchInput = tostring(SearchInput)

                if SearchInput ~= nil and string.len(SearchInput) ~= 0 and type(SearchInput) == "string" then
                    CurrentFiltre = SearchInput

                    vAdminManagementPlayersBans.refresh()
                end

            end
        )
    else
        vAdminManagementPlayersBans.Button(
            CurrentFiltre,
            nil,
            nil,
            "search",
            false,
            function()
                CurrentFiltre = nil

                vAdminManagementPlayersBans.refresh()
            end
        )
    end

    for k, v in pairs(vAdmin.bans) do

        if CurrentFiltre ~= nil then
            if v.id == CurrentFiltre or
                string.find(string.lower(v.raison), string.lower(CurrentFiltre)) ~= nil or
                string.find(string.lower(v.by), string.lower(CurrentFiltre)) ~= nil then

                vAdminManagementPlayersBans.Button(
                    "Ban ID",
                    v.id,
                    v.by,
                    nil,
                    false,
                    function()
                        local confirmation = ChoiceInput("Voulez-vous vraiment supprimer ce bannissement ?")

                        if confirmation == true then
                            TriggerServerEvent("core:ban:unbanplayer", token, v.id)
                            TriggerServerEvent("core:ban:getbans", token)

                            -- manually remove ban from table until server send new ban list
                            for i, ban in pairs(vAdmin.bans) do
                                if ban.id == v.id then
                                    table.remove(vAdmin.bans, i)
                                end
                            end

                            vAdminManagementPlayersBans.refresh()
                        end
                    end
                )
            end
        else
            vAdminManagementPlayersBans.Button(
                "Ban ID",
                v.id,
                v.by,
                nil,
                false,
                function()
                    local confirmation = ChoiceInput("Voulez-vous vraiment supprimer ce bannissement ?")

                    if confirmation == true then
                        TriggerServerEvent("core:ban:unbanplayer", token, v.id)
                        TriggerServerEvent("core:ban:getbans", token)

                        -- manually remove ban from table until server send new ban list
                        for i, ban in pairs(vAdmin.bans) do
                            if ban.id == v.id then
                                table.remove(vAdmin.bans, i)
                            end
                        end

                        vAdminManagementPlayersBans.refresh()
                    end
                end
            )
        end

    end
end