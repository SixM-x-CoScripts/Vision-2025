local insideRegister = false

RegisterNUICallback("focusOut", function()
    if insideRegister then insideRegister = false end
end)

local ingoreE = false

local Registered = {}

local tempheader = {
    ["rexdiner"] = "https://cdn.sacul.cloud/v2/vision-cdn/Headers/header_rexdiner.webp"
}
function OpenCashRegister(defaultMarge)
    insideRegister = true

    if GetVariable("entreprises") and GetVariable("entreprises")[p:getJob()] then 
        local marge = GetVariable("entreprises")[p:getJob()].marge 
        if marge then 
            defaultMarge = tonumber(marge)
        end
    end

    forceHideRadar()
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    local Products = GetCatalogueItems(p:getJob()) and GetCatalogueItems(p:getJob()).elements or {}
    
    if not Registered[p:getJob()] then
        Registered[p:getJob()] = true
        for k,v in pairs(Products) do 
            if v.label then 
                v.name = v.label
                v.quantity = 1
                v.price = math.floor(v.price * (1 + defaultMarge/100))
            end
        end
    end

    SendNUIMessage({
        type = 'openWebview',
        name = 'CaisseEnregistreuse',
        data = {
            source = GetPlayerServerId(PlayerId()),
            firstname = p:getFirstname(),
            lastname = p:getLastname(),
            permission = p:getPermission(),
            society = {
                name = jobs[p:getJob()].label,
                id = p:getJob(),
                image = tempheader[p:getJob()] or "https://cdn.sacul.cloud/v2/vision-cdn/Headers/job/"..p:getJob()..".webp",
            },
            products = Products,--{},
                --{
                --    id = "pepsi",
                --    name = "Pepsi",
                --    image = "https://cdn.sacul.cloud/v2/vision-cdn/burgerShotMenu/Hamburger.webp",
                --    price = 2.5,
                --    quantity = 1,
                --},
        }
    })
    while insideRegister do 
        Wait(1)
        DisableAllControlActions(0)
    end

    TriggerScreenblurFadeOut(1000)
end

RegisterNUICallback("caisseFacturer", function(data)
    --print(json.encode(data, {indent = true}))
    closeUI()
    ingoreE = true
    local closestPlayer = ChoicePlayersInZone(5.0)
    if closestPlayer == nil then
        ingoreE = false
        return
    end
    globalTarget = GetPlayerServerId(closestPlayer)

    local price = tonumber(data.total)
    local whatfor = ""
    if data.selectedProducts then 
        for k,v in ipairs(data.selectedProducts) do 
            if whatfor == "" then 
                whatfor = "x" .. v.quantity .. " " .. v.label 
            else 
                whatfor = whatfor .. "\nx" .. v.quantity .. " " .. v.label
            end
        end
    end
    print("price", price)
    print("whatfor", whatfor)
    TriggerServerEvent("core:sendFactureCustom", globalTarget, price, whatfor)
    Wait(1500)
    ingoreE = false
end)

local CashRegisters = {
    bahamas = {
        pos = {
            vector3(-1379.7265625, -596.74725341797, 29.216480255127),
            vector3(-1375.2607421875, -602.83117675781, 29.216979980469),
            -- DEV
            --vector3(-967.81176757812, -857.87969970703, 13.848901748657),
            --vector3(-1414.6118164062, -602.56097412109, 29.545446395874),
            vector3(-971.79571533203, -855.70556640625, 13.758651733398),
        },
        marge = 35,
    },
    cardealerSud = {
        pos = {
            vector3(-30.633544921875, -1096.3571777344, 26.2744140625),
            vector3(-31.225885391235, -1087.6689453125, 26.274415969849),
            vector3(-33.608631134033, -1086.7701416016, 26.274408340454),
            vector3(-39.950160980225, -1084.4150390625, 26.274406433105),
            vector3(-42.37532043457, -1083.5681152344, 26.274408340454),
        },
        marge = 35,
    },
    pawnshop = {
        pos = {
        vector3(-320.96426391602, -101.17422485352, 46.047332763672),
        vector3(-313.80590820312, -97.441345214844, 46.047359466553),
    },
    marge = 35,
    },
    vangelico = {
        pos = {
        vector3(-622.48046875, -229.76940917969, 37.05704498291),
        vector3(-621.97784423828, -231.92150878906, 37.05704498291),
    },
    marge = 35,
    },
    amerink = {
        pos = {
        vector3(1864.4174804688, 3750.2312011719, 32.029415130615),
        vector3(1864.4174804688, 3750.2312011719, 32.029415130615),
    },
    marge = 35,
    },
    bennys = {
        pos = {
        vector3(-198.86071777344, -1317.3182373047, 30.301361083984),
        vector3(-216.63899230957, -1334.7321777344, 30.300472259521),
        vector3(-211.9015045166, -1338.9681396484, 30.300483703613),
        vector3(-219.74560546875, -1337.8009033203, 30.3014087677),
    },
    marge = 35,
    },
    beekers = {
        pos = {
        vector3(148.89202880859, 6379.2626953125, 30.273818969727),
        vector3(150.43031311035, 6363.8237304688, 30.273818969727),
        vector3(163.35922241211, 6364.9384765625, 30.273839950562),
    },
    marge = 35,
    },
    harmony = {
        pos = {
        vector3(2524.5197753906, 2639.0981445312, 36.960098266602),
        vector3(2524.5112304688, 2623.4846191406, 36.945446014404),
        vector3(2530.6491699219, 2637.2980957031, 36.945442199707),
    },
    marge = 35,
    },
	rexdiner = {
        pos = {
			vector3(2537.4682617188, 2586.3032226562, 37.656078338623),
			vector3(2541.8576660156, 2586.2863769531, 37.656074523926),
		},
		marge = 35,
    },
	skyblue = {
        pos = {
			vector3(-1175.79, -178.7, 74.77),
			vector3(-1176.78, -173.98, 74.77),
		},
		marge = 35,
    },
    burgershot = {
        pos = {
			vector3(1591.01, 3750.82, 33.43),
			vector3(1588.73, 3753.93, 33.43),
		},
		marge = 35,
    },
    unicorn = {
        pos = {
			vector3(110.18467712402, -1283.8685302734, 28.618831634521),
			vector3(115.72260284424, -1280.3272705078, 28.618831634521),
		},
		marge = 35,
    },
    comrades = {
        pos = {
        vector3(-1586.1815185547, -994.25207519531, 12.075221061707),
        vector3(-1583.0875244141, -990.97729492188, 12.075221061707),
    },
    marge = 35,
    },
    bayviewLodge = {
        pos = {
        vector3(-688.39276123047, 5796.046875, 16.331064224243),
    },
    marge = 35,
    },
    yellowJack = {
        pos = {
        vector3(1984.1082763672, 3049.6977539062, 46.214992523193),
        vector3(1984.1116943359, 3054.5888671875, 46.215141296387),
    },
    marge = 35,
    },
    blackwood = {
        pos = {
        vector3(-306.55294799805, 6267.2290039062, 30.526859283447),
        vector3(-304.29409790039, 6269.296875, 30.526859283447),
    },
    marge = 35,
    },
    uwu = {
        pos = {
        vector3(-584.88171386719, -1059.0754394531, 21.344188690186),
        vector3(-584.81140136719, -1061.6302490234, 21.344188690186),
    },
    marge = 35,
    },
    pizzeria = {
        pos = {
        vector3(812.04364013672, -752.01806640625, 25.780841827393),
    },
    marge = 35,
    },
    pearl = {
        pos = {
        vector3(-1834.7370605469, -1189.6766357422, 13.313455581665),
        vector3(-1835.7795410156, -1191.5172119141, 13.313444137573),
    },
    marge = 35,
    },
    vclub = {
        pos = {
        vector3(-19.421371459961, 229.8576965332, 108.72702026367),
    },
    marge = 35,
    },
    tattooNord = {
        pos = {
        vector3(-293.42028808594, 6197.529296875, 30.48904800415),
    },
    marge = 35,
    },
    pops = {
        pos = {
        vector3(1593.2016601562, 6454.7065429688, 25.014015197754),
    },
    marge = 35,
    },
    hornys = {
        pos = {
        vector3(1250.8918457031, -358.88452148438, 68.082107543945),
    },
    marge = 35,
    },
    tacosrancho = {
        pos = {
        vector3(419.53958129883, -1914.8021240234, 24.471223831177),
    },
    marge = 35,
    },
    ltdsud = {
        pos = {
        vector3(-47.363353729248, -1758.7521972656, 28.421005249023),
    },
    marge = 35,
    },
    ltdseoul = {
        pos = {
            vector3(-706.06390380859, -914.59045410156, 18.215599060059),
        },
        marge = 35,
    },
    cardealerNord = {
        pos = {
            vector3(-233.25830078125, 6217.21484375, 30.944089889526),
        },
        marge = 35,
    },
    heliwave = {
        pos = {
            vector3(-787.11956787109, -1351.0679931641, 4.178505897522),
        },
        marge = 35,
    },
}

CreateThread(function()
    while not zone do 
        Wait(1000)
    end
    while not p do Wait(500) end 
    CheckNewRegister()

    --SendToVariable("entreprises", CashRegisters)
end)

local lastLoaded = ""
function CheckNewRegister()
    for k,v in pairs(CashRegisters) do 
        for _, coord in ipairs(v.pos) do
            if k == p:getJob() then
                local id = "cashRegister" .. k .. _
                if lastLoaded ~= id then
                    lastLoaded = id
                    zone.addZone(id, 
                        coord + vector3(0.0, 0.0, 1.0),
                        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le magasin",
                        function()
                            if not ingoreE then
                                OpenCashRegister(v.marge)
                            end
                        end,
                        false, -- Avoir un marker ou non
                        -1, -- Id / type du marker
                        0.6, -- La taille
                        { 0, 0, 0 }, -- RGB
                        0, -- Alpha
                        1.5,
                        true,
                        "bulleCaisse"
                    )
                end
            end
        end
    end
end