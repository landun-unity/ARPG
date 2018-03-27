--
-- 逻辑服务器 --> 客户端
-- 卡牌信息
-- @author czx
--
local RecruitCardInfo = class("RecruitCardInfo");

function RecruitCardInfo:ctor()
   --
    -- 卡牌Id
    --
    self._cardId = 0;
    
    --
    -- 卡牌表Id
    --
    self._cardTableId = 0;
    
    --
    -- 卡牌等级
    --
    self._cardLevel = 0;
end

function RecruitCardInfo:Init(model)
    self._cardId = model.cardId;
    self._cardTableId = model.cardTableId;
    self._cardLevel = model.cardLevel;
end

return RecruitCardInfo;
