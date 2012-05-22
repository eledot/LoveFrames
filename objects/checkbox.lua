--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- button clas
checkbox = class("checkbox", base)
checkbox:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function checkbox:initialize()

	self.type			= "checkbox"
	self.width 			= 0
	self.height 		= 0
	self.boxwidth 		= 20
	self.boxheight 		= 20
	self.font			= love.graphics.newFont(12)
	self.checked		= false
	self.lastvalue		= false
	self.internal		= false
	self.down			= true
	self.internals		= {}
	self.OnChanged		= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function checkbox:update(dt)
	
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
	
	if self.internals[1] then
	
		self.width = self.boxwidth + 5 + self.internals[1].width
		
		if self.internals[1].height == self.boxheight then
			self.height = self.boxheight
		else
			if self.internals[1].height > self.boxheight then
				self.height = self.internals[1].height
			else
				self.height = self.boxheight
			end
		end
		
	else
	
		self.width = self.boxwidth
		self.height = self.boxheight
		
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
function checkbox:draw()
	
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
		skin.DrawCheckBox(self)
	end
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function checkbox:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	
	if hover == true and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
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
function checkbox:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local checked = self.checked
	
	if hover == true and button == "l" then
	
		if checked == true then
			self.checked = false
		else
			self.checked = true
		end
		
		if self.OnChanged then
			self.OnChanged(self)
		end
		
	end
		
end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function checkbox:SetText(text)

	if text ~= "" then
		
		self.internals = {}
		
		local textobject = loveframes.Create("text")
		textobject:Remove()
		textobject.parent = self
		textobject.collide = false
		textobject:SetFont(self.font)
		textobject:SetText(text)
		textobject.Update = function(object, dt)
			if object.height > self.boxheight then
				object:SetPos(self.boxwidth + 5, 0)
			else
				object:SetPos(self.boxwidth + 5, self.boxheight/2 - object.height/2)
			end
		end
		
		table.insert(self.internals, textobject)
		
	else
	
		self.width = self.boxwidth
		self.height = self.boxheight
		self.internals = {}
		
	end
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function checkbox:GetText()

	local internals = self.internals
	local text = internals[1]
	
	if text then
		return text.text
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: SetSize(width, height)
	- desc: sets the object's size
--]]---------------------------------------------------------
function checkbox:SetSize(width, height)

	self.boxwidth = width
	self.boxheight = height
	
end

--[[---------------------------------------------------------
	- func: SetWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function checkbox:SetWidth(width)

	self.boxwidth = width
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function checkbox:SetHeight(height)

	self.boxheight = height
	
end

--[[---------------------------------------------------------
	- func: SetChecked(bool)
	- desc: sets whether the object is checked or not
--]]---------------------------------------------------------
function checkbox:SetChecked(bool)

	self.checked = bool
	
	if self.OnChanged then
		self.OnChanged(self)
	end
	
end

--[[---------------------------------------------------------
	- func: GetChecked()
	- desc: gets whether the object is checked or not
--]]---------------------------------------------------------
function checkbox:GetChecked()

	return self.checked
	
end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the font of the object's text
--]]---------------------------------------------------------
function checkbox:SetFont(font)

	local internals = self.internals
	local text = internals[1]
	
	self.font = font
	
	if text then
		text:SetFont(font)
	end
	
end