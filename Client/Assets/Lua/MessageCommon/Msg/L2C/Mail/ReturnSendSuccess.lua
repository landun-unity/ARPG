--
-- 逻辑服务器 --> 客户端
-- 发送邮件是否成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnSendSuccess = class("ReturnSendSuccess", GameMessage);

--
-- 构造函数
--
function ReturnSendSuccess:ctor()
    ReturnSendSuccess.super.ctor(self);
    --
    -- 是否成功
    --
    self.isSuccess = 0;
end

--@Override
function ReturnSendSuccess:_OnSerial() 
    self:WriteInt32(self.isSuccess);
end

--@Override
function ReturnSendSuccess:_OnDeserialize() 
    self.isSuccess = self:ReadInt32();
end

return ReturnSendSuccess;
