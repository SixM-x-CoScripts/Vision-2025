laboratory = {
    id = 0,
    crew = nil,
    laboType = nil,
    inAction = nil,
    coords = {},
    state = 0,
    PosWork = nil,
    minutes = 0,
    maxTime = 120,
    quantityDrugs = nil,
    blocked = false,
    percentages = {},
}

laboratory.__index = laboratory

classlabo = {} ---@type laboratory
local classlaboCrew = {} ---@type laboratory

---@return laboratory
function GetLabo(id)
    return classlabo[id]
end

---@return laboratory
function GetLaboByCrew(crew)
    return classlaboCrew[crew]
end

function laboratory:getId()
    return self.id
end

function laboratory:deleteLabo()
    MySQL.Async.execute("DELETE FROM laboratory WHERE id = @laboid", { ['@laboid'] = self.id })
    classlaboCrew[self.crew] = nil
    classlabo[self.id] = nil
end

function laboratory:getCrew()
    return self.crew
end

function laboratory:getlaboType()
    return self.laboType
end

function laboratory:updateQuantityDrugs(nbr)
    self.quantityDrugs = nbr
    self.needSave = true
end

function laboratory:addEntity(ent)
    if not self.entities then 
        self.entities = {}
    end
    table.insert(self.entities, ent)
end

function laboratory:getEntities(ent)
    return self.entities
end

function laboratory:removeEntities()
    if self.entities and next(self.entities) then 
        for k,v in pairs(self.entities) do 
            local ent = NetworkGetEntityFromNetworkId(v)
            if ent then
                DeleteEntity(ent)
            end
        end
    end
end

function laboratory:getQuantityDrugs()
    return self.quantityDrugs
end

function laboratory:updateState(state)
    self.state = state
    self.needSave = true
end

function laboratory:getState()
    return self.state
end

function laboratory:updateBlocked(bool)
    self.blocked = bool
end

function laboratory:getBlocked()
    return self.blocked
end

function laboratory:updateMinutes(minutes)
    self.minutes = minutes
    self.needSave = true
end

function laboratory:getMinutes()
    return self.minutes
end

function laboratory:updatePosWork(tbl)
    self.PosWork = tbl
    self.needSave = true
end

function laboratory:updateTreated(bool)
    self.hasPlantTreated = bool
    self.needSave = true
end

function laboratory:getPercentages()
    return self.percentages
end

function laboratory:updatePercentages(tbl)
    self.percentages = tbl
    self.needSave = true
end

function laboratory:updateMaxTime(nbr)
    self.maxTime = nbr
    self.needSave = true
end

function laboratory:getPosWork()
    return self.PosWork
end

function laboratory:getTreated()
    return self.hasPlantTreated
end

function laboratory:getLaunched()
    return self.launched
end

function laboratory:makeDrug(id, minutes, shouldUseNewInfo)
    CreateThread(function()
        if shouldUseNewInfo then
            self.launched = true
            self.minutes = minutes
        end
        while true do
            Citizen.Wait(60000)
            if self.minutes <= 1 then 
                if self.state ~= 2 then
                    if self.percentages[1] > 0 and self.percentages[2] > 0 and self.percentages[3] > 0 then  
                        self.state = 2
                        self.minutes = 0
                        self.quantityDrugs = 180
                        self.launched = false
                        TriggerClientEvents("core:labo:finished", GetAllCrewIds(), self.id, self.percentages, self.quantityDrugs, self.laboType)
                        TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(self.crew), self.crew, "Votre production de " .. self.laboType .. " est terminée", self.id, true)
                        break
                    end
                end
            else
                self.state = 1
                self.launched = true
                if not self.blocked then
                    if not self.percentages then 
                        self.minutes = self.minutes - 1
                    else
                        --if self.percentages[1] > 0 and self.percentages[2] > 0 and self.percentages[3] > 0 then  
                            self.minutes = self.minutes - 1
                            self.sentNotif = false
                            if math.fmod(self.minutes, 2) == 0 then -- modulo
                                local percen = (self.minutes/self.maxTime)*100
                                --self.percentages[1] = math.floor(percen)+1.0
                                --self.percentages[2] = math.floor(percen)+1.0
                                --self.percentages[3] = math.floor(percen)+1.0
                                self.percentages[1] = self.percentages[1]-2
                                self.percentages[2] = self.percentages[2]-2
                                self.percentages[3] = self.percentages[3]-2
                                --print(self.percentages[1], self.percentages[2], self.percentages[3])
                            end
                        --else
                        --    if not self.sentNotif then -- don't spam
                        --        self.state = 0
                        --        self.sentNotif = true
                        --        TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, self.id, self.minutes, false, self.percentages)
                        --        TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(self.crew), self.crew, "Hey, il te manque des ingrédients pour ta came", self.id, true)
                        --    end
                        --end
                    end
                    --if self.minutes == math.floor(self.maxTime/2) then
                    --    self.blocked = true
                    --    self.hasPlantTreated = false
                    --    TriggerClientEvents("core:labo:sendnotif", GetAllCrewIds(self.crew), self.crew, "Hey, la permière tournée de came est finis, viens compléter ta production", self.id, true)
                    --    TriggerClientEvents("core:labo:changeState", GetAllCrewIds(), 0, self.id, self.minutes, true, self.percentages)        
                    --end
                end
            end
        end
    end)
end

function laboratory:setOpen(bool)
    self.open = bool
    self.needSave = true
end

function laboratory:getOpen(bool)
    return self.open
end

function laboratory:needSave(bool)
    if bool ~= nil then 
        self.needSave = bool
    end
    return self.needSave
end

---@return laboratory
function laboratory:new(data)
    local self = setmetatable({}, laboratory)
    self.id = data.id or 0
    self.crew = data.crew or ""
    self.laboType = data.laboType or ""
    self.inAction = data.inAction or false
    self.coords = data.coords or vec3(0.0, 0.0, 0.0)
    self.state = data.state or 0
    self.owner = data.owner
    self.PosWork = data.PosWork or {}
    self.minutes = data.minutes or 0
    self.maxTime = data.maxTime or 120
    self.quantityDrugs = data.quantityDrugs
    self.blocked = data.blocked or false
    self.percentages = data.percentages or {}
    self.needSave = data.needSave or true
    self.hasPlantTreated = false
    self.open = false
    self.launched = false
    classlabo[data.id] = self
    classlaboCrew[data.crew] = self

    if self.state == 1 then 
        if self.minutes and self.minutes <= 1 then 
            self.state = 2
        else
            self:makeDrug(self.id, self.minutes)
        end
    end
    return self
end

CreateThread(function()
    while true do 
        Wait(5 * 60000)
        local countLab = 0
        for k,v in pairs(classlabo) do 
            local labo = GetLabo(v.id)
            if v.state == 1 then 
                if not v.launched then 
                    labo:makeDrug(v.id, v.minutes)
                end
            end
            if v.needSave then
                local InAction
                if v.state == 1 and v.minutes then InAction = v.minutes end
                local datae = {coords = v.coords, state = v.state, minutes = v.minutes, percentages = v.percentages, quantityDrugs = v.quantityDrugs, blocked = v.blocked, PosWork = json.encode(v.PosWork), maxTime = v.maxTime}
                MySQL.Async.execute("UPDATE laboratory SET data=@data, InAction=@action WHERE id=@id",
                {
                    ['@data'] = json.encode(datae),
                    ['@action'] = InAction,
                    ['@id'] = v.id,
                })
                countLab += 1
                v.needSave = false
                Wait(500)
            else
                Wait(250)
            end
        end
        if countLab > 0 then
            CorePrint("Saved " .. countLab .. " labos.")
        end
    end
end)