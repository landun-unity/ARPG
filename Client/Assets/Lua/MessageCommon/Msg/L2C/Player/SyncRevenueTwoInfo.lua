--
-- 逻辑服务器 --> 客户端
-- 同步服务器时间返回
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncRevenueTwoInfo = class("SyncRevenueTwoInfo", GameMessage);

--
-- 构造函数
--
function SyncRevenueTwoInfo:ctor()
    SyncRevenueTwoInfo.super.ctor(self);
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
    
    --
    -- 当前时间
    --
    self.currentTime = 0;
    
    --
    -- 第一次领取的金币
    --
    self.firstGold = 0;
    
    --
    -- 第二次领取的金币
    --
    self.secondGold = 0;

    --
    -- 下一次领取时间
    --
    self.currentTimestamp = 0;


    --
    -- 第三次领取时间
    --
    self.ThreeTime = 0;

end

--@Override
function SyncRevenueTwoInfo:_OnSerial() 
    self:WriteInt64(self.time);
    self:WriteInt32(self.gainTimes);
    self:WriteInt32(self.forceGainTimes);
    self:WriteInt64(self.currentTime);
    self:WriteInt64(self.firstGold);
    self:WriteInt64(self.secondGold)
    self:WriteInt64(self.currentTimestamp);
    self:WriteInt64(self.ThreeTime)
end

--@Override
function SyncRevenueTwoInfo:_OnDeserialize() 
    self.time = self:ReadInt64();
    self.gainTimes = self:ReadInt32();
    self.forceGainTimes = self:ReadInt32();
    self.currentTime = self:ReadInt64();
    self.firstGold = self:ReadInt64();
    self.secondGold = self:ReadInt64();
    self.currentTimestamp = self:ReadInt64();
    self.ThreeTime = self:ReadInt64()
end

return SyncRevenueTwoInfo;
