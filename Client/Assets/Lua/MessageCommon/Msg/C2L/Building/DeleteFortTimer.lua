--
-- 客户端 --> 逻辑服务器
-- 取消放弃要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteFortTimer = class("DeleteFortTimer", GameMessage);

--
-- 构造函数
--
function DeleteFortTimer:ctor()
    DeleteFortTimer.super.ctor(self);
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function DeleteFortTimer:_OnSerial() 
    self:WriteInt32(self.tiledIndex);
end

--@Override
function DeleteFortTimer:_OnDeserialize() 
    self.tiledIndex = self:ReadInt32();
end

return DeleteFortTimer;
