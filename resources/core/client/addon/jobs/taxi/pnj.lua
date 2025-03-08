local inMission    = false
local takeMission  = false
local timer        = false
local peds         = nil
local StartMission = false
local blips        = nil
local posStart     = {
    vector4(228.40824890137, 305.53698730469, 105.53206634521, 275.524078369141),
    vector4(-1346.0220947266, 14.906282424927, 53.09330368042, 275.524078369141),
    vector4(220.38050842285, 282.36685180664, 105.44665527344, 275.524078369141),
    vector4(419.83129882813, -962.267578125, 29.404787063599, 90.0),
    vector4(902.57922363281, 60.342353820801, 79.027519226074, 90.0),
    vector4(-1041.9681396484, -2721.9577636719, 13.756641387939, 333.05511474609),
    vector4(-1052.2418212891, -2715.4560546875, 13.756649971008, 333.28854370117),
    vector4(-1024.8387451172, -2731.1188964844, 13.756649017334, 334.15899658203),
    vector4(-210.75, -2001.4333496094, 27.751037597656, 249.48577880859),
    vector4(-1099.7497558594, -798.51251220703, 18.628540039063, 59.299800872803),
    vector4(-1201.3914794922, -1451.0323486328, 4.3740148544312, 27.450756072998),
    vector4(-1842.3269042969, -373.02258300781, 49.378753662109, 79.831092834473),
    vector4(-1869.6268310547, -341.64715576172, 49.388885498047, 148.48205566406),
    vector4(-1345.0054931641, 14.109412193298, 53.038311004639, 151.98538208008),
    vector4(-1405.7614746094, -563.13824462891, 30.274482727051, 203.15509033203),
    vector4(1173.5770263672, -291.68368530273, 68.917602539063, 284.48257446289),
    vector4(122.72779846191, -1311.2447509766, 29.187515258789, 208.22940063477),
    vector4(1017.5754394531, -585.71948242188, 58.802104949951, 244.95162963867),
    vector4(226.19519042969, 225.26486206055, 105.54848480225, 66.642784118652),
    vector4(-174.87518310547, 268.68032836914, 92.929176330566, 186.4351348877),
    vector4(-3.7221486568451, 251.01759338379, 109.00636291504, 343.70175170898),
    vector4(220.45053100586, 667.00250244141, 189.24241638184, 108.22161865234),
    vector4(91.051025390625, 481.63415527344, 147.34634399414, 207.46466064453),
    vector4(-1321.525390625, 454.43759155273, 99.505157470703, 340.02850341797),
    vector4(-1606.2878417969, 187.75245666504, 59.630786895752, 156.88754272461),
    vector4(-1955.8862304688, 353.18539428711, 90.991821289063, 119.92330932617),
    vector4(-2291.9548339844, 375.19104003906, 174.60168457031, 30.520952224731),
    vector4(-607.88470458984, -949.98663330078, 22.012607574463, 188.83306884766),
    vector4(-675.48260498047, -1102.1414794922, 14.663192749023, 59.693119049072),
    vector4(20.750238418579, -1123.3267822266, 29.040212631226, 139.83706665039),
    vector4(221.14753723145, -1894.8685302734, 25.09779548645, 205.90127563477),
    vector4(132.15971374512, -2017.6369628906, 18.275981903076, 239.73043823242),
    vector4(262.10192871094, -382.20883178711, 44.80131149292, 355.88461303711),
    vector4(216.2130279541, -363.63711547852, 44.165615081787, 343.76278686523),
    vector4(407.07879638672, -1897.6815185547, 25.531175613403, 31.532089233398),
    vector4(295.83779907227, -591.02777099609, 43.262763977051, 55.549491882324),
    vector4(-474.27954101563, -246.87084960938, 35.969966888428, 227.3023223877),
    vector4(-1389.7039794922, -722.72509765625, 24.375535964966, 47.652770996094),
    vector4(-1065.3381347656, -464.23669433594, 36.603107452393, 320.78228759766),
    vector4(-3021.9484863281, 86.112503051758, 11.681035041809, 296.80419921875),
    vector4(-3144.4321289063, 1120.7739257813, 20.851057052612, 243.74145507813),
    vector4(-3162.2229003906, 1060.4244384766, 20.833433151245, 309.86456298828),
    vector4(-2551.7041015625, 2318.0510253906, 33.215438842773, 352.68591308594),
    vector4(1200.2416992188, 2697.2006835938, 37.935768127441, 155.0735168457),
    vector4(598.41918945313, 2741.1904296875, 42.072738647461, 170.40014648438),
    vector4(1939.9342041016, 3720.8088378906, 32.466304779053, 205.18556213379),
    vector4(1398.0617675781, 3599.3078613281, 35.007911682129, 194.44732666016),
    vector4(-262.47451782227, 6208.1049804688, 31.534490585327, 53.665473937988),
    vector4(-696.16955566406, 5807.5737304688, 17.330968856812, 345.77032470703),
    vector4( 1805.3275146484, 4583.7270507813, 36.460346221924, 195.33940124512),
    vector4(2547.57421875, 4692.0771484375, 33.55065536499, 34.320148468018),
    vector4(1705.4851074219, 3743.6652832031, 33.707759857178, 121.61638641357),
    vector4(1403.5640869141, 3594.2612304688, 34.829837799072, 112.07640838623),
    vector4(-44.725952148438, 6500.9711914063, 31.391374588013, 223.17097473145),
    vector4(-404.45223999023, 6120.5346679688, 31.339555740356, 46.418369293213),
}

local finish = {
    vector4(131.55824279785, -1311.9228515625, 29.034297943115, 327.11456298828),
    vector4(927.50122070313, -584.08233642578, 57.396911621094, 327.11456298828),
    vector4(433.42129516602, -1592.5747070313, 29.169960021973, 327.11456298828),
    vector4(-1149.3615722656, -1596.5902099609, 4.3859362602234, 90.0),
    vector4(1937.5417480469, 3715.4506835938, 32.348106384277, 275.524078369141),
    vector4(-1239.6114501953, 244.94509887695, 64.903205871582, 90.0),
    vector4(-1621.6040039063, -1008.8427734375, 13.118775367737, 226.47135925293),
    vector4(-749.32653808594, -868.92224121094, 21.999797821045, 185.94206237793),
    vector4(-1256.8548583984, -1381.8526611328, 4.0793261528015, 108.62870788574),
    vector4(-1887.2322998047, -349.92446899414, 49.286933898926, 146.23564147949),
    vector4(-1369.7630615234, 55.620162963867, 53.703662872314, 358.29067993164),
    vector4(-1404.8255615234, -567.32629394531, 30.253582000732, 118.05216217041),
    vector4(122.4295425415, -1319.3555908203, 29.149560928345, 290.72192382813),
    vector4(936.93182373047, -491.0446472168, 59.974864959717, 117.60214996338),
    vector4(1011.844543457, -725.87396240234, 57.524822235107, 224.7578125),
    vector4(1182.3958740234, -588.17687988281, 64.105895996094, 358.44515991211),
    vector4(-74.420875549316, 296.96130371094, 106.21618652344, 72.887405395508),
    vector4(-505.13482666016, 577.76684570313, 120.64167022705, 158.88215637207),
    vector4(-712.57183837891, 483.99630737305, 108.28192138672, 108.09715270996),
    vector4(-1615.4737548828, 155.67230224609, 60.2571144104, 116.62870788574),
    vector4(-1003.0061035156, -1133.8054199219, 2.0705950260162, 201.55833435059),
    vector4(-1074.1778564453, -1379.4311523438, 5.0146446228027, 348.17678833008),
    vector4(-678.63995361328, -1097.3527832031, 14.525680541992, 38.113742828369),
    vector4(-72.758041381836, -1093.873046875, 26.404621124268, 338.71859741211),
    vector4(-620.55560302734, -930.15911865234, 22.533926010132, 1.7710568904877),
    vector4(119.45148468018, -1865.9123535156, 24.422142028809, 67.050231933594),
    vector4(402.73391723633, -1895.6184082031, 25.377338409424, 312.63018798828),
    vector4(868.45715332031, -2135.220703125, 30.559852600098, 258.50140380859),
    vector4(153.17524719238, -1029.150390625, 29.243688583374, 251.14418029785),
    vector4(222.79866027832, -853.63616943359, 30.048126220703, 256.02325439453),
    vector4(294.8984375, -574.13171386719, 43.169761657715, 25.432371139526),
    vector4(-542.99957275391, -279.15612792969, 35.171043395996, 126.46692657471),
    vector4(-71.941963195801, 883.64837646484, 235.60987854004, 22.996522903442),
    vector4(-771.02056884766, 292.96420288086, 85.637046813965, 97.181785583496),
    vector4(-948.78228759766, 128.56390380859, 57.541240692139, 252.05709838867),
    vector4(241.78770446777, -349.42016601563, 44.368549346924, 66.501258850098),
    vector4(-3081.6870117188, 336.74673461914, 7.2079205513, 160.23637390137),
    vector4(-3230.3176269531, 950.66119384766, 13.396241188049, 192.99287414551),
    vector4(-1101.3375244141, 2688.0874023438, 19.39942741394, 126.69458007813),
    vector4(-381.42135620117, 2829.1420898438, 44.732063293457, 334.58236694336),
    vector4(1204.0992431641, 2659.9826660156, 37.820980072021, 233.72476196289),
    vector4(1664.0950927734, 3714.92578125, 34.017078399658, 308.55651855469),
    vector4(1896.7521972656, 3945.0056152344, 32.805862426758, 87.945526123047),
    vector4(-246.51387023926, 6402.640625, 31.113594055176, 116.4627532959),
    vector4(923.77209472656, 3565.4956054688, 33.788948059082, 187.20341491699),
    vector4(-416.77532958984, 6205.1469726563, 31.564977645874, 194.01251220703),
    vector4(-1286.7430419922, 293.51431274414, 64.827323913574, 55.471946716309),
    vector4(-1226.8420410156, -191.97134399414, 39.179836273193, 47.145977020264),
    vector4(-1534.8245849609, -434.88488769531, 35.441902160645, 49.85676574707),
    vector4(-1070.4243164063, -1439.2172851563, 5.4254374504089, 49.85676574707),
    vector4(788.15502929688, -1286.2503662109, 26.14963722229, 175.66812133789),
}

local pedCreate = {
    "a_f_m_beach_01", "a_f_y_business_02", "a_f_y_indian_01", "a_f_y_clubcust_02", "cs_molly", "csb_bride",
    "csb_car3guy2", "cs_stretch", "csb_ramp_mex", "csb_reporter", "csb_grove_str_dlr", "g_m_m_chigoon_01",
}

local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local numberFarm = 0
function MissionPnjTaxi(isPremiumJob)
    if not isPremiumJob and pJob ~= "taxi" then
        return
    end
    if not inMission then
        inMission = true
        Citizen.CreateThread(function()
            while inMission do
                if not takeMission and not StartMission then
                    local random = math.random(1, #posStart)
                    local random2 = math.random(1, #finish)
                    local randomPed = math.random(1, #pedCreate)
                    local dist = CalculateTravelDistanceBetweenPoints(p:pos(), posStart[random].xyz)
                    local dist2 = CalculateTravelDistanceBetweenPoints(posStart[random].xyz, finish[random2].xyz)
                    if dist2 >= 99000 or dist2 == 0 then
                        dist2 = GetDistanceBetweenCoords(posStart[random].xyz, finish[random2].xyz, true)
                    end
                    if dist >= 99000 or dist == 0 then
                        dist = GetDistanceBetweenCoords(p:pos(), posStart[random].xyz, true)
                    end
                    local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(posStart[random].x,
                        posStart[random].y, posStart[random].z)) .. " (" ..
                        math.ceil(dist) .. "m)"
                    if GetDistanceBetweenCoords(posStart[random].x, posStart[random].y, posStart[random].z, finish[random2].x, finish[random2].y, finish[random2].z) < 100.0 then 
                        local random = math.random(1, #finish)
                        dist2 = GetDistanceBetweenCoords(posStart[random].xyz, finish[random2].xyz, true)
                    end
                    local streetName2 = GetStreetNameFromHashKey(GetStreetNameAtCoord(finish[random2].x,
                        finish[random2].y, finish[random2].z)) .. " (" ..
                        math.ceil(dist2) .. "m)"

                    if not timer then
                        timer = true
                    end

                    if isPremiumJob then
                        if numberFarm > 3 then 
                            OpenTutoFAInfo("Taxi", "Vous avez fini votre service, retournez au taxis pour prendre votre paye")
                            TriggerServerEvent("core:activities:update", PlayersIdTaxiFarm, "taxi", {finish = true})
                            blips = AddBlipForCoord(911.24, -170.66, 73.22)
                            SetBlipRoute(blips, true)
                            local created = false
                            while true do 
                                Wait(1)
                                local madist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 911.24, -170.66, 73.22)
                                if madist < 30.0 then 
                                    if not created then
                                        created = true
                                        Bulle.create("finishTaxi", vec3(911.24, -170.66, 73.22), "bulleGarerVert", true)
                                    end
                                    if madist < 3.0 then 
                                        if IsControlJustPressed(0, 38) then 
                                            if IsPedInAnyVehicle(PlayerPedId()) then
                                                Bulle.remove("finishTaxi")
                                                DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
                                                TriggerServerEvent("core:activities:kickplayers", PlayersIdTaxiFarm, "taxi")
                                                exports['tuto-fa']:HideStep()
                                                inMission = false
                                                takeMission = false
                                                timer = false
                                                StartMission = false
                                                break
                                            else
                                                exports['vNotif']:createNotification({
                                                    type = 'ROUGE',
                                                    content = "Vous devez être dans votre taxi pour finir cette mission"
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
--[[                     ShowAdvancedNotification("Taxi", "~b~Information",
                        "Demande de taxi.\n~b~Localisation: ~s~" .. streetName .. "\n~b~Destination: ~s~" .. streetName2
                        , "CHAR_TAXI", "CHAR_TAXI") ]]
                        
                    -- ShowNotification("Appuyer sur ~g~ Y ~w~ pour prendre la mission\nAppuyer sur ~r~ N ~w~ pour la refuser")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'VERT',
                        duration = 10, -- In seconds, default:  4
                        content = "Appuyer sur ~K Y pour ~s prendre la mission"
                    })
                    
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        duration = 10, -- In seconds, default:  4
                        content = "Appuyez sur ~K N pour ~s la refuser"
                    })

                    exports['vNotif']:createNotification({
                        type = 'MISSIONTAXI',
                        title = 'Taxi',
                        content = "Demande de taxi", -- Raison (en haut à droite)
                        adress = streetName, -- Adresse
                        adress2 = streetName2, -- Adresse
                        duration = 10, -- Durée seconde
                        distance = math.ceil(dist2),
                        distancepnj = math.ceil(dist),
                    })

                    local timerCount = 1
                    while timer do
                        timerCount += 1
                        if timerCount > 800 then 
                            if not isPremiumJob then
                                takeMission = false
                                inMission = false
                                -- ShowNotification("~r~Mission refusée")
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Mission ~s refusée"
                                })
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Mission ~s refusée"
                                })
                                Wait(5000)
                            end

                            timer = false
                        end
                        if IsControlJustPressed(0, 246) and not takeMission and p:isInVeh() then
                            takeMission = true
                            timer = false
                            -- ShowNotification("~g~Vous avez pris l'appel")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'VERT',
                                -- duration = 5, -- In seconds, default:  4
                                content = "Vous avez ~s pris l'appel"
                            })
                            exports['tuto-fa']:HideStep()

                            if isPremiumJob then                            
                                TriggerServerEvent("core:activities:update", PlayersIdTaxiFarm, "taxi", {streetName = streetName, streetName2 = streetName2, dist2 = dist2, dist = dist})
                            end
                        end
                        if IsControlJustPressed(0, 306) and not takeMission and p:isInVeh() then
                            if not isPremiumJob then
                                takeMission = false
                                inMission = false
                                -- ShowNotification("~r~Mission refusée")
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Mission ~s refusée"
                                })
                            else
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "Mission ~s refusée"
                                })
                                Wait(5000)
                            end

                            timer = false
                        end
                        Wait(1)
                    end
                    if takeMission then
                        SetWaypointOff()
                        blips = AddBlipForCoord(posStart[random])
                        SetBlipRoute(blips, true)
                        local ped = false
                        while takeMission do
                            Wait(300)
                            if #(posStart[random].xyz - p:pos()) < 100.0 and not ped then
                                TriggerSWEvent("TREFSDFD5156FD", "ADSFDF", 2000)
                                Wait(900)
                                peds = entity:CreatePed(pedCreate[randomPed], posStart[random].xyz,
                                    posStart[random].w)
                                SetEntityInvincible(peds.id, true)
                                ped = true
                            end
                            if #(posStart[random].xyz - p:pos()) < 6.0 then
                                RemoveBlip(blips)
                                if IsVehicleStopped(p:currentVeh()) then
                                    TaskEnterVehicle(peds.id, p:currentVeh(), -1, 2, 1.0, 1, 0)
                                    Wait(100)
                                    while GetIsTaskActive(peds.id, 160) do Wait(1) end
                                    if IsPedInVehicle(peds.id, p:currentVeh(), false) then
                                        StartMission = true
                                        takeMission = false
                                    end
                                end
                            end
                        end
                    end
                    if StartMission then
                        Citizen.CreateThread(function()
                            SetWaypointOff()
                            blips = AddBlipForCoord(finish[random2])
                            SetBlipRoute(blips, true)
                            while StartMission do
                                Wait(300)
                                if #(finish[random2].xyz - p:pos()) < 6.0 then
                                    RemoveBlip(blips)
                                    if IsVehicleStopped(p:currentVeh()) then
                                        FreezeEntityPosition(p:currentVeh(), true)
                                        TaskLeaveVehicle(peds.id, p:currentVeh(), 1)
                                        if not IsPedInVehicle(peds.id, p:currentVeh(), true) then
                                            FreezeEntityPosition(p:currentVeh(), false)
                                            if not isPremiumJob then
                                                local price = 0.3 * dist2
                                                StartMission = true

                                                -- ShowNotification("Vous avez déposé le client et gagné ~g~" ..
                                                --    Round(price) .. "~s~$")

                                                -- New notif
                                                exports['vNotif']:createNotification({
                                                    type = 'DOLLAR',
                                                    -- duration = 5, -- In seconds, default:  4
                                                    content = "Vous avez déposé le client et gagné ~s " .. Round(price) .. "$"
                                                })

                                                TriggerServerEvent('core:taxiEndPnj', token, Round(price))
                                                Wait(1000)
                                                peds:delete()
                                                inMission = false
                                                takeMission = false
                                                timer = false
                                                StartMission = false
                                                return
                                            else
                                                numberFarm += 1
                                                exports['vNotif']:createNotification({
                                                    type = 'JAUNE',
                                                    -- duration = 5, -- In seconds, default:  4
                                                    content = "Vous avez déposé le client"
                                                })
                                                OpenTutoFAInfo("Taxi", "Attendez un appel d'un nouveau client")
                                                Wait(1000)
                                                peds:delete()
                                                takeMission = false
                                                timer = false
                                                StartMission = false
                                                Wait(5000)
                                            end
                                        end
                                    end
                                end

                            end
                        end)
                    end
                end
                Wait(1000)
            end
        end)
    else
        inMission = false

        -- ShowNotification("~g~Mission terminée")

        -- New notif
        exports['vNotif']:createNotification({
            type = 'VERT',
            -- duration = 5, -- In seconds, default:  4
            content = "Mission ~s terminée"
        })

        inMission = false
        takeMission = false
        timer = false
        StartMission = false
        if blips ~= nil then
            SetBlipRoute(blips, false)
            RemoveBlip(blips)
            FreezeEntityPosition(p:currentVeh(), false)
        end
        return
    end
end
