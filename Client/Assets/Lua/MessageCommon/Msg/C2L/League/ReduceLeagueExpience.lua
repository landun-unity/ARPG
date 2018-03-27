--
-- 客户端 --> 逻辑服务器
-- 减少同盟经验
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReduceLeagueExpience = class("ReduceLeagueExpience", GameMessage);

--
-- 构造函数
--
function ReduceLeagueExpience:ctor()
    ReduceLeagueExpience.super.ctor(self);
    --
    -- 玩家id
    --
    self.playerId = 0;
    
    --
    -- 经验
    --
    self.exp = 0;
end

--@Override
function ReduceLeagueExpience:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt32(self.exp);
end

--@Override
function ReduceLeagueExpience:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.exp = self:ReadInt32();
end

return ReduceLeagueExpience;
