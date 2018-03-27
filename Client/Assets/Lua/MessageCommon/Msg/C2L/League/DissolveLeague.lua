--
-- 客户端 --> 逻辑服务器
-- 解散同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DissolveLeague = class("DissolveLeague", GameMessage);

--
-- 构造函数
--
function DissolveLeague:ctor()
    DissolveLeague.super.ctor(self);
end

--@Override
function DissolveLeague:_OnSerial() 
end

--@Override
function DissolveLeague:_OnDeserialize() 
end

return DissolveLeague;
