--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- tabbutton clas
tabbutton = class("tabbutton", base)
tabbutton:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function tabbutton:initialize(parent, text, tabnumber, tip, image)

	self.type			= "tabbutton"
	self.text 			= text
	self.tabnumber		= tabnumber
	self.parent			= parent
	self.staticx		= 0
	self.staticy		= 0
	self.width 			= 50
	self.height 		= 25
	self.internal		= true
	self.down			= false
	self.image			= nil
	
	if tip then
		local tooltip = tooltip:new(self, tip)
		tooltip:SetFollowCursor(false)
	end
	
	if image then
		self:SetImage(image)
	end
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function tabbutton:update(dt)
	
	if self.visible == false then
		if self.alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	self:SetClickBounds(self.parent.x, self.parent.y, self.parent.width, self.parent.height)
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function tabbutton:draw()
	
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
		skin.DrawTabButton(self)
	end
	
	local font = love.graphics.getFont()
	local width = font:getWidth(self.text)
	local image = self.image
	
	if image then
		local imagewidth = image:getWidth()
		self.width = imagewidth + 15 + width
	else
		self.width = 10 + width
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function tabbutton:mousepressed(x, y, button)

	
	if self.visible == false then
		return
	end
	
	if self.hover == true and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	
		self.down = true
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function tabbutton:mousereleased(x, y, button)
	
	if self.visible == false then
		return
	end
	
	local pinternals = self.parent.internals
	
	if self.hover == true and self.down == true then
	
		if button == "l" then
			self.parent:SwitchToTab(self.tabnumber)
		end
		
	end
	
	self.down = false

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function tabbutton:SetText(text)

	self.text = text
	
end

--[[---------------------------------------------------------
	- func: SetImage(image)
	- desc: adds an image to the object
--]]---------------------------------------------------------
function tabbutton:SetImage(image)

	if type(image) == "string" then
		self.image = love.graphics.newImage(image)
	else
		self.image = image
	end
	
end