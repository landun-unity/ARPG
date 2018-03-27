--
-- 客户端 --> 逻辑服务器
-- 盟主/副盟主打开周围玩家列表
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenRoundPlayer = class("OpenRoundPlayer", GameMessage);

--
-- 构造函数
--
function OpenRoundPlayer:ctor()
    OpenRoundPlayer.super.ctor(self);
end

--@Override
function OpenRoundPlayer:_OnSerial() 
end

--@Override
function OpenRoundPlayer:_OnDeserialize() 
end

return OpenRoundPlayer;
