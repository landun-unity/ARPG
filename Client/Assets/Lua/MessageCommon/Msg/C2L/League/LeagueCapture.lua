--
-- 客户端 --> 逻辑服务器
-- 踢人
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LeagueCapture = class("LeagueCapture", GameMessage);

--
-- 构造函数
--
function LeagueCapture:ctor()
    LeagueCapture.super.ctor(self);
end

--@Override
function LeagueCapture:_OnSerial() 
end

--@Override
function LeagueCapture:_OnDeserialize() 
end

return LeagueCapture;
