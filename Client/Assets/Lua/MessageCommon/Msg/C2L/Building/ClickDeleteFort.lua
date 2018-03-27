--
-- 客户端 --> 逻辑服务器
-- 取消拆除要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ClickDeleteFort = class("ClickDeleteFort", GameMessage);

--
-- 构造函数
--
function ClickDeleteFort:ctor()
    ClickDeleteFort.super.ctor(self);
    --
    -- 格子索引
    --
    self.index = 0;
end

--@Override
function ClickDeleteFort:_OnSerial() 
    self:WriteInt32(self.index);
end

--@Override
function ClickDeleteFort:_OnDeserialize() 
    self.index = self:ReadInt32();
end

return ClickDeleteFort;
