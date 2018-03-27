--
-- 客户端 --> 逻辑服务器
-- 退出同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local QuitLeague = class("QuitLeague", GameMessage);

--
-- 构造函数
--
function QuitLeague:ctor()
    QuitLeague.super.ctor(self);
end

--@Override
function QuitLeague:_OnSerial() 
end

--@Override
function QuitLeague:_OnDeserialize() 
end

return QuitLeague;
