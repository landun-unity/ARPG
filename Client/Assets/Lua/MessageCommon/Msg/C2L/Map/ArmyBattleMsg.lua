
--[[
  出征消息
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyBattleMsg = class("ArmyBattleMsg", GameMessage);

function ArmyBattleMsg:ctor()

    self.playerId = 0;
    -- 建筑物id
    self.buildingId = 0;

    -- 部队编号
    self.index = 0;

    -- 出征目标格子索引
    self.tiledIndex = 0;

    ArmyBattleMsg.super.ctor(self);
end

-- @override
function ArmyBattleMsg:_OnSerial()
    print("ArmyBattleMsg--------OnSerial........")
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end


-- @override
function ArmyBattleMsg:_OnDeserialize()
   self.playerId = self:ReadInt64();
   self.buildingId = self:ReadInt64();
   self.index = self:ReadInt32();
   self.tiledIndex = self:ReadInt32();

end

return ArmyBattleMsg;