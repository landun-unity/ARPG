--
-- 客户端 --> 逻辑服务器
-- 觉醒卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AwakenOneCard = class("AwakenOneCard", GameMessage);

--
-- 构造函数
--
function AwakenOneCard:ctor()
    AwakenOneCard.super.ctor(self);
    --
    -- 要觉醒的卡牌Id
    --
    self.awakenCard = 0;
    
    --
    -- 吃掉的第一张卡
    --
    self.removeOneCard = 0;
    
    --
    -- 吃掉的第二张卡
    --
    self.removeTwoCard = 0;
end

--@Override
function AwakenOneCard:_OnSerial() 
    self:WriteInt64(self.awakenCard);
    self:WriteInt64(self.removeOneCard);
    self:WriteInt64(self.removeTwoCard);
end

--@Override
function AwakenOneCard:_OnDeserialize() 
    self.awakenCard = self:ReadInt64();
    self.removeOneCard = self:ReadInt64();
    self.removeTwoCard = self:ReadInt64();
end

return AwakenOneCard;
