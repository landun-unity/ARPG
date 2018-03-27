--
-- 客户端 --> 逻辑服务器
-- 退出游戏
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ExitGame = class("ExitGame", GameMessage);

--
-- 构造函数
--
function ExitGame:ctor()
    ExitGame.super.ctor(self);
    --
    -- 要断开的适配器Id
    --
    self.disConnectAdapterId = 0;
end

--@Override
function ExitGame:_OnSerial() 
    self:WriteInt64(self.disConnectAdapterId);
end

--@Override
function ExitGame:_OnDeserialize() 
    self.disConnectAdapterId = self:ReadInt64();
end

return ExitGame;
