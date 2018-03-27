--
-- 逻辑服务器 --> 客户端
-- 添加一条基于战平部队的敌方提示
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AddEnemyTipBattle = class("AddEnemyTipBattle", GameMessage);

--
-- 构造函数
--
function AddEnemyTipBattle:ctor()
    AddEnemyTipBattle.super.ctor(self);
    --
    -- 敌方玩家ID
    --
    self.playerId = 0;
    
    --
    -- 所在格子
    --
    self.curTiled = 0;
    
    --
    -- 敌方玩家名称
    --
    self.playerName = "";
    
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
function AddEnemyTipBattle:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt32(self.curTiled);
    self:WriteString(self.playerName);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.armySlotIndex);
end

--@Override
function AddEnemyTipBattle:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.curTiled = self:ReadInt32();
    self.playerName = self:ReadString();
    self.buildingId = self:ReadInt64();
    self.armySlotIndex = self:ReadInt32();
end

return AddEnemyTipBattle;
