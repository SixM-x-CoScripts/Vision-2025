local insideMissionPNJ = false 

local function objectToTable(obj)
    local tbl = {}
    for k, v in pairs(obj) do
        table.insert(tbl, v)
    end
    return tbl
end

local function OpenMissionCenter()
    insideMissionPNJ = true
    SendNUIMessage({
        type = "openWebview",
        name = "JobCenter",
        --data = objectToTable(GetVariable("jobcenter"))
        data = {}
    })
end

RegisterCommand("missions", function()
    OpenMissionCenter()
end)

RegisterNUICallback("focusOut", function()
    if insideMissionPNJ then
        insideMissionPNJ = false
    end
end)

RegisterNUICallback("selectJob", function(jobname, cb)
    if insideMissionPNJ then
        print(jobname)
    end
end)