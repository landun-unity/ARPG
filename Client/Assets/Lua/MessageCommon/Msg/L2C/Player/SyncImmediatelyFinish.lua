--
-- 逻辑服务器 --> 客户端
-- 同步服务器时间返回
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncImmediatelyFinish = class("SyncImmediatelyFinish", GameMessage);

--
-- 构造函数
--
function SyncImmediatelyFinish:ctor()
    SyncImmediatelyFinish.super.ctor(self);
    --
    -- 金币
    --
    self.gold = 0;
    
    --
    -- 时间
    --
    self.time = 0;
    
    --
    -- 次数
    --
    self.surplusReceiveCount = 0;
end

--@Override
function SyncImmediatelyFinish:_OnSerial() 
    self:WriteInt64(self.gold);
    self:WriteInt64(self.time);
    self:WriteInt32(self.surplusReceiveCount);
end

--@Override
function SyncImmediatelyFinish:_OnDeserialize() 
    self.gold = self:ReadInt64();
    self.time = self:ReadInt64();
    self.surplusReceiveCount = self:ReadInt32();
end

return SyncImmediatelyFinish;
