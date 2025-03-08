local InJobCenter = false

local function objectToTable(obj)
    local tbl = {}
    if obj and type(obj) == "table" then
        for k, v in pairs(obj) do
            table.insert(tbl, v)
        end
    end
    return tbl
end

local jobcenter = {
    vector4(-269.1, -955.56, 30.22, 206.2),
    vector4(-418.51638793945, 6152.2583007813, 31.312999725342, 230.78753662109),
    vector4(1668.07, 3729.77, 33.84, 211.66),
}

local function OpenJobCenter()
    InJobCenter = true
    while not GetVariable do Wait(1) end
    SendNUIMessage({
        type = "openWebview",
        name = "JobCenter",
        data = {
            headerIcon = "https://cdn.sacul.cloud/v2/vision-cdn/icons/image_homme.webp",
            headerIconName = "Job Center",
            premium = p:getSubscription(),
            items = objectToTable(GetVariable("jobcenter")), --{
                --    objectToTable(GetVariable("jobcenter"))
            --},
        }
    })
end

CreateThread(function()
    -- Wait for player to be loaded
    while not p do Wait(100) end
    while not zone do Wait(100) end

    for k, v in pairs(jobcenter) do
        local ped = entity:CreatePedLocal("cs_bankman", v.xyz, v.w)
        SetEntityInvincible(ped.id, true)
        ped:setFreeze(true)
        TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
        SetEntityAsMissionEntity(ped.id, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped.id, true)

        -- Draw a blip
        local blip = AddBlipForCoord(v.xyz)
        SetBlipSprite(blip, 407)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Job Center")
        EndTextCommandSetBlipName(blip)

        zone.addZone(
        "jobcenter"..k,
        v.xyz + vector3(0.0, 0.0, 2.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le menu jobcenter",
        function()
            exports['tuto-fa']:GotoStep(7)
            OpenJobCenter()
        end,
        false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        3.0,
        true,
        "bulleJobcenter",
        true
    )
    end
end)

RegisterNUICallback("focusOut", function()
    if InJobCenter then
        InJobCenter = false
    end
end)

RegisterNUICallback("selectJob", function(jobname, cb)
    if InJobCenter then
        cb({})
        local jobs = GetVariable("jobcenter")
        -- find the job with the name then print it
        for _, job in pairs(jobs) do
            if job.name == jobname then
                -- Place a waypoint to job.position
                SetNewWaypoint(job.position.x, job.position.y)
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "La position a été ajoutée à votre GPS"
                })
                break
            end
        end
        InJobCenter = false
        closeUI()
    end
end)