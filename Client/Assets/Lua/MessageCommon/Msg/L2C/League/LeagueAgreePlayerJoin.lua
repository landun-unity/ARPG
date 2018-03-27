--
-- 逻辑服务器 --> 客户端
-- 同盟同意玩家加入
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LeagueAgreePlayerJoin = class("LeagueAgreePlayerJoin", GameMessage);

--
-- 构造函数
--
function LeagueAgreePlayerJoin:ctor()
    LeagueAgreePlayerJoin.super.ctor(self);
    --
    -- 同盟ID
    --
    self.leagueId = 0;
end

--@Override
function LeagueAgreePlayerJoin:_OnSerial() 
    self:WriteInt64(self.leagueId);
end

--@Override
function LeagueAgreePlayerJoin:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
end

return LeagueAgreePlayerJoin;
