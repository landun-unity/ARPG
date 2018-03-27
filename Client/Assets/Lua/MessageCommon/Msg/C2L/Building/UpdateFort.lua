--
-- 客户端 --> 逻辑服务器
-- 取消升级要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpdateFort = class("UpdateFort", GameMessage);

--
-- 构造函数
--
function UpdateFort:ctor()
    UpdateFort.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function UpdateFort:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function UpdateFort:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return UpdateFort;
