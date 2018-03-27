--
-- 逻辑服务器 --> 客户端
-- 招募到的卡牌列表
-- @author czx
--
local List = require("common/List");

local CardInfo = require("MessageCommon/Msg/L2C/Recruit/CardInfo");

local GameMessage = require("common/Net/GameMessage");
local ReturnCardList = class("ReturnCardList", GameMessage);

--
-- 构造函数
--
function ReturnCardList:ctor()
    ReturnCardList.super.ctor(self);
    --
    -- 卡包ID
    --
    self.recruitPackageId = 0;
    
    --
    -- 转换战法经验
    --
    self.transExpValue = 0;
    
    --
    -- 是否是批量招募
    --
    self.isBatchRecruit = 0;
    
    --
    -- 卡牌列表
    --
    self.cardList = List.new();
end

--@Override
function ReturnCardList:_OnSerial() 
    self:WriteInt64(self.recruitPackageId);
    self:WriteInt32(self.transExpValue);
    self:WriteInt32(self.isBatchRecruit);
    
    local cardListCount = self.cardList:Count();
    self:WriteInt32(cardListCount);
    for cardListIndex = 1, cardListCount, 1 do 
        local cardListValue = self.cardList:Get(cardListIndex);
        
        self:WriteInt64(cardListValue.cardId);
        self:WriteInt32(cardListValue.cardTableId);
        self:WriteInt32(cardListValue.cardLevel);
    end
end

--@Override
function ReturnCardList:_OnDeserialize() 
    self.recruitPackageId = self:ReadInt64();
    self.transExpValue = self:ReadInt32();
    self.isBatchRecruit = self:ReadInt32();
    
    local cardListCount = self:ReadInt32();
    for i = 1, cardListCount, 1 do 
        local cardListValue = CardInfo.new();
        cardListValue.cardId = self:ReadInt64();
        cardListValue.cardTableId = self:ReadInt32();
        cardListValue.cardLevel = self:ReadInt32();
        self.cardList:Push(cardListValue);
    end
end

return ReturnCardList;
