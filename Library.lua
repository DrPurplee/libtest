--[[
    Tel-Aviv Click UI Library
    - Interface compacte à droite
    - Bannière configurable
    - Tabs cliquables
    - Checkboxes carrées
    - Sliders à la souris
    - Dropdowns cliquables
    - RightShift pour afficher / masquer
    - API compatible avec les scripts migrés:
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
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local Library = {}

-- Compatibilité avec les scripts qui lisent Library.Theme.
Library.Theme = {
    Background = Color3.fromRGB(7, 11, 18),
    Panel = Color3.fromRGB(11, 18, 29),
    Element = Color3.fromRGB(15, 25, 40),
    ElementHover = Color3.fromRGB(20, 34, 54),

    Accent = Color3.fromRGB(36, 116, 255),
    Accent2 = Color3.fromRGB(66, 153, 255),
    AccentDark = Color3.fromRGB(20, 66, 135),

    Outline = Color3.fromRGB(34, 63, 99),
    OutlineBright = Color3.fromRGB(52, 96, 145),

    Text = Color3.fromRGB(255, 255, 255),
    ["Dark Text"] = Color3.fromRGB(155, 178, 208),
    ["Dark Icon"] = Color3.fromRGB(106, 139, 180),

    Muted = Color3.fromRGB(118, 145, 178),
    Success = Color3.fromRGB(91, 208, 145)
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

local function Create(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    return object
end

local function Corner(object, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = object
    })
end

local function Stroke(object, color, transparency, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Outline,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
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

local function UseFont(guiObject, weight)
    pcall(function()
        guiObject.FontFace = Font.new(
            "rbxasset://fonts/families/GothamSSm.json",
            weight or Enum.FontWeight.Medium,
            Enum.FontStyle.Normal
        )
    end)
end

local function NormalizeAsset(value)
    if value == nil then
        return ""
    end

    if typeof(value) == "number" then
        return "rbxassetid://" .. tostring(value)
    end

    local str = tostring(value)
    local id = str:match("%d+")

    if id then
        return "rbxassetid://" .. id
    end

    return str
end

local function RegisterFlag(flag, initialValue, setter)
    if not flag or flag == "" then
        return
    end

    Library.Flags[flag] = initialValue

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

    local title = options.Title or "Main"
    local build = options.Build or ("Build | " .. Player.Name)
    local size = options.Size or UDim2.fromOffset(480, 560)
    local bannerImage = NormalizeAsset(options.BannerImage)

    local gui = Create("ScreenGui", {
        Name = "TelAvivClickUI",
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

        -- Compact, collé à droite.
        Position = UDim2.new(1, -24, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),

        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,

        ClipsDescendants = true,

        Parent = gui
    })

    Corner(main, 9)
    Stroke(main, Theme.OutlineBright, 0.18, 1)

    -- Trait bleu supérieur.
    local topAccent = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 20,
        Parent = main
    })

    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.AccentDark),
            ColorSequenceKeypoint.new(0.5, Theme.Accent2),
            ColorSequenceKeypoint.new(1, Theme.Accent)
        }),
        Parent = topAccent
    })

    --====================================================
    -- BANNER
    --====================================================

    local banner = Create("ImageLabel", {
        Name = "Banner",
        Size = UDim2.new(1, 0, 0, 126),
        Position = UDim2.fromOffset(0, 2),

        BackgroundColor3 = Color3.fromRGB(8, 14, 23),
        BorderSizePixel = 0,

        Image = bannerImage,
        ImageTransparency = 0,

        ScaleType = Enum.ScaleType.Crop,

        Parent = main
    })

    -- Léger fondu uniquement tout en bas pour connecter la bannière au menu.
    local bannerFade = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 1, -34),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = banner
    })

    Create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.05)
        }),
        Rotation = 90,
        Parent = bannerFade
    })

    --====================================================
    -- HEADER
    --====================================================

    local header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        Position = UDim2.fromOffset(0, 128),

        BackgroundColor3 = Color3.fromRGB(8, 14, 23),
        BorderSizePixel = 0,

        Parent = main
    })

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(0.55, -14, 1, 0),
        Position = UDim2.fromOffset(14, 0),

        BackgroundTransparency = 1,

        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 13,

        TextXAlignment = Enum.TextXAlignment.Left,

        Parent = header
    })

    UseFont(titleLabel, Enum.FontWeight.SemiBold)

    local buildLabel = Create("TextLabel", {
        Size = UDim2.new(0.45, -14, 1, 0),
        Position = UDim2.new(0.55, 0, 0, 0),

        BackgroundTransparency = 1,

        Text = build,
        TextColor3 = Theme.Muted,
        TextSize = 9,

        TextXAlignment = Enum.TextXAlignment.Right,

        Parent = header
    })

    UseFont(buildLabel, Enum.FontWeight.Medium)

    Create("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 1, -1),

        BackgroundColor3 = Theme.Outline,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,

        Parent = header
    })

    --====================================================
    -- TABS
    --====================================================

    local tabsHolder = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 38),
        Position = UDim2.fromOffset(10, 171),

        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,

        Parent = main
    })

    Corner(tabsHolder, 6)
    Stroke(tabsHolder, Theme.Outline, 0.45)

    local tabsLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabsHolder
    })

    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = tabsHolder
    })

    --====================================================
    -- CONTENT
    --====================================================

    local content = Create("Frame", {
        Size = UDim2.new(1, -20, 1, -252),
        Position = UDim2.fromOffset(10, 217),

        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,

        ClipsDescendants = true,

        Parent = main
    })

    Corner(content, 7)
    Stroke(content, Theme.Outline, 0.38)

    --====================================================
    -- FOOTER
    --====================================================

    local footer = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 23),
        Position = UDim2.new(0, 10, 1, -28),

        BackgroundTransparency = 1,

        Text = "RIGHT SHIFT  •  menu",
        TextColor3 = Theme.Muted,
        TextSize = 8,

        TextXAlignment = Enum.TextXAlignment.Left,

        Parent = main
    })

    UseFont(footer, Enum.FontWeight.Medium)

    --====================================================
    -- WINDOW OBJECT
    --====================================================

    local Window = {
        Gui = gui,
        Main = main,
        Banner = banner,
        Tabs = {},
        CurrentTab = nil,
        Visible = true
    }

    --====================================================
    -- TAB SELECT
    --====================================================

    local function SelectTab(tab)
        for _, other in ipairs(Window.Tabs) do
            local active = other == tab

            other.Page.Visible = active

            if active then
                Tween(other.Button, 0.12, {
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 0.05
                })

                Tween(other.Label, 0.12, {
                    TextColor3 = Theme.Text
                })
            else
                Tween(other.Button, 0.12, {
                    BackgroundColor3 = Theme.Element,
                    BackgroundTransparency = 0.32
                })

                Tween(other.Label, 0.12, {
                    TextColor3 = Theme.Muted
                })
            end
        end

        Window.CurrentTab = tab
    end

    --====================================================
    -- ADD TAB
    --====================================================

    function Window:AddTab(options)
        options = options or {}

        local name = options.Name or "Tab"

        local button = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),

            BackgroundColor3 = Theme.Element,
            BackgroundTransparency = 0.32,

            BorderSizePixel = 0,
            Text = "",

            AutoButtonColor = false,

            Parent = tabsHolder
        })

        Corner(button, 5)

        local label = Create("TextLabel", {
            Size = UDim2.fromScale(1, 1),

            BackgroundTransparency = 1,

            Text = name,
            TextColor3 = Theme.Muted,
            TextSize = 10,

            Parent = button
        })

        UseFont(label, Enum.FontWeight.SemiBold)

        local page = Create("ScrollingFrame", {
            Name = name .. "Page",

            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.fromOffset(5, 5),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,

            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,

            Visible = false,

            Parent = content
        })

        local pageLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })

        Create("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            Parent = page
        })

        local Tab = {
            Name = name,
            Button = button,
            Label = label,
            Page = page
        }

        table.insert(Window.Tabs, Tab)

        -- Toujours 3 tabs max visuellement propres, mais reste compatible
        -- si un script en ajoute plus.
        for _, existing in ipairs(Window.Tabs) do
            existing.Button.Size = UDim2.new(
                1 / #Window.Tabs,
                -4,
                1,
                0
            )
        end

        button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(button, 0.1, {
                    BackgroundColor3 = Theme.ElementHover,
                    BackgroundTransparency = 0.15
                })
            end
        end)

        button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(button, 0.1, {
                    BackgroundColor3 = Theme.Element,
                    BackgroundTransparency = 0.32
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
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = page
            })

            local line = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 1),
                Position = UDim2.new(0, 8, 0.5, 0),

                BackgroundColor3 = Theme.Outline,
                BackgroundTransparency = 0.35,

                BorderSizePixel = 0,

                Parent = row
            })

            local label = Create("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.new(0, 0, 0, 18),
                Position = UDim2.new(0, 12, 0.5, -9),

                BackgroundColor3 = Theme.Panel,
                BorderSizePixel = 0,

                Text = "  " .. tostring(text or "") .. "  ",
                TextColor3 = Theme.Accent2,
                TextSize = 9,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row
            })

            UseFont(label, Enum.FontWeight.SemiBold)

            return row
        end

        --================================================
        -- TOGGLE / CHECKBOX
        --================================================

        function Tab:AddToggle(options)
            options = options or {}

            local name = options.Name or "Toggle"
            local value = options.Default == true
            local callback = options.Callback or function() end
            local flag = options.Flag

            local row = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),

                BackgroundColor3 = Theme.Element,
                BackgroundTransparency = 0.14,

                BorderSizePixel = 0,
                Text = "",

                AutoButtonColor = false,

                Parent = page
            })

            Corner(row, 5)
            Stroke(row, Theme.Outline, 0.55)

            local label = Create("TextLabel", {
                Size = UDim2.new(1, -55, 1, 0),
                Position = UDim2.fromOffset(12, 0),

                BackgroundTransparency = 1,

                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row
            })

            UseFont(label, Enum.FontWeight.Medium)

            local box = Create("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new(1, -31, 0.5, -9),

                BackgroundColor3 = Color3.fromRGB(10, 18, 29),
                BorderSizePixel = 0,

                Parent = row
            })

            Corner(box, 4)

            local boxStroke = Stroke(
                box,
                Theme.OutlineBright,
                0.15
            )

            local check = Create("TextLabel", {
                Size = UDim2.fromScale(1, 1),

                BackgroundTransparency = 1,

                Text = "✓",
                TextColor3 = Theme.Text,
                TextSize = 13,

                Visible = false,

                Parent = box
            })

            UseFont(check, Enum.FontWeight.Bold)

            local function SetValue(newValue, fromFlag)
                value = newValue == true

                if flag then
                    Library.Flags[flag] = value
                end

                if value then
                    Tween(box, 0.12, {
                        BackgroundColor3 = Theme.Accent
                    })

                    boxStroke.Color = Theme.Accent2
                    check.Visible = true
                else
                    Tween(box, 0.12, {
                        BackgroundColor3 = Color3.fromRGB(10, 18, 29)
                    })

                    boxStroke.Color = Theme.OutlineBright
                    check.Visible = false
                end

                if fromFlag ~= false then
                    callback(value)
                end
            end

            row.MouseEnter:Connect(function()
                Tween(row, 0.1, {
                    BackgroundColor3 = Theme.ElementHover
                })
            end)

            row.MouseLeave:Connect(function()
                Tween(row, 0.1, {
                    BackgroundColor3 = Theme.Element
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
                RegisterFlag(
                    flag,
                    value,
                    function(newValue)
                        SetValue(newValue, true)
                    end
                )
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

            local step =
                tonumber(options.Step)
                or tonumber(options.Decimals)
                or 1

            if step <= 0 then
                step = 1
            end

            local callback = options.Callback or function() end
            local flag = options.Flag

            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 50),

                BackgroundColor3 = Theme.Element,
                BackgroundTransparency = 0.14,

                BorderSizePixel = 0,

                Parent = page
            })

            Corner(row, 5)
            Stroke(row, Theme.Outline, 0.55)

            local label = Create("TextLabel", {
                Size = UDim2.new(0.65, 0, 0, 22),
                Position = UDim2.fromOffset(12, 3),

                BackgroundTransparency = 1,

                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row
            })

            UseFont(label, Enum.FontWeight.Medium)

            local valueLabel = Create("TextLabel", {
                Size = UDim2.new(0.35, -12, 0, 22),
                Position = UDim2.new(0.65, 0, 0, 3),

                BackgroundTransparency = 1,

                Text = "",
                TextColor3 = Theme.Accent2,
                TextSize = 9,

                TextXAlignment = Enum.TextXAlignment.Right,

                Parent = row
            })

            UseFont(valueLabel, Enum.FontWeight.SemiBold)

            local bar = Create("TextButton", {
                Size = UDim2.new(1, -24, 0, 7),
                Position = UDim2.fromOffset(12, 33),

                BackgroundColor3 = Color3.fromRGB(8, 15, 26),
                BorderSizePixel = 0,

                Text = "",
                AutoButtonColor = false,

                Parent = row
            })

            Corner(bar, 4)
            Stroke(bar, Theme.Outline, 0.45)

            local fill = Create("Frame", {
                Size = UDim2.new(0, 0, 1, 0),

                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,

                Parent = bar
            })

            Corner(fill, 4)

            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Theme.AccentDark),
                    ColorSequenceKeypoint.new(1, Theme.Accent2)
                }),
                Parent = fill
            })

            local knob = Create("Frame", {
                Size = UDim2.fromOffset(11, 11),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundColor3 = Theme.Text,
                BorderSizePixel = 0,

                Parent = bar
            })

            Corner(knob, 6)
            Stroke(knob, Theme.Accent, 0.05)

            local dragging = false

            local function Quantize(number)
                local rounded =
                    math.floor((number / step) + 0.5) * step

                -- évite les artefacts 0.30000004
                local precision = 0
                local stepText = tostring(step)
                local dot = stepText:find("%.")

                if dot then
                    precision = #stepText - dot
                end

                if precision > 0 then
                    local mult = 10 ^ precision
                    rounded = math.floor(rounded * mult + 0.5) / mult
                end

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
                    (x - bar.AbsolutePosition.X)
                        / bar.AbsoluteSize.X,
                    0,
                    1
                )

                local newValue =
                    min + ((max - min) * percent)

                SetValue(newValue, true)
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then
                    dragging = true
                    SetFromX(input.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging
                    and input.UserInputType
                    == Enum.UserInputType.MouseMovement
                then
                    SetFromX(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType
                    == Enum.UserInputType.MouseButton1
                then
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
                RegisterFlag(
                    flag,
                    value,
                    function(newValue)
                        SetValue(newValue, true)
                    end
                )
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
            local values =
                options.Options
                or options.Items
                or {}

            local currentIndex = 1
            local callback = options.Callback or function() end
            local flag = options.Flag

            local default = options.Default

            if default ~= nil then
                for index, option in ipairs(values) do
                    if tostring(option) == tostring(default) then
                        currentIndex = index
                        break
                    end
                end
            end

            local row = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42),

                BackgroundColor3 = Theme.Element,
                BackgroundTransparency = 0.14,

                BorderSizePixel = 0,

                Parent = page
            })

            Corner(row, 5)
            Stroke(row, Theme.Outline, 0.55)

            local label = Create("TextLabel", {
                Size = UDim2.new(0.48, -8, 1, 0),
                Position = UDim2.fromOffset(12, 0),

                BackgroundTransparency = 1,

                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = row
            })

            UseFont(label, Enum.FontWeight.Medium)

            local valueButton = Create("TextButton", {
                Size = UDim2.new(0.48, -12, 0, 28),
                Position = UDim2.new(0.52, 0, 0.5, -14),

                BackgroundColor3 = Color3.fromRGB(9, 17, 29),
                BorderSizePixel = 0,

                Text = "",
                AutoButtonColor = false,

                Parent = row
            })

            Corner(valueButton, 4)
            Stroke(valueButton, Theme.OutlineBright, 0.35)

            local valueLabel = Create("TextLabel", {
                Size = UDim2.new(1, -28, 1, 0),
                Position = UDim2.fromOffset(9, 0),

                BackgroundTransparency = 1,

                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 9,

                TextXAlignment = Enum.TextXAlignment.Left,

                Parent = valueButton
            })

            UseFont(valueLabel, Enum.FontWeight.Medium)

            local arrow = Create("TextLabel", {
                Size = UDim2.fromOffset(24, 28),
                Position = UDim2.new(1, -26, 0, 0),

                BackgroundTransparency = 1,

                Text = "›",
                TextColor3 = Theme.Accent2,
                TextSize = 15,

                Parent = valueButton
            })

            UseFont(arrow, Enum.FontWeight.SemiBold)

            local function GetValue()
                return values[currentIndex]
            end

            local function SetIndex(index, fire)
                if #values == 0 then
                    currentIndex = 1
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

                local currentValue = GetValue()
                valueLabel.Text = tostring(currentValue)

                if flag then
                    Library.Flags[flag] = currentValue
                end

                if fire then
                    callback(currentValue)
                end
            end

            local function SetValue(newValue, fire)
                if #values == 0 then
                    return
                end

                for index, option in ipairs(values) do
                    if tostring(option) == tostring(newValue) then
                        SetIndex(index, fire)
                        return
                    end
                end
            end

            valueButton.MouseEnter:Connect(function()
                Tween(valueButton, 0.1, {
                    BackgroundColor3 = Theme.ElementHover
                })
            end)

            valueButton.MouseLeave:Connect(function()
                Tween(valueButton, 0.1, {
                    BackgroundColor3 = Color3.fromRGB(9, 17, 29)
                })
            end)

            -- Un clic = prochaine valeur.
            valueButton.MouseButton1Click:Connect(function()
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

                currentIndex = math.clamp(
                    currentIndex,
                    1,
                    #values
                )

                SetIndex(currentIndex, false)
            end

            if flag then
                RegisterFlag(
                    flag,
                    GetValue(),
                    function(newValue)
                        SetValue(newValue, true)
                    end
                )
            end

            SetIndex(currentIndex, false)

            return Dropdown
        end

        --================================================
        -- BUTTON
        --================================================

        function Tab:AddButton(options)
            options = options or {}

            local callback =
                options.Callback
                or function() end

            local button = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),

                BackgroundColor3 = Theme.Element,
                BackgroundTransparency = 0.08,

                BorderSizePixel = 0,

                Text = tostring(options.Name or "Button"),
                TextColor3 = Theme.Text,
                TextSize = 10,

                AutoButtonColor = false,

                Parent = page
            })

            UseFont(button, Enum.FontWeight.SemiBold)

            Corner(button, 5)
            Stroke(button, Theme.Outline, 0.42)

            button.MouseEnter:Connect(function()
                Tween(button, 0.1, {
                    BackgroundColor3 = Theme.AccentDark
                })
            end)

            button.MouseLeave:Connect(function()
                Tween(button, 0.1, {
                    BackgroundColor3 = Theme.Element
                })
            end)

            button.MouseButton1Click:Connect(function()
                callback()
            end)

            return button
        end

        if #Window.Tabs == 1 then
            SelectTab(Tab)
        end

        return Tab
    end

    --====================================================
    -- WINDOW METHODS
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

    --====================================================
    -- RIGHT SHIFT
    --====================================================

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
