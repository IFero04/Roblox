repeat wait() until game:IsLoaded()
local placeID = game.PlaceId

-- // ANTI-AFK \\ --
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

-- // SLIME TOWER TYCOON \\ --
if placeID == 10675066724 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Beaast-exe/Roblox/master/scripts/SlimeTowerTycoon.lua"))()
-- // RACE CLICKER \\ --
elseif placeID == 9285238704 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Beaast-exe/Roblox/master/scripts/RaceClicker.lua"))()
-- // BEE SWARM SIMULATOR \\ --
elseif placeID == 1537690962 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Beaast-exe/Roblox/master/scripts/BeeSwarmSimulator.lua"))()
end
