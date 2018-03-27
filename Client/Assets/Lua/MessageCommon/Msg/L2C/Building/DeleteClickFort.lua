--
-- 逻辑服务器 --> 客户端
-- 删除要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteClickFort = class("DeleteClickFort", GameMessage);

--
-- 构造函数
--
function DeleteClickFort:ctor()
    DeleteClickFort.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function DeleteClickFort:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function DeleteClickFort:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return DeleteClickFort;
