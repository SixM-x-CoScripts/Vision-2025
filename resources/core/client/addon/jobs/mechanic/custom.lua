local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local open = false
local status = false
local redIndex = 1
local blueIndex = 1
local greenIndex = 1
local redIndex2 = 1
local blueIndex2 = 1
local greenIndex2 = 1
local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "shopui_title_carmod", "shopui_title_carmod")
local aesthetic = RageUI.CreateSubMenu(main, "", "Action disponible")
local perf = RageUI.CreateSubMenu(main, "", "Action disponible")
local perflist = RageUI.CreateSubMenu(perf, "", "Action disponible")
local aestheticlist = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")

---Color

local color = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local primaryColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local primaryColorList = RageUI.CreateSubMenu(primaryColor, "", "Action disponible")
local secondaryColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local secondaryColorList = RageUI.CreateSubMenu(secondaryColor, "", "Action disponible")
local customColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local customColor2 = RageUI.CreateSubMenu(color, "", "Action disponible")
local interiorColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local light = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local xenonColor = RageUI.CreateSubMenu(light, "", "Action disponible")
local liveries = RageUI.CreateSubMenu(color, "", "Action disponible")
local stickers = RageUI.CreateSubMenu(color, "", "Action disponible")
local neonKit = RageUI.CreateSubMenu(light, "", "Action disponible")
local neonColor = RageUI.CreateSubMenu(neonKit, "", "Action disponible")
-- wheel
local wheel = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local wheelList = RageUI.CreateSubMenu(wheel, "", "Action disponible")
local wheelBack = RageUI.CreateSubMenu(wheel, "", "Action disponible")
local wheelFront = RageUI.CreateSubMenu(wheel, "", "Action disponible")
local typeWheel = RageUI.CreateSubMenu(wheelList, "", "Action disponible")
local combinaisonColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local colorWheel = RageUI.CreateSubMenu(color, "", "Action disponible")
local windowTint = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local hornList = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local smokeTyreColor = RageUI.CreateSubMenu(color, "", "Action disponible")
local interior = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local interiorList = RageUI.CreateSubMenu(interior, "", "Action disponible")
local plaque = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local plaqueList = RageUI.CreateSubMenu(plaque, "", "Action disponible")
local extra = RageUI.CreateSubMenu(aesthetic, "", "Action disponible")
local phareType = RageUI.CreateSubMenu(light, "", "Action disponible")
local xenon = false
local interiorIndex = 1
local dashbordColorIndex = 1
local index = 1
local extraValue = {
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
    {value = false},
}
local noExtra = true
local dataIndex = 0
local dataName
local list = {}
local listcustom = {}
local turbo = false
local veh
local neon = {
    left = false,
    right = false,
    front = false,
    back = false
}
local dataColor = {}
local headlightColors = { {
    name = "Origine",
    id = -1
}, {
    name = "Blanc",
    id = 0
}, {
    name = "Bleu",
    id = 1
}, {
    name = "Bleu électrique",
    id = 2
}, {
    name = "Vert menthe",
    id = 3
}, {
    name = "Vert citron",
    id = 4
}, {
    name = "Jaune",
    id = 5
}, {
    name = "Or jaune",
    id = 6
}, {
    name = "Orange",
    id = 7
}, {
    name = "Rouge",
    id = 8
}, {
    name = "Rose poney",
    id = 9
}, {
    name = "Rose vif",
    id = 10
}, {
    name = "Violet",
    id = 11
}, {
    name = "Lumière noire",
    id = 12
} }
CustomPos = {}
local saveVeh = nil
CustomPosPlayer = {
    vector3(-222.09162902832, -1335.4942626953, 31.300476074219),
    vector3(-208.52241516113, -1335.0782470703, 31.300481796265),
    vector3(-213.9012298584, -1334.8658447266, 31.336013793945),
    vector3(-195.62390136719, -1326.9123535156, 30.300477981567),
    --vector3(875.8771, -2124.822, 30.5586),
    --vector3(887.1578, -2126.162, 30.5586),
    --vector3(897.8695, -2126.953, 30.5586),
    --vector3(909.1412, -2127.719, 30.5586),
    vector3(2522.0280761719, 2619.2868652344, 37.945377349854), -- Harmony-Rex
    vector3(2527.5012207031, 2634.6303710938, 37.94535446167), -- Harmony-Rex
    vector3(2522.6044921875, 2606.4982910156, 37.945369720459), -- Harmony-Rex
    vector3(1174.6185302734, 2640.0444335938, 37.753860473633),
    vector3(1182.3448486328, 2639.3857421875, 37.753860473633),
    vector3(4365.7016601563, 7964.9116210938, 92.413711547852), -- event
    --vector3(4359.5078125, 7968.4672851563, 92.50870513916), -- event
    vector3(-1416.8284912109, -446.95864868164, 35.9096908569344),
    vector3(-1423.1705322266, -450.89498901367, 35.909690856934 ),
    --vector3(162.61094665527, 6386.7475585938, 30.273830413818), -- Beekers
    --vector3(168.77581787109, 6374.5678710938, 30.273832321167), -- Beekers
    --vector3(156.55500793457, 6361.529296875, 30.273817062378), -- Beekers
    --vector3(149.0862121582, 6376.4692382812, 30.273820877075), -- Beekers
    --vector3(200.1650390625, 6404.4438476562, 30.381946563721), -- Beekers Ext
    vector3(167.59141540527, 6377.8647460938, 31.298736572266), -- Beekers
    vector3(164.34674072266, 6384.50390625, 31.298734664917), -- Beekers
    vector3(151.04487609863, 6372.6840820312, 31.275688171387), -- Beekers
    vector3(154.98387145996, 6364.0268554688, 31.275691986084), -- Beekers

    vector3(571.97290039063, 2764.5864257813, 41.12663269043),
    vector3(572.44061279297, 2758.2941894531, 41.126621246338),
    vector3(572.69989013672, 2752.3603515625, 41.126331329346),
    vector3(559.62530517578, 2776.8864746094, 41.141967773438),
    vector3(-800.99676513672, -1506.5111083984, 1.874317908287), --Heliwave Bateau

    vector3(554.93994140625, -198.7427520752, 53.564208984375),
    vector3(555.75219726562, -190.7414855957, 53.508735656738),
    vector3(555.86566162109, -183.23739624023, 53.508708953857),
    vector3(557.01275634766, -168.23751831055, 53.547431945801),
    vector3(556.0, -175.31, 53.51),
    vector3(-796.57, -1516.04, -0.73),
    vector3(-1124.9, -2875.99, 13.95),
    vector3(571.76, -230.67, 54.83)
}

CreateThread(function()
    while p == nil do
        Wait(0)
    end

    if p:getJob() == "bennys" then
        CustomPos = {
            vector3(-222.09162902832, -1335.4942626953, 31.300476074219),
            vector3(-208.52241516113, -1335.0782470703, 31.300481796265),
            vector3(-213.9012298584, -1334.8658447266, 31.336013793945),
            vector3(-193.09997558594, -1326.8818359375, 30.300477981567),
            vector3(-2150.7770996094, 3234.7976074219, 32.810287475586), -- admin customs
            vector3(4359.5078125, 7968.4672851563, 92.50870513916), -- event
            vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            vector3(-1112.4291992188, -2883.9079589844, 12.946015357971), --Heliwave Heli/Avion
        }
    --[[ elseif p:getJob() == "sunshine" then
        CustomPos = {
            --vector3(875.8771, -2124.822, 30.5586),
            --vector3(887.1578, -2126.162, 30.5586),
            --vector3(897.8695, -2126.953, 30.5586),
            --vector3(909.1412, -2127.719, 30.5586),
            --vector3(4365.7016601563, 7964.9116210938, 92.413711547852), -- event
            --vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            --vector3(-1112.4291992188, -2883.9079589844, 12.946015357971), --Heliwave Heli/Avion
        } ]]
    elseif p:getJob() == "cayogarage" then
        CustomPos = {
            vector3(5130.5478515625, -5136.572265625, 1.2138652801514),
            vector3(5128.5073242188, -5127.2431640625, 1.2138657569885),
            vector3(5128.9038085938, -5136.6118164063, 1.2138655185699),
            vector3(5128.4243164063, -5128.5727539063, 1.2138648033142),
            vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            vector3(-1112.4291992188, -2883.9079589844, 12.946015357971), --Heliwave Heli/Avion
        }
    elseif p:getJob() == "hayes" then
        CustomPos = {
            vector3(-1416.8284912109, -446.95864868164, 34.9096908569344),
            vector3(-1423.1705322266, -450.89498901367, 34.909690856934 ),
            vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            vector3(-1112.4291992188, -2883.9079589844, 12.946015357971), --Heliwave Heli/Avion
        }
    elseif p:getJob() == "beekers" then
        CustomPos = {
            vector3(164.05798339844, 6384.451171875, 30.298738479614),
            vector3(167.56466674805, 6377.875, 30.29874420166),
            vector3(150.41819763184, 6372.5473632812, 30.273849487305),
            vector3(155.97593688965, 6365.0903320312, 30.273834228516),
            vector3(200.1650390625, 6404.4438476562, 30.381946563721),
            vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            vector3(-1112.4291992188, -2883.9079589844, 12.946015357971), --Heliwave Heli/Avion
        }
    elseif p:getJob() == "harmony" then
        CustomPos = {
            -- vector3(1182.1461181641, 2639.7976074219, 36.753879547119),
            -- vector3(1173.9478759766, 2639.3454589844, 36.766952514648),
            vector3(2522.0280761719, 2619.2868652344, 36.945377349854), -- Harmony-Rex
            vector3(2527.5012207031, 2634.6303710938, 36.94535446167), -- Harmony-Rex
            vector3(2522.6044921875, 2606.4982910156, 36.945369720459), -- Harmony-Rex
            vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            vector3(-1112.4291992188, -2883.9079589844, 12.946015357971), --Heliwave Heli/Avion
        }
    elseif p:getJob() == "ocean" then
        CustomPos = {
            vector3(554.93994140625, -198.7427520752, 53.564208984375),
            vector3(555.75219726562, -190.7414855957, 53.508735656738),
            vector3(555.86566162109, -183.23739624023, 53.508708953857),
            vector3(557.01275634766, -168.23751831055, 53.547431945801),
            vector3(-800.99676513672, -1506.5111083984, 1.474317908287), --Heliwave Bateau
            vector3(-1112.5192871094, -2883.9377441406, 13.946022033691), --Heliwave Heli/Avion
            vector3(556.0, -175.31, 53.51),
            vector3(571.76, -230.67, 54.83),
        }
    end
end)

local category_custom = {}

main.Closed = function()
    RageUI.Visible(main, false)
    RageUI.Visible(aesthetic, false)
    RageUI.Visible(perf, false)
    RageUI.Visible(perflist, false)
    RageUI.Visible(aestheticlist, false)
    RageUI.Visible(color, false)
    RageUI.Visible(primaryColor, false)
    RageUI.Visible(primaryColorList, false)
    RageUI.Visible(secondaryColor, false)
    RageUI.Visible(secondaryColorList, false)
    RageUI.Visible(customColor, false)
    RageUI.Visible(customColor2, false)
    RageUI.Visible(interiorColor, false)
    RageUI.Visible(light, false)
    RageUI.Visible(liveries, false)
    RageUI.Visible(stickers, false)
    RageUI.Visible(xenonColor, false)
    RageUI.Visible(neonColor, false)
    RageUI.Visible(neonKit, false)
    RageUI.Visible(wheel, false)
    RageUI.Visible(wheelList, false)
    RageUI.Visible(wheelBack, false)
    RageUI.Visible(wheelFront, false)
    RageUI.Visible(typeWheel, false)
    RageUI.Visible(combinaisonColor, false)
    RageUI.Visible(colorWheel, false)
    RageUI.Visible(windowTint, false)
    RageUI.Visible(hornList, false)
    RageUI.Visible(smokeTyreColor, false)
    RageUI.Visible(interior, false)
    RageUI.Visible(interiorList, false)
    RageUI.Visible(plaque, false)
    RageUI.Visible(plaqueList, false)
    RageUI.Visible(extra, false)
    RageUI.Visible(phareType, false)
    vehicle.setProps(veh, saveVeh)
    open = false
end
-- TODO: Ajouter Menu, Interieur, plaque
function OpenCustomMenu()
    if open then
        RageUI.Visible(main, false)
        RageUI.Visible(aesthetic, false)
        RageUI.Visible(perf, false)
        RageUI.Visible(perflist, false)
        RageUI.Visible(aestheticlist, false)
        RageUI.Visible(color, false)
        RageUI.Visible(primaryColor, false)
        RageUI.Visible(primaryColorList, false)
        RageUI.Visible(secondaryColor, false)
        RageUI.Visible(secondaryColorList, false)
        RageUI.Visible(customColor, false)
        RageUI.Visible(customColor2, false)
        RageUI.Visible(interiorColor, false)
        RageUI.Visible(light, false)
        RageUI.Visible(liveries, false)
        RageUI.Visible(stickers, false)
        RageUI.Visible(xenonColor, false)
        RageUI.Visible(neonColor, false)
        RageUI.Visible(neonKit, false)
        RageUI.Visible(wheel, false)
        RageUI.Visible(wheelList, false)
        RageUI.Visible(wheelBack, false)
        RageUI.Visible(wheelFront, false)
        RageUI.Visible(typeWheel, false)
        RageUI.Visible(combinaisonColor, false)
        RageUI.Visible(colorWheel, false)
        RageUI.Visible(windowTint, false)
        RageUI.Visible(hornList, false)
        RageUI.Visible(smokeTyreColor, false)
        RageUI.Visible(interior, false)
        RageUI.Visible(interiorList, false)
        RageUI.Visible(plaque, false)
        RageUI.Visible(plaqueList, false) 
        RageUI.Visible(extra, false)
        RageUI.Visible(phareType, false)
        vehicle.setProps(veh, saveVeh)
        open = false
        return
    else
        Visual.Subtitle("Appuyez sur Espace pour ouvrir les portes", 8000)
        status = false
        for i = 0, 7 do
            if IsVehicleDoorFullyOpen(veh, i) then
                status = true
            end
        end
        open = true
        veh = p:currentVeh()
        neon = {
            left = false,
            right = false,
            front = false,
            back = false
        }
        saveVeh = vehicle.getProps(veh)
        RageUI.Visible(main, true)
        SetVehicleModKit(veh, 0)
        if IsToggleModOn(veh, 18) then
            turbo = true
        else
            turbo = false
        end
        Citizen.CreateThread(function()
            while open do
                -- if the player presses space, open all doors
                if IsControlJustPressed(0, 22) then
                    if not status then
                        for i = 0, 7 do
                            SetVehicleDoorOpen(veh, i, false, false)
                            status = true
                        end
                    else
                        for i = 0, 7 do
                            SetVehicleDoorShut(veh, i, false)
                            status = false
                        end
                    end
                end
                RageUI.IsVisible(main, function()
                    RageUI.Button("Performance", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, perf)
                    RageUI.Button("Esthetique", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, aesthetic)

                    RageUI.Button("Valider la commande", false, {
                        RightBadge = RageUI.BadgeStyle.Tick
                    }, true, {
                        onSelected = function()
                            TriggerServerEvent('core:addCommandeMecano', token, all_trim(GetVehicleNumberPlateText(veh)),
                                GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))), vehicle.getProps(veh))
                            vehicle.setProps(veh, saveVeh)
                            RageUI.CloseAll()
                            open = false
                            -- ShowNotification("~g~Commande transmise")

                            -- New notif
                            exports['vNotif']:createNotification({
                                type = 'JAUNE',
                                -- duration = 5, -- In seconds, default:  4
                                content = "~s Commande transmise"
                            })

                            -- Event refresh
                        end
                    }, nil)

                end)

                RageUI.IsVisible(perf, function()
                    for k, v in pairs(Custom.perf) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                index = GetVehicleMod(veh, v.label)
                            end
                        }, perflist)
                    end
                end)

                RageUI.IsVisible(aesthetic, function()
                    for k, v in pairs(Custom.aesthetic) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                index = GetVehicleMod(veh, v.label)
                            end
                        }, aestheticlist)
                    end
                    RageUI.Button('Klaxon', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, hornList)
                    RageUI.Button('Peinture', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            list = {}
                            for i = 1, 161 do
                                table.insert(list, i)
                            end
                            listcustom = {}
                            for i = 1, 256 do
                                table.insert(listcustom, i)
                            end
                        end
                    }, color)
                    RageUI.Button('Phares', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, light)
                    RageUI.Button('Roue', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            ToggleVehicleMod(veh, 20)
                        end
                    }, wheel)
                    RageUI.Button('Vitre', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, windowTint)
                    RageUI.Button('Interieur', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, interior)
                    RageUI.Button('Plaque', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, plaque)
                    RageUI.Button('extra', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, extra)
                end)


                
                RageUI.IsVisible(interior, function()
                    for k, v in pairs(Custom.interior) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.id
                                index = GetVehicleMod(veh, v.id)
                            end
                        }, interiorList)
                    end
                end)
                RageUI.IsVisible(plaque, function()
                    for k, v in pairs(Custom.plaque) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.id
                                index = GetVehicleMod(veh, v.id)
                            end
                        }, plaqueList)
                    end
                end)
                RageUI.IsVisible(plaqueList, function()
                    if dataIndex == 26 then
                        RageUI.Button("Bleu sur blanc", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 0)
                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 0)
                            end
                        }, nil)
                        RageUI.Button("Bleu sur blanc 2", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 3)

                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 3)

                            end
                        }, nil)
                        RageUI.Button("Bleu sur blanc 3", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 4)

                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 4)

                            end
                        }, nil)
                        RageUI.Button("Jaune sur noir", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 1)

                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 1)

                            end
                        }, nil)
                        RageUI.Button("Jaune sur bleu", false, {
                        }, true, {
                            onActive = function()
                                SetVehicleNumberPlateTextIndex(veh, 2)
                                -- SetVehicleMod(veh, 25, 2)
                                -- SetVehicleMod(veh, 26, 2)
                            end,
                            onSelected = function()
                                index = 1
                                SetVehicleNumberPlateTextIndex(veh, 2)
                                -- SetVehicleMod(veh, 25, 2)
                                -- SetVehicleMod(veh, 26, 2)
                            end
                        }, nil)
                    end
                    if GetNumVehicleMods(veh, dataIndex) == 0 and dataIndex ~= 26 then
                        RageUI.Separator("Pas de modification disponible")
                    else

                        for i = 1, GetNumVehicleMods(veh, dataIndex) do
                            local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end
                            }, nil)

                        end
                    end
                end)

                RageUI.IsVisible(extra, function()
                    for k, v in pairs(extraValue) do
                        if DoesExtraExist(veh, k) then
                            noExtra = false
                            RageUI.Checkbox('extra '..k, false, v.value, {}, {
                                onChecked = function()
                                    SetVehicleExtra(veh, k, 1)
                                    v.value = true
                                end,
                                onUnChecked = function()
                                    SetVehicleExtra(veh, k, 0)
                                    v.value = false
                                end
                            })
                        end
                       
                    end 
                    if noExtra then
                        RageUI.Separator("Pas de modification disponible")
                    end
                end)
                
                RageUI.IsVisible(interiorList, function()
                    if GetNumVehicleMods(veh, dataIndex) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetNumVehicleMods(veh, dataIndex) do
                            local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleMod(veh, dataIndex, i, 0)
                                end
                            }, nil)

                        end
                    end
                end)
                RageUI.IsVisible(hornList, function()
                    for i = 1, GetNumVehicleMods(veh, 14) do
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button("Klaxon n°" .. i, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 14, i, 0)
                                if IsHornActive(veh) then
                                    DisableControlAction(0, 38, true) 
                                end
                                DisableControlAction(0, 38, false) 
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 14, i, 0)
                            end
                        }, nil)

                    end
                end)

                RageUI.IsVisible(windowTint, function()
                    for k, v in pairs(Custom.windowTint) do
                        if index == v.id then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleWindowTint(veh, v.id)
                            end,
                            onSelected = function()
                                SetVehicleWindowTint(veh, v.id)
                                index = GetVehicleWindowTint(veh)
                            end
                        }, nil)
                    end
                end)
                RageUI.IsVisible(wheel, function()

                    RageUI.Button("Type de roue", false, {
                        RightLabel = ">"
                    }, true, {}, typeWheel)
                    RageUI.Button("Couleur des jantes", false, {
                        RightLabel = ">"
                    }, true, {}, colorWheel)
                    RageUI.Button("Fumée de pneu", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, smokeTyreColor)

                end)
                RageUI.IsVisible(colorWheel, function()
                    for k, v in pairs(Custom.nacrageColor) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)

                                SetVehicleExtraColours(veh, pearlescentColor, v.id)
                            end,
                            onSelected = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                                index = k
                                SetVehicleExtraColours(veh, pearlescentColor, v.id)
                            end
                        }, nil)
                    end

                end)
                RageUI.IsVisible(typeWheel, function()
                    if IsThisModelABike(GetEntityModel(veh)) then
                        RageUI.Button("Roue avant", false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataIndex = 23
                                index = GetVehicleMod(veh, 23)
                            end
                        }, wheelFront)
                        RageUI.Button("Roue arrière", false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataIndex = 24
                                index = GetVehicleMod(veh, 24)
                            end
                        }, wheelBack)
                    else
                        for k, v in pairs(Custom.wheels) do
                            RageUI.Button(v.name, false, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    dataName = v.name
                                    dataIndex = 23
                                    SetVehicleWheelType(veh, v.id)
                                    index = GetVehicleMod(veh, 23)
                                end
                            }, wheelList)
                        end
                    end
                end)
                RageUI.IsVisible(wheelList, function()

                    for i = 1, GetNumVehicleMods(veh, 23) do
                        local name = GetLabelText(GetModTextLabel(veh, 23, i)) -- Change seulement la roue AV sur les moto
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 23, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 23, i, 0)
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(wheelFront, function()
                    for i = 1, GetNumVehicleMods(veh, 23) do
                        local name = GetLabelText(GetModTextLabel(veh, 23, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 23, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 23, i, 0)
                            end
                        }, nil)
                    end
                end)

                RageUI.IsVisible(wheelBack, function()
                    for i = 1, GetNumVehicleMods(veh, 24) do
                        local name = GetLabelText(GetModTextLabel(veh, 24, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 24, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 24, i, 0)
                            end
                        }, nil)
                    end
                end)

                ---color
                RageUI.IsVisible(light, function()
                    RageUI.Checkbox('Phare xénon', false, xenon, {}, {
                        onChecked = function()
                            xenon = true
                            ToggleVehicleMod(veh, 22, true)
                        end,
                        onUnChecked = function()
                            xenon = false
                            ToggleVehicleMod(veh, 22, false)
                        end
                    })

                    if xenon then
                        RageUI.Button("Couleur des phares", false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                index = GetVehicleXenonLightsColor(veh)
                            end
                        }, xenonColor)
                    end
                    RageUI.Button('Kits néon', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()

                        end
                    }, neonKit)
                    RageUI.Button('Position des phares', false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()

                        end
                    }, phareType)
                end)
                RageUI.IsVisible(phareType, function()
                    for i = 1, GetNumVehicleMods(veh, 42) do
                        local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 42, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 42, i, 0)
                            end
                        }, nil)

                    end
                end)
                RageUI.IsVisible(neonKit, function()
                    RageUI.Checkbox('Néon gauche', false, neon.left, {}, {
                        onChecked = function()
                            neon.left = true
                            SetVehicleNeonLightEnabled(veh, 0, true)
                        end,
                        onUnChecked = function()
                            neon.left = false
                            SetVehicleNeonLightEnabled(veh, 0, false)
                        end
                    })
                    RageUI.Checkbox('Néon droit', false, neon.right, {}, {
                        onChecked = function()
                            neon.right = true
                            SetVehicleNeonLightEnabled(veh, 1, true)
                        end,
                        onUnChecked = function()
                            neon.right = false
                            SetVehicleNeonLightEnabled(veh, 1, false)
                        end
                    })
                    RageUI.Checkbox('Néon avant', false, neon.front, {}, {
                        onChecked = function()
                            neon.front = true
                            SetVehicleNeonLightEnabled(veh, 2, true)
                        end,
                        onUnChecked = function()
                            neon.front = false
                            SetVehicleNeonLightEnabled(veh, 2, false)
                        end
                    })
                    RageUI.Checkbox('Néon arrière', false, neon.back, {}, {
                        onChecked = function()
                            neon.back = true
                            SetVehicleNeonLightEnabled(veh, 3, true)
                        end,
                        onUnChecked = function()
                            neon.back = false
                            SetVehicleNeonLightEnabled(veh, 3, false)
                        end
                    })
                    RageUI.Button("Couleur néon", false, {}, true, {}, neonColor)
                end)

                RageUI.IsVisible(smokeTyreColor, function()
                    for k, v in pairs(Custom.neon) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                ToggleVehicleMod(veh, 20, true)
                                SetVehicleTyreSmokeColor(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end,
                            onSelected = function()
                                ToggleVehicleMod(veh, 20, true)
                                index = k
                                SetVehicleTyreSmokeColor(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end
                        }, nil)
                    end

                end)
                RageUI.IsVisible(neonColor, function()
                    for k, v in pairs(Custom.neon) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleNeonLightsColour(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end,
                            onSelected = function()
                                index = k
                                SetVehicleNeonLightsColour(veh, v.rgb[1], v.rgb[2], v.rgb[3])
                            end
                        }, nil)
                    end

                end)
                RageUI.IsVisible(xenonColor, function()
                    for k, v in pairs(headlightColors) do
                        if index == v.id then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleXenonLightsColor(veh, v.id)
                            end,
                            onSelected = function()
                                index = v.id
                                SetVehicleXenonLightsColor(veh, v.id)
                            end
                        }, nil)
                    end

                end)

                RageUI.IsVisible(color, function()
                    RageUI.Button("Couleur principale", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            ClearVehicleCustomPrimaryColour(GetVehiclePedIsIn(PlayerPedId()))
                            ClearVehicleCustomSecondaryColour(GetVehiclePedIsIn(PlayerPedId()))
                        end
                    }, primaryColor)
                    RageUI.Button("Couleur secondaire", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            ClearVehicleCustomPrimaryColour(GetVehiclePedIsIn(PlayerPedId()))
                            ClearVehicleCustomSecondaryColour(GetVehiclePedIsIn(PlayerPedId()))
                        end
                    }, secondaryColor)
                    RageUI.Button("Nacrage", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)

                            index = pearlescentColor
                        end
                    }, combinaisonColor)
                    RageUI.Button("Motif", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, liveries)
                    RageUI.Button("Stickers", false, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                        end
                    }, stickers)
                    -- for k, v in pairs(Custom.primaryColor) do
                    --     RageUI.Button(v.name, false, { RightLabel = ">" }, true, {
                    --         onSelected = function()
                    --             dataName = v.name
                    --             dataIndex = v.label
                    --             index = GetVehicleMod(veh, v.label)
                    --         end
                    --     }, perflist)
                    RageUI.List("Couleur intérieur", list, interiorIndex, false, {}, true, {
                        onListChange = function(Index)
                            interiorIndex = Index
                            SetVehicleInteriorColor(veh, interiorIndex)
                        end
                    }, nil)
                    RageUI.List("Couleur tableau de bord", list, dashbordColorIndex, false, {}, true, {
                        onListChange = function(Index)
                            dashbordColorIndex = Index
                            SetVehicleDashboardColor(veh, dashbordColorIndex)
                        end
                    }, nil)

                    -- end
                end)

                RageUI.IsVisible(interiorColor, function()
                    for i = 1, 161 do
                        if i < 161 then
                            local name = ""
                            for k, v in pairs(Custom.color[1].color) do
                                if v.id == i then
                                    name = v.name
                                end
                            end

                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name .. i, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleInteriorColor(veh, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleInteriorColor(veh, i)
                                end
                            }, nil)
                        end

                    end
                end)

                RageUI.IsVisible(liveries, function()
                    for i = 1, GetNumVehicleMods(veh, 48) do
                        local name = GetLabelText(GetModTextLabel(veh, 48, i))
                        if name == "NULL" then
                            name = "Original"
                        end
                        if index == i then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end

                        RageUI.Button(name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, 48, i, 0)
                            end,
                            onSelected = function()
                                index = i
                                SetVehicleMod(veh, 48, i, 0)
                            end
                        }, nil)

                    end
                end)
                RageUI.IsVisible(stickers, function()
                    if GetVehicleLiveryCount(veh) == -1 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 1, GetVehicleLiveryCount(veh) do
                            local name = GetLabelText(GetLiveryName(veh, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleLivery(veh, i)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleLivery(veh, i)
                                end
                            }, nil)

                        end
                    end
                end)
                RageUI.IsVisible(primaryColor, function()
                    for k, v in pairs(Custom.color) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                if v.color ~= nil then
                                    dataColor = v.color
                                end
                                index = GetNumModColors(veh)
                            end
                        }, primaryColorList)
                    end
                end)
                RageUI.IsVisible(combinaisonColor, function()
                    for k, v in pairs(Custom.nacrageColor) do
                        if index == k then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(v.name, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)

                                SetVehicleExtraColours(veh, v.id, wheelColor)
                            end,
                            onSelected = function()
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
                                index = k
                                SetVehicleExtraColours(veh, v.id, wheelColor)
                            end
                        }, nil)
                    end

                end)

                RageUI.IsVisible(secondaryColor, function()
                    for k, v in pairs(Custom.color) do
                        RageUI.Button(v.name, false, {
                            RightLabel = ">"
                        }, true, {
                            onSelected = function()
                                dataName = v.name
                                dataIndex = v.label
                                if v.color ~= nil then
                                    dataColor = v.color
                                end
                                index = GetNumModColors(veh)
                            end
                        }, secondaryColorList)
                    end
                end)
                RageUI.IsVisible(primaryColorList, function()
                    for i = 1, GetNumModColors(dataIndex, true) do
                        if i < GetNumModColors(dataIndex, true) then
                            local name = ""
                            for k, v in pairs(dataColor) do
                                if v.id == i then
                                    name = v.name
                                end
                            end

                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleModColor_1(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleModColor_1(veh, dataIndex, i, 0)
                                end
                            }, nil)
                        end

                    end
                end)
                RageUI.IsVisible(secondaryColorList, function()
                    for i = 1, GetNumModColors(dataIndex, true) do
                        if i < GetNumModColors(dataIndex, true) then
                            local name = ""
                            for k, v in pairs(dataColor) do
                                if v.id == i then
                                    name = v.name
                                end
                            end

                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end

                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleModColor_2(veh, dataIndex, i, 0)
                                end,
                                onSelected = function()
                                    index = i
                                    SetVehicleModColor_2(veh, dataIndex, i, 0)

                                end
                            }, nil)
                        end

                    end
                end)

                RageUI.IsVisible(perflist, function()
                    if GetNumVehicleMods(veh, dataIndex) == 0 and dataIndex ~= 18 then
                        RageUI.Separator("Pas de modification disponible")
                    elseif dataIndex == 18 then

                        if turbo then
                            Rightbadges = RageUI.BadgeStyle.Car
                        else
                            Rightbadges = nil
                        end

                        RageUI.Button("Turbo", false, {
                            RightBadge = Rightbadges
                        }, true, {
                            onActive = function()
                            end,
                            onSelected = function()
                                if turbo then
                                    turbo = false
                                    ToggleVehicleMod(veh, 18, false)
                                else
                                    turbo = true
                                    ToggleVehicleMod(veh, 18, true)
                                end
                            end
                        }, nil)
                    end


                    if GetNumVehicleMods(veh, dataIndex) >= 1 then
                        if index == 4 then
                            Rightbadge = RageUI.BadgeStyle.Car
                        else
                            Rightbadge = nil
                        end
                        RageUI.Button(dataName .. " - Niveau n°" .. 0, false, {
                            RightBadge = Rightbadge
                        }, true, {
                            onActive = function()
                                SetVehicleMod(veh, dataIndex, 4, false)
                            end,
                            onSelected = function()
                                index = 4
                                SetVehicleMod(veh, dataIndex, 4, true)
                            end
                        }, nil)
                        for i = 0, GetNumVehicleMods(veh, dataIndex) do

                            if i < GetNumVehicleMods(veh, dataIndex) then
                                if index == i then
                                    Rightbadge = RageUI.BadgeStyle.Car
                                else
                                    Rightbadge = nil
                                end
                                RageUI.Button(dataName .. " - Niveau n°" .. i + 1, false, {
                                    RightBadge = Rightbadge
                                }, true, {
                                    onActive = function()
                                        SetVehicleMod(veh, dataIndex, i, false)
                                    end,
                                    onSelected = function()
                                        index = i
                                        SetVehicleMod(veh, dataIndex, i, true)
                                    end
                                }, nil)
                            end
                        end
                    end
                    RageUI.StatisticPanel((GetVehicleEstimatedMaxSpeed(veh) / 100) * 2, "Vitesse de pointe", i)
                    RageUI.StatisticPanel(GetVehicleAcceleration(veh), "Accéleration", i)
                    RageUI.StatisticPanel((GetVehicleMaxBraking(veh) / 10) * 5, "Freinage", i)
                    RageUI.StatisticPanel((GetVehicleMaxTraction(veh) / 10) * 2, "Tenue de route", i)

                end)

                RageUI.IsVisible(aestheticlist, function()
                    if GetNumVehicleMods(veh, dataIndex) == 0 then
                        RageUI.Separator("Pas de modification disponible")
                    else
                        for i = 0, GetNumVehicleMods(veh, dataIndex) do
                            local name = GetLabelText(GetModTextLabel(veh, dataIndex, i))
                            if name == "NULL" then
                                name = "Original"
                            end
                            if index == i then
                                Rightbadge = RageUI.BadgeStyle.Car
                            else
                                Rightbadge = nil
                            end
                            RageUI.Button(name, false, {
                                RightBadge = Rightbadge
                            }, true, {
                                onActive = function()
                                    SetVehicleMod(veh, dataIndex, i, true)
                                end,
                                onSelected = function()
                                    index = i
                                end
                            }, nil)
                        end
                        RageUI.StatisticPanel((GetVehicleEstimatedMaxSpeed(veh) / 100) * 2, "Vitesse de pointe", i)
                        RageUI.StatisticPanel(GetVehicleAcceleration(veh), "Accéleration", i)
                        RageUI.StatisticPanel((GetVehicleMaxBraking(veh) / 10) * 5, "Freinage", i)
                        RageUI.StatisticPanel((GetVehicleMaxTraction(veh) / 10) * 2, "Tenue de route", i)
                    end
                end)

                Wait(1)
            end
        end)
    end
end

-- RegisterCommand("custom", function ()
--     OpenCustomMenu()
-- end)

local open = false
local currentCustom_main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "shopui_title_carmod",
    "shopui_title_carmod")
local currentCustom_category = RageUI.CreateSubMenu(currentCustom_main, "", "Action disponible", 0.0, 0.0,
    "shopui_title_carmod", "shopui_title_carmod")
local currentCustom_aesthetic = RageUI.CreateSubMenu(currentCustom_main, "", "Action disponible")
local currentCustom_perf = RageUI.CreateSubMenu(currentCustom_main, "", "Action disponible")
local submodifCustom = RageUI.CreateSubMenu(currentCustom_category, '', "Modification")
currentCustom_main.Closed = function()
    open = false
end

local currentCommand = nil
local selected_command = nil
local selected_key = nil

function OpenCurrentCustom()
    if open then
        open = false
        RageUI.Visible(currentCustom_main, false)
    else
        open = true
        RageUI.Visible(currentCustom_main, true)
        currentCommand = TriggerServerCallback("core:GetCommandeMecanoCb", token)
        local NewCustom = {}
        CreateThread(function()
            while open do
                RageUI.IsVisible(currentCustom_main, function()
                    for k, v in pairs(currentCommand) do
                        if v.name ~= nil then
                            RageUI.Button((v.plate or "?") .. " | " .. v.name, nil, {
                                RightLabel = ">"
                            }, true, {
                                onSelected = function()
                                    selected_command = v
                                    selected_key = k
                                    NewCustom = {}
                                    for key, value in pairs(selected_command.props) do
                                        for _, vv in pairs(vehicle.getProps(p:currentVeh())) do
                                            if key == _ then
                                                if value ~= vv then
                                                    table.insert(NewCustom, { props = key, value = value })
                                                end
                                            end
                                        end
                                    end
                                end
                            }, currentCustom_category)
                        else
                            RageUI.Separator("Aucune commande en cours")
                        end
                    end
                end)
                RageUI.IsVisible(currentCustom_category, function()
                    RageUI.Button("Modification du véhicule", nil, { RightLabel = ">" }, true, {}, submodifCustom)
                    RageUI.Button("Appliquer les customs", nil, {
                        RightLabel = ">"
                    }, true, {
                        onSelected = function()
                            -- local canBuy = TriggerServerCallback("core:buyCommande", token)
                            -- if canBuy then
                            if all_trim(GetVehicleNumberPlateText(p:currentVeh())) == selected_command.plate then
                                vehicle.setProps(p:currentVeh(), selected_command.props)
                                TriggerServerEvent("core:removeCommandeMecano", token, selected_key, p:getJob())
                                TriggerServerEvent("core:SetPropsVeh", token, all_trim(GetVehicleNumberPlateText(p:currentVeh())),
                                    vehicle.getProps(p:currentVeh()))

                                RageUI.GoBack()
                            else
                                -- ShowNotification("Ce n'est pas le bon véhicule")

                                -- New notif
                                exports['vNotif']:createNotification({
                                    type = 'ROUGE',
                                    -- duration = 5, -- In seconds, default:  4
                                    content = "~s Ce n'est pas le bon véhicule"
                                })

                            end
                            -- end
                        end
                    })
                    -- RageUI.Button("Esthetique", nil, {RightLabel = ">"}, true, {}, currentCustom_aesthetic)
                    RageUI.Button("Supprimer la commande", nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("core:removeCommandeMecano", token, selected_key, p:getJob())
                            RageUI.GoBack()
                        end
                    })
                end)
                RageUI.IsVisible(submodifCustom, function()
                    for key, value in pairs(NewCustom) do
                        RageUI.Button(value.props, nil, {}, true, {})
                    end
                end)
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent("core:GetCommandeMecano")
AddEventHandler("core:GetCommandeMecano", function(data)
    currentCommand = data
end)

function OpenCustomVehMenu()
    local dst = nil
    local tables = {}
    for k, v in pairs(CustomPos) do
        dst = GetDistanceBetweenCoords(p:pos(), vector3(v.x, v.y, v.z), true)
        table.insert(tables, {
            pos = dst
        })
    end
    for k, v in pairs(tables) do
        if v.pos <= 5.5 then
            if IsPedInAnyVehicle(p:ped()) then
                OpenCurrentCustom()
            else
                -- ShowNotification("Vous devez être dans le véhicule pour ouvrir le menu")

                -- New notif
                exports['vNotif']:createNotification({
                    type = 'ROUGE',
                    -- duration = 5, -- In seconds, default:  4
                    content = "~s Vous devez être dans le véhicule pour ouvrir le menu"
                })

            end
        end
    end
end

Citizen.CreateThread(function()
    while zone == nil do
        Wait(1)
    end
    for k, v in pairs(CustomPosPlayer) do
        zone.addZone("custombiatch" .. k,
                vector3(v.x, v.y, v.z), "~INPUT_CONTEXT~ Intéragir", function()
                if p:isInVeh() then
                    if p:getJob() == "harmony" or p:getJob() == "beekers" or p:getJob() == "bennys" or p:getJob() == "cayogarage" or p:getJob() == "ocean" or p:getJob() == "hayes" then
                        OpenCustomMenu() -- TODO: fini le menu society
                    else
                        exports['vNotif']:createNotification({
                            type = 'ROUGE',
                            -- duration = 5, -- In seconds, default:  4
                            content = "~s Vous n'êtes pas mécanicien"
                        })
                    end
                else
                    -- ShowNotification("~r~Vous n'êtes pas dans un véhicule")

                    -- New notif
                    exports['vNotif']:createNotification({
                        type = 'ROUGE',
                        -- duration = 5, -- In seconds, default:  4
                        content = "~s Vous n'êtes pas dans un véhicule"
                    })

                end
            end,
            false, -- Avoir un marker ou non
            -1, -- Id / type du marker
            0.6, -- La taille
            { 0, 0, 0 }, -- RGB
            0, -- Alpha
            2.0,
            true,
            "bulleCustom"
        )
    end
end)
