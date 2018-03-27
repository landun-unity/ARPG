--
-- 逻辑服务器 --> 客户端
-- 同盟攻城
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LeagueChangeWildBuilding = class("LeagueChangeWildBuilding", GameMessage);

--
-- 构造函数
--
function LeagueChangeWildBuilding:ctor()
    LeagueChangeWildBuilding.super.ctor(self);
    --
    -- 同盟id
    --
    self.leagueId = 0;
    
    --
    -- 目标城id
    --
    self.buildingId = 0;
    
    --
    -- 得到或失去
    --
    self.gainOrLost = false;
end

--@Override
function LeagueChangeWildBuilding:_OnSerial() 
    self:WriteInt64(self.leagueId);
    self:WriteInt64(self.buildingId);
    self:WriteBoolean(self.gainOrLost);
end

--@Override
function LeagueChangeWildBuilding:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
    self.buildingId = self:ReadInt64();
    self.gainOrLost = self:ReadBoolean();
end

return LeagueChangeWildBuilding;
