--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- panel class
panel = class("panel", base)
panel:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function panel:initialize()
	
	self.type			= "panel"
	self.width 			= 200
	self.height 		= 50
	self.internal		= false
	self.children 		= {}
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the element
--]]---------------------------------------------------------
function panel:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local children = self.children
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base and self.parent.type ~= "list" then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	self:CheckHover()

	for k, v in ipairs(children) do
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
function panel:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local children = self.children
	
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
		skin.DrawPanel(self)
	end
		
	-- loop through the object's children and draw them
	for k, v in ipairs(children) do
		v:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function panel:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local children = self.children
	local hover = self.hover
	
	if hover == true and button == "l" then
	
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
	end
	
	for k, v in ipairs(children) do
		v:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function panel:mousereleased(x, y, button)

	local visible = self.visible
	local children = self.children
	
	if visible == false then
		return
	end
	
	for k, v in ipairs(children) do
		v:mousereleased(x, y, button)
	end
	
end