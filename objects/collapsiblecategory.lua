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
	self.children		= {}
	self.OnOpenedClosed	= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function collapsiblecategory:update(dt)
	
	if self.visible == false then
		if self.alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if self.open == true then
		for k, v in ipairs(self.children) do
			v:update(dt)
			v:SetWidth(self.width - self.padding*2)
			v.y = (v.parent.y + v.staticy)
			v.x = (v.parent.x + v.staticx)
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
function collapsiblecategory:draw()
	
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
		skin.DrawCollapsibleCategory(self)
	end
	
	if self.open == true then
		for k, v in ipairs(self.children) do
			v:draw()
		end
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function collapsiblecategory:mousepressed(x, y, button)

	if self.visible == false then
		return
	end
	
	if self.hover == true then
	
		local col = loveframes.util.BoundingBox(self.x, x, self.y, y, self.width, 1, self.closedheight, 1)
		
		if button == "l" and col == true then
			
			local baseparent = self:GetBaseParent()
	
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
		
		end
		
	end
	
	if self.open == true then
	
		for k, v in ipairs(self.children) do
			v:mousepressed(x, y, button)
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function collapsiblecategory:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	local open = self.open
	local col = loveframes.util.BoundingBox(self.x, x, self.y, y, self.width, 1, self.closedheight, 1)
	
	if hover == true and button == "l" and col == true then
			
		if open == true then
			self:SetOpen(false)
		else
			self:SetOpen(true)
		end
		
	end
	
	if self.open == true then
	
		for k, v in ipairs(self.children) do
			v:mousereleased(x, y, button)
		end
		
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
	
	if self.children[1] then
		self.children[1]:Remove()
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

	if self.children[1] then
		return self.children[1]
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

	self.open = bool
	
	if bool == false then
		self.height = self.closedheight
		if self.children[1] then
			self.children[1]:SetVisible(false)
		end
	else
		self.height = self.closedheight + self.padding*2 + self.children[1].height
		if self.children[1] then
			self.children[1]:SetVisible(true)
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