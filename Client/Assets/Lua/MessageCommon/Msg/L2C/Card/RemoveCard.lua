--
-- 逻辑服务器 --> 客户端
-- 删除卡牌
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local RemoveCard = class("RemoveCard", GameMessage);

--
-- 构造函数
--
function RemoveCard:ctor()
    RemoveCard.super.ctor(self);
    --
    -- 卡牌列表
    --
    self.removeCardList = List.new();
end

--@Override
function RemoveCard:_OnSerial() 
    
    local removeCardListCount = self.removeCardList:Count();
    self:WriteInt32(removeCardListCount);
    for removeCardListIndex = 1, removeCardListCount, 1 do 
        self:WriteInt64(self.removeCardList:Get(removeCardListIndex));
    end
end

--@Override
function RemoveCard:_OnDeserialize() 
    
    local removeCardListCount = self:ReadInt32();
    for i = 1, removeCardListCount, 1 do 
        self.removeCardList:Push(self:ReadInt64());
    end
end

return RemoveCard;
