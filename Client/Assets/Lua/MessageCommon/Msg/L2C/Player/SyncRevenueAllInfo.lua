--
-- 逻辑服务器 --> 客户端
-- 同步税收信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncRevenueAllInfo = class("SyncRevenueAllInfo", GameMessage);

--
-- 构造函数
--
function SyncRevenueAllInfo:ctor()
    SyncRevenueAllInfo.super.ctor(self);
    --
    -- 第一次税收金币
    --
    self.oneGold = 0;
    
    --
    -- 第二次税收金币
    --
    self.twoGold = 0;
    
    --
    -- 第三次税收金币
    --
    self.threeGold = 0;
    
    --
    -- 第一次税收时间
    --
    self.oneTime = 0;
    
    --
    -- 第二次税收时间
    --
    self.twoTime = 0;
    
    --
    -- 第三次税收时间
    --
    self.threeTime = 0;
    
    --
    -- 强征次数
    --
    self.forcedCount = 0;
    
    --
    -- 第二次可领取时间
    --
    self.secondCanClaimTime = 0;
    
    --
    -- 第三次可领取时间
    --
    self.thirdCanClaimTime = 0;
    
    --
    -- 征收次数
    --
    self.surplusReceiveCount = 0;
end

--@Override
function SyncRevenueAllInfo:_OnSerial() 
    self:WriteInt32(self.oneGold);
    self:WriteInt32(self.twoGold);
    self:WriteInt32(self.threeGold);
    self:WriteInt64(self.oneTime);
    self:WriteInt64(self.twoTime);
    self:WriteInt64(self.threeTime);
    self:WriteInt32(self.forcedCount);
    self:WriteInt64(self.secondCanClaimTime);
    self:WriteInt64(self.thirdCanClaimTime);
    self:WriteInt32(self.surplusReceiveCount);
end

--@Override
function SyncRevenueAllInfo:_OnDeserialize() 
    self.oneGold = self:ReadInt32();
    self.twoGold = self:ReadInt32();
    self.threeGold = self:ReadInt32();
    self.oneTime = self:ReadInt64();
    self.twoTime = self:ReadInt64();
    self.threeTime = self:ReadInt64();
    self.forcedCount = self:ReadInt32();
    self.secondCanClaimTime = self:ReadInt64();
    self.thirdCanClaimTime = self:ReadInt64();
    self.surplusReceiveCount = self:ReadInt32();
end

return SyncRevenueAllInfo;
