--[[
	分城
--]]
local City = require("Game/Build/Subject/City")

local SubCity = class("SubCity",City)

function SubCity:ctor()
    SubCity.super.ctor(self);
end


return SubCity