local token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)

function LoadBioMarket()
    local ped = nil 
    local created = false
    if not created then
        ped = entity:CreatePedLocal("mp_m_shopkeep_01", vector3(-1253.0905761719, -1444.9006347656, 3.3738865852356),
            37.60525894165)
        created = true
    end
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)

    zone.addZone("bio_market",
        vector3(-1253.4201660156, -1443.9505615234, 4.4114685058594),
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le marché bio",
        function()
            openBioMarketMenu()
        end,
        false, -- Avoir un marker ou non
        -1, -- Id / type du marker
        0.6, -- La taille
        { 0, 0, 0 }, -- RGB
        0, -- Alpha
        2.5,
        true,
        "bulleMarche"
    )
end

local open = false
local bio_market_main = RageUI.CreateMenu("", "Produits")
local bio_market_sub = RageUI.CreateSubMenu(bio_market_main, "", "Produits", 0.0, 0.0, "vision", "Banner_TruthOrganic")
bio_market_main.Closed = function()
    open = false
end


local VUI = exports["VUI"]
local main2 = VUI:CreateMenu("Produits", "Banner_TruthOrganic", true)
main2.OnClose(function()
    open = false
end)


local biocfg = {
    {
        item = "litchi",
        price = 3,
        index = 1,
    },
    {
        item = "soja",
        price = 2,
        index = 1,
    },
    {
        item = "avocado",
        price = 4,
        index = 1,
    },
    {
        item = "algue",
        price = 3,
        index = 1,
    },
    {
        item = "sesam",
        price = 3,
        index = 1,
    },
    {
        item = "mint",
        price = 3,
        index = 1,
    },
    {
        item = "lemon",
        price = 2,
        index = 1,
    }
}

local bioItem = {}
for i = 1, 10 do
    table.insert(bioItem, i)
end


function GetItemLabel(item)
    return items[item].label
end

local labsTypeList = 1

function openBioMarketMenu()
    if open then
        open = false
        --RageUI.Visible(bio_market_main, false)
        return
    else
        open = true
        for k,v in pairs(biocfg) do  
            main2.List(
                GetItemLabel(v.item),
                v.price .. "$ Unité",
                false,
                bioItem,
                labsTypeList,
                function(index, item)
                    TriggerSecurEvent("core:marketBuyItem", v.item, v.price, index)
                end
            )
        end
        main2.open()
        --RageUI.Visible(bio_market_main, true)
        --CreateThread(function ()
        --    while open do
        --        RageUI.IsVisible(bio_market_main, function ()
        --            for k,v in pairs(biocfg) do  
        --                RageUI.List(GetItemLabel(v.item), bioItem, v.index, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
        --                    onListChange = function(Index, Item)
        --                        v.index = Index
        --                    end,
        --                    onSelected = function ()
        --                        TriggerSecurEvent("core:marketBuyItem", v.item, v.price, v.index)
        --                    end
        --                })
        --            end
        --        end)
        --        Wait(1)
        --    end
        --end)
    end
end


Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    Wait(1000)
    LoadBioMarket()
    print("[INFO] Le magasin bio a été chargé correctement")
end)