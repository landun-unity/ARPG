
--
local BatchRecruitInfo = class("BatchRecruitInfo");

--
-- 构造函数
--
function BatchRecruitInfo:ctor()
    --
    -- 1星卡牌数量
    --
    self._oneStarCardsCount = 0;
    
    --
    -- 2星卡牌数量
    --
    self._twoStarCardsCount = 0;
    
    --
    -- 3星卡牌数量
    --
    self._threeStarCardsCount = 0;
    
    --
    -- 4星卡牌数量
    --
    self._fourStarCardsCount = 0;
    
    --
    -- 转换了多少经验
    --
    self._transExp = 0;
end

--@Override
function BatchRecruitInfo:Init(model) 
    self._oneStarCardsCount = model.oneStarCardsCount;
    self._twoStarCardsCount = model.twoStarCardsCount;
    self._threeStarCardsCount = model.threeStarCardsCount;
    self._fourStarCardsCount = model.fourStarCardsCount;
    self._transExp = model.transExp;
end


return BatchRecruitInfo;
