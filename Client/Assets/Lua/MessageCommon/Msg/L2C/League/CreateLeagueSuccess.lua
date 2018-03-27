--
-- 逻辑服务器 --> 客户端
-- 创建同盟成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreateLeagueSuccess = class("CreateLeagueSuccess", GameMessage);

--
-- 构造函数
--
function CreateLeagueSuccess:ctor()
    CreateLeagueSuccess.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
end

--@Override
function CreateLeagueSuccess:_OnSerial() 
    self:WriteInt64(self.leagueId);
end

--@Override
function CreateLeagueSuccess:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
end

return CreateLeagueSuccess;
