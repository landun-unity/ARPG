--
-- 客户端 --> 逻辑服务器
-- 请求税收说明
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RevenueIntroductions = class("RevenueIntroductions", GameMessage);

--
-- 构造函数
--
function RevenueIntroductions:ctor()
    RevenueIntroductions.super.ctor(self);
end

--@Override
function RevenueIntroductions:_OnSerial() 
end

--@Override
function RevenueIntroductions:_OnDeserialize() 
end

return RevenueIntroductions;
