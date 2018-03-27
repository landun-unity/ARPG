--
-- 客户端 --> 逻辑服务器
-- 打开指定盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestOpenAppointLeague = class("RequestOpenAppointLeague", GameMessage);

--
-- 构造函数
--
function RequestOpenAppointLeague:ctor()
    RequestOpenAppointLeague.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
end

--@Override
function RequestOpenAppointLeague:_OnSerial() 
    self:WriteInt64(self.leagueId);
end

--@Override
function RequestOpenAppointLeague:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
end

return RequestOpenAppointLeague;
