--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- closebutton clas
sliderbutton = class("sliderbutton", base)
sliderbutton:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function sliderbutton:initialize(parent)

	self.type			= "sliderbutton"
	self.width 			= 10
	self.height 		= 20
	self.staticx		= 0
	self.staticy		= 0
	self.startx			= 0
	self.clickx			= 0
	self.starty			= 0
	self.clicky			= 0
	self.intervals		= true
	self.internal		= true
	self.down			= false
	self.dragging		= false
	self.parent			= parent
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function sliderbutton:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	local x, y = love.mouse.getPosition()
	local intervals = self.intervals
	local progress = 0
	local nvalue = 0
	local pvalue = 0
	local hover = self.hover
	local down = self.down
	local hoverobject = loveframes.hoverobject
	local parent = self.parent
	local slidetype = parent.slidetype
	local dragging = self.dragging
	
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
	
	if slidetype == "horizontal" then
		
		if dragging == true then
			self.staticx = self.startx + (x - self.clickx)
		end
			
		if (self.staticx + self.width) > self.parent.width then
			self.staticx = self.parent.width - self.width
		end
			
		if self.staticx < 0 then
			self.staticx = 0
		end
	
		progress = loveframes.util.Round(self.staticx/(self.parent.width - self.width), 5)
		nvalue = self.parent.min + (self.parent.max - self.parent.min) * progress
		pvalue = self.parent.value
	
	elseif slidetype == "vertical" then
		
		if dragging == true then
			self.staticy = self.starty + (y - self.clicky)
		end
			
		if (self.staticy + self.height) > self.parent.height then
			self.staticy = self.parent.height - self.height
		end
			
		if self.staticy < 0 then
			self.staticy = 0
		end
		
		local space = self.parent.height - self.height
		local remaining = (self.parent.height - self.height) - self.staticy
		local percent =  loveframes.util.Round(remaining/space, 5)
		
		nvalue = self.parent.min + (self.parent.max - self.parent.min) * percent
		pvalue = self.parent.value
		
	end
	
	if nvalue ~= pvalue then
		self.parent.value = loveframes.util.Round(nvalue, self.parent.decimals)
		if self.parent.OnValueChanged then
			self.parent.OnValueChanged(self.parent, self.parent.value)
		end
	end
	
	if dragging == true then
		loveframes.hoverobject = self
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function sliderbutton:draw()
	
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
		skin.DrawSliderButton(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function sliderbutton:mousepressed(x, y, button)
	
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
		self.dragging = true
		self.startx = self.staticx
		self.clickx = x
		self.starty = self.staticy
		self.clicky = y
		loveframes.hoverobject = self
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function sliderbutton:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	self.down = false
	self.dragging = false

end

--[[---------------------------------------------------------
	- func: MoveToX(x)
	- desc: moves the object to the specified x position
--]]---------------------------------------------------------
function sliderbutton:MoveToX(x)

	self.staticx = x
	
end

--[[---------------------------------------------------------
	- func: MoveToY(y)
	- desc: moves the object to the specified y position
--]]---------------------------------------------------------
function sliderbutton:MoveToY(y)

	self.staticy = y
	
end