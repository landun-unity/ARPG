
--某块地的连续战斗 没有连续战斗的只有一个
local BattleReportInfoList = class("BattleReportInfoList");
local List=require("common/List");

function BattleReportInfoList:ctor()
    --
    -- 连续的战报
    --
    self._continueList = List.new();
end

return BattleReportInfoList;