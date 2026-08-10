local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/DrPurplee/libtest/refs/heads/main/Library.lua"
))()

--========================================================
-- WINDOW
--========================================================

local Window =
	Library:CreateWindow({

		Title = "Main",

		Build =
			"Build 50001 | yourmenu",

		Size =
			UDim2.fromOffset(
				470,
				520
			),

		-- =============================================
		-- TON IMAGE DE BANNIERE
		-- =============================================

		BannerImage =
		"rbxassetid://7129155278"
	})

--========================================================
-- MAIN
--========================================================

local Main =
	Window:AddTab({
		Name = "Main"
	})

Main:AddToggle({
	Name = "Enabled",

	Default = true,

	Callback = function(value)
		print("Enabled:", value)
	end
})

Main:AddToggle({
	Name = "Auto Action",

	Default = false,

	Callback = function(value)
		print("Auto:", value)
	end
})

Main:AddSlider({
	Name = "Speed",

	Min = 0,
	Max = 10,

	Default = 5,

	Step = 0.5,

	Callback = function(value)
		print("Speed:", value)
	end
})

Main:AddDivider("Player Settings")

Main:AddDropdown({
	Name = "Mode",

	Options = {
		"Normal",
		"Smooth",
		"Fast"
	},

	Default = "Normal",

	Callback = function(value)
		print("Mode:", value)
	end
})

Main:AddToggle({
	Name = "Invisible",

	Default = false,

	Callback = function(value)
		print("Invisible:", value)
	end
})

Main:AddToggle({
	Name = "Full Invisible",

	Default = false,

	Callback = function(value)
		print("Full Invisible:", value)
	end
})

--========================================================
-- BYPASSES
--========================================================

local Bypasses =
	Window:AddTab({
		Name = "Bypasses"
	})

Bypasses:AddToggle({
	Name = "Anti Block Control",

	Default = false,

	Callback = function(value)
		print(value)
	end
})

Bypasses:AddToggle({
	Name = "Anti Attach",

	Default = false
})

Bypasses:AddToggle({
	Name = "Anti Attack",

	Default = false
})

Bypasses:AddToggle({
	Name = "Anti VDM",

	Default = false
})

Bypasses:AddToggle({
	Name = "Anti Weapon Block",

	Default = false
})

Bypasses:AddDivider("Admin Protection")

Bypasses:AddToggle({
	Name = "Anti Teleport",

	Default = false
})

Bypasses:AddToggle({
	Name = "Anti Freeze",

	Default = false
})

Bypasses:AddToggle({
	Name = "Anti Carry",

	Default = false
})

--========================================================
-- SETTINGS
--========================================================

local Settings =
	Window:AddTab({
		Name = "Settings"
	})

Settings:AddToggle({
	Name = "Interface Sounds",

	Default = true
})

Settings:AddSlider({
	Name = "Interface Scale",

	Min = 0.8,
	Max = 1.2,

	Default = 1,

	Step = 0.05,

	Callback = function(value)
		print("Scale:", value)
	end
})

Settings:AddDropdown({
	Name = "Theme",

	Options = {
		"Dark",
		"Black",
		"Gray"
	},

	Default = "Dark"
})

Settings:AddDivider("Interface")

Settings:AddButton({
	Name = "Change Banner",

	Callback = function()

		Window:SetBanner(
			"rbxassetid://1234567890"
		)

	end
})

Settings:AddButton({
	Name = "Close Menu",

	Callback = function()
		Window:Hide()
	end
})
