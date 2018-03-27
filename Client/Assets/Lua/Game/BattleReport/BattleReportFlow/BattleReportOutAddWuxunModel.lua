
-- 战报卡牌

local BattleReportOutAddWuxunModel = class("BattleReportOutAddWuxunModel");
function BattleReportOutAddWuxunModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.AddWuxun
    self.WnxunValue = 0;
end

function BattleReportOutAddWuxunModel:_OnDeserialize(byteArray)
    self.WnxunValue = byteArray:ReadInt32();
end

return BattleReportOutAddWuxunModel