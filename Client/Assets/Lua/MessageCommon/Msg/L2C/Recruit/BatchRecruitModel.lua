--
-- 逻辑服务器 --> 客户端
-- 批量招募返回的信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local BatchRecruitModel = class("BatchRecruitModel", GameMessage);

--
-- 构造函数
--
function BatchRecruitModel:ctor()
    BatchRecruitModel.super.ctor(self);
    --
    -- 1星卡牌数量
    --
    self.oneStarCardsCount = 0;
    
    --
    -- 2星卡牌数量
    --
    self.twoStarCardsCount = 0;
    
    --
    -- 3星卡牌数量
    --
    self.threeStarCardsCount = 0;
    
    --
    -- 4星卡牌数量
    --
    self.fourStarCardsCount = 0;
    
    --
    -- 转换了多少经验
    --
    self.transExp = 0;
end

--@Override
function BatchRecruitModel:_OnSerial() 
    self:WriteInt32(self.oneStarCardsCount);
    self:WriteInt32(self.twoStarCardsCount);
    self:WriteInt32(self.threeStarCardsCount);
    self:WriteInt32(self.fourStarCardsCount);
    self:WriteInt32(self.transExp);
end

--@Override
function BatchRecruitModel:_OnDeserialize() 
    self.oneStarCardsCount = self:ReadInt32();
    self.twoStarCardsCount = self:ReadInt32();
    self.threeStarCardsCount = self:ReadInt32();
    self.fourStarCardsCount = self:ReadInt32();
    self.transExp = self:ReadInt32();
end

return BatchRecruitModel;
