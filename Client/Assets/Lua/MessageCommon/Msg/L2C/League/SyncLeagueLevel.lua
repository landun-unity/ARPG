--
-- 逻辑服务器 --> 客户端
-- 同盟等级
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncLeagueLevel = class("SyncLeagueLevel", GameMessage);

--
-- 构造函数
--
function SyncLeagueLevel:ctor()
    SyncLeagueLevel.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
    
    --
    -- 同盟等级
    --
    self.leagueLevel = 0;
end

--@Override
function SyncLeagueLevel:_OnSerial() 
    self:WriteInt64(self.leagueId);
    self:WriteInt32(self.leagueLevel);
end

--@Override
function SyncLeagueLevel:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
    self.leagueLevel = self:ReadInt32();
end

return SyncLeagueLevel;
