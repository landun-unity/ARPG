--
-- 聊天服务器 --> 客户端
-- 注册聊天成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RegisterChatSuccess = class("RegisterChatSuccess", GameMessage);

--
-- 构造函数
--
function RegisterChatSuccess:ctor()
    RegisterChatSuccess.super.ctor(self);
end

--@Override
function RegisterChatSuccess:_OnSerial() 
end

--@Override
function RegisterChatSuccess:_OnDeserialize() 
end

return RegisterChatSuccess;
