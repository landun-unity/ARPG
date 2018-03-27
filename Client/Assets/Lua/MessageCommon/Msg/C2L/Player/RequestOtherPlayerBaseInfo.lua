--
-- 客户端 --> 逻辑服务器
-- 请求其它玩家的个人信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOtherPlayerBaseInfo = class("RequestOtherPlayerBaseInfo", GameMessage);

--
-- 构造函数
--
function RequestOtherPlayerBaseInfo:ctor()
    RequestOtherPlayerBaseInfo.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
end

--@Override
function RequestOtherPlayerBaseInfo:_OnSerial() 
    self:WriteInt64(self.playerId);
end

--@Override
function RequestOtherPlayerBaseInfo:_OnDeserialize() 
    self.playerId = self:ReadInt64();
end

return RequestOtherPlayerBaseInfo;
