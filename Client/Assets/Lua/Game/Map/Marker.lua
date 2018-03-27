
local GamePart = require("FrameWork/Game/GamePart")

local Marker = class("Marker",GamePart)

function Marker:ctor()
    Marker.super.ctor(self)
    -- 标记名字
    self.name = nil;
    -- 标记索引
    self.tiledIndex = nil;
end

function Marker:SetName(name)
	self.name = name
end

function Marker:GetName()
	return self.name
end

function Marker:SetTiledIndex(tiledIndex)
	self.tiledIndex = tiledIndex
end

function Marker:GetTiledIndex()
	return self.tiledIndex
end


return Marker