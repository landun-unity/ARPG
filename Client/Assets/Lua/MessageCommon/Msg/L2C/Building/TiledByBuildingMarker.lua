--
-- 逻辑服务器 --> 客户端
-- 标记信息改变
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local TiledByBuildingMarker = class("TiledByBuildingMarker", GameMessage);

--
-- 构造函数
--
function TiledByBuildingMarker:ctor()
    TiledByBuildingMarker.super.ctor(self);
    --
    -- 建筑物名字
    --
    self.name = "";
    
    --
    -- 建筑物索引
    --
    self.index = 0;
end

--@Override
function TiledByBuildingMarker:_OnSerial() 
    self:WriteString(self.name);
    self:WriteInt32(self.index);
end

--@Override
function TiledByBuildingMarker:_OnDeserialize() 
    self.name = self:ReadString();
    self.index = self:ReadInt32();
end

return TiledByBuildingMarker;
