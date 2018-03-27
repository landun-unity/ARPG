--
-- 客户端 --> 逻辑服务器
-- 招募卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RecruitCards = class("RecruitCards", GameMessage);

--
-- 构造函数
--
function RecruitCards:ctor()
    RecruitCards.super.ctor(self);
    --
    -- 卡包Id
    --
    self.cardPackageID = 0;
    
    --
    -- 招募个数
    --
    self.cardCount = 0;
    
    --
    -- 是否转换为战法经验
    --
    self.transToExp = false;
    
    --
    -- 几星以下转换成战法经验 TransToExp为false时不用考虑
    --
    self.transUnderStarNum = 0;
    
    --
    -- 是用玉石转换还是金币转换
    --
    self.transWay = 0;
    
    --
    -- 是否召唤到4星为止
    --
    self.isUntilForeStar = false;
    
    --
    -- 是否是批量招募
    --
    self.isBatchRecruit = false;
end

--@Override
function RecruitCards:_OnSerial() 
    self:WriteInt64(self.cardPackageID);
    self:WriteInt32(self.cardCount);
    self:WriteBoolean(self.transToExp);
    self:WriteInt32(self.transUnderStarNum);
    self:WriteInt32(self.transWay);
    self:WriteBoolean(self.isUntilForeStar);
    self:WriteBoolean(self.isBatchRecruit);
end

--@Override
function RecruitCards:_OnDeserialize() 
    self.cardPackageID = self:ReadInt64();
    self.cardCount = self:ReadInt32();
    self.transToExp = self:ReadBoolean();
    self.transUnderStarNum = self:ReadInt32();
    self.transWay = self:ReadInt32();
    self.isUntilForeStar = self:ReadBoolean();
    self.isBatchRecruit = self:ReadBoolean();
end

return RecruitCards;
