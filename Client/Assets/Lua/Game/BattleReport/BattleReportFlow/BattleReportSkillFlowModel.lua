

-- 战报EffectFlow

local BattleReportSkillFlowModel = class("BattleReportSkillFlowModel");
local BattleFlowType = require("Game/BattleReport/BattleFlowType");
local List = require("common/List");

local BattleReportEffectFlowModel = require("Game/BattleReport/BattleReportFlow/BattleReportEffectFlowModel");
function BattleReportSkillFlowModel:ctor()

    --类型
    self.BattleFlowType = BattleFlowType.Skill

    -- 攻击英雄
    self.AttackHeroId = 0

    --是否是真正的攻击方
    self.AIsAttackPart = false;

    -- 防御英雄
    self.DefenceHeroId = 0

    --是否是真正的攻击方
    self.DIsAttackPart = false;

    -- 技能id
    self.SkillId = 0

    -- 效果List
    self.EffectList = List.new();

end

function BattleReportSkillFlowModel:_OnDeserialize(byteArray)
    self.AttackHeroId = byteArray:ReadInt32();
    self.AIsAttackPart = byteArray:ReadBoolean()
    self.DefenceHeroId = byteArray:ReadInt32();
    self.DIsAttackPart = byteArray:ReadBoolean()
    self.SkillId = byteArray:ReadInt32();
    local flowCount = byteArray:ReadInt32();
    for ind = 1,flowCount do
        local effectflow = BattleReportEffectFlowModel.new();
        effectflow:_OnDeserialize(byteArray);
        self.EffectList:Push(effectflow);
    end
end

return BattleReportSkillFlowModel