--
-- 逻辑服务器 --> 客户端
-- 删除要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReplyDeleteFortTimer = class("ReplyDeleteFortTimer", GameMessage);

--
-- 构造函数
--
function ReplyDeleteFortTimer:ctor()
    ReplyDeleteFortTimer.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function ReplyDeleteFortTimer:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ReplyDeleteFortTimer:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return ReplyDeleteFortTimer;
