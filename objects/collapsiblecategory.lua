--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- button clas
collapsiblecategory = class("collapsiblecategory", base)
collapsiblecategory:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function collapsiblecategory:initialize()

	self.type			= "collapsiblecategory"
	self.text 			= "Category"
	self.width			= 200
	self.height			= 25
	self.closedheight	= 25
	self.padding		= 5
	self.internal		= false
	self.open			= false
	self.down		 	= false
	self.children		= {}
	self.OnOpenedClosed	= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function collapsiblecategory:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local open = self.open
	local children = self.children
	local curobject = children[1]
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if open == true then
		curobject:update(dt)
		curobject:SetWidth(self.width - self.padding*2)
		curobject.y = (curobject.parent.y + curobject.staticy)
		curobject.x = (curobject.parent.x + curobject.staticx)
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function collapsiblecategory:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local open = self.open
	local children = self.children
	local curobject = children[1]
	
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
		skin.DrawCollapsibleCategory(self)
	end
	
	if open == true then
		curobject:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function collapsiblecategory:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local open = self.open
	local children = self.children
	local curobject = children[1]
	
	if hover == true then
	
		local col = loveframes.util.BoundingBox(self.x, x, self.y, y, self.width, 1, self.closedheight, 1)
		
		if button == "l" and col == true then
			
			local baseparent = self:GetBaseParent()
	
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
			
			self.down = true
			loveframes.hoverobject = self
		
		end
		
	end
	
	if open == true then
		curobject:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function collapsiblecategory:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	local open = self.open
	local col = loveframes.util.BoundingBox(self.x, x, self.y, y, self.width, 1, self.closedheight, 1)
	local children = self.children
	local curobject = children[1]
	
	if hover == true and button == "l" and col == true and self.down == true then
			
		if open == true then
			self:SetOpen(false)
		else
			self:SetOpen(true)
		end
		
		self.down = false
		
	end
	
	if open == true then
		curobject:mousepressed(x, y, button)
	end

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function collapsiblecategory:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function collapsiblecategory:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetObject(object)
	- desc: sets the category's object
--]]---------------------------------------------------------
function collapsiblecategory:SetObject(object)
	
	local children = self.children
	local curobject = children[1]
	
	if curobject then
		curobject:Remove()
		self.children = {}
	end
	
	object:Remove()
	object.parent = self
	object:SetWidth(self.width - self.padding*2)
	object:SetPos(self.padding, self.closedheight + self.padding)
	
	table.insert(self.children, object)
	
end

--[[---------------------------------------------------------
	- func: SetObject(object)
	- desc: sets the category's object
--]]---------------------------------------------------------
function collapsiblecategory:GetObject()

	local children = self.children
	local curobject = children[1]
	
	if curobject then
		return curobject
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: SetSize(width, height)
	- desc: sets the object's size
--]]---------------------------------------------------------
function collapsiblecategory:SetSize(width, height)

	self.width = width
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function collapsiblecategory:SetHeight(height)

	return
	
end

--[[---------------------------------------------------------
	- func: SetClosedHeight(height)
	- desc: sets the object's closed height
--]]---------------------------------------------------------
function collapsiblecategory:SetClosedHeight(height)

	self.closedheight = height
	
end

--[[---------------------------------------------------------
	- func: GetClosedHeight()
	- desc: gets the object's closed height
--]]---------------------------------------------------------
function collapsiblecategory:GetClosedHeight()

	return self.closedheight
	
end

--[[---------------------------------------------------------
	- func: SetOpen(bool)
	- desc: sets whether the object is opened or closed
--]]---------------------------------------------------------
function collapsiblecategory:SetOpen(bool)

	local children = self.children
	local curobject = children[1]
	
	self.open = bool
	
	if bool == false then
		self.height = self.closedheight
		if curobject then
			curobject:SetVisible(false)
		end
	else
		self.height = self.closedheight + self.padding*2 + curobject.height
		if curobject then
			curobject:SetVisible(true)
		end
	end
			
	if self.OnOpenedClosed then
		self.OnOpenedClosed(self)
	end
	
end

--[[---------------------------------------------------------
	- func: GetOpen()
	- desc: gets whether the object is opened or closed
--]]---------------------------------------------------------
function collapsiblecategory:GetOpen()

	return self.opened

end