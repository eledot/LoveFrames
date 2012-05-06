--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- scrollbar class
scrollarea = class("scrollarea", base)

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

function scrollarea:update(dt)
	
	if self.visible == false then
		if self.alwaysupdate == false then
			return
		end
	end
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	self:CheckHover()
	
	if self.parent.internals[2] then
	
		if self.bartype == "vertical" then
			self.staticx	= 0
			self.staticy	= self.parent.internals[2].height - 1
			self.width 		= self.parent.width
			self.height 	= self.parent.height - self.parent.internals[2].height*2 + 2
		elseif self.bartype == "horizontal" then
			self.staticx	= self.parent.internals[2].width - 1
			self.staticy	= 0
			self.width 		= self.parent.width - self.parent.internals[2].width*2 + 2
			self.height 	= self.parent.height
		end
		
	end
	
	local time = love.timer.getTime()
	local x, y = love.mouse.getPosition()
	local listo = self.parent.parent
	
	if self.down == true then
		if self.scrolldelay < time then
			self.scrolldelay = time + self.delayamount
			if listo.display == "vertical" then
				if y > self.internals[1].y then
					self.internals[1]:Scroll(self.internals[1].height)
				else
					self.internals[1]:Scroll(-self.internals[1].height)
				end
			elseif listo.display == "horizontal" then
				if x > self.internals[1].x then
					self.internals[1]:Scroll(self.internals[1].width)
				else
					self.internals[1]:Scroll(-self.internals[1].width)
				end
			end
		end
		if self.hover == false then
			self.down = false
		end
	end
	
	for k, v in ipairs(self.internals) do
		v:update(dt)
	end
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

function scrollarea:draw()

	if self.visible == false then
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
		skin.DrawScrollArea(self)
	end
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
end

function scrollarea:mousepressed(x, y, button)
	
	if self.visible == false then
		return
	end
	
	local listo = self.parent.parent
	local time = love.timer.getTime()
	
	if self.hover == true and button == "l" then
		self.down = true
		self.scrolldelay = time + self.delayamount + 0.5
		if listo.display == "vertical" then
			if y > self.internals[1].y then
				self.internals[1]:Scroll(self.internals[1].height)
			else
				self.internals[1]:Scroll(-self.internals[1].height)
			end
		elseif listo.display == "horizontal" then
			if x > self.internals[1].x then
				self.internals[1]:Scroll(self.internals[1].width)
			else
				self.internals[1]:Scroll(-self.internals[1].width)
			end
		end
	end
	
	for k, v in ipairs(self.internals) do
		v:mousepressed(x, y, button)
	end

end

function scrollarea:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	if button == "l" then
		self.down = false
	end
	
	for k, v in ipairs(self.internals) do
		v:mousereleased(x, y, button)
	end

end