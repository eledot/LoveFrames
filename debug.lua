--[[------------------------------------------------
	-- LÖVE Frames --
	-- By Nikolai Resokav --
--]]------------------------------------------------

loveframes.debug = {}

local font = love.graphics.newFont(10)
local loremipsum = 
[[
Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Proin dui enim, porta eget facilisis quis, laoreet sit amet urna. 
Maecenas lobortis venenatis euismod. 
Sed at diam sit amet odio feugiat pretium nec quis libero. 
Quisque auctor semper imperdiet. 
Maecenas risus eros, varius pharetra volutpat in, fermentum scelerisque lacus. 
Proin lectus erat, luctus non facilisis vel, hendrerit vitae nisl. 
Aliquam vulputate scelerisque odio id faucibus. 
]]

function loveframes.debug.draw()

	-- get the current debug setting
	local debug = loveframes.config["DEBUG"]
	
	-- do not draw anthing if debug is off
	if debug == false then
		return
	end
	
	local cols = loveframes.util.GetCollisions()
	local numcols = #cols
	local topcol = cols[numcols] or {type = none, children = {}, x = 0, y = 0, width = 0, height = 0}
	local bchildren = #loveframes.base.children
	local objects = loveframes.util.GetAllObjects()
	
	-- font for debug text
	love.graphics.setFont(font)
	love.graphics.setLine(1, "smooth")
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Library Information", 6, 6)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print("Library Information", 5, 5)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.line(6, 21, 190, 21)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.line(5, 20, 190, 20)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Author: " ..loveframes.info.author, 6, 26)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Author: " ..loveframes.info.author, 5, 25)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Version: " ..loveframes.info.version, 6, 36)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Version: " ..loveframes.info.version, 5, 35)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Stage: " ..loveframes.info.stage, 6, 46)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Stage: " ..loveframes.info.stage, 5, 45)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Base Directory: " ..loveframes.config["DIRECTORY"], 6, 56)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Base Directory: " ..loveframes.config["DIRECTORY"], 5, 55)
	
	-- object information box
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Object Information", 6, 81)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print("Object Information", 5, 80)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.line(6, 96, 190, 96)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.line(5, 95, 190, 95)
	
	if numcols > 0 then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("Type: " ..topcol.type, 6, 101)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Type: " ..topcol.type, 5, 100)
	else
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("Type: none", 6, 101)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Type: none", 5, 100)
	end
	
	if topcol.children then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("# of children: " .. #topcol.children, 6, 111)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("# of children: " .. #topcol.children, 5, 110)
	else
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("# of children: 0", 6, 111)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("# of children: 0", 5, 110)
	end
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("X: " ..topcol.x, 6, 121)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("X: " ..topcol.x, 5, 120)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Y: " ..topcol.y, 6, 131)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Y: " ..topcol.y, 5, 130)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Width: " ..topcol.width, 6, 141)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Width: " ..topcol.width, 5, 140)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Height: " ..topcol.height, 6, 151)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Height: " ..topcol.height, 5, 150)
	
	-- Miscellaneous box
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Miscellaneous: ", 6, 191)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.print("Miscellaneous", 5, 190)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.line(6, 206, 190, 206)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.line(5, 205, 190, 205)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("LOVE Version: " ..love._version, 6, 211)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("LOVE Version: " ..love._version, 5, 210)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("FPS: " ..love.timer.getFPS(), 6, 221)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("FPS: " ..love.timer.getFPS(), 5, 220)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Delta Time: " ..love.timer.getDelta(), 6, 231)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Delta Time: " ..love.timer.getDelta(), 5, 230)
	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print("Total Objects: " ..#objects, 6, 241)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Total Objects: " ..#objects, 5, 240)
	
	-- outline the object that the mouse is hovering over
	love.graphics.setColor(255, 204, 51, 255)
	love.graphics.setLine(2, "smooth")
	love.graphics.rectangle("line", topcol.x - 1, topcol.y - 1, topcol.width + 2, topcol.height + 2)

end

function loveframes.debug.ExamplesMenu()

	------------------------------------
	-- examples frame
	------------------------------------
	local examplesframe = loveframes.Create("frame")
	examplesframe:SetName("Examples List")
	examplesframe:SetSize(200, love.graphics.getHeight() - 265)
	examplesframe:SetPos(5, 260)
	
	------------------------------------
	-- examples list
	------------------------------------
	local exampleslist = loveframes.Create("list", examplesframe)
	exampleslist:SetSize(200, exampleslist:GetParent():GetHeight() - 25)
	exampleslist:SetPos(0, 25)
	exampleslist:SetPadding(5)
	exampleslist:SetSpacing(5)
	exampleslist:SetDisplayType("vertical")
	
	------------------------------------
	-- button example
	------------------------------------
	local buttonexample = loveframes.Create("button")
	buttonexample:SetText("Button")
	buttonexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Button")
		frame1:Center()
		
		local button1 = loveframes.Create("button", frame1)
		button1:SetWidth(200)
		button1:SetText("Button")
		button1:Center()
		button1.OnClick = function(object2, x, y)
			object2:SetText("You clicked the button!")
		end
		button1.OnMouseEnter = function(object2)
			object2:SetText("The mouse entered the button.")
		end
		button1.OnMouseExit = function(object2)
			object2:SetText("The mouse exited the button.")
		end
		
	end
	exampleslist:AddItem(buttonexample)
	
	------------------------------------
	-- checkbox example
	------------------------------------
	local checkboxexample = loveframes.Create("button")
	checkboxexample:SetText("Checkbox")
	checkboxexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Checkbox")
		frame1:Center()
		
		local checkbox1 = loveframes.Create("checkbox", frame1)
		checkbox1:SetText("Checkbox 1")
		checkbox1:SetPos(5, 30)
		--checkbox1:SetFont(love.graphics.newFont(50))
		checkbox1.OnChanged = function(object2)
		end
		
		local checkbox2 = loveframes.Create("checkbox", frame1)
		checkbox2:SetText("Checkbox 2")
		checkbox2:SetPos(5, 60)
		checkbox2.OnChanged = function(object3)
		end
		
	end
	exampleslist:AddItem(checkboxexample)
	
	------------------------------------
	-- collapsible category example
	------------------------------------
	local collapsiblecategoryexample = loveframes.Create("button")
	collapsiblecategoryexample:SetText("Collapsible Category")
	collapsiblecategoryexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Collapsible Category")
		frame1:SetSize(500, 300)
		frame1:Center()
		
		local panel1 = loveframes.Create("panel")
			
		local collapsiblecategory1 = loveframes.Create("collapsiblecategory", frame1)
		collapsiblecategory1:SetPos(5, 30)
		collapsiblecategory1:SetSize(490, 265)
		collapsiblecategory1:SetText("Category 1")
		collapsiblecategory1:SetObject(panel1)
		
	end
	exampleslist:AddItem(collapsiblecategoryexample)
	
	------------------------------------
	-- cloumnlist example
	------------------------------------
	local cloumnlistexample = loveframes.Create("button")
	cloumnlistexample:SetText("Column List")
	cloumnlistexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Column List")
		frame1:SetSize(500, 300)
		frame1:Center()
		
		local list1 = loveframes.Create("columnlist", frame1)
		list1:SetPos(5, 30)
		list1:SetSize(490, 265)
		list1:AddColumn("Column 1")
		list1:AddColumn("Column 2")
		list1:AddColumn("Column 3")
		list1:AddColumn("Column 4")
		list1.OnRowClicked = function(parent, row, rowdata)
			print(unpack(rowdata))
		end
		
		for i=1, 20 do
			list1:AddRow("Row " ..i.. ", column 1", "Row " ..i.. ", column 2", "Row " ..i.. ", column 3", "Row " ..i.. ", column 4")
		end
		
	end
	exampleslist:AddItem(cloumnlistexample)
	
	------------------------------------
	-- frame example
	------------------------------------
	local frameexample = loveframes.Create("button")
	frameexample:SetText("Frame")
	frameexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Frame")
		frame1:Center()
		
		local text1 = loveframes.Create("text", frame1)
		text1:SetText("This is an example frame.")
		text1.Update = function(object2, dt)
			object2:Center()
		end
		
	end
	exampleslist:AddItem(frameexample)
	
	------------------------------------
	-- image example
	------------------------------------
	local imageexample = loveframes.Create("button")
	imageexample:SetText("Image")
	imageexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Image")
		frame1:SetSize(138, 163)
		frame1:Center()
		
		local image1 = loveframes.Create("image", frame1)
		image1:SetImage("resources/images/carlsagan.png")
		image1:SetPos(5, 30)
		
	end
	exampleslist:AddItem(imageexample)
	
	------------------------------------
	-- list example
	------------------------------------
	local listexample = loveframes.Create("button")
	listexample:SetText("List")
	listexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("List")
		frame1:SetSize(500, 455)
		frame1:Center()
		
		local list1 = loveframes.Create("list", frame1)
		list1:SetPos(5, 30)
		list1:SetSize(490, 300)
		
		local panel1 = loveframes.Create("panel", frame1)
		panel1:SetPos(5, 335)
		panel1:SetSize(490, 115)
		
		local slider1 = loveframes.Create("slider", panel1)
		slider1:SetPos(5, 5)
		slider1:SetWidth(480)
		slider1:SetMinMax(0, 100)
		slider1:SetText("Padding")
		slider1:SetDecimals(0)
		slider1.OnValueChanged = function(object2, value)
			list1:SetPadding(value)
		end
		
		local slider2 = loveframes.Create("slider", panel1)
		slider2:SetPos(5, 45)
		slider2:SetWidth(480)
		slider2:SetMinMax(0, 100)
		slider2:SetText("Spacing")
		slider2:SetDecimals(0)
		slider2.OnValueChanged = function(object2, value)
			list1:SetSpacing(value)
		end
		
		local button1 = loveframes.Create("button", panel1)
		button1:SetPos(5, 85)
		button1:SetSize(480, 25)
		button1:SetText("Change List Type")
		button1.OnClick = function(object2, x, y)
			if list1:GetDisplayType() == "vertical" then
				list1:SetDisplayType("horizontal")
			else
				list1:SetDisplayType("vertical")
			end
		end
		
		for i=1, 50 do
			local button2 = loveframes.Create("button")
			button2:SetText(i)
			list1:AddItem(button2)
		end
		
	end
	exampleslist:AddItem(listexample)
	
	------------------------------------
	-- multichoice example
	------------------------------------
	local multichoiceexample = loveframes.Create("button")
	multichoiceexample:SetText("Multichoice")
	multichoiceexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Multichoice")
		frame1:SetSize(210, 60)
		frame1:Center()
		
		local multichoice1 = loveframes.Create("multichoice", frame1)
		multichoice1:SetPos(5, 30)
		
		for i=1, 20 do
			multichoice1:AddChoice(i)
		end
		
	end
	exampleslist:AddItem(multichoiceexample)
	
	------------------------------------
	-- panel example
	------------------------------------
	local panelexample = loveframes.Create("button")
	panelexample:SetText("Panel")
	panelexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Panel")
		frame1:SetSize(210, 85)
		frame1:Center()
		
		local panel1 = loveframes.Create("panel", frame1)
		panel1:SetPos(5, 30)
		
	end
	exampleslist:AddItem(panelexample)
	
	------------------------------------
	-- progressbar example
	------------------------------------
	local progressbarexample = loveframes.Create("button")
	progressbarexample:SetText("Progress Bar")
	progressbarexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Progress Bar")
		frame1:SetSize(500, 160)
		frame1:Center()
		
		local progressbar1 = loveframes.Create("progressbar", frame1)
		progressbar1:SetPos(5, 30)
		progressbar1:SetWidth(490)
		progressbar1:SetLerpRate(1)
		
		local button1 = loveframes.Create("button", frame1)
		button1:SetPos(5, 60)
		button1:SetWidth(490)
		button1:SetText("Change bar value")
		button1.OnClick = function(object2, x, y)
			progressbar1:SetValue(math.random(progressbar1:GetMin(), progressbar1:GetMax()))
		end
		
		local button2 = loveframes.Create("button", frame1)
		button2:SetPos(5, 90)
		button2:SetWidth(490)
		button2:SetText("Toggle bar lerp")
		button2.OnClick = function(object2, x, y)
			if progressbar1:GetLerp() == true then
				progressbar1:SetLerp(false)
			else
				progressbar1:SetLerp(true)
			end
		end
		
		local slider1 = loveframes.Create("slider", frame1)
		slider1:SetPos(5, 120)
		slider1:SetWidth(490)
		slider1:SetText("Progressbar lerp rate")
		slider1:SetMinMax(1, 50)
		slider1.OnValueChanged = function(object2, value)
			progressbar1:SetLerpRate(value)
		end
		
	end
	exampleslist:AddItem(progressbarexample)
	
	------------------------------------
	-- slider example
	------------------------------------
	local sliderexample = loveframes.Create("button")
	sliderexample:SetText("Slider")
	sliderexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Slider")
		frame1:SetSize(300, 100)
		frame1:Center()
		
		local slider1 = loveframes.Create("slider", frame1)
		slider1:SetPos(5, 30)
		slider1:SetSize(290, 500)
		slider1:SetMinMax(0, 100)
		
	end
	exampleslist:AddItem(sliderexample)
	
	------------------------------------
	-- tabs example
	------------------------------------
	local tabsexample = loveframes.Create("button")
	tabsexample:SetText("Tabs")
	tabsexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Tabs")
		frame1:SetSize(500, 300)
		frame1:Center()
		
		local tabs1 = loveframes.Create("tabs", frame1)
		tabs1:SetPos(5, 30)
		tabs1:SetSize(490, 265)
		
		for i=1, 20 do
			local text1 = loveframes.Create("text")
			text1:SetText("Tab " ..i)
			tabs1:AddTab("Tab " ..i, text1, "Tab " ..i)
		end
		
	end
	exampleslist:AddItem(tabsexample)
	
	------------------------------------
	-- text example
	------------------------------------
	local textexample = loveframes.Create("button")
	textexample:SetText("Text")
	textexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Text")
		frame1:SetSize(500, 300)
		frame1:Center()
		
		local list1 = loveframes.Create("list", frame1)
		list1:SetPos(5, 30)
		list1:SetSize(490, 265)
		list1:SetPadding(5)
		list1:SetSpacing(5)
		
		for i=1, 20 do
			local text1 = loveframes.Create("text")
			text1:SetText(loremipsum)
			--text1:SetColor({math.random(1, 255), math.random(1, 255), math.random(1, 255), 255})
			list1:AddItem(text1)
		end
		
	end
	exampleslist:AddItem(textexample)
	
	------------------------------------
	-- text input example
	------------------------------------
	local textinputexample = loveframes.Create("button")
	textinputexample:SetText("Text Input")
	textinputexample.OnClick = function(object1, x, y)
	
		local frame1 = loveframes.Create("frame")
		frame1:SetName("Text Input")
		frame1:SetSize(500, 60)
		frame1:Center()
		
		local textinput1 = loveframes.Create("textinput", frame1)
		textinput1:SetPos(5, 30)
		textinput1:SetWidth(490)
		
	end
	exampleslist:AddItem(textinputexample)
		
end