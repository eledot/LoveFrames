--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- columnlist object
columnlist = class("columnlist", base)
columnlist:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: intializes the element
--]]---------------------------------------------------------
function columnlist:initialize()
	
	self.type 			= "columnlist"
	self.width 			= 300
	self.height 		= 100
	self.internal		= false
	self.children		= {}
	self.internals 		= {}
	self.OnRowClicked 	= nil
	self.OnScroll		= nil

	local list = columnlistarea:new(self)
	table.insert(self.internals, list)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function columnlist:update(dt)
	
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
	
	for k, v in ipairs(self.children) do
		v:update(dt)
	end
	
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
function columnlist:draw()

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
		skin.DrawColumnList(self)
	end
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
	for k, v in ipairs(self.children) do
		v:draw()
	end

end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function columnlist:mousepressed(x, y, button)

	if self.hover == true and button == "l" then
	
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
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
function columnlist:mousereleased(x, y, button)

	for k, v in ipairs(self.internals) do
		v:mousereleased(x, y, button)
	end
	
	for k, v in ipairs(self.children) do
		v:mousereleased(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: keypressed(key)
	- desc: called when the player presses a key
--]]---------------------------------------------------------
function columnlist:keypressed(key, unicode)

	for k, v in ipairs(self.internals) do
		v:keypressed(key, unicode)
	end
	
	for k, v in ipairs(self.children) do
		v:keypressed(key, unicode)
	end
	
end

--[[---------------------------------------------------------
	- func: keyreleased(key)
	- desc: called when the player releases a key
--]]---------------------------------------------------------
function columnlist:keyreleased(key)

	for k, v in ipairs(self.internals) do
		v:keyreleased(key)
	end
	
	for k, v in ipairs(self.children) do
		v:keyreleased(key)
	end
	
end

--[[---------------------------------------------------------
	- func: Adjustchildren()
	- desc: adjusts the width of the object's children
--]]---------------------------------------------------------
function columnlist:AdjustColumns()

	local width = self.width
	local bar = self.internals[1].bar
	
	if bar == true then
		width = width - 16
	end
	
	local children = self.children
	local numchildren = #children
	local columnwidth = width/numchildren
	local x = 0
	
	for k, v in ipairs(children) do
		if bar == true then
			v:SetWidth(columnwidth)
		else
			v:SetWidth(columnwidth)
		end
		v:SetPos(x, 0)
		x = x + columnwidth
	end
	
end

--[[---------------------------------------------------------
	- func: AddColumn(name)
	- desc: gives the object a new column with the specified
			name
--]]---------------------------------------------------------
function columnlist:AddColumn(name)

	columnlistheader:new(name, self)
	self:AdjustColumns()
	
	self.internals[1]:SetSize(self.width, self.height)
	self.internals[1]:SetPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: AddRow(...)
	- desc: adds a row of data to the object's list
--]]---------------------------------------------------------
function columnlist:AddRow(...)

	self.internals[1]:AddRow(arg)
	
end

--[[---------------------------------------------------------
	- func: Getchildrenize()
	- desc: gets the size of the object's children
--]]---------------------------------------------------------
function columnlist:GetColumnSize()

	if #self.children > 0 then
		return self.children[1].width, self.children[1].height
	else
		return 0, 0
	end
	
end

--[[---------------------------------------------------------
	- func: SetSize(width, height)
	- desc: sets the object's size
--]]---------------------------------------------------------
function columnlist:SetSize(width, height)
	
	self.width = width
	self.height = height
	
	self.internals[1]:SetSize(width, height)
	self.internals[1]:SetPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: SetWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function columnlist:SetWidth(width)
	
	self.width = width
	
	self.internals[1]:SetSize(width)
	self.internals[1]:SetPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function columnlist:SetHeight(height)
	
	self.height = height
	
	self.internals[1]:SetSize(height)
	self.internals[1]:SetPos(0, 0)
	
end

--[[---------------------------------------------------------
	- func: SetMaxColorIndex(num)
	- desc: sets the object's max color index for
			alternating row colors
--]]---------------------------------------------------------
function columnlist:SetMaxColorIndex(num)

	self.internals[1].colorindexmax = num
	
end