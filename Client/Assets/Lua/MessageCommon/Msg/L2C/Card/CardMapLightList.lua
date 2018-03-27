--
-- 逻辑服务器 --> 客户端
-- 玩家已有的卡牌对应的图鉴点亮
-- @author czx
--
local List = require("common/List");

local CardMapLightModel = require("MessageCommon/Msg/L2C/Card/CardMapLightModel");

local GameMessage = require("common/Net/GameMessage");
local CardMapLightList = class("CardMapLightList", GameMessage);

--
-- 构造函数
--
function CardMapLightList:ctor()
    CardMapLightList.super.ctor(self);
    --
    -- 卡牌tableId
    --
    self.cardTable = List.new();
end

--@Override
function CardMapLightList:_OnSerial() 
    
    local cardTableCount = self.cardTable:Count();
    self:WriteInt32(cardTableCount);
    for cardTableIndex = 1, cardTableCount, 1 do 
        local cardTableValue = self.cardTable:Get(cardTableIndex);
        self:WriteInt32(cardTableValue.id);
    end
end

--@Override
function CardMapLightList:_OnDeserialize() 
    
    local cardTableCount = self:ReadInt32();
    for i = 1, cardTableCount, 1 do 
        local cardTableValue = CardMapLightModel.new();
        cardTableValue.id = self:ReadInt32();
        self.cardTable:Push(cardTableValue);
    end
end

return CardMapLightList;
