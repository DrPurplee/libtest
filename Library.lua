local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local Library = {}

--========================================================
-- THEME
--========================================================

local Theme = {
	Background = Color3.fromRGB(12, 12, 14),
	Panel = Color3.fromRGB(18, 18, 21),
	Panel2 = Color3.fromRGB(25, 25, 29),

	Selected = Color3.fromRGB(68, 68, 74),
	SelectedTop = Color3.fromRGB(92, 92, 98),

	ToggleOff = Color3.fromRGB(64, 64, 72),
	ToggleOn = Color3.fromRGB(185, 185, 195),

	SliderBackground = Color3.fromRGB(57, 57, 65),
	SliderFill = Color3.fromRGB(200, 200, 210),

	Border = Color3.fromRGB(48, 48, 54),

	Text = Color3.fromRGB(235, 235, 240),
	TextSecondary = Color3.fromRGB(180, 180, 188),
	TextMuted = Color3.fromRGB(115, 115, 123),

	White = Color3.fromRGB(255, 255, 255)
}

--========================================================
-- HELPERS
--========================================================

local function Create(className, properties)
	local object = Instance.new(className)

	for property, value in pairs(properties or {}) do
		object[property] = value
	end

	return object
end

local function Corner(object, radius)
	return Create("UICorner", {
		CornerRadius = UDim.new(0, radius or 5),
		Parent = object
	})
end

local function Stroke(object, color, transparency)
	return Create("UIStroke", {
		Color = color or Theme.Border,
		Thickness = 1,
		Transparency = transparency or 0,
		Parent = object
	})
end

local function Tween(object, duration, properties)
	local tween = TweenService:Create(
		object,
		TweenInfo.new(
			duration,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		properties
	)

	tween:Play()

	return tween
end

local function Gradient(object, topColor, bottomColor)
	return Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, topColor),
			ColorSequenceKeypoint.new(1, bottomColor)
		}),

		Rotation = 90,

		Parent = object
	})
end

local function NormalizeAsset(value)
	if typeof(value) == "number" then
		return "rbxassetid://" .. tostring(value)
	end

	return value or ""
end

--========================================================
-- CREATE WINDOW
--========================================================

function Library:CreateWindow(options)
	options = options or {}

	local title = options.Title or "MENU"
	local build = options.Build or "Build 1"

	local bannerImage =
		NormalizeAsset(options.BannerImage)

	local size =
		options.Size
		or UDim2.fromOffset(470, 520)

	local gui = Create("ScreenGui", {
		Name = "KeyboardUILibrary",
		ResetOnSpawn = false,
		IgnoreGuiInset = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = Player:WaitForChild("PlayerGui")
	})

	--====================================================
	-- MAIN
	--====================================================

	local main = Create("Frame", {
		Name = "Main",

		Size = size,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.03,

		BorderSizePixel = 0,

		ClipsDescendants = true,

		Parent = gui
	})

	Corner(main, 7)
	Stroke(main, Color3.fromRGB(65, 65, 70), 0.15)

	--====================================================
	-- MAIN BACKGROUND GRADIENT
	--====================================================

	Gradient(
		main,
		Color3.fromRGB(29, 29, 33),
		Color3.fromRGB(8, 8, 10)
	)

	--====================================================
	-- BANNER
	--====================================================

	local banner = Create("ImageLabel", {
		Name = "Banner",

		Size = UDim2.new(1, 0, 0, 132),

		BackgroundColor3 = Color3.fromRGB(20, 20, 22),
		BorderSizePixel = 0,

		Image = bannerImage,
		ImageTransparency = 0,

		ScaleType = Enum.ScaleType.Crop,

		Parent = main
	})

	local bannerShade = Create("Frame", {
		Size = UDim2.fromScale(1, 1),

		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.42,

		BorderSizePixel = 0,

		Parent = banner
	})

	Gradient(
		bannerShade,
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(0, 0, 0)
	)

	-- petite ligne en bas de bannière
	Create("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 1, -2),

		BackgroundColor3 = Color3.fromRGB(110, 110, 118),
		BackgroundTransparency = 0.3,

		BorderSizePixel = 0,

		Parent = banner
	})

	--====================================================
	-- PAGE TITLE
	--====================================================

	local pageTitle = Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 32),
		Position = UDim2.fromOffset(0, 132),

		BackgroundColor3 = Color3.fromRGB(7, 7, 9),

		BorderSizePixel = 0,

		Text = title,

		TextColor3 = Theme.Text,
		TextSize = 13,

		Font = Enum.Font.GothamMedium,

		Parent = main
	})

	--====================================================
	-- TABS HOLDER
	--====================================================

	local tabsHolder = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		Position = UDim2.fromOffset(0, 164),

		BackgroundColor3 = Color3.fromRGB(12, 12, 14),

		BorderSizePixel = 0,

		Parent = main
	})

	local tabsLayout = Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,

		Parent = tabsHolder
	})

	--====================================================
	-- CONTENT
	--====================================================

	local content = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -226),
		Position = UDim2.fromOffset(0, 198),

		BackgroundTransparency = 1,

		ClipsDescendants = true,

		Parent = main
	})

	--====================================================
	-- FOOTER
	--====================================================

	local footer = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 28),
		Position = UDim2.new(0, 0, 1, -28),

		BackgroundColor3 = Color3.fromRGB(7, 7, 9),

		BorderSizePixel = 0,

		Parent = main
	})

	Create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),

		BackgroundColor3 = Theme.Border,

		BorderSizePixel = 0,

		Parent = footer
	})

	local buildLabel = Create("TextLabel", {
		Size = UDim2.new(0.75, -10, 1, 0),
		Position = UDim2.fromOffset(10, 0),

		BackgroundTransparency = 1,

		Text = build,

		TextColor3 = Theme.Text,
		TextSize = 11,

		Font = Enum.Font.Gotham,

		TextXAlignment = Enum.TextXAlignment.Left,

		Parent = footer
	})

	local pageCounter = Create("TextLabel", {
		Size = UDim2.new(0.25, -10, 1, 0),
		Position = UDim2.new(0.75, 0, 0, 0),

		BackgroundTransparency = 1,

		Text = "1 / 1",

		TextColor3 = Theme.Text,
		TextSize = 11,

		Font = Enum.Font.Gotham,

		TextXAlignment = Enum.TextXAlignment.Right,

		Parent = footer
	})

	--====================================================
	-- WINDOW DATA
	--====================================================

	local Window = {}

	Window.Gui = gui
	Window.Main = main

	Window.Tabs = {}

	Window.CurrentTabIndex = 1
	Window.SelectedIndex = 1

	Window.Visible = true

	--====================================================
	-- UPDATE PAGE COUNTER
	--====================================================

	local function UpdateCounter()
		pageCounter.Text =
			tostring(Window.CurrentTabIndex)
			.. " / "
			.. tostring(math.max(#Window.Tabs, 1))
	end

	--====================================================
	-- SELECTION SYSTEM
	--====================================================

	local function GetCurrentTab()
		return Window.Tabs[Window.CurrentTabIndex]
	end

	local function UpdateSelection()
		local tab = GetCurrentTab()

		if not tab then
			return
		end

		if #tab.Items == 0 then
			return
		end

		Window.SelectedIndex =
			math.clamp(
				Window.SelectedIndex,
				1,
				#tab.Items
			)

		for index, item in ipairs(tab.Items) do
			if item.Select then
				item:Select(
					index == Window.SelectedIndex
				)
			end
		end
	end

	--====================================================
	-- SELECT TAB
	--====================================================

	local function SelectTab(index)
		if #Window.Tabs == 0 then
			return
		end

		index =
			math.clamp(
				index,
				1,
				#Window.Tabs
			)

		Window.CurrentTabIndex = index

		for i, tab in ipairs(Window.Tabs) do
			local active = i == index

			tab.Page.Visible = active

			if active then
				Tween(tab.Button, 0.12, {
					BackgroundColor3 = Theme.SelectedTop
				})

				tab.Button.TextColor3 = Theme.White
			else
				Tween(tab.Button, 0.12, {
					BackgroundColor3 = Color3.fromRGB(17, 17, 20)
				})

				tab.Button.TextColor3 =
					Theme.TextSecondary
			end
		end

		local tab = GetCurrentTab()

		pageTitle.Text =
			tab and tab.Name or title

		Window.SelectedIndex = 1

		UpdateCounter()
		UpdateSelection()
	end

	--====================================================
	-- ADD TAB
	--====================================================

	function Window:AddTab(options)
		options = options or {}

		local name =
			options.Name or "Tab"

		local tabIndex =
			#Window.Tabs + 1

		local button = Create("TextButton", {
			Size = UDim2.new(
				1 / math.max(tabIndex, 1),
				0,
				1,
				0
			),

			BackgroundColor3 = Color3.fromRGB(17, 17, 20),

			BorderSizePixel = 0,

			Text = name,

			TextColor3 = Theme.TextSecondary,
			TextSize = 11,

			Font = Enum.Font.GothamMedium,

			AutoButtonColor = false,

			Parent = tabsHolder
		})

		Gradient(
			button,
			Color3.fromRGB(50, 50, 55),
			Color3.fromRGB(17, 17, 20)
		)

		local page = Create("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = 1,

			BorderSizePixel = 0,

			CanvasSize = UDim2.new(),

			AutomaticCanvasSize = Enum.AutomaticSize.Y,

			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110),

			Visible = false,

			Parent = content
		})

		local layout = Create("UIListLayout", {
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,

			Parent = page
		})

		local Tab = {
			Name = name,
			Button = button,
			Page = page,

			Items = {}
		}

		table.insert(Window.Tabs, Tab)

		-- resize tous les tabs
		for _, existing in ipairs(Window.Tabs) do
			existing.Button.Size =
				UDim2.new(
					1 / #Window.Tabs,
					0,
					1,
					0
				)
		end

		button.MouseButton1Click:Connect(function()
			for i, testTab in ipairs(Window.Tabs) do
				if testTab == Tab then
					SelectTab(i)
					break
				end
			end
		end)

		--================================================
		-- REGISTER ITEM
		--================================================

		local function RegisterItem(item)
			table.insert(Tab.Items, item)

			local itemIndex = #Tab.Items

			if item.Row then
				item.Row.MouseButton1Click:Connect(function()
					for i, current in ipairs(Tab.Items) do
						if current == item then
							Window.SelectedIndex = i
							break
						end
					end

					UpdateSelection()

					if item.Activate then
						item:Activate()
					end
				end)
			end

			return item
		end

		--================================================
		-- DIVIDER
		--================================================

		function Tab:AddDivider(text)
			local row = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 38),

				BackgroundTransparency = 1,

				Parent = page
			})

			local leftLine = Create("Frame", {
				Size = UDim2.new(0.31, 0, 0, 1),
				Position = UDim2.new(0.04, 0, 0.5, 0),

				BackgroundColor3 =
					Color3.fromRGB(145, 145, 150),

				BorderSizePixel = 0,

				Parent = row
			})

			local rightLine = Create("Frame", {
				Size = UDim2.new(0.31, 0, 0, 1),
				Position = UDim2.new(0.65, 0, 0.5, 0),

				BackgroundColor3 =
					Color3.fromRGB(145, 145, 150),

				BorderSizePixel = 0,

				Parent = row
			})

			Create("TextLabel", {
				Size = UDim2.new(0.3, 0, 1, 0),
				Position = UDim2.new(0.35, 0, 0, 0),

				BackgroundTransparency = 1,

				Text = text or "",

				TextColor3 = Theme.Text,
				TextSize = 10,

				Font = Enum.Font.GothamMedium,

				Parent = row
			})
		end

		--================================================
		-- TOGGLE
		--================================================

		function Tab:AddToggle(options)
			options = options or {}

			local name =
				options.Name or "Toggle"

			local value =
				options.Default == true

			local callback =
				options.Callback
				or function() end

			local row = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 34),

				BackgroundColor3 = Theme.Panel,
				BackgroundTransparency = 0.18,

				BorderSizePixel = 0,

				Text = "",

				AutoButtonColor = false,

				Parent = page
			})

			Gradient(
				row,
				Color3.fromRGB(42, 42, 47),
				Color3.fromRGB(15, 15, 18)
			)

			local selector = Create("Frame", {
				Size = UDim2.fromScale(1, 1),

				BackgroundColor3 = Theme.Selected,
				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = row
			})

			Create("TextLabel", {
				Size = UDim2.new(1, -75, 1, 0),
				Position = UDim2.fromOffset(13, 0),

				BackgroundTransparency = 1,

				Text = name,

				TextColor3 = Theme.Text,
				TextSize = 11,

				Font = Enum.Font.Gotham,

				TextXAlignment = Enum.TextXAlignment.Left,

				Parent = row
			})

			local switch = Create("Frame", {
				Size = UDim2.fromOffset(40, 20),

				Position = UDim2.new(
					1,
					-54,
					0.5,
					-10
				),

				BackgroundColor3 = Theme.ToggleOff,

				BorderSizePixel = 0,

				Parent = row
			})

			Corner(switch, 99)

			local knob = Create("Frame", {
				Size = UDim2.fromOffset(14, 14),

				Position = UDim2.fromOffset(3, 3),

				BackgroundColor3 = Theme.White,

				BorderSizePixel = 0,

				Parent = switch
			})

			Corner(knob, 99)

			local function Update()
				if value then
					Tween(switch, 0.12, {
						BackgroundColor3 = Theme.ToggleOn
					})

					Tween(knob, 0.12, {
						Position = UDim2.fromOffset(23, 3),
						BackgroundColor3 = Color3.fromRGB(35, 35, 39)
					})
				else
					Tween(switch, 0.12, {
						BackgroundColor3 = Theme.ToggleOff
					})

					Tween(knob, 0.12, {
						Position = UDim2.fromOffset(3, 3),
						BackgroundColor3 = Theme.White
					})
				end
			end

			local Item = {
				Row = row
			}

			function Item:Select(selected)
				Tween(selector, 0.08, {
					BackgroundTransparency =
						selected and 0.63 or 1
				})
			end

			function Item:Activate()
				value = not value

				Update()
				callback(value)
			end

			function Item:Get()
				return value
			end

			function Item:Set(newValue)
				value = newValue == true

				Update()
				callback(value)
			end

			RegisterItem(Item)

			Update()

			return Item
		end

		--================================================
		-- SLIDER
		--================================================

		function Tab:AddSlider(options)
			options = options or {}

			local name =
				options.Name or "Slider"

			local min =
				options.Min or 0

			local max =
				options.Max or 100

			local value =
				options.Default or min

			local step =
				options.Step or 1

			local callback =
				options.Callback
				or function() end

			local row = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 46),

				BackgroundColor3 = Theme.Panel,
				BackgroundTransparency = 0.18,

				BorderSizePixel = 0,

				Text = "",

				AutoButtonColor = false,

				Parent = page
			})

			Gradient(
				row,
				Color3.fromRGB(38, 38, 43),
				Color3.fromRGB(14, 14, 17)
			)

			local selector = Create("Frame", {
				Size = UDim2.fromScale(1, 1),

				BackgroundColor3 = Theme.Selected,
				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = row
			})

			Create("TextLabel", {
				Size = UDim2.new(0.55, 0, 0, 22),
				Position = UDim2.fromOffset(13, 3),

				BackgroundTransparency = 1,

				Text = name,

				TextColor3 = Theme.Text,
				TextSize = 11,

				Font = Enum.Font.Gotham,

				TextXAlignment = Enum.TextXAlignment.Left,

				Parent = row
			})

			local valueLabel = Create("TextLabel", {
				Size = UDim2.new(0.25, 0, 0, 22),
				Position = UDim2.new(0.55, 0, 0, 3),

				BackgroundTransparency = 1,

				Text = "",

				TextColor3 = Theme.TextSecondary,
				TextSize = 10,

				Font = Enum.Font.Gotham,

				TextXAlignment = Enum.TextXAlignment.Right,

				Parent = row
			})

			local bar = Create("Frame", {
				Size = UDim2.new(0.75, 0, 0, 6),

				Position = UDim2.new(
					0.21,
					0,
					0,
					31
				),

				BackgroundColor3 = Theme.SliderBackground,

				BorderSizePixel = 0,

				Parent = row
			})

			Corner(bar, 99)

			local fill = Create("Frame", {
				Size = UDim2.new(0, 0, 1, 0),

				BackgroundColor3 = Theme.SliderFill,

				BorderSizePixel = 0,

				Parent = bar
			})

			Corner(fill, 99)

			local knob = Create("Frame", {
				Size = UDim2.fromOffset(8, 8),

				AnchorPoint = Vector2.new(0.5, 0.5),

				BackgroundColor3 = Theme.White,

				BorderSizePixel = 0,

				Parent = bar
			})

			Corner(knob, 99)

			local function Update(newValue, fire)
				value =
					math.clamp(
						newValue,
						min,
						max
					)

				if step then
					value =
						math.round(value / step)
						* step
				end

				local percentage =
					(value - min)
					/
					(max - min)

				fill.Size =
					UDim2.new(
						percentage,
						0,
						1,
						0
					)

				knob.Position =
					UDim2.new(
						percentage,
						0,
						0.5,
						0
					)

				valueLabel.Text =
					tostring(value)

				if fire then
					callback(value)
				end
			end

			local Item = {
				Row = row
			}

			function Item:Select(selected)
				Tween(selector, 0.08, {
					BackgroundTransparency =
						selected and 0.63 or 1
				})
			end

			function Item:Activate()
				-- Enter peut avancer le slider
				Update(
					math.min(value + step, max),
					true
				)
			end

			function Item:Left()
				Update(
					value - step,
					true
				)
			end

			function Item:Right()
				Update(
					value + step,
					true
				)
			end

			function Item:Get()
				return value
			end

			function Item:Set(newValue)
				Update(newValue, true)
			end

			RegisterItem(Item)

			Update(value, false)

			return Item
		end

		--================================================
		-- DROPDOWN
		--================================================

		function Tab:AddDropdown(options)
			options = options or {}

			local name =
				options.Name or "Dropdown"

			local values =
				options.Options or {}

			local currentIndex = 1

			local callback =
				options.Callback
				or function() end

			if options.Default then
				for index, option in ipairs(values) do
					if option == options.Default then
						currentIndex = index
						break
					end
				end
			end

			local row = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 36),

				BackgroundColor3 = Theme.Panel,
				BackgroundTransparency = 0.18,

				BorderSizePixel = 0,

				Text = "",

				AutoButtonColor = false,

				Parent = page
			})

			Gradient(
				row,
				Color3.fromRGB(38, 38, 43),
				Color3.fromRGB(14, 14, 17)
			)

			local selector = Create("Frame", {
				Size = UDim2.fromScale(1, 1),

				BackgroundColor3 = Theme.Selected,
				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = row
			})

			Create("TextLabel", {
				Size = UDim2.new(0.52, 0, 1, 0),
				Position = UDim2.fromOffset(13, 0),

				BackgroundTransparency = 1,

				Text = name,

				TextColor3 = Theme.Text,
				TextSize = 11,

				Font = Enum.Font.Gotham,

				TextXAlignment = Enum.TextXAlignment.Left,

				Parent = row
			})

			local valueLabel = Create("TextLabel", {
				Size = UDim2.new(0.42, 0, 1, 0),
				Position = UDim2.new(0.55, 0, 0, 0),

				BackgroundTransparency = 1,

				Text = "",

				TextColor3 = Theme.TextSecondary,
				TextSize = 10,

				Font = Enum.Font.Gotham,

				TextXAlignment = Enum.TextXAlignment.Right,

				Parent = row
			})

			local function Update(fire)
				if #values == 0 then
					valueLabel.Text = "None"
					return
				end

				valueLabel.Text =
					"< "
					.. tostring(values[currentIndex])
					.. " >"

				if fire then
					callback(values[currentIndex])
				end
			end

			local Item = {
				Row = row
			}

			function Item:Select(selected)
				Tween(selector, 0.08, {
					BackgroundTransparency =
						selected and 0.63 or 1
				})
			end

			function Item:Activate()
				if #values == 0 then
					return
				end

				currentIndex += 1

				if currentIndex > #values then
					currentIndex = 1
				end

				Update(true)
			end

			function Item:Left()
				if #values == 0 then
					return
				end

				currentIndex -= 1

				if currentIndex < 1 then
					currentIndex = #values
				end

				Update(true)
			end

			function Item:Right()
				self:Activate()
			end

			function Item:Get()
				return values[currentIndex]
			end

			RegisterItem(Item)

			Update(false)

			return Item
		end

		--================================================
		-- BUTTON
		--================================================

		function Tab:AddButton(options)
			options = options or {}

			local callback =
				options.Callback
				or function() end

			local row = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 35),

				BackgroundColor3 = Theme.Panel,
				BackgroundTransparency = 0.18,

				BorderSizePixel = 0,

				Text = options.Name or "Button",

				TextColor3 = Theme.Text,
				TextSize = 11,

				Font = Enum.Font.GothamMedium,

				AutoButtonColor = false,

				Parent = page
			})

			Gradient(
				row,
				Color3.fromRGB(40, 40, 45),
				Color3.fromRGB(14, 14, 17)
			)

			local selector = Create("Frame", {
				Size = UDim2.fromScale(1, 1),

				BackgroundColor3 = Theme.Selected,
				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = row
			})

			local Item = {
				Row = row
			}

			function Item:Select(selected)
				Tween(selector, 0.08, {
					BackgroundTransparency =
						selected and 0.63 or 1
				})
			end

			function Item:Activate()
				callback()
			end

			RegisterItem(Item)

			return Item
		end

		UpdateCounter()

		if #Window.Tabs == 1 then
			SelectTab(1)
		end

		return Tab
	end

	--====================================================
	-- KEYBOARD NAVIGATION
	--
	-- Q / E       = onglet gauche / droite quand on ne règle rien
	-- ↑ / ↓       = élément précédent / suivant
	-- ENTER       = activer un toggle/bouton
	--               ou entrer en mode réglage pour slider/dropdown
	-- Q / E       = diminuer / augmenter la valeur en mode réglage
	-- BACKSPACE   = quitter le mode réglage
	-- RIGHT SHIFT = afficher / cacher le menu
	--
	-- Une touche ne déclenche qu'une seule action par pression.
	--====================================================

	Window.Editing = false
	Window.EditingItem = nil

	-- Empêche le maintien d'une touche de spammer les actions.
	local heldKeys = {}

	local function IsEnterKey(keyCode)
		return keyCode == Enum.KeyCode.Return
			or keyCode == Enum.KeyCode.KeypadEnter
	end

	local function GetSelectedItem()
		local tab = GetCurrentTab()

		if not tab then
			return nil
		end

		return tab.Items[Window.SelectedIndex]
	end

	local function ExitEditMode()
		Window.Editing = false
		Window.EditingItem = nil
	end

	local function EnterEditMode(item)
		Window.Editing = true
		Window.EditingItem = item
	end

	-- Quand on relâche une touche, elle peut être utilisée à nouveau.
	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode ~= Enum.KeyCode.Unknown then
			heldKeys[input.KeyCode] = nil
		end
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		local keyCode = input.KeyCode

		-- RIGHT SHIFT doit toujours pouvoir réouvrir le menu.
		if keyCode == Enum.KeyCode.RightShift then
			if heldKeys[keyCode] then
				return
			end

			heldKeys[keyCode] = true

			Window.Visible = not Window.Visible
			gui.Enabled = Window.Visible

			if not Window.Visible then
				ExitEditMode()
			end

			return
		end

		if processed or not Window.Visible then
			return
		end

		if keyCode == Enum.KeyCode.Unknown then
			return
		end

		-- Une seule action par vraie pression.
		if heldKeys[keyCode] then
			return
		end

		heldKeys[keyCode] = true

		local tab = GetCurrentTab()

		if not tab then
			return
		end

		--================================================
		-- MODE RÉGLAGE
		--================================================

		if Window.Editing then
			local item = Window.EditingItem

			-- BACKSPACE = sortir du slider/dropdown
			if keyCode == Enum.KeyCode.Backspace
				or keyCode == Enum.KeyCode.Delete
			then
				ExitEditMode()
				return
			end

			-- Q = une seule étape vers la gauche / valeur précédente.
			if keyCode == Enum.KeyCode.Q then
				if item and item.Left then
					item:Left()
				end
				return
			end

			-- E = une seule étape vers la droite / valeur suivante.
			if keyCode == Enum.KeyCode.E then
				if item and item.Right then
					item:Right()
				end
				return
			end

			-- Pendant le réglage, ↑ ↓ ENTER et les flèches ne font rien.
			return
		end

		--================================================
		-- NAVIGATION ENTRE LES ONGLETS : Q / E
		--================================================

		if keyCode == Enum.KeyCode.Q then
			local newTab = Window.CurrentTabIndex - 1

			if newTab < 1 then
				newTab = #Window.Tabs
			end

			SelectTab(newTab)
			return
		end

		if keyCode == Enum.KeyCode.E then
			local newTab = Window.CurrentTabIndex + 1

			if newTab > #Window.Tabs then
				newTab = 1
			end

			SelectTab(newTab)
			return
		end

		--================================================
		-- NAVIGATION VERTICALE : ↑ / ↓
		--================================================

		if keyCode == Enum.KeyCode.Up then
			if #tab.Items > 0 then
				Window.SelectedIndex -= 1

				if Window.SelectedIndex < 1 then
					Window.SelectedIndex = #tab.Items
				end

				UpdateSelection()
			end

			return
		end

		if keyCode == Enum.KeyCode.Down then
			if #tab.Items > 0 then
				Window.SelectedIndex += 1

				if Window.SelectedIndex > #tab.Items then
					Window.SelectedIndex = 1
				end

				UpdateSelection()
			end

			return
		end

		--================================================
		-- ENTER
		--================================================

		if IsEnterKey(keyCode) then
			local item = GetSelectedItem()

			if not item then
				return
			end

			-- Slider / Dropdown :
			-- s'ils possèdent Left/Right, ENTER ouvre le mode réglage.
			if item.Left or item.Right then
				EnterEditMode(item)
				return
			end

			-- Toggle / Button : ENTER agit directement.
			if item.Activate then
				item:Activate()
			end

			return
		end

		-- Q/E changent d'onglet seulement hors mode réglage.
		-- Une fois ENTER pressé sur un slider/dropdown, Q/E règlent la valeur.
	end)

	--====================================================
	-- PUBLIC METHODS
	--====================================================

	function Window:SetBanner(asset)
		banner.Image =
			NormalizeAsset(asset)
	end

	function Window:SetTitle(text)
		pageTitle.Text = tostring(text)
	end

	function Window:SetBuild(text)
		buildLabel.Text = tostring(text)
	end

	function Window:Toggle()
		Window.Visible =
			not Window.Visible

		gui.Enabled =
			Window.Visible
	end

	function Window:Show()
		Window.Visible = true
		gui.Enabled = true
	end

	function Window:Hide()
		Window.Visible = false
		gui.Enabled = false
	end

	function Window:Destroy()
		gui:Destroy()
	end

	return Window
end

return Library
