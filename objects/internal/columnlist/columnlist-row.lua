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
	self.font			= love.graphics.newFont(12)
	self.width 			= 80
	self.height 		= 25
	self.internal		= true
	self.columndata 	= data
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function columnlistrow:update(dt)
	
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
	
	if self.Update then
		self.Update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function columnlistrow:draw()

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
		skin.DrawColumnListRow(self)
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
	- func: keypressed(key)
	- desc: called when the player presses a key
--]]---------------------------------------------------------
function columnlistrow:keypressed(key, unicode)

	if self.visible == false then
		return
	end
	
end

--[[---------------------------------------------------------
	- func: keyreleased(key)
	- desc: called when the player releases a key
--]]---------------------------------------------------------
function columnlistrow:keyreleased(key)

	if self.visible == false then
		return
	end

end