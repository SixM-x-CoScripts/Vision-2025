local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local allPlayerAccount = {}
local idPlayer
local firstname
local lastname
local open = false
local tables = {}

RegisterNUICallback('focusOut', function(data, cb)
    if open then
        SetNuiFocus(false, false)
        open = false
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        openRadarProperly()
    end
    cb({})
end)

RegisterNUICallback('focusIn', function(data, cb)
    if open then
        SetNuiFocus(true, true)
    end
end)

RegisterNUICallback('setTyping', function(data, cb)
end)

RegisterNUICallback('bank__GetAllPlayerAccount', function(data, cb)
    print("bank__GetAllPlayerAccount")
    tables = {}
    local bank = TriggerServerCallback("core:getTransaction")
    for k, v in pairs(bank) do
        table.insert(tables, { id = v.id, label = v.label, amount = v.amount })
    end
    if p:getJob() ~= "aucun" then -- opti
        local bankjob = TriggerServerCallback("core:getTransactionByJob")
        if not bankjob then bankjob = {} end
        for k, v in pairs(bankjob) do
            table.insert(tables, { id = v.id, label = v.label, amount = v.amount })
        end
    end
    local invertedTables = {}
    for i = #tables, 1, -1 do
        table.insert(invertedTables, tables[i])
    end
    tables = invertedTables
    TriggerServerEvent("core:GetAllInformation", token)
    Wait(500)
    cb({
        data = {
            accounts = allPlayerAccount,
            player = {
                id = idPlayer,
                firstname = firstname,
                lastname = lastname,
                job = loadedJob.label
            }
        }
    })

end)

RegisterNUICallback('bank__Deposit', function(data, cb)
    if data.wallet_id ~= nil then
        if data.amount ~= nil then
            TriggerServerEvent("core:bankAtmUpdate", token, data.wallet_id, data.amount, "add")
        end
    end
    Wait(500)
    cb({
        data = {
            accounts = allPlayerAccount,
            player = {
                id = idPlayer,
                firstname = firstname,
                lastname = lastname,
                job = loadedJob.label
            }
        }
    })

end)

RegisterNUICallback('bank__Withdraw', function(data, cb)
    if data.wallet_id ~= nil then
        if data.amount ~= nil then
            TriggerServerEvent("core:bankAtmUpdate", token, data.wallet_id, data.amount, "remove")
        end
    end
    Wait(200)

    cb({
        data = {
            accounts = allPlayerAccount,
            player = {
                id = idPlayer,
                firstname = firstname,
                lastname = lastname,
                job = loadedJob.label
            }
        }
    })

end)

RegisterNUICallback('bank__Transfer', function(data, cb)

    if data.from_wallet_id ~= nil then
        if data.amount ~= nil then
            TriggerServerEvent("core:bank_Transfer", token, data.from_wallet_id, data.account_number, data.amount)
        end
    end
    cb({
        data = {
            accounts = allPlayerAccount,
            player = {
                id = idPlayer,
                firstname = firstname,
                lastname = lastname,
                job = loadedJob.label
            }
        }
    })

end)

function OpenAtmMenu()
    if open then
        open = false
        SetNuiFocusKeepInput(false)
        EnableControlAction(0, 1, true)
        EnableControlAction(0, 24, true)
        EnableControlAction(0, 25, true)
        EnableControlAction(0, 2, true)
        EnableControlAction(0, 142, true)
        EnableControlAction(0, 18, true)
        EnableControlAction(0, 322, true)
        EnableControlAction(0, 106, true)
        SetNuiFocus(false, false)
        --DisplayRadar(true)
        SendNuiMessage(json.encode({
            type = 'closeWebview'
        }))
        return
    else
        open = true
        CreateThread(function()
            while open do
                Wait(0)
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
                DisableControlAction(0, 142, open)
                DisableControlAction(0, 18, open)
                DisableControlAction(0, 322, open)
                DisableControlAction(0, 106, open)
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
            end
        end)
        SendNuiMessage(json.encode({
            type = 'openWebview',
            name = 'atm',
            data = {
            }
        }));
    end


end

RegisterNetEvent('core:GetAllInformation')
AddEventHandler('core:GetAllInformation', function(allAccountPlayer, id, firstName, lastName)
    allPlayerAccount = allAccountPlayer
    idPlayer = id
    firstname = firstName
    lastname = lastName
end)

Citizen.CreateThread(function()
    while zone == nil do
        Wait(1)
    end
    --for k, v in pairs(blips_config[1].pos) do
    --    zone.addZone("atm_bank" .. k, -- Nom
    --        v, -- Position
    --        "Appuyer sur ~INPUT_CONTEXT~ pour utiliser l'ATM", -- Text afficher
    --        function() -- Action qui seras fait
    --            OpenAtmMenu()
    --        end,
    --        false, -- Avoir un marker ou non
    --        -1, -- Id / type du marker
    --        0.6, -- La taille
    --        { 0, 0, 0 }, -- RGB
    --        0, -- Alpha
    --        2.5,
    --        true,
    --        "bulleCompte"
    --    )
    --end
    for k, v in pairs(blips_config[2].pos) do
        zone.addZone("atm_banks" .. k, -- Nom
            v, -- Position
            "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir votre compte", -- Text afficher
            function() -- Action qui seras fait
                if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("weapon_bat") and not InsideDrilling then
                    OpenAtmMenu()
                end
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.5,
            true,
            "bulleCompte"
        )
    end

    while not p do Wait(1) end
    while true do 
        Wait(1)
        local atm = GetClosestATM()
        if not atm then 
            Citizen.Wait(2400)
        else
            if not insideRobberyAtm then
                if not InsideDrilling then 
                    if GetDistanceBetweenCoords(GetEntityCoords(p:ped()), GetEntityCoords(atm)) < 1.0 then
                        Bulle.create("atm", GetEntityModel(atm) == -870868698 and GetEntityCoords(atm) + vector3(0.0, 0.0, 1.75) or GetEntityCoords(atm) + vector3(0.0, 0.0, 1.57), "bulleCompte", true, nil,nil,true)
                        if IsControlJustPressed(0,38) then 
                            OpenAtmMenu()
                        end
                    end
                end
            end
        end
    end
end)

function HideAtmInfos()
    for k, v in pairs(blips_config[2].pos) do
        zone.hideNotif("atm_banks" .. k)
    end
    Bulle.hide("atm")
end

function ShowAtmInfos()
    for k, v in pairs(blips_config[2].pos) do
        zone.showNotif("atm_banks" .. k)
    end
    Bulle.show("atm")
end


RegisterNUICallback("bank__GetTransactions", function(datas, cb)
    --json.encode(table.unpack(tables))
    local goodTable = tables
    local tableSend = {}
    for k,v in pairs(tables) do 
        if tonumber(v.id) == tonumber(datas.accountId) then 
            table.insert(tableSend, v)
        end
    end
    json.encode(table.unpack(tableSend))
    cb({
        data = tableSend
    })

end)