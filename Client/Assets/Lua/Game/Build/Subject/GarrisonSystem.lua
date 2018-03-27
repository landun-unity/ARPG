--[[
	要塞系統
--]]
local List = require("common/List")

local GarrisonSystem = class("GarrisonSystem")

function GarrisonSystem:ctor()

	--驻军列表
	self._allArmyList = List.new()
end


return GarrisonSystem
