Bulle = {
    bulle = {},
    add = function (nomn, pos, bulles, actions_, texture)
        local newBulle = {
            pos = pos,
            bulle = bulles,
            actions = actions_,
            texture = texture
        }
        Bulle.bulle[nomn] = newBulle
    end,

    remove = function(nom)
        Bulle.bulle[nom] = nil
    end,

    hide = function(nom)
        if not Bulle.bulle[nom] then return end
        Bulle.bulle[nom].hide = true
    end,

    removeClosestOfType = function(coords, nom, dist)
        for k,v in pairs(Bulle.bulle) do 
            if v.texture == nom then 
                local vecBulle = vector3(v.pos.x, v.pos.y, v.pos.z)
                if #(vecBulle - coords) < dist then 
                    Bulle.bulle[k] = nil
                end
            end
        end
    end,

    show = function(nom)
        if not Bulle.bulle[nom] then return end
        Bulle.bulle[nom].hide = false
    end,

    changeTexture = function(nom, texture)
        Bulle.bulle[nom].texture = texture
    end,
    
    exists = function(nom)
        return Bulle.bulle[nom]
    end,

    create = function(id, coords, typeTexture, ignoreIcon, w,h, useFocus)
        Bulle.add(id, coords,
            function()
                RobertoBulle(id, coords, typeTexture or 'vendre', 0, 0, ignoreIcon,w,h,useFocus)
            end,
            function()
            end,
            typeTexture
        )
    end
}

local ignoreCar = false
local InsideFocus = false
Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    while true do
        if not Optimisation then
            local pNear = false

            for k, v in pairs(Bulle.bulle) do
                if not v.texture then v.texture = "" end
                local dst = GetDistanceBetweenCoords(p:pos(), v.pos, true)
                if dst <= 15.0 and IsLookingAtCoords(v.pos.x, v.pos.y, v.pos.z, 35) and AcceptInside(v.pos.x, v.pos.y, v.pos.z) and not InsideFocus then
                    if not ignoreCar or (ignoreCar and v.texture == "bulleGarage" or string.find(v.texture,"bulleRendre") or v.texture == "bulleDeposerColis" or v.texture == "bulleRangerGarage" or v.texture == "bulleDecrocher" or v.texture == "bulleCustom" or v.texture == "bulleGarerVert" or v.texture == "bulleFourriereRemorquer" or v.texture == "bulleCiterneRemplir") then 
                        pNear = true
                        if not v.hide then
                            v.bulle()
                        end
                        if (v.texture and (string.find(string.lower(v.texture),"travailler")) and dst <= 4.5 or dst <= 3.5) then 
                            if IsControlJustPressed(0, 38) then 
                                v.actions()
                            end
                        end
                    end
                end
            end

            if IsPedInAnyVehicle(p:ped()) then 
                if not ignoreCar then
                    ignoreCar = true
                end
            else
                if ignoreCar then
                    ignoreCar = false
                end
            end

            if pNear then
                Wait(5)
            else
                Wait(500)
            end
        else
            Wait(10000)
        end
    end
end)

-- local alpha1 = 255
-- local alpha2 = 0
local init = {}
local Alpha1 = {}
local Alpha2 = {}

RegisterNUICallback("focusIn", function()
    InsideFocus = true
end)
RegisterNUICallback("focusOut", function()
    InsideFocus = false
end)

local ToBetterShow = {
    ["bulleGarage"] = true,
    ["bulleRangerGarage"] = true,
    ["bulleCustom"] = true,
    ["bulleGarerVert"] = true,
    ["bulleCiterneRemplir"] = true
}

function RobertoBulle(name, pos, textName, alpha1, alpha2, ignoreIcon,nw,nh,useFocus)
    if not init[name] then
        init[name] = true
        Alpha1[name] = alpha1
        Alpha2[name] = alpha2
    end
    while p == nil do Wait(1) end
    if useFocus and InsideFocus then 
    else
        if #(p:pos() - pos) < 20 then
            if (ToBetterShow[textName] and #(p:pos() - pos) < 10 or #(p:pos() - pos) < 5) then
                if Alpha1[name] > 0 then
                    Alpha1[name] = Alpha1[name] - 6
                end
                if Alpha1[name] <= 100 then
                    if Alpha2[name] < 255 then
                        Alpha2[name] = Alpha2[name] + 6
                    end
                end
            else
                if Alpha2[name] <= 100 then
                    if Alpha1[name] < 255 then
                        Alpha1[name] = Alpha1[name] + 10
                    end
                end

                if Alpha2[name] > 0 then
                    Alpha2[name] = Alpha2[name] - 6
                end
            end
            if not ignoreIcon then
                local w, h = Modules.UI.ConvertToPixel(14, 15)
                Modules.UI.DrawSprite3dNoDownSize({pos = pos,textureDict = "interact",textureName ="icon",x = 0,y = 0,width = w,height = h,r = 255,g = 255,b = 255,a = Round(Alpha1[name])})
            end
            local w, h = Modules.UI.ConvertToPixel(120*2.9, 25*2.9)
            Modules.UI.DrawSprite3dNoDownSize({pos = pos,textureDict = "interact",textureName = textName,x = 0,y = 0,width = nw or w,height = nh or h,r = 255,g = 255,b = 255,a = Round(Alpha2[name])})
        end
    end
end

function IsLookingAtCoords(x, y, z, tolerance)
    local camCoords = GetGameplayCamCoord()
    local direction = GetGameplayCamRot(2)
    local camForward = {
        x = -math.sin(math.rad(direction.z)) * math.abs(math.cos(math.rad(direction.x))),
        y = math.cos(math.rad(direction.z)) * math.abs(math.cos(math.rad(direction.x))),
        z = math.sin(math.rad(direction.x))
    }
    
    local targetVector = vector3(x - camCoords.x, y - camCoords.y, z - camCoords.z)
    local dotProduct = camForward.x * targetVector.x + camForward.y * targetVector.y + camForward.z * targetVector.z
    local targetMagnitude = math.sqrt(targetVector.x * targetVector.x + targetVector.y * targetVector.y + targetVector.z * targetVector.z)
    local camMagnitude = math.sqrt(camForward.x * camForward.x + camForward.y * camForward.y + camForward.z * camForward.z)
    
    local angle = math.acos(dotProduct / (targetMagnitude * camMagnitude)) * (180 / math.pi)
    
    if angle < tolerance then
        return true
    else
        return false
    end
end

function AcceptInside(x, y, z)
    --local playerInt = GetInteriorFromEntity(PlayerPedId())
    --local coordsInt = GetInteriorAtCoords(x, y, z)
    --if playerInt == 0 and coordsInt == 0 then 
    --    return true 
    --else
    --    if playerInt == coordsInt then 
    --        return true
    --    end
    --end
    return true
end