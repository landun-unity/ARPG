--
-- 客户端 --> 逻辑服务器
-- 放弃土地
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GiveUpOwnerLand = class("GiveUpOwnerLand", GameMessage);

--
-- 构造函数
--
function GiveUpOwnerLand:ctor()
    GiveUpOwnerLand.super.ctor(self);
    --
    -- 土地索引
    --
    self.tiledIndex = 0;

    self.buildingId = 0;
end

--@Override
function GiveUpOwnerLand:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
    self:WriteInt32(self.buildingId);
end

--@Override
function GiveUpOwnerLand:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
    self.buildingId = self:ReadInt32();
end

return GiveUpOwnerLand;
