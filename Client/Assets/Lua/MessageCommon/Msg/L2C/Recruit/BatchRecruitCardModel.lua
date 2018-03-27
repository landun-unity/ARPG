--
-- 逻辑服务器 --> 客户端
-- 返回招募到的卡牌
-- @author czx
--
local BatchRecruitCardModel = class("BatchRecruitCardModel");

function BatchRecruitCardModel:ctor()
    --
    -- 招募到的卡牌ID
    --
    self.cardId = 0;
    
    --
    -- 招募到的卡牌tableId
    --
    self.cardTableId = 0;
end

return BatchRecruitCardModel;
