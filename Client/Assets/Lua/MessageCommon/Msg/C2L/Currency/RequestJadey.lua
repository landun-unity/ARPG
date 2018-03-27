--[[
    请求玩家货币信息
--]]

local GameMessage = require("common/Net/GameMessage");
local RequestJadey = class("RequestJadey", GameMessage);

function RequestJadey:ctor()
    RequestJadey.super.ctor(self);
    
    self.jade = 0;
end

function RequestJadey:_OnSerial()
	self:WriteInt32(self.jade);
end

function RequestJadey:_OnDeserialize()
	self.jade = self:ReadInt32();
end

return RequestJadey;