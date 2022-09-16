-- // VARIABLES \\ --
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local remotesPath = game:GetService("ReplicatedStorage").GTycoonClient.Remotes
local RunService = game:GetService("RunService")

local events = {
	Merge = remotesPath.MergeDroppers,
    BuyDropper = remotesPath.BuyDropper,
    BuyRate = remotesPath.BuySpeed,
    Deposit = remotesPath.DepositDrops
}

-- // FEATURE DEFINING \\ --
local settings = {
	autoCollect = false,
	autoMerge = false,
	autoDeposit = false,
	autoBuySlime = {
		enabled = false,
		amount = 1
	},
	autoBuyRate = false,
	walkspeed = 16,
	jumppower = 50
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

Autos:AddToggle({
	Name = "Enable Auto Collect",
	Default = false,
	Callback = function(bool)
		settings.autoCollect = bool
		if bool then
			doAutoCollect()
		end
	end
})

Autos:AddToggle({
	Name = "Enable Auto Deposit",
	Default = false,
	Callback = function(bool)
		settings.autoDeposit = bool
		if bool then
			doAutoDeposit()
		end
	end
})

Autos:AddToggle({
	Name = "Enable Auto Merge",
	Default = false,
	Callback = function(bool)
		settings.autoMerge = bool
		if bool then
			doAutoMerge()
		end
	end
})

local Buy = Main:AddSection({
	Name = 'Buy'
})

Buy:AddDropdown({
	Name = "Buy Slime Amount",
	Default = "50",
	Options = {"1", "5", "25", "50"},
	Callback = function(amount)
		settings.autoBuySlime.amount = amount
	end
})

Buy:AddToggle({
	Name = "Auto Buy Slimes",
	Default = false,
	Callback = function(bool)
		settings.autoBuySlime.enabled = bool
		if bool then
			doAutoBuySlime(settings.autoBuySlime.amount)
		end
	end
})

Buy:AddToggle({
	Name = "Auto Buy Rate",
	Default = false,
	Callback = function(bool)
		settings.autoBuyRate = bool
		if bool then
			doAutoBuyRate()
		end
	end
})

-- // MISC TAB \\ --
local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local MISC = Misc:AddSection({
	Name = "Misc Options"
})

MISC:AddSlider({
	Name = "Walk Speed",
	Min = 16,
	Max = 200,
	Default = 16,
	Color = Color3.fromRGB(0, 255, 255),
	Increment = 1,
	Callback = function(value)
		settings.walkspeed = value
	end
})

MISC:AddSlider({
	Name = "Jump Power",
	Min = 50,
	Max = 200,
	Default = 50,
	Color = Color3.fromRGB(0, 255, 255),
	Increment = 1,
	Callback = function(value)
		settings.jumppower = value
	end
})

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

function TeleportToMe(item)
	if localPlayer.Character then
		local hrp = localPlayer.Character.HumanoidRootPart
		item.CFrame = hrp.CFrame
	end
end

function doAutoCollect()
	for i, v in ipairs(game:GetService("Workspace").Drops:GetChildren()) do
		if v:IsA("Part") and v.Name == "Dropper_Drop" then
			TeleportToMe(v)
		end
	end

	local added
	added = game:GetService("Workspace").Drops.ChildAdded:Connect(function(v)
		wait(0.2)
		if v:IsA("Part") and v.Name == "Dropper_Drop" then
			TeleportToMe(v)
		end
	end)

	spawn(function()
		while task.wait(0.1) do
			if settings.autoCollect ~= true then
				added:Disconnect()
				break;
			end
		end
	end)
end

function doAutoDeposit()
	spawn(function()
		while settings.autoDeposit do
			events.Deposit:FireServer()
			wait(0.1)
		end
	end)
end

function doAutoBuySlime(value)
	spawn(function()
		while settings.autoBuySlime.enabled do
			local amount = value or settings.autoBuySlime.amount
			events.BuyDropper:FireServer(tonumber(amount))
			wait(0.1)
		end
	end)
end

function doAutoBuyRate()
	spawn(function()
		while settings.autoBuyRate do
			events.BuyRate:FireServer(1)
			wait(0.1)
		end
	end)
end

function doAutoMerge()
	spawn(function()
		while settings.autoMerge do
			events.Merge:FireServer()
			wait(0.1)
		end
	end)
end

RunService.Stepped:Connect(function()
	if localPlayer.Character then
		local Humanoid = localPlayer.Character:FindFirstChild("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = tonumber(settings.walkspeed)
			Humanoid.JumpPower = tonumber(settings.jumppower)
			if Humanoid.UseJumpPower ~= true then
				Humanoid.UseJumpPower = true
			end
		end
	end
end)

-- // INITIALIZE THE SCRIPT \\ --
OrionLib:Init()