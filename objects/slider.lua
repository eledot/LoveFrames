--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- text clas
slider = class("slider", base)
slider:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function slider:initialize()

	self.type			= "slider"
	self.text 			= "Slider"
	self.slidetype		= "horizontal"
	self.width			= 5
	self.height			= 5
	self.max			= 10
	self.min			= 0
	self.value			= 0
	self.decimals		= 5
	self.internal		= false
	self.internals		= {}
	self.OnValueChanged	= nil
	
	-- create the slider button
	table.insert(self.internals, sliderbutton:new(self))
	
	-- set initial value to minimum
	self:SetValue(self.min)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function slider:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local internals = self.internals
	local sliderbutton = internals[1]
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if sliderbutton then
		if self.slidetype == "horizontal" then
			self.height = sliderbutton.height
		elseif self.slidetype == "vertical" then
			self.width = sliderbutton.width
		end
	end
	
	-- update internals
	for k, v in ipairs(self.internals) do
		v:update(dt)
	end
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function slider:draw()

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local internals = self.internals
	
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
		skin.DrawSlider(self)
	end
	
	-- draw internals
	for k, v in ipairs(internals) do
		v:draw()
	end

end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function slider:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	if self.hover == true and button == "l" then
		
		if self.slidetype == "horizontal" then
		
			local xpos = x - self.x
			local button = self.internals[1]
			local baseparent = self:GetBaseParent()
		
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
			
			button:MoveToX(xpos)
			button.down = true
			button.dragging = true
			button.startx = button.staticx
			button.clickx = x
			
		elseif self.slidetype == "vertical" then
		
			local ypos = y - self.y
			local button = self.internals[1]
			local baseparent = self:GetBaseParent()
		
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
			
			button:MoveToY(ypos)
			button.down = true
			button.dragging = true
			button.starty = button.staticy
			button.clicky = y
			
		end
			
	end
			
	
	for k, v in ipairs(self.internals) do
		v:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: SetValue(value)
	- desc: sets the object's value
--]]---------------------------------------------------------
function slider:SetValue(value)

	if value > self.max then
		return
	end
	
	if value < self.min then
		return
	end
	
	local decimals = self.decimals
	local newval = loveframes.util.Round(value, decimals)
	local internals = self.internals
	
	-- set the new value
	self.value = newval
	
	-- slider button object
	local sliderbutton = internals[1]
	
	-- move the slider button to the new position
	if self.slidetype == "horizontal" then
		local xpos = self.width * (( newval - self.min ) / (self.max - self.min))
		sliderbutton:MoveToX(xpos)
	elseif self.slidetype == "vertical" then
		local ypos = self.height - self.height * (( newval - self.min ) / (self.max - self.min))
		sliderbutton:MoveToY(ypos)
	end
	
	-- call OnValueChanged
	if self.OnValueChanged then
		self.OnValueChanged(self)
	end
	
end

--[[---------------------------------------------------------
	- func: GetValue()
	- desc: gets the object's value
--]]---------------------------------------------------------
function slider:GetValue()

	return self.value
	
end

--[[---------------------------------------------------------
	- func: SetMax(max)
	- desc: sets the object's maximum value
--]]---------------------------------------------------------
function slider:SetMax(max)

	self.max = max
	
end

--[[---------------------------------------------------------
	- func: GetMax()
	- desc: gets the object's maximum value
--]]---------------------------------------------------------
function slider:GetMax()

	return self.max
	
end

--[[---------------------------------------------------------
	- func: SetMin(min)
	- desc: sets the object's minimum value
--]]---------------------------------------------------------
function slider:SetMin(min)

	self.min = min
	
end

--[[---------------------------------------------------------
	- func: GetMin()
	- desc: gets the object's minimum value
--]]---------------------------------------------------------
function slider:GetMin()

	return self.min
	
end

--[[---------------------------------------------------------
	- func: SetMinMax()
	- desc: sets the object's minimum and maximum values
--]]---------------------------------------------------------
function slider:SetMinMax(min, max)

	self.min = min
	self.max = max
	
end

--[[---------------------------------------------------------
	- func: GetMinMax()
	- desc: gets the object's minimum and maximum values
--]]---------------------------------------------------------
function slider:GetMinMax()

	return self.min, self.max
	
end

--[[---------------------------------------------------------
	- func: SetText(name)
	- desc: sets the objects's text
--]]---------------------------------------------------------
function slider:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the objects's text
--]]---------------------------------------------------------
function slider:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetDecimals(decimals)
	- desc: sets the objects's decimals
--]]---------------------------------------------------------
function slider:SetDecimals(decimals)

	self.decimals = decimals
	
end

--[[---------------------------------------------------------
	- func: SetButtonSize(width, height)
	- desc: sets the objects's button size
--]]---------------------------------------------------------
function slider:SetButtonSize(width, height)
	
	local internals = self.internals
	local sliderbutton = self.internals[1]
	
	if sliderbutton then
		sliderbutton.width = width
		sliderbutton.height = height
	end
	
end

--[[---------------------------------------------------------
	- func: GetButtonSize()
	- desc: gets the objects's button size
--]]---------------------------------------------------------
function slider:GetButtonSize()

	local internals = self.internals
	local sliderbutton = self.internals[1]
	
	if sliderbutton then
		return sliderbutton.width, sliderbutton.height
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: SetSlideType(slidetype)
	- desc: sets the objects's slide type
--]]---------------------------------------------------------
function slider:SetSlideType(slidetype)

	self.slidetype = slidetype
	
	if slidetype == "vertical" then
		self:SetValue(self.min)
	end
	
end