--[[
	主城
--]]
local City = require("Game/Build/Subject/City")

local MainCity = class("MainCity",City)

function MainCity:ctor()
    MainCity.super.ctor(self);
end


return MainCity