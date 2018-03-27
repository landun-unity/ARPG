--
-- 客户端 --> 逻辑服务器
-- 请求购买政令
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequsetBuyDercee = class("RequsetBuyDercee", GameMessage);

--
-- 构造函数
--
function RequsetBuyDercee:ctor()
    RequsetBuyDercee.super.ctor(self);
end

--@Override
function RequsetBuyDercee:_OnSerial() 
end

--@Override
function RequsetBuyDercee:_OnDeserialize() 
end

return RequsetBuyDercee;
