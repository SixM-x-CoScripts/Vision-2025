local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local zoneData = {}

local policeMans = 0
local lockedList = {}
local sold = false
local closestNPC = nil

local DrugsType = {
    {
        name = "WEED",
        icon = "",
        item = "weed",
        action = "sell_weed"
    }, 
    {
        name = "METH",
        icon = "",
        item = "meth",
        action = "sell_meth"
    },
    {
        name = "COKE",
        icon = "",
        item = "coke",
        action = "sell_coke"
    },
    {
        name = "ECSTASY",
        icon = "",
        item = "ecstasy",
        action = "sell_ecstasy"
    },
    {
        name = "FENTANYL",
        icon = "",
        item = "fentanyl",
        action = "sell_fentanyl"
    }
}

local prices = {
    ['weed'] = RealRandom(80, 90),
    ['fentanyl'] = RealRandom(90, 100),
    ['coke'] = RealRandom(150, 180),
    ['meth'] = RealRandom(200, 230),
    ['ecstasy'] = RealRandom(150, 200),
}

function sell_drug(drug)
    local drugsVariable = GetVariable("drugs")

    closeUI()
    local zoneId = GetZoneAtCoords(p:pos())
    Bulle.remove("ventepnj")
    zoneData = TriggerServerCallback("core:GetZoneDataDrugs", tostring(zoneId))
    Wait(300)
    local data = {}
    local crew = p:getCrew()
    local zoneName = GetNameOfZone(p:pos())
    if zoneData == nil then
        data[crew] = 1
        TriggerServerEvent("core:CreateZoneData", token, tostring(zoneId), zoneName, data)
    end
    Wait(500)
    zoneData = TriggerServerCallback("core:GetZoneDataDrugs", tostring(zoneId))
    if zoneData then
        data = zoneData.data
        local value = {}
        for key, values in pairs(data) do
            if key ~= "None" then
                table.insert(value, { name = key, v = values })
            end
        end
        print("go zone2")
        table.sort(value, function(a, b) return a.v > b.v end)
        if value[1] ~= nil then
            if p:getCrew() == value[1].name then
                leader = true
            end
        end
    end
    --Vente
    local ramdom = math.random(1, 4)
    if ramdom == 1 then                             
        if coordsIsInSouth(p:pos()) then
            TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Trafic de drogue", false, "illegal")
            TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Trafic de drogue", false, "illegal") -- FIX_LSSD_LSPD
            TriggerSecurEvent('core:makeCall', "gcp", p:pos(), true, "Trafic de drogue", false, "illegal")
        else
            TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Trafic de drogue", false, "illegal")
            TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Trafic de drogue", false, "illegal") -- FIX_LSSD_LSPD
        end
        -- ShowNotification("Desolé je ne suis pas intéressé")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'ROUGE',
            -- duration = 5, -- In seconds, default:  4
            content = "Desolé je ne suis pas intéressé"
        })

        local closestNPCId = NetworkGetNetworkIdFromEntity(closestNPC)
        local tablee = {}
        for k, v in pairs(GetActivePlayers()) do
            table.insert(tablee, GetPlayerServerId(v))
        end 
        TriggerServerEvent("drug:pedLock", closestNPCId, tablee)
    else           
        local closestNPCId = NetworkGetNetworkIdFromEntity(closestNPC)
        sold = false
        for k, v in pairs(lockedList) do
            if v == closestNPCId then
                sold = true
            end
        end
        local tablee = {}
        for k, v in pairs(GetActivePlayers()) do
            table.insert(tablee, GetPlayerServerId(v))
        end 
        TriggerServerEvent("drug:pedLock", closestNPCId, tablee)
        if sold then
            -- ShowNotification("Desolé je ne suis pas intéressé")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Desolé je ne suis pas intéressé"
            })
            
        else
            local selling = false

            local count = p:getItemCount(drug)

            if not count then
                if coordsIsInSouth(p:pos()) then
                    TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Trafic de drogue", false, "illegal")
                    TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Trafic de drogue", false, "illegal") -- FIX_LSSD_LSPD
                    TriggerSecurEvent('core:makeCall', "gcp", p:pos(), true, "Trafic de drogue", false, "illegal")
                else
                    TriggerSecurEvent('core:makeCall', "lssd", p:pos(), true, "Trafic de drogue", false, "illegal")
                    TriggerSecurEvent('core:makeCall', "lspd", p:pos(), true, "Trafic de drogue", false, "illegal") -- FIX_LSSD_LSPD
                end
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Desolé je ne suis pas intéressé"
                })
                return
            end

            if count > 4 then
                count = 4
            end

            count = tonumber(math.random(1, count))
            local price
            if drugsVariable and drugsVariable[drug] then
                print(drugsVariable[drug].winMin, drugsVariable[drug].winMax)
                if tonumber(drugsVariable[drug].winMin) > tonumber(drugsVariable[drug].winMax) then 
                    print("[^3ERREUR MODO^7] La variable minimum est supérieur à celle maximum, modifiez la variable !")
                    price = prices[drug]
                else
                    price = math.random(tonumber(drugsVariable[drug].winMin or 0), tonumber(drugsVariable[drug].winMax or 0))
                end
            else
                price = prices[drug]
            end
            print("Price", price)
            local total = count * price

            local totalPrice = price * count

            if leader then
                totalPrice = totalPrice * 1.07
            end

            ActionInTerritoire(p:getCrew(), GetZoneByPlayer(), GetVariable("drugs").influence or 1, 7, coordsIsInSouth(GetEntityCoords(PlayerPedId())))
            AnimAndLoad(closestNPC)
            SellDrugs(drug, count, Round(totalPrice))
            selling = true

            --if value and value[1] ~= nil then
            --    if p:getCrew() ~= value[1].name then
            --        TriggerServerEvent("drugs:notifDrugs", value[1].name, zoneData.label)
            --    end
            --end
        end
    end
end

function SellDrugs(drugs, count, price)
    local crew = p:getCrew()
    local zoneId = GetZoneAtCoords(p:pos())
    local zoneName = GetNameOfZone(p:pos())
    zoneData = TriggerServerCallback("core:GetZoneDataDrugs", tostring(zoneId))
    Wait(500)
    local data = {}
    if zoneData ~= nil then
        data = zoneData.data
        if data[crew] ~= nil then
            data[crew] = data[crew] + 1
            TriggerServerEvent("core:UpdateZoneDrugs", token, tostring(zoneId), zoneName, data)
            for key, value in pairs(p:getInventaire()) do
                if value.name == drugs then
                    local xp = 10 --GetVariable("drugs")[drugs].xp
                    if GetVariable("drugs") then 
                        if type(GetVariable("drugs")) == "table" and GetVariable("drugs")[drugs] then 
                            if GetVariable("drugs")[drugs].xp then 
                                xp = GetVariable("drugs")[drugs].xp
                            end
                        end
                    end
                    print(xp, drugs)
                    TriggerServerEvent("core:RemoveItemToInventory", token, drugs, count, value.metadatas)
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                    TriggerSecurEvent("core:crew:updateXp", token, xp, "add", p:getCrew(), "sell drugs")

                    Bulle.remove("ventepnj")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez vendu ~s " .. count .. " " .. drugs .. "~c pour ~s " .. price .. "$"
                    })

                    return
                end
            end

        else
            data[crew] = 1
            TriggerServerEvent("core:UpdateZoneDrugs", token, tostring(zoneId), zoneName, data)
            for key, value in pairs(p:getInventaire()) do
                -- body
                if value.name == drugs then
                    TriggerServerEvent("core:RemoveItemToInventory", token, drugs, count, value.metadatas)
                    TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                    TriggerSecurEvent("core:crew:updateXp", token, count, "add", p:getCrew(), "update zone")
                    
                    Bulle.remove("ventepnj")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        -- duration = 5, -- In seconds, default:  4
                        content = "Vous avez vendu ~s " .. count .. " " .. drugs .. "~c pour ~s " .. price .. "$"
                    })

                    return
                end
            end


        end
    else
        data[crew] = 1
        TriggerServerEvent("core:CreateZoneData", token, tostring(zoneId), zoneName, data)
        for key, value in pairs(p:getInventaire()) do
            if value.name == drugs then
                TriggerServerEvent("core:RemoveItemToInventory", token, drugs, count, value.metadatas)
                TriggerSecurGiveEvent("core:addItemToInventory", token, "money", price, {})
                TriggerSecurEvent("core:crew:updateXp", token, count, "add", p:getCrew(), "create zone")

                Bulle.remove("ventepnj")
                
                -- New notif
                exports['vNotif']:createNotification({
                    type = 'VERT',
                    -- duration = 5, -- In seconds, default:  4
                    content = "Vous avez vendu ~s " .. count .. " " .. drugs .. "~c pour ~s " .. price .. "$"
                })

                return
            end
        end
    end

end

function AnimAndLoad(closestNPC)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'Progressbar',
        data = {
            text = "Vente en cours...",
            time = 4,
        }
    }))

    local coords = GetEntityCoords(PlayerPedId())
    TaskTurnPedToFaceEntity(closestNPC, p:ped(), -1)
    -- make the ped not flee
    SetPedFleeAttributes(closestNPC, 0, 0)
    TaskStandStill(closestNPC, 1000000)
    SetEntityAsMissionEntity(closestNPC)
    TriggerServerEvent('drug:SellDrugs')
    local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.7, 0.0)
    local heading = GetEntityHeading(p:ped())
    SetEntityCoords(closestNPC, pos.x, pos.y, pos.z - 1)
    SetEntityHeading(closestNPC, heading - 180.0)
    FreezeEntityPosition(closestNPC, true)
    FreezeEntityPosition(p:ped(), true)

    Modules.UI.RealWait(500)
    -- anim
    local pid = p:ped()
    RequestAnimDict("mp_ped_interaction")
    while not HasAnimDictLoaded("mp_ped_interaction") do Wait(0) end

    TaskPlayAnim(closestNPC, "mp_ped_interaction", "handshake_guy_b", 2.0, 2.0, -1, 120, 0, false, false, false)
    TaskPlayAnim(pid, "mp_ped_interaction", "handshake_guy_a", 2.0, 2.0, -1, 120, 0, false, false, false)
    Modules.UI.RealWait(4000)
    StopAnimTask(pid, "mp_ped_interaction", "handshake_guy_b", 1.0)
    StopAnimTask(closestNPC, "mp_ped_interaction", "handshake_guy_a", 1.0)
    FreezeEntityPosition(closestNPC, false)
    TaskWanderStandard(closestNPC, 10.0, 10)
    FreezeEntityPosition(p:ped(), false)
    SetEntityAsNoLongerNeeded(closestNPC)

end

local function OpenDrugsRadial(elementssend)
    SendNuiMessage(json.encode({
        type = 'openWebview',
        name = 'RadialMenu',
        data = { elements = elementssend, title = "DROGUES", hideKey = true }
    }));
end

function HasMultipleDrugs()
    local drugCount = 0
    local typeD = nil
    for k,v in pairs(prices) do 
        local count = p:getItemCount(k)
        if count then 
            drugCount += 1
            if typeD == nil then
                typeD = k
            else
                if type(typeD) ~= "table" then
                    local olddrug = typeD
                    typeD = {}
                    table.insert(typeD, k)
                    table.insert(typeD, olddrug)
                else
                    table.insert(typeD, k)
                end
            end
        end
    end
    Wait(10)
    return drugCount, typeD
end

local function failsell()
    exports['vNotif']:createNotification({
        type = 'ROUGE',
        -- duration = 5, -- In seconds, default:  4
        content = "Desolé je ne suis pas intéressé"
    })
end

function sell_weed()
    print("selll weed")
    --if GetVariable("drugs").weed.active == "true" then
        sell_drug("weed")
    --else
    --    failsell()
    --end
end

function sell_meth()
    print("sell_meth")
    --if GetVariable("drugs").meth.active == "true" then
        sell_drug("meth")
    --else
    --    failsell()
    --end
end

function sell_coke()
    print("sell_coke")
    --if GetVariable("drugs").coke.active == "true" then
        sell_drug("coke")
    --else
    --    failsell()
    --end
end

function sell_ecstasy()
    print("sell_ecstasy")
    --if GetVariable("drugs").ecstasy.active == "true" then
        sell_drug("ecstasy")
    --else
    --    failsell()
    --end
end

function sell_fentanyl()
    print("sell_fentanyl")
    --if GetVariable("drugs").fentanyl.active == "true" then
        sell_drug("fentanyl")
    --else
    --    failsell()
    --end
end

local function HaveDrugs()
    if p:haveItem("weed") then
        return true
    elseif p:haveItem("coke") then
        return true
    elseif p:haveItem("ecstasy") then
        return true
    elseif p:haveItem("fentanyl") then
        return true
    elseif p:haveItem("meth") then
        return true
    else 
        return false
    end
end

local lastcheck = 0
function getNumberOfCopsInDuty()
    local service = "lssd"
    if coordsIsInSouth(p:pos()) then
        service = "lspd"
    end
    local nbr = 0 
    if lastcheck == 0 then
        local wnbr = GlobalState['serviceCount_' .. service] or 0 --TriggerServerCallback("core:getNumberOfDuty", token, service)
        if wnbr then 
            nbr = wnbr
            oldNbr = wnbr
            lastcheck = 1
        end
    else 
        nbr = oldNbr 
    end
    return nbr
end

CreateThread(function()
    while true do
        Wait(60000)
        lastcheck = 0
    end
end)

CreateThread(function()
    while loaded do Wait(1) end
    while p == nil do Wait(1) end

    local leader = false
    while true do
        local pNear = false
        closestNPC = GetClosestNPC(10.0)
        local pedPos = GetEntityCoords(closestNPC)

        if pedPos ~= nil then
            local hasD, drugHas = HasMultipleDrugs()
            if hasD > 0 then
                if #(p:pos() - vector3(pedPos.x, pedPos.y, pedPos.z)) <= 2 then
                    pNear = true
                    if IsEntityPositionFrozen(closestNPC) or
                        IsPedModel(closestNPC, GetHashKey("mp_m_shopkeep_01")) or
                        IsPedModel(closestNPC, GetHashKey("s_f_y_shop_low")) or
                        IsPedModel(closestNPC, GetHashKey("mp_f_meth_01")) or
                        IsPedModel(closestNPC, GetHashKey("mp_f_cocaine_01")) or 
                        IsPedModel(closestNPC, GetHashKey("mp_m_cocaine_01")) or
                        IsPedModel(closestNPC, GetHashKey("mp_m_weed_01")) or 
                        IsPedModel(closestNPC, GetHashKey("mp_f_weed_01")) or 
                        IsPedModel(closestNPC, GetHashKey("mp_m_freemode_01")) or
                        IsPedModel(closestNPC, GetHashKey("mp_s_m_armoured_01")) or
                        IsPedDeadOrDying(closestNPC) or
                        IsPedModel(closestNPC, GetHashKey("mp_f_freemode_01")) then
                    else
                        --ShowHelpNotification("~INPUT_PICKUP~ Vendre")
                        Bulle.create("ventepnj",vector3(pedPos.x, pedPos.y, pedPos.z+0.9),"bulleVendreillegal",true)
                    end
                    if IsControlJustPressed(0, 38) then
                        local copsMax = GetVariable("drugs") and tonumber(GetVariable("drugs").cops) or 2
                        if IsEntityPositionFrozen(closestNPC) or
                            IsPedModel(closestNPC, GetHashKey("mp_m_shopkeep_01")) or
                            IsPedModel(closestNPC, GetHashKey("mp_m_freemode_01")) or
                            IsPedModel(closestNPC, GetHashKey("mp_f_meth_01")) or
                            IsPedModel(closestNPC, GetHashKey("mp_m_cocaine_01")) or
                            IsPedModel(closestNPC, GetHashKey("mp_m_weed_01")) or 
                            IsPedModel(closestNPC, GetHashKey("mp_f_weed_01")) or 
                            IsPedModel(closestNPC, GetHashKey("mp_f_cocaine_01")) or
                            IsPedModel(closestNPC, GetHashKey("s_f_y_shop_low")) or
                            IsPedDeadOrDying(closestNPC) or
                            IsPedModel(closestNPC, GetHashKey("mp_s_m_armoured_01")) or
                            IsPedModel(closestNPC, GetHashKey("mp_f_freemode_01"))
                        then
                            -- exports['vNotif']:createNotification({
                            --    type = 'ROUGE',
                            --    content = "Vous ne pouvez pas vendre de drogues à cette personne"
                            -- })
                        elseif tonumber(getNumberOfCopsInDuty()) < tonumber(copsMax) then
                            if GlobalState['serviceCount_lssd'] > 0 then 
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Il n'y a pas assez de policiers en service, essaie dans le nord !"
                                })
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    content = "Il n'y a pas assez de policiers en service"
                                })
                            end
                        elseif IsPedInAnyVehicle(PlayerPedId(), true) then
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous ne pouvez pas vendre de drogues en étant dans un véhicule"
                            })
                        elseif IsPedDeadOrDying(closestNPC) then
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous ne pouvez pas vendre de drogues à un mort"
                            })
                        elseif IsPedInAnyVehicle(closestNPC) then
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous ne pouvez pas vendre de drogues à quelqu'un dans un véhicule"
                            })
                        elseif IsPedAPlayer(closestNPC) then
                            exports['vNotif']:createNotification({
                                type = 'ROUGE',
                                content = "Vous ne pouvez pas vendre de drogues à un joueur"
                            })
                        else
                            if hasD > 1 then
                                local ToSend = {}
                                for k,v in pairs(DrugsType) do 
                                    for x,a in pairs(drugHas) do
                                        if a == v.item then 
                                            table.insert(ToSend, v)
                                        end
                                    end
                                end
                                Wait(50)
                                OpenDrugsRadial(ToSend)
                            elseif hasD == 1 then
                                sell_drug(drugHas)
                            end
                        end

                    end
                end
            else
                Bulle.remove("ventepnj")
                Wait(1000)
            end
        else
            Bulle.remove("ventepnj")
            Wait(500)
        end
        if pNear then
            Wait(0)
        else
            Bulle.remove("ventepnj")
            Wait(300)
        end
    end
end)

local open = false
local main = RageUI.CreateMenu("Zone", "Zone")

main.Closed = function()
    open = false
    RageUI.Visible(main, false)
end

function OpenZoneMenu()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        local leader = false
        RageUI.Visible(main, true)
        local zoneId = GetZoneAtCoords(p:pos())
        zoneData = TriggerServerCallback("core:GetZoneDataDrugs", tostring(zoneId))
        local data = {}
        if zoneData == nil then
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "Aucune zone n'existe à cet emplacement, reprenez-la en vendant ici."
            }) 
            return 
        end
        data = zoneData.data
        local label = zoneData.label
        local value = {}
        for key, values in pairs(data) do
            if key ~= "None" then
                table.insert(value, { name = key, v = values })
            end
        end
        table.sort(value, function(a, b) return a.v > b.v end)

        if p:getCrew() == value[1].name and p:getCrew() ~= "None" then
            leader = true
        end
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Separator("Zone: ~b~ " .. label)
                    for _, v in pairs(value) do
                        if _ == 1 then
                            RageUI.Button(v.name .. ": " .. v.v .. " points", nil, { RightLabel = "~o~LEADER" }, true,
                                {})

                        else
                            RageUI.Button(v.name .. ": " .. v.v .. " points", nil, {}, true, {})
                        end
                    end
                    if leader then
                        RageUI.Separator("GESTION")
                        RageUI.Button("Changer le nom de la zone", nil, {}, true, {
                            onSelected = function()
                                local name = KeyboardImput("Nom")
                                if name ~= nil then
                                    label = name

                                    local changed = TriggerServerCallback("core:ChangeNameZone", zoneId, name)
                                    if changed then
                                        -- ShowNotification("Changement fais avec succes")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'VERT',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "Changement fais avec ~s succès"
                                        })

                                    else
                                        -- ShowNotification("Erreur lors du changement")

                                        -- New notif
                                        exports['vNotif']:createNotification({
                                            type = 'ROUGE',
                                            -- duration = 5, -- In seconds, default:  4
                                            content = "~s Erreur lors du changement"
                                        })

                                    end
                                end
                            end
                        })
                    end

                end)

                Wait(1)
            end
        end)
    end
end

RegisterCommand('zones', function()
    OpenZoneMenu()
end, false)

RegisterNetEvent("drug:pedLock", function(newLockedPed)
    table.insert(lockedList, newLockedPed)
end)

RegisterNetEvent("drug:loadPedLock", function(lockList)
    lockedList = lockList
end)

RegisterNetEvent("drugs:notifDrugs")
AddEventHandler("drugs:notifDrugs", function(lieux)
    exports['vNotif']:createNotification({
        type = 'JAUNE',
        content = "Quelqu'un est entrain de vendre sur votre zone ~s (" .. lieux .. ")"
    })
end)