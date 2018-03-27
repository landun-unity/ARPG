--
-- 客户端 --> 逻辑服务器
-- 请求打开排行榜
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenLeagueRanklistRequest = class("OpenLeagueRanklistRequest", GameMessage);

--
-- 构造函数
--
function OpenLeagueRanklistRequest:ctor()
    OpenLeagueRanklistRequest.super.ctor(self);
end

--@Override
function OpenLeagueRanklistRequest:_OnSerial() 
end

--@Override
function OpenLeagueRanklistRequest:_OnDeserialize() 
end

return OpenLeagueRanklistRequest;
