local mouseOnAnySubMenu = false
local function DrawRectangle(position, size, color)
	local pos = (position + size / 2.0)
	DrawRect(pos[1], pos[2], size[1], size[2], color[1], color[2], color[3], color[4])
end

function RubyUI:isMouseOnButton(position, buttonPos)
	return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + self.baseWidth and position.y < buttonPos.y + self.baseHeight
end

function RubyUI:HandleCooldown()
    self.inClickCooldown = true
    Citizen.CreateThread(function()
        Wait(150)
        self.inClickCooldown = false
    end)
end

function RubyUI:HandleControl(actions)
    if actions.onClick ~= false then
        for _,v in pairs(self.baseClickControls) do
            if IsControlJustReleased(0, v) and not self.inClickCooldown then
                self:HandleCooldown()
                actions.onClick()
                RubyUI:PlaySound("click")
                break
            end
        end
    end

    if actions.onActive ~= false then
        actions.onActive()
    end
end

function RubyUI:HandleCloseMenuControl()
    for _,v in pairs(self.baseCloseControls) do
        if IsControlJustReleased(0, v) and not self.inClickCooldown then
            return true
        end
    end
    return false
end

function RubyUI:HandleDisplayControl()
    DisableControlAction(0, 16, true)
    DisableControlAction(0, 17, true)

    if IsDisabledControlJustReleased(0, 16) then -- Down
        local oldIndex = self.baseStartDisplay

        self.baseStartDisplay = self.baseStartDisplay + 1

        if self.functions[self.baseStartDisplay + 9] == nil then
            self.baseStartDisplay = oldIndex
        end
    end

    if IsDisabledControlJustReleased(0, 17) then -- up
        self.baseStartDisplay = self.baseStartDisplay - 1

        if self.baseStartDisplay <= 0 then
            self.baseStartDisplay = 1
        end
    end
end

function RubyUI:RenderSubMenu(mouseX, mouseY, actualX, actualY, ref)

    local renderX = actualX + 0.15
    local renderY = actualY - 0.030

    local mouseOnMenu = false
    mouseOnAnySubMenu = false
    self.isMouseOnAnyMenu = false


    if ref.baseMaxDisplay > #ref.functions then
        ref.baseMaxDisplay = #ref.functions
    end

    if ref.baseStartDisplay > ref.baseMaxDisplay then
        ref.baseStartDisplay = 0
    end

    

    ref.baseMaxDisplay = ref.baseStartDisplay + 9
    if ref.baseMaxDisplay > #ref.functions then
        ref.baseMaxDisplay = #ref.functions
    end

    local k = 1
    for i = ref.baseStartDisplay, ref.baseMaxDisplay do
        local v = ref.functions[i]
        if v ~= nil then
            if i >= ref.baseStartDisplay and i <= ref.baseMaxDisplay then
                if ref:isMouseOnButton({x = mouseX, y = mouseY}, {x = renderX, y = renderY + (0.031 * k)}) then
                    mouseOnMenu = true
                    mouseOnAnySubMenu = true
                    self.isMouseOnAnyMenu = true
                    if ref.selectedFunction ~= k then
                        ref.selectedFunction = k
                        RubyUI:PlaySound("nav")
                    end
                    ref.cachedY = renderY + 0.030 * k

                    DrawRectangle(vector2(renderX, renderY + (0.030 * k)), vector2(ref.baseWidth, ref.baseHeight), {145, 145, 145, 170})
                    DrawRectangle(vector2(renderX - 0.001, renderY + (0.030 * k)), vector2(0.001, ref.baseHeight), {ref.baseRgb[1], ref.baseRgb[2], ref.baseRgb[3], 255})

                    if v.subMenu ~= nil then
                        ref:RenderSubMenu(mouseX, mouseY, renderX, renderY + (0.030 * k), v.subMenu)
                    else
                        ref:HandleControl(v)
                    end


                else
		        	DrawRectangle(vector2(renderX, renderY + (0.030 * k)), vector2(ref.baseWidth, ref.baseHeight), {0, 0, 0, 140})
                end
                DrawTexts(renderX + 0.01, (renderY + 0.002) + (0.030 * k), v.label, false, 0.35, {255, 255, 255, 255}, 6, 0) -- level
                if v.subMenu ~= nil then
                    DrawTexts(renderX + 0.13, (renderY + 0.002) + (0.030 * k), ">", false, 0.35, {255, 255, 255, 255}, 4, 0) -- level
                end
                k = k + 1
            end
        end
    end

    if #ref.functions > 10 and mouseOnMenu then
        DrawRectangle(vector2(renderX - 0.001, renderY + (0.031 * k)), vector2(0.001, ref.baseHeight + 0.005), {ref.baseRgb[1], ref.baseRgb[2], ref.baseRgb[3], 255})
        DrawRectangle(vector2(renderX + 0.150, renderY + (0.031 * k)), vector2(0.001, ref.baseHeight + 0.005), {ref.baseRgb[1], ref.baseRgb[2], ref.baseRgb[3], 255})
        DrawRectangle(vector2(renderX, renderY + (0.031 * k)), vector2(ref.baseWidth, ref.baseHeight + 0.005), {0, 0, 0, 140})

        if not HasStreamedTextureDictLoaded("commonmenu") then
            RequestStreamedTextureDict("commonmenu", 1)
        end
        DrawSprite("commonmenu", "shop_arrows_upanddown", renderX + 0.0735, (renderY + 0.017) + (0.031 * k), 0.027, 0.04, 0.0, 255, 255, 255, 255)
    end


    if mouseOnMenu then
        if #ref.functions > 10 then
            ref:HandleDisplayControl()
        end
    end

    if not mouseOnMenu then
        if ref.functions[ref.selectedFunction] ~= nil and ref.functions[ref.selectedFunction].subMenu ~= nil then
            ref:RenderSubMenu(mouseX, mouseY, renderX, ref.cachedY, ref.functions[ref.selectedFunction].subMenu)
        end
    end
end

function RubyUI:Render()
	DrawRectangle(vector2(self.baseX, self.baseY - 0.005), vector2(self.baseWidth, self.baseHeight - 0.025), {self.baseRgb[1], self.baseRgb[2], self.baseRgb[3], 255})
	DrawRectangle(vector2(self.baseX, self.baseY), vector2(self.baseWidth, self.baseHeight), {0, 0, 0, self.baseAlpha})

	DrawTexts(self.baseX + 0.005, self.baseY + 0.003, self.baseTitle, false, 0.35, {255, 255, 255, 255}, 2, 0) -- title
    DrawTexts(self.baseX + 0.11, self.baseY + 0.003, self.selectedFunctionInTotal.."/"..#self.functions, false, 0.35, {255, 255, 255, 255}, 4, 0) -- pageCount

	local posX = GetControlNormal(0, 239)
	local posY = GetControlNormal(0, 240)
    DisableControlAction(0, 1, true) -- LookLeftRight
    DisableControlAction(0, 2, true) -- LookUpDown
    DisableControlAction(0, 142, true) -- MeleeAttackAlternate
    DisableControlAction(0, 18, true) -- Enter
    DisableControlAction(0, 322, true) -- ESC
    DisableControlAction(0, 106, true) -- VehicleMouseControlOverride

    local mouseOnMenu = false
    self.isMouseOnAnyMenu = false

    if self.baseMaxDisplay > #self.functions then
        self.baseMaxDisplay = #self.functions
    end

    if self.baseStartDisplay > self.baseMaxDisplay then
        self.baseStartDisplay = 0
    end

    self.baseMaxDisplay = self.baseStartDisplay + 9
    if self.baseMaxDisplay > #self.functions then
        self.baseMaxDisplay = #self.functions
    end

    local k = 1
    for i = self.baseStartDisplay, self.baseMaxDisplay do
        local v = self.functions[i]
        if i >= self.baseStartDisplay and i <= self.baseMaxDisplay then
            if self:isMouseOnButton({x = posX, y = posY}, {x = self.baseX, y = self.baseY + (0.031 * k)}) then
                mouseOnMenu = true
                self.isMouseOnAnyMenu = true
                if self.selectedFunction ~= k then
                    self.selectedFunction = k
                    self.selectedFunctionInTotal = i
                    RubyUI:PlaySound("nav")
                end

                self.cachedY = self.baseY + 0.030 * k

                DrawRectangle(vector2(self.baseX, self.baseY + (0.030 * k)), vector2(self.baseWidth, self.baseHeight), {145, 145, 145, 170})
                DrawRectangle(vector2(self.baseX - 0.001, self.baseY + (0.030 * k)), vector2(0.001, self.baseHeight), {self.baseRgb[1], self.baseRgb[2], self.baseRgb[3], 255})

                if v.subMenu ~= nil then
                    self:RenderSubMenu(posX, posY, self.baseX, self.baseY + 0.030 * k, v.subMenu)
                else
                    self:HandleControl(v)
                end


            else
                if self.selectedFunction == k then
                    DrawRectangle(vector2(self.baseX, self.baseY + (0.030 * k)), vector2(self.baseWidth, self.baseHeight), {145, 145, 145, 170})
                else
                    DrawRectangle(vector2(self.baseX, self.baseY + (0.030 * k)), vector2(self.baseWidth, self.baseHeight), {0, 0, 0, 140})
                end
            end
            DrawTexts(self.baseX + 0.01, (self.baseY + 0.002) + (0.030 * k), v.label, false, 0.35, {255, 255, 255, 255}, 6, 0) -- level
            if v.subMenu ~= nil then
                DrawTexts(self.baseX + 0.13, (self.baseY + 0.002) + (0.030 * k), ">", false, 0.35, {255, 255, 255, 255}, 4, 0) -- level
            end
            k = k + 1
        end
    end

    if #self.functions > 10 and mouseOnMenu then
        DrawRectangle(vector2(self.baseX - 0.001, self.baseY + (0.031 * k)), vector2(0.001, self.baseHeight + 0.005), {self.baseRgb[1], self.baseRgb[2], self.baseRgb[3], 255})
        DrawRectangle(vector2(self.baseX + 0.150, self.baseY + (0.031 * k)), vector2(0.001, self.baseHeight + 0.005), {self.baseRgb[1], self.baseRgb[2], self.baseRgb[3], 255})
        DrawRectangle(vector2(self.baseX, self.baseY + (0.031 * k)), vector2(self.baseWidth, self.baseHeight + 0.005), {0, 0, 0, 140})

        if not HasStreamedTextureDictLoaded("commonmenu") then
            RequestStreamedTextureDict("commonmenu", 1)
        end
        DrawSprite("commonmenu", "shop_arrows_upanddown", self.baseX + 0.0735, (self.baseY + 0.017) + (0.031 * k), 0.027, 0.04, 0.0, 255, 255, 255, 255)
    end


    if mouseOnMenu then
        if #self.functions > 10 then
            self:HandleDisplayControl()
        end
    else
        if self:HandleCloseMenuControl() and not mouseOnAnySubMenu then
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            --Npc.StopNpcDialogue()
            return true
        end
    end



    if not mouseOnMenu then
        if self.functions[self.selectedFunction].subMenu ~= nil then
            self:RenderSubMenu(posX, posY, self.baseX, self.cachedY, self.functions[self.selectedFunction].subMenu)
        end
    end
end