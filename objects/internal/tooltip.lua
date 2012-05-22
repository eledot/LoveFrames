--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- tooltip clas
tooltip = class("tooltip", base)
tooltip:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function tooltip:initialize(object, text, width)

	local width = width or 0
	
	self.type			= "tooltip"
	self.parent			= loveframes.base
	self.object			= object or nil
	self.width 			= width or 0
	self.height 		= 0
	self.padding		= 5
	self.xoffset		= 0
	self.yoffset		= 0
	self.internal		= true
	self.show			= false
	self.followcursor	= true
	self.alwaysupdate	= true
	
	self.text = loveframes.Create("text")
	self.text:Remove()
	self.text.parent = self
	self.text:SetText(text or "")
	self.text:SetWidth(width or 0)
	self.text:SetPos(0, 0)
	
	table.insert(loveframes.base.children, self)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function tooltip:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local text = self.text
	
	self.width = text.width + self.padding*2
	self.height = text.height + self.padding*2
	
	local object = self.object
	local draworder = self.draworder
	
	if object then
	
		local hover = object.hover
		local odraworder = object.draworder
		
		self.show = object.hover
		self.visible = self.show
		
		local show = self.show
		
		if show == true then
			if self.followcursor == true then
				local x, y = love.mouse.getPosition()
				local top = self:IsTopChild()
				self.x = x + self.xoffset
				self.y = y - self.height + self.yoffset
			else
				self.x = object.x + self.xoffset
				self.y = object.y - self.height + self.yoffset
			end
			
			if top == false then
				self:MoveToTop()
			end
			
			text:SetPos(self.padding, self.padding)
			
		end
		
		if odraworder > draworder then
			self:Remove()
			table.insert(loveframes.base.children, self)
		end
		
	end
	
	text:update(dt)
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function tooltip:draw()
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount
	
	local show = self.show
	local text = self.text
	
	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
	
	if show == true then
	
		if self.Draw ~= nil then
			self.Draw(self)
		else
			skin.DrawToolTip(self)
		end
	
		text:draw()
		
	end
	
end

--[[---------------------------------------------------------
	- func: SetFollowCursor(bool)
	- desc: sets whether or not the tooltip should follow the
			cursor
--]]---------------------------------------------------------
function tooltip:SetFollowCursor(bool)

	self.followcursor = bool
	
end

--[[---------------------------------------------------------
	- func: SetObject(object)
	- desc: sets the tooltip's object
--]]---------------------------------------------------------
function tooltip:SetObject(object)

	self.object = object
	
end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the tooltip's text
--]]---------------------------------------------------------
function tooltip:SetText(text)

	self.text:SetText(text)
	
end

--[[---------------------------------------------------------
	- func: SetTextMaxWidth(text)
	- desc: sets the tooltip's text max width
--]]---------------------------------------------------------
function tooltip:SetTextMaxWidth(width)

	self.text:SetMaxWidth(width)
	
end

--[[---------------------------------------------------------
	- func: SetOffsets(xoffset, yoffset)
	- desc: sets the tooltip's x and y offset
--]]---------------------------------------------------------
function tooltip:SetOffsets(xoffset, yoffset)

	self.xoffset = xoffset
	self.yoffset = yoffset
	
end

--[[---------------------------------------------------------
	- func: SetPadding(padding)
	- desc: sets the tooltip's padding
--]]---------------------------------------------------------
function tooltip:SetPadding(padding)

	self.padding = padding
	
end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the tooltip's font
--]]---------------------------------------------------------
function tooltip:SetFont(font)

	self.text:SetFont(font)
	
end