
-- 战报卡牌

local BattleReportOutLoseBuildingModel = class("BattleReportOutLoseBuildingModel");
function BattleReportOutLoseBuildingModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.LoseBuilding
    self.tiledID = 0;
    self.buildingName = ""
    self.buildingID = 0;
	self.name = "";
end

function BattleReportOutLoseBuildingModel:_OnDeserialize(byteArray)
    self.tiledID = byteArray:ReadInt32();
    self.buildingName = byteArray:ReadString();
    self.buildingID = byteArray:ReadInt64();
    self.name = byteArray:ReadString();
end

return BattleReportOutLoseBuildingModel