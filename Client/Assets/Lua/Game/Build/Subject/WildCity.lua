--[[
	野外建筑（除野外要塞军营外其他仅同盟可占领的建筑）
--]]

local WildBuilding = require("Game/Build/Subject/WildBuilding")

local WildCity = class("WildCity",WildBuilding)

function WildCity:ctor()
	WildCity.super.ctor(self);
end


return WildCity