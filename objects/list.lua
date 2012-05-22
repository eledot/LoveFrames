--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- list class
list = class("list", base)
list:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function list:initialize()
	
	self.type			= "list"
	self.display		= "vertical"
	self.width 			= 300
	self.height 		= 150
	self.clickx 		= 0
	self.clicky 		= 0
	self.padding		= 0
	self.spacing		= 0
	self.offsety		= 0
	self.offsetx		= 0
	self.extra			= 0
	self.internal		= false
	self.hbar			= false
	self.vbar			= false
	self.autoscroll		= false
	self.internals		= {}
	self.children 		= {}
	self.OnScroll		= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function list:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local internals = self.internals
	local children = self.children
	local display = self.display
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	self:CheckHover()
	
	for k, v in ipairs(internals) do
		v:update(dt)
	end
	
	for k, v in ipairs(children) do
		v:update(dt)
		v:SetClickBounds(self.x, self.y, self.width, self.height)
		v.y = (v.parent.y + v.staticy) - self.offsety
		v.x = (v.parent.x + v.staticx) - self.offsetx
		
		if display == "vertical" then
			if v.lastheight ~= v.height then
				self:CalculateSize()
				self:RedoLayout()
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
function list:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount

	local internals = self.internals
	local children = self.children
	
	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
		
	if self.Draw ~= nil then
		self.Draw(self)
	else
		skin.DrawList(self)
	end
	
	local stencilfunc = function() love.graphics.rectangle("fill", self.x, self.y, self.width, self.height) end
	local stencil = love.graphics.newStencil(stencilfunc)
	
	love.graphics.setStencil(stencil)
		
	for k, v in ipairs(children) do
		local col = loveframes.util.BoundingBox(self.x, v.x, self.y, v.y, self.width, v.width, self.height, v.height)
		if col == true then
			v:draw()
		end
	end
	
	love.graphics.setStencil()
	
	for k, v in ipairs(internals) do
		v:draw()
	end
	
	if self.Draw == nil then
		skin.DrawOverList(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function list:mousepressed(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local toplist = self:IsTopList()
	local hover = self.hover
	local vbar = self.vbar
	local hbar = self.hbar
	local children = self.children
	local internals = self.internals
	
	if hover == true and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
	end
	
	if vbar == true or hbar == true then
	
		if toplist == true then
	
			local bar = self:GetScrollBar()
			
			if button == "wu" then
				bar:Scroll(-5)
			elseif button == "wd" then
				bar:Scroll(5)
			end
			
		end
		
	end
	
	for k, v in ipairs(internals) do
		v:mousepressed(x, y, button)
	end
	
	for k, v in ipairs(children) do
		v:mousepressed(x, y, button)
	end

end

--[[---------------------------------------------------------
	- func: AddItem(object)
	- desc: adds an item to the object
--]]---------------------------------------------------------
function list:AddItem(object)
	
	if object.type == "frame" then
		return
	end

	local children = self.children
	
	object:Remove()
	object.parent = self
	
	table.insert(children, object)
	
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: RemoveItem(object)
	- desc: removes an item from the object
--]]---------------------------------------------------------
function list:RemoveItem(object)

	object:Remove()
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: CalculateSize()
	- desc: calculates the size of the object's children
--]]---------------------------------------------------------
function list:CalculateSize()
	
	local numitems = #self.children
	local height = self.height
	local width = self.width
	local padding = self.padding
	local spacing = self.spacing
	local itemheight = self.padding
	local itemwidth	= self.padding
	local display = self.display
	local vbar = self.vbar
	local hbar = self.hbar
	local internals = self.internals
	local children = self.children
	
	if display == "vertical" then
	
		for k, v in ipairs(self.children) do
			itemheight = itemheight + v.height + spacing
		end
		
		self.itemheight = (itemheight - spacing) + padding
		
		local itemheight = self.itemheight
		
		if itemheight > height then
		
			self.extra = itemheight - height
			
			if vbar == false then
				local scrollbar = scrollbody:new(self, display)
				table.insert(internals, scrollbar)
				self.vbar = true
				self:GetScrollBar().autoscroll = self.autoscroll
			end
			
		else
			
			if vbar == true then
				local bar = internals[1]
				bar:Remove()
				self.vbar = false
				self.offsety = 0
			end
			
		end
		
	elseif display == "horizontal" then
		
		for k, v in ipairs(children) do
			itemwidth = itemwidth + v.width + spacing
		end
		
		self.itemwidth = (itemwidth - spacing) + padding
		
		local itemwidth = self.itemwidth
				
		if itemwidth > width then
		
			self.extra = itemwidth - width
			
			if hbar == false then
				local scrollbar = scrollbody:new(self, display)
				table.insert(internals, scrollbar)
				self.hbar = true
				self:GetScrollBar().autoscroll = self.autoscroll
			end
			
		else
			
			if hbar == true then
				local bar = internals[1]
				bar:Remove()
				self.hbar = false
				self.offsetx = 0
			end
			
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: RedoLayout()
	- desc: used to redo the layour of the object
--]]---------------------------------------------------------
function list:RedoLayout()
	
	local children = self.children
	local padding = self.padding
	local spacing = self.spacing
	local starty = padding
	local startx = padding
	local vbar = self.vbar
	local hbar = self.hbar
	local display = self.display
	
	if #children > 0 then
	
		for k, v in ipairs(children) do
	
			if display == "vertical" then
			
				local height = v.height
				
				v.staticx = padding
				v.staticy = starty
				v.lastheight = v.height
				
				if vbar == true then
					if v.width + padding > (self.width - self.internals[1].width) then
						v:SetWidth((self.width - self.internals[1].width) - (padding*2))
					end
					if v.retainsize == false then
						v:SetWidth((self.width - self.internals[1].width) - (padding*2))
					end
					self.internals[1].staticx = self.width - self.internals[1].width
					self.internals[1].height = self.height
				else
					if v.retainsize == false then
						v:SetWidth(self.width - (padding*2))
					end
				end
				
				starty = starty + v.height
				starty = starty + spacing
				
			elseif display == "horizontal" then
				
				v.staticx = startx
				v.staticy = padding
				
				if hbar == true then
					if v.height + padding > (self.height - self.internals[1].height) then
						v:SetHeight((self.height - self.internals[1].height) - (padding*2))
					end
					if v.retainsize == false then
						v:SetHeight((self.height - self.internals[1].height) - (padding*2))
					end
					self.internals[1].staticy = self.height - self.internals[1].height
					self.internals[1].width = self.width
				else
					if v.retainsize == false then
						v:SetHeight(self.height - (padding*2))
					end
				end
				
				startx = startx + v.width
				startx = startx + spacing
				
			end
			
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: SetDisplayType(type)
	- desc: sets the object's display type
--]]---------------------------------------------------------
function list:SetDisplayType(type)

	local children = self.children
	local numchildren = #children
	
	self.display = type
	
	self.internals = {}
	self.vbar = false
	self.hbar = false
	self.offsetx = 0
	self.offsety = 0
	
	if numchildren > 0 then
		self:CalculateSize()
		self:RedoLayout()
	end

end

--[[---------------------------------------------------------
	- func: GetDisplayType()
	- desc: gets the object's display type
--]]---------------------------------------------------------
function list:GetDisplayType()

	return self.display
	
end

--[[---------------------------------------------------------
	- func: SetPadding(amount)
	- desc: sets the object's padding
--]]---------------------------------------------------------
function list:SetPadding(amount)

	local children = self.children
	local numchildren = #children
	
	self.padding = amount
	
	if numchildren > 0 then
		self:CalculateSize()
		self:RedoLayout()
	end
	
end

--[[---------------------------------------------------------
	- func: SetSpacing(amount)
	- desc: sets the object's spacing
--]]---------------------------------------------------------
function list:SetSpacing(amount)

	local children = self.children
	local numchildren = #children
	
	self.spacing = amount
	
	if numchildren > 0 then
		self:CalculateSize()
		self:RedoLayout()
	end
	
end

--[[---------------------------------------------------------
	- func: Clear()
	- desc: removes all of the object's children
--]]---------------------------------------------------------
function list:Clear()
	
	self.children = {}
	self:CalculateSize()
	self:RedoLayout()

end

--[[---------------------------------------------------------
	- func: SetWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function list:SetWidth(width)

	self.width = width
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function list:SetHeight(height)

	self.height = height
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: GetSize()
	- desc: gets the object's size
--]]---------------------------------------------------------
function list:SetSize(width, height)

	self.width = width
	self.height = height
	self:CalculateSize()
	self:RedoLayout()
	
end

--[[---------------------------------------------------------
	- func: GetScrollBar()
	- desc: gets the object's scroll bar
--]]---------------------------------------------------------
function list:GetScrollBar()

	local vbar = self.vbar
	local hbar = self.hbar
	
	if vbar == true or hbar == true then
		local scrollbar = self.internals[1].internals[1].internals[1]
		return scrollbar
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: SetAutoScroll(bool)
	- desc: sets whether or not the list's scrollbar should
			auto scroll to the bottom when a new object is
			added to the list
--]]---------------------------------------------------------
function list:SetAutoScroll(bool)

	self.autoscroll = bool
	
	if self:GetScrollBar() ~= false then
		self:GetScrollBar().autoscroll = bool
	end
	
end