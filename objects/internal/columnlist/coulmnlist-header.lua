--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- columnlistheader object
columnlistheader = class("columnlistheader", base)
columnlistheader:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: intializes the element
--]]---------------------------------------------------------
function columnlistheader:initialize(name, parent)
	
	self.type 		= "columnlistheader"
	self.parent		= parent
	self.name		= name
	self.width 		= 80
	self.height 	= 16
	self.hover		= false
	self.down		= false
	self.clickable	= true
	self.enabled	= true
	self.descending = true
	self.internal	= true

	table.insert(parent.children, self)
		
	local key = 0
	
	for k, v in ipairs(self.parent.children) do
		if v == self then
			key = k
		end
	end
	
	self.OnClick = function()
		if self.descending == true then
			self.descending = false
		else
			self.descending = true
		end
		self.parent.internals[1]:Sort(key, self.descending)
	end
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function columnlistheader:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
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
function columnlistheader:draw()

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
		skin.DrawColumnListHeader(self)
	end

end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function columnlistheader:mousepressed(x, y, button)

	if self.hover == true and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" and button == "l" then
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
function columnlistheader:mousereleased(x, y, button)

	if self.visible == false then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	
	if hover == true and down == true and button == "l" and clickable == true then
		if enabled == true then
			self.OnClick(self, x, y)
		end
	end
	
	self.down = false
	
end