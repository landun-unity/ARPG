--
-- 客户端 --> 逻辑服务器
-- 请求玩家政令
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestDecree = class("RequestDecree", GameMessage);

--
-- 构造函数
--
function RequestDecree:ctor()
    RequestDecree.super.ctor(self);
    --
    -- 政令
    --
    self.decree = 0;
end

--@Override
function RequestDecree:_OnSerial() 
    self:WriteInt32(self.decree);
end

--@Override
function RequestDecree:_OnDeserialize() 
    self.decree = self:ReadInt32();
end

return RequestDecree;
