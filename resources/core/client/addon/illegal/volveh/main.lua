--[[
    vol véhicule
    - Numero de téléphone 
    - Position en direction de la ou y'a le pnj qui nous fait un topo sur la situation 
    - le pnj nous explique en discussion le topo de la mission ( vol véhicule de luxe dans une villa )
    - On recois la pos par sms juste apres la discussion de la maison
    - dans la maison des gardes son positionner il faut allez recuperer des clé sur un des garde apres l'avoir tuer ( fouiller chaque garde 0 indice )
    - apres avoir la cle le véhicule est accessible et demarable
    - Une fois dans la voiture le mec nous envoie un message avec la pos 
    - Une fois a la pos on descend du véhicule la ou on rejoins le mec qui apres qu'on est descendu il recup et ce casse avec la caisse
]]

local inMission = false
local pedCreate = false
local leader = nil
local itemTroll = {
    "préservatif",
    "chaussette sale",
    "chargeur",
    "doudou",
    "poison",
    "des clés d'une cave"
}
function StartThieftVehicleMission(data)
    local keyTrouver = false
    local firstStep = false
    Bulle.add("INFORMATEUR", vector3(data.posLeader.x, data.posLeader.y, data.posLeader.z),

        function()
            RobertoBulle("volveh", vector3(data.posLeader.x, data.posLeader.y, data.posLeader.z + 1), 'bulleInformation', 255, 0)
        end,
        function()
            if not firstStep then
                firstStep = true
                Visual.Subtitle("Salut, un homme riche me doit une voiture mais il fait en sorte de ne plus me répondre, "
                    , 5000)
                Wait(5000)
                Visual.Subtitle("je vais te demander d'aller la récupérer et de me la ramener ne t'inquiète pas tu seras bien payé."
                    , 5000)
                Wait(5000)
                Visual.Subtitle("Je t'envoie toutes les informations nécessaires par message.", 5000)
                Wait(5000)
                TriggerServerEvent("phone:AnonymeCall", "654-8790", data.posVeh,
                    "Les clés du véhicule seront sur un des gardes armés fait attention a toi, je te recontacte quand tu es dans le véhicule.")
            end
        end)


    if not inMission then
        inMission = true
        local vehCreate = false
        local veh
        local peds = {}
        local bullePed = {}
        local _, CIA = AddRelationshipGroup("CIA")
        SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), CIA)
        while inMission do
            local pNear = false
            ---Premiere phase Avec le leader
            if #(p:pos() - data.posLeader.xyz) < 20 then
                pNear = true
                if not pedCreate then
                    pedCreate = true
                    leader = entity:CreatePedLocal("cs_lestercrest", data.posLeader.xyz, data.posLeader.w)
                    TaskStartScenarioInPlace(leader.id, "WORLD_HUMAN_AA_COFFEE", -1, true)
                    Wait(1000)
                    SetEntityInvincible(leader.id, true)
                end
            end


            --- Seconde Phase quand on arrive a la villa

            if #(p:pos() - data.posVeh.xyz) < 40 and firstStep then
                --Creation Veh
                if not vehCreate then
                    vehCreate = true
                    veh = vehicle.create(data.veh, data.posVeh, {})
                    SetVehicleDoorsLocked(veh, 2)
                    for i = 1, #data.posPed do
                        TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
                        TriggerSWEvent("TREFSDFD5156FD", "AESDAZDS", 5000)
                        TriggerSWEvent("TREFSDFD5156FD", "VZEFDSF", 5000)
                        bullePed[i] = false
                        Wait(1000)
                        peds[i] = entity:CreatePedLocal("s_m_m_chemsec_01", data.posPed[i].pos.xyz, data.posPed[i].pos.w)
                        SetPedRelationshipGroupHash(peds[i].id, CIA)

                        SetPedDropsWeaponsWhenDead(peds[i].id, false)
                        GiveWeaponToPed(peds[i].id, GetHashKey("weapon_pistol50"), 250, true, true)
                    end
                    searchRamdom = math.random(1, #peds)
                end
            end
            for i = 1, #peds do
                if IsEntityDead(peds[i].id) then
                    if not bullePed[i] then
                        bullePed[i] = true
                        Bulle.add("ped" .. i,
                            vector3(GetEntityCoords(peds[i].id).x, GetEntityCoords(peds[i].id).y,
                                GetEntityCoords(peds[i].id).z),
                            function()
                                RobertoBulle("ped" .. i,
                                    vector3(GetEntityCoords(peds[i].id).x, GetEntityCoords(peds[i].id).y,
                                        GetEntityCoords(peds[i].id).z + 1), 'bulleEntrer', 255, 0)
                            end,
                            function()
                                SendNuiMessage(json.encode({
                                    type = 'openWebview',
                                    name = 'Progressbar',
                                    data = {
                                        text = "Fouille en cours...",
                                        time = 5,
                                    }
                                }))
                                p:PlayAnim("amb@medic@standing@kneel@base", "base", 1)
                                Modules.UI.RealWait(5000)
                                ClearPedTasks(p:ped())
                                if i == searchRamdom then
                                    -- ShowNotification("Vous avez trouver les ~g~clés de la voiture")

                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "Vous avez trouver les ~s clés de la voiture"
                                    })

                                    keyTrouver = true
                                    SetVehicleDoorsLocked(veh, 0)
                                else
                                    local random = math.random(1, #itemTroll)
                                    -- ShowNotification("Vous avez trouver un(e) ~g~" .. itemTroll[random])

                                    -- New notif
                                    exports['vNotif']:createNotification({
                                        type = 'VERT',
                                        -- duration = 5, -- In seconds, default:  4
                                        content = "Vous avez trouver un(e) ~s " .. itemTroll[random]
                                    })

                                end
                            end)
                    end
                end
            end
            if pNear then
                Wait(1)
            else
                Wait(500)
            end
        end
    else
        inMission = false
    end
    -- body
end

RegisterNetEvent('core:CallMissionThiefVeh')
AddEventHandler('core:CallMissionThiefVeh', function(data)
    TriggerSecurEvent("core:crew:updateXp", token, 200, "add", p:getCrew(), "volveh")
    StartThieftVehicleMission(data)
end)