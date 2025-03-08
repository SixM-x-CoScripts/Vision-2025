RubyUI = {
    -- baseX = 0.03, -- gauche / droite ( plus grand = droite )
    -- baseY = 0.2, -- Hauteur ( Plus petit = plus haut )
    -- baseWidth = 0.15, -- Longueur
    -- baseHeight = 0.03, -- Epaisseur
    -- baseRgb = {66, 182, 245},
    -- baseAlpha = 230,
    -- baseAlphaButtons = 170,
    -- baseTitle = "",
    -- baseClickControls = {24, 176},
    -- baseMaxDisplay = 10,
    -- baseStartDisplay = 1,

    -- selectedFunction = 1,
    -- cachedSelectedFuntion = 1,

    -- cachedY = 0,
    -- functions = {},
    -- inClickCooldown = false
}
local baseFunction = function() end

---@return RubyUI
function RubyUI:CreateMenu(title, x, y)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.baseX = 0.03
    obj.baseY = 0.2


    if x ~= nil then
        obj.baseX = x
    end

    if y ~= nil then
        obj.baseY = y
    end

    obj.baseWidth = 0.15 -- Longueur
    obj.baseHeight = 0.03 -- Epaisseur
    obj.baseRgb = {66, 182, 245}
    obj.baseAlpha = 230
    obj.baseAlphaButtons = 170
    obj.baseTitle = title
    obj.baseClickControls = {24, 176}
    obj.baseCloseControls = {24, 177, 32}
    obj.baseMaxDisplay = 10
    obj.baseStartDisplay = 1
    obj.selectedFunction = 1
    obj.selectedFunctionInTotal = 1
    obj.cachedSelectedFuntion = 1
    obj.cachedY = 0
    obj.functions = {}
    obj.inClickCooldown = false
    obj.cachedX = 0
    obj.cachedY = 0
    obj.keyboardControl = false
    obj.isMouseOnAnyMenu = false


    return obj
end

function RubyUI:SetMouseOnMenu(status)
    self.isMouseOnAnyMenu = status
end

function RubyUI:GetMouseOnMenu()
    return self.isMouseOnAnyMenu
end

function RubyUI:SetTitle(title)
    self.baseTitle = title
end

function RubyUI:ResetFunctions()
    self.functions = {}
end

function RubyUI:AddButton(text, actions)
    local functionAction = {}
    functionAction.label = text


    if actions.onClick == nil then
        functionAction.onClick = false
    else
        functionAction.onClick = actions.onClick
    end


    if actions.onActive == nil then
        functionAction.onActive = false
    else
        functionAction.onActive = actions.onActive
    end

    table.insert(self.functions, functionAction)
end

function RubyUI:AddButtonToSubMenu(text, menu)
    table.insert(self.functions, {label = text, subMenu = menu})
end

function RubyUI:SetMousePosition()
    SetCursorLocation(self.baseX, self.baseY)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
end