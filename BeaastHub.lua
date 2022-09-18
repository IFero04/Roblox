repeat wait() until game:IsLoaded()
local placeID = game.PlaceId

-- // SLIME TOWER TYCOON \\ --
if placeID == 10675066724 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Beaast-exe/Roblox/master/scripts/SlimeTowerTycoon.lua"))()
elseif placeID == 9285238704 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Beaast-exe/Roblox/master/scripts/RaceClicker.lua"))()
end
