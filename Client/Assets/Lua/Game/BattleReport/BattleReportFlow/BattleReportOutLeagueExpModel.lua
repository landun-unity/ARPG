
-- 战报卡牌

local BattleReportOutLeagueExpModel = class("BattleReportOutLeagueExpModel");
function BattleReportOutLeagueExpModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.LeagueExp
    self.exp = 0;
end

function BattleReportOutLeagueExpModel:_OnDeserialize(byteArray)
    self.exp = byteArray:ReadInt32();
end

return BattleReportOutLeagueExpModel