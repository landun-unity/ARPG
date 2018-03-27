--
-- 客户端 --> 逻辑服务器
-- 任命官员
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AppointOfficer = class("AppointOfficer", GameMessage);

--
-- 构造函数
--
function AppointOfficer:ctor()
    AppointOfficer.super.ctor(self);
    --
    -- 被处理者
    --
    self.targetId = 0;
    
    --
    -- 官位
    --
    self.titleId = 0;
end

--@Override
function AppointOfficer:_OnSerial() 
    self:WriteInt64(self.targetId);
    self:WriteInt32(self.titleId);
end

--@Override
function AppointOfficer:_OnDeserialize() 
    self.targetId = self:ReadInt64();
    self.titleId = self:ReadInt32();
end

return AppointOfficer;
