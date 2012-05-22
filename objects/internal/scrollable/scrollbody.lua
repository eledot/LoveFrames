--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- scrollbar class
scrollbody = class("scrollbody", base)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function scrollbody:initialize(parent, bartype)
	
	self.type			= "scroll-body"
	self.bartype		= bartype
	self.parent			= parent
	self.x 				= 0
	self.y 				= 0
	self.internal		= true
	self.internals		= {}
	
	if self.bartype == "vertical" then
		self.width 		= 16
		self.height 	= self.parent.height
		self.staticx	= self.parent.width - self.width
		self.staticy	= 0
	elseif self.bartype == "horizontal" then
		self.width 		= self.parent.width
		self.height 	= 16
		self.staticx	= 0
		self.staticy	= self.parent.height - self.height
	end
	
	table.insert(self.internals, scrollarea:new(self, bartype))
	
	local bar = self.internals[1].internals[1]
	
	if self.bartype == "vertical" then 
	
		local upbutton			= scrollbutton:new("up")
		upbutton.parent 		= self
		upbutton.Update			= function(object, dt)
			upbutton.staticx 		= 0 + self.width - upbutton.width
			upbutton.staticy 		= 0
			if object.down == true and object.hover == true then
				bar:Scroll(-0.10)
			end
		end
			
		local downbutton		= scrollbutton:new("down")
		downbutton.parent 		= self
		downbutton.Update 		= function(object, dt)
			downbutton.staticx 		= 0 + self.width - downbutton.width
			downbutton.staticy 		= 0 + self.height - downbutton.height
			if object.down == true and object.hover == true then
				bar:Scroll(0.10)
			end
		end
		
		table.insert(self.internals, upbutton)
		table.insert(self.internals, downbutton)
		
	elseif self.bartype == "horizontal" then
		
		local leftbutton		= scrollbutton:new("left")
		leftbutton.parent 		= self
		leftbutton.Update		= function(object, dt)
			leftbutton.staticx 		= 0
			leftbutton.staticy 		= 0
			if object.down == true and object.hover == true then
				bar:Scroll(-0.10)
			end
		end
			
		local rightbutton		= scrollbutton:new("right")
		rightbutton.parent 		= self
		rightbutton.Update 		= function(object, dt)
			rightbutton.staticx 	= 0 + self.width - rightbutton.width
			rightbutton.staticy 	= 0
			if object.down == true and object.hover == true then
				bar:Scroll(0.10)
			end
		end
		
		table.insert(self.internals, leftbutton)
		table.insert(self.internals, rightbutton)
		
	end
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function scrollbody:update(dt)
	
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
function scrollbody:draw()

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
		skin.DrawScrollBody(self)
	end
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
end