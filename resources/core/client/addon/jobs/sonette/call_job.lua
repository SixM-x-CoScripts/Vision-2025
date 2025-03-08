local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local sonnettePos = {
    ["ltdsud"] = {
        pos = vector3(-55.0919, -1756.1848, 28.4396)
    },
    ["ltdseoul"] = {
        pos = vector3(-710.35540771484, -917.34924316406, 18.214166641235)
    },
    ["ltdmirror"] = {
        pos = vector3(1161.7680664063, -327.13562011719, 68.212242126465)
    },
    ["weazelnews"] = {
        pos = vector3(-599.33380126953, -934.11938476563, 22.864675521851)
    },
    ["lspd"] = {
        pos = vector3(-1097.4617919922, -843.46569824219, 18.001041412354)
    },
    ["lssd"] = {
        pos = vector3(2827.33, 4729.56, 47.62)
    },
    ["justice"] = {
        pos = vector3(236.38, -409.35, 46.93)
    },
    ["gcp"] = {
        pos = vector3(4927.115234375, -5295.8217773438, 4.6881566047668)
    },
    ["sunshine"] = {
        pos = vector3(869.53057861328, -2110.1025390625, 29.490036010742)
    },
    ["bean"] = {
        pos = vector3(-627.65533447266, 241.42178344727, 80.894142150879)
    },
    ["bahamas"] = {
        pos = vector3(-1391.5441894531, -587.97424316406, 29.246072769165)
    },
    ["vclub"] = {
        pos = vector3(-20.871553421021, 239.68515014648, 108.55397033691)
    },
    --["club77"] = {
    --    pos = vector3(-20.871553421021, 239.68515014648, 108.55397033691)
    --},
    -- ["burgershot"] = {
    --     pos = vector3(2545.7705078125, 2592.3493652344, 38.101768493652) --Rex Diner's
    -- },
    ["barber2"] = {
        pos = vector3(-820.21, -186.72, 36.57)
    },
    ["barbercayo"] = {
        pos = vector3(5157.0971679688, -5135.3427734375, 1.3177547454834)
    },
    ["cardealerSud"] = {
        pos = vector3(-46.4831, -1104.9564, 26.2633)
    },
    ["cardealerNord"] = {
        pos = vector3(-246.65548706055, 6211.30859375, 31.943964004517)
    },
    ["heliwave"] = {
        pos = vector3(-815.33117675781, -1344.9147949219, 4.1504797935486)
    },
    ["unicorn"] = {
        pos = vector3(130.53582763672, -1298.1751708984, 28.233039855957)
    },
    ["royalhotel"] = {
        pos = vector3(390.55996704102, 4.0447010993958, 90.415740966797)
    },
    ["bennys"] = {
        pos = vector3(-231.91149902344, -1331.7314453125, 30.29610824585)
    },
    ["ocean"] = {
        pos = vector3(-2194.5639648438, -389.32089233398, 12.719396591187)
    },
    --[[ ["cayogarage"] = {
        pos = vector3(5122.6040039063, -5132.9487304688, 1.1342098712921)
    }, ]]
    ["hayes"] = {
        pos = vector3(-1431.9050292969, -445.98962402344, 34.660949707031)
    },
    --[[ ["beekers"] = {
        pos = vector3(10000, 10000, 10000) -- pos à mettre
    }, ]]
    --[[ ["ems"] = {
        pos = vector3(-1851.2567138672, -339.83062744141, 48.443878173828)
    }, ]]
    ["sams"] = {
        pos = vector3(342.11, -590.49, 27.78)
    },
    ["bcms"] = {
        pos = vector3(-250.25, 6335.94, 31.45)
    },
    ["cayoems"] = {
        pos = vector3(4963.1630859375, -5103.8442382813, 1.9553964138031)
    },
    ["pawnshop"] = {
        pos = vector3(-296.70660400391, -104.05701446533, 46.049446105957)
    },
    ["gouv"] = {
        pos = vector3(-432.84423828125, 1097.8323974609, 328.76638793945)
    },
    ["tattooSud"] = {
        pos = vector3(319.36679077148, 177.61192321777, 102.62548065186)
    },
    ["tattooNord"] = {
        pos = vector3(-290.14837646484, 6201.5659179688, 30.467575073242)
    },
    ["tattoocayo"] = {
        pos = vector3(-290.14837646484, 6201.5659179688, 30.467575073242)
    },
    ["amerink"] = {
        pos = vector3(1858.8793945312, 3749.7431640625, 32.04761505127)
    },
    ["mirror"] = {
        pos = vector3(1123.2768554688, -642.95764160156, 55.704177856445)
    },
    ["yellowJack"] = {
        pos = vector3(1989.9291992188, 3055.1481933594, 46.215152740479)
    },
    ["blackwood"] = {
        pos = vector3(-298.56344604492, 6257.333984375, 30.507244110107)
    },
    ["lst"] = {
        pos = vector3(435.18951416016, -649.47186279297, 27.7396068573)
    },
    ["rockford"] = {
        pos = vector3(-1007.3261108398, -269.92852783203, 38.04061126709)
    },
    ["emperium"] = {
        pos = vector3(203.10052490234, -20.331596374512, 73.987152099609)
    },
    ["casse"] = {
        pos = vector3(2337.4365234375, 3131.85546875, 47.203121185303)
    },
    ["pizzeria"] = {
        pos = vector3(792.20806884766, -759.81439208984, 25.761432647705)
    },
    ["sandybeauty"] = {
        pos = vector3(-763.84100341797, -161.2080078125, 36.550804138184)
    },
    ["hornys"] = {
        pos = vector3(1241.8441162109, -368.22219848633, 68.082252502441)
    },
    ["pearl"] = {
        pos = vector3(-1832.7927246094, -1203.5007324219, 13.303376197815)
    },
    ["rexdiner"] = {
        pos = vector3(2542.73, 2594.1, 37.1)
    },
    ["ammunation"] = {
        pos = vector3(15.131879806519, -1115.2550048828, 28.79118347168)
    },
    --["ammunation"] = {
    --    pos = vector3(1698.9365234375, 3749.7651367188, 33.37914276123)
    --},
    ["tacosrancho"] = {
        pos = vector3(410.89453125, -1907.5825195313, 24.460599899292)
    },
    ["taxi"] = {
        pos = vector3(905.40679931641, -165.13847351074, 73.102897644043)
    },
    ["avocat2"] = {
        pos = vector3(-244.9595489502, 157.75012207031, 73.04354095459)
    },
    ["avocat3"] = {
        pos = vector3(-602.81652832031, -349.29000854492, 34.241146087646)
    },
    ["harmony"] = {
        pos = vector3(2530.0329589844, 2628.7109375, 37.945442199707)
    },
    ["lsevent"] = {
        pos = vector3(-270.74310302734, -687.16204833984, 32.465881347656)
    },
}

function callEntreprise(k)
    if k ~= "lspd" and k ~= "ems" and k ~= "bcms" and k ~= "cayoems" and k ~= "g6" and k ~= "usmc" and k ~= "lssd" and k ~= "gcp" and k ~= "bp" then
        TriggerSecurEvent('core:makeCall', k, sonnettePos[k].pos, false, "Un client sonne à votre boutique", true)
    elseif k == 'ems' or k == "sams" or k == "bcms" or k == "cayoems" then
        TriggerSecurEvent('core:makeCall', k, sonnettePos[k].pos, false, "Un patient sonne à l'acceuil", true)
    else
        TriggerSecurEvent('core:makeCall', k, sonnettePos[k].pos, false, "Un agent est demandé à l'accueil du poste",
            true)
    end
end

local char = "menu_title_choicelssdbp"
local open = false
local main = RageUI.CreateMenu("", "Choix de la sonette", 0.0, 0.0, "vision", char)
function ChoiceLSSDUSBPSonette()
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true

        RageUI.Visible(main, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("~y~Los Santos County Sheriff", false, {}, true, {
                        onSelected = function()
                            k = 'lssdbp'
                            TriggerSecurEvent('core:makeCall', 'lssd', sonnettePos[k].pos, false,
                                "Un agent est demandé à l'accueil du poste", true)
                        end
                    })
                    RageUI.Button("~g~United States Border Patrol", false, {}, true, {
                        onSelected = function()
                            k = 'lssdbp'
                            TriggerSecurEvent('core:makeCall', 'bp', sonnettePos[k].pos, false,
                                "Un agent est demandé à l'accueil du poste", true)
                        end
                    })
                    RageUI.Button("~g~Guardia CayoPerico", false, {}, true, {
                        onSelected = function()
                            k = 'lssdbp'
                            TriggerSecurEvent('core:makeCall', 'gcp', sonnettePos[k].pos, false,
                                "Un agent est demandé à l'accueil du poste", true)
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end

CreateThread(function()
    while p == nil do Wait(1) end

    for k, v in pairs(sonnettePos) do
        local x, y, z = table.unpack(v.pos)
        zone.addZone(
            "sonnette_job_" .. k,
            vector3(x, y, z + 1.0),
            "Appuyer sur ~INPUT_CONTEXT~ pour appeler l'entreprise",
            function()
                if k == 'lssdbp' then
                    char = "menu_title_choicelssdbp"
                    main = RageUI.CreateMenu("", "Choix de la sonette", 0.0, 0.0, "vision", char)
                    ChoiceLSSDUSBPSonette()
                else
                    callEntreprise(k)
                end
            end,
            false,            -- Avoir un marker ou non
            25,               -- Id / type du marker
            0.6,              -- La taille
            { 51, 204, 255 }, -- RGB
            170,              -- Alpha
            1.5,
            true,
            "bulleSonnette"
        )
    end
end)
