--
-- 逻辑服务器 --> 客户端
-- 创建要塞回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncCreatePlayerBuilding = class("SyncCreatePlayerBuilding", GameMessage);

--
-- 构造函数
--
function SyncCreatePlayerBuilding:ctor()
    SyncCreatePlayerBuilding.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物索引
    --
    self.index = 0;
    
    --
    -- 表Id
    --
    self.tableId = 0;
    
    --
    -- 玩家Id
    --
    self.ownerId = 0;
    
    --
    -- 建筑物Name
    --
    self.cityName = "";
    
    --
    -- 要塞等级
    --
    self.fortLev = 0;
end

--@Override
function SyncCreatePlayerBuilding:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tableId);
    self:WriteInt64(self.ownerId);
    self:WriteString(self.cityName);
    self:WriteInt32(self.fortLev);
end

--@Override
function SyncCreatePlayerBuilding:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tableId = self:ReadInt32();
    self.ownerId = self:ReadInt64();
    self.cityName = self:ReadString();
    self.fortLev = self:ReadInt32();
end

return SyncCreatePlayerBuilding;
