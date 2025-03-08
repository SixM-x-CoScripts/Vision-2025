local token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    token = t
end)


local open = false
--local main = RageUI.CreateMenu("", "Action disponible", 0.0, 0.0, "vision", "Banner_Chasse")
--main.Closed = function()
--    open = false
--    RageUI.Visible(main, false)
--end

local meatCfg = {
    {
        item = "viandelapin",
        price = 12,
        index = 1,
    },
    {
        item = "viandepuma",
        price = 38,
        index = 1,
    },
    {
        item = "viandesanglier",
        price = 32,
        index = 1,
    },
    {
        item = "coyote",
        price = 16,
        index = 1,
    },
    {
        item = "viandebiche",
        price = 16,
        index = 1,
    },
    {
        item = "viandeoiseau",
        price = 10,
        index = 1,
    },
}


if GetVariable("jobcenter") then
    local chasse = GetVariable("jobcenter").chasse
    if chasse and chasse.prices and tonumber(chasse.prices.lapin) and tonumber(chasse.prices.puma) and tonumber(chasse.prices.sanglier) and tonumber(chasse.prices.coyote) and tonumber(chasse.prices.biche) and tonumber(chasse.prices.oiseau) then
        meatCfg[1].price = tonumber(chasse.prices.lapin)
        meatCfg[2].price = tonumber(chasse.prices.puma)
        meatCfg[3].price = tonumber(chasse.prices.sanglier)
        meatCfg[4].price = tonumber(chasse.prices.coyote)
        meatCfg[5].price = tonumber(chasse.prices.biche)
        meatCfg[6].price = tonumber(chasse.prices.oiseau)
    end
end

local meatItem = {}
for i = 1, 10 do
    table.insert(meatItem, i)
end


function GetItemLabel(item)
    return items[item].label
end

local VUI = exports["VUI"]
local main2 = VUI:CreateMenu("Chasse", "Banner_Chasse", true)
main2.OnClose(function()
    open = false
end)

function OpenChasseMarket()
    if open then
        --RageUI.Visible(main, false)
    else
        open = true
        --RageUI.Visible(main, true)

        for k, v in pairs(meatCfg) do
            main2.Button(
                GetItemLabel(v.item),
                "",
                v.price*10 .. "$",
                nil,
                false,
                function()
                    TriggerServerEvent("core:sellHunt", token, v.item, v.price*10, 1)
                end
            )
        end
        main2.open()

        --[[CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k, v in pairs(meatCfg) do
                        RageUI.List(GetItemLabel(v.item), meatItem, v.index, nil, { RightLabel = "~g~" .. v.price .. "$" }
                            , true, {
                            onListChange = function(Index, Item)
                                v.index = Index
                            end,
                            onSelected = function()
                                TriggerServerEvent("core:sellHunt", token, v.item, v.price, v.index)
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)]]
    end
end

Citizen.CreateThread(function()
    local ped = entity:CreatePedLocal("s_m_m_linecook", vector3(-1490.5402832031, 4981.5537109375, 62.347873687744),
    82.629386901855)
    SetEntityInvincible(ped.id, true)
    ped:setFreeze(true)
    TaskStartScenarioInPlace(ped.id, "WORLD_HUMAN_CLIPBOARD", -1, true)
    SetEntityAsMissionEntity(ped.id, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped.id, true)
end)

CreateThread(function()
    while zone == nil do
        Wait(1000)
    end
    zone.addZone("chasse", -- Nom
        vector3(-1490.5402832031, 4981.5537109375, 64.347873687744), -- Position
        "Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le marché de chasse", -- Text afficher
        function() -- Action qui seras fait
            OpenChasseMarket()
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
end)
