-- Õ½±¨ÏûÏ¢´¦Àí
local IOHandler = require("FrameWork/Game/IOHandler")
local BattleReportHandler = class("BattleReportHandler", IOHandler)
local BattleReportInfo = require("Game/BattleReport/BattleReportInfo")
local BattleReportInfoList = require("Game/BattleReport/BattleReportInfoList")
local List=require("common/List");

local BattleReportDetailModel = require("Game/BattleReport/BattleReportFlow/BattleReportDetailModel")

-- ¹¹Ôìº¯Êý
function BattleReportHandler:ctor( )
    -- body
    BattleReportHandler.super.ctor(self);
end

-- ×¢²áËùÓÐÏûÏ¢
function BattleReportHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_BattleReport.AllBattleReport, self.HandleAllReport, require("MessageCommon/Msg/L2C/BattleReport/AllBattleReport"));
    self:RegisterMessage(L2C_BattleReport.BattleReportUnReadCount, self.BattleReportUnReadCount, require("MessageCommon/Msg/L2C/BattleReport/BattleReportUnReadCount"));
    self:RegisterMessage(L2C_BattleReport.BattleReportMemblock, self.BattleReportMemblock, require("MessageCommon/Msg/L2C/BattleReport/BattleReportMemblock"));
    self:RegisterMessage(L2C_BattleReport.OneBattleReport, self.OneBattleReport, require("MessageCommon/Msg/L2C/BattleReport/OneBattleReport"));
end

--Ò»ÌõÕ½±¨
function BattleReportHandler:OneBattleReport(msg)
    local baseClass1 = UIService:Instance():GetUIClass(UIType.OperationUI);
    local isopen1 = UIService:Instance():GetOpenedUI(UIType.OperationUI);
    if baseClass1 ~= nil and isopen1 == true then
        UIService:Instance():HideUI(UIType.OperationUI);
        local reportinfo = BattleReportInfo.new();
        reportinfo._iD = msg.iD;
        reportinfo._battleType = msg.battleType;
        reportinfo._placeType = msg.placeType;
        reportinfo._tileIndex = msg.tileIndex;
        reportinfo._fightTime = msg.fightTime;
        reportinfo._aCardTableID = msg.aCardTableID;
        reportinfo._aCardLevel = msg.aCardLevel;
        reportinfo._dCardTableID = msg.dCardTableID;
        reportinfo._dCardLevel = msg.dCardLevel;
        reportinfo._aAdvanceStar = msg.aAdvanceStar;
        reportinfo._aPlayerName = msg.aPlayerName;
        reportinfo._aleagueName = msg.aleagueName;
        reportinfo._dPlayerName = msg.dPlayerName;
        reportinfo._dAdvanceStar = msg.dAdvanceStar;
        reportinfo._dleagueName = msg.dleagueName;
        reportinfo._aTroopNum = msg.aTroopNum;
        reportinfo._dTroopNum = msg.dTroopNum;
        reportinfo._resultType = msg.resultType;
        reportinfo._byteArryID = msg.byteArryID;
        reportinfo._isRead = msg.isRead;
        reportinfo._reportType = msg.reportType;
        reportinfo._drawTimes = msg.drawTimes;
        baseClass1:OpenBattleReportDetail(reportinfo);
    end
end

-- 战报list返回
function BattleReportHandler:HandleAllReport(msg)
    local infomsg = List.new();
    local count = msg.allBattleReport:Count();
    --print("战报list返回: "..count);
    for index = 1 ,count do 
        local modelList= msg.allBattleReport:Get(index);
        if(modelList ~=nil) then
            infomsg:Push(self:GetReportInfoList(modelList))
        end
    end
    self:AddReportList(infomsg);

    local baseClass = UIService:Instance():GetUIClass(UIType.UIBattleReport);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIBattleReport);
    if baseClass ~= nil and isOpen == true then
        baseClass:ShowReportList();
    end
end

function BattleReportHandler:AddReportList(reportList)
    self._logicManage:AddReportList(reportList)
end

function BattleReportHandler:GetReportInfoList(modelList)
    local infoList = BattleReportInfoList.new();
    local count = modelList.battleReportContinue:Count();
    --倒序取
    for index = 1 ,count do 
        local model = modelList.battleReportContinue:Get(count - index + 1);
        if(model ~= nil) then
            infoList._continueList:Push(self:GetReportInfo(model,index,count))
        end
    end
    return infoList;
end

function BattleReportHandler:GetReportInfo(model,index,count)
    local reportinfo = BattleReportInfo.new();
    reportinfo._iD = model.iD;
    reportinfo._battleType = model.battleType;
    reportinfo._placeType = model.placeType;
    reportinfo._tileIndex = model.tileIndex;
    reportinfo._fightTime = model.fightTime;
    reportinfo._aCardTableID = model.aCardTableID;
    reportinfo._aCardLevel = model.aCardLevel;
    reportinfo._dCardTableID = model.dCardTableID;
    reportinfo._dCardLevel = model.dCardLevel;
    reportinfo._aAdvanceStar = model.aAdvanceStar;
    reportinfo._aPlayerName = model.aPlayerName;
    reportinfo._aleagueName = model.aleagueName;
    reportinfo._dPlayerName = model.dPlayerName;
    reportinfo._dAdvanceStar = model.dAdvanceStar;
    reportinfo._dleagueName = model.dleagueName;
    reportinfo._aTroopNum = model.aTroopNum;
    reportinfo._dTroopNum = model.dTroopNum;
    reportinfo._resultType = model.resultType;
    reportinfo._byteArryID = model.byteArryID;
    reportinfo._isRead = model.isRead;
    reportinfo._reportType = model.reportType;
    reportinfo._drawTimes = model.drawTimes;
    if count > 1 then
        reportinfo._isContinueReport = true;
        reportinfo._continueReportCount = count - 1;
    else
        reportinfo._isContinueReport = false;    
    end
    reportinfo._continueIndex = index - 1;
    return reportinfo;
end

--Õ½±¨ÏêÇé
function BattleReportHandler:BattleReportMemblock(msg)
    local blockModel = BattleReportDetailModel.new();
    local receiveMessage = ByteArray.New();
    BattleReportService:Instance():SetLastClickID(msg.reportid);
    receiveMessage:InitBytes(msg.memblock:GetBytes());
    receiveMessage:Reset();
    blockModel:_OnDeserialize(receiveMessage)
    BattleReportService:Instance():TransModelToStruct(blockModel);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIBattleReport);
    if baseClass ~= nil then
        baseClass:ReponseOpenReportDetail();
    end
end

--Î´¶ÁÊýÁ¿
function BattleReportHandler:BattleReportUnReadCount(msg)
    self._logicManage:InitUnReadCount(msg.unReadCount)
end

return BattleReportHandler;