--
-- 客户端 --> 逻辑服务器
-- 申请加入同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ApplyJoin = class("ApplyJoin", GameMessage);

--
-- 构造函数
--
function ApplyJoin:ctor()
    ApplyJoin.super.ctor(self);
    --
    -- 被申请同盟
    --
    self.leagueId = 0;
end

--@Override
function ApplyJoin:_OnSerial() 
    self:WriteInt64(self.leagueId);
end

--@Override
function ApplyJoin:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
end

return ApplyJoin;
