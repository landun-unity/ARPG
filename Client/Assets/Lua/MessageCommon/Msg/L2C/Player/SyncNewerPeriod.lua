--
-- 逻辑服务器 --> 客户端
-- 同步新手保护期阶段
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncNewerPeriod = class("SyncNewerPeriod", GameMessage);

--
-- 构造函数
--
function SyncNewerPeriod:ctor()
    SyncNewerPeriod.super.ctor(self);
    --
    -- 当前新手保护期阶段
    --
    self.curNewerPeriod = 0;
    
    --
    -- 新手保护期结束时间
    --
    self.newerPeriodEndTime = 0;
end

--@Override
function SyncNewerPeriod:_OnSerial() 
    self:WriteInt32(self.curNewerPeriod);
    self:WriteInt64(self.newerPeriodEndTime);
end

--@Override
function SyncNewerPeriod:_OnDeserialize() 
    self.curNewerPeriod = self:ReadInt32();
    self.newerPeriodEndTime = self:ReadInt64();
end

return SyncNewerPeriod;
