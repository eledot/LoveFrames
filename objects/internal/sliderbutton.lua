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
	self.intervals		= true
	self.internal		= true
	self.down			= false
	self.dragging		= false
	self.parent			= parent
	
	self:SetY(self.parent.ycenter - self.height/2)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function sliderbutton:update(dt)
	
	if self.visible == false then
		if self.alwaysupdate == false then
			return
		end
	end
	
	local x, y = love.mouse.getPosition()
	local intervals = self.intervals
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if self.dragging == true then
		self.staticx = self.startx + (x - self.clickx)
	end
		
	if (self.staticx + self.width) > self.parent.width then
		self.staticx = self.parent.width - self.width
	end
		
	if self.staticx < 0 then
		self.staticx = 0
	end
	
	local progress = loveframes.util.Round(self.staticx/(self.parent.width - self.width), 5)
	local nvalue = self.parent.min + (self.parent.max - self.parent.min) * progress
	local pvalue = self.parent.value
	
	if nvalue ~= pvalue then
		self.parent.value = loveframes.util.Round(nvalue, self.parent.decimals)
		self.parent.OnValueChanged(self.parent, self.parent.value)
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
	
	if self.visible == false then
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
	
	if self.visible == false then
		return
	end
		
	if self.hover == true and button == "l" then
	
		local baseparent = self:GetBaseParent()
		
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
		self.down = true
		self.dragging = true
		self.startx = self.staticx
		self.clickx = x
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function sliderbutton:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	self.down = false
	self.dragging = false

end

function sliderbutton:MoveToX(x)

	self.staticx = x
	
end