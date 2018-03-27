

-- 战报统计

local BattleReportCountModel = class("BattleReportCountModel");

function BattleReportCountModel:ctor()

    -- 武将
    self.cardID = 0

    -- 普通杀伤
    self.normalDamage = 0

    -- 战法杀伤
    self.SkillDamage = 0

    -- 战法释放
    self.DoSkillTimes = 0

    -- 救援
    self.helpNum = 0

    -- 损失
    self.losseNum = 0

    -- 本场伤病
    self.theWoundNum = 0

    -- 总伤病
    self.woundNumSum = 0
end

function BattleReportCountModel:_OnDeserialize(byteArray)
    self.cardID = byteArray:ReadInt32();
    self.normalDamage = byteArray:ReadInt32();
    self.SkillDamage = byteArray:ReadInt32();
    self.DoSkillTimes = byteArray:ReadInt32();
    self.helpNum = byteArray:ReadInt32();
    self.losseNum = byteArray:ReadInt32();
    self.theWoundNum = byteArray:ReadInt32();
    self.woundNumSum = byteArray:ReadInt32();
end

return BattleReportCountModel