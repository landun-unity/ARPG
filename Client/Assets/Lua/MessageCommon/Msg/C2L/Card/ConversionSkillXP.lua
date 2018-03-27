--
-- 客户端 --> 逻辑服务器
-- 转换战法经验
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local ConversionSkillXP = class("ConversionSkillXP", GameMessage);

--
-- 构造函数
--
function ConversionSkillXP:ctor()
    ConversionSkillXP.super.ctor(self);
    --
    -- 卡牌列表
    --
    self.cards = List.new();
    
    --
    -- 转化花费类型
    --
    self.costType = 0;
end

--@Override
function ConversionSkillXP:_OnSerial() 
    
    local cardsCount = self.cards:Count();
    self:WriteInt32(cardsCount);
    for i = 1, cardsCount, 1 do 
        self:WriteInt64(self.cards:Get(i));
    end
    self:WriteInt32(self.costType);
end

--@Override
function ConversionSkillXP:_OnDeserialize() 
    
    local cardsCount = self:ReadInt32();
    for i = 1, cardsCount, 1 do 
        self.cards:Push(self:ReadInt64());
    end
    self.costType = self:ReadInt32();
end

return ConversionSkillXP;
