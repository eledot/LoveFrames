--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- multichoicerow class
multichoicerow = class("multichoicerow", base)
multichoicerow:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function multichoicerow:initialize()
	
	self.type			= "multichoice-row"
	self.text			= ""
	self.width 			= 50
	self.height 		= 25
	self.hover			= false
	self.internal		= true
	self.down			= false
	self.canclick		= false
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function multichoicerow:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	if self.hover == false then
		self.down = false
	elseif self.hover == true then
		if loveframes.hoverobject == self then
			self.down = true
		end
	end
	
	if self.down == false and loveframes.hoverobject == self then
		self.hover = true
	end
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function multichoicerow:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount

	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
		
	if self.Draw ~= nil then
		self.Draw(self)
	else
		skin.DrawMultiChoiceRow(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function multichoicerow:mousepressed(x, y, button)
	
	if self.visible == false then
		return
	end
	
	if self.hover == true and button == "l" then
	
		self.down = true
		loveframes.hoverobject = self
		
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function multichoicerow:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	if self.hover == true and self.down == true and self.canclick == true and button == "l" then
		self.parent.list:SelectChoice(self.text)
	end
	
	self.down = false
	self.canclick = true

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function multichoicerow:SetText(text)

	self.text = text
	
end