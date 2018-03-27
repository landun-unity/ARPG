
-- 战报卡牌

local BattleReportOutNullReportReasonModel = class("BattleReportOutNullReportReasonModel");
function BattleReportOutNullReportReasonModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.NullReportReason
    self.NullReportReasonType = 0;
end

function BattleReportOutNullReportReasonModel:_OnDeserialize(byteArray)
    self.NullReportReasonType = byteArray:ReadInt32();
end

return BattleReportOutNullReportReasonModel