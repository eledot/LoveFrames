--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- button clas
button = class("button", base)
button:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function button:initialize()

	self.type			= "button"
	self.text 			= "Button"
	self.width 			= 80
	self.height 		= 25
	self.internal		= false
	self.down			= false
	self.clickable		= true
	self.enabled		= true
	self.OnClick		= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function button:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	local hover = self.hover
	local down = self.down
	local hoverobject = loveframes.hoverobject
	
	if hover == false then
		self.down = false
	elseif hover == true then
		if hoverobject == self then
			self.down = true
		end
	end
	
	if down == false and hoverobject == self then
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
function button:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount
	
	if self.Draw ~= nil then
		self.Draw(self)
	else
		skin.DrawButton(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function button:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	
	if hover == true and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	
		self.down = true
		loveframes.hoverobject = self
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function button:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	
	if hover == true and down == true and button == "l" and clickable == true then
		if enabled == true then
			if self.OnClick then
				self.OnClick(self, x, y)
			end
		end
	end
	
	self.down = false

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function button:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function button:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object can be clicked or not
--]]---------------------------------------------------------
function button:SetClickable(bool)

	self.clickable = bool
	
end

--[[---------------------------------------------------------
	- func: GetClickable(bool)
	- desc: gets whether the object can be clicked or not
--]]---------------------------------------------------------
function button:GetClickable()

	return self.clickable
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object is enabled or not
--]]---------------------------------------------------------
function button:SetEnabled(bool)

	self.enabled = bool
	
end

--[[---------------------------------------------------------
	- func: GetEnabled()
	- desc: gets whether the object is enabled or not
--]]---------------------------------------------------------
function button:GetEnabled()

	return self.enabled
	
end