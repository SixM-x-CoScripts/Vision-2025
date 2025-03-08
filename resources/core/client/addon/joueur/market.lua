local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

local open = false
local market_main = RageUI.CreateMenu("", "Superette", 0.0, 0.0, 'vision', "menu_title_ltd")
market_main.Closed = function ()
    open = false
end

local marketCfg = {
    {
        item = "banana",
        price = 40,
        index = 1,
    },
    {
        item = "water",
        price = 30,
        index = 1,
    },
    {
        item = "tapas",
        price = 50,
        index = 1,
    },
    {
        item = "pince",
        price = 50,
        index = 1,
    },
    {
        item = "cig",
        price = 20,
        index = 1,
    },
}
local marketItem = {}

for i = 1, 10 do
    table.insert(marketItem, i)
end

local marketPos = {
    vector3(-715.86547851563, -909.56036376953, 19.215599060059),
    vector3(1154.021484375, -320.39053344727, 69.205101013184),
    vector3(26.71954536438, -1346.2580566406, 29.496961593628),
    vector3(-50.614688873291, -1748.9300537109, 29.421005249023),
    vector3(-1222.3823242188, -906.82891845703, 12.326347351074),
    vector3(-1487.6103515625, -378.73391723633, 40.163410186768),
    vector3(374.52481079102, 326.58853149414, 103.56629943848),
    vector3(1135.6368408203, -982.12689208984, 46.415843963623),
    vector3(-2968.0363769531, 390.44519042969, 15.043313980103),
    vector3(-3039.9201660156, 586.12683105469, 7.908860206604),
    vector3(-1829.1578369141, 791.89575195313, 138.2622833252),
    vector3(2556.7375488281, 382.60064697266, 108.6229019165),
    vector3(547.04364013672, 2670.4855957031, 42.156463623047),
    vector3(1166.1861572266, 2708.9350585938, 38.157699584961),
    vector3(2678.646484375, 3281.1418457031, 55.241062164307),
    vector3(1961.5063476563, 3741.7622070313, 32.343669891357),
    vector3(162.14131164551, 6640.669921875, 31.698871612549),
    vector3(1729.7496337891, 6414.9658203125, 35.037147521973),
}

function GetItemLabel(item)
    return items[item].label
end

function OpenMarkerMenu()
    if open then
        open = false
        RageUI.Visible(market_main, false)
        return
    else
        open = true
        RageUI.Visible(market_main, true)
        
        CreateThread(function ()
            while open do
                RageUI.IsVisible(market_main, function ()
                    for k,v in pairs(marketCfg) do  
                        RageUI.List(GetItemLabel(v.item), marketItem, v.index, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                            onListChange = function(Index, Item)
                                v.index = Index
                            end,
                            onSelected = function ()
                                TriggerSecurEvent("core:marketBuyItem", v.item, v.price, v.index)
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)
    end
end

-- CreateThread(function()
--     while zone == nil do Wait(1) end

--     for k,v in pairs(marketPos) do
--         zone.addZone(
--             "market"..math.random(0, 100),
--             v,
--             "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le frigo",
--             function ()
--                 OpenMarkerMenu()
--             end,
--             false
--         )
--     end
-- end)