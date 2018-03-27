--
-- 客户端 --> 逻辑服务器
-- 请求玩家货币信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestCurrencyInfo = class("RequestCurrencyInfo", GameMessage);

--
-- 构造函数
--
function RequestCurrencyInfo:ctor()
    RequestCurrencyInfo.super.ctor(self);
end

--@Override
function RequestCurrencyInfo:_OnSerial() 
end

--@Override
function RequestCurrencyInfo:_OnDeserialize() 
end

return RequestCurrencyInfo;
