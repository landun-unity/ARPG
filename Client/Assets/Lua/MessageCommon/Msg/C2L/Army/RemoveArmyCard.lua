--[[请求玩家信息]]

local GameMessage = require("common/Net/GameMessage");
local RemoveArmyCard = class("ArmyGarrison", GameMessage);

function RemoveArmyCard:ctor()
    RemoveArmyCard.super.ctor(self);
    -- 建筑物的Id
    self.BuildingId = 0;
	-- BuildingSlotIndex
	self.BuildingSlotIndex = 0;
	-- 部队的槽位
	self.ArmySlotIndex = 0;
end

function RemoveArmyCard:_OnSerial()
    self:WriteInt64(self.BuildingId);
    self:WriteInt32(self.BuildingSlotIndex);
    self:WriteInt32(self.ArmySlotIndex);
end

function RemoveArmyCard:_OnDeserialize()
    self.BuildingId = self:ReadInt64();
    self.BuildingSlotIndex = self:ReadInt32();
    self.ArmySlotIndex = self:ReadInt32();
end

return RemoveArmyCard;
