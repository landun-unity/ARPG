--
-- 逻辑服务器 --> 客户端
-- 卡牌信息
-- @author czx
--
local CardInfo = class("CardInfo");

function CardInfo:ctor()
    --
    -- 卡牌Id
    --
    self.cardId = 0;
    
    --
    -- 卡牌表Id
    --
    self.cardTableId = 0;
    
    --
    -- 卡牌等级
    --
    self.cardLevel = 0;
end

return CardInfo;
