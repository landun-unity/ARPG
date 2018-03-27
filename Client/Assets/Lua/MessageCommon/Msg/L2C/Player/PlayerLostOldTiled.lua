--
-- 逻辑服务器 --> 客户端
-- 玩家新获得一块地
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local PlayerLostOldTiled = class("PlayerLostOldTiled", GameMessage);

--
-- 构造函数
--
function PlayerLostOldTiled:ctor()
    PlayerLostOldTiled.super.ctor(self);
    --
    -- 格子Id
    --
    self.tiledId = 0;
    
    --
    -- 格子当前耐久
    --
    self.tiledCurDurable = 0;
    
    --
    -- 格子最大耐久
    --
    self.tiledMaxDurable = 0;
end

--@Override
function PlayerLostOldTiled:_OnSerial() 
    self:WriteInt32(self.tiledId);
    self:WriteInt32(self.tiledCurDurable);
    self:WriteInt32(self.tiledMaxDurable);
end

--@Override
function PlayerLostOldTiled:_OnDeserialize() 
    self.tiledId = self:ReadInt32();
    self.tiledCurDurable = self:ReadInt32();
    self.tiledMaxDurable = self:ReadInt32();
end

return PlayerLostOldTiled;
