--
-- 逻辑服务器 --> 客户端
-- 同步税收第三次信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncRevenueThreeInfo = class("SyncRevenueThreeInfo", GameMessage);

--
-- 构造函数
--
function SyncRevenueThreeInfo:ctor()
    SyncRevenueThreeInfo.super.ctor(self);
    --
    -- 第一次领取时间
    --
    self.firstTime = 0;
    
    --
    -- 第二次领取时间
    --
    self.secondTime = 0;
    
    --
    -- 第三次领取时间
    --
    self.thirdTime = 0;
    
    --
    -- 第一次领取金币
    --
    self.firstGold = 0;
    
    --
    -- 第二次领取金币
    --
    self.secondGold = 0;
    
    --
    -- 第三次领取金币
    --
    self.thirdGold = 0;
    
    --
    -- 领取次数
    --
    self.gainTimes = 0;
    
    --
    -- 强征领取次数
    --
    self.forceGainTimes = 0;
end

--@Override
function SyncRevenueThreeInfo:_OnSerial() 
    self:WriteInt64(self.firstTime);
    self:WriteInt64(self.secondTime);
    self:WriteInt64(self.thirdTime);
    self:WriteInt64(self.firstGold);
    self:WriteInt64(self.secondGold);
    self:WriteInt64(self.thirdGold);
    self:WriteInt32(self.gainTimes);
    self:WriteInt32(self.forceGainTimes);
end

--@Override
function SyncRevenueThreeInfo:_OnDeserialize() 
    self.firstTime = self:ReadInt64();
    self.secondTime = self:ReadInt64();
    self.thirdTime = self:ReadInt64();
    self.firstGold = self:ReadInt64();
    self.secondGold = self:ReadInt64();
    self.thirdGold = self:ReadInt64();
    self.gainTimes = self:ReadInt32();
    self.forceGainTimes = self:ReadInt32();
end

return SyncRevenueThreeInfo;
