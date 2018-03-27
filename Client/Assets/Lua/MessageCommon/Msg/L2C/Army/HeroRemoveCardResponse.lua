--
-- 逻辑服务器 --> 客户端
-- 部队移除卡牌回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local HeroRemoveCardResponse = class("HeroRemoveCardResponse", GameMessage);

--
-- 构造函数
--
function HeroRemoveCardResponse:ctor()
    HeroRemoveCardResponse.super.ctor(self);
    --
    -- 移除掉的卡牌的id
    --
    self.removedCardId = 0;
end

--@Override
function HeroRemoveCardResponse:_OnSerial() 
    self:WriteInt64(self.removedCardId);
end

--@Override
function HeroRemoveCardResponse:_OnDeserialize() 
    self.removedCardId = self:ReadInt64();
end

return HeroRemoveCardResponse;
