local conteneurEntity = nil
local conteneurEntity2 = nil
local conteneurEntity3 = nil
local conteneurEntity4 = nil
local sceneObject = nil
local lockObject = nil

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local setupConteneur = {
    pos = vector3(-25.643602371216, -2470.8957519531, 5.0067753791809), 
    heading = 53.0, 
    lock = {pos = vector3(-25.643602371216, -2470.8957519531, 5.0067753791809), taken = false},
    table = vector3(-25.648426055908, -2470.8957519531, 5.0023589134216),
}

RegisterNetEvent("core:startevent:conteneur", function(typee)
    if not typee then return end
    if typee == "tout le monde" then 
        CreateEventConteneur()
        return
    end
    if p:getCrew() ~= "None" and (string.lower(p:getCrewType()) == string.lower(typee)) then
        CreateEventConteneur()
    end
end)

local blipMission = nil

function CreateEventConteneur()
    while not entity do Wait(1000) end
    while not zone do Wait(1000) end
    conteneurEntity = entity:CreateObjectLocal("tr_prop_tr_container_01a", setupConteneur.pos).id
    SetEntityHeading(conteneurEntity, setupConteneur.heading)
    FreezeEntityPosition(conteneurEntity, true)
    Wait(math.random(100, 500))
    conteneurEntity2 = entity:CreateObjectLocal('prop_ld_container', setupConteneur.pos).id
    SetEntityHeading(conteneurEntity2, setupConteneur.heading)
    SetEntityVisible(conteneurEntity2, false)
    FreezeEntityPosition(conteneurEntity2, true)
    Wait(math.random(100, 500))
    conteneurEntity3 = entity:CreateObjectLocal('tr_prop_tr_lock_01a', setupConteneur.lock.pos).id
    SetEntityHeading(conteneurEntity3, setupConteneur.heading)
    conteneurEntity4 = entity:CreateObjectLocal('xm_prop_lab_desk_02', setupConteneur.table).id
    SetEntityHeading(conteneurEntity4, setupConteneur.heading)
    
    exports['vNotif']:createNotification({
        type = 'ILLEGAL',
        name = "Indic",
        label = "Conteneur",
        labelColor = "#E81010",
        logo = NotifImageIA[math.random(1, #NotifImageIA)].lien,
        mainMessage = "Hey, j'ai apperçu un conteneur que tu peux péter !",
        duration = 10,
    })

    blipMission = AddBlipForCoord(setupConteneur.pos)
    SetBlipSprite(blipMission, 478)
    SetBlipScale(blipMission, 0.75)
    SetBlipColour(blipMission, 2)
    SetBlipAsShortRange(blipMission, true)
    SetBlipRoute(blipMission, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("~r~Conteneur")
    EndTextCommandSetBlipName(blipMission)

    zone.addZone(
        "conteneurEvent", -- Nom
        vector3(-23.963584899902, -2472.171875, 6.157758560181), -- Position
        "~INPUT_CONTEXT~ Catalogue", -- Text afficher
        function()
            OpenContainerEvent({"champagne_pack", math.random(20, 30), "bouteille2", math.random(30, 50)})
        end,
        false, -- Avoir un marker ou non
        25, -- Id / type du marker
        0.6, -- La taille
        { 51, 204, 255 }, -- RGB
        170,-- Alpha
        2.0,
        true,
        "bulleOuvrir"
    )
end

local ConteneurEventAnim = {
    ['objects'] = {
        'tr_prop_tr_grinder_01a',
        --'ch_p_m_bag_var02_arm_s'
    },
    ['animations'] = {
        {'action', 'action_container', 'action_lock', 'action_angle_grinder', 'action_bag'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}

RegisterNetEvent("core:rm:conteneurevent", function()
    Bulle.hide("conteneurEvent")
    Bulle.remove("conteneurEvent")
    zone.removeZone("conteneurEvent")
    RemoveBlip(blipMission)
end)

function OpenContainerEvent(whattogive)
    TriggerServerEvent("core:rm:conteneurevent")
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local pedRotation = GetEntityRotation(ped)
    local animDict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'
    TriggerSWEvent("TREFSDFD5156FD", "IOAPP", 5000)
    loadAnimDict(animDict)
    loadPtfxAsset('scr_tn_tr')

    for i = 1, #ConteneurEventAnim['objects'] do
        loadModel(ConteneurEventAnim['objects'][i])
        ConteneurEventAnim['sceneObjects'][i] = CreateObject(GetHashKey(ConteneurEventAnim['objects'][i]), pedCo, 1, 1, 0)
        NetworkRegisterEntityAsNetworked(ConteneurEventAnim['sceneObjects'][i])
    end

    sceneObject = GetClosestObjectOfType(pedCo, 2.5, GetHashKey('tr_prop_tr_container_01a'), 0, 0, 0)
    lockObject = GetClosestObjectOfType(pedCo, 2.5, GetHashKey('tr_prop_tr_lock_01a'), 0, 0, 0)
    print("sceneObject", sceneObject)
    print("lockObject", lockObject)
    NetworkRegisterEntityAsNetworked(sceneObject)
    NetworkRegisterEntityAsNetworked(lockObject)

    scene = NetworkCreateSynchronisedScene(GetEntityCoords(sceneObject), GetEntityRotation(sceneObject), 2, true, false, 1065353216, 0, 1065353216)

    NetworkAddEntityToSynchronisedScene(sceneObject, scene, animDict, ConteneurEventAnim['animations'][1][2], 1.0, -1.0, 1148846080)
    NetworkAddEntityToSynchronisedScene(lockObject, scene, animDict, ConteneurEventAnim['animations'][1][3], 1.0, -1.0, 1148846080)
    NetworkAddEntityToSynchronisedScene(ConteneurEventAnim['sceneObjects'][1], scene, animDict, ConteneurEventAnim['animations'][1][4], 1.0, -1.0, 1148846080)
    NetworkAddPedToSynchronisedScene(ped, scene, animDict, ConteneurEventAnim['animations'][1][1], 4.0, -4.0, 1033, 0, 1000.0, 0)
    
    SetEntityCoords(ped, GetEntityCoords(sceneObject))
    NetworkStartSynchronisedScene(scene)
    Wait(4000)
    UseParticleFxAssetNextCall('scr_tn_tr')
    sparks = StartParticleFxLoopedOnEntity("scr_tn_tr_angle_grinder_sparks", ConteneurEventAnim['sceneObjects'][1], 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 1)
    Wait(1000)
    StopParticleFxLooped(sparks, 1)
    print("IN DOING")
    Wait(GetAnimDuration(animDict, 'action') * 1000 - 5000)
    local goodRot = GetEntityRotation(sceneObject)
    SetEntityCoordsNoOffset(sceneObject, GetEntityCoords(sceneObject))
    local goodCo = GetEntityCoords(sceneObject)
    SetEntityCoords(p:ped(), -24.989995956421, -2471.361328125, 5.2036824226379)
    SetEntityHeading(p:ped(), 51.2)
    p:PlayAnim("pickup_object", "pickup_low", 0.5)
    Wait(1500)
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Vous avez reçu ~c x"..whattogive[2].." " .. GetItemLabel(whattogive[1])
    })
    TriggerSecurGiveEvent("core:addItemToInventory", token, whattogive[1], whattogive[2], {})
    p:PlayAnim("pickup_object", "pickup_low", 0.5)
    Wait(1500)
    exports['vNotif']:createNotification({
        type = 'VERT',
        content = "Vous avez reçu ~c x"..whattogive[4].." " .. GetItemLabel(whattogive[3])
    })
    TriggerSecurGiveEvent("core:addItemToInventory", token, whattogive[3], whattogive[4], {})
    SetEntityCoords(p:ped(), -23.963584899902, -2472.171875, 5.157758560181)
    print("finished")
    ClearPedTasks(p:ped())
end