--
-- 逻辑服务器 --> 客户端
-- 玩家的一页卡牌
-- @author czx
--
local CardModel = class("CardModel");

function CardModel:ctor()
    --
    -- 卡牌列表
    --
    self.id = 0;
    
    --
    -- 表Id
    --
    self.tableID = 0;
    
    --
    -- 经验
    --
    self.exp = 0;
    
    --
    -- 进阶次数
    --
    self.advancedTime = 0;
    
    --
    -- 体力
    --
    self.power = 0;
    
    --
    -- 等级
    --
    self.level = 0;
    
    --
    -- 兵力
    --
    self.troop = 0;
    
    --
    -- 剩余策略点
    --
    self.point = 0;
    
    --
    -- 攻击加的点数
    --
    self.attacktPoint = 0;
    
    --
    -- 防御加的点数
    --
    self.defensePoint = 0;
    
    --
    -- 谋略加的点数
    --
    self.strategyPoint = 0;
    
    --
    -- 速度加的点数
    --
    self.speedPoint = 0;
    
    --
    -- 是否被保护
    --
    self.isProtect = false;
    
    --
    -- 是否觉醒
    --
    self.isAwaken = false;
    
    --
    -- 第一个技能ID
    --
    self.skillIDOne = 0;
    
    --
    -- 第一个技能等级
    --
    self.skillOneLevel = 0;
    
    --
    -- 第二个技能
    --
    self.skillTwoID = 0;
    
    --
    -- 第二个技能
    --
    self.skillTwoLevel = 0;
    
    --
    -- 第三个技能
    --
    self.skillThreeID = 0;
    
    --
    -- 第三个技能等级
    --
    self.skillThreeLevel = 0;
    
    --
    -- 上次洗点时间
    --
    self.lastResetPointTime = 0;
    
    --
    -- 上次卡牌重置时间
    --
    self.lastResetCardTime = 0;
    
    --
    -- 卡牌重伤恢复时间
    --
    self.badlyHurtTime = 0;
    
    --
    -- 卡牌疲劳恢复时间
    --
    self.tiredRecoverTime = 0;
end

return CardModel;
