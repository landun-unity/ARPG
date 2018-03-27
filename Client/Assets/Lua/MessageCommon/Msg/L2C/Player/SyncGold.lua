--
-- 逻辑服务器 --> 客户端
-- 同步金币玉符
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncGold = class("SyncGold", GameMessage);

--
-- 构造函数
--
function SyncGold:ctor()
    SyncGold.super.ctor(self);
    --
    -- 金币
    --
    self.gold = 0;
    
    --
    -- 玉符
    --
    self.jade = 0;
end

--@Override
function SyncGold:_OnSerial() 
    self:WriteInt32(self.gold);
    self:WriteInt32(self.jade);
end

--@Override
function SyncGold:_OnDeserialize() 
    self.gold = self:ReadInt32();
    self.jade = self:ReadInt32();
end

return SyncGold;
