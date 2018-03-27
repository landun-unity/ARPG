--
-- 客户端 --> 逻辑服务器
-- 重置卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ResetCard = class("ResetCard", GameMessage);

--
-- 构造函数
--
function ResetCard:ctor()
    ResetCard.super.ctor(self);
    --
    -- 重置卡牌Id
    --
    self.cardID = 0;
end

--@Override
function ResetCard:_OnSerial() 
    self:WriteInt64(self.cardID);
end

--@Override
function ResetCard:_OnDeserialize() 
    self.cardID = self:ReadInt64();
end

return ResetCard;
