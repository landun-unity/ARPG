--
-- 客户端 --> 逻辑服务器
-- 申请禅让
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ApplyDemise = class("ApplyDemise", GameMessage);

--
-- 构造函数
--
function ApplyDemise:ctor()
    ApplyDemise.super.ctor(self);
    --
    -- 被处理者
    --
    self.targetPlayerid = 0;
end

--@Override
function ApplyDemise:_OnSerial() 
    self:WriteInt64(self.targetPlayerid);
end

--@Override
function ApplyDemise:_OnDeserialize() 
    self.targetPlayerid = self:ReadInt64();
end

return ApplyDemise;
