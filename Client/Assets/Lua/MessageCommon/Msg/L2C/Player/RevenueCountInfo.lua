--
-- 逻辑服务器 --> 客户端
-- 税收次数
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RevenueCountInfo = class("RevenueCountInfo", GameMessage);

--
-- 构造函数
--
function RevenueCountInfo:ctor()
    RevenueCountInfo.super.ctor(self);
    --
    -- 税收次数
    --
    self.count = 0;
end

--@Override
function RevenueCountInfo:_OnSerial() 
    self:WriteInt32(self.count);
end

--@Override
function RevenueCountInfo:_OnDeserialize() 
    self.count = self:ReadInt32();
end

return RevenueCountInfo;
