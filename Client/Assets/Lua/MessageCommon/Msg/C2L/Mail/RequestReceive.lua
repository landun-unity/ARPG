--
-- 客户端 --> 逻辑服务器
-- 领取奖励
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestReceive = class("RequestReceive", GameMessage);

--
-- 构造函数
--
function RequestReceive:ctor()
    RequestReceive.super.ctor(self);
    --
    -- 邮件ID
    --
    self.mailId = 0;
end

--@Override
function RequestReceive:_OnSerial() 
    self:WriteInt64(self.mailId);
end

--@Override
function RequestReceive:_OnDeserialize() 
    self.mailId = self:ReadInt64();
end

return RequestReceive;
