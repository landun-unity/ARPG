--
-- 客户端 --> 逻辑服务器
-- 请求跳过新手引导
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestJumpGuide = class("RequestJumpGuide", GameMessage);

--
-- 构造函数
--
function RequestJumpGuide:ctor()
    RequestJumpGuide.super.ctor(self);
end

--@Override
function RequestJumpGuide:_OnSerial() 
end

--@Override
function RequestJumpGuide:_OnDeserialize() 
end

return RequestJumpGuide;
