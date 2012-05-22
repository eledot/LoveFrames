--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- multichoicelist class
multichoicelist = class("multichoicelist", base)
multichoicelist:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function multichoicelist:initialize(object)
	
	self.type			= "multichoice-list"
	self.parent			= loveframes.base
	self.list			= object
	self.x 				= object.x
	self.y				= object.y + self.list.height
	self.width 			= self.list.width
	self.height 		= 0
	self.clickx 		= 0
	self.clicky 		= 0
	self.padding		= self.list.listpadding
	self.spacing		= self.list.listspacing
	self.offsety		= 0
	self.offsetx		= 0
	self.extra			= 0
	self.canremove		= false
	self.internal		= true
	self.vbar			= false
	self.children		= {}
	self.internals		= {}
	
	for k, v in ipairs(object.choices) do
		local row = multichoicerow:new()
		row:SetText(v)
		self:AddItem(row)
	end
	
	table.insert(loveframes.base.children, self)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function multichoicelist:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local x, y = love.mouse.getPosition()
	local selfcol = loveframes.util.BoundingBox(x, self.x, y, self.y, 1, self.width, 1, self.height)
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
		
	if self.x < 0 then
		self.x = 0
	end
	
	if self.x + self.width > width then
		self.x = width - self.width
	end
	
	if self.y < 0 then
		self.y = 0
	end
	
	if self.y + self.height > height then
		self.y = height - self.height
	end
	
	for k, v in ipairs(self.internals) do
		v:update(dt)
	end
	
	for k, v in ipairs(self.children) do
		v:update(dt)
		v:SetClickBounds(self.x, self.y, self.width, self.height)
		v.y = (v.parent.y + v.staticy) - self.offsety
		v.x = (v.parent.x + v.staticx) - self.offsetx
	end
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function multichoicelist:draw()
	
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
		skin.DrawMultiChoiceList(self)
	end
		
	for k, v in ipairs(self.internals) do
		v:draw()
	end
		
	love.graphics.setScissor(self.x, self.y, self.width, self.height)
		
	for k, v in ipairs(self.children) do
		local col = loveframes.util.BoundingBox(self.x, v.x, self.y, v.y, self.width, v.width, self.height, v.height)
		if col == true then
			v:draw()
		end
	end
		
	love.graphics.setScissor()
	
	skin.DrawOverMultiChoiceList(self)
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function multichoicelist:mousepressed(x, y, button)
	
	if self.visible == false then
		return
	end
	
	local selfcol = loveframes.util.BoundingBox(x, self.x, y, self.y, 1, self.width, 1, self.height)
	local toplist = self:IsTopList()
	
	if selfcol == false and button == "l" and self.canremove == true then
		self:Close()
	end
	
	if self.vbar == true and toplist == true then
	
		if button == "wu" then
			self.internals[1].internals[1].internals[1]:Scroll(-5)
		elseif button == "wd" then
			self.internals[1].internals[1].internals[1]:Scroll(5)
		end
		
	end
	
	for k, v in ipairs(self.internals) do
		v:mousepressed(x, y, button)
	end
	
	for k, v in ipairs(self.children) do
		v:mousepressed(x, y, button)
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function multichoicelist:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	self.canremove = true
	
	for k, v in ipairs(self.internals) do
		v:mousereleased(x, y, button)
	end
	
	for k, v in ipairs(self.children) do
		v:mousereleased(x, y, button)
	end

end

--[[---------------------------------------------------------
	- func: AddItem(object)
	- desc: adds an item to the object
--]]---------------------------------------------------------
function multichoicelist:AddItem(object)
	
	if object.type ~= "multichoice-row" then
		return
	end
	
	object.parent = self
	
	table.insert(self.children, object)
	
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: RemoveItem(object)
	- desc: removes an item from the object
--]]---------------------------------------------------------
function multichoicelist:RemoveItem(object)

	for k, v in ipairs(self.children) do
	
		if v == object then
			table.remove(self.children, k)
		end
		
	end
	
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: CalculateSize()
	- desc: calculates the size of the object's children
--]]---------------------------------------------------------
function multichoicelist:CalculateSize()

	self.height = self.padding
	
	if self.list.listheight then
		self.height = self.list.listheight
	else
		for k, v in ipairs(self.children) do
			self.height = self.height + (v.height + self.spacing)
		end
	end

	if self.height > love.graphics.getHeight() then
		self.height = love.graphics.getHeight()
	end
	
	local numitems = #self.children
	local height = self.height
	local padding = self.padding
	local spacing = self.spacing
	local itemheight = self.padding
	local vbar = self.vbar
	
	for k, v in ipairs(self.children) do
		itemheight = itemheight + v.height + spacing
	end
		
	self.itemheight = (itemheight - spacing) + padding
		
	if self.itemheight > height then
		
		self.extra = self.itemheight - height
			
		if vbar == false then
			local scroll = scrollbody:new(self, "vertical")
			table.insert(self.internals, scroll)
			self.vbar = true
		end
			
	else
			
		if vbar == true then
			self.internals[1]:Remove()
			self.vbar = false
			self.offsety = 0
		end
			
	end
	
end

--[[---------------------------------------------------------
	- func: RedoLayout()
	- desc: used to redo the layour of the object
--]]---------------------------------------------------------
function multichoicelist:RedoLayout()

	local children = self.children
	local padding = self.padding
	local spacing = self.spacing
	local starty = padding
	local vbar = self.vbar
	
	if #children > 0 then
	
		for k, v in ipairs(children) do
			
			v.staticx = padding
			v.staticy = starty
				
			if vbar == true then
				v.width = (self.width - self.internals[1].width) - padding*2
				self.internals[1].staticx = self.width - self.internals[1].width
				self.internals[1].height = self.height
			else
				v.width = self.width - padding*2
			end
				
			starty = starty + v.height
			starty = starty + spacing
			
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: SetPadding(amount)
	- desc: sets the object's padding
--]]---------------------------------------------------------
function multichoicelist:SetPadding(amount)

	self.padding = amount
	
end

--[[---------------------------------------------------------
	- func: SetSpacing(amount)
	- desc: sets the object's spacing
--]]---------------------------------------------------------
function multichoicelist:SetSpacing(amount)

	self.spacing = amount
	
end

function multichoicelist:Close()

	self:Remove()
	self.list.haslist = false
		
end