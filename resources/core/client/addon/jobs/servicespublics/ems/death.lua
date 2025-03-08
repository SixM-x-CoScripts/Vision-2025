-- Lorsque le joueur tombe coma il faut qu'il attende 2 minutes avant de pouvoir respawn à l'hôpital tout seul.
-- Cependant, il peut aussi décider d'attendre les EMS dans quel cas il faudrait que lors du coma, le joueur ait la possibilité de choisir soit :
-- Attendre 2 minutes et se TP à l'hôpital
-- Rester sur place et faire un call EMS
-- Avant de faire son choix, une interface avec un cadre de texte doit apparaître dans lequel il écrit ce qu'il s'est passé pour qu'il tombe coma (préciser au joueur que ce cadre est full HRP et existe pour aider l'EMS lorsqu'il va arriver sur place ou servira de logs pour tous les comas et éviter le nopain sur de grosses scènes)
-- Ce texte doit être accessible pour les EMS lorsqu'ils arrivent sur place et voient le patient au sol. Il faut donc que lorsque les EMS choisissent de faire l'interaction ""Circonstances de l'inconscience"", ils voient le cadre de texte écrit par le joueur (style Lawless)
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local isDead = false
local timer = 5 * 60000
local times = nil
local motif = ""
local finishTimer = false

local UI = { {
    label = "background_call",
    pos = { 0.43177086114883, 0.8629629611969 },
    color = {},
    alpha = 100,
    action = function()

    end,
    finishTimer = true,

    dev = false
}, {
    label = "background_revive",
    pos = { 0.51458334922791, 0.8629629611969 },
    color = { 255, 255, 255 },
    alpha = 100,
    action = function()
        if finishTimer then
            finishTimer = false
        end
    end,
    finishTimer = false,
    dev = false
} }

local deathTime = 0
local IsKO = false
local weaponHashType = { "inconnue", "dégâts de mêlée", "blessure par balle", "chute", "dégâts explosifs", "feu", "chute", "éléctrique", "écorchure", "gaz", "gaz", "eau" }
AddEventHandler('core:onPlayerDeath', function(data)
    if not IsKO then
        isDead = true
        local time = 300
        if data and data.deathCause == -842959696 then 
            time = 120
        elseif data and data.deathCause == 0 then 
            time = 240
        end
        if weaponHashType[GetWeaponDamageType(GetPedCauseOfDeath(PlayerPedId()))] == "dégâts de mêlée" then 
            if p:getPermission() >= 5 then
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    content = "~s TKT FREROT TES PERMS 5 PAS DE KO HEHE"
                })
                PlayerInComa(time)
            else
                deathTime = GetGameTimer()
                SetPedToRagdoll(p:ped(), 1000, 1000, 0, 1, 1, 0)
                KO()
            end

        else
            PlayerInComa(time)
        end
    else
        local time = 300
        if data and data.deathCause == -842959696 then 
            time = 120
        elseif data and data.deathCause == 0 then 
            time = 240
        end
        PlayerInComa(time)
    end
end)

local waitTimeKO = 30 * 1000 -- 30s
function KO()
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        -- duration = 5, -- In seconds, default:  4
        content = "~s Vous êtes KO"
    })
    IsKO = true
    SendNuiMessage(json.encode({
        type = 'closeWebview',
    }));
    Wait(500)
    if GetResourceState("ZeroTrust") == "started" then
        exports["ZeroTrust"]:Resurected()
    end
    TriggerEvent("core:RevivePlayer")
    ShakeGameplayCam('HAND_SHAKE', 1.5)
    local newlife = GetEntityMaxHealth(PlayerPedId())/3
    SetEntityHealth(PlayerPedId(), math.floor(newlife))
    SetPedCanRagdoll(PlayerPedId(), true)
    while IsKO do 
        Wait(1)
        SetPedToRagdoll(PlayerPedId(), 6000, 6000, 0, 0, 0, 0)
        deathTime = deathTime or GetGameTimer()
        local t = deathTime + waitTimeKO
        if t < GetGameTimer() then 
            ClearTimecycleModifier()
            IsKO = false
        end
    end
    SetPedCanRagdoll(PlayerPedId(), false)
end

function PlayerInComa(time)
    isDead = true
    if time == nil then time = 300 end
    OpenDeathscreen(time)
end

RegisterNetEvent("core:IsDeadStatut")
AddEventHandler("core:IsDeadStatut", function(statut)
    isDead = statut
end)

function OpenDeathscreen(time)
    forceHideRadar()

    local ambulancier = (GlobalState['serviceCount_ems'] or 0) + (GlobalState['serviceCount_lsfd'] or 0) + (GlobalState['serviceCount_bcms'] or 0)
    if ambulancier >= 1 then
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Deathscreen',
            data = {
                secToWait = time
            }
        }));
    else
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'Deathscreen',
            data = {
                secToWait = time == 300 and time/5 or time
            }
        }));
    end

    TriggerScreenblurFadeIn(10)
end

local cooldownems = false
function DeathscreenCallEmergency()
    if isDead then
        if not cooldownems then
            cooldownems = true
            -- ShowNotification("Vous avez envoyé un appel aux EMS")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'JAUNE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez envoyé un appel ~s aux SAMS"
            })

            TriggerSecurEvent('core:makeCall', "sams", p:pos(), false, "Patient dans le coma")
            TriggerSecurEvent('core:makeCall', "bcms", p:pos(), false, "Patient dans le coma")
            TriggerSecurEvent('core:makeCall', "ems", p:pos(), false, "Patient dans le coma")
            TriggerSecurEvent('core:makeCall', "lsfd", p:pos(), false, "Patient dans le coma")
            Wait(120000)
            cooldownems = false 
        else
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Vous avez déjà envoyé un appel ~s aux SAMS"
            })
        end
    end
end

function DeathscreenRespawn()
    if isDead then
        -- ShowNotification("Vous venez de vous réveiller")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            -- duration = 5, -- In seconds, default:  4
            content = "Vous venez de vous ~s réveiller"
        })

        TriggerEvent('core:RevivePlayer')
        TriggerScreenblurFadeOut(10)
        openRadarProperly()
        -- Ci-dessous vous permets de fermer le deathscreen où n'importe quel interface ouverte.
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }));
    end
end

RegisterNUICallback('deathscreen__action', function(data, cb)
    _G[data.action]()
    Wait(200)
    SendNuiMessage(json.encode({
        type = 'response',
        uuid = data.uuid,
        data = {}
    }));
end)

-- Citizen.CreateThread(function()
--     while p == nil do Wait(0) end

--     while true do
--         if not IsPedDeadOrDying(p:ped(), true) and not isDead then
--             local name, bone = p:GetAllLastDamage()
--             for k, v in pairs(Death.GetAllDamagePed) do
--                 if bone ~= nil and v ~= bone then
--                     table.insert(Death.GetAllDamagePed, { name = name, bone = bone })

--                 end
--             end

--             -- if json.encode(Death.GetAllDamagePed) == "[]" then
--             --     if bone ~= nil and name ~= nil then
--             --         table.insert(Death.GetAllDamagePed, { name = name, bone = bone })

--             --     end
--             -- end
--         end
--         Wait(500)
--     end
-- end)

-- RegisterCommand("blur", function()
--     TriggerScreenblurFadeOut(10)
-- end)
