--
-- 客户端 --> 逻辑服务器
-- 任命太守
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AppointChief = class("AppointChief", GameMessage);

--
-- 构造函数
--
function AppointChief:ctor()
    AppointChief.super.ctor(self);
    --
    -- 被处理者
    --
    self.targetId = 0;
    
    --
    -- 太守id
    --
    self.chiefId = 0;
end

--@Override
function AppointChief:_OnSerial() 
    self:WriteInt64(self.targetId);
    self:WriteInt32(self.chiefId);
end

--@Override
function AppointChief:_OnDeserialize() 
    self.targetId = self:ReadInt64();
    self.chiefId = self:ReadInt32();
end

return AppointChief;
