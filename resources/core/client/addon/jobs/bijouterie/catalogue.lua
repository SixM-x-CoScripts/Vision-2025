-- RegisterCommand('anim', function()
--     TriggerEvent("skinchanger:getSkin", function(cb)
--         print(json.encode(cb))
--     end)
--     -- openApp = false
--     -- TriggerServerEvent("core:SetPlayerActiveSkin", token, skin)
-- end)

local function WatchesAnim()
    local cam = Cam.create("watches")
    local rot = GetEntityRotation(PlayerPedId())
    Cam.setPos("watches", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.2, 1.2, 0.5))
    Cam.lookAtCoords("watches", vector3(p:pos().x, p:pos().y, p:pos().z + 0.5))
    Cam.render("watches", true, false, 1)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)

    RequestAnimDict("anim@random@shop_clothes@watches")
    while not HasAnimDictLoaded("anim@random@shop_clothes@watches") do Wait(1) end
    Citizen.CreateThread(function()
        TaskPlayAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "intro", 8.0, -8.0, -1, 0, 0, 0, 0, 0)
        Wait(GetAnimDuration("anim@random@shop_clothes@watches", "intro") * 1000)
        while IsEntityPlayingAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "intro") do Wait(1) end
        TaskPlayAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "idle_d", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
    end)


    -- TaskPlayAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "idle_d", 8.0, -8.0, -1, 1, 0, false, false, false)

end

local function BraceletWatchesAnim()
    local cam = Cam.create("bracelet")
    local rot = GetEntityRotation(PlayerPedId())
    Cam.setPos("bracelet", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.2, 1.2, 0.5))
    Cam.lookAtCoords("bracelet", vector3(p:pos().x, p:pos().y, p:pos().z + 0.5))
    Cam.render("bracelet", true, false, 1)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
    RequestAnimDict("anim@random@shop_clothes@watches")
    while not HasAnimDictLoaded("anim@random@shop_clothes@watches") do Wait(1) end
    Citizen.CreateThread(function()
        TaskPlayAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "intro", 8.0, -8.0, -1, 0, 0, 0, 0, 0)
        Wait(GetAnimDuration("anim@random@shop_clothes@watches", "intro") * 1000)
        while IsEntityPlayingAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "intro") do Wait(1) end
        TaskPlayAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "idle_d", 8.0, -8.0, -1, 1, 0, 0, 0, 0)
    end)
end

local function BraceletWatchesGlasses()
    -- local cam = Cam.create("bracelet")
    -- local rot = GetEntityRotation(PlayerPedId())
    -- Cam.setPos("bracelet", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.2, 1.2, 0.5))
    -- Cam.lookAtCoords("bracelet", vector3(p:pos().x, p:pos().y, p:pos().z + 0.5))
    -- Cam.render("bracelet", true, false, 1)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
    RequestAnimDict("mp_character_creation@customise@male_a")
    while not HasAnimDictLoaded("mp_character_creation@customise@male_a") do Wait(1) end
    Citizen.CreateThread(function()
        TaskPlayAnim(PlayerPedId(), "mp_character_creation@customise@male_a", "clothes_a", 8.0, -8.0, -1, 0, 0, 0, 0,
            0)
    end)
end

local open = false
local main = RageUI.CreateMenu("", "Catalogue", 0.0, 0.0, "vision", "menu_title_binco")
local watches = RageUI.CreateSubMenu(main, "", "Catalogue", 0.0, 0.0, "vision", "menu_title_binco")
main:DisplayGlare(false)
watches:DisplayGlare(false)
local cached      = {}
local directTable = {}
local index       = {}
local ClothsData  = {}
local oldSkin     = {}
local dataName    = ''
local dataName2   = ''
local function RefreshData(oldSkin)
    TriggerEvent("skinchanger:getData", function(comp, max)
        local comp = comp
        local max = max
        for k, v in pairs(comp) do


            if v.componentId == 0 then
                comp[k].value = GetPedPropIndex(PlayerPedId(), v.componentId)
            end
            if oldSkin then
                index[v.name] = comp[k].value
            end

            for i, m in pairs(max) do
                if i == v.name then
                    comp[k].max = m
                    comp[k].table = {}
                    comp[k].index = {}
                    for i = 0, m do
                        table.insert(comp[k].table, i)
                        table.insert(comp[k].index, 1)
                    end
                end
            end

            if v.max == nil then
                comp[k].max = 1
            end

            directTable[v.name] = comp[k]


        end

        ClothsData = comp
        return true
    end)
end

local data = {}
local dataLabel = ""
main.Closed = function()
    open = false
    p:setSkin(oldSkin)
    ClearFocus()
end
watches.Closed = function()
    Cam.delete("watches")
    Cam.delete("bracelet")
    TaskPlayAnim(PlayerPedId(), "anim@random@shop_clothes@watches", "outro", 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    ClearFocus()
end
function OpenCatalogueBijouterie()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        RefreshData(true)
        oldSkin = p:skin()
        RefreshData(true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("Montre", false, {}, true, {
                        onSelected = function()
                            data = {}
                            data.data = {}
                            RefreshData(true)
                            data = directTable["watches_1"]
                            data.data = directTable["watches_2"]
                            dataName = 'watches_1'
                            dataName2 = 'watches_2'
                            dataLabel = "Montre"
                            WatchesAnim()
                        end
                    }, watches)
                    RageUI.Button("Bracelet", false, {}, true, {
                        onSelected = function()
                            data = {}
                            data.data = {}
                            RefreshData(true)
                            data = directTable["bracelets_1"]
                            data.data = directTable["bracelets_2"]
                            dataName = 'bracelets_1'
                            dataName2 = 'bracelets_2'
                            dataLabel = "Bracelet"
                            BraceletWatchesAnim()
                        end
                    }, watches)

                end)
                RageUI.IsVisible(watches, function()
                    for i = 1, data.max do
                        RageUI.List(dataLabel .. " n°" .. i, data.data.table, data.index[i], false,
                            { RightLabel = "~g~50$" }, true, {
                                onListChange = function(Index)
                                    data.data.value = Index
                                    data.index[i] = Index
                                    p:setCloth(dataName2, data.data.value)
                                    -- p:setSkin(data.data.value)
                                end,
                                onActive = function(Index)
                                    data.value = Index
                                    p:setCloth(dataName, i)
                                end
                            }, nil)
                    end
                end)
                Wait(1)
            end
        end)
    end
end
