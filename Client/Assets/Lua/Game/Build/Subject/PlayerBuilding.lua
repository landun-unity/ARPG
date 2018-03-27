--[[
	玩家建筑
--]]

local Building = require("Game/Build/Subject/Building")

local PlayerBuilding = class("PlayerBuilding",Building)

function PlayerBuilding:ctor()
	PlayerBuilding.super.ctor(self);
end


return PlayerBuilding