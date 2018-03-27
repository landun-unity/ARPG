local GamePart = require("FrameWork/Game/GamePart")
local List = require("common/List")
require("Game/BattleReport/OccupyType");
local BattleReportManage = class("BattleReportManage", GamePart)
local BattleReportType = require("Game/BattleReport/BattleReportType");
local BattleReportInfoList = require("Game/BattleReport/BattleReportInfoList")

-- ¹¹Ôìº¯Êý
function BattleReportManage:ctor( )
	BattleReportManage.super.ctor(self)
    self.AllReportList = List.new();
    self.AttacktList = List.new();
    self.DefenceList = List.new();
    self.AttackCityList = List.new();

    self.LastClickReportID = 0;
    self.LastReportIndex = 0;
    self.CurrentDetailInfo = nil;
    self.BattleReportDetail = {};
    self.CurrentGroup = 0;

    self.UnreadCount = 0;
end

function BattleReportManage:InitUnReadCount(count)
    self.UnreadCount = count;
end

function BattleReportManage:GetUnReadCount()
    return self.UnreadCount
end

function BattleReportManage:AddReportList(reportList)
    local count = reportList:Count();
    for index = 1,count do
        local reportinfo = reportList:Get(index)
        self:AddReportToTable(reportinfo);
    end
end

function BattleReportManage:AddReportToTable(info)
    if(info) then
        self.AllReportList:Push(info);
        if(info._continueList:Count()==0) then
            return;
        end
        local reportType = info._continueList:Get(1)._battleType;--Ö»»ñÈ¡µÚÒ»¸ö ¾ÍÖªµÀÊÇÊ²Ã´ÀàÐÍ
        if(reportType == BattleReportType.Attack) then
            self.AttacktList:Push(info);
        end
        if(reportType == BattleReportType.Defence) then
            self.DefenceList:Push(info);
        end
        if(reportType == BattleReportType.AttackCity) then
            self.AttackCityList:Push(info);
        end
    end
end

function BattleReportManage:GetAllReportListByType(reportType,openInfo)
    if reportType == BattleReportType.All then
        return self:GetAllOpenedReportListByType(self.AllReportList,openInfo);
    elseif reportType == BattleReportType.Attack then
        return self:GetAllOpenedReportListByType(self.AttacktList,openInfo);
    elseif reportType == BattleReportType.Defence then
        return self:GetAllOpenedReportListByType(self.DefenceList,openInfo);
    elseif reportType == BattleReportType.AttackCity then
        return self:GetAllOpenedReportListByType(self.AttackCityList,openInfo);
    end
    return nil;
end

--获取连续战报中未读个数
function BattleReportManage:GetConReprotUnreadCount(reportType,id)
    if reportType == BattleReportType.All then
        return self:GetAllConReprotUnreadCount(self.AllReportList,id);
    elseif reportType == BattleReportType.Attack then
        return self:GetAllConReprotUnreadCount(self.AttacktList,id);
    elseif reportType == BattleReportType.Defence then
        return self:GetAllConReprotUnreadCount(self.DefenceList,id);
    elseif reportType == BattleReportType.AttackCity then
        return self:GetAllConReprotUnreadCount(self.AttackCityList,id);
    end
    return 0;
end

function BattleReportManage:GetAllConReprotUnreadCount(reportList,id)
    local unReadCount = 0;
    if reportList == nil or reportList:Count() == 0 then
        return unReadCount;
    end
    for i = 1,reportList:Count() do
        local battleReportInfo = reportList:Get(i);
        local conCount = battleReportInfo._continueList:Count();
        for j = 1 ,conCount do
            local info = battleReportInfo._continueList:Get(j);
            if info ~= nil then
                if  info._iD == id and info._isContinueReport == true and info._isRead == false then
                    unReadCount = unReadCount + 1;
                end
            end
        end
    end
    return unReadCount;
end

--获取界面上要显示的战报列表
function BattleReportManage:GetAllOpenedReportListByType(reportList,openInfo)
    if reportList == nil or reportList:Count() == 0 then
        return nil;
    end
    local newList = List.new();
    for i = 1,reportList:Count() do
        local battleReportInfo = reportList:Get(i);
        local conCount = battleReportInfo._continueList:Count();
        for j = 1 ,conCount do
            local info = battleReportInfo._continueList:Get(j);
            if info ~= nil then
                if openInfo ~= nil and info._iD == openInfo._iD and info._isContinueReport == true then
                    info._isOpen = info._isOpen == false and true or false;
                end
                if info._continueIndex == 0  or (info._continueIndex ~= 0 and info._isOpen == true)  then
                    newList:Push(info);
                end
            end
        end
    end
    return newList;
end

--读取单条战报
function BattleReportManage:ReadOneReport(id,continueIndex)
    for i = 1,self.AllReportList:Count() do
        local battleReportInfo = self.AllReportList:Get(i);
        local conCount = battleReportInfo._continueList:Count();
        for j = 1 ,conCount do
            local info = battleReportInfo._continueList:Get(j);
            if info ~= nil then
                if info._iD == id and info._continueIndex == continueIndex then
                    info._isRead = true;
                end
            end
        end
    end
end

function BattleReportManage:GetReportListCountByType(reportType)
    if(reportType == BattleReportType.All) then
        return self.AllReportList:Count();
    end
    if(reportType == BattleReportType.Attack) then
        return self.AttacktList:Count();
    end
    if(reportType == BattleReportType.Defence) then
        return self.DefenceList:Count();
    end
    if(reportType == BattleReportType.AttackCity) then
        return self.AttackCityList:Count();
    end
    return 0;
end

function BattleReportManage:GetReportInfo(reportType,index)
    if(reportType == BattleReportType.All) then
        return self.AllReportList:Get(index);
    end
    if(reportType == BattleReportType.Attack) then
        return self.AttacktList:Get(index);
    end
    if(reportType == BattleReportType.Defence) then
        return self.DefenceList:Get(index);
    end
    if(reportType == BattleReportType.AttackCity) then
        return self.AttackCityList:Get(index);
    end
    return nil;
end

function BattleReportManage:SetLastClickID(LastID)
    self.LastClickReportID = LastID;
end

function BattleReportManage:GetLastClickID()
    return self.LastClickReportID;
end

function BattleReportManage:SetLastClickIndex(LastIndex)
    self.LastReportIndex = LastIndex;
end

function BattleReportManage:GetLastClickIndex()
    return self.LastReportIndex;
end

function BattleReportManage:SetBattleReportDetail(detailInfo)
    if(self.LastClickReportID>=0 and self.LastReportIndex>=0) then
        self.BattleReportDetail[self.LastClickReportID..""..self.LastReportIndex] = detailInfo;
    end
end

function BattleReportManage:GetBattleReportInfoById(id,index)
    return self.BattleReportDetail[id..""..index];
end

function BattleReportManage:ClearAllReport()
    self.AllReportList:Clear();
    self.AttacktList:Clear();
    self.DefenceList:Clear();
    self.AttackCityList:Clear();
    self.BattleReportDetail = {};
    self.LastClickReportID = -1;
    self.LastReportIndex = -1;
end

function BattleReportManage:SetCurrentDetailInfo(info)
    self.CurrentDetailInfo = info;
end

function BattleReportManage:GetCurrentDetailInfo()
    return self.CurrentDetailInfo;
end

function BattleReportManage:SetAllBattleReportRead()
    self:SetBattleReportListRead(self.AllReportList);
end

--¶ÔÓ¦Ä³¸öÁÐ±íÉèÎªÒÑ¶Á 
function BattleReportManage:SetBattleReportListRead(ReportList,ReportId)
    local count = ReportList:Count();
    for i = 1,count do
        local infoList = ReportList:Get(i)
        local infoCount = infoList._continueList:Count();
        for j = 1,infoCount do
            local info = infoList._continueList:Get(j);
            if(ReportId~=nil) then
                if(info._iD == ReportId) then
                    info._isRead = true;
                    return;
                end
            else
                info._isRead = true;
            end
        end
    end
end

function BattleReportManage:SetOneBattleReportRead(iD)
    self:SetBattleReportListRead(self.AllReportList,iD);
end

function BattleReportManage:SetGroup(group)
    self.CurrentGroup = group;
end

function BattleReportManage:GetGroup()
    return self.CurrentGroup;
end

function BattleReportManage:GetTiledName(tiledid, type, buildingID, name)
    -- local tiled = MapService:Instance():GetTiledByIndex(tiledid);
    -- local tiledInfo = MapService:Instance():GetDataTiled(tiled)
    local str = "";
    if(type == OccupyType.OccupyTown) then
        str = name.."-城区"
    elseif(type == OccupyType.OccupyBuilding) then
        local building = BuildingService:Instance():GetBuilding(buildingID)
        str = building._dataInfo.Name;
    elseif(type == OccupyType.OccupyWildTown) then
        local building = BuildingService:Instance():GetBuilding(buildingID)
        str = building._dataInfo.Name.."-城区"
    elseif(type == OccupyType.PlayerBuildingCenter) then
        str = name;
    else
        str = "土地 <color=#FFE384>Lv.".. buildingID .."</color>"
    end
    return str;
end

return BattleReportManage


