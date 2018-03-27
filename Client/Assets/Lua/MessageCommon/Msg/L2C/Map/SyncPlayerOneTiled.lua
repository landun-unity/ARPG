--
-- 逻辑服务器 --> 客户端
-- 同步一个格子信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncPlayerOneTiled = class("SyncPlayerOneTiled", GameMessage);

--
-- 构造函数
--
function SyncPlayerOneTiled:ctor()
    SyncPlayerOneTiled.super.ctor(self);
    --
    -- 土地Id
    --
    self.tiledId = 0;
    
    --
    -- 土地表Id
    --
    self.tiledTableId = 0;
    
    --
    -- 当前地块耐久
    --
    self.curDurableVal = 0;
    
    --
    -- 地块耐久最大值
    --
    self.maxDurableVal = 0;
    
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物表Id
    --
    self.buildingTableId = 0;
    
    --
    -- 是否有城区
    --
    self.isHaveTown = 0;
    
    --
    -- 城区建筑Id
    --
    self.buildingIdForTown = 0;
    
    --
    -- 城区建筑表Id
    --
    self.buildingTableIdForTown = 0;
end

--@Override
function SyncPlayerOneTiled:_OnSerial() 
    self:WriteInt32(self.tiledId);
    self:WriteInt32(self.tiledTableId);
    self:WriteInt32(self.curDurableVal);
    self:WriteInt32(self.maxDurableVal);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.buildingTableId);
    self:WriteInt32(self.isHaveTown);
    self:WriteInt64(self.buildingIdForTown);
    self:WriteInt32(self.buildingTableIdForTown);
end

--@Override
function SyncPlayerOneTiled:_OnDeserialize() 
    self.tiledId = self:ReadInt32();
    self.tiledTableId = self:ReadInt32();
    self.curDurableVal = self:ReadInt32();
    self.maxDurableVal = self:ReadInt32();
    self.buildingId = self:ReadInt64();
    self.buildingTableId = self:ReadInt32();
    self.isHaveTown = self:ReadInt32();
    self.buildingIdForTown = self:ReadInt64();
    self.buildingTableIdForTown = self:ReadInt32();
end

return SyncPlayerOneTiled;
