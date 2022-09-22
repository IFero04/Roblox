repeat wait() until game:IsLoaded()

local sharedUtility = require(game:GetService("ReplicatedStorage").Modules.SharedUtility)
local plot = sharedUtility.GetPlayerTycoon(game:GetService("Players").LocalPlayer)
local SPlot = tostring(plot)

local size = workspace.CurrentCamera.ViewportSize
local a = Drawing.new("Text")

a.Visible = true
a.Size = 16
a.Color = Color3.fromRGB(0, 255, 255)
a.Text = "100x Price"
a.Font = Drawing.Fonts.Plex
a.Outline = true
a.OutlineColor = Color3.new(.1,.1,.1)
a.Position = Vector2.new((size.X - a.TextBounds.X) - 10, (size.Y - a.TextBounds.Y) - 25)

local b = Drawing.new("Text")
b.Visible = true
b.Size = 16
b.Color = Color3.fromRGB(0, 255, 0)
b.Text = tostring(PL)
b.Font = Drawing.Fonts.Plex
b.Outline = true
b.OutlineColor = Color3.new(.1,.1,.1)
b.Position = Vector2.new((size.X - b.TextBounds.X) - 10, (size.Y - b.TextBounds.Y) - 10)

spawn(function()
	while true do
		b.Text = game:GetService("Workspace").Plots[SPlot].Buttons.BuyDropper100.Button.BillboardGui.DropperCost.Text
		wait(0.1)
	end
end)