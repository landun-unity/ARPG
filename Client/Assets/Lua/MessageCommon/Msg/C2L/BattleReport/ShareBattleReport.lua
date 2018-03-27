--
-- 客户端 --> 逻辑服务器
-- 分享到聊天
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ShareBattleReport = class("ShareBattleReport", GameMessage);

--
-- 构造函数
--
function ShareBattleReport:ctor()
    ShareBattleReport.super.ctor(self);
    --
    -- 战报Id
    --
    self.battleReportID = 0;
end

--@Override
function ShareBattleReport:_OnSerial() 
    self:WriteInt64(self.battleReportID);
end

--@Override
function ShareBattleReport:_OnDeserialize() 
    self.battleReportID = self:ReadInt64();
end

return ShareBattleReport;
