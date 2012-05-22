--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- scrollbar class
scrollbar = class("scrollbar", base)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function scrollbar:initialize(parent, bartype)

	self.type			= "scrollbar"
	self.bartype		= bartype
	self.parent			= parent
	self.x 				= 0
	self.y 				= 0
	self.staticx		= 0
	self.staticy		= 0
	self.maxx			= 0
	self.maxy			= 0
	self.clickx			= 0
	self.clicky			= 0
	self.starty			= 0
	self.lastwidth		= 0
	self.lastheight		= 0
	self.lastx			= 0
	self.lasty			= 0
	self.internal		= true
	self.hover			= false
	self.dragging		= false
	self.autoscroll		= false
	self.internal		= true
	
	if self.bartype == "vertical" then
		self.width 		= self.parent.width
		self.height 	= 5
	elseif self.bartype == "horizontal" then
		self.width 		= 5
		self.height 	= self.parent.height
	end
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function scrollbar:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	local x, y = love.mouse.getPosition()
	local bartype = self.bartype
	local cols = {}
	local basecols = {}
	local dragging = self.dragging
	
	if bartype == "vertical" then
		self.width 		= self.parent.width
	elseif bartype == "horizontal" then
		self.height 	= self.parent.height
	end
	
	if bartype == "vertical" then
		
		local parent = self.parent
		local listo = parent.parent.parent
		local height = parent.height * (listo.height/listo.itemheight)
		
		if height < 20 then
			self.height = 20
		else
			self.height = height
		end
		
		self.maxy = parent.y + (parent.height - self.height)
		self.x = parent.x + parent.width - self.width
		self.y = parent.y + self.staticy
			
		if dragging == true then
			if self.staticy ~= self.lasty then
				if listo.OnScroll then
					listo.OnScroll(listo)
				end
				self.lasty = self.staticy
			end
			self.staticy = self.starty + (y - self.clicky)
		end
		
		local space = (self.maxy - parent.y)
		local remaining = (0 + self.staticy)
		local percent = remaining/space
		local extra = listo.extra * percent
		local autoscroll = self.autoscroll
		local lastheight = self.lastheight
		
		listo.offsety = 0 + extra
			
		if self.staticy > space then
			self.staticy = space
			listo.offsety = listo.extra
		end
					
		if self.staticy < 0 then
			self.staticy = 0
			listo.offsety = 0
		end
		
		if autoscroll == true then
			if listo.itemheight ~= lastheight then
				self.lastheight = listo.itemheight
				self:Scroll(self.maxy)
			end
		end
	
	elseif bartype == "horizontal" then
		
		self.lastwidth = self.width
		
		local parent = self.parent
		local listo = self.parent.parent.parent
		local width = self.parent.width * (listo.width/listo.itemwidth)
		
		if width < 20 then
			self.width = 20
		else
			self.width = width
		end
		
		self.maxx = parent.x + (parent.width) - self.width
		self.x = parent.x + self.staticx
		self.y = parent.y + self.staticy
			
		if dragging == true then
			if self.staticx ~= self.lastx then
				if listo.OnScroll then
					listo.OnScroll(listo)
				end
				self.lastx = self.staticx
			end
			self.staticx = self.startx + (x - self.clickx)
		end
		
		local space = (self.maxx - parent.x)
		local remaining = (0 + self.staticx)
		local percent = remaining/space
		local extra = listo.extra * percent
		local autoscroll = self.autoscroll
		local lastwidth = self.lastwidth
		
		listo.offsetx = 0 + extra
		
		if self.staticx > space then
			self.staticx = space
			listo.offsetx = listo.extra
		end
					
		if self.staticx < 0 then
			self.staticx = 0
			listo.offsetx = 0
		end
		
		if autoscroll == true then
			if self.width ~= lastwidth then
				self.width = self.width
				self:Scroll(self.maxx)
			end
		end
			
	end
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function scrollbar:draw()

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
		skin.DrawScrollBar(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function scrollbar:mousepressed(x, y, button)

	local visible = self.visible
	local hover = self.hover
	
	if visible == false then
		return
	end
	
	if hover == false then
		return
	end
	
	local baseparent = self:GetBaseParent()
	
	if baseparent.type == "frame" then
		baseparent:MakeTop()
	end
	
	local dragging = self.dragging
	
	if dragging == false then
		
		if button == "l" then
		
			self.starty = self.staticy
			self.startx = self.staticx
			self.clickx = x
			self.clicky = y
			self.dragging = true
			loveframes.hoverobject = self
			
		end
			
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function scrollbar:mousereleased(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	if self.dragging == true then
		self.dragging = false
	end

end

--[[---------------------------------------------------------
	- func: SetMaxX(x)
	- desc: sets the object's max x position
--]]---------------------------------------------------------
function scrollbar:SetMaxX(x)

	self.maxx = x
	
end

--[[---------------------------------------------------------
	- func: SetMaxY(y)
	- desc: sets the object's max y position
--]]---------------------------------------------------------
function scrollbar:SetMaxY(y)

	self.maxy = y
	
end

--[[---------------------------------------------------------
	- func: Scroll(amount)
	- desc: scrolls the object
--]]---------------------------------------------------------
function scrollbar:Scroll(amount)

	local bartype = self.bartype
	local listo = self.parent.parent.parent
	
	if bartype == "vertical" then
		local newy = (self.y + amount)
		
		if newy > self.maxy then
			self.staticy = self.maxy - self.parent.y
		elseif newy < self.parent.y then
			self.staticy = 0
		else
			self.staticy = self.staticy + amount
		end
	elseif bartype == "horizontal" then
		local newx = (self.x + amount)
		
		if newx > self.maxx then
			self.staticx = self.maxx - self.parent.x
		elseif newx < self.parent.x then
			self.staticx = 0
		else
			self.staticx = self.staticx + amount
		end
	end
	
	if listo.OnScroll then
		listo.OnScroll(listo)
	end
	
end