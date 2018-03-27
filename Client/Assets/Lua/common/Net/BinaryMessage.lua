local GameMessage = require("common/Net/GameMessage");
local BinaryMessage = class("BinaryMessage",GameMessage)

-- 二进制消息
function BinaryMessage:ctor()
    -- body
    print("BinaryMessage:ctor");
    BinaryMessage.super.ctor(self);
    self.block = nil;
end

-- @override
function BinaryMessage:_OnSerial()
    self:WriteBytes(self.block:GetBytes(), 0, self.block:GetUseSize());
end

-- @override
function BinaryMessage:_OnDeserialize()
    self:ReadBytes(self.block:GetBytes(), 0, self.block:GetUseSize());
end

return BinaryMessage;