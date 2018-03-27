--
-- 客户端 --> 逻辑服务器
-- 玩家同意加入同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local PlayerAgreeJoinInvent = class("PlayerAgreeJoinInvent", GameMessage);

--
-- 构造函数
--
function PlayerAgreeJoinInvent:ctor()
    PlayerAgreeJoinInvent.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
end

--@Override
function PlayerAgreeJoinInvent:_OnSerial() 
    self:WriteInt64(self.leagueId);
end

--@Override
function PlayerAgreeJoinInvent:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
end

return PlayerAgreeJoinInvent;
