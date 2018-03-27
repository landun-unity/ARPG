--
-- 客户端 --> 逻辑服务器
-- 罢免官员
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RecallOfficer = class("RecallOfficer", GameMessage);

--
-- 构造函数
--
function RecallOfficer:ctor()
    RecallOfficer.super.ctor(self);
    --
    -- 目标id
    --
    self.targetId = 0;
end

--@Override
function RecallOfficer:_OnSerial() 
    self:WriteInt64(self.targetId);
end

--@Override
function RecallOfficer:_OnDeserialize() 
    self.targetId = self:ReadInt64();
end

return RecallOfficer;
