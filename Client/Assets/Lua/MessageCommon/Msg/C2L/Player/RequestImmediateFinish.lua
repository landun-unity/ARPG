--
-- 客户端 --> 逻辑服务器
-- 请求立即完成税收
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestImmediateFinish = class("RequestImmediateFinish", GameMessage);

--
-- 构造函数
--
function RequestImmediateFinish:ctor()
    RequestImmediateFinish.super.ctor(self);
end

--@Override
function RequestImmediateFinish:_OnSerial() 
end

--@Override
function RequestImmediateFinish:_OnDeserialize() 
end

return RequestImmediateFinish;
