-- // VARIABLES \\ --
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local remotesPath = game:GetService("ReplicatedStorage").GTycoonClient.Remotes
local RunService = game:GetService("RunService")
local ObbyFinish = game:GetService("Workspace").ObbyButton.Button
local ObbyCheckpoints = game:GetService("Workspace").ObbyCheckpoints
local returnToPlot = game:GetService("Workspace").ReturnPortals:FindFirstChild("ReturnToPlot").Portal

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
	autoObby = {
		enabled = false,
		delaySeconds = 5
	},
	autoObby2 = {
		enabled = false,
		delaySeconds = 5
	},
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
	Default = "100",
	Options = {"1", "5", "25", "50", "100"},
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

MISC:AddSlider({
	Name = "Auto Obby Interval",
	Min = 5,
	Max = 60,
	Default = 10,
	Color = Color3.fromRGB(0, 255, 255),
	Increment = 5,
	Callback = function(value)
		settings.autoObby.delaySeconds = value
	end
})

MISC:AddToggle({
	Name = "Enable Auto Obby",
	Default = false,
	Callback = function(bool)
		settings.autoObby.enabled = bool
		if bool then
			doAutoObby()
		end
	end
})

MISC:AddToggle({
	Name = "Enable Auto Obby (Tween)",
	Default = false,
	Callback = function(bool)
		settings.autoObby2.enabled = bool
		if bool then
			doAutoObby2()
		end
	end
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

function TeleportToMe(item)
	if localPlayer.Character then
		local hrp = localPlayer.Character.HumanoidRootPart
		item.CFrame = hrp.CFrame
	end
end

function TeleportTo(cframe)
	if localPlayer.Character then
		local hrp = localPlayer.Character.HumanoidRootPart
		hrp.CFrame = cframe
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

local obbyCheckpoints = {
	[1] = ObbyCheckpoints.ObbyCheckpoint1.CFrame,
	[2] = ObbyCheckpoints.ObbyCheckpoint2.CFrame,
	[3] = ObbyCheckpoints.ObbyCheckpoint3.CFrame,
	[4] = ObbyCheckpoints.ObbyCheckpoint4.CFrame,
	[5] = ObbyCheckpoints.ObbyCheckpoint5.CFrame,
	[6] = ObbyFinish.CFrame + Vector3.new(0, 20, 0),
	[7] = returnToPlot.CFrame
}

function doAutoObby()
	spawn(function()
		while settings.autoObby.enabled do
			for i, v in ipairs(obbyCheckpoints) do
				TeleportTo(v)
				wait(2)
			end
			wait(settings.autoObby.delaySeconds)
		end
	end)
end

for i, v in pairs(game:GetService("Workspace").DragonBreaths:GetDescendants()) do
	if v.name == "Killer" then
		v:Destroy()
	end
end

function doAutoObby2()
	spawn(function()
		while settings.autoObby2.enabled do
			function Tween(newCFrame)
				local tween = game:GetService("TweenService"):Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2.5), { CFrame = newCFrame })
				tween:Play()
				tween.Completed:Wait()
			end

			local Points = game:GetService("Workspace"):WaitForChild("ObbyCheckpoints")
			for i = 1, 5 do
				local str = tostring("ObbyCheckpoint" .. i)
				Tween(Points[str].CFrame)
			end
			Tween(game:GetService("Workspace"):WaitForChild("ObbyButton"):WaitForChild("Button").CFrame)
		end
	end)
end

local ChatFrame = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Chat"):WaitForChild("Frame"):WaitForChild("ChatChannelParentFrame"):WaitForChild("Frame_MessageLogDisplay"):WaitForChild("Scroller")
local Connection = nil
spawn(function()
	Connection = ChatFrame.ChildAdded:Connect(function(child)
		for i, v in pairs(child:GetChildren()) do
			if v.ClassName == "TextLabel" and v.Text == "You earned a boost from the Wizard's Tower!" then
				child:Destroy()
				for a, b in pairs(ChatFrame:GetChildren()) do
					if b.ClassName == "Frame" and #b:GetChildren() == 0 then
						b:Destroy()
					end
				end
			end
		end
	end)
end)

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