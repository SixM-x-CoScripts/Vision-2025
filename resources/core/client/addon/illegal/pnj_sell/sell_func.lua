seller = {}

seller.__index = seller

seller_npc = {
    items_shop = {
        {name = "serflex", label = "Serflex", price = 0},
        {name = "sactete", label = "Sac de tête", price = 0}, -- sorte de cagoule
        -- {name = "radiosat", label = "Radio Satellite", price = 0}, -- à revoir 
        -- {name = "trackgps", label = "Trackeur gps", price = 0},
        {name = "weapon_molotov", label = "Cocktail Molotov", price = 0}, -- regarder dans le fw pour l'item
    }
}

setmetatable(seller, {
    __call  = function(_, asset)
        local self = setmetatable({}, seller)
        self.menuIsOpen = false 
        self.wait = 750
        return (self)
    end
})

function seller:initMenu()
    self.main_seller_menu = self.UI.CreateMenu("Vendeur", "LISTE")

    self.main_seller_menu.Closed = function()
        self.menuIsOpen = false 
        self.wait = 750
        self.UI.CloseAll()
    end
end 

function seller:initThread(cb)
    CreateThread(function()
        while self.menuIsOpen do 
            cb()
            Wait(self.wait)
        end 
    end)
end 

function seller:requestAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict) 
        while not HasAnimDictLoaded(dict) do 
            Wait(1)
        end
    end
end 

function seller:openSeller()
    self.UI = RageUI  

    if self.menuIsOpen then 
       self.menuIsOpen = false 
       self.UI.CloseAll()
    else 
        if p:getCrew() == "5Nations" then 
            seller:initMenu()
            self.menuIsOpen = true 
            self.wait = 0
            self.UI.Visible(self.main_seller_menu, self.menuIsOpen)
            seller:initThread(function()
                self.UI.IsVisible(self.main_seller_menu, function()
                    self.UI.Separator("-- ~r~Vendeur illégale~s~ --")
                    for k,v in pairs(seller_npc.items_shop) do 
                       RageUI.Button(v.label, nil, {RightLabel = "~g~" .. v.price .. "$"}, true, {
                            onSelected = function()
                                TriggerSecurEvent("core:marketBuyItem", v.name, v.price, 1)
                            end
                       })
                    end 
                end)
            end)
        else 
           -- ShowNotification("~r~Vous n'avez pas l'autorisation~s~")

            -- New notif
            exports['vNotif']:createNotification({
                type = 'ROUGE',
                -- duration = 5, -- In seconds, default:  4
                content = "~s Vous n'avez pas l'autorisation"
            })

        end 
    end 
end 

function seller:sendNUI(args)
    SendNuiMessage(args)
end 


seller()