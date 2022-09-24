-- // VARIABLES \\ --
local virtualUser = game:GetService("VirtualUser")

-- // FEATURE DEFINING \\ --
local settings = {
	autoClick = false
}

-- // UI SETUP \\ --
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "Beaast Hub",
	HidePremium = false,
	SaveConfig = false,
	IntroEnabled = false,
	IntroText = "Beaast Hub"
})

local Main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Autos = Main:AddSection({
	Name = "Autos"
})

local Clicker = Autos:AddToggle({
	Name = "Enable Auto Clicker",
	Default = false,
	Flag = "clicker",
	Callback = function(bool)
		settings.autoClick = bool
		if bool then
			doAutoClick()
		end
	end
})

Autos:AddBind({
	Name = "Toggle Auto Clicker",
	Default = Enum.KeyCode.F,
	Hold = false,
	Callback = function()
		if settings.autoClick then
			Clicker:Set(false)
		else
			Clicker:Set(true)
		end
	end
})

-- // MISC TAB \\ --
local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local CREDITS = Misc:AddSection({
	Name = "Credits"
})

CREDITS:AddButton({
	Name = "COPY DISCORD LINK",
	Callback = function()
		setclipboard('https://discord.gg/MeAXMSCc9Q')
		OrionLib:MakeNotification({
			Name = "COPIED!",
			Content = "Discord link copied to your clipboard!",
			Time = 5
		})
  	end
})

CREDITS:AddLabel("Created by: Beaast#6458")

local UI = Misc:AddSection({
	Name = "UI Options"
})

UI:AddBind({
	Name = "Toggle UI",
	Default = Enum.KeyCode.RightControl,
	Hold = false,
	Callback = function()
		local UI = game:GetService("CoreGui"):FindFirstChild("Orion")
		if UI then
			UI.Enabled = not UI.Enabled
		end
	end
})

UI:AddButton({
	Name = "Destroy UI",
	Callback = function()
		OrionLib:Destroy()
  	end
})

-- // CHEAT FUNCTIONS \\ --

function doAutoWalk()
	spawn(function()
		while settings.autoWalk do
			wait(0.1)
			virtualUser:SetKeyDown(119)
			wait(10)
			virtualUser:SetKeyUp(119)
		end
		virtualUser:SetKeyUp(119)
	end)
end

function doAutoClick()
	spawn(function()
		while settings.autoClick do
			virtualUser:Button1Down(Vector2.new(500,0), workspace.CurrentCamera.CFrame)
			wait(0.01)
			virtualUser:Button1Up(Vector2.new(500,0), workspace.CurrentCamera.CFrame)
		end
		virtualUser:Button1Up(Vector2.new(500,0), workspace.CurrentCamera.CFrame)
	end)
end

-- // INITIALIZE THE SCRIPT \\ --
OrionLib:Init()