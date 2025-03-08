---@class player
---@field public id number
---@field public uid number
---@field public discord string
---@field public fivemid string
---@field public source number
---@field public license string
---@field public firstname string
---@field public lastname string
---@field public age string
---@field public sex "M" | "F"
---@field public size number
---@field public birthplaces string
---@field public inventaire table
---@field public weapons table
---@field public cloths PlayerClothes
---@field public tattoos table
---@field public degrader table
---@field public banque number
---@field public pos table
---@field public permission number
---@field public balance number
---@field public subscription number
---@field public buyendDate number
---@field public job string
---@field public job_grade number
---@field public crew string
---@field public crewType string
---@field public status PlayerStatus
---@field public vip number
---@field public needSave boolean
---@field public needPosSave boolean
---@field public active number
---@field public idPerso table
---@field public idPersoNum table
---@field public lastProperty table
---@field public hasvoted number
player = {}

player.__index = player

---@type table<number, player>
local p = {}
---@type table<number, number>
local uids = {};
---@type table<number, number>
local ids = {};
---@type table<string, number>
local discordIds = {};
---@type table<string, number>
local fivemIds = {};
---@type table<string, number>
local licenses = {};

---@return player
function GetPlayer(source)
    return p[source]
end

-- Ne jamais use
function GetAllPlayers()
    return p
end

-- A utiliser que dans la boutique
---@param uid number
---@return player
function GetPlayerByUniqueID(uid)
    -- local idbdd = 0
    -- for k,v in pairs(p) do
    --     if tonumber(v.uid) == tonumber(uid) then
    --         idbdd = v
    --         break
    --     end
    -- end
    return p[uids[uid] --[[ Get Player source by uniqueId ]]] --[[ Returns player associated with this uniqueId ]] or 0;
end

---@param id number
---@return player
function GetPlayerById(id)
    -- local player = nil
    -- for k,v in pairs(p) do
    --     if tonumber(v.id) == tonumber(id) then
    --         player = v
    --         break
    --     end
    -- end
    return p[ids[id] --[[ Get Player source by id ]]] --[[ Returns player associated with this id ]] or 0;
end

---@param duid string
---@return player
function GetPlayerByDiscord(duid)
    -- local discord = 0

    -- for k,v in pairs(p) do
    --     if v.discord == duid then
    --         discord = v
    --         break
    --     end
    -- end
    return p[discordIds[duid] --[[ Get Player source by discordId ]]] --[[ Returns player associated with this discordId ]] or 0;
end

---@param fmid string
---@return player
function GetPlayerByFiveMID(fmid)
    -- local fivem = 0

    -- for k,v in pairs(p) do
    --     -- print('ALL : ' .. v.fivemid)
    --     if v.fivemid == fmid then
    --         fivem = v
    --         break
    --     end
    -- end
    return p[fivemIds[fmid]] or 0;
end

---@param license string
---@return player
function GetPlayerByLicense(license)
    return p[licenses[license]];
end

---@param playerObj player
function RemovePlayer(playerObj)
    if (type(playerObj) ~= "table") then
        return;
    end
    if (p[playerObj.source]) then
        p[playerObj.source] = nil;
    end
    if (uids[playerObj.uid]) then
        uids[playerObj.uid] = nil;
    end
    if (ids[playerObj.id]) then
        ids[playerObj.id] = nil;
    end
    if (playerObj.discord) and (discordIds[playerObj.discord]) then
        discordIds[playerObj.discord] = nil;
    end
    if (playerObj.fivemid) and (fivemIds[playerObj.fivemid]) then
        fivemIds[playerObj.fivemid] = nil;
    end
    if (playerObj.license) and (licenses[playerObj.license]) then
        licenses[playerObj.license] = nil;
    end
end

---@return player
function player:new(data, default, source, perm)
    local self = setmetatable({}, player)
    if not default then
        self.id = data.id
        self.uid = data.uid
        self.discord = data.discord
        self.fivemid = data.fivemid
        self.source = source
        self.license = data.license
        self.firstname = data.firstname
        self.lastname = data.lastname
        self.age = data.age
        self.sex = data.sex
        self.size = data.size;
        self.birthplaces = data.birthplaces
        self.inventaire = formatInventoryForPlayer((type(data.inventaire) == "string" and json.decode(data.inventaire) or data.inventaire), data.crew, data.hasvoted)
        if data.weapons == nil then
            self.weapons = {}
        else
            self.weapons = type(data.weapons) == "string" and json.decode(data.weapons) or deepcopy(data.weapons)
        end
        self.cloths = type(data.cloths) == "string" and json.decode(data.cloths) or deepcopy(data.cloths)
        self.tattoos = type(data.tattoos) == "string" and json.decode(data.tattoos) or deepcopy(data.tattoos)
        self.degrader = type(data.degrader) == "string" and json.decode(data.degrader) or deepcopy(data.degrader)
        self.banque = data.banque
        self.pos = type(data.pos) == "string" and json.decode(data.pos) or deepcopy(data.pos)
        self.permission = data.permission
        self.subscription = data.subscription
        self.buyendDate = data.buyendDate or 0
        self.balance = data.balance
        self.job = data.job
        self.job_grade = data.job_grade
        self.crew = data.crew
        self.crewType = getCrewByName(data.crew) and getCrewByName(data.crew):getType() or "Normal"
        self.status = type(data.status) == "string" and json.decode(data.status) or data.status
        self.vip = data.vip
        self.needSave = false
        self.needPosSave = false
        self.active = data.active or 1
        self.idPerso = {}
        self.idPersoNum = {}
        if self.cloths.cloths == nil then
            self.cloths.cloths = {}
        end
        self.lastProperty = type(data.lastProperty) == "string" and json.decode(data.lastProperty) or data.lastProperty
        self.hasvoted = 1
        -- local patchForFemales = json.decode(data.cloths)
        -- patchForFemales.skin.sex = data.sex == "F" and 1 or 0
        -- self.cloths = patchForFemales
        -- print("sex start femme patch after:" .. patchForFemales.skin.sex, self.cloths.skin.sex)
    else
        self.source = source
        self.firstname = ""
        self.lastname = ""
        self.age = "02/01/2000"
        self.sex = ""
        self.size = 180
        self.birthplaces = ""
        self.inventaire = {}
        self.weapons = {}
        self.cloths = { skin = {}, cloths = {} }
        self.tattoos = {}
        self.degrader = {}
        self.banque = 5000
        self.pos = Config.defaultPos
        self.permission = perm or 0
        self.subscription = data.subscription
        self.buyendDate = data.buyendDate or 0
        self.balance = data.balance
        self.job = "aucun"
        self.job_grade = 1
        self.crew = "None"
        self.crewType = "Normal"
        self.status = { hunger = 99, thirst = 99, health = 200 }
        self.vip = 0
        self.needSave = false
        self.needPosSave = false
        self.active = 1
        self.idPerso = {}
        self.idPersoNum = {}
        self.license = GetLicense(source)
        self.discord = GetDiscord(source)
        self.fivemid = GetIDFiveM(source)
        self.hasvoted = 1
    end
    p[source] = self
    if (self.uid) then
        uids[self.uid] = source;
    end
    if (self.id) then
        ids[self.id] = source;
    end
    if (self.license) and (self.license ~= "" and self.license ~= "license:000000000000000000000000000000000000") then
        licenses[self.license] = source;
    end
    if (self.discord) and (self.discord ~= "discord:000000000000000000") then
        discordIds[self.discord] = source;
    end
    if (self.fivemid) and (self.fivemid ~= "fivem:0000InvalideTaCapte") then
        fivemIds[self.fivemid] = source;
    end

    return self
end

--getters and setters

function player:getId()
    return self.id
end

function player:getUniqueId()
    return self.uid
end

---@param uid number
function player:setUniqueId(uid)
    self.uid = uid;
    return self;
end

---@param id number
function player:setId(id)
    self.id = id;
    return self;
end

---@param source number
function player:setSource(source)
    self.source = source;
    return self;
end

function player:getSource()
    return self.source
end

---@param license string
function player:setLicense(license)
    self.license = license;
    return self;
end

function player:getLicense()
    return self.license
end

---@param discord string
function player:setDiscord(discord)
    self.discord = discord;
    return self;
end

function player:getDiscord()
    return self.discord
end

---@param fivem string
function player:setFiveMID(fivem)
    self.fivemid = fivem;
    return self;
end

function player:getFiveMID()
    return self.fivemid
end

function player:getFirstname()
    return self.firstname
end

---@param firstname string
function player:setFirstname(firstname)
    self.firstname = firstname;
    return self;
end

function player:getLastname()
    return self.lastname
end

---@param lastname string
function player:setLastname(lastname)
    self.lastname = lastname;
    return self;
end

function player:getAge()
    return self.age;
end

---@param age string
function player:setAge(age)
    self.age = age;
    return self;
end

function player:getSex()
    return self.sex
end

---@param sex "M" | "F"
function player:setSex(sex)
    self.sex = sex;
    return self;
end

function player:getSize()
    return self.size
end

---@param size number
function player:setSize(size)
    self.size = size;
    return self;
end

function player:getBirthplaces()
    return self.birthplaces
end

---@param birthplaces string
function player:setBirthplaces(birthplaces)
    self.birthplaces = birthplaces;
    return self;
end

---@param inventaire table
function player:setInventaire(inventaire)
    self.inventaire = inventaire;
    return self;
end

function player:getInventaire()
    return self.inventaire
end

function player:GetId()
    return self.id
end

function player:getId() -- copie de GetId() pour fix les fautes de frappes maj
    return self.id
end

---@param id number
function player:setId(id)
    self.id = id;
    return self;
end

function player:getSkin()
    return self.cloths.skin
end

function player:getCloths()
    return self.cloths
end

function player:getTattoos()
    return self.tattoos
end
function player:GetGradender()
    return self.degrader
end

---@param degrade table
function player:setGradender(degrade)
    self.degrader = degrade;
    return self;
end
function player:idPersonnage()
    return self.idPerso
end

---@param data table
function player:setidPersonnage(data)
    self.idPerso = data;
    return self;
end

function player:getBanque()
    return self.banque
end

function player:getPos()
    return self.pos
end

function player:getPermission()
    return self.permission
end

function player:getBalance()
    return self.balance
end

---@param newbalance number
function player:setBalance(newbalance)
    self.balance = newbalance;
    return self;
end

function player:getSubscription()
    return self.subscription
end

function player:getBuyendDate()
    return self.buyendDate
end

---@param inte number
function player:setBuyendDate(inte)
    self.buyendDate = inte;
    return self;
end

---@param inte number
function player:setSubscription(inte)
    self.subscription = inte;
    return self;
end

function player:getJob()
    return self.job
end

function player:getJobGrade()
    return self.job_grade
end

function player:getCrew()
    return self.crew
end

function player:getNeedSave()
    return self.needSave
end

function player:getWeapons()
    return self.weapons
end

---@param weapon table
function player:setWeapons(weapon)
    self.weapons  = weapon;
    return self;
end

---@param cloths PlayerClothes
function player:setCloths(cloths)
    self.cloths = cloths;
    return self;
end

function player:getCloths()
    return self.cloths
end

---@param skin table
function player:setSkin(skin)
    self.cloths.skin = skin;
    return self;
end

function player:getSkin()
    return self.cloths.skin
end

---@param cloths table
function player:setClothsCloths(cloths)
    self.cloths.cloths = cloths;
    return self;
end

function player:getClothsCloths()
    return self.cloths.cloths
end

---@param tattoo table
function player:setTattoos(tattoo)
    self.tattoos = tattoo;
    return self;
end

function player:getTattoos()
    return self.tattoos;
end

function player:getDegrader()
    return self.degrader;
end

---@param degrader table
function player:setDegrader(degrader)
    self.degrader = degrader;
    return self;
end

---@param banque number
function player:setBanque(banque)
    self.banque = banque;
    return self;
end

function player:getBanque()
    return self.banque
end

---@param pos table
function player:setPos(pos)
    self.pos = pos;
    return self;
end

function player:getPos()
    return self.pos
end

function player:getPermission()
    return self.permission
end

---@param permission number
function player:setPermission(permission)
    self.permission = permission;
    return self;
end

---@param job string
function player:setJob(job)
    self.job = job;
    return self;
end

function player:getJob()
    return self.job
end

---@param job_grade number
function player:setJobGrade(job_grade)
    self.job_grade = job_grade;
    return self;
end

function player:getJobGrade()
    return self.job_grade
end

---@param crew string
function player:setCrew(crew)
    self.crew = crew;
    return self;
end

function player:getCrew()
    return self.crew
end

---@param vip number
function player:setVip(vip)
    self.vip = vip;
    return self;
end

function player:getVip()
    return self.vip;
end

---@param status PlayerStatus
function player:setStatus(status)
    self.status = status;
    return self;
end

function player:getStatus()
    return self.status
end

---@param hunger number
function player:setHunger(hunger)
    self.status.hunger = hunger;
    return self;
end

function player:getHunger()
    return self.status.hunger
end

---@param thirst number
function player:setThirst(thirst)
    self.status.thirst = thirst;
    return self;
end

function player:getThirst()
    return self.status.thirst
end

---@param health number
function player:setHealth(health)
    self.status.health = health;
    return self;
end

function player:getHealth()
    return self.status.health
end

---@param status boolean
function player:setNeedSave(status)
    self.needSave = status;
    return self;
end

function player:getNeedSave()
    return self.needSave
end

---@param status boolean
function player:setNeedPosSave(status)
    self.needPosSave = status;
    return self;
end

function player:getNeedPosSave()
    return self.needPosSave;
end

---@param num number
---@return boolean
function player:haveEnoughMoney(num)
    for k,v in pairs(self:getInventaire()) do
        if v.name == "money" then
            if v.count >= tonumber(num) then
                return true;
            end
            return false;
        end
    end
end

function player:getStatus()
    return self.status;
end

---@param active number
function player:setActive(active)
    self.active = active;
    return self;
end

function player:getActive()
    return self.active
end

---@param idPerso table
function player:setIdPerso(idPerso)
    self.idPerso = idPerso;
    return self;
end

---@param idPersoNum table
function player:setNumPerso(idPersoNum)
    self.idPersoNum = idPersoNum;
    return self;
end

function player:getIdPerso()
    return self.idPerso
end

function player:getNumPerso()
    return self.idPersoNum
end

---@param lastProperty table
function player:setLastProperty(lastProperty)
    self.lastProperty = lastProperty;
    return self;
end

function player:getLastProperty()
    return self.lastProperty
end

---@param hasvoted 0 | 1
function player:setHasvoted(hasvoted)
    self.hasvoted = hasvoted
    return self;
end

function player:getHasvoted()
    return self.hasvoted;
end
-- weapons

---@param weaponName string
---@return boolean
function player:DoesWeaponExist(weaponName)
    if weapons[weaponName] ~= nil then
        return true;
    end
    return false;
end

---@param weaponName string
---@return table
function player:GetWeaponData(weaponName)
    return weapons[weaponName];
end

---@param weaponName string
---@return boolean
function player:HaveWeapon(weaponName)
    if self.weapons[weaponName] ~= nil then
        return true;
    end
    return false;
end

---@deprecated
---@param weaponName string
---@param ammo number
---@return boolean, string
function player:AddWeaponIfPossible(weaponName, ammo)
    if self:DoesWeaponExist(weaponName) then
        -- if not self:HaveWeapon(weaponName, ammo) then
        --     local weapon = self:GetWeaponData(name)
        --     self.weapons[weaponName] = {
        --         ammo = ammo,
        --         hash = weapon.hash,
        --         nameGXT = weapon.NameGXT,
        --         descGXT = weapon.DescriptionGXT,
        --         name = weaponName,
        --     }
        --     return true;
        -- end
        -- return false, "Possède déja l'arme"
    else
        return false, "Arme inconnu"
    end
end

---@param weaponName
---@param ammo number
---@return boolean
function player:SetWeaponAmmo(weaponName, ammo)
    if self:HaveWeapon(weaponName) then
        self.weapons[weaponName].ammo = ammo;
        return true;
    end
    return false;
end

---@param weaponName string
---@param components string
---@param option any
---@return boolean
function player:SetWeaponComponents(weaponName, components, option)
    if self:HaveWeapon(weaponName) then

        if components == 'suppressor' then
            self.weapons[weaponName].metadatas.suppressor = option
            --[[ print("OK SERVER SUPPRESSOR") ]]
        elseif components == 'flashlight' then
            self.weapons[weaponName].metadatas.flashlight = option
            --[[ print("OK SERVER FLASHLIGHT") ]]
        elseif components == 'grip' then
            self.weapons[weaponName].metadatas.grip = option
            --[[ print("OK SERVER GRIP") ]]
        end
        return true
    else
        return false
    end
end

---@param name string
---@return boolean
function player:RemoveWeapon(name)
    if self:HaveWeapon(name) then
        self.weapons[name] = nil;
        return true;
    end
    return false;
end

--- TODO : Watch if needed
function player:GiveWeaponIfPossible(name, source, target)
    if self:HaveWeapon(name) then
        -- TODO
        if not GetPlayer(target):HaveWeapon(name) then
            local weapon = GetPlayer(target):GetWeaponData(name)
            GetPlayer(target).weapons[name] = {
                ammo = self.weapons[name].ammo,
                hash = weapon.hash,
                nameGXT = weapon.NameGXT,
                descGXT = weapon.DescriptionGXT,
            }
            self:RemoveWeapon(name)
        else
            --TriggerClientEvent("core:ShowNotification", source, "La personne possède déja l'arme")
            TriggerClientEvent("__atoshi::createNotification", source, {
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s La personne possède déja l'arme"
            })
        end
    else
        --TriggerClientEvent("core:ShowNotification", source, "Vous ne possède pas l'arme")
        TriggerClientEvent("__atoshi::createNotification", source, {
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~s Vous ne possède pas l'arme"
        })
    end
end

-- bannk fct

function player:HaveMoneyAccount()
    if self.banque >= 0 then
        return true
    else
        return false
    end
end

---@param money number
function player:AddMoneyAccount(money)
    self.banque = self:getBanque() + money;
    return self;
end


function player:GetMoney()
    for k, v in pairs(player:getInventaire()) do
        if v.name == money then
            return v.count
        end
    end
    return 0
end

---@param money number
---@return boolean
function player:RemoveMoneyAccount(money)
    if self:getBanque() >= money then
        self.banque = self:getBanque() - money
        return true
    else
        return false
    end
end

-- players fct

function player:isMale()
    if p:getSex() == "M" then
        return true
    else
        return false
    end
end

function player:getFullName()
    return self:getFirstname() .. " " .. self:getLastname()
end

function getAllPlayerJobs()
    local playerJob = {}
    for k, v in pairs(p) do
        if v ~= nil then
            if v.permission >= 1 then
                playerJob[tonumber(v.source)] = 2
            elseif v.job == "lspd" or v.job == "lssd" or v.job == "usss" or v.job == "bp" or v.job == "lsfd" then
                playerJob[tonumber(v.source)] = 3
            -- elseif checkCrew(v.crew) then
            --     playerJob[tonumber(v.source)] = 1
            end
        end
    end
    return playerJob
end

function formatInventoryForPlayer(inventory, crew, hasvoted)
    local sanatizedInventory = {}
    local itemSelected
    local optimizedMetadata = {}
    for k, v in pairs(inventory) do
        itemSelected = items[v.name]
        if itemSelected and v.name and itemSelected.type and itemSelected.cols and itemSelected.rows and v.count and itemSelected.label and itemSelected.weight then
            --print(json.encode(itemSelected))
            --[[
                haut
                 d = drawableTshirtId
                 d2 = drawableArmsId
                 d3 = drawableTorsoId
                 v1 = variationTshirtId
                 v2 = variationTorsoId
                 v3 = variationArmsId
                 else:
                 v = variationId
                 d = drawableId
                 for all:
                 p = premium
            ]]
            if itemSelected.type == "clothes" and v.name ~= "outfit" and v.metadatas and v.metadatas.d then
                optimizedMetadata = {}
                if v.name == "tshirt" then
                    optimizedMetadata = { renamed=v.metadatas.renamed, premium = v.metadatas.p or false, drawableTshirtId=v.metadatas.d, drawableArmsId=v.metadatas.d2 , drawableTorsoId=v.metadatas.d3 , variationTshirtId=v.metadatas.v1 , variationTorsoId=v.metadatas.v2 ,variationArmsId =v.metadatas.v3}
                elseif v.name == "access" or v.name == "mask" then
                    optimizedMetadata = { name=v.metadatas.name, premium = v.metadatas.p or false, renamed=v.metadatas.renamed, drawableId=v.metadatas.d, variationId =v.metadatas.v}
                else
                    optimizedMetadata = { renamed=v.metadatas.renamed, premium = v.metadatas.p or false, drawableId=v.metadatas.d, variationId=v.metadatas.v}
                end
                --v.metadatas = {}
            else
                optimizedMetadata = v.metadatas and v.metadatas or {}
            end
            --print("formatInventoryForPlayer4", json.encode(optimizedMetadata))
            -- print(hasvoted == 0 and itemSelected.type == "weapons", hasvoted, itemSelected.type, crew)
            -- if hasvoted == 0 and itemSelected.type == "weapons"then
            --     print("delete weapons", crew, v.name)
            -- else
            --     print("not wp", hasvoted)
            table.insert(sanatizedInventory, {metadatas=optimizedMetadata,name=v.name,type=itemSelected.type,cols=itemSelected.cols,rows=itemSelected.rows,count=v.count,label=itemSelected.label,weight=optimizedMetadata.premium and 0.0 or itemSelected.weight})
            --end
        end
    end
    return sanatizedInventory
end

GetPlayer = function(source)
    return p[source]
end

-- export

exports('GetPlayer', function()
    return p
end)

exports('GetPlayerTarget', function(target)
    return p[target]
end)

exports('GetMoneyPlayer', function(source)
    return GetPlayer(source):GetMoney()
end)

exports('GetPlayerJob', function(source)
    return GetPlayer(source):getJob()
end)

exports('GetPlayerPerm', function(source)
    while GetPlayer(source) == nil do Wait(1000) end

    if GetPlayer(source) then
        return GetPlayer(source):getPermission()
    else
        return 0
    end
end)

GetPlayerPerm = function(source) -- NE PAS TOUCHER SVPPPP -- je touche tu vas faire quoi???
    local perm
    if GetPlayer(source) then
        perm = GetPlayer(source):getPermission()
    else
        perm = 0
    end
    return perm
end

function GetAllplayer()
    return p
end

function GetOnlinePlayer()
    local players = {}
    for k, v in pairs(p) do
        table.insert(players, { idbdd = v.id, id = v.source, license = v.license, firstname = v.firstname, lastname = v.lastname })
    end
    return players
end

function GetAllPlayersWithPerm(perm)
    local players = {}
    for k, v in pairs(p) do
        if v.permission >= perm then
            table.insert(players, {unique_id = v.id, source = v.source, permission = v.permission, firstname = v.firstname, lastname = v.lastname})
        end
    end
    return players
end

exports('GetPlayerIdbdd', function(source)
    while GetPlayer(source) == nil do Wait(1000) end
    return GetPlayer(source):GetId()
end)

exports('GetPlayerFullname', function(source)
    return GetPlayer(source):getFirstname() .. " " .. GetPlayer(source):getLastname()
end)
