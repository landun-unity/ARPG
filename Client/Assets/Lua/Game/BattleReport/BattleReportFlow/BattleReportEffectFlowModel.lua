

-- 战报EffectFlow

local BattleReportEffectFlowModel = class("BattleReportEffectFlowModel");
local BattleFlowType = require("Game/BattleReport/BattleFlowType");

function BattleReportEffectFlowModel:ctor()
    --类型
    self.BattleFlowType = BattleFlowType.Effect

    -- 攻击英雄
    self.AttackHeroId = 0

    --是否是真正的攻击方
    self.AIsAttackPart = false;

    -- 防御英雄
    self.DefenceHeroId = 0

    --是否是真正的攻击方
    self.DIsAttackPart = false;

    -- 效果Type
    self.EffectType = 0

    -- 效果id
    self.EffectId = 0

    -- 效果参数
    self.EffectParam = 0

    -- 效果参数
    self.EffectParam2 = 0

    -- 效果参数
    self.EffectParam3 = 0

    -- 是否是变灰色
    self.isgray = false;

end

function BattleReportEffectFlowModel:_OnDeserialize(byteArray,isgray)
    self.isgray = byteArray:ReadBoolean();
    self.BattleFlowType = byteArray:ReadInt32();
    self.AttackHeroId = byteArray:ReadInt32();
    self.AIsAttackPart = byteArray:ReadBoolean()
    self.DefenceHeroId = byteArray:ReadInt32();
    self.DIsAttackPart = byteArray:ReadBoolean()
    self.EffectType = byteArray:ReadInt32();
    self.EffectId = byteArray:ReadInt32();
    self.EffectParam = byteArray:ReadInt32();
    self.EffectParam2 = byteArray:ReadInt32();
    self.EffectParam3 = byteArray:ReadInt32();
    -- 
end
return BattleReportEffectFlowModel