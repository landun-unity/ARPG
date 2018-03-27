--
-- 客户端 --> 逻辑服务器
-- 打开同盟外交请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenDiplomacyLeagueRequest = class("OpenDiplomacyLeagueRequest", GameMessage);

--
-- 构造函数
--
function OpenDiplomacyLeagueRequest:ctor()
    OpenDiplomacyLeagueRequest.super.ctor(self);
end

--@Override
function OpenDiplomacyLeagueRequest:_OnSerial() 
end

--@Override
function OpenDiplomacyLeagueRequest:_OnDeserialize() 
end

return OpenDiplomacyLeagueRequest;
