--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- scrollbar class
scrollarea = class("scrollarea", base)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function scrollarea:initialize(parent, bartype)
	
	self.type			= "scroll-area"
	self.bartype		= bartype
	self.parent			= parent
	self.x 				= 0
	self.y 				= 0
	self.scrolldelay	= 0
	self.delayamount	= 0.05
	self.down			= false
	self.internal		= true
	self.internals		= {}
	
	table.insert(self.internals, scrollbar:new(self, bartype))
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function scrollarea:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	self:CheckHover()
	
	local parent = self.parent
	local pinternals = parent.internals
	local button = pinternals[2]
	local bartype = self.bartype
	local time = love.timer.getTime()
	local x, y = love.mouse.getPosition()
	local listo = parent.parent
	local down = self.down
	local scrolldelay = self.scrolldelay
	local delayamount = self.delayamount
	local internals = self.internals
	local bar = internals[1]
	local hover = self.hover
	
	if button then
	
		if bartype == "vertical" then
			self.staticx	= 0
			self.staticy	= button.height - 1
			self.width 		= parent.width
			self.height 	= parent.height - button.height*2 + 2
		elseif bartype == "horizontal" then
			self.staticx	= button.width - 1
			self.staticy	= 0
			self.width 		= parent.width - button.width*2 + 2
			self.height 	= parent.height
		end
		
	end
	
	if down == true then
		if scrolldelay < time then
			self.scrolldelay = time + delayamount
			if listo.display == "vertical" then
				if y > bar.y then
					bar:Scroll(bar.height)
				else
					bar:Scroll(-bar.height)
				end
			elseif listo.display == "horizontal" then
				if x > bar.x then
					bar:Scroll(bar.width)
				else
					bar:Scroll(-bar.width)
				end
			end
		end
		if hover == false then
			self.down = false
		end
	end
	
	for k, v in ipairs(internals) do
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
function scrollarea:draw()

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local internals = self.internals
	
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
		skin.DrawScrollArea(self)
	end
	
	for k, v in ipairs(internals) do
		v:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function scrollarea:mousepressed(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local listo = self.parent.parent
	local time = love.timer.getTime()
	local internals = self.internals
	local bar = internals[1]
	local hover = self.hover
	local delayamount = self.delayamount
	
	if hover == true and button == "l" then
		self.down = true
		self.scrolldelay = time + delayamount + 0.5
		
		local baseparent = self:GetBaseParent()
		
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
			
		if listo.display == "vertical" then
			if y > self.internals[1].y then
				bar:Scroll(bar.height)
			else
				bar:Scroll(-bar.height)
			end
		elseif listo.display == "horizontal" then
			if x > bar.x then
				bar:Scroll(bar.width)
			else
				bar:Scroll(-bar.width)
			end
		end
		
		loveframes.hoverobject = self
		
	end
	
	for k, v in ipairs(internals) do
		v:mousepressed(x, y, button)
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function scrollarea:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local internals = self.internals
	
	if button == "l" then
		self.down = false
	end
	
	for k, v in ipairs(internals) do
		v:mousereleased(x, y, button)
	end

end