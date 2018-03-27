--[[
    请求玩家货币信息
--]]

local GameMessage = require("common/Net/GameMessage");
local RequestDecree = class("RequestDecree", GameMessage);

function RequestDecree:ctor()
    RequestDecree.super.ctor(self);
    
    self.Decree = 0;
end

function RequestDecree:_OnSerial()
	self:WriteInt32(self.Decree);
end

function RequestDecree:_OnDeserialize()
	self.Decree = self:ReadInt32();
end

return RequestDecree;