--
-- 客户端 --> 逻辑服务器
-- 玩家打开被邀请盟列表
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenBeInventLeague = class("OpenBeInventLeague", GameMessage);

--
-- 构造函数
--
function OpenBeInventLeague:ctor()
    OpenBeInventLeague.super.ctor(self);
end

--@Override
function OpenBeInventLeague:_OnSerial() 
end

--@Override
function OpenBeInventLeague:_OnDeserialize() 
end

return OpenBeInventLeague;
