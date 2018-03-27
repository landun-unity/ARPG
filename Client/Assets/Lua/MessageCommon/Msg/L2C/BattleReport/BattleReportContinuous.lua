--
-- 逻辑服务器 --> 客户端
-- 连续的战报
-- @author czx
--
local List = require("common/List");

local BattleReportModel = require("MessageCommon/Msg/L2C/BattleReport/BattleReportModel");

local BattleReportContinuous = class("BattleReportContinuous");

function BattleReportContinuous:ctor()
    --
    -- 连续的战报
    --
    self.battleReportContinue = List.new();
end

return BattleReportContinuous;
