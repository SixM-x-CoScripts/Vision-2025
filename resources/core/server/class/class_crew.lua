crew = {
    id = 0, ---@private
    name = "", ---@private
    devise = "", ---@private
    perms = {exclure = 1, sendDm = 1, editPerm = 1, editMembres = 1, recrute = 1}, ---@private
    typeCrew = "normal", ---@private
    color = "#ffffff", ---@private
    xp = 0, ---@private
    members = {}, ---@private
    roles = {}, ---@private
    needSave = false, ---@private
    needSaveMembers = false, ---@private
    needSaveRoles = false, ---@private
}

crewTab = {}

crew.__index = crew

local classCrew = {} ---@type crew

---@return crew
function GetCrew(id)
    return classCrew[id]
end

--@return crew
function GetAllCrews()
    return classCrew
end

function RemoveCrew(id)
    classCrew[id] = nil
end

---@return crew
function crew:new(data)
    local self = setmetatable({}, crew)
    self.id = data.id
    self.name = data.name
    self.devise = data.devise
    self.perms = json.decode(data.perms)
    self.typeCrew = data.typeCrew
    self.color = data.color
    self.xp = data.xp
    self.members = getMembers(data.id)
    self.roles = getRoles(data.id)
    self.needSave = false
    self.needSaveMembers = false
    self.needSaveRoles = false
    if data.typeCrew ~= "normal" then
        crewTab[data.name] = true
    end
    --CorePrint("Le crew " .. self.name .."/".. self.id .. " a été chargé")
    classCrew[data.id] = self
    return self
end

--crew methods

function crew:getId()
    return self.id
end

---@private
function crew:setName(name)
    self:setNeedSave(true)
    self.name = name
end

function crew:getName()
    return self.name
end

---@private
function crew:setDevise(devise)
    self:setNeedSave(true)
    self.devise = devise
end

function crew:getDevise()
    return self.devise
end

---@private
function crew:setPerms(perms)
    self:setNeedSave(true)
    self.perms = perms
end

function crew:getPerms()
    return self.perms
end

---@private
function crew:setType(typeCrew)
    self:setNeedSave(true)
    self.typeCrew = typeCrew
end

function crew:getType()
    return self.typeCrew
end

---@private
function crew:setColor(color)
    self:setNeedSave(true)
    self.color = color
end

function crew:getColor()
    return self.color
end

---@private
function crew:setXp(xp)
    self:setNeedSave(true)
    self.xp = xp
end

function crew:getXp()
    return self.xp
end

function crew:removeXp(amount)
    self.needSave = true
    if self.xp - amount < 0 then
        self.xp = 0
    else
        self.xp = self.xp - (tonumber(amount) or 0)
    end
end

function crew:addXp(amount)
    self.needSave = true
    self.xp = self.xp + (tonumber(amount) or 0)
end

---@private
function crew:setMembers(members)
    self:setNeedSave(true)
    self.members = members
end

function crew:getMembers()
    return self.members
end

function crew:getCountNumberMembers()
    return #self.members
end

---@private
function crew:setRoles(roles)
    self:setNeedSave(true)
    self.roles = roles
end

function crew:getRoles()
    return self.roles
end

---@private
function crew:setNeedSave(needSave)
    self.needSave = needSave
end

function crew:getNeedSave()
    return self.needSave
end

---@private
function crew:setNeedSaveMembers(needSaveMembers)
    self.needSaveMembers = needSaveMembers
end

function crew:getNeedSaveMembers()
    return self.needSaveMembers
end

---@private
function crew:setNeedSaveRoles(needSaveRoles)
    self.needSaveRoles = needSaveRoles
end

function crew:getNeedSaveRoles()
    return self.needSaveRoles
end
--crew functions

function crew:updateCrew()
    MySQL.Async.execute("UPDATE crew SET name = @name, devise = @devise, perms = @perms, typeCrew = @typeCrew, color = @color, xp = @xp WHERE id = @id", {
            ['@id'] = self.id,
            ['@name'] = self.name,
            ['@devise'] = self.devise,
            ['@perms'] = json.encode(self.perms),
            ['@typeCrew'] = self.typeCrew,
            ['@color'] = self.color,
            ['@xp'] = self.xp,
        },
        function(affectedRows)
            self:setNeedSave(false)
            CorePrint("Le crew " .. self.name .. " à été mis a jour")
        end
    )
end

function crew:updateMember(data)
    MySQL.Async.execute("UPDATE crew_members SET rank_id = @rank_id WHERE id = @id", {
            ['@id'] = data.id,
            ['@rank_id'] = data.rank_id,
        },
        function(affectedRows)
            self:setNeedSaveMembers(false)
            CorePrint("Le crew " .. self.name .. " à été mis a jour")
        end
    )
end

function crew:updateRoles(data)
    MySQL.Async.execute("UPDATE crew_rank SET name = @name WHERE id = @id", {
            ['@id'] = data.id,
            ['@name'] = data.name,
        },
        function(affectedRows)
            self:setNeedSaveRoles(false)
            CorePrint("Le crew " .. self.name .. " à été mis a jour")
        end
    )
end

-- function

function getCrewByName(name)
    for k, v in pairs(GetAllCrews()) do
        if v.name == name then return v end
    end
    return nil
end

function getCrewInTablet()
    return crewTab
end
