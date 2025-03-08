local ObjBoutique = {}

local PrixBoutique = {
    ["Premium"] = 2500/2,
}

local LostPremium = {}

function GetMyVCoins(src)
    local obj = GetPlayer(src)
    return obj:getBalance()
end

function RemoveCoins(src, coins)
    local obj = GetPlayer(src)
    return obj:setBalance(obj:getBalance() - coins)
end

function BoutiqueLogs(text, img, ping)
    local embed = {
        {
            ["author"] = {                
                ["name"] = "Boutique Absolute",
            },
            ["title"]= "Achat Boutique",
            ["type"]="rich",
            ["color"] = 14688650,
            ["description"] = text,
            ["footer"]=  {
                ["text"]= "Boutique Absolute",
            },
            ["image"] = {
                ["url"] = img,
            }
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/1209468325537644545/V34GMqB65IQorIaUOw8b9mW757N6tmVNNKlB520Lp1kg2pMItL2QYqa_Bk_fpPXK1sRm", function(err, text, headers) end, 'POST', json.encode({ username = "Boutique Absolute", content = ping and "@everyone" or "", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function SendBoutiquesInfo(text)
    
    local webhook = "https://discord.com/api/webhooks/1209468650306805780/lQ34MY2lkRNWD8EpzT4917nIgYblKsn_WdqQvM3-ltau-b785vsuVG5oFX22UCe99yBe"

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = "Boutique Absolute",  content = text}), { ['Content-Type'] = 'application/json' })
end

function BoutiqueLogsVCoins(text, img)
    local embed = {
        {
            ["author"] = {                
                ["name"] = "Boutique Absolute",
            },
            ["title"]= "Achat Boutique Tebex",
            ["type"]="rich",
            ["color"] = 14688650,
            ["description"] = text,
            ["footer"]=  {
                ["text"]= "Boutique Absolute",
            },
            ["image"] = {
                ["url"] = img,
            }
        }
    }
    local webhook = "https://discord.com/api/webhooks/1209468869518032967/NRDJvm0U9t0xPD-sjtn1xocTQtt5nKrKKIp1fg7WOwOgcfcSEfbExKQpWMluCZeeOBio"
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = "Boutique Absolute", embeds = embed}), { ['Content-Type'] = 'application/json' })
	--if img ~= nil then
    --    PerformHttpRequest(webhook, function(Error, Content, Head) end, 'POST', json.encode({username = "Boutique Absolute", content = "@everyone"}), { ['Content-Type'] = 'application/json' })
    --else
    --    PerformHttpRequest(webhook, function(Error, Content, Head) end, 'POST', json.encode({username = "Boutique Absolute", content = "Aucun PING car le give a été effectué par la console"}), { ['Content-Type'] = 'application/json' })
    --end
end

RegisterServerCallback("core:getUniqueID", function(source)
    local obj = GetPlayer(source)
    return obj:getUniqueId()
end)

RegisterCommand("uniqueIDDEV", function(source)
    if source == 0 then return end 
    local obj = GetPlayer(source)
    local license = GetPlayer(source):getLicense()
    local discord = GetDiscord(source)
    print("Votre Absolute ID est " .. VisionUniqueID(license, discord))
end)

local function GetDatasFromNumberofCoins(pts)
    local img = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/7d143782ef903a98873a58e52216a6ea8e1ba433.png" 
    if pts == 1000 then 
        return 10, "https://dunb17ur4ymx4.cloudfront.net/packages/images/4bb9738e8403c5f05d0e5470fc61ec05215eb5be.webp"
    elseif pts == 2500 then 
        return 25, "https://dunb17ur4ymx4.cloudfront.net/packages/images/ac78e2184356dc3ea38238a8d817c5d91d37ee36.webp"
    elseif pts == 3000 then 
        return 25, "https://dunb17ur4ymx4.cloudfront.net/packages/images/9f444058ab936229b49bd1df84baa8fbfc4cb747.webp"
    elseif pts == 4500 then 
        return 35, "https://dunb17ur4ymx4.cloudfront.net/packages/images/90b15e91aae02d1d824b20218815525c01977c72.webp"
    elseif pts == 5000 then 
        return 35, "https://dunb17ur4ymx4.cloudfront.net/packages/images/a628309995e8a8f8f54b6e6279ddd7cdeade1a6f.webp"
    elseif pts == 7000 then 
        return 50, "https://dunb17ur4ymx4.cloudfront.net/packages/images/8cc9659bab95bd968000ade73aab21e0daab6957.webp"
    elseif pts == 10000 then 
        return 50, "https://dunb17ur4ymx4.cloudfront.net/packages/images/9b94a60c044ae9088b20491ed8c4324af3cc9cd7.webp"
    elseif pts == 15000 then 
        return 100, "https://dunb17ur4ymx4.cloudfront.net/packages/images/20fbb840dbb019f399815d8845d236b4bc7f1b87.webp"
    elseif pts == 25000 then 
        return 100, "https://dunb17ur4ymx4.cloudfront.net/packages/images/e4e98211776231a08438ace68988cb3f4300242c.webp"
    elseif pts == 100000 then 
        return 300, "https://dunb17ur4ymx4.cloudfront.net/packages/images/c4bb0286a92c9d4518d4fad9d2a5f72b60323be1.webp"
    end
    return 0, img
end

function givepremium(source, id, callback)
    local time = os.time()
    local endDate = time + (30 * 86400)
    MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE id = @id', {
        ['@id'] = tonumber(id),
        ['@subscription'] = 1,
    }, function(rowsChange)
        CorePrint("Le joueur " .. tostring(id) .. " (ID UNIQUE) a achete l'abonnement premium sur la boutique.")
    end)
    local playerexist2 = GetPlayerByUniqueID(id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/33c9dff547c10dd1caa25a0386049288c5f43f87.webp"
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    --[[ if nameGive ~= "CONSOLE" then 
        img = nil
    end ]]
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement premium** pour l'ID BDD : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
        SendBoutiquesInfo(GetDiscord(playerexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
        playerexist:setSubscription(1)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjdqsd", playerexist2.source, playerexist:getBalance(), nbrJour)
        MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE id = @id', {
            ['@id'] = tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()
        end)
        if callback then callback(true) end
    else
        MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE id = @id', {
            ['@id'] = tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()

        end)

        MySQL.Async.fetchAll("SELECT fivem, discord, balance, subscription FROM players_unique WHERE id = @id", {
            ['@id'] = tonumber(id)
        }, function(data)
            if data ~= nil and data[1] ~= nil then
                local premiumstatus = "Non"
                if not data[1].subscription then data[1].subscription = 0 end
                if data[1] and data[1].subscription == 1 then
                    premiumstatus = "Oui"
                end
                
                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium** pour l'ID BDD : **" .. id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. data[1].fivem .."`\n- <:zerkay_identifier:975119837464526868>  Unique ID : `" .. id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
            
                for k, v in pairs(data) do
                    SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
                end
                if callback then callback(true) end
            else
                if callback then callback(false) end
            end
        end)
    end
end

RegisterCommand('givepremium', function(source, args) 
    local id    = tonumber(args[1])
    if source == 0 or HasPermission(source, 5) then 
        givepremium(source, id)
    end
end, false)

function fivemgivepremium(source, id, nbrJour, callback)
    local nbrJour = nbrJour and tonumber(nbrJour) or 30
    local time = os.time()
    local endDate = time + (nbrJour * 86400)
    MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE fivem = @fivem', {
        ['@fivem'] = "fivem:"..tonumber(id),
        ['@subscription'] = 1,
    }, function(rowsChange)
        CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a achete l'abonnement premium sur la boutique.")
    end)
    local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/33c9dff547c10dd1caa25a0386049288c5f43f87.webp"
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    --[[ if nameGive ~= "CONSOLE" then 
        img = nil
    end ]]
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium** pour l'ID BDD : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
        SendBoutiquesInfo(GetDiscord(playerexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
        playerexist:setSubscription(1)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjdqsd", playerexist2.source, playerexist:getBalance(), nbrJour)
        MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE fivem = @fivem', {
            ['@fivem'] = "fivem:"..tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()
        end)
        if callback then callback(true) end
    else
        MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE fivem = @fivem', {
            ['@fivem'] = "fivem:"..tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()

        end)


        MySQL.Async.fetchAll("SELECT id, discord, balance, subscription FROM players_unique WHERE fivem = @fivem", {
            ['@fivem'] = "fivem:"..tonumber(id)
        }, function(data)
            if data ~= nil and data[1] ~= nil then

                local premiumstatus = "Non"
                if not data[1].subscription then data[1].subscription = 0 end
                if data[1].subscription == 1 then
                    premiumstatus = "Oui"
                end
                
                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium** pour l'ID FiveM: **" .. id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:zerkay_identifier:975119837464526868>  Unique ID : `" .. data[1].id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)

                for k, v in pairs(data) do
                    SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
                end
                if callback then callback(true) end
            else
                if callback then callback(false) end
            end
        end)
    end
end

RegisterCommand('fivemgivepremium', function(source, args) 
    local id    = tonumber(args[1])
    local nbrJour = args[2] and tonumber(args[2]) or 30
    if source == 0 or HasPermission(source, 5) then 
        fivemgivepremium(source, id, nbrJour)
    end
end, false)


function removefivempremium(source, id, callback)
    MySQL.Async.execute('UPDATE players_unique SET subscription = 0, buyendDate = 0 WHERE fivem = @fivem', {
        ['@fivem'] = "fivem:"..tonumber(id)
    }, function(rowsChange)
        if rowsChange == 0 then
            print("Le joueur " .. tostring(id) .. " (ID FiveM) n'a pas d'abonnement premium.")
            if callback then callback(false) end
            return
        end
        print("Le joueur " .. tostring(id) .. " (ID FiveM) a perdu son abonnement premium.")
        if callback then callback(true) end
    end)

    local playerByUniqueId = GetPlayerByFiveMID('fivem:'..id)
    Wait(500)
    local player = playerByUniqueId == 0 and 0 or GetPlayer(playerByUniqueId.source)
    Wait(500)

    if player ~= 0 then
        player:setSubscription(0)
        player:setBuyendDate(0)
        Wait(200)
        TriggerClientEvent("odsfnbgdfngdfbgiudfsbgiurftdboh", playerByUniqueId.source)
    end
end

RegisterCommand("removefivempremium", function(source, args)
    local id = tonumber(args[1])

    if source == 0 or HasPermission(source, 5) then
        removefivempremium(source, id)
    end
end, false)

function removeboutiquepremium(source, id, callback)
    MySQL.Async.execute('UPDATE players_unique SET subscription = 0, buyendDate = 0 WHERE id = @id', {
        ['@id'] = tonumber(id)
    }, function(rowsChange)
        if rowsChange == 0 then
            print("Le joueur " .. tostring(id) .. " (ID Boutique) n'a pas d'abonnement premium.")
            if callback then callback(false) end
            return
        end
        print("Le joueur " .. tostring(id) .. " (ID Boutique) a perdu son abonnement premium.")
        if callback then callback(true) end
    end)

    local playerByUniqueId = GetPlayerByUniqueID(id)
    Wait(500)
    local player = playerByUniqueId == 0 and 0 or GetPlayer(playerByUniqueId.source)
    Wait(500)

    if player ~= 0 then
        player:setSubscription(0)
        player:setBuyendDate(0)
        Wait(200)
        TriggerClientEvent("odsfnbgdfngdfbgiudfsbgiurftdboh", playerByUniqueId.source)
    end
end

RegisterCommand("removeboutiquepremium", function(source, args)
    local id = tonumber(args[1])

    if source == 0 or HasPermission(source, 5) then
        removeboutiquepremium(source, id)
    end
end, false)

function fivemgivepremiumplus(source, id, nbrJour, callback)
    local nbrJour = nbrJour and tonumber(nbrJour) or 30
    local time = os.time()
    local endDate = time + (nbrJour * 86400)
    local point = 5000

    MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE fivem = @fivem', {
        ['@fivem'] = "fivem:"..tonumber(id),
        ['@subscription'] = 2,
    }, function(rowsChange)
        CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a achete l'abonnement premium+ sur la boutique.")
    end)

    MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE fivem = @fivem', {
        ['@fivem'] = "fivem:"..tonumber(id)
    }, function(data)
        if not data[1].balance then data[1].balance = 0 end
        local poi = data[1].balance
        npoint = tonumber(poi) + tonumber(point)

        MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE fivem = @fivem', {
            ['@fivem'] = "fivem:"..tonumber(id),
            ['@point'] = npoint
        }, function(rowsChange)
            CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a reçu " .. tostring(point) .. " points boutique avec son achat du Premium+. Il a desormais " .. npoint .. " points.")
        end)
    end)

    local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/d77a46c5a89598e1e5f2c8c25dd94256fdd5a16e.webp"
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    --[[ if nameGive ~= "CONSOLE" then 
        img = nil
    end ]]
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID FiveM : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
        SendBoutiquesInfo(GetDiscord(playerexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
        playerexist:setSubscription(2)
        playerexist:setBalance(playerexist:getBalance() + point)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "add")

        TriggerClientEvent("aeceoereasdqxdfgjdqsd", playerexist2.source, playerexist:getBalance(), nbrJour, 2)
        MySQL.Async.execute('UPDATE players_unique SET subscription = 2, buyendDate = @buyendDate WHERE fivem = @fivem', {
            ['@fivem'] = "fivem:"..tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()
        end)
        if callback then callback(true) end
    else           
        MySQL.Async.execute('UPDATE players_unique SET subscription = 2, buyendDate = @buyendDate WHERE fivem = @fivem', {
            ['@fivem'] = "fivem:"..tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()

        end)


        MySQL.Async.fetchAll("SELECT id, discord, balance, subscription FROM players_unique WHERE fivem = @fivem", {
            ['@fivem'] = "fivem:"..tonumber(id)
        }, function(data)
            if data ~= nil and data[1] ~= nil then
                
                local premiumstatus = "Non"
                if not data[1].subscription then data[1].subscription = 0 end
                if data[1].subscription == 2 then
                    premiumstatus = "Oui"
                end

                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID FiveM: **" .. id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:zerkay_identifier:975119837464526868>  Unique ID : `" .. data[1].id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n- <:Premium:1158022039580463146> Status Premium+ :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)

                for k, v in pairs(data) do
                    SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                end
                if callback then callback(true) end
            else
                if callback then callback(false) end
            end
        end) 
    end
end

RegisterCommand('fivemgivepremium+', function(source, args) 
    local id    = tonumber(args[1])
    local nbrJour = args[2] and tonumber(args[2]) or 30

    if source == 0 or HasPermission(source, 5) then 
        fivemgivepremiumplus(source, id, nbrJour)
    end
end, false)

function givepremiumplus(source, id, nbrJour, callback)
    local nbrJour = nbrJour and tonumber(nbrJour) or 30
    local time = os.time()
    local endDate = time + (nbrJour * 86400)
    local point = 5000

    MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE id = @id', {
        ['@id'] = tonumber(id),
        ['@subscription'] = 2,
    }, function(rowsChange)
        CorePrint("Le joueur " .. tostring(id) .. " (ID Boutique) a achete l'abonnement premium+ sur la boutique.")
    end)

    MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE id = @id', {
        ['@id'] = tonumber(id)
    }, function(data)
        if data == nil or data[1] == nil then

            if callback then callback(false) end
            return
        end
        if not data[1].balance then data[1].balance = 0 end
        local poi = data[1].balance
        npoint = tonumber(poi) + tonumber(point)

        MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE id = @id', {
            ['@id'] = tonumber(id),
            ['@point'] = npoint
        }, function(rowsChange)
            CorePrint("Le joueur " .. tostring(id) .. " (ID Boutique) a reçu " .. tostring(point) .. " points boutique avec son achat du Premium+. Il a desormais " .. npoint .. " points.")
        end)
    end)

    local playerexist2 = GetPlayerByUniqueID(id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/d77a46c5a89598e1e5f2c8c25dd94256fdd5a16e.webp"
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    --[[ if nameGive ~= "CONSOLE" then 
        img = nil
    end ]]
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID Boutique : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID Boutique : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
        SendBoutiquesInfo(GetDiscord(playerexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
        playerexist:setSubscription(2)
        playerexist:setBalance(playerexist:getBalance() + point)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "add")

        TriggerClientEvent("aeceoereasdqxdfgjdqsd", playerexist2.source, playerexist:getBalance(), nbrJour, 2)
        MySQL.Async.execute('UPDATE players_unique SET subscription = 2, buyendDate = @buyendDate WHERE id = @id', {
            ['@id'] = tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()
        end)
        if callback then callback(true) end
    else           
        MySQL.Async.execute('UPDATE players_unique SET subscription = 2, buyendDate = @buyendDate WHERE id = @id', {
            ['@id'] = tonumber(id),
            ['@buyendDate'] = endDate,
        }, function()

        end)


        MySQL.Async.fetchAll("SELECT fivem, discord, balance, subscription FROM players_unique WHERE id = @id", {
            ['@id'] = tonumber(id)
        }, function(data)
            if data ~= nil and data[1] ~= nil then
                
                local premiumstatus = "Non"
                if not data[1].subscription then data[1].subscription = 0 end
                if data[1].subscription == 2 then
                    premiumstatus = "Oui"
                end

                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID Boutique : **" .. id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID Unique : `".. id .."`\n- <:zerkay_identifier:975119837464526868>  FiveM ID : `" .. data[1].fivem .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n- <:Premium:1158022039580463146> Status Premium+ :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)

                for k, v in pairs(data) do
                    SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                end
                if callback then callback(true) end
            else
                if callback then callback(false) end
            end
        end) 
    end
end

RegisterCommand('givepremium+', function(source, args) 
    local id    = tonumber(args[1])
    local nbrJour = args[2] and tonumber(args[2]) or 30

    if source == 0 or HasPermission(source, 5) then 
        givepremiumplus(source, id, nbrJour)
    end
end, false)

function giveidboutique(source, id, point, callback)
    local npoint = nil
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE id = @id', {
        ['@id'] = tonumber(id)
    }, function(data)
        if data == nil or data[1] == nil then
            CorePrint("Le joueur " .. tostring(id) .. " (ID UNIQUE) n'existe pas.")
            if callback then callback(false) end
            return
        end
        if not data[1].balance then data[1].balance = 0 end
        local poi = data[1].balance
        npoint = tonumber(poi) + tonumber(point)

        MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE id = @id', {
            ['@id'] = tonumber(id),
            ['@point'] = npoint
        }, function(rowsChange)
            if rowsChange == 0 then
                CorePrint("Le joueur " .. tostring(id) .. " (ID UNIQUE) n'a pas de points boutique.")
                if callback then callback(false) end
                return
            end
            CorePrint("Le joueur " .. tostring(id) .. " (ID UNIQUE) a achete " .. tostring(point) .. " points boutique. Il a desormais " .. npoint .. " points. Give par : " .. (nameGive or "CONSOLE"))
            if callback then callback(true, npoint) end
        end)
    end)
    local playerexist2 = GetPlayerByUniqueID(id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local euros, img = GetDatasFromNumberofCoins(point)
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID BDD : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID Unique : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. playerexist:getBalance() + point .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
        playerexist:setBalance(playerexist:getBalance() + point)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "add")
    else

        MySQL.Async.fetchAll("SELECT fivem, discord, balance, subscription FROM players_unique WHERE id = @id", {
            ['@id'] = tonumber(id)
        }, function(data)
            if data ~= nil and data[1] ~= nil then
                
                local premiumstatus = "Non"
                if not data[1].subscription then data[1].subscription = 0 end
                if data[1].subscription == 1 then
                    premiumstatus = "Oui"
                end

                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. (point or '?') .. " VCoins** pour l'ID BDD : **"..(id or "?") .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:zerkay_identifier:975119837464526868> ID Unique : `".. (id or "?") .."`\n- <:reyz_faceid:759105033601548329> ID FiveM : `" .. (data[1].fivem or "?") .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. (data[1].discord or "?") .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. (euros or "?") .. "€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. (premiumstatus or "?")  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. (data[1].balance or "?") .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. (nameGive or "CONSOLE") .."`", img)
            end
        end)
    end
end

RegisterCommand("giveidboutique", function(source, args, raw)
    local id    = tonumber(args[1])
    local point = tonumber(args[2])
    if source == 0 or HasPermission(source, 5) then 
        giveidboutique(source, id, point)
    end
end)

function giveidfivem(source, id, point, callback)
    local npoint = nil
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE fivem = @fivem', {
        ['@fivem'] = "fivem:"..tonumber(id)
    }, function(data)
        if data == nil or data[1] == nil then
            CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) n'existe pas.")
            if callback then callback(false) end
            return
        end
        if not data[1].balance then data[1].balance = 0 end
        local poi = data[1].balance
        npoint = tonumber(poi) + tonumber(point)

        MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE fivem = @fivem', {
            ['@fivem'] = "fivem:"..tonumber(id),
            ['@point'] = npoint
        }, function(rowsChange)
            if rowsChange == 0 then
                CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) n'a pas de points boutique.")
                if callback then callback(false) end
                return
            end
            CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a achete " .. tostring(point) .. " points boutique. Il a desormais " .. npoint .. " points. Give par : " .. (nameGive or "CONSOLE"))
            if callback then callback(true, npoint) end
        end)
    end)
    local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local euros, img = GetDatasFromNumberofCoins(point)
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID FiveM : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. playerexist:getBalance() + point .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
        playerexist:setBalance(playerexist:getBalance() + point)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "add")
    else

        MySQL.Async.fetchAll("SELECT id, discord, balance, subscription FROM players_unique WHERE fivem = @fivem", {
            ['@fivem'] = "fivem:"..tonumber(id)
        }, function(data)
            if data ~= nil and data[1] ~= nil then
                
                local premiumstatus = "Non"
                if not data[1].subscription then data[1].subscription = 0 end
                if data[1].subscription == 1 then
                    premiumstatus = "Oui"
                end

                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID BDD : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:zerkay_identifier:975119837464526868> ID Unique : `" .. data[1].id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
            end
        end)
    end
end

RegisterCommand("giveidfivem", function(source, args, raw)
    local id    = tonumber(args[1])
    local point = tonumber(args[2])
    if source == 0 or HasPermission(source, 5) then 
        giveidfivem(source, id, point)
    end
end)

RegisterCommand("givevcoinsnewoffer", function(source, args, raw)
    local id    = tonumber(args[1])
    local beneficiaire    = tonumber(args[2])
    local point = tonumber(args[3])
    if source == 0 or HasPermission(source, 5) then 

        -- PARTIE QUI VA GIVE AU BENEFICIAIRE

        MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE id = @id', {
                ['@id'] = tonumber(beneficiaire)
            }, function(data)
            if not data[1].balance then data[1].balance = 0 end
            local poi = data[1].balance
            npoint = tonumber(poi) + tonumber(point)
    
            MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE id = @id', {
                ['@id'] = tonumber(beneficiaire),
                ['@point'] = npoint
            }, function(rowsChange)
                CorePrint("Le joueur " .. tostring(beneficiaire) .. " (ID UNIQUE) a achete " .. tostring(point) .. " points boutique. Il a desormais " .. npoint .. " points.")
            end)
        end)
        local beneficiaireplayerexist2 = GetPlayerByUniqueID(beneficiaire)
        Wait(500)
        local beneficiaireplayerexist = beneficiaireplayerexist2 == 0 and 0 or GetPlayer(beneficiaireplayerexist2.source)
        Wait(500)
        local euros, img = GetDatasFromNumberofCoins(point)
        local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
        if beneficiaireplayerexist ~= 0 then
            BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID Unique : **"..beneficiaire .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(beneficiaireplayerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. beneficiaireplayerexist:getFirstname() .. " " .. beneficiaireplayerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(beneficiaireplayerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. beneficiaireplayerexist:getBalance() + point .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
            beneficiaireplayerexist:setBalance(beneficiaireplayerexist:getBalance() + point)
            Wait(200)
            TriggerClientEvent("aeceoereasdqxdfgjh", beneficiaireplayerexist2.source, beneficiaireplayerexist:getBalance())
        else

            MySQL.Async.fetchAll("SELECT fivem, discord, balance, subscription FROM players_unique WHERE id = @id", {
                ['@id'] = tonumber(beneficiaire)
            }, function(data)
                if data ~= nil and data[1] ~= nil then
                    
                    local premiumstatus = "Non"
                    if not data[1].subscription then data[1].subscription = 0 end
                    if data[1].subscription == 1 or data[1].subscription == 2 then
                        premiumstatus = "Oui"
                    end

                    BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID BDD : **"..beneficiaire .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:zerkay_identifier:975119837464526868> ID Unique : `".. beneficiaire .."`\n- <:reyz_faceid:759105033601548329> ID FiveM : `" .. data[1].fivem .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                end
            end)
        end

        -- PARTIE QUI VA GIVE AU DONATEUR

        MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE fivem = @fivem', {
                ['@fivem'] = "fivem:"..tonumber(id)
            }, function(data)
            if not data[1].balance then data[1].balance = 0 end
            local poi = data[1].balance
            npoint = tonumber(poi) + tonumber(point)

            MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE fivem = @fivem', {
                ['@fivem'] = "fivem:"..tonumber(id),
                ['@point'] = npoint
            }, function(rowsChange)
                CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a achete " .. tostring(point) .. " points boutique. Il a desormais " .. npoint .. " points.")
            end)
        end)
        local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
        Wait(500)
        local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
        Wait(500)
        local euros, img = GetDatasFromNumberofCoins(point)
        local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
        if playerexist ~= 0 then
            BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID FiveM : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. playerexist:getBalance() + point .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
            playerexist:setBalance(playerexist:getBalance() + point)
            Wait(200)
            TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "add")
        else
            MySQL.Async.fetchAll("SELECT id, discord, balance, subscription FROM players_unique WHERE fivem = @fivem", {
                ['@fivem'] = "fivem:"..tonumber(id)
            }, function(data)
                if data ~= nil and data[1] ~= nil then
                    
                    local premiumstatus = "Non"
                    if not data[1].subscription then data[1].subscription = 0 end
                    if data[1].subscription == 1 or data[1].subscription == 2 then
                        premiumstatus = "Oui"
                    end

                    BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **" .. point .. " VCoins** pour l'ID BDD : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:zerkay_identifier:975119837464526868> ID Unique : `" .. data[1].id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **" .. euros .. "€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                end
            end)
        end
    end
end)

RegisterCommand("giveabonewoffer", function(source, args, raw)
    local abonnement    = args[1]
    local id    = tonumber(args[2])
    local beneficiaire    = tonumber(args[3])
    local point = tonumber(args[4])

    local time = os.time()
    local nbrJour = args[5] and tonumber(args[5]) or 30
    local endDate = time + (nbrJour * 86400)

    local point = 5000

    print(abonnement)


    if source == 0 or HasPermission(source, 5) then 
        if abonnement == "premium" then

            -- PARTIE QUI VA GIVE AU BENEFICIAIRE

            MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE id = @id', {
                ['@id'] = tonumber(beneficiaire),
                ['@subscription'] = 1,
            }, function(rowsChange)
                CorePrint("Le joueur " .. tostring(beneficiaire) .. " (ID UNIQUE) a achete l'abonnement premium sur la boutique.")
            end)
            local beneficiaireexist2 = GetPlayerByUniqueID(beneficiaire)
            Wait(500)
            local beneficiaireexist = beneficiaireexist2 == 0 and 0 or GetPlayer(beneficiaireexist2.source)
            Wait(500)
            local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/33c9dff547c10dd1caa25a0386049288c5f43f87.webp"
            local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
            --[[ if nameGive ~= "CONSOLE" then 
                img = nil
            end ]]
            if beneficiaireexist ~= 0 then
                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement premium** pour l'ID BDD : **" .. beneficiaire .. "**\n\n- 🎁 Offert par l'ID FiveM : `" .. id .. "`\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(beneficiaireexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. beneficiaireexist:getFirstname() .. " " .. beneficiaireexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(beneficiaireexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID Unique : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                SendBoutiquesInfo(GetDiscord(beneficiaireexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
                beneficiaireexist:setSubscription(1)
                Wait(200)
                TriggerClientEvent("aeceoereasdqxdfgjdqsd", beneficiaireexist2.source, beneficiaireexist:getBalance(), nbrJour)
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE id = @id', {
                    ['@id'] = tonumber(beneficiaire),
                    ['@buyendDate'] = endDate,
                }, function()
                end)
            else
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE id = @id', {
                    ['@id'] = tonumber(beneficiaire),
                    ['@buyendDate'] = endDate,
                }, function()
    
                end)
    
                MySQL.Async.fetchAll("SELECT fivem, discord, balance, subscription FROM players_unique WHERE id = @id", {
                    ['@id'] = tonumber(beneficiaire)
                }, function(data)
                    if data ~= nil and data[1] ~= nil then
    
                        local premiumstatus = "Non"
                        if not data[1].subscription then data[1].subscription = 0 end
                        if data[1].subscription == 1 or data[1].subscription == 2 then
                            premiumstatus = "Oui"
                        end
                        
                        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium** pour l'ID BDD : **" .. beneficiaire .. "**\n\n- 🎁 Offert par l'ID FiveM : `" .. id .. "`\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. data[1].fivem .."`\n- <:zerkay_identifier:975119837464526868>  Unique ID : `" .. beneficiaire .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                    
                        for k, v in pairs(data) do
                            SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
                        end
                    end
                end)
    
            end

            -- PARTIE QUI VA GIVE AU DONATEUR

            MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE fivem = @fivem', {
                ['@fivem'] = "fivem:"..tonumber(id),
                ['@subscription'] = 1,
            }, function(rowsChange)
                CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a achete l'abonnement premium sur la boutique.")
            end)
            local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
            Wait(500)
            local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)

            if playerexist ~= 0 then
                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium** pour l'ID FiveM : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                SendBoutiquesInfo(GetDiscord(playerexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
                playerexist:setSubscription(1)
                Wait(200)
                TriggerClientEvent("aeceoereasdqxdfgjdqsd", playerexist2.source, playerexist:getBalance(), nbrJour)
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE fivem = @fivem', {
                    ['@fivem'] = "fivem:"..tonumber(id),
                    ['@buyendDate'] = endDate,
                }, function()
                end)
            else
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE fivem = @fivem', {
                    ['@fivem'] = "fivem:"..tonumber(id),
                    ['@buyendDate'] = endDate,
                }, function()
    
                end)
    
    
                MySQL.Async.fetchAll("SELECT id, discord, balance, subscription FROM players_unique WHERE fivem = @fivem", {
                    ['@fivem'] = "fivem:"..tonumber(id)
                }, function(data)
                    if data ~= nil and data[1] ~= nil then
    
                        local premiumstatus = "Non"
                        if not data[1].subscription then data[1].subscription = 0 end
                        if data[1].subscription == 1 or data[1].subscription == 2 then
                            premiumstatus = "Oui"
                        end
                        
                        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium** pour l'ID FiveM: **" .. id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:zerkay_identifier:975119837464526868>  Unique ID : `" .. data[1].id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **15€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
    
                        for k, v in pairs(data) do
                            SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
                        end
                    end
                end)
            end


        elseif abonnement == "premium+" then

            -- PARTIE QUI VA GIVE AU BENEFICIAIRE

            MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE id = @id', {
                ['@id'] = tonumber(beneficiaire),
                ['@subscription'] = 2,
            }, function(rowsChange)
                print("Le joueur " .. tostring(beneficiaire) .. " (ID Boutique) a achete l'abonnement premium+ sur la boutique.")
            end)
    
            MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE id = @id', {
                ['@id'] = tonumber(beneficiaire)
            }, function(data)
                
                if not data[1].balance then data[1].balance = 0 end
                local poi = data[1].balance
                npoint = tonumber(poi) + tonumber(point)
    
                MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE id = @id', {
                    ['@id'] = tonumber(beneficiaire),
                    ['@point'] = npoint
                }, function(rowsChange)
                    print("Le joueur " .. tostring(beneficiaire) .. " (ID Boutique) a reçu " .. tostring(point) .. " points boutique avec son achat du Premium+. Il a desormais " .. npoint .. " points.")
                end)
            end)
    
            local beneficiaireexist2 = GetPlayerByUniqueID(beneficiaire)
            Wait(500)
            local beneficiaireexist = beneficiaireexist2 == 0 and 0 or GetPlayer(beneficiaireexist2.source)
            Wait(500)
            local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/d77a46c5a89598e1e5f2c8c25dd94256fdd5a16e.webp"
            local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
            --[[ if nameGive ~= "CONSOLE" then 
                img = nil
            end ]]
            if beneficiaireexist ~= 0 then
                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID Boutique : **" .. beneficiaire .. "**\n\n- 🎁 Offert par l'ID FiveM : `" .. id .. "`\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(beneficiaireexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. beneficiaireexist:getFirstname() .. " " .. beneficiaireexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(beneficiaireexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID Boutique : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                SendBoutiquesInfo(GetDiscord(beneficiaireexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                beneficiaireexist:setSubscription(2)
                beneficiaireexist:setBalance(beneficiaireexist:getBalance() + point)
                Wait(200)
                TriggerClientEvent("aeceoereasdqxdfgjh", beneficiaireexist2.source, beneficiaireexist:getBalance(), point, "add")
    
                TriggerClientEvent("aeceoereasdqxdfgjdqsd", beneficiaireexist2.source, beneficiaireexist:getBalance(), nbrJour, 2)
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE id = @id', {
                    ['@id'] = tonumber(beneficiaire),
                    ['@buyendDate'] = endDate,
                }, function()
                end)
            else           
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE id = @id', {
                    ['@id'] = tonumber(beneficiaire),
                    ['@buyendDate'] = endDate,
                }, function()
    
                end)
    
    
                MySQL.Async.fetchAll("SELECT fivem, discord, balance, subscription FROM players_unique WHERE id = @id", {
                    ['@id'] = tonumber(beneficiaire)
                }, function(data)
                    if data ~= nil and data[1] ~= nil then
                        
                        local premiumstatus = "Non"
                        if not data[1].subscription then data[1].subscription = 0 end
                        if data[1].subscription == 1 or data[1].subscription == 2 then
                            premiumstatus = "Oui"
                        end
    
                        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID Boutique : **" .. beneficiaire .. "**\n\n- 🎁 Offert par l'ID FiveM : `" .. id .. "`\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID Unique : `".. id .."`\n- <:zerkay_identifier:975119837464526868>  FiveM ID : `" .. data[1].fivem .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
    
                        for k, v in pairs(data) do
                            SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                        end
                    end
                end) 
            end

            -- PARTIE QUI VA GIVE AU DONATEUR

            MySQL.Async.execute('UPDATE players_unique SET subscription = @subscription WHERE fivem = @fivem', {
                ['@fivem'] = "fivem:"..tonumber(id),
                ['@subscription'] = 2,
            }, function(rowsChange)
                CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a achete l'abonnement premium+ sur la boutique.")
            end)
    
            MySQL.Async.fetchAll('SELECT balance FROM players_unique WHERE fivem = @fivem', {
                ['@fivem'] = "fivem:"..tonumber(id)
            }, function(data)
                
                if not data[1].balance then data[1].balance = 0 end
                local poi = data[1].balance
                npoint = tonumber(poi) + tonumber(point)
    
                MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE fivem = @fivem', {
                    ['@fivem'] = "fivem:"..tonumber(id),
                    ['@point'] = npoint
                }, function(rowsChange)
                    CorePrint("Le joueur " .. tostring(id) .. " (ID FiveM) a reçu " .. tostring(point) .. " points boutique avec son achat du Premium+. Il a desormais " .. npoint .. " points.")
                end)
            end)
    
            local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
            Wait(500)
            local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
            Wait(500)
            local img = "https://dunb17ur4ymx4.cloudfront.net/packages/images/d77a46c5a89598e1e5f2c8c25dd94256fdd5a16e.webp"
            local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
            --[[ if nameGive ~= "CONSOLE" then 
                img = nil
            end ]]
            if playerexist ~= 0 then
                BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID FiveM : **"..id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_iconuser:759105231778086913> Joueur : `" .. GetPlayerName(playerexist:getSource()) .. "`\n- 🪪 Prénom Nom RP : `" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "`\n- <:DISCORD:1158021419708452924> Discord : " .. GetDiscord(playerexist2.source, true).. "\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
                SendBoutiquesInfo(GetDiscord(playerexist2.source, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                playerexist:setSubscription(2)
                playerexist:setBalance(playerexist:getBalance() + point)
                Wait(200)
                TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "add")
    
                TriggerClientEvent("aeceoereasdqxdfgjdqsd", playerexist2.source, playerexist:getBalance(), nbrJour, 2)
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE fivem = @fivem', {
                    ['@fivem'] = "fivem:"..tonumber(id),
                    ['@buyendDate'] = endDate,
                }, function()
                end)
            else           
                MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate WHERE fivem = @fivem', {
                    ['@fivem'] = "fivem:"..tonumber(id),
                    ['@buyendDate'] = endDate,
                }, function()
    
                end)
    
    
                MySQL.Async.fetchAll("SELECT id, discord, balance, subscription FROM players_unique WHERE fivem = @fivem", {
                    ['@fivem'] = "fivem:"..tonumber(id)
                }, function(data)
                    if data ~= nil and data[1] ~= nil then
                        
                        local premiumstatus = "Non"
                        if not data[1].subscription then data[1].subscription = 0 end
                        if data[1].subscription == 1 or data[1].subscription == 2 then
                            premiumstatus = "Oui"
                        end
    
                        BoutiqueLogsVCoins("<:LogoFA:1222160078795177994> **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n\n<:reyz_edit:759105033705881702> Achat de **l'abonnement Premium+** pour l'ID FiveM: **" .. id .. "**\n\n<:BOUTIQUE:1157288403424006154> __Auteur de l'achat__ :\n- <:reyz_clouderror:759105033995943936> **Le joueur n'était pas connecté lors de l'achat**\n- <:reyz_faceid:759105033601548329> ID FiveM : `".. id .."`\n- <:zerkay_identifier:975119837464526868>  Unique ID : `" .. data[1].id .. "`\n- <:DISCORD:1158021419708452924> ID Discord : `" .. data[1].discord .. "`\n- <:reyz_coinsstack:759105033986899968> Dépense de **35€** \n- <:Premium:1158022039580463146> Status Premium :  `" .. premiumstatus  .. "`\n- <:VCOINS:1158099468051304558> Nombre de VCoins : `" .. data[1].balance .. "`\n\n<:VStaff:1152351479672352929> Give par : `".. nameGive .."`", img)
    
                        for k, v in pairs(data) do
                            SendBoutiquesInfo(v.discord .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                        end
                    end
                end) 
            end
        end
    end
end)

function setidboutique(source, id, point, callback)
    MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE id = @id', {
        ['@id'] = tonumber(id),
        ['@point'] = point
    }, function(rowsChange)
        if rowsChange == 0 then
            print("Le joueur " .. tostring(id) .. " (ID Boutique) n'existe pas.")
            if callback then callback(false) end
            return
        end
        print("La balance du joueur " .. tostring(id) .. " (ID Boutique) a été changée en " .. tostring(point) .. " points boutique.")
        if callback then callback(true, point) end
    end)
    local playerexist2 = GetPlayerByUniqueID(id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local euros, img = GetDatasFromNumberofCoins(point)
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat de **"..point.." points** pour l'ID BDD : **"..id .. "**\n**Give par :** ".. nameGive .."\nLa personne à dépensé **"..euros.."€**\nTotal VCoins du joueur: **".. point .."**\nJoueur : **" .. GetPlayerName(playerexist:getSource()) .. "**\nPrénom Nom RP : **" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "**\nDiscord du joueur : " .. GetDiscord(playerexist2.source, true), img)
        playerexist:setBalance(point)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "set")
    else
        BoutiqueLogsVCoins("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat de **"..point.." points** pour l'ID BDD : **"..id .. "**\n**Give par :** ".. nameGive .."\nLa personne à dépensé **"..euros.."€**\n\n**Le joueur n'est pas connecté**", img)
    end
end

RegisterCommand("setidboutique", function(source, args, raw)
    local id    = tonumber(args[1])
    local point = tonumber(args[2])
    if source == 0 or HasPermission(source, 5) then 
        setidboutique(source, id, point)
    end
end)

function setidfivem(source, id, point, callback)
    MySQL.Async.execute('UPDATE players_unique SET balance = @point WHERE fivem = @fivem', {
        ['@fivem'] = "fivem:"..tonumber(id),
        ['@point'] = point
    }, function(rowsChange)
        if rowsChange == 0 then
            print("Le joueur " .. tostring(id) .. " (ID FiveM) n'existe pas.")
            if callback then callback(false) end
            return
        end
        print("La balance du joueur " .. tostring(id) .. " (ID FiveM) a été changée en " .. tostring(point) .. " points boutique.")
        if callback then callback(true, point) end
    end)
    local playerexist2 = GetPlayerByFiveMID('fivem:'..id)
    Wait(500)
    local playerexist = playerexist2 == 0 and 0 or GetPlayer(playerexist2.source)
    Wait(500)
    local euros, img = GetDatasFromNumberofCoins(point)
    local nameGive = source == 0 and "CONSOLE" or GetPlayerName(source)
    if playerexist ~= 0 then
        BoutiqueLogsVCoins("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat de **"..point.." points** pour l'ID BDD : **"..id .. "**\n**Give par :** ".. nameGive .."\nLa personne à dépensé **"..euros.."€**\nTotal VCoins du joueur: **".. point .."**\nJoueur : **" .. GetPlayerName(playerexist:getSource()) .. "**\nPrénom Nom RP : **" .. playerexist:getFirstname() .. " " .. playerexist:getLastname() .. "**\nDiscord du joueur : " .. GetDiscord(playerexist2.source, true), img)
        playerexist:setBalance(point)
        Wait(200)
        TriggerClientEvent("aeceoereasdqxdfgjh", playerexist2.source, playerexist:getBalance(), point, "set")
    else
        BoutiqueLogsVCoins("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat de **"..point.." points** pour l'ID BDD : **"..id .. "**\n**Give par :** ".. nameGive .."\nLa personne à dépensé **"..euros.."€**\n\n**Le joueur n'est pas connecté**", img)
    end
end

RegisterCommand("setidfivem", function(source, args, raw)
    local id    = tonumber(args[1])
    local point = tonumber(args[2])
    if source == 0 or HasPermission(source, 5) then 
        setidfivem(source, id, point)
    end
end)

function removeidboutique(source, id, vcoins, callback)
    MySQL.Async.execute('UPDATE players_unique SET balance = balance - @vcoins WHERE id = @id', {
        ['@id'] = tonumber(id),
        ['@vcoins'] = vcoins
    }, function(rowsChange)
        if rowsChange == 0 then
            print("Le joueur " .. tostring(id) .. " (ID Boutique) n'existe pas.")
            if callback then callback(false) end
            return
        end
        print("Le joueur " .. tostring(id) .. " (ID Boutique) a perdu " .. tostring(vcoins) .. " points boutique.")
        
        MySQL.Async.fetchScalar('SELECT balance FROM players_unique WHERE id = @id', {
            ['@id'] = tonumber(id)
        }, function(newBalance)
            if not newBalance then
                print("Erreur lors de la récupération du solde du joueur " .. tostring(id) .. " (ID Boutique).")
                if callback then callback(false) end
                return
            end

            local playerByUniqueId = GetPlayerByUniqueID(id)
            if playerByUniqueId ~= 0 then
                local player = GetPlayer(playerByUniqueId.source)
                player:setBalance(newBalance)
                TriggerClientEvent("aeceoereasdqxdfgjh", playerByUniqueId.source, newBalance, vcoins, "remove")
            end

            if callback then callback(true, newBalance) end
        end)
    end)
end

RegisterCommand("removeidboutique", function(source, args)
    local id = tonumber(args[1])
    local vcoins = tonumber(args[2])

    if source == 0 or HasPermission(source, 5) then
        removeidboutique(source, id, vcoins)
    end
end)

function removeidfivem(source, id, vcoins, callback)
    local fivemId = "fivem:" .. tonumber(id)

    MySQL.Async.execute('UPDATE players_unique SET balance = balance - @vcoins WHERE fivem = @fivem', {
        ['@fivem'] = fivemId,
        ['@vcoins'] = vcoins
    }, function(rowsChange)
        if rowsChange == 0 then
            print("Le joueur " .. tostring(id) .. " (ID FiveM) n'existe pas.")
            if callback then callback(false) end
            return
        end
        print("Le joueur " .. tostring(id) .. " (ID FiveM) a perdu " .. tostring(vcoins) .. " points boutique.")
        
        MySQL.Async.fetchScalar('SELECT balance FROM players_unique WHERE fivem = @fivem', {
            ['@fivem'] = fivemId
        }, function(newBalance)
            if not newBalance then
                print("Erreur lors de la récupération du solde du joueur " .. tostring(id) .. " (ID FiveM).")
                if callback then callback(false) end
                return
            end

            local playerByUniqueId = GetPlayerByFiveMID(fivemId)
            if playerByUniqueId ~= 0 then
                local player = GetPlayer(playerByUniqueId.source)
                player:setBalance(newBalance)
                TriggerClientEvent("aeceoereasdqxdfgjh", playerByUniqueId.source, newBalance, vcoins, "remove")
            end

            if callback then callback(true, newBalance) end
        end)
    end)
end


RegisterCommand("removeidfivem", function(source, args)
    local id = tonumber(args[1])
    local vcoins = tonumber(args[2])

    if source == 0 or HasPermission(source, 5) then
        removeidfivem(source, id, vcoins)
    end
end)

local function findBoutiqueElement(data, category, idSelected)
    local labelVariation = ""
    local ImageVariation = ""
    for k,v in pairs(ObjBoutique) do
        --print("v4", json.encode(v[4]))
        if v and v[1] then
            --print(v[1].category)
            if v[1].category == category then 
                --print("found 1")
                if v[1].items[1].variations[idSelected+1].name then
                    labelVariation = v[1].items[1].variations[idSelected+1].name .. " " .. v[1].items[1].variations[idSelected+1].label
                else
                    labelVariation = v[1].items[1].variations[idSelected+1].label
                end
                ImageVariation = v[1].items[1].variations[idSelected+1].icon
            end
        end
        if v[2] then 
            --print(v[2].category)
            if v[2].category == category then 
                --print("found 2 idSelected+1", idSelected+1)
                if v[2].items[1].variations[idSelected+1].name then
                    labelVariation = v[2].items[1].variations[idSelected+1].name .. " " .. v[2].items[1].variations[idSelected+1].label
                else
                    labelVariation = v[2].items[1].variations[idSelected+1].label
                end
                ImageVariation = v[2].items[1].variations[idSelected+1].icon and v[2].items[1].variations[idSelected+1].icon or v[2].items[1].image
            end
        end
        if v[3] then 
            --print(v[3].category)
            if v[3].category == category then 
                --print("found 3 idSelected+1", idSelected+1)
                if v[3].items[1].variations[idSelected+1].name then
                    labelVariation = v[3].items[1].variations[idSelected+1].name .. " " .. v[3].items[1].variations[idSelected+1].label
                else
                    labelVariation = v[3].items[1].variations[idSelected+1].label
                end
                ImageVariation = v[3].items[1].variations[idSelected+1].icon and v[3].items[1].variations[idSelected+1].icon or v[3].items[1].image
            end
        end
        if v[4] then 
            --print("v[4].category", v[4].category)
            if v[4].category == category then 
                --print("found 4 idSelected+1", idSelected+1)
                if v[4].items[1].variations[idSelected+1].name then
                    labelVariation = v[4].items[1].variations[idSelected+1].name .. " " .. v[4].items[1].variations[idSelected+1].label
                else
                    labelVariation = v[4].items[1].variations[idSelected+1].label
                end
                ImageVariation = v[4].items[1].variations[idSelected+1].icon and v[4].items[1].variations[idSelected+1].icon or v[4].items[1].image
            end
        end
        if v[5] then 
            --print("v[5].category", v[5].category)
            if v[5].category == category then 
                --print("found 5 idSelected+1", idSelected+1)
                if v[5].items[1].variations[idSelected+1].name then
                    labelVariation = v[5].items[1].variations[idSelected+1].name .. " " .. v[5].items[1].variations[idSelected+1].label
                else
                    labelVariation = v[5].items[1].variations[idSelected+1].label
                end
                ImageVariation = v[5].items[1].variations[idSelected+1].icon and v[5].items[1].variations[idSelected+1].icon or v[5].items[1].image
            end
        end
        if v[6] then 
            if v[6].category == category then 
                --print("found 6 idSelected+1", idSelected+1)
                if v[6].items[1].variations[idSelected+1].name then
                    labelVariation = v[6].items[1].variations[idSelected+1].name .. " " .. v[6].items[1].variations[idSelected+1].label
                else
                    labelVariation = v[6].items[1].variations[idSelected+1].label
                end
                ImageVariation = v[6].items[1].variations[idSelected+1].icon and v[6].items[1].variations[idSelected+1].icon or v[6].items[1].image
            end
        end
        if v[k] then 
            if v[k].category and v[k].category == category then
                labelVariation = v[k].items[1] and v[k].items[1].variations[idSelected+1].name .. " " .. v[k].items[1].variations[idSelected+1].label
                if v[k].items[1] then
                    ImageVariation = v[k].items[1].variations[idSelected+1].icon and v[k].items[1].variations[idSelected+1].icon or v[k].items[1].image    
                end            
            end
        end
    end
    if labelVariation == "" then 
        labelVariation = "ID : " .. idSelected+1 or "?"
    end
    return labelVariation, ImageVariation
end

local function idToNameCategory(id)
    if id == 0 then 
        return "VETEMENTS"
    elseif id == 1 then 
        return "MASQUES"
    elseif id == 2 then 
        return "BIJOUX"
    elseif id == 3 then 
        return "TATTOO"
    elseif id == 4 then 
        return "LIVERIES"
    else
        return "LIVERIES " .. id
    end
end

local function IdsToCustom(data)
    local Text = ""

    local customFieldsname1
    local customFieldsname1Value
    local customFieldsname2
    local customFieldsname2Value
    local img = nil

    local TicketMsg = ""

    local name = idToNameCategory(tonumber(data.category))
    local labelVariation, ImageVariation = findBoutiqueElement(data, data.category, data.variation)
    img = ImageVariation
    if data.customFields and next(data.customFields) then
        customFieldsname1 = data.customFields[1].name
        customFieldsname1Value = data.customFields[1].value
        customFieldsname2 = data.customFields[2].name
        customFieldsname2Value = data.customFields[2].value
        Text = "Le client souhaite avoir un **" .. name .. "** avec la couleur **" .. labelVariation .. "** et avec comme "..customFieldsname1.." : **" .. customFieldsname1Value .. "** et comme "..customFieldsname2.." : **" .. customFieldsname2Value .. "**"
        
        TicketMsg = "\n\n**Bon de commande :** `".. "EN ATTENTE" .. "`\n\n**Nouvelle commande !**\n > **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n> **Catégorie :** `" .. name .. "`\n> **Couleur :** `".. labelVariation .. "`\n> **".. customFieldsname1 .." :** `".. customFieldsname1Value .. "`\n> **".. customFieldsname2 .." :** `".. customFieldsname2Value .. "`"
    else
        Text = "Le client souhaite avoir un **" .. name .. "** avec la couleur **" .. labelVariation .. "**"

        TicketMsg =  "\n\n**Bon de commande :** `".. "EN ATTENTE" .. "`\n\n**Nouvelle commande !**\n > **Serveur : **`" .. GetConvar("sv_hostname", "FA") .. "`\n > **Catégorie :** `" .. name .. "`\n> **Couleur :** `".. labelVariation .. "`"

    end     
    return Text, img, TicketMsg
end

RegisterNetEvent("core:trybuyBoutiqueItem", function(data)
    local src = source
    local coins = GetMyVCoins(src)
    local price = 2500/2
    if data.price then 
        price = tonumber(data.price)
    end
    if data.category == 0 then 
        price = 3000/2
    elseif data.category == 1 then 
        price = 2500/2
    elseif data.category == 2 then 
        price = 5000/2
    elseif data.category == 3 then 
        price = 2000/2
    elseif data.category >= 4 then 
        price = 3500/2
    end
    --print("data", type(data))
    local ply = GetPlayer(src)
    if price ~= 0 then
        if data and type(data) == "table" and data.category then
            local nameCategory = idToNameCategory(tonumber(data.category))
            if ply:getBalance() >= price then 
                RemoveCoins(src, price)    
                local CustomToCreate, images, TicketMsg = IdsToCustom(data)
                print("Achat boutique de " .. GetPlayerName(src) .. " [" .. src .. "] : " .. CustomToCreate .. " au prix de " .. price .. "$")
                BoutiqueLogs("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat d'un item **CUSTOM** du joueur ".. GetPlayerName(src) .." ["..src.."].\nPrénom Nom RP : **" .. ply:getFirstname() .. " " .. ply:getLastname() .. "**\nPrix de l'item boutique : **"..price.."**\nNombre de VCoins du joueur : "..ply:getBalance().."\nDiscord du joueur : " .. GetDiscord(src, true) .. "\n\n" .. CustomToCreate, images, true)
                SendBoutiquesInfo(GetDiscord(src, false)..".".. TicketMsg)

                TriggerClientEvent("core:boutique:validatedOrder", src)
                TriggerClientEvent("aeceoereasdqxdfgjd", src, ply:getBalance(), true, nil)
            else
                TriggerClientEvent("core:boutique:cancelledOrder", src)

            end
        end
    else
        TriggerClientEvent("core:boutique:cancelledOrder", src)
    end
end)

RegisterNetEvent("core:boutique:buypack", function(data)
    
end)

RegisterNetEvent("core:boutique:buyprenium", function()
    local src = source
    local time = os.time()
    local endDate = time + (30 * 86400)
    local ply = GetPlayer(src)
    if ply:getBalance() >= PrixBoutique["Premium"] then 
        RemoveCoins(src, PrixBoutique["Premium"])    
        MySQL.Async.execute('UPDATE players_unique SET subscription = 1, buyendDate = @buyendDate, discord = @discord WHERE license = @license', {
            ['@license'] = tostring(ply:getLicense()),
            ['@buyendDate'] = endDate,
            ['@discord'] = GetDiscord(src),
        }, function(rowsChange)
            print("Le joueur " .. GetPlayerName(src).. " [".. tostring(src) .."] a acheté le pack premium dans la boutique.")
            BoutiqueLogs("Serveur : **" .. GetConvar("sv_hostname", "FA") .. "**\nAchat du **pack premium** du joueur ".. GetPlayerName(src) .." ["..src.."].\nPrénom Nom RP : **" .. ply:getFirstname() .. " " .. ply:getLastname() .. "**\nDiscord du joueur : " .. GetDiscord(src, true))
            SendBoutiquesInfo(GetDiscord(src, false) .. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Nouveau` \n> **Serveur :** `FA`")
            ply:setSubscription(1)
            TriggerClientEvent("aeceoereasdqxdfgjd", src, ply:getBalance(), nil)
            TriggerClientEvent("core:boutique:validatedOrder", src)
        end)
    else
        TriggerClientEvent("core:boutique:cancelledOrder", src)
    end
end)

CreateThread(function()
	local btData = LoadResourceFile(GetCurrentResourceName(), 'server/addon/boutique.json')
	ObjBoutique = btData and json.decode(btData) or {}
    if next(ObjBoutique) then 
        CorePrint("Boutique chargée avec succés")
    else
        CorePrint("Boutique non chargée")
    end
end)

RegisterCommand("refreshBoutique", function(source)
    if source == 0 then 
        local btData = LoadResourceFile(GetCurrentResourceName(), 'server/addon/boutique.json')
        ObjBoutique = btData and json.decode(btData) or {}
        if next(ObjBoutique) then 
            CorePrint("Boutique chargée avec succés")
        else
            CorePrint("Boutique non chargée")
        end
    end
end)

RegisterServerCallback("core:boutique:getElements", function()
    return ObjBoutique
end)

RegisterNetEvent("core:boutique:createNewElement", function(element)
    local src = source 
    if GetPlayer(src):getPermission() >= 3 then
        table.insert(ObjBoutique, element)
	    SaveResourceFile(GetCurrentResourceName(), 'server/addon/boutique.json', json.encode(ObjBoutique))
    end
end)

RegisterNetEvent("core:boutique:update", function(catalogue)
    local src = source 
    if GetPlayer(src):getPermission() >= 3 then
        SaveResourceFile(GetCurrentResourceName(), 'server/addon/boutique.json', json.encode(catalogue))
        ObjBoutique = catalogue
        TriggerLatentClientEvent("core:boutique:update", -1, 5000, catalogue)
    end
end)

RegisterNetEvent("core:boutique:getCatalogue", function()
    local src = source
    TriggerLatentClientEvent("core:boutique:update", src, 5000, ObjBoutique)
end)

local function getGoodDiscord(discord, mention)
    if discord and string.find(discord, "discord:") then 
        newdiscord = discord:gsub("discord:", "")
        if mention then
            newdiscord = discord .. " ( <@" .. newdiscord .. "> )"
        end
        return newdiscord
    end
    return discord
end

RegisterNetEvent("core:secu:ImConnectedFirst", function()
    local src = source
    local discord = "N/A"
    for k,v in ipairs(GetPlayerIdentifiers(src))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end
    discord = getGoodDiscord(discord)
    if LostPremium[discord] then 
        TriggerClientEvent("core:sendnotifboutiquecaduc", src)
    end
end)

CreateThread(function()
    local count = 0
    while not MySQL do Wait(1) end 
    Wait(3000)
    CorePrint("Démarrage du check du temps restant des abonnements premium")
    MySQL.Async.fetchAll('SELECT license, subscription, discord, buyendDate FROM `players_unique` WHERE subscription IN (1, 2)', {},  function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                local dayRemaining = math.floor(((v.buyendDate or 0) - os.time()) / 86400)

                local oldsubscription = v.subscription or 0
                
                if dayRemaining < 0 then 
                    MySQL.Async.execute('UPDATE players_unique SET subscription = 0, buyendDate = 0 WHERE license = @license', {
                        ['@license'] = tostring(v.license),
                    }, function(rowsChange)
                        local disc = getGoodDiscord(v.discord, false) or "?"
                        
                        if oldsubscription == 1 then
                            SendBoutiquesInfo("discord:"..disc.. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Caduc` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium`")
                        else
                            SendBoutiquesInfo("discord:"..disc.. ".\n\n**Nouvelle commande !**\n> **Catégorie :** `" .. "Abonnement" .. "`\n> **Type :** `Caduc` \n> **Serveur :** `FA`\n> **Abonnement :** `Premium+`")
                        end
                        count = count + 1
                        if disc ~= "?" then
                            LostPremium[disc] = true
                        end
                    end)
                end
            end
        end
        if count > 0 then
            CorePrint("Suppression de x" .. count .. " abonnements premium car leur temps ont expiré")
        end
    end)
end)

function BuyVehicleBoutique(player2, vehicle, liveries, typeachcat, perf, colors, category)
    local player = tonumber(player2)
    local model = vehicle
    local props = {}
    local plate = GenerateNotOwnedPlate()
    props.plate = plate
    props.modLivery = liveries or 0
    if perf then
        props.modEngine = perf
        props.modBrakes = perf
        props.modTransmission = perf
        if perf > 3 then props.modEngine = 3 end
        if perf > 2 then props.modBrakes = 2 end
        if perf > 2 then props.modTransmission = 2 end
        if perf == 5 then 
            props.modTurbo = true
        end
    end
    if colors then 
        if type(colors) == "table" then 
            props.rgbcolor1 = {colors[1], colors[2], colors[3]}
            props.rgbcolor2 = {colors[1], colors[2], colors[3]}
        end
    end
    local owner = GetPlayer(player):getId()
    MySQL.Async.execute("INSERT INTO vehicles (owner, plate, name, props, inventory, garage, vente, job, premium) VALUES (@1, @2, @3, @4, @5, @6, @7, @8, @prem)"
        , {
            ["1"] = owner,
            ["2"] = props.plate,
            ["3"] = tostring(model),
            ["4"] = json.encode(props),
            ["5"] = json.encode({}),
            ["6"] = "central",
            ["7"] = nil,
            ["8"] = nil,
            ["prem"] = typeachcat == "boutiquevehicule" and 1 or 0
        }, function(affectedRows)
        if affectedRows ~= 0 then
            local inv
            if coffre[GetHashKey(model)] ~= nil and coffre[GetHashKey(model)] / 1000 ~= nil then
                inv = json.encode({item={}, cloths={}, weapons={}, weight={max=coffre[GetHashKey(model)] / 1000, current=0}})
            else
                inv = json.encode({item={}, cloths={}, weapons={}, weight={max=100, current=0}})
            end
            local veh = carDealerCreateCar({
                plate = props.plate,
                owner = owner,
                name = model,
                props = json.encode(props),
                garage = nil,
                stored = 1,
                premium = typeachcat == "boutiquevehicule" and true or false,
                vente = nil,
                coowner = json.encode({}),
                job = nil,
                inventory = json.encode(inv),
                mileage = 0,
                fuel = 100,
                body = json.encode({}),
                currentPlate = props.plate
            })
            --GetPlayerVehicle(player, true)
            if typeachcat == "boutique" then
                TriggerClientEvent('core:spawnboutiquecar', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "casino" then 
                TriggerClientEvent('core:spawnboutiquecar', player, tostring(model), props.plate, 0, props.modLivery, "casino")
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "boutiquevehicule" then 
                print("Go", boutiquevehicule, category)
                TriggerClientEvent('core:spawnboutiqueVehiclePayant', player, tostring(model), props, category)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "bateau" then
                TriggerClientEvent('core:spawnbateauachat', player, tostring(model), props, category)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "premiumsud" then
                TriggerClientEvent('core:spawnpremiumcarSud', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "noJobSud" then
                TriggerClientEvent('core:spawnnojobcarSud', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), false)
            elseif typeachcat == "noJobNord" then
                TriggerClientEvent('core:spawnnojobcarNord', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), false)
            elseif typeachcat == "premiumnord" then
                TriggerClientEvent('core:spawnpremiumcarNorth', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model), true)
            elseif typeachcat == "heliwave" then
                TriggerClientEvent('core:spawnpremiumcarheliwave', player, tostring(model), props.plate, 0, props.modLivery)
                TriggerClientEvent('core:createKeys', player, props.plate, tostring(model))
            end

            local vehName = TriggerClientCallback(player, "core:getVehicleNameFromModel", model)

			if vehName ~= "NULL" then
				local params = {
					plate = props.plate,
					model = vehName,
				}

				exports['knid-mdt']:api().people.vehicles.create(owner, params,
					function(cb)
						if cb == 201 then
							print("^2[" .. cb .. "]^0 MDT: (" .. string.upper(typeachcat) .. ") Vehicle created : ^6", owner, json.encode(params), "^0")
						else
							print("^8[" .. cb .. "]^0 MDT: (".. string.upper(typeachcat) ..") Error creating vehicle : ^6", owner, json.encode(params), "^0")
						end
					end)
			end
        else
            --[[TriggerClientEvent('core:ShowNotification', player, "~r~Erreur lors de l'achat du véhicule")]]
            TriggerClientEvent("__atoshi::createNotification", player, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Erreur lors de l'achat du véhicule"
            })
        end
    end)
end


RegisterNetEvent("core:boutiquevehicule:buyCar", function(name, price, performance, colors, category)
    local src = source 
    local coins = GetMyVCoins(src)
    if not price then return end
    if price == 0 then return end

    if tonumber(coins) >= price then
        RemoveCoins(src, price)
        SendDiscordLogImage("boutiqueVeh", source, "https://cdn.sacul.cloud/vision/boutique/"..name..".webp", 
            GetPlayer(src):getLastname() .. " " .. GetPlayer(src):getFirstname(), 
            string.sub(GetDiscord(src), 9, -1), GetIDFiveM(src), GetMyVCoins(src),
            name, price, performance, category)
        BuyVehicleBoutique(src, name, 0, "boutiquevehicule", performance, colors, category)
        TriggerClientEvent("aeceoereasdqxdfgjh", src, GetMyVCoins(src), coins, "buy")
    end
end)

RegisterNetEvent("core:boutiquevehicule:tryCar", function(name, category, oldcoords, colors, perf)
    local src = source 
    SetPlayerRoutingBucket(src, src)
    TriggerClientEvent("core:boutiqueveh:try", src, name, category, oldcoords, colors, perf)
end)

RegisterNetEvent("core:boutique:finishedtest", function()
    local src = source 
    SetPlayerRoutingBucket(src, 0)
end)

RegisterNetEvent("core:boutique:buyCar", function(id, veh, liveri)
    local src = source 
    if GetPlayer(src):getPermission() >= 3 then
        BuyVehicleBoutique(id, veh, liveri, "boutique")
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'VERT',
            content = "~s Véhicule give avec succès"
        })
    end
end)

RegisterNetEvent("core:boutique:buyBateau", function(veh)
    local src = source 
    BuyVehicleBoutique(src, veh, 0, "bateau")
end)


RegisterNetEvent("core:nojob:buyCar", function(veh, job)
    local src = source 
    if DoesPlayerHaveItemCount(src, "money", veh.price) then
        for key, value in pairs(GetPlayer(src):getInventaire()) do
            if value.name == "money" then
                if RemoveItemToPlayer(src, "money", veh.price, value.metadatas) then
                    if job == "noJobSud" then
                        AddMoneyToSociety(veh.price*0,15, "cardealerSud")
                    elseif job == "noJobNord" then
                        AddMoneyToSociety(veh.price*0,15, "cardealerNord")
                    elseif job == "noJobHeliwave" then
                        AddMoneyToSociety(veh.price*0,15, "heliwave")
                    end
                    BuyVehicleBoutique(src, veh.name, 0, job)
                else
                    TriggerClientEvent("__atoshi::createNotification", src, {
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous n'avez pas assez d'argent en banque"
                    })
                end
            end
        end
    else
        local account = getBankPlayerFromSrc(src)
        local hasmoney = bankPlayerUpdate(src, "remove", veh.price, "player")
        if hasmoney then
            if job == "noJobSud" then
                AddMoneyToSociety(veh.price*0,15, "cardealerSud")
            elseif job == "noJobNord" then
                AddMoneyToSociety(veh.price*0,15, "cardealerNord")
            elseif job == "noJobHeliwave" then
                AddMoneyToSociety(veh.price*0,15, "heliwave")
            end
            BuyVehicleBoutique(src, veh.name, 0, job)
        end
    end
end)

RegisterNetEvent("core:premium:buyCar", function(veh, endroit)
    local src = source 
    if GetPlayer(src):getSubscription() ~= 0 then
        if DoesPlayerHaveItemCount(src, "money", veh.price) then
            for key, value in pairs(GetPlayer(src):getInventaire()) do
                if value.name == "money" then
                    if RemoveItemToPlayer(src, "money", veh.price, value.metadatas) then
                        if endroit == "sud" then
                            AddMoneyToSociety(veh.price*0,15, "cardealerSud")
                            BuyVehicleBoutique(src, veh.name, 0, "premiumsud")
                        elseif endroit == "nord" then
                            AddMoneyToSociety(veh.price*0,15, "cardealerNord")
                            BuyVehicleBoutique(src, veh.name, 0, "premiumnord")
                        elseif endroit == "heliwave" then
                            AddMoneyToSociety(veh.price*0,15, "heliwave")
                            BuyVehicleBoutique(src, veh.name, 0, "heliwave")
                        end
                    else
                        TriggerClientEvent("__atoshi::createNotification", src, {
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Vous n'avez pas assez d'argent en banque"
                        })
                    end
                end
            end
        else
            local account = getBankPlayerFromSrc(src)
            local hasmoney = bankPlayerUpdate(src, "remove", veh.price, "player")
            if hasmoney then
                if endroit == "sud" then
                    AddMoneyToSociety(veh.price*0,15, "cardealerSud")
                    BuyVehicleBoutique(src, veh.name, 0, "premiumsud")
                elseif endroit == "nord" then
                    AddMoneyToSociety(veh.price*0,15, "cardealerNord")
                    BuyVehicleBoutique(src, veh.name, 0, "premiumnord")
                elseif endroit == "heliwave" then
                    AddMoneyToSociety(veh.price*0,15, "heliwave")
                    BuyVehicleBoutique(src, veh.name, 0, "heliwave")
                end
            end
        end
    else
        TriggerClientEvent("__atoshi::createNotification", src, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous devez avoir l'abonnement premium pour pouvoir acheter ce véhicule"
        })
    end
end)

--RegisterCommand("boutique", function(source, args)
--    print(VisionUniqueID(args[1], args[2]))
--end)

function VisionUniqueID(license, discord)
    local Number = 0
    local Subtable = {
        ["a"] = 1, ["b"] = 2, ["c"] = 3, ["d"] = 4,
        ["e"] = 5, ["f"] = 6, ["g"] = 7, ["h"] = 8,
        ["i"] = 9, ["j"] = 10, ["k"] = 11, ["l"] = 12,
        ["m"] = 13, ["n"] = 14, ["o"] = 15, ["p"] = 16,
        ["q"] = 17, ["r"] = 18, ["s"] = 19, ["t"] = 20,
        ["u"] = 21, ["v"] = 22, ["w"] = 23, ["x"] = 24,
        ["y"] = 25, ["z"] = 26, [":"] = 27, ["/"] = 28
    }
    for i = 1, #license do
        local char = license:sub(i, i)
        local key = Subtable[string.lower(char)] or char
        Number = Number + tonumber(key)
    end
    for i = 1, #discord do
        local char = discord:sub(i, i)
        local key = Subtable[string.lower(char)] or char
        Number = Number + tonumber(key)
        if i == #discord then multiplynumber = char end
    end
    return Number * multiplynumber
end


-- FIRST LAUNCH
--RegisterNetEvent("core:playerLoaded", function(source)
--    local ply = GetPlayer(source)
--    MySQL.Async.execute('UPDATE players_unique SET discord = @discord WHERE license = @license', {
--        ['@license'] = tostring(ply:getLicense()),
--        ['@discord'] = GetDiscord(source),
--    }, function(rowsChange)
--    end)
--end)


-- Prepare database for boutique system
-- We don't want any error so we have to delete all NULL values even if there is a default in the database
MySQL.ready(function()
    MySQL.Async.execute('UPDATE players_unique SET subscription = 0 WHERE subscription IS NULL;', {}, function(rowsChange)
    end)
    MySQL.Async.execute('UPDATE players_unique SET balance = 0 WHERE balance IS NULL;', {}, function(rowsChange)
    end)
    CorePrint("[^4Boutique^7] Restructuration des valeurs boutique NULL en bdd.")
end)