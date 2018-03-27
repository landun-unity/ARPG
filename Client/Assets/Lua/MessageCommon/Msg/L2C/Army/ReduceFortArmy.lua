--
-- 逻辑服务器 --> 客户端
-- 增减要塞部队
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReduceFortArmy = class("ReduceFortArmy", GameMessage);

--
-- 构造函数
--
function ReduceFortArmy:ctor()
    ReduceFortArmy.super.ctor(self);
    --
    -- 部队当前所在buildingid
    --
    self.curBuildingId = 0;
    
    --
    -- 部队出生建筑物id
    --
    self.spawnBuildingId = 0;
    
    --
    -- 出生建筑物index
    --
    self.spawnIndex = 0;
end

--@Override
function ReduceFortArmy:_OnSerial() 
    self:WriteInt64(self.curBuildingId);
    self:WriteInt64(self.spawnBuildingId);
    self:WriteInt32(self.spawnIndex);
end

--@Override
function ReduceFortArmy:_OnDeserialize() 
    self.curBuildingId = self:ReadInt64();
    self.spawnBuildingId = self:ReadInt64();
    self.spawnIndex = self:ReadInt32();
end

return ReduceFortArmy;
