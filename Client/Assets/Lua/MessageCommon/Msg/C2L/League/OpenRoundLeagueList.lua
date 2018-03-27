--
-- 客户端 --> 逻辑服务器
-- 打开周围同盟列表
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenRoundLeagueList = class("OpenRoundLeagueList", GameMessage);

--
-- 构造函数
--
function OpenRoundLeagueList:ctor()
    OpenRoundLeagueList.super.ctor(self);
end

--@Override
function OpenRoundLeagueList:_OnSerial() 
end

--@Override
function OpenRoundLeagueList:_OnDeserialize() 
end

return OpenRoundLeagueList;
