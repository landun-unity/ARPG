
-- 战报卡牌

local BattleReportOutChangeDurableModel = class("BattleReportOutChangeDurableModel");
function BattleReportOutChangeDurableModel:ctor()

    -- 战报回合外部的类型 -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.ChangeDurable
    self.tileIndex = 0;
    self.changValue = 0;
    self.type = 1;
    self.buildingID = 0;
    self.name = "";
end

function BattleReportOutChangeDurableModel:_OnDeserialize(byteArray)
    self.tileIndex = byteArray:ReadInt32();
    self.changValue = byteArray:ReadInt32();
    self.type = byteArray:ReadInt32();
    self.buildingID = byteArray:ReadInt64();
    self.name = byteArray:ReadString();
end

return BattleReportOutChangeDurableModel