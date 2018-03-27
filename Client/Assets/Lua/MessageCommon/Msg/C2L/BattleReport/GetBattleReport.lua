--
-- 客户端 --> 逻辑服务器
-- 获取战报
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetBattleReport = class("GetBattleReport", GameMessage);

--
-- 构造函数
--
function GetBattleReport:ctor()
    GetBattleReport.super.ctor(self);
    --
    -- 战报分组 1个人 2同盟
    --
    self.battleReportGroup = 0;
    
    --
    -- 战报种类 0所有 1攻击 2.防御 3攻城
    --
    self.battleReportType = 0;
    
    --
    -- 页数
    --
    self.pageCount = 0;
end

--@Override
function GetBattleReport:_OnSerial() 
    self:WriteInt32(self.battleReportGroup);
    self:WriteInt32(self.battleReportType);
    self:WriteInt32(self.pageCount);
end

--@Override
function GetBattleReport:_OnDeserialize() 
    self.battleReportGroup = self:ReadInt32();
    self.battleReportType = self:ReadInt32();
    self.pageCount = self:ReadInt32();
end

return GetBattleReport;
