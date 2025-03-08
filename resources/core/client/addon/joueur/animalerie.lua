local MyAnimal
MyAnimalPed = nil
local openRadial = false
local AnimalerieOpened = false
local AnimaleMenuOpen = false

isMyAnimalAttacking = false

local pedPos = vector4(561.94110107422, 2749.1552734375, 41.848388671875, 186.16133117676)
local previewPos = vector4(556.53265380859, 2745.5524902344, 41.848304748535, 298.64300537109)
local PreviewPed = nil
local previewCam = {
    pos = vector4(vector4(558.77624511719, 2747.8139648438, 42.272674560547, 134.55010986328)),
    cam = nil
}

DataSendAnimalerie = {
    catalogue = {},
    buttons = {
        {
            name = 'Chiens',
            width = 'full',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            --image = 'https://media.discordapp.net/attachments/498529074717917195/1144402242640826379/image.webp',
            --type = 'coverBackground',
        },
        {
            name = 'Chats',
            width = 'full',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            --image = 'https://media.discordapp.net/attachments/498529074717917195/1144402327164428429/image.webp',
            --type = 'coverBackground',
        },
        {
            name = 'Ferme',
            width = 'full',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            --image = 'https://media.discordapp.net/attachments/498529074717917195/1144402392880791663/image.webp',
            --type = 'coverBackground',
        },
        {
            name = 'Animaux sauvages',
            width = 'full',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            --image = 'https://media.discordapp.net/attachments/498529074717917195/1144402467136733234/image.webp',
            --type = 'coverBackground',
        },
        --{
        --    name = 'Singes',
        --    width = 'half',
        --    --hoverStyle = 'fill-black stroke-black',
        --    hoverStyle = 'stroke-black',
        --    --image = 'https://media.discordapp.net/attachments/498529074717917195/1144402539907924118/image.webp',
        --    --type = 'coverBackground',
        --},
        {
            name = 'Autres',
            width = 'full',
            --hoverStyle = 'fill-black stroke-black',
            hoverStyle = 'stroke-black',
            --image = 'https://media.discordapp.net/attachments/498529074717917195/1144402539907924118/image.webp',
            --type = 'coverBackground',
        },
    },
    --headerIcon = 'https://cdn.sacul.cloud/v2/vision-cdn/icons/bague.webp',
    headerIconName = 'ANIMALERIE',
    headerImage = 'https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951163154726519574661dog.webp',
    callbackName = 'Menu_Animalerie_callback'
}

local AnimauxVente = {
    {
        label = "Rottweiler",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147226753597706341image.webp",
        category = "Chiens",
        ped = "a_c_rottweiler",
        itemname = "rottweiler",
    },
    {
        label = "Cairn terrier",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147913950789386320image.webp",
        category = "Chiens",
        ped = "a_c_westy",
        itemname = "cairn",
    },
    {
        label = "Caniche",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914043558994151image.webp",
        category = "Chiens",
        ped = "a_c_poodle",
        itemname = "caniche",
    },
    {
        label = "Carlin",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914045828112394image.webp",
        category = "Chiens",
        ped = "a_c_pug",
        itemname = "carlin",
    },
    {
        label = "Husky",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914116560855080image.webp",
        category = "Chiens",
        ped = "a_c_husky",
        itemname = "husky",
    },
    {
        label = "Retriever",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914213113729024image.webp",
        category = "Chiens",
        ped = "a_c_retriever",
        itemname = "retriever",
    },
    {
        label = "Berger australien",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914215202496553image.webp",
        category = "Chiens",
        ped = "a_c_shepherd",
        itemname = "shepard",
    },


    {
        label = "Chat",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147918187262914640image.webp",
        category = "Chats",
        ped = "a_c_cat_01",
        itemname = "chat",
    },


    {
        label = "Vache",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914831773569044image.webp",
        category = "Ferme",
        ped = "a_c_cow",
        itemname = "vache",
    },
    {
        label = "Poule",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914827797381191image.webp",
        category = "Ferme",
        ped = "a_c_hen",
        itemname = "poule",
    },
    {
        label = "Cochon",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147914829626089622image.webp",
        category = "Ferme",
        ped = "a_c_pig",
        itemname = "cochon",
    },


    --{
    --    label = "Coyote",
    --    image = "https://cdn.discordapp.com/attachments/498529074717917195/1147918188751892480/image.webp",
    --    category = "Animaux sauvages",
    --    ped = "a_c_coyote",
    --},
    --{
    --    label = "Puma",
    --    image = "https://cdn.discordapp.com/attachments/498529074717917195/1147918254564716637/image.webp",
    --    category = "Animaux sauvages",
    --    ped = "a_c_mtlion",
    --},
    {
        label = "Sanglier",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951147918276698054736image.webp",
        category = "Animaux sauvages",
        ped = "a_c_boar",
        itemname = "sanglier",
    },


    {
        label = "Lapin",
        image = "https://cdn.sacul.cloud/v2/vision-cdn/Discord/4985290747179171951151600123013505034image.webp",
        category = "Autres",
        ped = "a_c_rabbit_01",
        itemname = "lapin",
    },


    --{
    --    label = "Macaque rhésus",
    --    image = "https://cdn.discordapp.com/attachments/498529074717917195/1151600134971465738/image.webp",
    --    category = "Singes",
    --    ped = "a_c_rhesus",
    --},
    --{
    --    label = "Chimpanzé",
    --    image = "https://cdn.discordapp.com/attachments/498529074717917195/1147920650070134934/image.webp",
    --    category = "Singes",
    --    ped = "a_c_chimp",
    --},
}

DataSendCanine = {
    current = 2,
    header = "https://cdn.sacul.cloud/v2/vision-cdn/headers/gestionanimal.webp",
    attaques = {
        {
            id = 1,
            label = "Attaquer",
            callbackName = "attackAnim",
        }
    },
    poses = {
        {
            id = 1,
            label = "Aucun",
            callbackName = "rompich",
        },   
        --{
        --    id = 2,
        --    label = "Dormir",
        --    callbackName = "rompich",
        --},
    },
    actions = {
        {
            id = 1,
            label = "Suivre/Rappeler",
            callbackName = "followAnim",
        },
        {
            id = 2,
            label = "Entrer dans le véhicule",
            callbackName = "EnterVAnim",
        },
        {
            id = 3,
            label = "Sortir du véhicule",
            callbackName = "ExitVAnim",
        }
    },
    apparences = AnimauxVente,
}

local function GetDatas()
    DataSendAnimalerie.catalogue = {}
    for k, v in pairs(AnimauxVente) do
        table.insert(DataSendAnimalerie.catalogue, {id = k, ped = v.ped, itemname = v.itemname, isPremium = true, price = 1000, image=v.image, category=v.category, label=v.label, ownCallbackName= 'Menu_Animalerie_preview_callback'})
    end
    return true
end

RegisterNUICallback("focusOut", function()
    if AnimalerieOpened then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(previewCam.cam)
        AnimalerieOpened = false
    end
    if AnimaleMenuOpen then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(previewCam.cam)
        AnimaleMenuOpen = false
    end
    if PreviewPed then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(previewCam.cam)
        DeleteEntity(PreviewPed.id)
        PreviewPed = nil
    end
end)

function OpenRadialAnimalerie()
    closeUI()
    Wait(100)
    if not openRadial then
        openRadial = true
        CreateThread(function()
            while openRadial do
                Wait(0)
                DisableControlAction(0, 1, openRadial)
                DisableControlAction(0, 2, openRadial)
                DisableControlAction(0, 142, openRadial)
                DisableControlAction(0, 18, openRadial)
                DisableControlAction(0, 322, openRadial)
                DisableControlAction(0, 106, openRadial)
                DisableControlAction(0, 24, true) -- disable attackAnim
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
                if IsControlJustPressed(0, 202) then 
                    closeUI()
                    openRadial = false
                end
            end
        end)
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        Wait(200)
        CreateThread(function()
            SendNuiMessage(json.encode({
                type = 'openWebview',
                name = 'RadialMenu',
                data = { elements = {
                    {
                        name = "APPARENCE",
                        --icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/billet.svg",
                        action = "ApparenceAnimaux"
                    },
                    {
                        name = "POSES",
                        --icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/checkmark.svg",
                        action = "PosesAnimaux"
                    },
                    {
                        name = "SORTIR / RANGER",
                        --icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/paper.svg",
                        action = "SortirRangerAnimaux"
                    },
                    {
                        name = "ACTIONS",
                        --icon = "https://cdn.sacul.cloud/v2/vision-cdn/svg/radial/megaphone.svg",
                        action = "ActionsAnimaux"
                    }, 
                }, title = "GESTION ANIMAL", hideKey = true }
            }));
        end)
    else
        openRadial = false
        closeUI()
        return
    end
end

function SortirRangerAnimaux()
    if MyAnimalPed then
        DespawnMyAnimal()
    else
        SpawnMyAnimal()
    end
end

function PosesAnimaux()
    local elementsAnimaux = {}
    for k,v in pairs(DataSendCanine.poses) do 
        table.insert(elementsAnimaux, {name = v.label, action = v.callbackName})
    end
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'RadialMenu',
        data = { 
            elements = elementsAnimaux, 
        title = "POSES", hideKey = true }
    }));        
end

function ApparenceAnimaux()
    --[[local MyAnimaux = TriggerServerCallback("core:getAnimaux")
    local AnimauxReturn = {}
    if MyAnimaux and next(MyAnimaux) then
        for k,v in pairs(AnimauxVente) do
            for i,z in pairs(MyAnimaux) do
                if v.ped == z.ped then
                    table.insert(AnimauxReturn, {name = v.label, image = v.image, category = v.category, ped = v.ped})
                end
            end
        end
    end
    for k,v in pairs(DataSendCanine.actions) do 
        table.insert(elementsAnimaux, {name = v.label, action = v.callbackName})
    end
    
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'RadialMenu',
        data = { 
            elements = elementsAnimaux, 
        title = "ACTIONS" }
    }));]]
end

function ActionsAnimaux()
    local elementsAnimaux = {}
    for k,v in pairs(DataSendCanine.actions) do 
        table.insert(elementsAnimaux, {name = v.label, action = v.callbackName})
    end
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'RadialMenu',
        data = { 
            elements = elementsAnimaux, 
        title = "ACTIONS", hideKey = true }
    }));
end

local Chargement = false
RegisterNUICallback("Menu_Animalerie_preview_callback", function(data)
    if data.ped then
        if Chargement then
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = 'Chargement du model...'
            })
        else
            Chargement = true
            TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 3000)
            if PreviewPed then
                DeleteEntity(PreviewPed.id)
                PreviewPed = nil
            end
            PreviewPed = entity:CreatePed(data.ped, previewPos.xyz)
            SetEntityHeading(PreviewPed.id, previewPos.w)
            FreezeEntityPosition(PreviewPed.id, true)
            SetEntityInvincible(PreviewPed.id, true)

            if previewCam.cam then
                DestroyCam(previewCam.cam, true)
                previewCam.cam = nil
            end
            previewCam.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            SetCamCoord(previewCam.cam, previewCam.pos.xyz)
            SetCamRot(previewCam.cam, 0.0, 0.0, previewCam.pos.w, 2)
            SetCamFov(previewCam.cam, 50.0)
            RenderScriptCams(true, false, 0, 1, 0)
            Wait(2000)
            Chargement = false
        end
    end
end)

RegisterNUICallback("Menu_Animalerie_callback", function(data)
    if data.category and data.ped then
        if p:pay(1000) then
            --TriggerServerEvent("core:buyAnimal", data.ped)
            TriggerSecurGiveEvent("core:addItemToInventory", token, data.itemname, 1, {
                premium = true
            })
            exports['vNotif']:createNotification({
                type = 'VERT',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous avez acheté un " .. data.label
            })
            SendNuiMessage(json.encode({
                type = 'closeWebview',
            }))
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~c Vous n'avez pas assez d'argent"
            })
        end
    end
end)

CreateThread(function()
    while zone == nil do
        Wait(1)
    end
    local ped = entity:CreatePedLocal("a_m_m_farmer_01", pedPos.xyz, pedPos.w)
    ped:setFreeze(true)
    SetEntityInvincible(ped.id, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
    zone.addZone("animelerie",
        pedPos.xyz + vector3(0.0, 0.0, 2.0),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir l'animalerie",
        function()
            if not AnimalerieOpened then
                OpenAnimalerie()
            end
        end,
        false, -- Avoir un marker ou non
        29, -- Id / type du marker
        1.0, -- La taille
        {50, 168, 82}, -- RGB
        170, -- Alpha
        5.0,
        true,
        "bulleAnimalerie"
    )

    -- Bulle Animalerie
end)

function OpenAnimalerie()
    local bool = GetDatas()
    while not bool do
        Wait(1)
    end
    AnimalerieOpened = true
    DataSendAnimalerie.isUserPremium = p:getSubscription()
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuGrosCatalogue',
        data = DataSendAnimalerie
    }))
end

function SpawnMyAnimal()
    TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 5000)
    if not MyAnimal then return end
    RequestModel(GetHashKey(MyAnimal.ped))
    Wait(900)
    local coords, forward = GetEntityCoords(p:ped()), GetEntityForwardVector(p:ped())
    local objCoords = (coords + forward * 0.5)
    local x,y,z = table.unpack(objCoords)
    MyAnimalPed = entity:CreatePed(MyAnimal.ped, vector3(x,y,z-0.90)).id
    SetEntityAsMissionEntity(MyAnimalPed, true, true)
    SetBlockingOfNonTemporaryEvents(MyAnimalPed, true)
    local lbip = AddBlipForEntity(MyAnimalPed)
    SetBlipAsFriendly(lbip, true)
    if MyAnimal and MyAnimal.category == "Chiens" then
        DataSendCanine.attaques = {
            {
                id = 1,
                label = "Attaquer",
                callbackName = "attackAnim",
            }
        }
        DataSendCanine.poses = {
            {
                id = 1,
                label = "Assis",
                callbackName = "poseSit",
            },
            {
                id = 2,
                label = "Couché",
                callbackName = "couche",
            },
            {
                id = 3,
                label = "Réclamer",
                callbackName = "behDOg",
            },
            {
                id = 4,
                label = "Donner la patte",
                callbackName = "patte",
            },
        }
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Pas bouger",
                callbackName = "nomooveAnim",
            },
            {
                id = 3,
                label = "Aboyer",
                callbackName = "barkAnim",
            },
            {
                id = 4,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 5,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    elseif MyAnimal and MyAnimal.category == "Chats" then
        DataSendCanine.attaques = {
            {
                id = 1,
                label = "Attaquer",
                callbackName = "attackAnim",
            }
        }
        DataSendCanine.poses = {
            {
                id = 1,
                label = "Aucun",
                callbackName = "Aucun",
            },
        }
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 3,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    elseif MyAnimal and MyAnimal.category == "Singes" then
        DataSendCanine.attaques = {}
        DataSendCanine.poses = {}
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 3,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    else
        DataSendCanine.attaques = {
            {
                id = 1,
                label = "Attaquer",
                callbackName = "attackAnim",
            }
        }
        DataSendCanine.poses = {
            {
                id = 1,
                label = "Aucun",
                callbackName = "Aucun",
            },
        }
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 3,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    end
    CreateThread(function()
        while MyAnimalPed do
            Wait(1)
            local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(MyAnimalPed))
            if dist and dist < 2.0 then
                if not AnimaleMenuOpen then
                    --ShowHelpNotification("~INPUT_PICKUP~ Gestion Animal")
                    if IsControlJustPressed(0, 38) then
                        --OpenAnimalMenu()
                        --OpenRadialAnimalerie()
                        OpenMenuAnimalerie()
                    end
                end
            end
            Bulle.create("monChien", GetEntityCoords(MyAnimalPed) + vector3(0.0, 0.0, 0.5), "bulleGererAnimal", true)
        end
        Bulle.remove("monChien")
    end)
end

function DespawnMyAnimal()
    DeleteEntity(MyAnimalPed)
    MyAnimalPed = nil
end

function OpenAnimalMenu()
    AnimaleMenuOpen = true
    local MyAnimaux = TriggerServerCallback("core:getAnimaux")
    local AnimauxReturn = {}
    if MyAnimaux and next(MyAnimaux) then
        for k,v in pairs(AnimauxVente) do
            for i,z in pairs(MyAnimaux) do
                if v.ped == z.ped then
                    table.insert(AnimauxReturn, {label = v.label, image = v.image, category = v.category, ped = v.ped})
                end
            end
        end
    end
    Wait(200)
    DataSendCanine.apparences = AnimauxReturn
    if MyAnimal and MyAnimal.category == "Chiens" then
        DataSendCanine.attaques = {
            {
                id = 1,
                label = "Attaquer",
                callbackName = "attackAnim",
            }
        }
        DataSendCanine.poses = {
            {
                id = 1,
                label = "Assis",
                callbackName = "poseSit",
            },
            {
                id = 2,
                label = "Couché",
                callbackName = "couche",
            },
            {
                id = 3,
                label = "Réclamer",
                callbackName = "behDOg",
            },
            {
                id = 4,
                label = "Donner la patte",
                callbackName = "patte",
            },
        }
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Pas bouger",
                callbackName = "nomooveAnim",
            },
            {
                id = 3,
                label = "Aboyer",
                callbackName = "barkAnim",
            },
            {
                id = 4,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 5,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    elseif MyAnimal and MyAnimal.category == "Chats" then
        DataSendCanine.attaques = {
            {
                id = 1,
                label = "Attaquer",
                callbackName = "attackAnim",
            }
        }
        DataSendCanine.poses = {
            {
                id = 1,
                label = "Aucun",
                callbackName = "Aucun",
            },
        }
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Pas bouger",
                callbackName = "nomooveAnim",
            },
            {
                id = 3,
                label = "Aboyer",
                callbackName = "barkAnim",
            },
            {
                id = 4,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 5,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    elseif MyAnimal and MyAnimal.category == "Singes" then
        DataSendCanine.attaques = {}
        DataSendCanine.poses = {}
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 3,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    else
        DataSendCanine.attaques = {
            {
                id = 1,
                label = "Attaquer",
                callbackName = "attackAnim",
            }
        }
        DataSendCanine.poses = {}
        DataSendCanine.actions = {
            {
                id = 1,
                label = "Suivre/Rappeler",
                callbackName = "followAnim",
            },
            {
                id = 2,
                label = "Entrer dans le véhicule",
                callbackName = "EnterVAnim",
            },
            {
                id = 3,
                label = "Sortir du véhicule",
                callbackName = "ExitVAnim",
            }
        }
    end
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'MenuK9',
        data = DataSendCanine
    }))
end

RegisterCommand("K9", function()
    ExecuteCommand("animal")
end)

RegisterCommand("animal", function()
    if p:getSubscription() >= 1 then
        OpenAnimalMenu()
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "~c Vous devez avoir le premium pour pouvoir utiliser le menu K9"
        })
    end
end)

RegisterNUICallback("MenuK9", function(data)
    if data.button then
        if data.button == "appear" then
            SpawnMyAnimal()
        end
        if data.button == "disappear" then
            DespawnMyAnimal()
        end
        if data.button == "attackAnim" then
            if MyAnimalPed then
                AnimalAttack(MyAnimalPed)
            end
        end
        if data.button == "poseSit" then
            if MyAnimalPed then
                Command_Sit(MyAnimalPed)
            end
        end
        if data.button == "ExitVAnim" then
            if MyAnimalPed then
                if p:currentVeh() then
                    TaskLeaveVehicle(MyAnimalPed, p:currentVeh(), 16)
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous devez ~s être ~c dans un véhicule"
                    })
                end
            end
        end
        if data.button == "EnterVAnim" then
            if MyAnimalPed then
                if p:currentVeh() then
                    SetVehicleDoorOpen(p:currentVeh(), 3, false, false)
                    TaskEnterVehicle(MyAnimalPed, p:currentVeh(), -1, 2, 1.0, 16, 0)
                    Wait(1000)
                    SetVehicleDoorShut(p:currentVeh(), 3, false)
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous devez ~s être ~c dans un véhicule"
                    })
                end
            end
        end
        if data.button == "behDOg" then
            if MyAnimalPed then
                Command_beg(MyAnimalPed)
            end
        end
        if data.button == "patte" then
            if MyAnimalPed then
                Command_paw(MyAnimalPed)
            end
        end
        if data.button == "couche" then
            if MyAnimalPed then
                Command_Lay(MyAnimalPed)
            end
        end
        if data.button == "followAnim" then
            if MyAnimalPed then
                Command_Follow(MyAnimalPed)
            end
        end
        if data.button == "nomooveAnim" then
            if MyAnimalPed then
                Command_Stay(MyAnimalPed)
            end
        end
        if data.button == "barkAnim" then
            if MyAnimalPed then
                Command_Bark(MyAnimalPed)
            end
        end
    elseif data.apparence then
        if MyAnimal and MyAnimalPed then
            DeleteEntity(MyAnimalPed)
            MyAnimalPed = nil
        end
        MyAnimal = data.apparence
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = 'Vous avez sélectionné un ' .. data.apparence.label .. ' comme animal de compagnie.'
        })
    elseif not next(data) then
        SendNuiMessage(json.encode({
            type = 'closeWebview',
        }))
        Wait(100)
        OpenAnimalMenu()
    end
end)

function AnimalAttack(animal)
    if isMyAnimalAttacking then
        isMyAnimalAttacking = false
        ClearPedTasksImmediately(animal)
    else
        attackK9(animal)
    end
end

RegisterCommand("getAnimaux", function()
    local result = TriggerServerCallback("core:getAnimaux")
end)


function attackAnim()
    if MyAnimalPed then
        AnimalAttack(MyAnimalPed)
    end
end
function poseSit()
    if MyAnimalPed then
        Command_Sit(MyAnimalPed)
    end
end
function ExitVAnim()
    if MyAnimalPed then
        if p:currentVeh() then
            TaskLeaveVehicle(MyAnimalPed, p:currentVeh(), 16)
            CreateThread(function()
                Wait(1000)
                if IsEntityDead(MyAnimalPed) then 
                    ResurrectPed(MyAnimalPed)
                end
            end)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous devez ~s être ~c dans un véhicule"
            })
        end
    end
end
function EnterVAnim()
    if MyAnimalPed then
        if p:currentVeh() then
            SetVehicleDoorOpen(p:currentVeh(), 3, false, false)
            TaskEnterVehicle(MyAnimalPed, p:currentVeh(), -1, 2, 1.0, 16, 0)
            Wait(1000)
            SetVehicleDoorShut(p:currentVeh(), 3, false)
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous devez ~s être ~c dans un véhicule"
            })
        end
    end
end
function behDOg()
    if MyAnimalPed then
        Command_beg(MyAnimalPed)
    end
end
function patte()
    if MyAnimalPed then
        Command_paw(MyAnimalPed)
    end
end
function couche()
    if MyAnimalPed then
        Command_Lay(MyAnimalPed)
    end
end
function followAnim()
    if MyAnimalPed then
        Command_Follow(MyAnimalPed)
    end
end
function nomooveAnim()
    if MyAnimalPed then
        Command_Stay(MyAnimalPed)
    end
end
function barkAnim()
    if MyAnimalPed then
        Command_Bark(MyAnimalPed)
    end
end


RegisterNetEvent("core:useanimal", function(animal)
    for k,v in pairs(AnimauxVente) do
        if v.itemname == animal then 
            if MyAnimalPed then
                DespawnMyAnimal()
            else
                MyAnimal = {}
                MyAnimal.category = v.category
                MyAnimal.ped = v.ped
                SpawnMyAnimal()
            end
        end
    end
end)