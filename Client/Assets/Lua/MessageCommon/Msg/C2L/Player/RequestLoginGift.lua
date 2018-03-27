--
-- 客户端 --> 逻辑服务器
-- 请求每日奖励
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestLoginGift = class("RequestLoginGift", GameMessage);

--
-- 构造函数
--
function RequestLoginGift:ctor()
    RequestLoginGift.super.ctor(self);
end

--@Override
function RequestLoginGift:_OnSerial() 
end

--@Override
function RequestLoginGift:_OnDeserialize() 
end

return RequestLoginGift;
