--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

--[[------------------------------------------------
	-- note: the text wrapping of this object is
			 experimental and not final
--]]------------------------------------------------
-- text class
text = class("text", base)
text:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function text:initialize()

	self.type			= "text"
	self.text 			= ""
	self.font			= love.graphics.newFont(12)
	self.width			= 5
	self.height			= 5
	self.maxw			= 0
	self.lines			= 1
	self.text			= {}
	self.original		= {}
	self.internal		= false
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function text:update(dt)

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
function text:draw()

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
		skin.DrawText(self)
	end

	self:DrawText()
	
end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function text:SetText(t)

	local dtype = type(t)
	local maxw = self.maxw
	local font = self.font
	local inserts = {}
	local tdata, prevcolor
	
	self.text = {}
	
	if dtype == "string" then
		tdata = {t}
		self.original = {t}
	elseif dtype == "number" then
		tdata = {tostring(t)}
		self.original = {tostring(t)}
	elseif dtype == "table" then
		tdata = t
		self.original = t
	else
		return
	end
	
	for k, v in ipairs(tdata) do
		
		local dtype = type(v)
		
		if k == 1 and dtype ~= "table" then
			prevcolor = {0, 0, 0, 255}
		end
		
		if dtype == "table" then
			prevcolor = v
		elseif dtype == "number" then
			
			table.insert(self.text, {color = prevcolor, text = tostring(v)})
			
		elseif dtype == "string" then
			
			v = v:gsub(string.char(9), "    ")
			v = v:gsub("\n", "")
			
			local parts = loveframes.util.SplitSring(v, " ")
					
			for i, j in ipairs(parts) do
				table.insert(self.text, {color = prevcolor, text = j})
			end
			
		end
		
	end
	
	if maxw > 0 then
	
		for k, v in ipairs(self.text) do
					
			local data = v.text
			local width = font:getWidth(data)
			local curw = 0
			local new = ""
			local key = k
			
			if width > maxw then
					
				table.remove(self.text, k)
				
				for n=1, #data do
							
					local item = data:sub(n, n)
					local itemw = font:getWidth(item)
					
					if n ~= #data then
					
						if (curw + itemw) > maxw then
							table.insert(inserts, {key = key, color = v.color, text = new})
							new = item
							curw = 0 + itemw
							key = key + 1
						else
							new = new .. item
							curw = curw + itemw
						end
						
					else
						new = new .. item
						table.insert(inserts, {key = key, color = v.color, text = new})
					end
							
				end
						
			end
					
		end
		
	end
	
	for k, v in ipairs(inserts) do
		table.insert(self.text, v.key, {color = v.color, text = v.text})
	end
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function text:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: Format()
	- desc: formats the text
--]]---------------------------------------------------------
function text:DrawText()

	local textdata = self.text
	local maxw = self.maxw
	local font = self.font
	local height = font:getHeight("a")
	local twidth = 0
	local drawx = 0
	local drawy = 0
	local lines = 0
	local totalwidth = 0
	local prevtextwidth
	local x = self.x
	local y = self.y
	
	for k, v in ipairs(textdata) do
		
		local text = v.text
		local color = v.color
		
		if type(text) == "string" then
		
			local width = font:getWidth(text)
			totalwidth = totalwidth + width
			
			if maxw > 0 then
			
				if k ~= 1 then
				
					if (twidth + width) > maxw then
						twidth = 0 + width
						drawx = 0
						drawy = drawy + height
					else
						twidth = twidth + width
						drawx = drawx + prevtextwidth
					end
					
				else
					twidth = twidth + width
				end
				
				prevtextwidth = width
				
				love.graphics.setFont(font)
				love.graphics.setColor(unpack(color))
				love.graphics.print(text, x + drawx, y + drawy)
			
			else
			
				if k ~= 1 then
					drawx = drawx + prevtextwidth
				end
				
				prevtextwidth = width
				
				love.graphics.setFont(font)
				love.graphics.setColor(unpack(color))
				love.graphics.print(text, x + drawx, y)
				
			end
			
		end
	
	end
	
	if maxw > 0 then
		self.width = maxw
	else
		self.width = totalwidth
	end
	
	self.height = drawy + height
	
end

--[[---------------------------------------------------------
	- func: SetMaxWidth(width)
	- desc: sets the object's maximum width
--]]---------------------------------------------------------
function text:SetMaxWidth(width)

	self.maxw = width
	self:SetText(self.original)
	
end

--[[---------------------------------------------------------
	- func: GetMaxWidth()
	- desc: gets the object's maximum width
--]]---------------------------------------------------------
function text:GetMaxWidth()

	return self.maxw
	
end

--[[---------------------------------------------------------
	- func: SetWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function text:SetWidth(width)

	self:SetMaxWidth(width)
	
end

--[[---------------------------------------------------------
	- func: SetHeight()
	- desc: sets the object's height
--]]---------------------------------------------------------
function text:SetHeight(height)
	
	return
	
end

--[[---------------------------------------------------------
	- func: SetSize()
	- desc: sets the object's size
--]]---------------------------------------------------------
function text:SetSize(width, height)

	self:SetMaxWidth(width)
	
end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the object's font
	- note: font argument must be a font object
--]]---------------------------------------------------------
function text:SetFont(font)

	local original = self.original
	
	self.font = font
	
	if original then
		self:SetText(original)
	end
	
end

--[[---------------------------------------------------------
	- func: GetFont()
	- desc: gets the object's font
--]]---------------------------------------------------------
function text:GetFont()

	return self.font
	
end