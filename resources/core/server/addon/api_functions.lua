--- API Duty Statistiques
local token = "jWjSNf5wtC8gctwEuQdjgEA8BmgwjctYmQMe9wG6ME3v7RWWnnrD8cX1hyveAKCQfFehWvsDnRdfC7cSHNgwCYajUUCqVZuL7VPP7avWKyW2QbK2nwuTdLWZ"
local function replyToRequest(type, name, messageId, args, status, data)
    local url = "http://srvdev.visionrp.fr:6420/fa/discord/replyToRequest"

    PerformHttpRequest(url, 
        function(errorCode, resultData, resultHeaders, errorData) end, 
        'POST', 
        json.encode({
            ["type"] = type,
            ["name"] = name,
            ["messageId"] = messageId,
            ["args"] = args,
            ["status"] = status,
            ["data"] = data
        }), 
        { 
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end

local function getApiRequestForm()
    local url = "http://srvdev.visionrp.fr:6420/fa/discord/getRequestForm"
    local source = 0

    PerformHttpRequest(url, 
        function(errorCode, resultData, resultHeaders, errorData)
            if errorCode == 200 then
                local data = json.decode(resultData)
                for k, v in pairs(data) do
                    local error = false
                    ------------------------------------------------------------------------
                    ------------------------------ Boutique ------------------------------
                    ------------------------------------------------------------------------
                    if v.name == "givepremium" then
                        print("[^2INFO^7] Give d'un premium à l'id boutique "..v.args[1]) 
                        givepremium(source, v.args[1], function(success)
                            if success then 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "fivemgivepremium" then
                        print("[^2INFO^7] Give d'un premium à l'id fivem "..v.args[1])
                        fivemgivepremium(source, v.args[1], v.args[2], function(success)
                            if success then 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "removefivempremium" then
                        print("[^2INFO^7] Suppression d'un premium à l'id fivem "..v.args[1])
                        removefivempremium(source, v.args[1], function(success)
                            if success then 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "removeboutiquepremium" then
                        print("[^2INFO^7] Suppression d'un premium à l'id boutique "..v.args[1])
                        removeboutiquepremium(source, v.args[1], function(success)
                            if success then 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "fivemgivepremiumplus" then
                        print("[^2INFO^7] Give d'un premium+ à l'id fivem "..v.args[1])
                        fivemgivepremiumplus(source, v.args[1], v.args[2], function(success)
                            if success then 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "givepremiumplus" then
                        print("[^2INFO^7] Give d'un premium+ à l'id boutique "..v.args[1])
                        givepremiumplus(source, v.args[1], v.args[2], function(success)
                            if success then 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "giveidboutique" then
                        print("[^2INFO^7] Give de vcoins à l'id boutique "..v.args[1])
                        giveidboutique(source, v.args[1], v.args[2], function(success, currentNumberOfVcoins)
                            local data = { vcoins = currentNumberOfVcoins }
                            if success then 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "SUCCESS", data) 
                            else 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "giveidfivem" then
                        print("[^2INFO^7] Give de vcoins à l'id fivem "..v.args[1])
                        giveidfivem(source, v.args[1], v.args[2], function(success, currentNumberOfVcoins)
                            local data = { vcoins = currentNumberOfVcoins }
                            if success then 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "SUCCESS", data) 
                            else 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "setidboutique" then
                        print("[^2INFO^7] Redefinition du nombre de vcoins à "..v.args[2].." pour l'id boutique "..v.args[1])
                        setidboutique(source, v.args[1], v.args[2], function(success, currentNumberOfVcoins)
                            local data = { vcoins = currentNumberOfVcoins }
                            if success then 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "SUCCESS", data)  
                            else 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "setidfivem" then
                        print("[^2INFO^7] Redefinition du nombre de vcoins à "..v.args[2].." pour l'id fivem "..v.args[1])
                        setidfivem(source, v.args[1], v.args[2], function(success, currentNumberOfVcoins)
                            local data = { vcoins = currentNumberOfVcoins }
                            if success then 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "SUCCESS", data) 
                            else 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "removeidboutique" then
                        print("[^2INFO^7] Suppression de "..v.args[2].." vcoins pour l'id boutique "..v.args[1])
                        removeidboutique(source, v.args[1], v.args[2], function(success, currentNumberOfVcoins)
                            local data = { vcoins = currentNumberOfVcoins }
                            if success then 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "SUCCESS", data) 
                            else 
                                replyToRequest("boutique", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "removeidfivem" then
                        print("[^2INFO^7] Suppression de "..v.args[2].." vcoins pour l'id fivem "..v.args[1])
                        removeidfivem(source, v.args[1], v.args[2], function(success, currentNumberOfVcoins)
                            local data = { vcoins = currentNumberOfVcoins }
                            if success then 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "SUCCESS", data) 
                            else 
                                replyToRequest("fivem", v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    ------------------------------------------------------------------------
                    ------------------------------ Modération ------------------------------
                    ------------------------------------------------------------------------
                    elseif v.name == "ban" then
                        print("[^2INFO^7] Ban de l'id fivem "..v.args[1])
                        BanPlayer(v.args[1], v.args[2], v.args[3], 0, v.args[4], { ["username"] = v.args[5] }, function(success, banId)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS", { banId = banId })
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "banoffline" then
                        print("[^2INFO^7] Ban offline de l'id fivem "..v.args[1])
                        BanOfflinePlayer(v.args[1], v.args[2], v.args[3], 0, v.args[4], { ["username"] = v.args[5] }, function(success, banId)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS", { banId = banId })
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "unban" then
                        print("[^2INFO^7] Unban de l'id fivem "..v.args[1])
                        UnBanPlayer(v.args[1], function(success)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "kick" then
                        print("[^2INFO^7] Kick de l'id fivem "..v.args[1])
                        KickPlayer(0, v.args[1], v.args[2], function(success)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "jail" then
                        print("[^2INFO^7] Jail de l'id fivem "..v.args[1])
                        JailPlayer(v.args[1], v.args[2]*60, function(success)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "unjail" then
                        print("[^2INFO^7] Unjail de l'id fivem "..v.args[1])
                        ReleasePlayer(v.args[1], function(success)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "wipeidbdd" then
                        print("[^2INFO^7] Wipe de l'id fivem "..v.args[1])
                        WipeWithIdBdd(v.args[1], function(success)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS") 
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    elseif v.name == "removeweaponidbdd" then
                        print("[^2INFO^7] Suppression des armes de l'id fivem "..v.args[1])
                        RemoveAllWeaponsWithIdBdd(v.args[1], function(success, countWeaponsRemoved)
                            if success then 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "SUCCESS", { countWeaponRemoved = countWeaponRemoved }) 
                            else 
                                replyToRequest('moderation', v.name, v.messageId, v.args, "ERROR")
                            end
                        end)
                    else
                        replyToRequest(nil, v.name, v.messageId, v.args, "ERROR")
                        print("[^1ERROR^7] getApiRequestForm | Name not found !")
                    end
                end
            end
        end, 
        'GET', 
        "", 
        { 
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        }
    )
end

--- CRON
Citizen.CreateThread(function()
    local hostname = GetConvar("sv_hostname", 'null')
    local projectDesc = GetConvar("sv_projectDesc", 'null')
    while hostname == "Absolute FA" and projectDesc == "Serious RP, Développement inédit, Staff Actif   discord.gg/visionrp" do
        getApiRequestForm()
        Wait(15*1000)
        print("[^2INFO^7] Récupération des requêtes API à exécuter")
    end
end)