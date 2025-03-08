local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local ephemeralPos = {}
local blippos = {}
local vigneDone = 0
local addpos = nil
local playerpos = nil
local near = false
local active = false
local count = 0
local price = 0
local blipDropGrape = nil

local ped = nil
local created = false
if not created then
    ped = entity:CreatePedLocal("a_f_y_vinewood_02", vector3(-1868.0714111328, 2088.7756347656, 139.51187133789),
        325.59)
    created = true
end
SetEntityInvincible(ped.id, true)
ped:setFreeze(true)
TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
SetEntityAsMissionEntity(ped.id, 0, 0)
SetBlockingOfNonTemporaryEvents(ped.id, true)

local propsBox = nil 
propsBox = entity:CreateObjectLocal('prop_partsbox_01', vector3(-1879.7463378906, 2093.9245605469, 139.48886108398))
propsBox:setFreeze(true)


--[[zone.addZone("startVigne",
    vector3(-1868.0714111328, 2088.7756347656, 139.51187133789),
    "Appuyer sur ~INPUT_CONTEXT~ pour récupérer le sécateur",
    function()
        if not active then
            if CheckJobLimit() then
                if not p:haveItem('shears') then
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "shears", 1, {})
                end
                active = true
                startVigne()
                blipDropGrape = AddBlipForCoord(-1879.7463378906, 2093.9245605469, 139.48886108398)
                SetBlipColour(blipDropGrape, 15)
            end
        end
    end
)]]

function startVigne()
    for k=1, #vignePos do
        addpos = vignePos[k]
        ephemeralPos[k] = addpos
        blippos[k] = AddBlipForCoord(addpos)
    end
    CreateThread(function()
        while true do 
            Wait(10)
            for k,v in pairs(ephemeralPos) do
                local dist = #(GetEntityCoords(PlayerPedId()) - v)
                if dist < 25.0 then
                    DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.45, 0.45, 0.45, 238, 130, 238, 175, 1, 0, 0, 0)
                    if dist < 3.0 then
                        ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour ramasser le raisin")
                        if IsControlJustPressed(0, 38) then 
                            RemoveBlip(blippos[k])
                            near = true
                            table.remove(ephemeralPos, k)
                            table.remove(blippos, k)
                            p:PlayAnim('custom@pickfromground', 'pickfromground', 0)
                            Wait(5000)
                            ClearPedTasksImmediately(PlayerPedId())
                            vigneDone = vigneDone + 1
                            TriggerSecurGiveEvent("core:addItemToInventory", token, "grape", 1, {})
                            
                        end
                    end
                end
            end
            DrawMarker(29, -1879.5345458984, 2094.1694335938, 141.0756072998, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 238, 130, 238, 255, 0, 0, 0, 0)
            if active == false then 
                break
            end
        end 
    end)
end

RegisterNetEvent("core:shearsuse", function()
    for k=1, #ephemeralPos do
        playerpos = GetEntityCoords(PlayerPedId())
        vigneCoord = ephemeralPos[k]
        if GetDistanceBetweenCoords(playerpos, vigneCoord) > 2 then
            near = false
        else
            RemoveBlip(blippos[k])
            near = true
            table.remove(ephemeralPos, k)
            table.remove(blippos, k)
            break
        end
    end

    if near then
        p:PlayAnim('custom@pickfromground', 'pickfromground', 0)
        Wait(5000)
        ClearPedTasksImmediately(PlayerPedId())
        vigneDone = vigneDone + 1
        TriggerSecurGiveEvent("core:addItemToInventory", token, "grape", 1, {})
    else
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Aucune grappe à récupérer ici."
        })
    end
end)

local open = false
local main = RageUI.CreateMenu("", "Type de coupe", 0.0, 0.0, "vision", 'menu_title_choiceVigne')
function openVigneSelection()
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true

        RageUI.Visible(main, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("~r~Déposer et continuer", false, {}, true, {
                        onSelected = function()
                            sellAndContinue()
                        end
                    })
                    RageUI.Button("~g~Déposer et arrêter", false, {}, true, {
                        onSelected = function()
                            sellAndStop()
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end

--[[zone.addZone("sellGrappe",
    vector3(-1878.7725830078, 2094.9650878906, 139.44256591797),
    "Appuyer sur ~INPUT_CONTEXT~ pour déposer les grappes de raisin",
    function()
        openVigneSelection()
    end,
    false, -- Avoir un marker ou non
    -1, -- Id / type du marker
    0.6, -- La taille
    { 0, 0, 0 }, -- RGB
    0, -- Alpha
    3 -- Interact dist
)]]

function sellAndContinue()
    if p:getItemCount('grape') == false then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas de grappe à vendre."
        })
    elseif #ephemeralPos == 0 then
        sellAndStop()
    else
        count = p:getItemCount('grape')
        price = count*15
        TriggerServerEvent("core:RemoveItemToInventory", token, "grape", count, {})
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})

        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            duration = 5,
            content = "Vous avez gagnez "..price.."$"
        })
    end
end

function sellAndStop()
    if p:getItemCount('grape') == false then
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            duration = 5, -- In seconds, default:  4
            content = "Vous n'avez pas de grappe à vendre."
        })
    else
        count = p:getItemCount('grape')
        price = count*15
        TriggerServerEvent("core:RemoveItemToInventory", token, "grape", count, {})
        TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})

        exports['vNotif']:createNotification({
            type = 'DOLLAR',
            duration = 5,
            content = "Vous avez gagnez "..price.."$"
        })

        active = false
        for k=1, #blippos do
            RemoveBlip(blippos[k])
        end
        ephemeralPos = {}
        vigneDone = 0
        price = 0
        RemoveBlip(blipDropGrape)
    end
end

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    print("^3[JOBS]: ^7vigneron ^3loaded")
end)