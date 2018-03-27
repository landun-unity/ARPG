--
-- 客户端 --> 逻辑服务器
-- 取消放弃土地
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CancelGiveUpOwnerLand = class("CancelGiveUpOwnerLand", GameMessage);

--
-- 构造函数
--
function CancelGiveUpOwnerLand:ctor()
    CancelGiveUpOwnerLand.super.ctor(self);
    --
    -- 土地索引
    --
    self.tiledIndex = 0;
end

--@Override
function CancelGiveUpOwnerLand:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function CancelGiveUpOwnerLand:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return CancelGiveUpOwnerLand;
