--
-- 逻辑服务器 --> 客户端
-- 创建分城回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncCreatePlayerSubCity = class("SyncCreatePlayerSubCity", GameMessage);

--
-- 构造函数
--
function SyncCreatePlayerSubCity:ctor()
    SyncCreatePlayerSubCity.super.ctor(self);
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
end

--@Override
function SyncCreatePlayerSubCity:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tableId);
    self:WriteInt32(self.ownerId);
    self:WriteString(self.cityName);
end

--@Override
function SyncCreatePlayerSubCity:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tableId = self:ReadInt32();
    self.ownerId = self:ReadInt32();
    self.cityName = self:ReadString();
end

return SyncCreatePlayerSubCity;
