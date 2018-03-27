-- Anchor:Dr
-- Date 16/9/14
-- 武将卡类

local CardModel = class("CardModel");

function CardModel:ctor()

    --CardModel.super.ctor(self);
    -- 唯一ID
    self.iD = 0;

    -- tableid
    self._tableID = 0;

    -- 经验l
    self._exp = 0;

    --等级
    self._level=0;

    -- 进阶次数
    self.advancedTime = 0;

    -- 体力
    self.power = 0;

    -- 兵力
    self.troop = 0;

    -- 剩余的策略点
    self.point = 0;

    -- 攻击加的点数
    self.selfattacktPoint = 0;

    -- 防御加的点数
    self.defensePoint = 0;

    -- 谋略加的点数
    self.selfstrategyPoint = 0;

    -- 速度加的点数	
    self.speedPoint = 0;

    -- 是否被保护
    self.isProtect = false;

    -- 是否觉醒	
    self.isAwaken = false;

    -- 第一个技能ID
    self.skillIDOne = 0;

    -- 第一个技能等级
    self.SkillOneLevel = 0;

    -- 第二个技能

    self.SkillTwoID = 0;

    -- 第二个技能等级	
    self.SkillTwoLevel = 0;

    -- 第三个技能
    self.SkillThreeID = 0;

    -- 第三个技能等级
    self.SkillThreeLevel = 0;

end

return CardModel;

-- endregion
