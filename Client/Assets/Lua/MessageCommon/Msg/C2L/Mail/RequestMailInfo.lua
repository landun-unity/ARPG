--
-- 客户端 --> 逻辑服务器
-- 请求邮件信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestMailInfo = class("RequestMailInfo", GameMessage);

--
-- 构造函数
--
function RequestMailInfo:ctor()
    RequestMailInfo.super.ctor(self);
end

--@Override
function RequestMailInfo:_OnSerial() 
end

--@Override
function RequestMailInfo:_OnDeserialize() 
end

return RequestMailInfo;
