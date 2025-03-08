local smoking = false
local duration = 0
local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

RegisterNetEvent("core:UseWeed")
AddEventHandler("core:UseWeed", function()
    if p:isInVeh() or IsPlayerDead(PlayerPedId()) then
        -- give back the weed
        TriggerSecurGiveEvent("core:addItemToInventory", token, "weed", 1, {})
        return
    end
    -- play scenario
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
    smoking = true

    while smoking and duration < 120000 do
        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter de fumer")
        if IsControlJustPressed(0, 38) then
            smoking = false
            ClearPedTasks(PlayerPedId())
        end
        duration = duration + 10
        Wait(10)
    end
    TriggerEvent("core:WeedEffect")
    ClearPedTasks(PlayerPedId())
    smoking = false
    duration = 0
end)

local isFentanyl = false
RegisterNetEvent("core:UseFentanyl")
AddEventHandler("core:UseFentanyl", function()
    if p:isInVeh() or IsPlayerDead(PlayerPedId()) then
        -- give back the heroine
        TriggerSecurGiveEvent("core:addItemToInventory", token, "fentanyl", 1, {})
        return
    end
    p:PlayAnim("missfbi3_party", "snort_coke_b_male3", 16)
    isFentanyl = true
    while duration < 6000 do
        duration = duration + 10
        Wait(10)
    end
    TriggerEvent("core:FentanylEffect")
    ClearPedTasks(PlayerPedId())
    isFentanyl = false
    duration = 0
end)

local isCoke = false
RegisterNetEvent("core:UseCoke")
AddEventHandler("core:UseCoke", function()
    if p:isInVeh() or IsPlayerDead(PlayerPedId()) then
        -- give back the coke
        TriggerSecurGiveEvent("core:addItemToInventory", token, "coke", 1, {})
        return
    end
    p:PlayAnim("missfbi3_party", "snort_coke_b_male3", 16)
    isCoke = true
    while duration < 6000 do
        duration = duration + 10
        Wait(10)
    end
    TriggerEvent("core:CokeEffect")
    ClearPedTasks(PlayerPedId())
    isCoke = false
    duration = 0
end)

local meth = false
RegisterNetEvent("core:UseMeth")
AddEventHandler("core:UseMeth", function()
    -- when the player uses meth, do the smoking emote for 2 minutes
    if p:isInVeh() or IsPlayerDead(PlayerPedId()) then
        -- give back the meth
        TriggerSecurGiveEvent("core:addItemToInventory", token, "meth", 1, {})
        return
    end
    -- play scenario
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
    meth = true

    while meth and duration < 120000 do
        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter de fumer")
        if IsControlJustPressed(0, 38) then
            meth = false
            ClearPedTasks(PlayerPedId())
        end
        duration = duration + 10
        Wait(10)
    end
    TriggerEvent("core:MethEffect")
    ClearPedTasks(PlayerPedId())
    meth = false
    duration = 0
end)
