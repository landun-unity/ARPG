--
-- 逻辑服务器 --> 客户端
-- 移除格子上的建筑物
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveBuilding = class("RemoveBuilding", GameMessage);

--
-- 构造函数
--
function RemoveBuilding:ctor()
    RemoveBuilding.super.ctor(self);
    --
    -- 标记id
    --
    self.id = 0;
    
    --
    -- 标记坐标
    --
    self.coord = 0;
    
    --
    -- 建筑物类型
    --
    self.buildingType = 0;
end

--@Override
function RemoveBuilding:_OnSerial() 
    self:WriteInt64(self.id);
    self:WriteInt32(self.coord);
    self:WriteInt32(self.buildingType);
end

--@Override
function RemoveBuilding:_OnDeserialize() 
    self.id = self:ReadInt64();
    self.coord = self:ReadInt32();
    self.buildingType = self:ReadInt32();
end

return RemoveBuilding;
