--
-- 逻辑服务器 --> 客户端
-- 同步领取时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncRevenueInfo = class("SyncRevenueInfo", GameMessage);

--
-- 构造函数
--
function SyncRevenueInfo:ctor()
    SyncRevenueInfo.super.ctor(self);
    --
    -- 领取时间
    --
    self.time = 0;
    
    --
    -- 领取次数
    --
    self.gainTimes = 0;
    
    --
    -- 强征领取次数
    --
    self.forceGainTimes = 0;

    self.gold = 0

    self.currentTime = 0

    self.currentTimestamp = 0
end

--@Override
function SyncRevenueInfo:_OnSerial() 
    self:WriteInt64(self.time);
    self:WriteInt32(self.gainTimes);
    self:WriteInt32(self.forceGainTimes);
    self:WriteInt64(self.gold);
    self:WriteInt64(self.currentTime);
    self:WriteInt64(self.currentTimestamp)
end

--@Override
function SyncRevenueInfo:_OnDeserialize() 
    self.time = self:ReadInt64();
    self.gainTimes = self:ReadInt32();
    self.forceGainTimes = self:ReadInt32();
    self.gold = self:ReadInt64();
    self.currentTime = self:ReadInt64();
    self.currentTimestamp = self:ReadInt64()
end

return SyncRevenueInfo;
