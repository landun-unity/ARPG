
-- 战报卡牌

local BattleReportOutOccupyModel = class("BattleReportOutOccupyModel");
function BattleReportOutOccupyModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.Occupy
    self.tileIndex = 0;
    self.OccupyType = 1;
    self.buildingID = 0;
    self.name = "";
end

function BattleReportOutOccupyModel:_OnDeserialize(byteArray)
    self.tileIndex = byteArray:ReadInt32();
    self.OccupyType = byteArray:ReadInt32();
    self.buildingID = byteArray:ReadInt64();
    self.name = byteArray:ReadString();
end

return BattleReportOutOccupyModel