-- // VARIABLES \\ --
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local remotesPath = game:GetService("ReplicatedStorage").GTycoonClient.Remotes

local events = {
	Merge = remotesPath.MergeDroppers,
    Buy_Dropper = remotesPath.BuyDropper,
    Buy_Speed = remotesPath.BuySpeed,
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
	autoBuyRate = false
}

-- // UI SETUP \\ --
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "Beaast Hub",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "BeaastHubSlimeTower",
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
	Default = "1",
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

Misc:AddButton({
	Name = "Destroy UI",
	Callback = function()
      	for i, v in pairs(game.CoreGui:GetDescendants()) do
		if v.Name == "Orion" then
			v:Destroy()
		end
end
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
			events.Buy_Dropper:FireServer(tonumber(amount))
			wait(0.1)
		end
	end)
end

function doAutoBuyRate()
	spawn(function()
		while settings.autoBuyRate do
			events.Buy_Speed:FireServer(1)
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

-- // INITIALIZE THE SCRIPT \\ --
OrionLib.Init()