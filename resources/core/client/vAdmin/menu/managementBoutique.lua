local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function renderManagementBoutique()
    vAdminManagementBoutique.Title("Premium")
    vAdminManagementBoutique.List(
        "Give",
        "Premium",
        false,
        {"1 mois", "3 mois", "6 mois", "1 an"},
        0,
        function(index, item)
            local idBoutique = KeyboardImput("ID Boutique")

            if idBoutique ~= nil then

                local time = 0
                if item == "1 mois" then
                    time = 30
                elseif item == "3 mois" then
                    time = 90
                elseif item == "6 mois" then
                    time = 180
                elseif item == "1 an" then
                    time = 365
                end

                ExecuteCommand("givepremium " .. idBoutique .. " " .. time)
            end
        end
    )
    vAdminManagementBoutique.Button(
        "Remove",
        "Premium",
        nil,
        "chevron",
        false,
        function()
            local idBoutique = KeyboardImput("ID Boutique")

            if idBoutique ~= nil then
                ExecuteCommand("removepremium " .. idBoutique)
            end
        end
    )

    vAdminManagementBoutique.Title("V Coins")
    vAdminManagementBoutique.Button(
        "Give",
        "V Coins",
        nil,
        "chevron",
        false,
        function()
            local idBoutique = KeyboardImput("ID Boutique")

            if idBoutique ~= nil then
                local amount = KeyboardImput("Amount")

                if amount ~= nil then
                    ExecuteCommand("giveidboutique " .. idBoutique .. " " .. amount)
                end
            end
        end
    )
    vAdminManagementBoutique.Button(
        "Remove",
        "V Coins",
        nil,
        "chevron",
        false,
        function()
            local idBoutique = KeyboardImput("ID Boutique")

            if idBoutique ~= nil then
                local amount = KeyboardImput("Amount")

                if amount ~= nil then
                    ExecuteCommand("removeidboutique " .. idBoutique .. " " .. amount)
                end
            end
        end
    )
    vAdminManagementBoutique.Button(
        "Set",
        "V Coins",
        nil,
        "chevron",
        false,
        function()
            local idBoutique = KeyboardImput("ID Boutique")

            if idBoutique ~= nil then
                local amount = KeyboardImput("Amount")

                if amount ~= nil then
                    ExecuteCommand("setidboutique " .. idBoutique .. " " .. amount)
                end
            end
        end
    )

    vAdminManagementBoutique.Title("Véhicule Premium")
    vAdminManagementBoutique.Button(
        "Give",
        "Véhicule Premium",
        nil,
        "chevron",
        true,
        function()end
    )
    vAdminManagementBoutique.Button(
        "Remove",
        "Véhicule Premium",
        nil,
        "chevron",
        true,
        function()end
    )
end