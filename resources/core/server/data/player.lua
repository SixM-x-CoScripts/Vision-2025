vAdminPlayersList = {}
function CreatePlayerData(src, perm, perso)
    local FinalSendPlayerData = {}
    local ply = GetPlayer(src)
    if ply == nil then
        local license = GetLicense(src)

        local obj = player:new({}, true, src, perm)

        MySQL.Async.insert("INSERT INTO players (cloths, license, firstname, lastname, age, sex, size, birthplaces, inventaire, banque, pos, permission, job, job_grade, crew, active) VALUES (@1, @key, @12, @13, @14, @15, @16, @17, @3, @4, @5, @6, @7, @8, @9, @11)"
            , {
                ["1"] = json.encode(obj:getCloths()),
                ["3"] = json.encode(obj:getInventaire()),
                ["4"] = obj:getBanque(),
                ["5"] = json.encode(obj:getPos()),
                ["6"] =  obj:getPermission(),
                ["7"] = obj:getJob(),
                ["8"] = obj:getJobGrade(),
                ["9"] = obj:getCrew(),
                ["10"] = json.encode(obj:getStatus()),
                ["11"] = obj:getActive(),
                ["key"] = obj:getLicense(),
                ["12"] = obj:getFirstname(),
                ["13"] = obj:getLastname(),
                ["14"] = obj:getAge(),
                ["15"] = obj:getSex(),
                ["16"] = obj:getSize(),
                ["17"] = obj:getBirthplaces(),

            }, function(result)
            local ply = GetPlayer(src)
            ply:setId(result)

            ply:setFiveMID(GetIDFiveM(src))
            ply:setDiscord(GetDiscord(src))
            -- CorePrint("Player " .. src .. " saved.")
            GiveItemToPlayer(src, "bread", 5, {})
            GiveItemToPlayer(src, "money", 3000, {})
            GiveItemToPlayer(src, "water", 5, {})
            GiveItemToPlayer(src, "gps", 1, {})
            GiveItemToPlayer(src, "phone", 1, {})
            GiveItemToPlayer(src, "tabletli", 1, {})
            CreateAccountPlayer(result)
        end)

        -- Wait(250)

        -- FinalSendPlayerData = GetUniquePlayerInfo(src, license, obj)

        MySQL.Async.fetchAll("SELECT id, permission, balance, subscription, buyendDate FROM players_unique WHERE license = @license", {
            ["@license"] = license
        }, function(result)
            if (result[1] == nil) then
                MySQL.Async.insert("INSERT INTO players_unique (license, permission, fivem, discord, balance, subscription, buyendDate) VALUES (@license, @permission, @fivem, @discord, @balance, @subscription, @buyendDate)"
                , {
                    ["license"] = license,
                    ["discord"] = GetDiscord(src),
                    ["fivem"] = GetIDFiveM(src),
                    ["permission"] = 0,
                    ["balance"] = 0,
                    ["subscription"] = 0,
                    ["buyendDate"] = 0
                }, function(resultid)
                    obj:setBalance(0)
                    obj:setSubscription(0)
                    obj:setPermission(0)
                    obj:setUniqueId(resultid)
                end)
            else
                obj:setBalance(result[1].balance)
                obj:setPermission(result[1].permission)
                obj:setUniqueId(result[1].id)
                if result[1].buyendDate and result[1].buyendDate > 0 then
                    obj:setSubscription(result[1].subscription)
                else
                    -- Reset his subscription when it has expired
                    obj:setSubscription(0)
                end
            end
        end)

        if perso then
            obj:setNumPerso(perso + 1)
        end
        Wait(250)
        RefreshPlayerData(src)
    end
    return FinalSendPlayerData
end

-- function GetUniquePlayerInfo(src, license, obj)
--     local FinalSendPlayerData = {}
--     local result = MySQL.Sync.fetchAll([[
--         SELECT
--             p.id as player_id, p.license, p.tattoos, p.weapons, p.pos, p.job, p.job_grade, p.crew, p.status, p.last_property, p.hasvoted, p.active, p.firstname, p.lastname, p.age, p.sex, p.size, p.inventaire, p.cloths, p.birthplaces, p.playtime,
--             pu.id as unique_id, pu.permission, pu.subscription, pu.buyendDate, pu.balance, pu.discord, pu.fivem, pu.total_playtime, pu.global_playtime
--         FROM
--             players as p
--         JOIN
--             players_unique as pu ON p.license = pu.license
--         WHERE
--             p.license = @license
--     ]], {
--         ["@license"] = license
--     })
--     FinalSendPlayerData = result

--     MySQL.Async.fetchAll("SELECT id, permission, balance, subscription, buyendDate FROM players_unique WHERE license = @license", {
--         ["@license"] = license
--     }, function(result)
--         if (result[1] == nil) then
--             MySQL.Async.insert("INSERT INTO players_unique (license, permission, fivem, discord, balance, subscription, buyendDate, visionid) VALUES (@license, @permission, @fivem, @discord, @balance, @subscription, @buyendDate, @visionid)"
--             , {
--                 ["license"] = license,
--                 ["discord"] = GetDiscord(src),
--                 ["fivem"] = GetIDFiveM(src),
--                 ["permission"] = 0,
--                 ["balance"] = 0,
--                 ["subscription"] = 0,
--                 ["buyendDate"] = 0,
--                 ["visionid"] = VisionUniqueID(obj:getLicense(), GetDiscord(src))
--             }, function(id)
--                 obj:setUniqueId(id)
--                 table.insert(FinalSendPlayerData, {permission = 0, balance = 0, subscription = 0, buyendDate = 0, discord = GetDiscord(src), fivem = GetIDFiveM(src)})
--             end)
--         else
--             FinalSendPlayerData.balance=result[1].balance
--             FinalSendPlayerData.permission=result[1].permission
--             FinalSendPlayerData.uid=result[1].id

--             FinalSendPlayerData.buyendDate = result[1].buyendDate or 0

--             if result[1].buyendDate and result[1].buyendDate > 0 then
--                 if result[1].subscription == 1 then
--                     FinalSendPlayerData.subscription = 1
--                 elseif result[1].subscription == 2 then
--                     FinalSendPlayerData.subscription = 2
--                 end
--             else
--                 FinalSendPlayerData.subscription = 0
--             end
--             obj:setUniqueId(result[1].id)
--             obj:setBalance(result[1].balance)
--             obj:setPermission(result[1].permission)
--             obj:setSubscription(FinalSendPlayerData.subscription)
--         end
--     end)
--     return FinalSendPlayerData
-- end

function UpdatePlayerData(src, uid)
    local FinalSendPlayerData = {}
    if GetPlayer(src) == nil then
        local license = GetLicense(src)
        local obj = player:new({}, true, src, 0)

        MySQL.Async.execute("UPDATE players SET cloths = @cloths, inventaire = @inventaire, lastname = @lastname, firstname = @firstname, degrader = @degrader, last_property = @last_property, phone_number = @phone_number, crew = @crew, tattoos = @tattoos, banque = @banque, pos = @pos, job = @job, job_grade = @job_grade WHERE id = @player_id"
        , {
            ["@tattoos"] = json.encode({}),
            ["@banque"] = 5000,
            ["@pos"] = json.encode(vector4(-1370.0, -527.89, 29.31, 0.0)),
            ["@job"] = "aucun",
            ["@job_grade"] = 1,
            ["@crew"] = "None",
            ["@phone_number"] = nil,
            ["@last_property"] = nil,
            ["@degrader"] = json.encode({}),
            ["@firstname"] = obj:getFirstname(),
            ["@lastname"] = obj:getLastname(),
            ["@age"] = "1/1/2000",
            ["@inventaire"] = json.encode(obj:getInventaire()),
            ["@cloths"] = json.encode(obj:getCloths()),
            ["@player_id"] = uid,
        })
        local ply = GetPlayer(src)

        ply:setId(uid)

        ply:setFiveMID(GetIDFiveM(src))
        ply:setDiscord(GetDiscord(src))
        -- CorePrint("Player " .. src .. " saved.")
        GiveItemToPlayer(src, "bread", 5, {})
        GiveItemToPlayer(src, "money", 3000, {})
        GiveItemToPlayer(src, "water", 5, {})
        GiveItemToPlayer(src, "gps", 1, {})
        GiveItemToPlayer(src, "phone", 1, {})
        GiveItemToPlayer(src, "tabletli", 1, {})
        CreateAccountPlayer(uid)

        -- Wait(250)

        -- FinalSendPlayerData = GetUniquePlayerInfo(src, license, obj)

        Wait(250)
        RefreshPlayerData(src)

    end

end

function LoadPlayerData(source, data, id)
    if GetPlayer(source) == nil then
        local data = data
        local obj = player:new(data, false, source) ---@return player
        obj:setIdPerso(id)
        obj:setNumPerso(#id.characterList)
        RefreshPlayerData(source)
        TriggerEvent("core:playerLoaded", source)
        if Bank.GetPlayerCommonAccount(tonumber(source)) then
            TriggerClientEvent("core:updateBankPhoneValue", source, Bank.GetPlayerCommonAccount(tonumber(source)).balance)
        end
        obj:setActive(1)
        Wait(5000)
        -- check if player has been Wiped then load creator
        if (obj:getFirstname() == "" and obj:getLastname() == "") or (obj:getFirstname() == "Wiped" and obj:getLastname() == "Wiped") then
            TriggerClientEvent("core:loadCreator", source)
        end
        Wait(3000)
        SavePlayerData(source)
        if getBankPlayerFromSrc(source) == nil then CreateAccountPlayer(obj:getId()) end
    end
end

local Answer = {}
RegisterNetEvent("core:PersonnageSelected")
AddEventHandler("core:PersonnageSelected", function(data)
    Answer[source] = data
end)

MySQL.ready(function()
    -- local players = 0
    -- local time = os.time()
    -- local newtime = os.time()
	-- local prom = promise.new()
    -- MySQL.Async.fetchAll([[
    --     SELECT
    --         p.id as player_id, p.license, p.tattoos, p.weapons, p.pos, p.job, p.job_grade, p.crew, p.status, p.last_property, p.hasvoted, p.active, p.firstname, p.lastname, p.age, p.sex, p.size, p.inventaire, p.cloths, p.birthplaces, p.playtime,
    --         pu.id as unique_id, pu.permission, pu.subscription, pu.buyendDate, pu.balance, pu.discord, pu.fivem, pu.total_playtime, pu.global_playtime
    --     FROM players as p JOIN players_unique as pu ON p.license = pu.license WHERE pu.last_connection >= DATE_SUB(NOW(), INTERVAL 15 DAY)
    --     ]], {}, function(result)
    --     for k, v in pairs(result) do
    --         v.permission = v.permission or 0
    --         v.subscription = v.subscription or 0
    --         v.buyendDate = v.buyendDate or 0
    --         v.balance = v.balance or 0
    --         v.discord = v.discord or ""
    --         v.fivemid = v.fivem or ""
    --         v.id = v.player_id
    --         v.uid = v.unique_id

    --         players += 1
    --         offlineplayers:new(v, v.license)
    --     end
    --     newtime = os.time()
    --     prom:resolve()
    -- end)
	-- local result = Citizen.Await(prom)
    -- CorePrint("Loaded " .. players .. " players under " .. newtime-time .. "ms.")
end)


function GetPlayerData(source, selectedPlayer)
    local source = source
    local license = GetLicense(source)
    local tables = {}
    tables.characterList = {}
    --local obj = GetOfflinePlayers(license)
    local sendData

    --if obj == nil then
        -- Maybe he hasn't connected for a long time
        -- Check if he has a player in the database
        local result = MySQL.Sync.fetchAll([[
            SELECT
                p.id as player_id, p.license, p.tattoos, p.weapons, p.pos, p.job, p.job_grade, p.crew, p.status, p.last_property, p.hasvoted, p.active, p.firstname, p.lastname, p.age, p.sex, p.size, p.inventaire, p.cloths, p.birthplaces, p.playtime,
                pu.id as unique_id, pu.permission, pu.subscription, pu.buyendDate, pu.balance, pu.discord, pu.fivem, pu.total_playtime, pu.global_playtime
            FROM
                players as p
            JOIN
                players_unique as pu ON p.license = pu.license
            WHERE
                p.license = @license
        ]], {
            ["@license"] = license
        })
        if (not next(result)) then
            CreatePlayerData(source, 0)
            return "ok"
        else
            for k, v in pairs(result) do
                v.id = v.player_id
                v.uid = v.unique_id
                table.insert(tables.characterList, {id = v.id, name =  v.lastname .. " " .. v.firstname})
                if selectedPlayer and selectedPlayer == v.id then -- for player switch
                    sendData = v
                end
                if v.active == 1 and not sendData then
                    sendData = v
                end
            end
            --print("GetOfflinePlayers | sendData ", sendData)
            if (not sendData) then
                sendData = result[1];
                sendData.active = 1;
                MySQL.Sync.execute('UPDATE players SET active = 1 WHERE license = @license AND id = @id', {
                    ['@license'] = license,
                    ['@id'] = sendData.id
                });
            end
            MySQL.Sync.execute('UPDATE players SET active = 0 WHERE license = @license AND id != @id', {
                ['@license'] = license,
                ['@id'] = sendData.id
            });
            LoadPlayerData(source, sendData, tables);
            return "ok"
        end
    --end
    -- for k,v in pairs(obj) do
    --     table.insert(tables.characterList, {id = v.id, name =  v.lastname .. " " .. v.firstname})
    --     if (not v.uid) or (v.uid == 0) then
    --         -- reSELECT players_unique
    --         local result = MySQL.Sync.fetchAll([[
    --             SELECT
    --                 id, permission, balance, subscription, buyendDate
    --             FROM
    --                 players_unique
    --             WHERE
    --                 license = @license
    --         ]], {
    --             ["@license"] = license
    --         })
    --         if result[1] then
    --             v.uid = result[1].id
    --             v.permission = result[1].permission
    --             v.subscription = result[1].subscription
    --             v.buyendDate = result[1].buyendDate
    --             v.balance = result[1].balance
    --         end
    --     end
    --     --print("Player", tonumber(v.id), tonumber(selectedPlayer), tonumber(v.id) == tonumber(selectedPlayer))
    --     if selectedPlayer and selectedPlayer == v.id then -- for player switch
    --         sendData = v
    --         break;
    --         --print("sendData Semlected", v)
    --     end

    --     -- if no active player, select the first one
    --     if sendData == nil then
    --         sendData = v
    --         if v.active == 1 then
    --             break;
    --         end
    --     end
    -- end
    -- Wait(100)
    -- local charlist = tables
    -- --print("sendData", sendData)
    -- if sendData == nil then
    --     local FinalSend = CreatePlayerData(source, 0)
    --     return "ok"
    -- else
    --     MySQL.Async.execute('UPDATE players SET active = 0 WHERE license = @license AND id != @id', {
    --         ['@license'] = license,
    --         ['@id'] = sendData.id
    --     });
    --     LoadPlayerData(source, sendData, charlist)
    --     return "ok"
    -- end

    -- OLD NOT OPTI
    -- I DON'T REMOVE IT IN CASE IF WE WANT TO REVERT
    -- local FinalSend, charlist, gotperm = nil, nil, false

    -- MySQL.Async.fetchAll("SELECT * FROM players WHERE license = @license", {
    --     ["@license"] = license
    -- }, function(result)
    --     if result[1] == nil then
    --         FinalSend = CreatePlayerData(source, 0)
    --         gotperm = true
    --     elseif result[1].lastname == "" then
    --         MySQL.Async.execute("DELETE FROM players WHERE id = @id", {
    --             ["@id"] = result[1].id
    --         }, function(result)
    --         end)
    --         FinalSend = CreatePlayerData(source, 0)
    --         gotperm = true
    --     elseif result[1].lastname == "Wiped" and result[1].firstname == "Wiped" and result[1].active == 1 then
    --         FinalSend = UpdatePlayerData(source, result[1].id)
    --         gotperm = true
    --     else
    --         local tables = {}
    --         tables.characterList = {}
    --         local activeIndex = 1
    --         for k, v in pairs(result) do
    --             if v.active == 1 then
    --                 activeIndex = k
    --             end
    --             table.insert(tables.characterList, {id = v.id, name =  v.lastname .. " " .. v.firstname})
    --         end
    --         if not activeIndex then
    --             activeIndex = 1
    --         end
    --         charlist = tables
    --         -- On utilise plus le spawnmenu donc on passe direct sur l'id active
    --         -- On envoi juste la demande de refresh des persos coté client
    --         TriggerClientEvent("core:SpawnMenu", source, #GetPlayers())
    --         --while Answer[source] == nil do Wait(10) end
    --         FinalSend = result[activeIndex]
    --         Answer[source] = nil
    --     end
    -- end)

    -- while FinalSend == nil do Wait(150) end

    -- if FinalSend ~= nil and not gotperm then
    --     MySQL.Async.fetchAll("SELECT id, permission, balance, subscription, buyendDate FROM players_unique WHERE license = @license", {
    --         ["@license"] = license
    --     }, function(result)
    --         if (result[1] == nil) then
    --             MySQL.Async.insert("INSERT INTO players_unique (license, permission, fivem, discord, balance, subscription, buyendDate) VALUES (@license, @permission, @fivem, @discord, @balance, @subscription, @buyendDate)"
    --             , {
    --                 ["license"] = license,
    --                 ["discord"] = GetDiscord(source),
    --                 ["fivem"] = GetIDFiveM(source),
    --                 ["permission"] = 0,
    --                 ["balance"] = 0,
    --                 ["subscription"] = 0,
    --                 ["buyendDate"] = 0
    --             }, function(result)
    --                 table.insert(FinalSend, {permission = 0, balance = 0, subscription = 0, buyendDate = 0, discord = GetDiscord(source), fivem = GetIDFiveM(source)})
    --             end)
    --         else
    --             FinalSend.balance=result[1].balance
    --             FinalSend.permission=result[1].permission
    --             FinalSend.uid=result[1].id

    --             if result[1].buyendDate then
    --                 FinalSend.buyendDate = result[1].buyendDate
    --             else
    --                 FinalSend.buyendDate = 0
    --             end

    --             if result[1].buyendDate and result[1].buyendDate > 0 then
    --                 if result[1].subscription == 1 then
    --                     FinalSend.subscription = 1
    --                 elseif result[1].subscription == 2 then
    --                     FinalSend.subscription = 2
    --                 end
    --             else
    --                 FinalSend.subscription = 0
    --             end
    --         end
    --     end)
    --     while FinalSend.balance == nil do Wait(100) end
    --     LoadPlayerData(source, FinalSend, charlist)
    --     return "ok"
    -- elseif FinalSend ~= nil and gotperm then
    --     LoadPlayerData(source, FinalSend, charlist)
    --     return "ok"
    -- end
end

function SavePlayerData(source, isnewpersonnage)
    if GetPlayer(source) ~= nil then
        local obj = GetPlayer(source)
        if (obj:getFirstname() == "" or obj:getLastname() == "") or (obj:getFirstname() == "Wiped" or obj:getLastname() == "Wiped") then
            isnewpersonnage = true
        end
        if isnewpersonnage then
            MySQL.Async.execute("UPDATE players SET cloths = @1, tattoos = @2, degrader = @3, firstname = @15, lastname = @16, age = @17, sex = @18, size = @19, birthplaces = @20, inventaire = @5 , banque = @6 , permission = @7, job = @8, job_grade = @9, crew = @10, status = @12, active = @13, weapons = @14 WHERE license = @license AND id = @id"
                ,{
                    ["@1"] = json.encode(obj:getCloths()),
                    ["@2"] = json.encode(obj:getTattoos()),
                    ["@3"] = json.encode(obj:getDegrader()),
                    ["@5"] = json.encode(formatInventoryForBdd(obj:getInventaire())),
                    ["@6"] = obj:getBanque(),
                    ["@7"] = obj:getPermission(),
                    ["@8"] = obj:getJob(),
                    ["@9"] = obj:getJobGrade(),
                    ["@10"] = obj:getCrew(),
                    ["@12"] = json.encode(obj:getStatus()),
                    ["@13"] = json.encode(obj:getActive()),
                    ["@14"] = json.encode(obj:getWeapons()),
                    ["@license"] = obj:getLicense(),
                    ["@id"] = obj:getId(),
                    ["@15"] = obj:getFirstname(),
                    ["@16"] = obj:getLastname(),
                    ["@17"] = obj:getAge(),
                    ["@18"] = obj:getSex(),
                    ["@19"] = obj:getSize(),
                    ["@20"] = obj:getBirthplaces(),
                },
            function(affectedRows)
                obj:setNeedSave(false)
            end)
        else
            -- local patchForFemales = obj:getCloths()
            -- print("sex femme patch before:" .. patchForFemales.skin.sex)
            -- patchForFemales.skin.sex = obj:getSex() == "F" and 1 or 0
            -- print("sex femme patch after:" .. patchForFemales.skin.sex)
            MySQL.Async.execute("UPDATE players SET cloths = @1, tattoos = @2, degrader = @3, inventaire = @5 , banque = @6 , permission = @7, job = @8, job_grade = @9, crew = @10, status = @12, active = @13, weapons = @14, pos = @15 WHERE license = @license AND id = @id"
            ,{
                ["@1"] = json.encode(obj:getCloths()),
                ["@2"] = json.encode(obj:getTattoos()),
                ["@3"] = json.encode(obj:getDegrader()),
                ["@5"] = json.encode(formatInventoryForBdd(obj:getInventaire())),
                ["@6"] = obj:getBanque(),
                ["@7"] = obj:getPermission(),
                ["@8"] = obj:getJob(),
                ["@9"] = obj:getJobGrade(),
                ["@10"] = obj:getCrew(),
                ["@12"] = json.encode(obj:getStatus()),
                ["@13"] = json.encode(obj:getActive()),
                ["@14"] = json.encode(obj:getWeapons()),
                ["@15"] = json.encode(obj:getPos()),
                ["@license"] = obj:getLicense(),
                ["@id"] = obj:getId(),
            },
            function(affectedRows)
                obj:setNeedSave(false)
            end)

            MySQL.Async.execute("UPDATE players_unique SET permission = @perm, balance = @balance, subscription = @subscription, visionid = @visionid, discord = @discord, fivem = @fivem WHERE license = @license",
            {
                ["@license"] = obj:getLicense(),
                ["@discord"] = GetDiscord(source),
                ["@fivem"] = GetIDFiveM(source),
                ["@perm"] = obj:getPermission(),
                ["@balance"] = obj:getBalance(),
                ["@subscription"] = obj:getSubscription(),
                ["@visionid"] = VisionUniqueID(obj:getLicense(), GetDiscord(source))
            },
            function(affectedRows)
                obj:setNeedSave(false)
            end)

        end

        -- local offlinePlayer = GetOfflinePlayer(obj:getId())
        -- if offlinePlayer then
        --     offlinePlayer:update({
        --         id = obj:getId(),
        --         uid = obj:getUniqueId(),
        --         discord = GetDiscord(source),
        --         fivemid = GetIDFiveM(source),
        --         license = obj:getLicense(),
        --         firstname = obj:getFirstname(),
        --         lastname = obj:getLastname(),
        --         age = obj:getAge(),
        --         sex = obj:getSex(),
        --         birthplaces = obj:getBirthplaces(),
        --         inventaire = formatInventoryForPlayer(obj:getInventaire(), obj:getCrew(), obj:getHasvoted()),
        --         weapons = json.encode(obj:getWeapons()),
        --         cloths = json.encode(obj:getCloths()),
        --         tattoos = json.encode(obj:getTattoos()),
        --         degrader = json.encode(obj:getDegrader()),
        --         banque = obj:getBanque(),
        --         pos = json.encode(obj:getPos()),
        --         permission = obj:getPermission(),
        --         subscription = obj:getSubscription(),
        --         buyendDate = obj:getBuyendDate(),
        --         balance = obj:getBalance(),
        --         job = obj:getJob(),
        --         job_grade = obj:getJobGrade(),
        --         crew = obj:getCrew(),
        --         status = json.encode(obj:getStatus()),
        --         vip = obj:getVip(),
        --         active = obj:getActive(),
        --         lastProperty = json.encode(obj:getLastProperty())
        --     })
        -- else
        --     offlineplayers:new({
        --         id = obj:getId(),
        --         uid = obj:getUniqueId(),
        --         discord = GetDiscord(source),
        --         fivemid = GetIDFiveM(source),
        --         license = obj:getLicense(),
        --         firstname = obj:getFirstname() or "Inconnu",
        --         lastname = obj:getLastname() or "Inconnu",
        --         age = obj:getAge(),
        --         sex = obj:getSex(),
        --         birthplaces = obj:getBirthplaces(),
        --         inventaire = formatInventoryForPlayer((obj:getInventaire() or {}), obj:getCrew(), obj:getHasvoted()),
        --         weapons = json.encode(obj:getWeapons()),
        --         cloths = json.encode(obj:getCloths()),
        --         tattoos = json.encode(obj:getTattoos()),
        --         degrader = json.encode(obj:getDegrader()),
        --         banque = obj:getBanque() or 0,
        --         pos = json.encode(obj:getPos()),
        --         permission = obj:getPermission() or 0,
        --         subscription = obj:getSubscription() or 0,
        --         buyendDate = obj:getBuyendDate(),
        --         balance = obj:getBalance(),
        --         job = obj:getJob() or "aucun",
        --         job_grade = obj:getJobGrade(),
        --         crew = obj:getCrew() or "aucun",
        --         status = json.encode(obj:getStatus()),
        --         vip = obj:getVip(),
        --         active = obj:getActive() or 1,
        --         lastProperty = json.encode(obj:getLastProperty())
        --     }, obj:getLicense())
        -- end
    end
end

function formatInventoryForBdd(inventory)
    local formatedInventory = {}
    local optimizedMetadata = {}
    for k, v in pairs(inventory) do
        --print('formatInventoryForBdd1',json.encode(v))
        if (not v.metadatas) or next(v.metadatas) == nil then
            table.insert(formatedInventory, {name = v.name, count = v.count, uniqueId = v.uniqueId})
        else
            --[[
                haut:
                 d = drawableTshirtId
                 d2 = drawableArmsId
                 d3 = drawableTorsoId
                 v1 = variationTshirtId
                 v2 = variationTorsoId
                 v3 = variationArmsId
                else:
                 v = variationId
                 d = drawableId
                outfit.data
                 d = arms
                 a = arms_2
                 s = shoes_1
                 s2 = shoes_2
                 t = tshirt_1
                 t2 = tshirt_2
                 t3 = torso_1
                 t4 = torso_2
                 p = pants_1
                 p2 = pants_2
                 ]]
            if v.type == "clothes" and v.name ~= "outfit" then
                optimizedMetadata = {}
                --print("out", v.metadatas.premium, v.name)
                if v.name == "tshirt" then
                    optimizedMetadata = { renamed=v.metadatas.renamed, p = v.metadatas.premium or false, d=v.metadatas.drawableTshirtId, d2=v.metadatas.drawableArmsId , d3=v.metadatas.drawableTorsoId , v1=v.metadatas.variationTshirtId , v2=v.metadatas.variationTorsoId ,v3 =v.metadatas.variationArmsId}
                elseif v.name == "access" or v.name == "mask" then
                    --print("formatInventoryForBdd2",v.metadatas.drawableId)
                    optimizedMetadata = { name=v.metadatas.name, p = v.metadatas.premium or false, renamed=v.metadatas.renamed, d=v.metadatas.drawableId, v =v.metadatas.variationId}
                else
                    optimizedMetadata = { renamed=v.metadatas.renamed, p = v.metadatas.premium or false, d=v.metadatas.drawableId, v =v.metadatas.variationId}
                end
                --print(json.encode(v.metadatas))
            else
                optimizedMetadata = v.metadatas
            end
            --print('formatInventoryForBdd1',json.encode(optimizedMetadata))
            table.insert(formatedInventory, {name = v.name, count = v.count, metadatas = optimizedMetadata, uniqueId = v.uniqueId})
        end
    end
    --print("formatInventoryForBdd3",json.encode(formatedInventory))
    return formatedInventory
end

function SavePlayerPos(source)
    if GetPlayer(source) ~= nil then
        local obj = GetPlayer(source)
        sql.update("players", { { column = "pos", data = json.encode(obj:getPos()) } },
            { "license = '" .. obj:getLicense() .. "'", 'id = ' .. obj:getId() })
        -- CorePrint("Player " .. source .. " pos saved.")
        obj:setNeedSave(false)
    end
end

function MarkPlayerPosAsNonSaved(source)
    if GetPlayer(source) ~= nil then
        local player = GetPlayer(source)
        if not player:getNeedSave() then
            player:setNeedSave(true)
        end
    end
end

function MarkPlayerDataAsNonSaved(source)
    if GetPlayer(source) ~= nil then
        local player = GetPlayer(source)
        if not player:getNeedSave() then
            player:setNeedSave(true)
        end
    end
end

function RefreshPlayerData(source)
    local player = GetPlayer(source)
    TriggerLatentClientEvent("core:RefreshPlayerData", source, 25000, player)
    RefreshPlayerKeys(source)
    RefreshCarJob(source, player:getJob())
end

function addPlayerToAdminList(source)
    local player = GetPlayer(source)

    table.insert(vAdminPlayersList, {
        id = tonumber(source),
        name = GetPlayerName(source) or "Unknown",
        firstname = player:getFirstname() or "Unknown",
        lastname = player:getLastname() or "Unknown",
        permission = player:getPermission() or 0,
        license = player:getLicense(),
        discord = GetDiscord(source),
    })
end

function removePlayerFromAdminList(source)
    for k, v in pairs(vAdminPlayersList) do
        if v.id == source then
            table.remove(vAdminPlayersList, k)
            break
        end
    end
end

RegisterNetEvent("core:InitPlayer")
AddEventHandler("core:InitPlayer", function()
    local src = source
    GetPlayerData(src)

    local obj = GetPlayer(src)
    local discord = GetDiscord(src)
    local fivem = GetIDFiveM(src)

    obj:setDiscord(discord)
    obj:setFiveMID(fivem)

    checkIfPlayerIsInJail(src)

    local identifiers = PlayersIdentifierToString(src, true)
    if obj ~= nil and discord ~= nil and identifiers ~= nil then
        SendDiscordLog("connexionAdmin", src, string.sub(discord, 9, -1), obj:getFirstname() .. " " .. obj:getLastname()
            , identifiers)
        SendDiscordLog("connexion", src, string.sub(discord, 9, -1), obj:getFirstname() .. " " .. obj:getLastname()
            , PlayersIdentifierToString(src))
        --givekeytmp(obj:getId(), obj:getCrew(), obj:getJob(), src)
        SendPlayerStatistiques(src, identifiers)
        addPlayerToAdminList(src)
        if obj:getCrew() ~= "None" then
            TriggerEvent("core:UpdateCrewCount", obj:getCrew(), true)
        end

        local count = 0
        for k, v in pairs(json.decode(json.encode(obj:getInventaire()))) do
            if v.metadatas and tonumber(v.metadatas.removeTimestamp) then
                local timestamp = GlobalState.OsTime
                if tonumber(v.metadatas.removeTimestamp) < tonumber(timestamp) then
                    count = count + 1
                    print('Suppresion des items non existant', v.name)
                    RemoveItemToPlayer(src, v.name, v.count, v.metadatas)
                end
            end
        end
        if count > 0 then RefreshPlayerData(source) end

        if obj:getPermission() >= 69 then blacklistSearch[src] = true end

		local player = GetPlayer(src)

		local license = player:getLicense()

		MySQL.Async.execute("UPDATE players_unique SET last_connection = NOW() WHERE  `license`=@license", {
			['@license'] = license
		})
    end
end)

function triggerEventPlayer(eventName, source, ...)
    --print(eventName)
	TriggerClientEvent(eventName, source, ...)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        CorePrint("Resource stopping, saving players.")
        local sources = GetPlayers();
        local src, player;
        for k,v in pairs(sources) do
            src = tonumber(v);
            player = GetPlayer(src);
            if (type(player) == "table") then
                SavePlayerData(src);
            end
        end
        -- for k, v in pairs(players) do
        --     SavePlayerData(k)
        -- end
    end
end)

RegisterCommand("save", function(source)
    SavePlayerData(source)
    --RefreshPlayerData(source)

    -- New notif
    TriggerClientEvent("__atoshi::createNotification", source, {
        type = 'SYNC',
        -- duration = 5, -- In seconds, default:  4
        content = "~sSauvegarde de vos données"
    })

end)

local LeaveConfig = {
    ['timed out'] = 'Timed Out',
    ['crash'] = 'Crash',
    ['Exiting'] = 'F8 Quit / Ou simple déconnexion',
    ['Disconnected.'] = 'Déconnecté',
}

AddEventHandler("playerDropped", function(reason)
    local source = source
    local obj = GetPlayer(source)

    searched = false

    removePlayerFromAdminList(source)
    CorePrint("Player " .. source .. " dropped (" .. reason .. ").")
    if obj ~= nil then
        local discord = GetDiscord(source)
        local identifiers = PlayersIdentifierToString(source, true)
        TriggerEvent("core:playerTimer:stop", obj:getLicense(), obj:getId())
        saveJailTime(obj:getId())
        if obj:getCrew() ~= "None" then
            TriggerEvent("core:UpdateCrewCount", obj:getCrew(), false)
        end
        SendDiscordLog("deconnexionAdmin", source, string.sub(discord, 9, -1), obj:getFirstname() .. " " .. obj:getLastname(), obj:getId(), reason, GetEntityCoords(GetPlayerPed(source)), identifiers)
        SendDiscordLog("deconnexion", source, string.sub(discord, 9, -1), obj:getFirstname() .. " " .. obj:getLastname(), obj:getId(), reason, GetEntityCoords(GetPlayerPed(source)), PlayersIdentifierToString(source))
        TriggerEvent("core:closeDisconnectedPlayerReports", discord)
        if reason ~= "Exiting" and not string.find(reason, "Wipe") then
            SendPlayerCrashLog(source, reason, identifiers)
        end

        local sourcePed = GetPlayerPed(source)
        local pedCoords = GetEntityCoords(sourcePed)
        local searched = false
        for k, v in pairs(LeaveConfig) do
            if string.find(reason, k) then
                searched = true
                TriggerClientEvents('core:sendPlayerDroppedText', GetAllStaff(), { src = source, name = playerName, raison = v, coords = pedCoords})
                break
            end
        end
        if not searched then
            TriggerClientEvents('core:sendPlayerDroppedText', GetAllStaff(), { src = source, name = playerName, raison = reason, coords = pedCoords})
        end

        local ped = GetPlayerPed(source)
        obj:setPos(vector4(GetEntityCoords(ped), GetEntityHeading(ped)))

        --SavePlayerPos(source)
        if (not reason) or (not string.find(reason, "Wipe")) then
            SavePlayerData(source)
        end
        RemovePlayer(obj)
    end
end)

-- RegisterCommand("drawtest", function(source, args)
--     local sourcePed = GetPlayerPed(source)
--     local pedCoords = GetEntityCoords(sourcePed)
--     local permission = GetPlayer(source):getPermission()
--     local reason = args[1] or "Disconnected"
--     local searched = false

--     if permission < 6 then
--         for _, action in ipairs(adminActions) do
--             if string.find(reason, action) then
--                 searched = true
--                 break
--             end
--         end

--         if not searched then
--             for k, v in pairs(LeaveConfig) do
--                 if string.find(reason, k) then
--                     searched = true
--                     TriggerClientEvents('core:sendPlayerDroppedText', GetAllStaff(), { src = source, name = playerName, raison = v, coords = pedCoords})
--                     break
--                 end
--             end
--         end

--         if not searched then
--             TriggerClientEvents('core:sendPlayerDroppedText', GetAllStaff(), { src = source, name = playerName, raison = reason, coords = pedCoords})
--         end
--     end
-- end)


RegisterCommand("delvehplayer", function(source, args)
    local plate = args[2]
    local ply = GetPlayer(tonumber(args[1]))
    if source == 0 or GetPlayer(source):getPermission() >= 5 then
        local veh = GetVehicle(plate)
        if veh ~= nil then
            SendDiscordLog("forceDeleteVehicle", veh:getOwner(),
                plate, veh:getName(), string.sub(GetDiscord(source), 9, -1), string.sub(GetDiscord(source), 9, -1))
            veh:deleteVehicle()
            RemoveVehicle(plate)
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'SYNC',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Le véhicule a bien été supprimé !"
            })
            -- Rien à foutre de l'opti comme dis Flo, je suis payé tous les 4 mois
            if not ply then return end
            for k, v in pairs(ply:getInventaire()) do
                if v.name == "keys" then
                    if v.metadatas.plate == plate then
                        RemoveItemToPlayer(ply:getSource(), v.name, 1, v.metadatas)
                    end
                end
            end
        else
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Un véhicule qui existe serait bien mieux non ?"
            })
        end
    else
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Tu es qui ?"
        })
    end

end)

Citizen.CreateThread(function()
    while true do
        Wait(5 * 60000)
        local sources = GetPlayers();
        local src, player;
        for i = 1, #sources do
            src = tonumber(sources[i]);
            player = GetPlayer(src);
            if (type(player) == "table" and player:getNeedSave()) then
                SavePlayerData(src);
                if (GetPlayerPing(src) == 0) then
                    RemovePlayer(player);
                end
                Wait(1000);
            end
        end
        -- for k, v in pairs(players) do
        --     local obj = v
        --     if obj:getNeedSave() then
        --         SavePlayerData(k)
        --         if GetPlayerPing(k) == 0 then
        --             players[k] = nil
        --             RemovePlayer(v)
        --         end
        --         Wait(1000)
        --     end
        -- end
    end
end)

RegisterNetEvent("core:RestaurationInventaireDeBgplayer")
AddEventHandler("core:RestaurationInventaireDeBgplayer", function()
    local count = nil
    local source = source
    for k, v in pairs(GetPlayer(source):getInventaire()) do
        if v.name == "money" then
            v.count = math.floor(v.count + 0.5)
        end
        if v.metadatas == nil then
            count = v.count
            RemoveItemFromInventoryNil(source, v.name, v.count, v.metadatas)
        end
        if v.name == "money" and v.metadatas == nil then
            count = v.count
            RemoveItemFromInventoryNil(source, v.name, v.count, v.metadatas)
            for key, value in pairs(GetPlayer(source):getInventaire()) do
                if value.name == "money" and value.metadatas ~= nil then
                    AddItemToInventory(source, value.name, count, value.metadatas)
                end
            end
        end
        if v.name == "tshirt" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "outfit" and v.count > 1 then
            RemoveClothFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "pant" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "glasses" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "feet" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "bague" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "ongle" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "piercing" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "montre" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "bracelet" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "bouclesoreilles" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "collier" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "mask" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "hat" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        elseif v.name == "access" and v.count > 1 then
            RemoveItemFromInventory(source, v.name, v.count, v.metadatas)
            AddItemToInventory(source, v.name, 1, v.metadatas)
        end
    end
end)

RegisterNetEvent("core:getPlayerHealth")
AddEventHandler("core:getPlayerHealth", function(health)
    GetPlayer(source):setHealth(health)
end)

RegisterServerCallback("core:GetAllPersonnage", function(source)
    return GetPlayer(source):getIdPerso()
end)

RegisterServerCallback("core:GetAllPersonnageNumber", function(source)
    return GetPlayer(source):getNumPerso()
end)

RegisterServerCallback("core:GetPlayersJob", function()
    return getAllPlayerJobs()
 end)

-- RegisterServerCallback('core:player:deleteOfflinePlayerFromBddForSaculBecauseHeAskForTodayAndHeDontWantToBreakAllTheServer', function(source, idbdd)
--     local ret = true
--     result = MySQL.Async.execute("DELETE FROM players WHERE id = @idbdd"
--         , {
--         ['@idbdd'] = idbdd,
--     }, function(rowsChanged)
--         if rowsChanged == 0 then
--             ret = false
--         else
--             MySQL.Async.execute("DELETE FROM bank WHERE player = @sacul", { ['@sacul'] = idbdd })
--             MySQL.Async.execute("DELETE FROM crew_members WHERE player_id = @sacul", { ['@sacul'] = idbdd })
--             MySQL.Async.execute("DELETE FROM license WHERE id_player = @sacul", { ['@sacul'] = idbdd })
--             MySQL.Async.execute("DELETE FROM vehicles WHERE owner = @sacul AND job IS NULL", { ['@sacul'] = idbdd })
--             MySQL.Async.execute("DELETE FROM players WHERE id = @sacul", { ['@sacul'] = idbdd })
--             MySQL.Async.execute("DELETE FROM phone_phones WHERE id = @sacul", { ['@sacul'] = idbdd })
--             -- update property for owner and co-owner by the column license - the co owner lose the property also check with wiped player before
--             MySQL.Async.execute("UPDATE property SET owner = @1, co_owner = @2, rentedAt = @3, rentalEnd = @4, type = @5 WHERE owner = @sacul and type = @type"
--             , {
--                 ["@1"] = nil,
--                 ["@2"] = nil,
--                 ["@3"] = nil,
--                 ["@4"] = nil,
--                 ["@5"] = nil,
--                 ["@sacul"] = idbdd,
--                 ["@type"] = "Individuel"
--             })
--         end
--     end)
--     return ret
-- end)

RegisterServerCallback('core:lifeinvader:getData', function(source)
    local data = {
        discord = string.sub(GetDiscord(source), 9, -1),
        uniqueId = GetPlayer(source):getId(),
    }

    return data
end)

RegisterNetEvent("core:NewPersonnage")
AddEventHandler("core:NewPersonnage", function()
    local source = source
    local player = GetPlayer(source);
    if (not player) then return; end
    local license = player:getLicense()
    local idbdd = player:getId()
    player:setActive(0)
    local perm = player:getPermission()
    local persos = player:getNumPerso()
    SavePlayerPos(source)
    SavePlayerData(source, true)
    RemovePlayer(player)
    --RemovePlayerOffline(license, idbdd)

    CreatePlayerData(source, perm, persos)
end)

RegisterNetEvent("core:Switch")
AddEventHandler("core:Switch", function(id)
    local source = source
    local player = GetPlayer(source);
    player:setActive(0)
    SavePlayerPos(source)
    SavePlayerData(source)
    RemovePlayer(player)
    SetPlayerToActive(source, id)
end)

function SetPlayerToActive(source, id)
    MySQL.Async.execute("UPDATE players SET active = @1 WHERE license = @license AND id = @id"
            ,{
                ["@1"] = 1,
                ["@license"] = GetLicense(source),
                ["@id"] = id,
            },
            function(affectedRows)
                switchPlayer(source, id)
                CorePrint("Player " .. source .. " saved for switch.")
            end)
end

function switchPlayer(source, id)
    local src = source
    GetPlayerData(src, id)
end

function GetLoadedPlayerFromId(id)
    -- for k, v in pairs(players) do
    --     if v:getId() == id then
    --         return v
    --     end
    -- end
    return GetPlayerById(id) -- Wrapper for the moment
end

function GetPlayerFromId(id)
    -- for k, v in pairs(players) do
    --     if v:getId() == id then
    --         return {crew = v.crew, job = v.job, inclass = true}
    --     end
    -- end
    local player = GetPlayerById(id)
    if (player) and type(player) == "table" then
        return {crew = player.crew, firstname = player.firstname, lastname = player.lastname, job = player.job, inclass = true}
    end
    -- if player not loaded, load it
    -- Only take job & crew because we only need this for the moment (you can add more if you want)
    return MySQL.Sync.fetchAll("SELECT crew, job, firstname, lastname FROM players WHERE id = @id LIMIT 1", { ["@id"] = id })[1]
end

RegisterServerCallback("core:GetPlayerDiscordId", function(source)
    return GetDiscord(source)
end)

-- RegisterCommand("debugPlayer", function(source, args)
--     local license = args[1]
--     if not license then
--         license = GetLicense(source)
--     end
--     RemoveAllOfflinePlayers(license)
-- end)

-- RegisterCommand("switchPerso", function(source, args)
--     if source == 0 or GetPlayer(source):getPermission() >= 5 then
--         local license = args[1]
--         local idbdd = tonumber(args[2])
--         local target = GetPlayerByLicense(license)
--         if (target) then
--             print('Ce joueur est connecté, merci de l\'inviter à se déconnecter avant d\'effectuer cette action')
--             return;
--         end
--         -- Get les offline player par rapport a la license et mettre tout les personnage en active = 0 sauf celui qui est en idbdd
--         local offlinePlayers = GetOfflinePlayers(license)
--         for k, v in pairs(offlinePlayers) do
--             if v.id == idbdd then
--                 local affectedRows = MySQL.Sync.execute("UPDATE players SET active = @1 WHERE license = @license AND id = @id",{
--                     ["@1"] = 1,
--                     ["@license"] = license,
--                     ["@id"] = idbdd,
--                 });
--                 if (affectedRows == 0) then
--                     CorePrint("Player " .. idbdd .. " not found for switch.")
--                 else
--                     v.active = 1;
--                     MySQL.Sync.execute("UPDATE players SET active = 0 WHERE license = @license AND id != @id", {
--                         ['@id'] = idbdd,
--                         ['@license'] = license
--                     });
--                     CorePrint("Player " .. idbdd .. " saved for switch active.")
--                 end
--                 break;
--             end
--         end
--     end
-- end)
