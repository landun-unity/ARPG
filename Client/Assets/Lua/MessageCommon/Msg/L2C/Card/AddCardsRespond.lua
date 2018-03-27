--
-- 逻辑服务器 --> 客户端
-- 新增加多张卡牌
-- @author czx
--
local List = require("common/List");

local CardModel = require("MessageCommon/Msg/L2C/Card/CardModel");

local GameMessage = require("common/Net/GameMessage");
local AddCardsRespond = class("AddCardsRespond", GameMessage);

--
-- 构造函数
--
function AddCardsRespond:ctor()
    AddCardsRespond.super.ctor(self);
    --
    -- 卡牌列表
    --
    self.cards = List.new();
end

--@Override
function AddCardsRespond:_OnSerial() 
    
    local cardsCount = self.cards:Count();
    self:WriteInt32(cardsCount);
    for cardsIndex = 1, cardsCount, 1 do 
        local cardsValue = self.cards:Get(cardsIndex);
        
        self:WriteInt64(cardsValue.id);
        self:WriteInt32(cardsValue.tableID);
        self:WriteInt32(cardsValue.exp);
        self:WriteInt32(cardsValue.advancedTime);
        self:WriteInt32(cardsValue.power);
        self:WriteInt32(cardsValue.level);
        self:WriteInt32(cardsValue.troop);
        self:WriteInt32(cardsValue.point);
        self:WriteInt32(cardsValue.attacktPoint);
        self:WriteInt32(cardsValue.defensePoint);
        self:WriteInt32(cardsValue.strategyPoint);
        self:WriteInt32(cardsValue.speedPoint);
        self:WriteBoolean(cardsValue.isProtect);
        self:WriteBoolean(cardsValue.isAwaken);
        self:WriteInt32(cardsValue.skillIDOne);
        self:WriteInt32(cardsValue.skillOneLevel);
        self:WriteInt32(cardsValue.skillTwoID);
        self:WriteInt32(cardsValue.skillTwoLevel);
        self:WriteInt32(cardsValue.skillThreeID);
        self:WriteInt32(cardsValue.skillThreeLevel);
        self:WriteInt64(cardsValue.lastResetPointTime);
        self:WriteInt64(cardsValue.lastResetCardTime);
        self:WriteInt64(cardsValue.badlyHurtTime);
        self:WriteInt64(cardsValue.tiredRecoverTime);
    end
end

--@Override
function AddCardsRespond:_OnDeserialize() 
    
    local cardsCount = self:ReadInt32();
    for i = 1, cardsCount, 1 do 
        local cardsValue = CardModel.new();
        cardsValue.id = self:ReadInt64();
        cardsValue.tableID = self:ReadInt32();
        cardsValue.exp = self:ReadInt32();
        cardsValue.advancedTime = self:ReadInt32();
        cardsValue.power = self:ReadInt32();
        cardsValue.level = self:ReadInt32();
        cardsValue.troop = self:ReadInt32();
        cardsValue.point = self:ReadInt32();
        cardsValue.attacktPoint = self:ReadInt32();
        cardsValue.defensePoint = self:ReadInt32();
        cardsValue.strategyPoint = self:ReadInt32();
        cardsValue.speedPoint = self:ReadInt32();
        cardsValue.isProtect = self:ReadBoolean();
        cardsValue.isAwaken = self:ReadBoolean();
        cardsValue.skillIDOne = self:ReadInt32();
        cardsValue.skillOneLevel = self:ReadInt32();
        cardsValue.skillTwoID = self:ReadInt32();
        cardsValue.skillTwoLevel = self:ReadInt32();
        cardsValue.skillThreeID = self:ReadInt32();
        cardsValue.skillThreeLevel = self:ReadInt32();
        cardsValue.lastResetPointTime = self:ReadInt64();
        cardsValue.lastResetCardTime = self:ReadInt64();
        cardsValue.badlyHurtTime = self:ReadInt64();
        cardsValue.tiredRecoverTime = self:ReadInt64();
        self.cards:Push(cardsValue);
    end
end

return AddCardsRespond;
