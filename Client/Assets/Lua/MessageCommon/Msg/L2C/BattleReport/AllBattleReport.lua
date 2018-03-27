--
-- 逻辑服务器 --> 客户端
-- 所有的战报列表
-- @author czx
--
local List = require("common/List");

local BattleReportContinuous = require("MessageCommon/Msg/L2C/BattleReport/BattleReportContinuous");
local BattleReportModel = require("MessageCommon/Msg/L2C/BattleReport/BattleReportModel");

local GameMessage = require("common/Net/GameMessage");
local AllBattleReport = class("AllBattleReport", GameMessage);

--
-- 构造函数
--
function AllBattleReport:ctor()
    AllBattleReport.super.ctor(self);
    --
    -- 战报列表
    --
    self.allBattleReport = List.new();
end

--@Override
function AllBattleReport:_OnSerial() 
    
    local allBattleReportCount = self.allBattleReport:Count();
    self:WriteInt32(allBattleReportCount);
    for allBattleReportIndex = 1, allBattleReportCount, 1 do 
        local allBattleReportValue = self.allBattleReport:Get(allBattleReportIndex);
        
        
        local allBattleReportValueBattleReportContinueCount = allBattleReportValue.battleReportContinue:Count();
        self:WriteInt32(allBattleReportValueBattleReportContinueCount);
        for allBattleReportValueBattleReportContinueIndex = 1, allBattleReportValueBattleReportContinueCount, 1 do 
            local allBattleReportValueBattleReportContinueValue = allBattleReportValue.battleReportContinue:Get(allBattleReportValueBattleReportContinueIndex);
            
            self:WriteInt64(allBattleReportValueBattleReportContinueValue.iD);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.battleType);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.placeType);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.tileIndex);
            self:WriteInt64(allBattleReportValueBattleReportContinueValue.fightTime);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.aCardTableID);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.aCardLevel);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.aAdvanceStar);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.dCardTableID);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.dCardLevel);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.dAdvanceStar);
            self:WriteString(allBattleReportValueBattleReportContinueValue.aPlayerName);
            self:WriteString(allBattleReportValueBattleReportContinueValue.aleagueName);
            self:WriteString(allBattleReportValueBattleReportContinueValue.dPlayerName);
            self:WriteString(allBattleReportValueBattleReportContinueValue.dleagueName);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.aTroopNum);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.dTroopNum);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.resultType);
            self:WriteBoolean(allBattleReportValueBattleReportContinueValue.isRead);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.reportType);
            self:WriteInt32(allBattleReportValueBattleReportContinueValue.drawTimes);
        end
    end
end

--@Override
function AllBattleReport:_OnDeserialize() 
    
    local allBattleReportCount = self:ReadInt32();
    for i = 1, allBattleReportCount, 1 do 
        local allBattleReportValue = BattleReportContinuous.new();
        
        local allBattleReportValueBattleReportContinueCount = self:ReadInt32();
        for i = 1, allBattleReportValueBattleReportContinueCount, 1 do 
            local allBattleReportValueBattleReportContinueValue = BattleReportModel.new();
            allBattleReportValueBattleReportContinueValue.iD = self:ReadInt64();
            allBattleReportValueBattleReportContinueValue.battleType = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.placeType = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.tileIndex = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.fightTime = self:ReadInt64();
            allBattleReportValueBattleReportContinueValue.aCardTableID = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.aCardLevel = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.aAdvanceStar = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.dCardTableID = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.dCardLevel = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.dAdvanceStar = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.aPlayerName = self:ReadString();
            allBattleReportValueBattleReportContinueValue.aleagueName = self:ReadString();
            allBattleReportValueBattleReportContinueValue.dPlayerName = self:ReadString();
            allBattleReportValueBattleReportContinueValue.dleagueName = self:ReadString();
            allBattleReportValueBattleReportContinueValue.aTroopNum = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.dTroopNum = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.resultType = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.isRead = self:ReadBoolean();
            allBattleReportValueBattleReportContinueValue.reportType = self:ReadInt32();
            allBattleReportValueBattleReportContinueValue.drawTimes = self:ReadInt32();
            allBattleReportValue.battleReportContinue:Push(allBattleReportValueBattleReportContinueValue);
        end
        self.allBattleReport:Push(allBattleReportValue);
    end
end

return AllBattleReport;
