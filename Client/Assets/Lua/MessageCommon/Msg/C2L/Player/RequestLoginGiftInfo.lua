--
-- 客户端 --> 逻辑服务器
-- 请求每日奖励信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestLoginGiftInfo = class("RequestLoginGiftInfo", GameMessage);

--
-- 构造函数
--
function RequestLoginGiftInfo:ctor()
    RequestLoginGiftInfo.super.ctor(self);
end

--@Override
function RequestLoginGiftInfo:_OnSerial() 
end

--@Override
function RequestLoginGiftInfo:_OnDeserialize() 
end

return RequestLoginGiftInfo;
