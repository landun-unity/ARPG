--
-- 客户端 --> 逻辑服务器
-- 打开盟成员
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOpenLeagueMembers = class("RequestOpenLeagueMembers", GameMessage);

--
-- 构造函数
--
function RequestOpenLeagueMembers:ctor()
    RequestOpenLeagueMembers.super.ctor(self);
end

--@Override
function RequestOpenLeagueMembers:_OnSerial() 
end

--@Override
function RequestOpenLeagueMembers:_OnDeserialize() 
end

return RequestOpenLeagueMembers;
