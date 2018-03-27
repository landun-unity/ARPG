-- Anchor:Dr
-- Date 16/9/14
-- 武将卡类
local HeroCard = class("HeroCard");
local DataHero = require("Game/Table/model/DataHero");
local VariationCalc = require("Game/Util/VariationCalc")

function HeroCard:ctor()
    -- 唯一ID
    self.id = 0;
    -- 兵种类型
    self.baseArmy = 0;
    -- tableid
    self.tableID = 0;
    -- 经验l
    self.exp = 0;
    -- 等级
    self.level = 1;
    -- 进阶次数
    self.advancedTime = 0;
    -- 体力
    self.power = nil;
--    self.power = VariationCalc.new();
--    --self.power:Init(mmHerocard.power, os.time());
--    self.power:SetVariationVal(1);
--    self.power:SetVariationSpace(3 * 60 * 1000);
--    self.power:SetMaxValue(100);
    -- 攻击
    self.attack = 0;
    -- 防御
    self.def = 0;
    -- 谋略
    self.strategy = 0;
    -- 速度
    self.speed = 0;
    --加的速度属性点
    -- 所属的城市id，只有在部队中才有。
    self.buildingId = 0;
    -- 兵力
    self.troop = 0;
    -- 攻城
    self.siege = 0;

    -- 重伤恢复时间
    self.RecoverTime = 0;
    self.hurtTimer = nil;

    --疲劳恢复时间
    self.TiredTime = 0;
    self.tiredTimer = nil;

    -- 剩余的策略点
    self.point = 0;

    -- 是否被保护
    self.isProtect = false;

    -- 是否觉醒	
    self.isAwaken = false;

    -- 技能
    self.allSkillSlotList = { };
    -- 技能等级
    self.allSkillLevelList = { };
    -- 技能槽位的最大数值
    self.Max_Skill_Slot = 3;

    self.lastResetPointTime = 0;
    self.lastResetCardTime = 0;

    self.soilderType = 0;
    self.cost = 0;
    self.star = 0;
    self.camp = 0;
end

function HeroCard:InitPower(count)
    if self.power == nil then
        self.power = VariationCalc.new();
        self.power:Init(count, PlayerService:Instance():GetLocalTime(),false);
        self.power:SetVariationVal(1);
        self.power:SetVariationSpace(DataGameConfig[115].OfficialData);
        self.power:SetMaxValue(100);
    end
end

-- 设置卡牌兵力
function HeroCard:SetCardTroop(count)
    self.troop = count;
end

-- 设置所属城市（在部队中才会设置）
function HeroCard:SetBuildingId(id)
    self.buildingId = id;
end

-- 获取技能 从1开始
function HeroCard:GetSkill(index)
    if index == nil or index < 1 or index > self.Max_Skill_Slot then
        return 0;
    end
    if self.allSkillSlotList[index] == nil then
        return 0;
    end
    return self.allSkillSlotList[index];
end

-- 获取技能 从1开始
function HeroCard:GetSkillLevel(index)
    if index == nil or index < 1 or index > self.Max_Skill_Slot then
        return 0;
    end
    if self.allSkillLevelList[index] == nil then
        return 0;
    end
    return self.allSkillLevelList[index];
end


-- 设置卡牌重置时间
function HeroCard:GetLastResetTime()

    return self.lastResetCardTime

end


function HeroCard:SetLastResetTime(time)

    self.lastResetCardTime = time

end

-- 设置技能
-- index 位置索引 从1开始
-- skill 技能
-- level 技能的等级
function HeroCard:SetSkill(index, skill, level)
    if index == nil or index < 1 or index > self.Max_Skill_Slot then
        return;
    end
    self.allSkillSlotList[index] = skill;
    self.allSkillLevelList[index] = level;
end

-- 获取卡牌的cost
function HeroCard:GetHeroCostValue()
    if self.tableID == 0 then
        -- print("error: self.tableID is nil!!!!!!!!!!!!!!!!!!! ");
        return 0;
    end
    return DataHero[self.tableID].Cost;
end

function HeroCard:GetLastResetTime()

    return self.lastResetPointTime;

end

function HeroCard:SetLastResetTime(v)

    self.lastResetPointTime = v;

end

-- 获取卡牌的攻城市值
function HeroCard:GetSiegeValue()
    return  math.floor(DataHero[self.tableID].SiegeBase +(self.level - 1) * DataHero[self.tableID].SiegeUpgrade);
end

-- 获取卡牌的速度值
function HeroCard:GetSpeedValue()
    return math.floor(DataHero[self.tableID].SpeedBase +(self.level - 1) * DataHero[self.tableID].SpeedUpgrade + self.speed);
end

-- 重伤时间倒计时
function HeroCard:SetHurtTimer()
    if self.RecoverTime > 0 then
        local curTimeStamp = PlayerService:Instance():GetLocalTime();
        local valueTime = math.floor(self.RecoverTime - curTimeStamp);
        if valueTime <= 0 then
            valueTime = 0;
        end
        self.hurtTimer = CommonService:Instance():DataTimeDown(valueTime, self.hurtTimer, function() self:HurtTimeEnd() end);
    else
        return;
    end
end

function HeroCard:SetTiredTimer()
     if self.TiredTime > 0 and self.tiredTimer == nil then
        local curTimeStamp = PlayerService:Instance():GetLocalTime();
        local valueTime = math.floor(self.TiredTime - curTimeStamp);
        if valueTime <= 0 then
            valueTime = 0;
        end
        self.tiredTimer = CommonService:Instance():DataTimeDown(valueTime, self.tiredTimer, function() self:TiredTimeEnd() end);
    else
        return;
    end
end

function HeroCard:TiredTimeEnd()
    self.TiredTime = 0;
end

function HeroCard:HurtTimeEnd()
    self.RecoverTime = 0;
end

-- 是否已学习此技能
function HeroCard:IsLearnedSkill(SkillID)
    for i = 1, 3 do
        if self:GetSkill(i) == SkillID then
          return true
        end
    end
    return false
end


return HeroCard;
