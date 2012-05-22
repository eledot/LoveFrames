--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- columnlistrow object
columnlistrow = class("columnlistrow", base)
columnlistrow:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: intializes the element
--]]---------------------------------------------------------
function columnlistrow:initialize(parent, data)

	self.type 			= "columnlistrow"
	self.parent			= parent
	self.colorindex		= self.parent.rowcolorindex
	self.font			= love.graphics.newFont(10)
	self.textcolor		= {0, 0, 0, 255}
	self.width 			= 80
	self.height 		= 25
	self.textx			= 5
	self.texty			= 5
	self.internal		= true
	self.columndata 	= data
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function columnlistrow:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
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
function columnlistrow:draw()

	local visible = self.visible
	
	if visible == false then
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
		skin.DrawColumnListRow(self)
	end

	local cwidth, cheight = self:GetParent():GetParent():GetColumnSize()
	local x = self.textx
	local textcolor = self.textcolor
	
	for k, v in ipairs(self.columndata) do
		love.graphics.setFont(self.font)
		love.graphics.setColor(unpack(textcolor))
		love.graphics.print(v, self.x + x, self.y + self.texty)
		x = x + cwidth
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function columnlistrow:mousepressed(x, y, button)

	if self.visible == false then
		return
	end
	
	if self.hover == true and button == "l" then
	
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function columnlistrow:mousereleased(x, y, button)

	if self.visible == false then
		return
	end
	
	if self.hover == true and button == "l" then
	
		local parent1 = self:GetParent()
		local parent2 = parent1:GetParent()
		
		if parent2.OnRowClicked then
			parent2.OnRowClicked(parent2, self, self.columndata)
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: SetTextPos(x, y)
	- desc: sets the positions of the object's text
--]]---------------------------------------------------------
function columnlistrow:SetTextPos(x, y)

	self.textx = x
	self.texty = y

end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the object's font
--]]---------------------------------------------------------
function columnlistrow:SetFont(font)

	self.font = font

end

--[[---------------------------------------------------------
	- func: GetFont()
	- desc: gets the object's font
--]]---------------------------------------------------------
function columnlistrow:GetFont()

	return self.font

end

--[[---------------------------------------------------------
	- func: GetColorIndex()
	- desc: gets the object's color index
--]]---------------------------------------------------------
function columnlistrow:GetColorIndex()

	return self.colorindex

end

--[[---------------------------------------------------------
	- func: SetTextColor(color)
	- desc: sets the object's text color
--]]---------------------------------------------------------
function columnlistrow:SetTextColor(color)

	self.textcolor = color

end