--
-- 逻辑服务器 --> 客户端
-- 同步玩家势力值
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncPlayerInfluence = class("SyncPlayerInfluence", GameMessage);

--
-- 构造函数
--
function SyncPlayerInfluence:ctor()
    SyncPlayerInfluence.super.ctor(self);
    --
    -- 势力值
    --
    self.influence = 0;
end

--@Override
function SyncPlayerInfluence:_OnSerial() 
    self:WriteInt32(self.influence);
end

--@Override
function SyncPlayerInfluence:_OnDeserialize() 
    self.influence = self:ReadInt32();
end

return SyncPlayerInfluence;
