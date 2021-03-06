﻿--
-- 逻辑服务器 --> 客户端
-- 同步一张卡牌的属性信息
-- @author czx
--
local CardModel = require("MessageCommon/Msg/L2C/Card/CardModel");

local GameMessage = require("common/Net/GameMessage");
local OneCardProperty = class("OneCardProperty", GameMessage);

--
-- 构造函数
--
function OneCardProperty:ctor()
    OneCardProperty.super.ctor(self);
    --
    -- 卡牌信息
    --
    self.model = CardModel.new();
end

--@Override
function OneCardProperty:_OnSerial() 
    self:WriteInt64(self.model.id);
    self:WriteInt32(self.model.tableID);
    self:WriteInt32(self.model.exp);
    self:WriteInt32(self.model.advancedTime);
    self:WriteInt32(self.model.power);
    self:WriteInt32(self.model.level);
    self:WriteInt32(self.model.troop);
    self:WriteInt32(self.model.point);
    self:WriteInt32(self.model.attacktPoint);
    self:WriteInt32(self.model.defensePoint);
    self:WriteInt32(self.model.strategyPoint);
    self:WriteInt32(self.model.speedPoint);
    self:WriteBoolean(self.model.isProtect);
    self:WriteBoolean(self.model.isAwaken);
    self:WriteInt32(self.model.skillIDOne);
    self:WriteInt32(self.model.skillOneLevel);
    self:WriteInt32(self.model.skillTwoID);
    self:WriteInt32(self.model.skillTwoLevel);
    self:WriteInt32(self.model.skillThreeID);
    self:WriteInt32(self.model.skillThreeLevel);
    self:WriteInt64(self.model.lastResetPointTime);
    self:WriteInt64(self.model.lastResetCardTime);
    self:WriteInt64(self.model.badlyHurtTime);
end

--@Override
function OneCardProperty:_OnDeserialize() 
    self.model.id = self:ReadInt64();
    self.model.tableID = self:ReadInt32();
    self.model.exp = self:ReadInt32();
    self.model.advancedTime = self:ReadInt32();
    self.model.power = self:ReadInt32();
    self.model.level = self:ReadInt32();
    self.model.troop = self:ReadInt32();
    self.model.point = self:ReadInt32();
    self.model.attacktPoint = self:ReadInt32();
    self.model.defensePoint = self:ReadInt32();
    self.model.strategyPoint = self:ReadInt32();
    self.model.speedPoint = self:ReadInt32();
    self.model.isProtect = self:ReadBoolean();
    self.model.isAwaken = self:ReadBoolean();
    self.model.skillIDOne = self:ReadInt32();
    self.model.skillOneLevel = self:ReadInt32();
    self.model.skillTwoID = self:ReadInt32();
    self.model.skillTwoLevel = self:ReadInt32();
    self.model.skillThreeID = self:ReadInt32();
    self.model.skillThreeLevel = self:ReadInt32();
    self.model.lastResetPointTime = self:ReadInt64();
    self.model.lastResetCardTime = self:ReadInt64();
    self.model.badlyHurtTime = self:ReadInt64();
end

return OneCardProperty;
