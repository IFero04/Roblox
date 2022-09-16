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
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
	Name = "",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "BeaastHubSlimeTower",
	IntroEnabled = true,
	IntroText = "Beaast Hub"
})

local Main = Window:MakeTab({
	Name = "Tab 1",
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
end

-- // MISC TAB \\ --
local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Misc:AddButton({
	Name = "Destroy UI",
	CallBack = function()
		print("teste")
	end
})

-- // INITIALIZE THE SCRIPT \\ --
OrionLib.Init()