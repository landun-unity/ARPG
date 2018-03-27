--
-- 客户端 --> 逻辑服务器
-- 请求玩家同盟信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestLeagueInfo = class("RequestLeagueInfo", GameMessage);

--
-- 构造函数
--
function RequestLeagueInfo:ctor()
    RequestLeagueInfo.super.ctor(self);
end

--@Override
function RequestLeagueInfo:_OnSerial() 
end

--@Override
function RequestLeagueInfo:_OnDeserialize() 
end

return RequestLeagueInfo;
