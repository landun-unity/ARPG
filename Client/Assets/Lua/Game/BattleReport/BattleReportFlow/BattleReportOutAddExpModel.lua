
-- 战报卡牌

local BattleReportOutAddExpModel = class("BattleReportOutAddExpModel");
function BattleReportOutAddExpModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.AddExp
    self.CardID = 0;
    self.IsAttackPart = false;
    self.Exp = 0;
    self.isUpLevel = false;
    self.cardLevel = 0;

end

function BattleReportOutAddExpModel:_OnDeserialize(byteArray)
    self.CardID = byteArray:ReadInt32();
    self.IsAttackPart = byteArray:ReadBoolean();
    self.Exp = byteArray:ReadInt32();
    self.isUpLevel = byteArray:ReadBoolean();
    self.cardLevel = byteArray:ReadInt32();
end

return BattleReportOutAddExpModel