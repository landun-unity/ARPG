--[[
    Name:城设施界面
--]]

local UIBase= require("Game/UI/UIBase")
local PlayerService = require("Game/Player/PlayerService")
--local BuildingService = require("Game/Build/BuildingService")
local CurrencyEnum = require("Game/Player/CurrencyEnum")
local DataConstruction = require("Game/Table/model/DataConstruction")
local FacilityService = require("Game/Facility/FacilityService")
local C2L_Facility = require("MessageCommon/Handler/C2L/C2L_Facility");
local UIFacilityCancel = class("UIFacility",UIBase)

--构造函数
function UIFacilityCancel:ctor()
	UIFacilityCancel.super.ctor(self);
    self.UIFacilityProperty = nil;
    self.confirmBtn = nil;
    self.backBtn = nil;
    self._type = nil;
    self._id = nil;
    self.buildingId = nil;
    self._backGroundBtn = nil;
end

--初始化界面
function UIFacilityCancel:OnInit()
end


function UIFacilityCancel:RegisterAllNotice()
    --self:RegisterNotice(L2C_Facility.OpenCityFacilityRespond, self.RefreshExp);
    self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.OnClickCancelFacility);
end

--注册控件
function UIFacilityCancel:DoDataExchange()
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"confirmBtn")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"backBtn")
    self._backGroundBtn = self:RegisterController(UnityEngine.UI.Button, "backGroundBtn");
end

--注册控件点击事件
function UIFacilityCancel:DoEventAdd()
   self:AddListener(self.backBtn, self.OnClickCancelFacility);
   self:AddListener(self._backGroundBtn, self.OnClickCancelFacility);
   self:AddListener(self.confirmBtn, self.OnClickConfirmFacility);
end

function UIFacilityCancel:OnClickConfirmFacility()
    local msg = require("MessageCommon/Msg/C2L/Facility/CancelUpgradeFacility").new();
    msg:SetMessageId(C2L_Facility.CancelUpgradeFacility);
    --print(self._id)
    msg.buildingId = self.buildingId;
    msg.facilityId = self._id;
    NetService:Instance():SendMessage(msg);
    --PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):ChangeValue("-"..self._facilitydata.UpgradeCostCommand[self._level]);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):ChangeValue(self._facilitydata.UpgradeCostWood[self._level] * 0.8);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):ChangeValue(self._facilitydata.UpgradeCostIron[self._level] * 0.8);
    -- PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):ChangeValue(self._facilitydata.UpgradeCostStone[self._level] * 0.8);
    -- self.UIFacilityProperty:Refresh();
    --UIService:Instance():HideUI(UIType.UIFacilityCancel);
end

function UIFacilityCancel:OnClickCancelFacility()
    UIService:Instance():HideUI(UIType.UIFacilityCancel);

end

function UIFacilityCancel:OnShow(param)
    self._type = param.type;
    self.buildingId = param.id;
    self._facility = FacilityService:Instance():GetFacility(self.buildingId, self._type);
    self._id = self._facility:GetId();
    --self.UIFacilityProperty = UIFacilityProperty;
end

return UIFacilityCancel;