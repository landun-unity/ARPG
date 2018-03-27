local HeroHandbookCard = class("HeroHandbookCard");
--local DataHeroLevel = require("Game/Table/model/DataHeroLevel");

function HeroHandbookCard:ctor()
    -- 唯一ID
    self.id = 0;

    -- tableid
    self.tableID = 0;

    -- 经验l
    self.exp = 0;

    --等级
    self.level=0;

    -- 进阶次数
    self.advancedTime = 0;

    -- 体力
    self.power = 0;

    --攻击
    self.attack =0;
    --防御
    self.def =0;
    --谋略
    self.strategy=0;
    --速度
    self.speed =0;
    -- 兵力
    self.troop = 0;

    -- 剩余的策略点
    self.point = 0;

    -- 是否被保护
    self.isProtect = false;

    -- 是否觉醒	
    self.isAwaken = false;

    -- 技能
    self.allSkillSlotList = {};
    -- 技能等级
    self.allSkillLevelList = {};
    -- 技能槽位的最大数值
    self.Max_Skill_Slot = 3;

    self.lastResetPointTime = 0;

    self.lastResetCardTime = 0;

    self.baseArmy = nil;
    self.cost = 0;
    self.star = 0;
    self.camp = 0;

end


-- 获取技能 从1开始
function HeroHandbookCard:GetSkill(index)
    if index == nil or index < 1 or index > self.Max_Skill_Slot then
        return 0;
    end
      if self.allSkillSlotList[index] == nil then
        return 0;
    end
    return self.allSkillSlotList[index];
end

-- 获取技能 从1开始
function HeroHandbookCard:GetSkillLevel(index)
    if index == nil or index < 1 or index > self.Max_Skill_Slot then
        return 0;
    end
    if self.allSkillLevelList[index] == nil then
        return 0;
    end
    return self.allSkillLevelList[index];
end


-- 设置卡牌重置时间
function HeroHandbookCard:GetLastResetTime()

    return self.lastResetCardTime

end


function HeroHandbookCard:SetLastResetTime(time)

    self.lastResetCardTime = time

end
-- 设置技能
-- index 位置索引 从1开始
-- skill 技能
-- level 技能的等级
function HeroHandbookCard:SetSkill(index, skill, level)
    if index == nil or index < 1 or index > self.Max_Skill_Slot then
        return;
    end

    self.allSkillSlotList[index] = skill;
    self.allSkillLevelList[index] = level;
end




return HeroHandbookCard;