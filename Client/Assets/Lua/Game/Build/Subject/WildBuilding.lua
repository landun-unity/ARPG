--[[
	所有野外建筑
--]]

local Building = require("Game/Build/Subject/Building")

local WildBuilding = class("WildBuilding",Building)

function WildBuilding:ctor()
	WildBuilding.super.ctor(self);
end


return WildBuilding