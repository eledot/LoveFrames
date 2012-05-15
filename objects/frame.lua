--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- frame class
frame = class("frame", base)
frame:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function frame:initialize()
	
	self.type				= "frame"
	self.name 				= "Frame"
	self.width 				= 300
	self.height 			= 150
	self.clickx 			= 0
	self.clicky 			= 0
	self.internal			= false
	self.draggable 			= true
	self.screenlocked 		= false
	self.dragging 			= false
	self.modal				= false
	self.modalbackground	= false
	self.showclose			= true
	self.internals			= {}
	self.children 			= {}
	self.OnClose			= nil
	
	local close = closebutton:new()
	close.parent = self
	close:SetSize(16, 16)
	close.OnClick = function()
	
		self:Remove()
		
		if self.OnClose then
			self.OnClose(self)
		end
		
	end
	
	table.insert(self.internals, close)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the element
--]]---------------------------------------------------------
function frame:update(dt)
	
	local x, y = love.mouse.getPosition()
	local showclose = self.showclose
	local close = self.internals[1]
	
	if self.visible == false then
		if self.alwaysupdate == false then
			return
		end
	end
	
	close:SetPos(self.width - 22, 4)
	self:CheckHover()
	
	-- dragging check
	if self.dragging == true then
		self.x = x - self.clickx
		self.y = y - self.clicky
	end
	
	-- if screenlocked then keep within screen
	if self.screenlocked == true then
	
		local width = love.graphics.getWidth()
		local height = love.graphics.getHeight()
		
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
		
	end
	
	if self.modal == true then
		
		local numtooltips = 0 
		
		for k, v in ipairs(loveframes.base.children) do
			if v.type == "tooltip" then
				numtooltips = numtooltips + 1
			end
		end
		
		if self.draworder ~= #loveframes.base.children - numtooltips then
			self.modalbackground:MoveToTop()
			self:MoveToTop()
		end
		
	end
	
	for k, v in ipairs(self.internals) do
		v:update(dt)
	end
	
	for k, v in ipairs(self.children) do
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
function frame:draw()
	
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
		skin.DrawFrame(self)
	end
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
	-- loop through the object's children and draw them
	for k, v in ipairs(self.children) do
		v:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function frame:mousepressed(x, y, button)

	local width = self.width
	local height = self.height
	local selfcol = loveframes.util.BoundingBox(x, self.x, y, self.y, 1, self.width, 1, self.height)

	if self.visible == false then
		return
	end
	
	if selfcol == true then
	
		local top = self:IsTopCollision()
		
		-- initiate dragging if not currently dragging
		if self.dragging == false and top == true and button == "l" then
			if y < self.y + 25 and self.draggable == true then
				self.clickx = x - self.x
				self.clicky = y - self.y
				self.dragging = true
			end
		end
		
		if top == true and button == "l" then
			self:MakeTop()
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
function frame:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	-- exit the dragging state
	if self.dragging == true then
		self.dragging = false
	end
	
	for k, v in ipairs(self.internals) do
		v:mousereleased(x, y, button)
	end
	
	for k, v in ipairs(self.children) do
		v:mousereleased(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: SetName(name)
	- desc: sets the frame's name
--]]---------------------------------------------------------
function frame:SetName(name)

	self.name = name
	
end

--[[---------------------------------------------------------
	- func: GetName()
	- desc: gets the frame's name
--]]---------------------------------------------------------
function frame:GetName()

	return self.name
	
end

--[[---------------------------------------------------------
	- func: SetDraggable(true/false)
	- desc: sets whether the frame can be dragged or not
--]]---------------------------------------------------------
function frame:SetDraggable(bool)

	self.draggable = bool
	
end

--[[---------------------------------------------------------
	- func: GetDraggable()
	- desc: gets whether the frame can be dragged ot not
--]]---------------------------------------------------------
function frame:GetDraggable()

	return self.draggable
	
end


--[[---------------------------------------------------------
	- func: SetScreenLocked(bool)
	- desc: sets whether the frame can be moved passed the
			boundaries of the window or not
--]]---------------------------------------------------------
function frame:SetScreenLocked(bool)

	self.screenlocked = bool
	
end

--[[---------------------------------------------------------
	- func: GetScreenLocked()
	- desc: gets whether the frame can be moved passed the
			boundaries of window or not
--]]---------------------------------------------------------
function frame:GetScreenLocked()

	return self.screenlocked
	
end

--[[---------------------------------------------------------
	- func: ShowCloseButton(bool)
	- desc: sets whether the close button should be drawn
--]]---------------------------------------------------------
function frame:ShowCloseButton(bool)

	local close = self.internals[1]

	close.visible = bool
	self.showclose = bool
	
end

--[[---------------------------------------------------------
	- func: MakeTop()
	- desc: makes the object the top object in the drawing
			order
--]]---------------------------------------------------------
function frame:MakeTop()
	
	local x, y = love.mouse.getPosition()
	local children = loveframes.base.children
	local numchildren = #children
	local key = 0
	
	if numchildren == 1 then
		return
	end
	
	if children[numchildren] == self then
		return
	end
	
	-- make this the top element
	for k, v in ipairs(children) do
		if v == self then
			table.remove(loveframes.base.children, k)
			table.insert(loveframes.base.children, self)
			key = k
			break
		end
	end
	
	loveframes.base.children[key]:mousepressed(x, y, "l")
		
end

--[[---------------------------------------------------------
	- func: SetModal(bool)
	- desc: makes the object the top object in the drawing
			order
--]]---------------------------------------------------------
function frame:SetModal(bool)

	self.modal = bool
	
	if bool == true then
	
		if loveframes.modalobject ~= false then
			loveframes.modalobject:SetModal(false)
		end
	
		loveframes.modalobject = self
		
		if self.modalbackground == false then
			self.modalbackground = modalbackground:new(self)
			self.modal = true
		end
		
	else
	
		if loveframes.modalobject == self then
	
			loveframes.modalobject = false
			
			if self.modalbackground ~= false then
				self.modalbackground:Remove()
				self.modalbackground = false
				self.modal = false
			end
			
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: GetModal()
	- desc: gets whether or not the object is in a modal
			state
--]]---------------------------------------------------------
function frame:GetModal()

	return self.modal
	
end

--[[---------------------------------------------------------
	- func: SetVisible(bool)
	- desc: set's whether the object is visible or not
--]]---------------------------------------------------------
function frame:SetVisible(bool)

	self.visible = bool
	
	for k, v in ipairs(self.children) do
		v:SetVisible(bool)
	end

	if self.showclose == true then
		self.internals[1].visible = bool
	end
	
end