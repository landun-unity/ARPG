--
-- 客户端 --> 逻辑服务器
-- 部队出征
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyBattleMsg = class("ArmyBattleMsg", GameMessage);

--
-- 构造函数
--
function ArmyBattleMsg:ctor()
    ArmyBattleMsg.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 部队索引
    --
    self.index = 0;
    
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function ArmyBattleMsg:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ArmyBattleMsg:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
end

return ArmyBattleMsg;
