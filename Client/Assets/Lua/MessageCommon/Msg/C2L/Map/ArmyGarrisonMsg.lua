--[[驻守消息]]

local GameMessage = require("common/Net/GameMessage");
local ArmyGarrisonMsg = class("ArmyGarrison", GameMessage);

function ArmyGarrisonMsg:ctor()
    -- 玩家ID
    self.playerId = 0;
	 -- 建筑物id
    self.buildingId = 0;

    -- 部队编号
    self.index = 0;

    -- 出征目标格子索引
    self.tiledIndex = 0;

    ArmyGarrisonMsg.super.ctor(self);
end

function ArmyGarrisonMsg:_OnSerial()
    self:WriteInt64(self.playerId);
	self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end

function ArmyGarrisonMsg:_OnDeserialize()
    self.playerId = self:ReadInt64();
	self.buildingId = self:ReadInt64();
   self.index = self:ReadInt32();
   self.tiledIndex = self:ReadInt32();
end

return ArmyGarrisonMsg;