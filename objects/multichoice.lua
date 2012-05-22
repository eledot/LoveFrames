--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- progress bar class
multichoice = class("multichoice", base)
multichoice:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function multichoice:initialize()

	self.type				= "multichoice"
	self.choice				= ""
	self.text				= "Select an option"
	self.width 				= 200
	self.height 			= 25
	self.listpadding		= 0
	self.listspacing		= 0
	self.listheight			= nil
	self.haslist			= false
	self.internal			= false
	self.choices			= {}
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function multichoice:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= nil then
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
function multichoice:draw()
	
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
		skin.DrawMultiChoice(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function multichoice:mousepressed(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local hover = self.hover
	local haslist = self.haslist
	
	if hover == true and haslist == false and button == "l" then
	
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
		self.haslist = true
		self.list = multichoicelist:new(self)
		loveframes.hoverobject = self
		
	end

end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function multichoice:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if visible == false then
		return
	end

end

--[[---------------------------------------------------------
	- func: AddChoice(choice)
	- desc: adds a choice to the current list of choices
--]]---------------------------------------------------------
function multichoice:AddChoice(choice)

	local choices = self.choices
	table.insert(choices, choice)
	
end

--[[---------------------------------------------------------
	- func: SetChoice(choice)
	- desc: sets the current choice
--]]---------------------------------------------------------
function multichoice:SetChoice(choice)

	self.choice = choice
	
end

--[[---------------------------------------------------------
	- func: SelectChoice(choice)
	- desc: selects a choice
--]]---------------------------------------------------------
function multichoice:SelectChoice(choice)

	self.choice = choice
	self.list:Close()
	
	if self.OnChoiceSelected then
		self.OnChoiceSelected(self, choice)
	end
	
end

--[[---------------------------------------------------------
	- func: SetListHeight(height)
	- desc: sets the height of the list of choices
--]]---------------------------------------------------------
function multichoice:SetListHeight(height)

	self.listheight = height
	
end

--[[---------------------------------------------------------
	- func: SetPadding(padding)
	- desc: sets the padding of the list of choices
--]]---------------------------------------------------------
function multichoice:SetPadding(padding)

	self.listpadding = padding
	
end

--[[---------------------------------------------------------
	- func: SetSpacing(spacing)
	- desc: sets the spacing of the list of choices
--]]---------------------------------------------------------
function multichoice:SetSpacing(spacing)

	self.listspacing = spacing
	
end

--[[---------------------------------------------------------
	- func: GetValue()
	- desc: gets the value (choice) of the object
--]]---------------------------------------------------------
function multichoice:GetValue()

	return self.choice
	
end

--[[---------------------------------------------------------
	- func: GetChoice()
	- desc: gets the current choice (same as get value)
--]]---------------------------------------------------------
function multichoice:GetChoice()

	return self.choice
	
end