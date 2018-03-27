--
-- 客户端 --> 逻辑服务器
-- 罢免太守
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RecallChief = class("RecallChief", GameMessage);

--
-- 构造函数
--
function RecallChief:ctor()
    RecallChief.super.ctor(self);
    --
    -- 目标id
    --
    self.targetId = 0;
end

--@Override
function RecallChief:_OnSerial() 
    self:WriteInt64(self.targetId);
end

--@Override
function RecallChief:_OnDeserialize() 
    self.targetId = self:ReadInt64();
end

return RecallChief;
