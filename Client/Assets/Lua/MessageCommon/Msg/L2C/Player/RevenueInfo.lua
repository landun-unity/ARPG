--
-- 逻辑服务器 --> 客户端
-- 税收信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RevenueInfo = class("RevenueInfo", GameMessage);

--
-- 构造函数
--
function RevenueInfo:ctor()
    RevenueInfo.super.ctor(self);
    --
    -- 税收金币
    --
    self.gold = 0;
    
    --
    -- 税收次数
    --
    self.count = 0;
    
    --
    -- 当前时间
    --
    self.time = 0;
    
    --
    -- 税收完成时间
    --
    self.finishTime = 0;
    
    --
    -- 强增次数
    --
    self.forceCount = 0;
end

--@Override
function RevenueInfo:_OnSerial() 
    self:WriteInt32(self.gold);
    self:WriteInt32(self.count);
    self:WriteInt64(self.time);
    self:WriteInt64(self.finishTime);
    self:WriteInt32(self.forceCount);
end

--@Override
function RevenueInfo:_OnDeserialize() 
    self.gold = self:ReadInt32();
    self.count = self:ReadInt32();
    self.time = self:ReadInt64();
    self.finishTime = self:ReadInt64();
    self.forceCount = self:ReadInt32();
end

return RevenueInfo;
