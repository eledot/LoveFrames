--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

-- textinput clas
textinput = class("textinput", base)
textinput:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------

function textinput:initialize()

	self.type			= "textinput"
	self.text			= ""
	self.keydown		= "none"
	self.font			= love.graphics.newFont(12)
	self.textcolor		= {0, 0, 0, 255}
	self.width			= 200
	self.height			= 25
	self.delay			= 0
	self.xoffset		= 0
	self.blink			= 0
	self.blinknum		= 0
	self.blinkx			= 0
	self.blinky			= 0
	self.textx			= 0
	self.texty			= 0
	self.textxoffset	= 0
	self.textyoffset	= 0
	self.unicode		= 0
	self.showblink 		= true
	self.focus			= false
	self.internal		= false
	self.OnEnter		= nil
	self.OnTextEntered	= nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function textinput:update(dt)

	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if visible == false then
		if alwaysupdate == false then
			return
		end
	end
	
	local time = love.timer.getTime()
	local keydown = self.keydown
	local unicode = self.unicode
	
	self:CheckHover()
	
	-- move to parent if there is a parent
	if self.parent ~= loveframes.base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if keydown ~= "none" then
		if time > self.delay then
			self:RunKey(keydown, unicode)
			self.delay = time + 0.02
		end
	end
	
	self:PositionText()
	self:RunBlink()
	
	if self.Update then
		self.Update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function textinput:draw()

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	loveframes.drawcount = loveframes.drawcount + 1
	self.draworder = loveframes.drawcount
	
	local font = self.font
	local textcolor = self.textcolor
	local text = self.text
	local textx = self.textx
	local texty = self.texty
	
	-- skin variables
	local index	= loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = loveframes.skins.available[selfskin] or loveframes.skins.available[index] or loveframes.skins.available[defaultskin]
	
	local stencilfunc = function() love.graphics.rectangle("fill", self.x, self.y, self.width, self.height) end
	local stencil = love.graphics.newStencil(stencilfunc)
	love.graphics.setStencil(stencil)
	
	if self.Draw ~= nil then
		self.Draw(self)
	else
		skin.DrawTextInput(self)
	end
	
	love.graphics.setFont(font)
	love.graphics.setColor(unpack(textcolor))
	love.graphics.print(text, textx, self.texty)
	
	love.graphics.setStencil()
	
	if self.Draw == nil then
		skin.DrawOverTextInput(self)
	end

end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function textinput:mousepressed(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	if button ~= "l" then
		return
	end
	
	local hover = self.hover
	
	if hover == true then
	
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
		self.focus = true
		
	else
	
		self.focus = false
		
	end
	
	self:GetTextCollisions(x, y)
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function textinput:mousereleased(x, y, button)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	if button ~= "l" then
		return
	end
	
end

--[[---------------------------------------------------------
	- func: keypressed(key)
	- desc: called when the player presses a key
--]]---------------------------------------------------------
function textinput:keypressed(key, unicode)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	local time = love.timer.getTime()
	
	self.delay = time + 0.80
	self.keydown = key
	self:RunKey(key, unicode)
	
end

--[[---------------------------------------------------------
	- func: keyreleased(key)
	- desc: called when the player releases a key
--]]---------------------------------------------------------
function textinput:keyreleased(key)

	local visible = self.visible
	
	if visible == false then
		return
	end
	
	self.keydown = "none"
	
end

--[[---------------------------------------------------------
	- func: RunKey(key, unicode)
	- desc: runs a key event on the object
--]]---------------------------------------------------------
function textinput:RunKey(key, unicode)
	
	local visible = self.visible
	local focus = self.focus
	
	if visible == false then
		return
	end
	
	if self.focus == false then
		return
	end
	
	local text = self.text
	local ckey = ""
	local font = self.font
	local swidth = self.width
	local twidth = font:getWidth(self.text)
	local textxoffset = self.textxoffset
	local blinkx = self.blinkx
	local blinknum = self.blinknum
	
	self.unicode = unicode
	
	if key == "left" then
		self:MoveBlinker(-1)
		if blinkx <= self.x  and blinknum ~= 0 then
			local width = self.font:getWidth(self.text:sub(blinknum, blinknum + 1))
			self.xoffset = self.xoffset + width
		elseif blinknum == 0 and self.xoffset ~= 0 then
			self.xoffset = 0
		end
	elseif key == "right" then
		self:MoveBlinker(1)
		if blinkx >= self.x + swidth and blinknum ~= #self.text then
			local width = self.font:getWidth(self.text:sub(blinknum, blinknum))
			self.xoffset = self.xoffset - width*2
		elseif blinknum == #self.text and self.xoffset ~= ((0 - font:getWidth(self.text)) + swidth) and font:getWidth(self.text) + self.textxoffset > self.width then
			self.xoffset = ((0 - font:getWidth(self.text)) + swidth)
		end
	end
	
	-- key input checking system
	if key == "backspace" then
		if text ~= "" then
			self.text = self:RemoveFromeText(blinknum)
			self:MoveBlinker(-1)
		end
	elseif key == "return" then
		if self.OnEnter ~= nil then
			self.OnEnter(self, self.text)
		end
	else
		if unicode > 31 and unicode < 127 then
			ckey = string.char(unicode)
			if blinknum ~= 0 and blinknum ~= #self.text then
				self.text = self:AddIntoText(unicode, blinknum)
				self:MoveBlinker(1)
			elseif blinknum == #self.text then
				self.text = text .. ckey
				self:MoveBlinker(1)
			elseif blinknum == 0 then
				self.text = self:AddIntoText(unicode, blinknum)
				self:MoveBlinker(1)
			end
			
			if self.OnTextEntered then
				self.OnTextEntered(self, ckey)
			end
			
		end
	end
	
	if key == "backspace" then
		local cwidth = font:getWidth(self.text:sub(#self.text))
		if self.xoffset ~= 0 then
			self.xoffset = self.xoffset + cwidth
		end
	else
		local cwidth = font:getWidth(ckey)
		-- swidth - 1 is for the "-" character
		if (twidth + textxoffset) >= (swidth - 1) then
			self.xoffset = self.xoffset - cwidth
		end
	end
	
end

--[[---------------------------------------------------------
	- func: MoveBlinker(num, exact)
	- desc: moves the object's blinker
--]]---------------------------------------------------------
function textinput:MoveBlinker(num, exact)

	if exact == nil or false then
		self.blinknum = self.blinknum + num
	else
		self.blinknum = num
	end
	
	if self.blinknum > #self.text then
		self.blinknum = #self.text
	elseif self.blinknum < 0 then
		self.blinknum = 0
	end
	
	self.showblink = true
	
end

--[[---------------------------------------------------------
	- func: RunBlink()
	- desc: runs a blink on the object's blinker
--]]---------------------------------------------------------
function textinput:RunBlink()

	local time = love.timer.getTime()
	local blink = self.blink
	local blinknum = self.blinknum
	local text = self.text
	
	if self.xoffset > 0 then
		self.xoffset = 0
	end
	
	if blink < time then
		if self.showblink == true then
			self.showblink = false
		else
			self.showblink = true
		end
		self.blink = time + 0.50
	end
	
	local width = 0
	
	for i=1, blinknum do
		width = width + self.font:getWidth(text:sub(i, i))
	end
	
	self.blinkx = self.textx + width
	self.blinky	= self.texty
	
end

--[[---------------------------------------------------------
	- func: AddIntoText(t, p)
	- desc: adds text into the object's text a given 
			position
--]]---------------------------------------------------------
function textinput:AddIntoText(t, p)

	local s = self.text
	local part1 = s:sub(1, p)
	local part2 = s:sub(p + 1)
	local new = part1 .. string.char(t) .. part2
	
	return new
	
end

--[[---------------------------------------------------------
	- func: RemoveFromeText(p)
	- desc: removes text from the object's text a given 
			position
--]]---------------------------------------------------------
function textinput:RemoveFromeText(p)

	local blinknum = self.blinknum
	local text = self.text
	
	if blinknum ~= 0 then
		local s = text
		local part1 = s:sub(1, p - 1)
		local part2 = s:sub(p + 1)
		local new = part1 .. part2
		return new
	end
	
	return text
	
end

--[[---------------------------------------------------------
	- func: GetTextCollisions(x, y)
	- desc: gets text collisions with the mouse
--]]---------------------------------------------------------
function textinput:GetTextCollisions(x, y)

	local font = self.font
	local text = self.text
	local xpos = 0
	
	for i=1, #text do
		
		local width = font:getWidth(text:sub(i, i))
		local height = font:getHeight(text:sub(i, i))
		local tx = self.textx + xpos
		local ty = self.texty
		local col = loveframes.util.BoundingBox(tx, x, ty, y, width, 1, height, 1)
		xpos = xpos + width
		
		if col == true then
			self:MoveBlinker(i - 1, true)
			break
		end
		
		if x < tx then
			self:MoveBlinker(0, true)
		end
		
		if x > (tx + width) then
			self:MoveBlinker(#self.text, true)
		end
		
	end
	
end

--[[---------------------------------------------------------
	- func: PositionText()
	- desc: positions the object's text
--]]---------------------------------------------------------
function textinput:PositionText()

	self.textx = self.x + self.xoffset + self.textxoffset
	self.texty = self.y + self.textyoffset
	
end

--[[---------------------------------------------------------
	- func: SetTextOffsetX(num)
	- desc: sets the object's text x offset
--]]---------------------------------------------------------
function textinput:SetTextOffsetX(num)

	self.textxoffset = num
	
end

--[[---------------------------------------------------------
	- func: SetTextOffsetY(num)
	- desc: sets the object's text y offset
--]]---------------------------------------------------------
function textinput:SetTextOffsetY(num)

	self.textyoffset = num
	
end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the object's font
--]]---------------------------------------------------------
function textinput:SetFont(font)

	self.font = font
	
end

--[[---------------------------------------------------------
	- func: SetTextColor(color)
	- desc: sets the object's text color
--]]---------------------------------------------------------
function textinput:SetTextColor(color)

	self.textcolor = color
	
end

--[[---------------------------------------------------------
	- func: SetFocus(focus)
	- desc: sets the object's focus
--]]---------------------------------------------------------
function textinput:SetFocus(focus)

	self.focus = focus
	
end


--[[---------------------------------------------------------
	- func: GetFocus
	- desc: gets the object's focus
--]]---------------------------------------------------------
function textinput:GetFocus()

	return self.focus
	
end

--[[---------------------------------------------------------
	- func: GetBlinkerVisibility
	- desc: gets the object's blinker visibility
--]]---------------------------------------------------------
function textinput:GetBlinkerVisibility()

	return self.showblink
	
end