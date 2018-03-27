--
-- 客户端 --> 逻辑服务器
-- 请求服务器验证并开启新手保护期某个阶段
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOpenNewerPeriod = class("RequestOpenNewerPeriod", GameMessage);

--
-- 构造函数
--
function RequestOpenNewerPeriod:ctor()
    RequestOpenNewerPeriod.super.ctor(self);
    --
    -- 新手保护期阶段
    --
    self.newerPeriod = 0;
end

--@Override
function RequestOpenNewerPeriod:_OnSerial() 
    self:WriteInt32(self.newerPeriod);
end

--@Override
function RequestOpenNewerPeriod:_OnDeserialize() 
    self.newerPeriod = self:ReadInt32();
end

return RequestOpenNewerPeriod;
