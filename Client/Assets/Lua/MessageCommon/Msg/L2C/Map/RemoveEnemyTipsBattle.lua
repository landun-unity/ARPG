--
-- 逻辑服务器 --> 客户端
-- 移除一条基于战平部队的敌方提示
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveEnemyTipsBattle = class("RemoveEnemyTipsBattle", GameMessage);

--
-- 构造函数
--
function RemoveEnemyTipsBattle:ctor()
    RemoveEnemyTipsBattle.super.ctor(self);
    --
    -- 敌方玩家ID
    --
    self.playerId = 0;
    
    --
    -- 敌方部队的建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 敌方部队的槽位索引
    --
    self.armySlotIndex = 0;
end

--@Override
function RemoveEnemyTipsBattle:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.armySlotIndex);
end

--@Override
function RemoveEnemyTipsBattle:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.buildingId = self:ReadInt64();
    self.armySlotIndex = self:ReadInt32();
end

return RemoveEnemyTipsBattle;
