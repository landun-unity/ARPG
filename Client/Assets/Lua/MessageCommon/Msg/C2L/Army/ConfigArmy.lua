--[[请求玩家信息]]

local GameMessage = require("common/Net/GameMessage");
local ConfigArmy = class("ArmyGarrison", GameMessage);

function ConfigArmy:ctor()
    ConfigArmy.super.ctor(self);
    -- 建筑物的Id
    self.BuildingId = 0;
	-- BuildingSlotIndex
	self.BuildingSlotIndex = 0;
	-- 部队的槽位
	self.ArmySlotIndex = 0;
	-- 卡牌Id
	self.CardId = 0;
end

function ConfigArmy:_OnSerial()
    self:WriteInt64(self.BuildingId);
    self:WriteInt32(self.BuildingSlotIndex);
    self:WriteInt32(self.ArmySlotIndex);
    self:WriteInt64(self.CardId);
end

function ConfigArmy:_OnDeserialize()
    self.BuildingId = self:ReadInt64();
    self.BuildingSlotIndex = self:ReadInt32();
    self.ArmySlotIndex = self:ReadInt32();
    self.CardId = self:ReadInt64();
end

return ConfigArmy;
