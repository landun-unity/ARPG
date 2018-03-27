--
-- 客户端 --> 逻辑服务器
-- 打开我的盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOpenLeague = class("RequestOpenLeague", GameMessage);

--
-- 构造函数
--
function RequestOpenLeague:ctor()
    RequestOpenLeague.super.ctor(self);
end

--@Override
function RequestOpenLeague:_OnSerial() 
end

--@Override
function RequestOpenLeague:_OnDeserialize() 
end

return RequestOpenLeague;
