--
-- 客户端 --> 逻辑服务器
-- 请求天下大势信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestWordTendencyInfo = class("RequestWordTendencyInfo", GameMessage);

--
-- 构造函数
--
function RequestWordTendencyInfo:ctor()
    RequestWordTendencyInfo.super.ctor(self);
end

--@Override
function RequestWordTendencyInfo:_OnSerial() 
end

--@Override
function RequestWordTendencyInfo:_OnDeserialize() 
end

return RequestWordTendencyInfo;
