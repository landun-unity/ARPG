--
-- 客户端 --> 逻辑服务器
-- 取消禅让
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CancelDemise = class("CancelDemise", GameMessage);

--
-- 构造函数
--
function CancelDemise:ctor()
    CancelDemise.super.ctor(self);
    --
    -- 被禅让者
    --
    self.targetPlayerid = 0;
end

--@Override
function CancelDemise:_OnSerial() 
    self:WriteInt64(self.targetPlayerid);
end

--@Override
function CancelDemise:_OnDeserialize() 
    self.targetPlayerid = self:ReadInt64();
end

return CancelDemise;
