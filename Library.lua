--[[
    TEL-AVIV UI — PRO v2
    Style: compact / flat / high contrast / mouse-first
    API:
      Library:CreateWindow()
      Window:AddTab()
      Tab:AddDivider()
      Tab:AddToggle()
      Tab:AddSlider()
      Tab:AddDropdown()
      Tab:AddButton()
      Window:SetBanner()
      Window:Show()
      Window:Hide()
      Window:Toggle()
      Window:Destroy()

    Notes:
      - Tabs = simples, pas de "pill buttons"
      - Texte plus grand / plus contrasté
      - Bleu utilisé uniquement comme accent
      - Bords 4–6 px : carré mais propre
      - RightShift = afficher / masquer
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Library = {}

--========================================================
-- THEME
--========================================================

Library.Theme = {
    Background = Color3.fromRGB(8, 11, 16),
    Header = Color3.fromRGB(10, 14, 20),
    Panel = Color3.fromRGB(11, 16, 23),
    Row = Color3.fromRGB(14, 20, 29),
    RowHover = Color3.fromRGB(18, 26, 38),

    Accent = Color3.fromRGB(45, 125, 255),
    AccentSoft = Color3.fromRGB(77, 148, 255),
    AccentDark = Color3.fromRGB(25, 73, 154),

    Border = Color3.fromRGB(38, 48, 62),
    BorderStrong = Color3.fromRGB(55, 69, 88),

    Text = Color3.fromRGB(248, 250, 252),
    Text2 = Color3.fromRGB(201, 210, 222),
    Muted = Color3.fromRGB(133, 147, 164),

    CheckboxOff = Color3.fromRGB(20, 28, 39),
    SliderTrack = Color3.fromRGB(27, 36, 48),
}

Library.Font = Font.new(
    "rbxasset://fonts/families/GothamSSm.json",
    Enum.FontWeight.Medium,
    Enum.FontStyle.Normal
)

Library.SetFlags = {}
Library.Flags = {}

local Theme = Library.Theme

--========================================================
-- HELPERS
--========================================================

local function Create(className, props)
    local obj = Instance.new(className)

    for k, v in pairs(props or {}) do
        obj[k] = v
    end

    return obj
end

local function Corner(obj, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 4),
        Parent = obj,
    })
end

local function Stroke(obj, color, transparency, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj,
    })
end

local function Tween(obj, time, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            time,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        props
    )

    t:Play()
    return t
end

local function SetFont(obj, weight)
    pcall(function()
        obj.FontFace = Font.new(
            "rbxasset://fonts/families/GothamSSm.json",
            weight or Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        )
    end)
end

local function NormalizeAsset(asset)
    if asset == nil then
        return ""
    end

    if typeof(asset) == "number" then
        return "rbxassetid://" .. tostring(asset)
    end

    local str = tostring(asset)
    local id = str:match("%d+")

    if id then
        return "rbxassetid://" .. id
    end

    return str
end

local function RegisterFlag(flag, defaultValue, setter)
    if not flag or flag == "" then
        return
    end

    Library.Flags[flag] = defaultValue

    Library.SetFlags[flag] = function(value)
        Library.Flags[flag] = value

        if setter then
            setter(value, true)
        end
    end
end

--========================================================
-- WINDOW
--========================================================

function Library:CreateWindow(options)
    options = options or {}

    local title = options.Title or "TEL-AVIV"
    local build = options.Build or ("Build | " .. LocalPlayer.Name)
    local size = options.Size or UDim2.fromOffset(490, 570)
    local bannerImage = NormalizeAsset(options.BannerImage)

    local gui = Create("ScreenGui", {
        Name = "TelAvivProUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LocalPlayer:WaitForChild("PlayerGui"),
    })

    local main = Create("Frame", {
        Name = "Main",
        Size = size,
        Position = UDim2.new(1, -22, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),

        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,

        Parent = gui,
    })

    Corner(main, 6)
    Stroke(main, Theme.BorderStrong, 0.15, 1)

    -- Accent très fin, pas de gros gradient.
    Create("Frame", {
        Name = "TopAccent",
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 50,
        Parent = main,
    })

    --====================================================
    -- BANNER
    --====================================================

    local banner = Create("ImageLabel", {
        Name = "Banner",
        Size = UDim2.new(1, 0, 0, 124),
        Position = UDim2.fromOffset(0, 2),

        BackgroundColor3 = Color3.fromRGB(7, 10, 15),
        BorderSizePixel = 0,

        Image = bannerImage,
        ImageTransparency = 0,
        ScaleType = Enum.ScaleType.Crop,

        Parent = main,
    })

    -- Seulement une petite ligne de séparation.
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),

        BackgroundColor3 = Theme.BorderStrong,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,

        Parent = banner,
    })

    --====================================================
    -- TITLE BAR
    --====================================================

    local titleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.fromOffset(0, 126),

        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,

        Parent = main,
    })

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(0.55, -14, 1, 0),
        Position = UDim2.fromOffset(14, 0),

        BackgroundTransparency = 1,

        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,

        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,

        Parent = titleBar,
    })

    SetFont(titleLabel, Enum.FontWeight.Bold)

    local buildLabel = Create("TextLabel", {
        Size = UDim2.new(0.45, -14, 1, 0),
        Position = UDim2.new(0.55, 0, 0, 0),

        BackgroundTransparency = 1,

        Text = build,
        TextColor3 = Theme.Muted,
        TextSize = 10,

        TextXAlignment = Enum.TextXAlignment.Right,
        TextYAlignment = Enum.TextYAlignment.Center,

        Parent = titleBar,
    })

    SetFont(buildLabel, Enum.FontWeight.Medium)

    --====================================================
    -- TABS — flat, professional
    --====================================================

    local tabsHolder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.fromOffset(0, 166),

        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,

        Parent = main,
    })

    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),

        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,

        Parent = tabsHolder,
    })

    local tabsLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabsHolder,
    })

    --====================================================
    -- CONTENT
    --====================================================

    local content = Create("Frame", {
        Size = UDim2.new(1, -18, 1, -240),
        Position = UDim2.fromOffset(9, 214),

        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,

        Parent = main,
    })

    Corner(content, 5)
    Stroke(content, Theme.Border, 0.25, 1)

    --====================================================
    -- FOOTER
    --====================================================

    local footer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 1, -25),

        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,

        Parent = main,
    })

    local footerLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(10, 0),

        BackgroundTransparency = 1,

        Text = "RIGHT SHIFT  ·  SHOW / HIDE",
        TextColor3 = Theme.Muted,
        TextSize = 9,

        TextXAlignment = Enum.TextXAlignment.Left,

        Parent = footer,
    })

    SetFont(footerLabel, Enum.FontWeight.SemiBold)

    --====================================================
    -- WINDOW OBJECT
    --====================================================

    local Window = {
        Gui = gui,
        Main = main,
        Banner = banner,
        Tabs = {},
        CurrentTab = nil,
        Visible = true,
    }

    local function ResizeTabs()
        local count = math.max(#Window.Tabs, 1)

        for _, tab in ipairs(Window.Tabs) do
            tab.Button.Size = UDim2.new(
                1 / count,
                0,
                1,
                0
            )
        end
    end

    local function SelectTab(tab)
        for _, other in ipairs(Window.Tabs) do
            local active = other == tab

            other.Page.Visible = active

            if active then
                Tween(other.Label, 0.1, {
                    TextColor3 = Theme.Text,
                })

                Tween(other.Indicator, 0.1, {
                    BackgroundTransparency = 0,
                })
            else
                Tween(other.Label, 0.1, {
                    TextColor3 = Theme.Muted,
                })

                Tween(other.Indicator, 0.1, {
                    BackgroundTransparency = 1,
                })
            end
        end

        Window.CurrentTab = tab
    end

    --====================================================
    -- TAB
    --====================================================

    function Window:AddTab(options)
        options = options or {}

        local name = options.Name or "Tab"

        local button = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Text = "",
            AutoButtonColor = false,

            Parent = tabsHolder,
        })

        local label = Create("TextLabel", {
            Size = UDim2.new(1, -12, 1, -3),
            Position = UDim2.fromOffset(6, 0),

            BackgroundTransparency = 1,

            Text = name,
            TextColor3 = Theme.Muted,
            TextSize = 11,

            Parent = button,
        })

        SetFont(label, Enum.FontWeight.SemiBold)

        local indicator = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 2),
            Position = UDim2.new(0, 10, 1, -2),

            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Parent = button,
        })

        local page = Create("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.fromOffset(5, 5),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.25,
            ScrollingDirection = Enum.ScrollingDirection.Y,

            Visible = false,

            Parent = content,
        })

        Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page,
        })

        Create("UIPadding", {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 8),
            Parent = page,
        })

        local Tab = {
            Name = name,
            Button = button,
            Label = label,
            Indicator = indicator,
            Page = page,
        }

        table.insert(Window.Tabs, Tab)
        ResizeTabs()

        button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(label, 0.08, {
                    TextColor3 = Theme.Text2,
                })
            end
        end)

        button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(label, 0.08, {
                    TextColor3 = Theme.Muted,
                })
            end
        end)

        button.MouseButton1Click:Connect(function()
            SelectTab(Tab)
        end)

        --================================================
        -- DIVIDER
        --================================================

        function Tab:AddDivider(text)
            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 31),
                BackgroundTransparency = 1,
                Parent = page,
            })

            local label = Create("TextLabel", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(8, 0),

                BackgroundTransparency = 1,

                Text = string.upper(tostring(text or "")),
                TextColor3 = Theme.AccentSoft,
                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row,
            })

            SetFont(label, Enum.FontWeight.Bold)

            Create("Frame", {
                Size = UDim2.new(1, -16, 0, 1),
                Position = UDim2.new(0, 8, 1, -1),

                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.35,
                BorderSizePixel = 0,

                Parent = row,
            })

            return row
        end

        --================================================
        -- TOGGLE
        --================================================

        function Tab:AddToggle(options)
            options = options or {}

            local name = options.Name or "Toggle"
            local value = options.Default == true
            local callback = options.Callback or function() end
            local flag = options.Flag

            local row = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 38),

                BackgroundColor3 = Theme.Row,
                BorderSizePixel = 0,

                Text = "",
                AutoButtonColor = false,

                Parent = page,
            })

            Corner(row, 4)
            Stroke(row, Theme.Border, 0.4, 1)

            local label = Create("TextLabel", {
                Size = UDim2.new(1, -54, 1, 0),
                Position = UDim2.fromOffset(12, 0),

                BackgroundTransparency = 1,

                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 12,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row,
            })

            SetFont(label, Enum.FontWeight.Medium)

            local box = Create("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new(1, -31, 0.5, -9),

                BackgroundColor3 = Theme.CheckboxOff,
                BorderSizePixel = 0,

                Parent = row,
            })

            Corner(box, 3)

            local boxStroke = Stroke(
                box,
                Theme.BorderStrong,
                0.05,
                1
            )

            local check = Create("TextLabel", {
                Size = UDim2.fromScale(1, 1),

                BackgroundTransparency = 1,

                Text = "✓",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,

                Visible = false,

                Parent = box,
            })

            SetFont(check, Enum.FontWeight.Bold)

            local function SetValue(newValue, fire)
                value = newValue == true

                if flag then
                    Library.Flags[flag] = value
                end

                if value then
                    Tween(box, 0.09, {
                        BackgroundColor3 = Theme.Accent,
                    })

                    boxStroke.Color = Theme.AccentSoft
                    check.Visible = true
                else
                    Tween(box, 0.09, {
                        BackgroundColor3 = Theme.CheckboxOff,
                    })

                    boxStroke.Color = Theme.BorderStrong
                    check.Visible = false
                end

                if fire then
                    callback(value)
                end
            end

            row.MouseEnter:Connect(function()
                Tween(row, 0.08, {
                    BackgroundColor3 = Theme.RowHover,
                })
            end)

            row.MouseLeave:Connect(function()
                Tween(row, 0.08, {
                    BackgroundColor3 = Theme.Row,
                })
            end)

            row.MouseButton1Click:Connect(function()
                SetValue(not value, true)
            end)

            local Toggle = {}

            function Toggle:Get()
                return value
            end

            function Toggle:Set(newValue)
                SetValue(newValue, true)
            end

            if flag then
                RegisterFlag(flag, value, function(v)
                    SetValue(v, true)
                end)
            end

            SetValue(value, false)

            return Toggle
        end

        --================================================
        -- SLIDER
        --================================================

        function Tab:AddSlider(options)
            options = options or {}

            local name = options.Name or "Slider"
            local min = tonumber(options.Min) or 0
            local max = tonumber(options.Max) or 100
            local value = tonumber(options.Default) or min
            local step = tonumber(options.Step) or tonumber(options.Decimals) or 1
            local callback = options.Callback or function() end
            local flag = options.Flag

            if step <= 0 then
                step = 1
            end

            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 55),

                BackgroundColor3 = Theme.Row,
                BorderSizePixel = 0,

                Parent = page,
            })

            Corner(row, 4)
            Stroke(row, Theme.Border, 0.4, 1)

            local label = Create("TextLabel", {
                Size = UDim2.new(0.68, 0, 0, 24),
                Position = UDim2.fromOffset(12, 3),

                BackgroundTransparency = 1,

                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 12,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row,
            })

            SetFont(label, Enum.FontWeight.Medium)

            local valueLabel = Create("TextLabel", {
                Size = UDim2.new(0.32, -12, 0, 24),
                Position = UDim2.new(0.68, 0, 0, 3),

                BackgroundTransparency = 1,

                Text = "",
                TextColor3 = Theme.AccentSoft,
                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Right,

                Parent = row,
            })

            SetFont(valueLabel, Enum.FontWeight.Bold)

            local bar = Create("TextButton", {
                Size = UDim2.new(1, -24, 0, 8),
                Position = UDim2.fromOffset(12, 36),

                BackgroundColor3 = Theme.SliderTrack,
                BorderSizePixel = 0,

                Text = "",
                AutoButtonColor = false,

                Parent = row,
            })

            Corner(bar, 3)

            local fill = Create("Frame", {
                Size = UDim2.new(0, 0, 1, 0),

                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,

                Parent = bar,
            })

            Corner(fill, 3)

            local knob = Create("Frame", {
                Size = UDim2.fromOffset(12, 12),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,

                Parent = bar,
            })

            Corner(knob, 6)
            Stroke(knob, Theme.Accent, 0.05, 1)

            local dragging = false

            local function Quantize(number)
                local rounded = math.floor((number / step) + 0.5) * step
                return math.clamp(rounded, min, max)
            end

            local function SetValue(newValue, fire)
                value = Quantize(tonumber(newValue) or min)

                if flag then
                    Library.Flags[flag] = value
                end

                local percent = 0

                if max ~= min then
                    percent = (value - min) / (max - min)
                end

                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, 0, 0.5, 0)

                valueLabel.Text = tostring(value)

                if fire then
                    callback(value)
                end
            end

            local function SetFromX(x)
                if bar.AbsoluteSize.X <= 0 then
                    return
                end

                local percent = math.clamp(
                    (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                    0,
                    1
                )

                SetValue(min + ((max - min) * percent), true)
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    SetFromX(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging
                    and input.UserInputType == Enum.UserInputType.MouseMovement
                then
                    SetFromX(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            local Slider = {}

            function Slider:Get()
                return value
            end

            function Slider:Set(newValue)
                SetValue(newValue, true)
            end

            if flag then
                RegisterFlag(flag, value, function(v)
                    SetValue(v, true)
                end)
            end

            SetValue(value, false)

            return Slider
        end

        --================================================
        -- DROPDOWN
        --================================================

        function Tab:AddDropdown(options)
            options = options or {}

            local name = options.Name or "Dropdown"
            local values = options.Options or options.Items or {}
            local default = options.Default
            local callback = options.Callback or function() end
            local flag = options.Flag
            local currentIndex = 1

            if default ~= nil then
                for i, option in ipairs(values) do
                    if tostring(option) == tostring(default) then
                        currentIndex = i
                        break
                    end
                end
            end

            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 44),

                BackgroundColor3 = Theme.Row,
                BorderSizePixel = 0,

                Parent = page,
            })

            Corner(row, 4)
            Stroke(row, Theme.Border, 0.4, 1)

            local label = Create("TextLabel", {
                Size = UDim2.new(0.50, -8, 1, 0),
                Position = UDim2.fromOffset(12, 0),

                BackgroundTransparency = 1,

                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 12,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row,
            })

            SetFont(label, Enum.FontWeight.Medium)

            local select = Create("TextButton", {
                Size = UDim2.new(0.46, -12, 0, 29),
                Position = UDim2.new(0.54, 0, 0.5, -14),

                BackgroundColor3 = Color3.fromRGB(10, 15, 22),
                BorderSizePixel = 0,

                Text = "",
                AutoButtonColor = false,

                Parent = row,
            })

            Corner(select, 3)
            Stroke(select, Theme.BorderStrong, 0.25, 1)

            local valueLabel = Create("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(9, 0),

                BackgroundTransparency = 1,

                Text = "",
                TextColor3 = Theme.Text2,
                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = select,
            })

            SetFont(valueLabel, Enum.FontWeight.SemiBold)

            local arrow = Create("TextLabel", {
                Size = UDim2.fromOffset(24, 29),
                Position = UDim2.new(1, -26, 0, 0),

                BackgroundTransparency = 1,

                Text = "›",
                TextColor3 = Theme.AccentSoft,
                TextSize = 16,

                Parent = select,
            })

            SetFont(arrow, Enum.FontWeight.Bold)

            local function GetValue()
                return values[currentIndex]
            end

            local function SetIndex(index, fire)
                if #values == 0 then
                    valueLabel.Text = "None"

                    if flag then
                        Library.Flags[flag] = nil
                    end

                    return
                end

                if index < 1 then
                    index = #values
                elseif index > #values then
                    index = 1
                end

                currentIndex = index

                local current = values[currentIndex]
                valueLabel.Text = tostring(current)

                if flag then
                    Library.Flags[flag] = current
                end

                if fire then
                    callback(current)
                end
            end

            local function SetValue(newValue, fire)
                for i, option in ipairs(values) do
                    if tostring(option) == tostring(newValue) then
                        SetIndex(i, fire)
                        return
                    end
                end
            end

            select.MouseEnter:Connect(function()
                Tween(select, 0.08, {
                    BackgroundColor3 = Theme.RowHover,
                })
            end)

            select.MouseLeave:Connect(function()
                Tween(select, 0.08, {
                    BackgroundColor3 = Color3.fromRGB(10, 15, 22),
                })
            end)

            -- Simple et rapide : un clic = prochaine valeur.
            select.MouseButton1Click:Connect(function()
                SetIndex(currentIndex + 1, true)
            end)

            local Dropdown = {}

            function Dropdown:Get()
                return GetValue()
            end

            function Dropdown:Set(newValue)
                SetValue(newValue, true)
            end

            function Dropdown:Refresh(newValues)
                values = newValues or {}

                if #values == 0 then
                    currentIndex = 1
                    valueLabel.Text = "None"
                    return
                end

                currentIndex = math.clamp(currentIndex, 1, #values)
                SetIndex(currentIndex, false)
            end

            if flag then
                RegisterFlag(flag, GetValue(), function(v)
                    SetValue(v, true)
                end)
            end

            SetIndex(currentIndex, false)

            return Dropdown
        end

        --================================================
        -- BUTTON
        --================================================

        function Tab:AddButton(options)
            options = options or {}

            local callback = options.Callback or function() end

            local button = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),

                BackgroundColor3 = Theme.Row,
                BorderSizePixel = 0,

                Text = tostring(options.Name or "Button"),
                TextColor3 = Theme.Text,
                TextSize = 11,

                AutoButtonColor = false,

                Parent = page,
            })

            SetFont(button, Enum.FontWeight.SemiBold)
            Corner(button, 4)
            Stroke(button, Theme.Border, 0.35, 1)

            button.MouseEnter:Connect(function()
                Tween(button, 0.08, {
                    BackgroundColor3 = Theme.RowHover,
                })
            end)

            button.MouseLeave:Connect(function()
                Tween(button, 0.08, {
                    BackgroundColor3 = Theme.Row,
                })
            end)

            button.MouseButton1Click:Connect(callback)

            return button
        end

        if #Window.Tabs == 1 then
            SelectTab(Tab)
        end

        return Tab
    end

    --====================================================
    -- PUBLIC METHODS
    --====================================================

    function Window:SetBanner(asset)
        banner.Image = NormalizeAsset(asset)
    end

    function Window:SetTitle(text)
        titleLabel.Text = tostring(text)
    end

    function Window:SetBuild(text)
        buildLabel.Text = tostring(text)
    end

    function Window:Show()
        Window.Visible = true
        gui.Enabled = true
    end

    function Window:Hide()
        Window.Visible = false
        gui.Enabled = false
    end

    function Window:Toggle()
        Window.Visible = not Window.Visible
        gui.Enabled = Window.Visible
    end

    function Window:Destroy()
        gui:Destroy()
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == Enum.KeyCode.RightShift then
            Window:Toggle()
        end
    end)

    return Window
end

return Library
