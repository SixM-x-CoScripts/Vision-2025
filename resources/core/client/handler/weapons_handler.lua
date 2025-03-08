local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function LoadWeaponHandler()
    local hasVest = false

    Citizen.CreateThread(function()
        while true do
            local pWeapons = p:getWeapons()

            for k, v in pairs(pWeapons) do
                if HasPedGotWeapon(p:ped(), GetHashKey(k), 0) then
                    local ammo = GetAmmoInPedWeapon(p:ped(), GetHashKey(k))
                    if ammo ~= v.ammo then
                        p:SetWeaponAmmo(k, ammo)
                        TriggerServerEvent("core:UpdateWeaponAmmo", token, k, ammo)
                        v.ammo = ammo
                    end
                end
            end

            Wait(1000)
        end
    end)


    Citizen.CreateThread(function()
        while true do
            local pWeapons = p:getWeapons()
            for k, v in pairs(pWeapons) do
                if HasPedGotWeapon(p:ped(), GetHashKey(k), 0) then
                    if pWeapons[k] == nil then
                        RemoveWeaponFromPed(p:ped(), GetHashKey(k))
                        -- TODO Ac screenshot detection
                    end
                end
            end
            Wait(2500)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if (p:skin().bproof_1 == 145 or p:skin().bproof_1 == 129) and not hasVest then
                --print("has vest")
                hasVest = true
            end

            if p:skin().bproof_1 ~= 145 and p:skin().bproof_1 ~= 129 and hasVest then
                --print("remove vest")
                hasVest = false
            end

            Wait(2500)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if hasVest then
                ShowHelpNotification("~INPUT_CONTEXT~ Pour faire boom")
            else
                Wait(1000)
            end

            if hasVest and IsControlJustPressed(0, 38) then
                print("boom")
                local pos = GetEntityCoords(p:ped())
                AddExplosion(pos.x, pos.y, pos.z, 4, 1000.0, true, false, 1000.0)
                p:setCloth("bproof_1", 0)
                p:saveSkin()
                hasVest = false
            end

            Wait(0)
        end
    end)

    local PosLabo = {
        vector3(-1103.5, -830.06, 9.28), -- lspd
        vector3(475.38, -988.92, 25.21), -- lspd MR
        vector3(622.14, -29.81, 86.8), -- lspd Vp
        vector3(2810.95, 4710.28, 47.63), -- lssd
        vector3(2507.31, -354.54, 100.89), -- usss
    }

    CreateThread(function()
        while not p do Wait(1000) end
      
        TriggerServerEvent("core:checkMeta")
        while true do 
            Wait(1)
            if IsPedArmed(PlayerPedId(), 4) then
                if IsPedShooting(PlayerPedId()) then
                    if p:getJob() ~= "lspd" and p:getJob() ~= "lssd" and p:getJob() ~= "usss" then
                        local dataid = nil
                        if UsingWeapon.metadatas and UsingWeapon.metadatas.id then
                            dataid = UsingWeapon.metadatas.id
                        end
                        TriggerServerEvent("core:shootingcases", GetEntityCoords(PlayerPedId()),
                            GetWeapontypeGroup(GetSelectedPedWeapon(PlayerPedId())), dataid)
                        Wait(2000)
                    end
                end
            else
                Wait(2000)
            end
        end
    end)

    while not zone do Wait(1000) end
    for k, v in pairs(PosLabo) do
        zone.addZone("laborLSPD" .. k,
            v + vector3(0.0, 0.0, 0.9),
            "~INPUT_CONTEXT~ Magasin de vêtements",
            function()
                if p:getJob() == "lspd" or p:getJob() == "lssd" or p:getJob() == "usss" then
                    if UsingWeapon and IsPedArmed(PlayerPedId(), 4) then
                        if UsingWeapon.metadatas and UsingWeapon.metadatas.id then
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                content = "Le numéro de série de l'arme est : " .. UsingWeapon.metadatas.id
                            })
                        else
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                content = "Le numéro de série de l'arme a été rayé"
                            })
                        end
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            content = "Vous n'avez pas d'arme équipé"
                        })
                    end
                else
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        content = "Vous n'avez pas le métier nécessaire"
                    })
                end
            end, false,
            27,
            0.5,
            { 255, 255, 255 },
            170,
            3.5,
            true,
            "bulleArmes"
        )
    end

    CreateThread(function()
        while true do
            Wait(1)
            if next(WeaponCases) then
                if GetSelectedPedWeapon(PlayerPedId()) == `weapon_flashlight` then
                    if IsPlayerFreeAiming(PlayerId()) then
                        for k, v in pairs(WeaponCases) do
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos.x, v.pos.y, v.pos.z) < 10.0 then
                                if IsLookingAtCoords(v.pos.x, v.pos.y, v.pos.z, 20.0) then
                                    DrawMarker(25, v.pos.x, v.pos.y, v.pos.z - .95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2,
                                        0.2, 0.2, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                                    WeapDraw3DText({
                                        xyz = { x = v.pos.x, y = v.pos.y, z = v.pos.z - .95 },
                                        text = {
                                            content = "Munition " .. v.typeAmmo .. "\nHeure : " .. v.time,
                                            rgb = { 255, 255, 255 },
                                            textOutline = true,
                                            scaleMultiplier = 0.8,
                                            font = 0
                                        },
                                        perspectiveScale = 0.1,
                                    })
                                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.pos.x, v.pos.y, v.pos.z) < 2.0 then
                                        if IsControlJustPressed(0, 38) then
                                            p:PlayAnim("amb@medic@standing@kneel@base", "base", 1)
                                            Wait(2000)
                                            exports['vNotif']:createNotification({
                                                type = 'VERT',
                                                content = "~c Vous avez récupéré la douille"
                                            })
                                            table.remove(WeaponCases, k)
                                            StopAnimTask(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 1.0)
                                            if v.id then
                                                TriggerSecurGiveEvent("core:addItemToInventory", token, "douille", 1, {
                                                    time = v.time,
                                                    typeAmmo = v.typeAmmo,
                                                    id = v.id
                                                })
                                            else
                                                TriggerSecurGiveEvent("core:addItemToInventory", token, "douille", 1, {
                                                    time = v.time,
                                                    typeAmmo = v.typeAmmo
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    Wait(2000)
                end
            else
                Wait(5000)
            end
        end
    end)
end

WeaponCases = {}
RegisterNetEvent("core:shootingcases", function(coords)
    table.insert(WeaponCases, coords)
end)

default = {
    xyz = { x = -1377.514282266, y = -2852.64941406, z = 13.9448 }, -- At airport
    text = {
        content = "Test",
        rgb = { 255, 255, 255 },
        textOutline = true,
        scaleMultiplier = 0.8,
        font = 0
    },
    perspectiveScale = 0.1,
}

function WeapDraw3DText(params)
    if params == nil then params = default end
    if params.xyz == nil then params.xyz = default.xyz end
    if params.text.rgb == nil then params.text.rgb = default.text.rgb end
    if params.text.textOutline == nil then params.text.textOutline = default.text.textOutline end
    local onScreen, _x, _y = World3dToScreen2d(params.xyz.x, params.xyz.y, params.xyz.z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, params.xyz.x, params.xyz.y, params.xyz.z, 1)
    local scale = (1 / distance) * (params.perspectiveScale or default.perspectiveScale)
    local fov = (1 / GetGameplayCamFov()) * 75
    local scale = scale * fov
    if onScreen then
        SetTextScale(tonumber(params.text.scaleMultiplier * 0.0),
            tonumber(0.35 * (params.text.scaleMultiplier or default.text.scaleMultiplier)))
        SetTextFont(params.text.font or default.text.font)
        SetTextProportional(true)
        SetTextColour(params.text.rgb[1], params.text.rgb[2], params.text.rgb[3], 255)
        --SetTextDropshadow(0, 0, 0, 0, 255)
        --SetTextEdge(2, 0, 0, 0, 150)
        if (params.text.textOutline) == true then SetTextOutline() end;
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(params.text.content or default.text.content)
        DrawText(_x, _y)
    end
end

RegisterNetEvent("core:usedouille", function(metadas)
    if metadas.id then
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Information sur la douille : \nHeure : " ..
                metadas.time .. "\nMunition " .. metadas.typeAmmo .. "\nNuméro de série de l'arme : " .. metadas.id
        })
    else
        exports['vNotif']:createNotification({
            type = 'JAUNE',
            content = "Information sur la douille : \nHeure : " ..
                metadas.time .. "\nMunition " .. metadas.typeAmmo .. "\nNuméro de série de l'arme rayé"
        })
    end
end)
