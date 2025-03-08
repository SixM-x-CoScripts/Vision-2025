Jobs = {}

local function RefreshjobsFiles() -- Allow dynamic save
    SaveResourceFile(GetCurrentResourceName(), "./config/jobs.json", json.encode(jobs), -1)
    CorePrint("Jobs saved to jobs.json")
end

-- RefreshjobsFiles()
local function LoadjobsFromFile() -- Allow dynamic load
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "/config/jobs.json")
    Jobs = json.decode(loadFile)
end

LoadjobsFromFile()

local function DoesJobExist(job)
    if Jobs[job] ~= nil then
        return true
    else
        return false
    end
end

local function DoesJobGradeExist(job, grade) -- Vérifie aussi si le job exist au cas ou
    if Jobs[job] ~= nil then
        if tonumber(grade) <= tonumber(#Jobs[job].grade) then
            return true
        else
            return false
        end
    else
        return false
    end
end

local function CanPlayerRecruit(source)
    local src = tonumber(source)
    if GetPlayer(src) ~= nil then
        if Jobs[GetPlayer(src):getJobGrade()] ~= nil then
            if Jobs[GetPlayer(src):getJobGrade()].gestion then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end

function ChangePlayerJob(_src, job, grade)
    local src = tonumber(_src)
    local player = GetPlayer(src)
    if player ~= nil then
        if DoesJobExist(job) then
            if DoesJobGradeExist(job, grade) then
                -- Remove old job
                local oldjob = player:getJob()
                if oldjob ~= nil or oldjob ~= "aucun" then
                    SetDuty(src, oldjob, false)
                end
                player:setJob("aucun")
                player:setJobGrade(1)

                Wait(1000)

                -- Apply new job
                player:setJob(job)
                player:setJobGrade(grade)
                triggerEventPlayer("core:setJobPlayer", src, job, grade)
                MarkPlayerDataAsNonSaved(src)
                --RefreshPlayerData(src)
                CorePrint("Le Job " .. job .. " a été mis sur l'id " .. src)
                return true
            else
                print("Le grade " .. tostring(grade) .. " n'existe pas pour le job " .. tostring(job))
                return false
            end
        else
            print("Le job " .. job .. " n'existe pas")
            return false
        end
    end
    return false
end

function ChangePlayerJobOffline(targetId, job, grade)
    if GetPlayer(source) ~= nil then
        if DoesJobExist(job) then
            if DoesJobGradeExist(job, grade) then
                MySQL.Async.execute("UPDATE players SET job_grade = @1, job = @2 WHERE id = @3",
                    {
                        ['1'] = grade,
                        ['2'] = job,
                        ['3'] = targetId,
                    },
                    function(affectedRows)

                    end)
            else
                return false, "Le grade " .. tostring(grade) .. " n'existe pas pour le job " .. tostring(job)
            end
        else
            return false, "Le job n'existe pas"
        end
    end
end

function CreateNewJob(name, label, grades, moneyNpc, actionZone, cloths, clothsPos)

    if name == nil then return end
    if label == nil then return end
    if grades == nil then return end
    if moneyNpc == nil then return end
    if actionZone == nil then return end
    if cloths == nil then return end


    local newJob = {
        label = label,
        name = name,
        grade = grades,
        moneyPerNpc = moneyNpc,
        clothsPos = clothsPos,
        actionEntreprise = actionZone,
        cloths = cloths,
        -- grade = {
        --     {grade = 0, label = "template",   gestion = false,    salaire = 50, coffre = false},
        -- },
    }

    Jobs[name] = newJob
    CorePrint("Création du nouveau job")
    RefreshjobsFiles()
    LoadjobsFromFile()
end

function UpdateJobData(index, data)
    Jobs[index] = data
    CorePrint("Job mis à jours")
    RefreshjobsFiles()
    LoadjobsFromFile()
end

-- @events

RegisterNetEvent("core:CreateNewJob")
AddEventHandler("core:CreateNewJob", function(token, name, label, grades, moneyNpc, actionZone, cloths, clothsPos)
    if CheckPlayerToken(source, token) then
        if HasPermission(source, 5) then
            CreateNewJob(name, label, grades, moneyNpc, actionZone, cloths, clothsPos)
        else
            -- TODO Anti cheat detection / log
        end
    end
end)

RegisterNetEvent("core:UpdateJob")
AddEventHandler("core:UpdateJob", function(token, index, jobData)
    if CheckPlayerToken(source, token) then
        if HasPermission(source, 5) then
            UpdateJobData(index, jobData)
        else
            -- TODO Anti cheat detection / log
        end
    end
end)


-- RegisterNetEvent("core:RecruitPlayer")
-- AddEventHandler("core:RecruitPlayer", function(token, target, job, grade)
--     if CheckPlayerToken(source, token) then
--         if CanPlayerRecruit(source) then
--             ChangePlayerJob(target, job, grade)
--         else
--             -- TODO Anti cheat detection / log
--         end
--     end
-- end)


RegisterNetEvent("core:StaffRecruitPlayer")
AddEventHandler("core:StaffRecruitPlayer", function(token, target, job, grade)
    if CheckPlayerToken(source, token) then
        if GetPlayer(source):getPermission() ~= 0 then
            ChangePlayerJob(target, job, grade)
        else
            -- TODO Anti cheat detection / log
        end
    end
end)


-- @Exports

exports("GetJobPlayerData", function(source)
    local src = tonumber(source)
    local result = {}
    if GetPlayer(src) ~= nil then
        result.job = GetPlayer(src):getJob()
        result.jobLabel = Jobs[GetPlayer(src):getJob()].label
        result.grade = GetPlayer(src):getJobGrade()
        result.gradeName = Jobs[GetPlayer(src):getJob()].grade[GetPlayer(src):getJobGrade()].label
    end
    return result
end)