--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- tabs class
tabs = class("tabpanel", base)
tabs:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function tabs:initialize()
	
	self.type			= "tabs"
	self.width 			= 100
	self.height 		= 50
	self.clickx 		= 0
	self.clicky 		= 0
	self.offsetx		= 0
	self.tab			= 1
	self.tabnumber		= 1
	self.padding		= 5
	self.tabheight		= 25
	self.autosize		= true
	self.internal		= false
	self.tabs			= {}
	self.internals		= {}
	self.children 		= {}
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the element
--]]---------------------------------------------------------
function tabs:update(dt)
	
	local x, y = love.mouse.getPosition()
		local tabheight = self.tabheight
	local padding = self.padding
	local autosize = self.autosize
	local tabheight = self.tabheight
	local padding = self.padding
	local autosize = self.autosize
	
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
	
	if #self.children > 0 and self.tab == 0 then
		self.tab = 1
	end
	
	local pos = 0
	
	for k, v in ipairs(self.internals) do
		v:update(dt)
		if v.type == "tabbutton" then
			v.y = (v.parent.y + v.staticy)
			v.x = (v.parent.x + v.staticx) + pos + self.offsetx
			pos = pos + v.width - 1
		end
	end
	
	for k, v in ipairs(self.children) do
		v:update(dt)
		v:SetPos(padding, tabheight + padding)
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function tabs:draw()
	
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
		skin.DrawTabPanel(self)
	end
	
	local tabheight = self:GetHeightOfButtons()
	local stencilfunc = function() love.graphics.rectangle("fill", self.x, self.y, self.width, tabheight) end
	local stencil = love.graphics.newStencil(stencilfunc)
	
	love.graphics.setStencil(stencil)
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
	love.graphics.setStencil()
	
	if #self.children > 0 then
		self.children[self.tab]:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function tabs:mousepressed(x, y, button)
	
	if self.visible == false then
		return
	end
	
	if self.hover == true then
	
		if button == "l" then
		
			local baseparent = self:GetBaseParent()
		
			if baseparent and baseparent.type == "frame" then
				baseparent:MakeTop()
			end
			
		end
		
	end
	
	if button == "wu" then
		
		local buttonheight = self:GetHeightOfButtons()
		local col = loveframes.util.BoundingBox(self.x, x, self.y, y, self.width, 1, buttonheight, 1)
		local visible = self.internals[#self.internals - 1]:GetVisible()
			
		if col == true and visible == true then
			self.offsetx = self.offsetx + 5
		end
			
	end
		
	if button == "wd" then
		
		local buttonheight = self:GetHeightOfButtons()
		local col = loveframes.util.BoundingBox(self.x, x, self.y, y, self.width, 1, buttonheight, 1)
		local visible = self.internals[#self.internals]:GetVisible()
			
		if col == true and visible == true then
			self.offsetx = self.offsetx - 5
		end
			
	end
	
	for k, v in ipairs(self.internals) do
		v:mousepressed(x, y, button)
	end
	
	if #self.children > 0 then
		self.children[self.tab]:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function tabs:mousereleased(x, y, button)

	if self.visible == false then
		return
	end
	
	for k, v in ipairs(self.internals) do
		v:mousereleased(x, y, button)
	end
	
	if #self.children > 0 then
		self.children[self.tab]:mousereleased(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: AddTab(name, object, tip, image)
	- desc: adds a new tab to the tab panel
--]]---------------------------------------------------------
function tabs:AddTab(name, object, tip, image)

	local tabheight = self.tabheight
	local padding = self.padding
	local autosize = self.autosize
	
	object:Remove()
	object.parent = self
	object.staticx = 0
	object.staticy = 0
	object:SetWidth(self.width - 10)
	object:SetHeight(self.height - 35)
	
	table.insert(self.children, object)
	self.internals[self.tabnumber] = tabbutton:new(self, name, self.tabnumber, tip, image)
	self.internals[self.tabnumber].height = self.tabheight
	self.tabnumber = self.tabnumber + 1
	
	for k, v in ipairs(self.internals) do
		self:SwitchToTab(k)
		break
	end
	
	self:AddScrollButtons()
	
	if autosize == true and object.retainsize == false then
		object:SetSize(self.width - padding*2, (self.height - tabheight) - padding*2)
	end
		
end

--[[---------------------------------------------------------
	- func: AddScrollButtons()
	- desc: creates scroll buttons fot the tab panel
	- note: for internal use only
--]]---------------------------------------------------------
function tabs:AddScrollButtons()

	for k, v in ipairs(self.internals) do
		if v.type == "scrollbutton" then
			table.remove(self.internals, k)
		end
	end
	
	local leftbutton = scrollbutton:new("left")
	leftbutton.parent = self
	leftbutton:SetPos(0, 0)
	leftbutton:SetSize(15, 25)
	leftbutton:SetAlwaysUpdate(true)
	leftbutton.Update = function(object, dt)
		if self.offsetx ~= 0 then
			object.visible = true
		else
			object.visible = false
			object.down = false
			object.hover = false
		end
		
		if object.down == true then
			if self.offsetx ~= 0 then
				self.offsetx = self.offsetx + 1
			end
		end
	end
	
	local rightbutton = scrollbutton:new("right")
	rightbutton.parent = self
	rightbutton:SetPos(self.width - 15, 0)
	rightbutton:SetSize(15, 25)
	rightbutton:SetAlwaysUpdate(true)
	rightbutton.Update = function(object, dt)
		local bwidth = self:GetWidthOfButtons()
		if (self.offsetx + bwidth) > self.width then
			object.visible = true
		else
			object.visible = false
			object.down = false
			object.hover = false
		end
		
		if object.down == true then
			if ((self.x + self.offsetx) + bwidth) ~= (self.x + self.width) then
				self.offsetx = self.offsetx - 1
			end
		end
	end
	
	table.insert(self.internals, leftbutton)
	table.insert(self.internals, rightbutton)

end

--[[---------------------------------------------------------
	- func: GetWidthOfButtons()
	- desc: gets the total width of all of the tab buttons
--]]---------------------------------------------------------
function tabs:GetWidthOfButtons()

	local width = 0
	
	for k, v in ipairs(self.internals) do
		if v.type == "tabbutton" then
			width = width + v.width
		end
	end
	
	return width
	
end

--[[---------------------------------------------------------
	- func: GetHeightOfButtons()
	- desc: gets the height of one tab button
--]]---------------------------------------------------------
function tabs:GetHeightOfButtons()
	
	return self.tabheight
	
end

--[[---------------------------------------------------------
	- func: SwitchToTab(tabnumber)
	- desc: makes the specified tab the active tab
--]]---------------------------------------------------------
function tabs:SwitchToTab(tabnumber)
	
	for k, v in ipairs(self.children) do
		v.visible = false
	end
	
	self.tab = tabnumber
	self.children[self.tab].visible = true
	
end

--[[---------------------------------------------------------
	- func: SetScrollButtonSize(width, height)
	- desc: sets the size of the scroll buttons
--]]---------------------------------------------------------
function tabs:SetScrollButtonSize(width, height)

	for k, v in ipairs(self.internals) do
		
		if v.type == "scrollbutton" then
			v:SetSize(width, height)
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: SetPadding(paddint)
	- desc: sets the padding for the tab panel
--]]---------------------------------------------------------
function tabs:SetPadding(padding)

	self.padding = padding
	
end

--[[---------------------------------------------------------
	- func: SetPadding(paddint)
	- desc: gets the padding of the tab panel
--]]---------------------------------------------------------
function tabs:GetPadding()

	return self.padding
	
end

--[[---------------------------------------------------------
	- func: SetTabHeight(height)
	- desc: sets the height of the tab buttons
--]]---------------------------------------------------------
function tabs:SetTabHeight(height)

	self.tabheight = height
	
	for k, v in ipairs(self.internals) do
		
		if v.type == "tabbutton" then
			v:SetHeight(self.tabheight)
		end
		
	end
	
end