--[[请求玩家信息]]

local GameMessage = require("common/Net/GameMessage");
local ExchangeArmyCard = class("ExchangeArmyCard", GameMessage);

function ExchangeArmyCard:ctor()
    ExchangeArmyCard.super.ctor(self);
    -- 建筑物的Id
    self.BuildingId = 0;
	-- BuildingSlotIndex
	self.LeftBuildingSlotIndex = 0;
	-- 部队的槽位
	self.LeftArmySlotIndex = 0;
    -- BuildingSlotIndex
	self.RightBuildingSlotIndex = 0;
	-- 部队的槽位
	self.RightArmySlotIndex = 0;
end

function ExchangeArmyCard:_OnSerial()
    self:WriteInt64(self.BuildingId);
    self:WriteInt32(self.LeftBuildingSlotIndex);
    self:WriteInt32(self.LeftArmySlotIndex);
    self:WriteInt32(self.RightBuildingSlotIndex);
    self:WriteInt32(self.RightArmySlotIndex);
end

function ExchangeArmyCard:_OnDeserialize()
    self.BuildingId = self:ReadInt64();
    self.LeftBuildingSlotIndex = self:ReadInt32();
    self.LeftArmySlotIndex = self:ReadInt32();
    self.RightBuildingSlotIndex = self:ReadInt32();
    self.RightArmySlotIndex = self:ReadInt32();
end

return ExchangeArmyCard;
