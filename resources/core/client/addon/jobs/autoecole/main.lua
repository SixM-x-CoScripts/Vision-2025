local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)
local open = false
local code = false
local fail = false
local speed_wait = 0
local inPermis = false
function InitLicense()
    code = TriggerServerCallback("core:getLicenseInPlayer", token, "traffic_law")
end

local VUI = exports["VUI"]
--local main2 = RageUI.CreateMenu("", "Action Disponible", 0.0, 0.0, "root_cause", "shopui_title_drivingschool")
local main2 = VUI:CreateMenu("Action Disponible", "driver", true)

main2.OnOpen(function()
    code = TriggerServerCallback("core:getLicenseInPlayer", token, "traffic_law")
    local driving = TriggerServerCallback("core:getLicenseInPlayer", token, 'driving')
    local moto = TriggerServerCallback("core:getLicenseInPlayer", token, 'moto')
    local camion = TriggerServerCallback("core:getLicenseInPlayer", token, 'camion')
    Bulle.hide("yusuf")
    renderMenuCode(code, driving, moto, camion)
end)
main2.OnClose(function()
    Bulle.show("yusuf")
end)

local code_config = {
    vector3(224.85809326172, 371.42068481445, 105.11414337158),
    vector3(226.0104675293, 371.07345581055, 105.11414337158),
    vector3(227.10748291016, 370.63323974609, 105.11414337158),
    vector3(224.15725708008, 369.61001586914, 105.11414337158),
    vector3(225.2864074707, 369.18054199219, 105.11414337158),
    vector3(226.52012634277, 368.73281860352, 105.11414337158)
}
-- passage du code dans la salle
abdelAziz = entity:CreatePedLocal("a_m_y_mexthug_01", vector3(230.7066192627, 365.64993286133, 105.05167388916), 161.1)
abdelAziz:setFreeze(true)
SetEntityInvincible(abdelAziz.id, true)
SetEntityAsMissionEntity(abdelAziz.id, 0, 0)
SetBlockingOfNonTemporaryEvents(abdelAziz.id, true)

for k, v in pairs(code_config) do
    zone.addZone("autoecole_code" .. k, v + vector3(0.0, 0.0, 1.0), "~INPUT_CONTEXT~ Intéragir",
        function()
            --exports["tuto-fa"]:GotoStep(3)
            code = TriggerServerCallback("core:getLicenseInPlayer", token, "traffic_law")
            main2.open()
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        5.5,
        true,
        "bulleCode"
    )

    zone.addZone("yusuf", vector3(230.7066192627, 365.64993286133, 107.05167388916), "In",
        function()
            if TriggerServerCallback("core:getLicenseInPlayer", token, "traffic_law") then 
                --OpenCode(true)
                code = TriggerServerCallback("core:getLicenseInPlayer", token, "traffic_law")
                main2.open()
            else
                exports['vNotif']:createNotification({
                    type = 'ILLEGAL',
                    name = "Moniteur",
                    label = "Abdel aziz",
                    labelColor = "#10A8D1",
                    logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/abdel.webp",
                    mainMessage = "Va dans la salle pour passer ton code et reviens vers moi après",
                    duration = 10,
                })
            end
        end, false,
        27,
        0.5,
        { 255, 255, 255 },
        170,
        5.5,
        true,
        "bullePermis"
    )
end

function renderMenuCode(code, driving, moto, camion)
    if not code then 
        main2.Button(
            "Passer l'examen",
            "du code",
            nil,
            "chevron",
            false,
            function()
                DriveSchool.note = 0
                main2.close()
                SendNUIMessage({
                    type = "openWebview",
                    name = "autoecole",
                    data = DriveSchool.Question
                })
            end
        )
    else
        main2.Button(
            "Passer le permis",
            "voiture",
            nil,
            driving and "lock" or "chevron",
            false,
            function()
                main2.close()
                open = false
                StartPermis("voiture")
            end
        )
        main2.Button(
            "Passer le permis",
            "moto",
            nil,
            moto and "lock" or "chevron",
            false,
            function()
                main2.close()
                open = false
                StartPermis("moto")
            end
        )
        main2.Button(
            "Passer le permis",
            "camion",
            nil,
            camion and "lock" or "chevron",
            false,
            function()
                main2.close()
                open = false
                StartPermis("camtar")
            end
        )
    end
end

function OpenCode(has)
    code = TriggerServerCallback("core:getLicenseInPlayer", token, "traffic_law")
    local driving = TriggerServerCallback("core:getLicenseInPlayer", token, 'driving')
    local moto = TriggerServerCallback("core:getLicenseInPlayer", token, 'moto')
    local camion = TriggerServerCallback("core:getLicenseInPlayer", token, 'camion')
    renderMenuCode(has and true or code, driving, moto, camion)
    main2.open()
end

function StartPermis(permis)
    ---SpawnVeh With Player
    local veh, outPos;
    inPermis = true
    for k, v in pairs(AutoEcole.spawn) do
        if vehicle.IsSpawnPointClear(v, 3) then
            outPos = v
            break
        end
    end
    if not outPos then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Les ~s sorties ~c de véhicule sont ~s occupées"
        })
        return
    end

    local index = 1
    if permis == "moto" then
        veh = vehicle.create("bati", outPos, {})
        local plate = vehicle.getProps(veh).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, veh, VehToNet(veh), p:getJob())
        --createKeys(plate, model)
    elseif permis == "voiture" then
        veh = vehicle.create("blista", outPos, {})
        local plate = vehicle.getProps(veh).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, veh, VehToNet(veh), p:getJob())
        --createKeys(plate, model)
    elseif permis == "camtar" then
        veh = vehicle.create("mule3", outPos, {})
        local plate = vehicle.getProps(veh).plate
        local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        local newVeh = TriggerServerCallback("core:NewVehJob", plate, model, veh, VehToNet(veh), p:getJob())
        --createKeys(plate, model)
    end

    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
    SetEntityAsMissionEntity(abdelAziz.id, true, true)
    NetworkRequestControlOfEntity(abdelAziz.id)
    TaskWarpPedIntoVehicle(abdelAziz.id, veh, 0)
    -- ShowNotification("Bienvenue dans votre permis de conduire, suivez les indications sur votre GPS et respectez le code de la route")

    -- New notif
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Moniteur",
        label = "Abdel aziz",
        labelColor = "#10A8D1",
        logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/abdel.webp",
        mainMessage = "Bienvenue dans votre permis de conduire, suivez les indications sur votre GPS et respectez le code de la route",
        duration = 10,
    })

    Wait(100)
    local error = 0
    local type = 18
    local checkpoint = nil
    CreateThread(function()
        while inPermis do
            -- if the player goes out of the vehicle he has 5 seconds to get back in
            if not IsPedInVehicle(p:ped(), veh, false) then
                Visual.Subtitle("Vous avez quitté le véhicule, vous avez 10 secondes pour rentrer", 10000)
                Wait(10000)
                if not IsPedInVehicle(p:ped(), veh, false) then
                    -- end the test and delete the vehicle
                    inPermis = false
                    TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                    --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                    TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                    DeleteEntity(veh)
                    index = 1
                    error = 0
                    DeleteCheckpoint(checkpoint)
                    NetworkRequestControlOfEntity(abdelAziz.id)
                    SetEntityCoords(abdelAziz.id, 230.7066192627, 365.64993286133, 105.05167388916)
                    SetEntityHeading(abdelAziz.id, 161.1)
                    checkpoint = nil
                    return
                end
            end
            if checkpoint == nil then
                SetNewWaypoint(AutoEcole.pos[index].x, AutoEcole.pos[index].y)
                checkpoint = CreateCheckpoint(type, AutoEcole.pos[index].x, AutoEcole.pos[index].y,
                    AutoEcole.pos[index].z + 1, AutoEcole.pos[index + 1].x, AutoEcole.pos[index + 1].y,
                    AutoEcole.pos[index + 1].z - 1.5, 2.0, 255, 255, 255, 255, false)
            end
            if #(p:pos() - AutoEcole.pos[index]) <= 10 then
                index = index + 1
                DeleteCheckpoint(checkpoint)
                checkpoint = nil
            end
            if index == #AutoEcole.pos then
                -- if the player has 3 or more errors, fail the test and notify the player
                TriggerEvent('persistent-vehicles/forget-vehicle', veh)
                --removeKeys(GetVehicleNumberPlateText(veh), GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
                TriggerServerEvent("core:removeVeh", GetVehicleNumberPlateText(veh))
                DeleteEntity(veh)
                if error >= 3 then
                    -- ShowNotification("Vous avez ~r~échoué~w~ l'examen")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ILLEGAL',
                        name = "Moniteur",
                        label = "Abdel aziz",
                        labelColor = "#10A8D1",
                        logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/abdel.webp",
                        mainMessage = "Vous avez échoué l'examen",
                        duration = 10,
                    })

                    inPermis = false
                    DeleteCheckpoint(checkpoint)
                    checkpoint = nil
                    index = 1
                    error = 0
                    return
                else
                    -- ShowNotification("Vous avez ~g~réussi~w~ l'examen")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ILLEGAL',
                        name = "Moniteur",
                        label = "Abdel aziz",
                        labelColor = "#10A8D1",
                        logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/abdel.webp",
                        mainMessage = "Vous avez réussi l'examen",
                        duration = 10,
                    })
                    exports["tuto-fa"]:GotoStep(3)
                    SetEntityCoords(abdelAziz.id, 230.7066192627, 365.64993286133, 105.05167388916)
                    SetEntityHeading(abdelAziz.id, 161.1)

                    local SID = GetPlayerServerId(PlayerId())
                    if permis == "voiture" then
                        TriggerServerEvent("core:addLicence", SID, token, "driving")
                    elseif permis == "moto" then
                        TriggerServerEvent("core:addLicence", SID, token, "moto")
                    elseif permis == "camtar" then
                        TriggerServerEvent("core:addLicence", SID, token, "camion")
                    end
                    inPermis = false
                    DeleteCheckpoint(checkpoint)
                    checkpoint = nil
                    index = 1
                    error = 0
                    return
                end
                NetworkRequestControlOfEntity(abdelAziz.id)
                SetEntityCoords(abdelAziz.id, 230.7066192627, 365.64993286133, 105.05167388916)
                SetEntityHeading(abdelAziz.id, 161.1)
                break
            end
            if (index + 1) == #AutoEcole.pos then
                -- last checkpoint is finish line
                type = 10
            end
            if error < 3 then
                -- if the speed is above 80 km/h add error and give them time to slow down
                if GetEntitySpeed(veh) * 3.6 > 80 and speed_wait == 0 then
                    error = error + 1
                    exports['vNotif']:createNotification({
                        type = 'ILLEGAL',
                        name = "Moniteur",
                        label = "Abdel aziz",
                        labelColor = "#10A8D1",
                        logo = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/abdel.webp",
                        mainMessage = error == 1 and "Tu dépasse la limite de vitesse !" or "Tu dépasse la limite de vitesse, la prochaine fois c'est ciao !",
                        duration = 10,
                    })
                    speed_wait = 100
                end
                -- if the car health is below 85% add 3 errors and end the test
                if GetVehicleBodyHealth(veh) < 85 and not fail then
                    error = error + 3
                    fail = true
                end
            end
            if speed_wait > 0 then
                speed_wait = speed_wait - 1
            end
            Wait(1)
        end
        NetworkRequestControlOfEntity(abdelAziz.id)
        SetEntityCoords(abdelAziz.id, 230.7066192627, 365.64993286133, 105.05167388916)
        SetEntityHeading(abdelAziz.id, 161.1)
    end)
end