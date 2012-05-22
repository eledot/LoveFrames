--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
progressbar = class("progressbar", base)
progressbar:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function progressbar:initialize()

	self.type			= "progressbar"
	self.width 			= 100
	self.height 		= 25
	self.min			= 0
	self.max			= 10
	self.value			= 0
	self.progress		= 0
	self.lerprate		= 1000
	self.lerpvalue		= 0
	self.lerpto			= 0
	self.lerpfrom		= 0
	self.completed		= false
	self.lerp			= false
	self.internal		= false
	self.OnComplete		= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function progressbar:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local lerp = self.lerp
	local lerprate = self.lerprate
	local lerpvalue = self.lerpvalue
	local lerpto = self.lerpto
	local lerpfrom = self.lerpfrom
	local value = self.value
	local completed = self.completed
	
	self:CheckHover()
	
	-- caclulate progress
	if lerp == true then
		if lerpfrom < lerpto then
			if lerpvalue < lerpto then
				self.lerpvalue = lerpvalue + lerprate*dt
			elseif lerpvalue > lerpto then
				self.lerpvalue = lerpto
			end
		elseif lerpfrom > lerpto then
			if lerpvalue > lerpto then
				self.lerpvalue = lerpvalue - lerprate*dt
			elseif lerpvalue < lerpto then
				self.lerpvalue = lerpto
			end
		elseif lerpfrom == lerpto then
			self.lerpvalue = lerpto
		end
		
		self.progress = self.lerpvalue/self.max * self.width
		
		-- min check
		if self.lerpvalue < self.min then
			self.lerpvalue = self.min
		end
	
		-- max check
		if self.lerpvalue > self.max then
			self.lerpvalue = self.max
		end
	else
		self.progress = self.value/self.max * self.width
		
		-- min check
		if self.value < self.min then
			self.value = self.min
		end
	
		-- max check
		if self.value > self.max then
			self.value = self.max
		end
	end
	
	-- move to parent if there is a parent
	if self.parent ~= nil then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	-- completion check
	if completed == false then
		if self.value >= self.max then
			self.completed = true
			if self.OnComplete then
				self.OnComplete(self)
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
function progressbar:draw()
	
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
		skin.DrawProgressBar(self)
	end
	
end

--[[---------------------------------------------------------
	- func: SetMax(max)
	- desc: sets the object's maximum value
--]]---------------------------------------------------------
function progressbar:SetMax(max)

	self.max = max
	
end

--[[---------------------------------------------------------
	- func: GetMax()
	- desc: gets the object's maximum value
--]]---------------------------------------------------------
function progressbar:GetMax()

	return self.max
	
end

--[[---------------------------------------------------------
	- func: SetMin(min)
	- desc: sets the object's minimum value
--]]---------------------------------------------------------
function progressbar:SetMin(min)

	self.min = min
	
end

--[[---------------------------------------------------------
	- func: GetMin()
	- desc: gets the object's minimum value
--]]---------------------------------------------------------
function progressbar:GetMin()

	return self.min
	
end

--[[---------------------------------------------------------
	- func: SetMinMax()
	- desc: sets the object's minimum and maximum values
--]]---------------------------------------------------------
function progressbar:SetMinMax(min, max)

	self.min = min
	self.max = max
	
end

--[[---------------------------------------------------------
	- func: GetMinMax()
	- desc: gets the object's minimum and maximum values
--]]---------------------------------------------------------
function progressbar:GetMinMax()

	return self.min, self.max
	
end

--[[---------------------------------------------------------
	- func: SetValue(value)
	- desc: sets the object's value
--]]---------------------------------------------------------
function progressbar:SetValue(value)

	local lerp = self.lerp
	
	if lerp == true then
		self.lerpvalue = self.lerpvalue
		self.lerpto = value
		self.lerpfrom = self.lerpvalue
		self.value = value
	else
		self.value = value
	end
	
end

--[[---------------------------------------------------------
	- func: GetValue()
	- desc: gets the object's value
--]]---------------------------------------------------------
function progressbar:GetValue()

	return self.value
	
end

--[[---------------------------------------------------------
	- func: SetLerp(bool)
	- desc: sets whether or not the object should lerp
			when changing between values
--]]---------------------------------------------------------
function progressbar:SetLerp(bool)

	self.lerp = bool
	self.lerpto = self:GetValue()
	self.lerpvalue = self:GetValue()
	
end

--[[---------------------------------------------------------
	- func: GetLerp()
	- desc: gets whether or not the object should lerp
			when changing between values
--]]---------------------------------------------------------
function progressbar:GetLerp()

	return self.lerp
	
end

--[[---------------------------------------------------------
	- func: SetLerpRate(rate)
	- desc: sets the object's lerp rate
--]]---------------------------------------------------------
function progressbar:SetLerpRate(rate)

	self.lerprate = rate
	
end

--[[---------------------------------------------------------
	- func: GetLerpRate()
	- desc: gets the object's lerp rate
--]]---------------------------------------------------------
function progressbar:GetLerpRate()

	return self.lerprate
	
end