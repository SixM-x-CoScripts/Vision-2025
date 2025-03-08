local isBeingTreated = false

local nurseReception = {
    {x = 313.89, y = -584.2, z = 42.27, heading = 161.77},
    -- {x = -253.27, y = 6335.85, z = 31.45, heading = 230.26},
}

local nurseRoom = {x = 308.54, y = -599.19, z = 42.27}

local toReceptionWaypoints = {
    {x = 307.37, y = -597.62, z = 42.27},
    {x = 309.04, y = -593.71, z = 42.27},
    {x = 310.68, y = -593.08, z = 42.27},
    {x = 311.56, y = -590.63, z = 42.27},

}

local toBedWaypoints = {
    {x = 310.2, y = -590.0, z = 42.27},
    {x = 307.01, y = -587.66, z = 42.27},
    {x = 308.1, y = -583.95, z = 42.27},
    {x = 310.31, y = -577.12, z = 42.27},
    {x = 311.67, y = -574.36, z = 42.27},
    {x = 315.99, y = -575.6, z = 42.27},
    {x = 323.6, y = -578.44, z = 42.27},
    {x = 324.97, y = -580.33, z = 42.27},
    {x = 323.64, y = -584.2, z = 42.27}
}

local fromBedWaypoints = {
    {x = 323.64, y = -584.2, z = 42.27},
    {x = 324.97, y = -580.33, z = 42.27},
    {x = 323.6, y = -578.44, z = 42.27},
    {x = 315.99, y = -575.6, z = 42.27},
    {x = 311.67, y = -574.36, z = 42.27},
    {x = 310.31, y = -577.12, z = 42.27},
    {x = 308.1, y = -583.95, z = 42.27},
    {x = 307.01, y = -587.66, z = 42.27},
    {x = 310.2, y = -590.0, z = 42.27},
    {x = 311.66, y = -591.5, z = 42.27},
    {x = 309.04, y = -593.71, z = 42.27},
    {x = 307.37, y = -597.62, z = 42.27}
}

local fromBedRoomToBed = {
    [1] = {
        {x = 328.04, y = -585.55, z = 42.27},
    },
    [2] = {
        {x = 328.4, y = -585.82, z = 42.27},
    },
    [3] = {
        {x = 327.37, y = -586.62, z = 42.27},
    },
    [4] = {
        {x = 327.0, y = -586.44, z = 42.27},
    },
    [5] = {
        {x = 321.98, y = -584.85, z = 42.27},
    },
    [6] = {
        {x = 319.55, y = -583.77, z = 42.27},
    },
    [7] = {
        {x = 316.46, y = -582.71, z = 42.27},
    },
    [8] = {
        {x = 319.39, y = -582.49, z = 42.27},
    },
    [9] = {
        {x = 319.39, y = -582.49, z = 42.27},
    },
}

Citizen.CreateThread(function()
    local nurseModel = GetHashKey("s_m_m_doctor_01")
    RequestModel(nurseModel)
    while not HasModelLoaded(nurseModel) do
        Citizen.Wait(100)
    end

    for k,v in pairs(nurseReception) do
        local nursePed = CreatePed(4, nurseModel, v.x, v.y, v.z, v.heading, false, false)
        FreezeEntityPosition(nursePed, true)
        SetEntityInvincible(nursePed, true)
        SetEntityAsMissionEntity(nursePed, 0, 0)
        SetBlockingOfNonTemporaryEvents(nursePed, true)

        local blipRadar = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blipRadar, 153)
        SetBlipScale(blipRadar, 0.70)
        SetBlipColour(blipRadar, 2)
        SetBlipDisplay(blipRadar, 5)
        SetBlipAsShortRange(blipRadar, true)
    end
end)

local function openNurseMenu(amount)
    local health = IsPedMale(p:ped()) and (p:getHealth() - 100) or p:getHealth() 

    SetNuiFocus(true, true)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'NurseMenu',
        data = {
            firstname = p:getFirstname(),
            lastname = p:getLastname(),
            birthdate = p:getAge(),
            care_cost = amount,
            health = health,
        }
    }))
end

for k,v in pairs(nurseReception) do
    zone.addZone("hospital_reception_"..k, vector3(v.x, v.y, v.z + 2.0),
        "Appuyez sur ~INPUT_CONTEXT~ pour demander des soins.", function()
            if isBeingTreated then
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    content = "Vous êtes déjà en train de recevoir des soins."
                })
                return
            else
                local amount = 0
                if p:getHealth() < 200 then
                    local EmsDuty = tonumber(GlobalState['serviceCount_ems']) or 0
                    if EmsDuty >= 1 then
                        local confirmation = ChoiceInput("Des médecins sont déjà en service êtes-vous sûrs de vouloir vous faire soigner pour 1500$ ?", "Oui", "Non")
                        if confirmation == true then
                            if p:haveEnoughMoney(1500) then
                                amount = 1500
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Vous n'avez pas assez d'argent pour payer les soins."
                                })
                                return
                            end
                        end
                    else
                        if p:haveEnoughMoney(500) then
                            amount = 500
                        else
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous n'avez pas assez d'argent pour payer les soins."
                            })
                            return
                        end
                    end
                    if amount > 0 then
                        --[[ p:pay(amount)
                        exports['vNotif']:createNotification({
                            type = 'VERT',
                            duration = 6,
                            content = "Vous avez payé "..amount.."$ pour les soins. Attendez que l'infirmier vienne vous chercher."
                        })
                        TriggerServerEvent('hospital:requestTreatment', amount, EmsDuty) ]]
                        openNurseMenu(amount)
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas besoin de soins. Laissez la place aux autres !"
                    })
                    return
                end
            end
        end, false,
        29,
        1.0,
        { 50, 168, 82 },
        170,
        3.0,
        true,
        "bulleConsulter"
    )
end

local function guideNurse(nursePed, waypoints, callback)
    Citizen.CreateThread(function()
        for _, waypoint in ipairs(waypoints) do
            TaskGoStraightToCoord(nursePed, waypoint.x, waypoint.y, waypoint.z, 1.0, -1, 0.0, 0.0)
            while #(GetEntityCoords(nursePed) - vector3(waypoint.x, waypoint.y, waypoint.z)) > 1.0 do
                TaskGoStraightToCoord(nursePed, waypoint.x, waypoint.y, waypoint.z, 1.0, -1, 0.0, 0.0)
                Citizen.Wait(50)
            end
        end

        if callback then
            callback()
        end
    end)
end

RegisterNUICallback('startCare', function(data)
    local EmsDuty = tonumber(GlobalState['serviceCount_ems']) or 0
    
    SetNuiFocus(false, false)
    p:pay(tonumber(data.cost))
    exports['vNotif']:createNotification({
        type = 'VERT',
        duration = 6,
        content = "Vous avez payé "..data.cost.."$ pour les soins. Attendez que l'infirmier vienne vous chercher."
    })
    TriggerServerEvent('hospital:requestTreatment', data.cost, EmsDuty) 

    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }))
end)

RegisterNetEvent('hospital:startTreatment')
AddEventHandler('hospital:startTreatment', function(bed)
    isBeingTreated = true

    OpenTutoFAInfo("Soins", "Un infirmier va vous prendre en charge.")

    local nurseModel = GetHashKey("s_m_m_doctor_01")
    RequestModel(nurseModel)
    while not HasModelLoaded(nurseModel) do
        Citizen.Wait(100)
    end

    local nursePed = CreatePed(4, nurseModel, nurseRoom.x, nurseRoom.y, nurseRoom.z, 0.0, false, true)
    SetEntityInvincible(nursePed, true)

    
    Citizen.CreateThread(function()
        Citizen.Wait(300000)
        if isBeingTreated then                                
            print("Soins terminés - ForceQuit")
            exports['tuto-fa']:HideStep()
            zone.removeZone("hospital_bed")
            zone.removeBulle("hospital_bed")
            if DoesEntityExist(nursePed) then
                DeleteEntity(nursePed)
            end
            isBeingTreated = false
            TriggerServerEvent('hospital:freeBed', bed)
        end
    end)

    guideNurse(nursePed, toReceptionWaypoints, function()
        OpenTutoFAInfo("Soins", "Suivez l'infirmier jusqu'au lit et allongez-vous.")

        guideNurse(nursePed, toBedWaypoints, function()
            OpenTutoFAInfo("Soins", "Allongez-vous sur le lit.")
            zone.addZone("hospital_bed", vector3(bed.x, bed.y, bed.z + 1.0),
                "Appuyez sur ~INPUT_CONTEXT~ pour vous allonger.", function()
                    zone.removeZone("hospital_bed")
                    zone.removeBulle("hospital_bed")
                    exports['tuto-fa']:HideStep()
                    if bed.heading > 180 then SetEntityHeading(p:ped(), 160.0) else SetEntityHeading(p:ped(), 340.0) end
                    SetEntityCoordsNoOffset(p:ped(), bed.x, bed.y, bed.z + 2.0, 0.0, 0.0, 0.0)
                    p:PlayAnim("switch@trevor@annoys_sunbathers", "trev_annoys_sunbathers_loop_guy", 1)
                    if bed.heading > 180 then SetEntityHeading(p:ped(), 160.0) else SetEntityHeading(p:ped(), 340.0) end
                    guideNurse(nursePed, fromBedRoomToBed[bed.id], function()
                        if bed.heading > 180 then SetEntityHeading(p:ped(), 160.0) else SetEntityHeading(p:ped(), 340.0) end
                        local y = 0 if bed.heading > 180 then y = -0.4 else y = 0.4 end
                        guideNurse(nursePed, {{x = bed.x + bed.pedPos, y = bed.y + y, z = bed.z}}, function()
                            if bed.heading > 180 then SetEntityHeading(p:ped(), 160.0) else SetEntityHeading(p:ped(), 340.0) end
                            if bed.pedPos >= 1 then SetEntityHeading(nursePed, 70.0) else SetEntityHeading(nursePed, 250.0) end

                            if bed.heading > 180 and bed.pedPos >= 1 then 
                                camPos = {x = -1.5, y = -1.5, z = 2, x2 = 0.75, y2 = 0, z2 = -0.75} 
                            elseif bed.heading > 180 and bed.pedPos < 1 then
                                camPos = {x = 0.1, y = -1.75, z = 2.5, x2 = 0.0, y2 = 0.0, z2 = -0.7}
                            elseif bed.heading < 180 and bed.pedPos >= 1 then 
                                camPos = {x = -0.1, y = 2.1, z = 2.0, x2 = 0.2, y2 = 0.0, z2 = -0.75}
                            elseif bed.heading < 180 and bed.pedPos < 1 then 
                                camPos = {x = 1.5, y = 1.5, z = 2.0, x2 = -1.0, y2 = 0.0, z2 = -0.75}
                            end

                            Cam.create("medic_cam")
                            Cam.setPos("medic_cam", vector(bed.x + camPos.x, bed.y + camPos.y, bed.z + camPos.z))
                            Cam.setFov("medic_cam", 50.0)
                            local pedCoords = GetEntityCoords(p:ped())
                            Cam.lookAtCoords("medic_cam", vector3(pedCoords.x + camPos.x2, pedCoords.y + camPos.y2, pedCoords.z + camPos.z2))
                            Cam.render("medic_cam", true, false, 0)

                            RequestAnimDict("mini@repair")
                            while not HasAnimDictLoaded("mini@repair") do Wait(1) end
                            TaskPlayAnim(nursePed, "mini@repair", "fixing_a_player", 2.0, 2.0, -1, 1, 0, false, false, false)
                            RemoveAnimDict("mini@repair")

                            SendNuiMessage(json.encode({
                                type = 'openWebview',
                                name = 'LoadingBar',
                                data = {
                                    firstname = p:getFirstname(),
                                    lastname = p:getLastname(),
                                    icon = "heart",
                                    color = "#33963C",
                                    time = 60,
                                }
                            }))

                            Modules.UI.RealWait(60000)

                            Cam.render("medic_cam", false, false, 0)

                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                content = "Soins terminés. Vous avez été soigné avec succès."
                            })

                            SendNuiMessage(json.encode({
                                type = 'closeWebview',
                            }));

                            p:setHealth(200)

                            ClearPedTasksImmediately(p:ped())
                            ClearPedTasksImmediately(nursePed)
                        
                            guideNurse(nursePed, fromBedWaypoints, function()
                                print("Soins terminés")
                                DeleteEntity(nursePed)
                                isBeingTreated = false
                                TriggerServerEvent('hospital:freeBed', bed)
                            end)
                        end)
                    end)
            end, false,
                29,
                1.0,
                { 50, 168, 82 },
                170,
                4.0,
                true,
                "bulleAllonger"
            )
        end)
    end)
end)