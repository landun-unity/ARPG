--
-- 账号服务器 --> 客户端
-- 注册回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local EhooRegisterRespond = class("EhooRegisterRespond", GameMessage);

--
-- 构造函数
--
function EhooRegisterRespond:ctor()
    EhooRegisterRespond.super.ctor(self);
end

--@Override
function EhooRegisterRespond:_OnSerial() 
end

--@Override
function EhooRegisterRespond:_OnDeserialize() 
end

return EhooRegisterRespond;
