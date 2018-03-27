--
-- 客户端 --> 逻辑服务器
-- 研究技能
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local ResearchSkill = class("ResearchSkill", GameMessage);

--
-- 构造函数
--
function ResearchSkill:ctor()
    ResearchSkill.super.ctor(self);
    --
    -- 技能Id
    --
    self.skillID = 0;
    
    --
    -- 要吃掉的卡牌ID
    --
    self.cards = List.new();
end

--@Override
function ResearchSkill:_OnSerial() 
    self:WriteInt64(self.skillID);
    
    local cardsCount = self.cards:Count();
    self:WriteInt32(cardsCount);
    for i = 1, cardsCount, 1 do 
        self:WriteInt64(self.cards:Get(i));
    end
end

--@Override
function ResearchSkill:_OnDeserialize() 
    self.skillID = self:ReadInt64();
    
    local cardsCount = self:ReadInt32();
    for i = 1, cardsCount, 1 do 
        self.cards:Push(self:ReadInt64());
    end
end

return ResearchSkill;
