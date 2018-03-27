--
-- 客户端 --> 逻辑服务器
-- 打开同盟标记请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenLeagueMarkRequest = class("OpenLeagueMarkRequest", GameMessage);

--
-- 构造函数
--
function OpenLeagueMarkRequest:ctor()
    OpenLeagueMarkRequest.super.ctor(self);
end

--@Override
function OpenLeagueMarkRequest:_OnSerial() 
end

--@Override
function OpenLeagueMarkRequest:_OnDeserialize() 
end

return OpenLeagueMarkRequest;
