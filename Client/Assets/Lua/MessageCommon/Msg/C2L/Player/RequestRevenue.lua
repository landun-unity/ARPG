--
-- 客户端 --> 逻辑服务器
-- 请求税收
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestRevenue = class("RequestRevenue", GameMessage);

--
-- 构造函数
--
function RequestRevenue:ctor()
    RequestRevenue.super.ctor(self);
    --
    -- 次数
    --
    self.count = 0;
end

--@Override
function RequestRevenue:_OnSerial() 
    self:WriteInt32(self.count);
end

--@Override
function RequestRevenue:_OnDeserialize() 
    self.count = self:ReadInt32();
end

return RequestRevenue;
