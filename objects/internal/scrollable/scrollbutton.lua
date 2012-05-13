--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- scrollbutton clas
scrollbutton = class("scrollbutton", base)
scrollbutton:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function scrollbutton:initialize(scrolltype)

	self.type			= "scrollbutton"
	self.scrolltype		= scrolltype
	self.width 			= 16
	self.height 		= 16
	self.down			= false
	self.internal		= true
	self.OnClick		= function() end
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function scrollbutton:update(dt)
	
	if self.visible == false then
		if self.alwaysupdate == false then
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
function scrollbutton:draw()
	
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
		skin.DrawScrollButton(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, scrollbutton)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function scrollbutton:mousepressed(x, y, scrollbutton)

	
	if self.visible == false then
		return
	end
	
	if self.hover == true then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	
		self.down = true
		loveframes.hoverobject = self
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, scrollbutton)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function scrollbutton:mousereleased(x, y, scrollbutton)
	
	if self.visible == false then
		return
	end
	
	if self.hover == true and self.down == true then
	
		if scrollbutton == "l" then
			self.OnClick(x, y, self)
		end
		
	end
	
	self.down = false

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function scrollbutton:SetText(text)

	return
	
end