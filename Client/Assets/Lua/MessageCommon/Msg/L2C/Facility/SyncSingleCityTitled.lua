--
-- 逻辑服务器 --> 客户端
-- 升级设施回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncSingleCityTitled = class("SyncSingleCityTitled", GameMessage);

--
-- 构造函数
--
function SyncSingleCityTitled:ctor()
    SyncSingleCityTitled.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildId = 0;
    
    --
    -- 格子索引
    --
    self.index = 0;
    
    --
    -- 设施对应tableid
    --
    self.tableid = 0;
    
    --
    -- 格子等级
    --
    self.level = 0;
    
    --
    -- 民居对应枚举
    --
    self.folkType = 0;
end

--@Override
function SyncSingleCityTitled:_OnSerial() 
    self:WriteInt64(self.buildId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tableid);
    self:WriteInt32(self.level);
    self:WriteInt32(self.folkType);
end

--@Override
function SyncSingleCityTitled:_OnDeserialize() 
    self.buildId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tableid = self:ReadInt32();
    self.level = self:ReadInt32();
    self.folkType = self:ReadInt32();
end

return SyncSingleCityTitled;
