--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- closebutton clas
closebutton = class("closebutton", base)
closebutton:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function closebutton:initialize()

	self.type			= "closebutton"
	self.width 			= 80
	self.height 		= 25
	self.internal		= true
	self.hover			= false
	self.down			= false
	self.OnClick		= function() end
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function closebutton:update(dt)
	
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
		if loveframes.hoverobject == self then
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
function closebutton:draw()
	
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
		skin.DrawCloseButton(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function closebutton:mousepressed(x, y, button)
	
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
function closebutton:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	
	if hover == true and self.down == true then
	
		if button == "l" then
			self.OnClick(x, y, self)
		end
		
	end
	
	self.down = false

end