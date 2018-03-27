--[[
	关卡
--]]
local WildCity = require("Game/Build/Subject/WildCity")

local LevelShiYi = class("LevelShiYi",WildCity)

function LevelShiYi:ctor()
    LevelShiYi.super.ctor(self);
end


return LevelShiYi;