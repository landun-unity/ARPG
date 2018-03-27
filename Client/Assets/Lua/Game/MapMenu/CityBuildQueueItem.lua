--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local CityBuildQueueItem = class("CityBuildQueueItem",UIBase)
require("Game/Table/InitTable");
function CityBuildQueueItem:ctor()
    
   CityBuildQueueItem.super.ctor(self)

   self.nameText = nil;
   self.levelText = nil;
   self.slider = nil;
   self.timeText = nil;
   self.immediatelyCompleteBtn = nil;

   self.constructionName = nil;
   self.curBuildingId = 0;
   self.curBuilding = nil;
end


function CityBuildQueueItem:DoDataExchange()
    self.nameText = self:RegisterController(UnityEngine.UI.Text,"Name");
    self.levelText = self:RegisterController(UnityEngine.UI.Text,"Level");
    self.slider = self:RegisterController(UnityEngine.UI.Slider,"Slider");
    self.timeText = self:RegisterController(UnityEngine.UI.Text,"TimeText");    
    self.immediatelyCompleteBtn = self:RegisterController(UnityEngine.UI.Button,"ImmeditelyComplete");
end

function CityBuildQueueItem:DoEventAdd()
    self:AddListener(self.immediatelyCompleteBtn,self.OnClickImmediatelyCompleteBtn);
end


function CityBuildQueueItem:OnShow()
 
end

--facility: Facility
function CityBuildQueueItem:SetItemInfo(buildingId,facility)
--    if self.timer ~= nil then
--        self.timer:Stop();    
--    end
    self.curBuildingId = buildingId;
    self.curBuilding = BuildingService:Instance():GetBuilding(buildingId);
    local needTime = 0;
    local endTime =0;
    local curTimeStamp = PlayerService:Instance():GetLocalTime();

    if self.curBuilding._dataInfo.Type == BuildingType.PlayerFort or self.curBuilding._dataInfo.Type == BuildingType.WildFort then
        endTime = self.curBuilding._upgradeFortTime;
        if endTime == 0 then
            return;
        end
        self.constructionName =  self.curBuilding._name;
        self.nameText.text = self.curBuilding._name;
        self.levelText.text = "Lv."..self.curBuilding._fortGrade+1;
        if self.curBuilding._fortGrade == 1 then
            needTime = DataBuilding[40002].UpgradeCostTime;
        elseif self.curBuilding._fortGrade == 2 then
            needTime = DataBuilding[40003].UpgradeCostTime;
        elseif self.curBuilding._fortGrade == 3 then
            needTime = DataBuilding[40004].UpgradeCostTime
        elseif self.curBuilding._fortGrade == 4 then
            needTime = DataBuilding[40005].UpgradeCostTime
        end
        -- needTime = self.curBuilding._dataInfo.UpgradeCostTime;
        self:ShowTimes(needTime,endTime,curTimeStamp);
        return;
    end
    if facility == nil then
        return;
    end
    self.curFacility = facility;
    self.constructionName = DataConstruction[facility._tableId].Name;
    self.nameText.text = DataConstruction[facility._tableId].Name;
    self.levelText.text = "Lv."..facility._level+1;


    local mDataTable=DataConstruction[facility._tableId];
    if  facility._level+1 > mDataTable.MaxLevel then 
        needTime=0;
    else
        needTime =  mDataTable.UpgradeCostTime[facility._level+1];
    end 
    
    endTime = facility._nextUpgradeTime;
    self:ShowTimes(needTime,endTime,curTimeStamp);
end

function CityBuildQueueItem:ShowTimes(needTime,endTime,curTimeStamp)
    local valueTime = math.ceil(endTime - curTimeStamp);
    if valueTime <= 0 then
        valueTime = 0;
    end
    local cdTime = math.floor(valueTime / 1000)
    self.timeText.text = CommonService:Instance():GetDateString(cdTime);
    self.slider.value =(needTime - valueTime)/needTime;
    CommonService:Instance():TimeDown(UIType.UIMainCity, endTime,self.timeText,function() self:TimersEnds() end,self.slider,needTime);
end

function CityBuildQueueItem:TimersEnds()
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.UIMainCity);
    if baseClass ~= nil and isOpen == true then
        baseClass:RefreshBuildQueues();
    end
end

--立即完成
 function CityBuildQueueItem:OnClickImmediatelyCompleteBtn()
    local curHaveJade =  PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
    if curHaveJade >=20 then
        CommonService:Instance():ShowOkOrCancle(
            self,
            function()  self:CommonOk() end,
            function() self:CommonCancle() end,
            "确认",
            "是否花费<color=#FF0000>"..DataGameConfig[307].OfficialData.."</color>玉符立即完成<color=#FF0000>"..self.constructionName.."</color>的建造",
            "确认",
            "取消");
    else
        CommonService:Instance():ShowOkOrCancle(
            self,
            function()  self:GoRechargeOk() end,
            nil,
            "玉符宝石不足",
            "没有足够的宝石,请前往充值界面",
            "确认",
            "取消");
    end
end

function CityBuildQueueItem:GoRechargeOk()   
     UIService:Instance():HideUI(UIType.CommonOkOrCancle);
     UIService:Instance():ShowUI(UIType.RechargeUI);
end

function CityBuildQueueItem:CommonOk( ... )
    -- body
    if self.curBuilding ~= nil then
        if self.curBuilding._dataInfo.Type == BuildingType.PlayerFort or self.curBuilding._dataInfo.Type == BuildingType.WildFort then
            local msg = require("MessageCommon/Msg/C2L/Building/UpgradePromptlyPlayerFort").new();
            msg:SetMessageId(C2L_Building.UpgradePromptlyPlayerFort);
            msg.buildingId = self.curBuildingId;
            msg.tiledIndex = self.curBuilding._tiledId;
            NetService:Instance():SendMessage(msg);
        else
            local msg = require("MessageCommon/Msg/C2L/Facility/UpgradeImmediateRequest").new();
            msg:SetMessageId(C2L_Facility.UpgradeImmediateRequest);
            msg.buildingId = self.curBuildingId;
            msg.facilityId = self.curFacility._id;
            NetService:Instance():SendMessage(msg);
            UIService:Instance():HideUI(UIType.CommonOkOrCancle);
        end
    end
    
end

function CityBuildQueueItem:CommonCancle( ... )
    -- body
    UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end

return CityBuildQueueItem