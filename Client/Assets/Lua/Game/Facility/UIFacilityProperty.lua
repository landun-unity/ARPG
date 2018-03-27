--[[
    Name:城设施介绍界面
--]]

local UIBase= require("Game/UI/UIBase")
local FacilityService = require("Game/Facility/FacilityService")
local DataGameConfig = require("Game/Table/model/DataGameConfig")
local Data = require("Game/Table/model/DataConstruction")
local PlayerService = require("Game/Player/PlayerService")
require("Game/Facility/FacilityProperty")
local CurrencyEnum = require("Game/Player/CurrencyEnum")
local C2L_Facility = require("MessageCommon/Handler/C2L/C2L_Facility");
local UIFacilityProperty = class("UIFacilityProperty",UIBase)

--构造函数
function UIFacilityProperty:ctor()
	UIFacilityProperty.super.ctor(self);

    self._type = 0;
    self._level = 0;
    self._facilitydata = nil;
    self._tableId = nil;
    self._facility = nil;
	
    self._closeBtn = nil;
    self._backGroundBtn = nil;

    self._buildingTimeText = nil;

    self._buildingIntroduce = nil;


    self._buildingDemand = nil;

    self._buildingConfirm = nil;
    self._buildingConfirmText = nil;

    self._buildingLock = nil;
    self._buildingLockImage = nil;
    self._buildingLockText = nil;

    self._buildingDemandText = nil;
    self._buildingDemandWood = nil;
    self._buildingDemandIron = nil;
    self._buildingDemandStone = nil;
     
    self._buildingDecree = nil;
    self._buildingCancel = nil;
    self._buildingDecreeFirst = nil;
    self._buildingDecreeLast = nil;
    self._buildingMoney = nil;
    self._buildingMoneyText = nil;
    self._buildingComplete = nil;

    self._textGrid = nil;
    self._buildingPlus = nil;
    self._buildingPlusText = nil;
    self._buildingPlusFirst = nil;
    self._buildingPlusImage = nil;
    self._buildingPlusLast = nil;
    
    self._buildingPlusOne = nil;
    self._buildingPlusOneText = nil;
    self._buildingPlusOneFirst = nil;
    self._buildingPlusOneImage = nil;
    self._buildingPlusOneLast = nil;

    self._buildingEffect = nil;
    self._buildingEffectText = nil;
    self._buildingEffectPanel = nil;

    self._buildingImage = nil;
    self._facilityback = nil;
    self._facilityimage = nil;
    self._levelimage = nil;
    self._facilitylevel = nil;
    self._facilityname = nil;
    self._max = nil;
    self._building = nil;
    self._imagepanel = nil;
    self._time = nil;
    self._facilitypanel = nil;

    self.buildingId = nil;

    self.marchTimer = nil;

    -- 放弃分城相关
    self._removeSubCityBtn = nil;
    self._removeCityTips = nil;
    self._cancelRemoveBtn = nil;
end

--注册控件
function UIFacilityProperty:DoDataExchange()
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button,"backGround/closeBtn");
    self._backGroundBtn = self:RegisterController(UnityEngine.UI.Button,"backGroundBtn");

	self._buildingIntroduce = self:RegisterController(UnityEngine.UI.Text,"BuildingIntroduce");


    self._buildingDemand = self:RegisterController(UnityEngine.Transform,"BuildingDemand");

    self._buildingConfirm = self:RegisterController(UnityEngine.UI.Button,"BuildingDemand/BuildingConfirm");
    self._buildingConfirmText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/BuildingConfirm/Text");

    self._buildingLock = self:RegisterController(UnityEngine.Transform,"BuildingLock");
    self._buildingLockImage = self:RegisterController(UnityEngine.UI.Image,"BuildingLock/BuildingLockImage")
    self._buildingLockText = self:RegisterController(UnityEngine.UI.Text,"BuildingLock/BuildingLockText");

    self._buildingDemandText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemand/BuildingText");
    self._buildingTimeText = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/BuildingTimeText")
    self._buildingDemandWood = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemandWood/BuildingText");
    self._buildingDemandIron = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemandIron/BuildingText");
    self._buildingDemandStone = self:RegisterController(UnityEngine.UI.Text,"BuildingDemand/Grid/BuildingDemandStone/BuildingText");
     
    self._buildingDecree = self:RegisterController(UnityEngine.Transform,"BuildingDecree");
    self._buildingCancel = self:RegisterController(UnityEngine.UI.Button,"BuildingDecree/BuildingCancel");
    self._buildingDecreeFirst = self:RegisterController(UnityEngine.UI.Text,"BuildingDecree/BuildingDecreeFirst");
    self._buildingDecreeLast = self:RegisterController(UnityEngine.UI.Text,"BuildingDecree/BuildingDecreeLast");
    self._buildingMoney = self:RegisterController(UnityEngine.Transform,"BuildingDecree/BuildingMoney");
    self._buildingMoneyText = self:RegisterController(UnityEngine.UI.Text,"BuildingDecree/BuildingMoney/BuildingMoneyText");
    self._buildingComplete = self:RegisterController(UnityEngine.UI.Button,"BuildingDecree/BuildingMoney/BuildingComplete");

    self._textGrid = self:RegisterController(UnityEngine.Transform,"TextGrid");
    self._buildingPlus = self:RegisterController(UnityEngine.Transform,"TextGrid/BuildingPlus");
    self._buildingPlusText = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusText");
    self._buildingPlusFirst = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusFirst");
    self._buildingPlusImage = self:RegisterController(UnityEngine.Transform,"TextGrid/BuildingPlus/BuildingPlusImage");
    self._buildingPlusLast = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlus/BuildingPlusLast");
    
    self._buildingPlusOne = self:RegisterController(UnityEngine.Transform,"TextGrid/BuildingPlusOne");
    self._buildingPlusOneText = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneText");
    self._buildingPlusOneFirst = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneFirst");
    self._buildingPlusOneImage = self:RegisterController(UnityEngine.Transform,"TextGrid/BuildingPlusOne/BuildingPlusOneImage");
    self._buildingPlusOneLast = self:RegisterController(UnityEngine.UI.Text,"TextGrid/BuildingPlusOne/BuildingPlusOneLast");

    self._buildingEffect = self:RegisterController(UnityEngine.Transform,"BuildingEffect");
    self._buildingEffectText = self:RegisterController(UnityEngine.UI.Text,"BuildingEffect/BuildingEffectText");
    self._buildingEffectPanel = self:RegisterController(UnityEngine.UI.Image,"BuildingEffect/BuildingEffectPanel");

    self._buildingImage = self:RegisterController(UnityEngine.Transform,"BuildingImage");
    self._facilityback = self:RegisterController(UnityEngine.UI.Image,"BuildingImage/FacilityItem/facilityback");
    self._facilityimage = self:RegisterController(UnityEngine.UI.Button, "BuildingImage/FacilityItem/facilityimage");
    self._levelimage = self:RegisterController(UnityEngine.UI.Image, "BuildingImage/FacilityItem/levelimage");
    self._facilitylevel = self:RegisterController(UnityEngine.UI.Text, "BuildingImage/FacilityItem/facilitylevel");
    self._facilityname = self:RegisterController(UnityEngine.UI.Text, "BuildingImage/FacilityItem/facilityname");
    self._max = self:RegisterController(UnityEngine.UI.Image, "BuildingImage/FacilityItem/max");
    self._building = self:RegisterController(UnityEngine.UI.Image, "BuildingImage/FacilityItem/building");
    self._imagepanel = self:RegisterController(UnityEngine.UI.Image, "BuildingImage/FacilityItem/imagepanel");
    self._time = self:RegisterController(UnityEngine.UI.Text, "BuildingImage/FacilityItem/time");
    self._facilitypanel = self:RegisterController(UnityEngine.UI.Image, "BuildingImage/FacilityItem/facilitypanel");
    
    self._removeSubCityBtn = self:RegisterController(UnityEngine.UI.Button,"BuildingImage/FacilityItem/RemoveButton");
    self._removeCityTips = self:RegisterController(UnityEngine.Transform,"removeTips");
    self._cancelRemoveBtn = self:RegisterController(UnityEngine.UI.Button,"removeTips/cancelRemoveBtn");
end

--初始化界面
function UIFacilityProperty:OnInit()
end

function UIFacilityProperty:RegisterAllNotice()
    self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.Refresh);
    self:RegisterNotice(L2C_Player.SyncBuildingInfo, self.RefreshDeleteSubCityShow);
end

--注册控件点击事件
function UIFacilityProperty:DoEventAdd()
   self:AddListener(self._closeBtn, self.OnClickCloseUpgradeFacility)
   self:AddListener(self._buildingConfirm, self.OnClickUpgradeFacility);
   self:AddListener(self._buildingCancel, self.OnClickCancelFacility);
   self:AddListener(self._buildingComplete, self.OnClickCompleteFacility);
   self:AddListener(self._backGroundBtn, self.OnClickCloseUpgradeFacility);
   self:AddListener(self._removeSubCityBtn, self.OnClickRemoveSubCityBtn);
   self:AddListener(self._cancelRemoveBtn, self.CancelRemoveSubCity);
end

-- 拆除分城按钮点击
function UIFacilityProperty:OnClickRemoveSubCityBtn()
    local param = { };
    param[1] = "<color=#FFFFFFFF>是否确认放弃城市?</color>"
    param[2] = "<color=#6EAF47FF>成功放弃后,将失去城市所有功能,本城所有部队强制解散</color>"
    param[3] = true
    param[4] = true
    param[6] = "确认"
    -- param[4] = true;
    UIService:Instance():ShowUI(UIType.MessageBox, param);
    MessageBox:Instance():RegisterOk( function()
        self:RemoveSubCityConfirm();
    end );
end

-- 拆除分城确认
function UIFacilityProperty:RemoveSubCityConfirm()
    local building = BuildingService:Instance():GetBuilding(self.buildingId);
    if building == nil then
        return;
    end
    local msg = require("MessageCommon/Msg/C2L/Building/RemoveSubCity").new();
    msg:SetMessageId(C2L_Building.RemoveSubCity);
    msg.buildingId = self.buildingId;
    NetService:Instance():SendMessage(msg);
end

-- 取消放弃分城
function UIFacilityProperty:CancelRemoveSubCity()
    local msg = require("MessageCommon/Msg/C2L/Building/CancelRemoveSubCityRequest").new();
    msg:SetMessageId(C2L_Building.CancelRemoveSubCityRequest);
    msg.buildingID = self.buildingId;
    NetService:Instance():SendMessage(msg);
end

function UIFacilityProperty:OnClickCloseUpgradeFacility()
    if self.marchTimer ~= nil then
        self.marchTimer:Stop();
        self.marchTimer = nil;
    end
     UIService:Instance():HideUI(UIType.UIFacilityProperty);
end

--升级
function UIFacilityProperty:OnClickUpgradeFacility()
    if  self:CheckConsBaseQueue(self.buildingId) == false then
        self:SendConUpgradeMessage();
    else
        if self:CheckConsTempQueue(self.buildingId) == false then
            local tempCount = self:GetConsTempQueueCount(self.buildingId);
            ------print(tempCount);
            local multipleCount = math.pow(DataGameConfig[317].OfficialData,tempCount+1);
            local shouldCostMoney = DataGameConfig[316].OfficialData * multipleCount;
            local haveMoney =  PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
            ------print(shouldCostMoney.."    "..haveMoney);
            if haveMoney < shouldCostMoney then
                UIService:Instance():ShowUI(UIType.UICueMessageBox,1);
                return;
            else
                local paramT = { };
                paramT[1] = "是否花费<color=#FF0000>"..shouldCostMoney.."</color>铜币增加一个临时建造队列？";
                paramT[4] = true;
                UIService:Instance():ShowUI(UIType.MessageBox, paramT);
                MessageBox:Instance():RegisterOk( function()
                    self:SendConUpgradeMessage();
                end );
            end
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox,401);
            return;
        end
    end
end

function UIFacilityProperty:SendConUpgradeMessage()
    local msg = require("MessageCommon/Msg/C2L/Facility/UpgradeFacilityRequest").new();
    msg:SetMessageId(C2L_Facility.UpgradeFacilityRequest);
    msg.buildingId = self.buildingId;
    msg.facilityId = FacilityService:Instance():GetFacilityByTableId(self.buildingId, self._tableId)._id;
    NetService:Instance():SendMessage(msg);
    self:SetUpBtnClicked(false);
end

--获取该城市的临时建造队列数量
function UIFacilityProperty:GetConsTempQueueCount(buildingId)  
    local building = BuildingService:Instance():GetBuilding(buildingId);
    if building ~= nil then 
        local tempList = building:GetTempConstructionQueue();
        return tempList:Count();
    else
        return 0;
    end
end

--检测该城市的基础建造队列是否达到上限
function UIFacilityProperty:CheckConsBaseQueue(buildingId)    
    local building = BuildingService:Instance():GetBuilding(buildingId);
    if building ~= nil then         
        local baseList = building:GetBaseConstructionQueue();
        if baseList~= nil then 
            local baseCount = baseList:Count();
            local baseMax = building:GetPlayerBaseConsMax();
            ----print("baseMax:"..baseMax)
            if baseCount >= baseMax then 
                return true;
            else
                return false;
            end
        else
            return false;
        end
    else
        return false;
    end
end

--检测该城市的临时建造队列是否达到上限
function UIFacilityProperty:CheckConsTempQueue(buildingId)    
    local building = BuildingService:Instance():GetBuilding(buildingId);
    if building ~= nil then 
        local tempList = building:GetTempConstructionQueue();
        if tempList~= nil then 
            local tempCount = tempList:Count();
            local tempMax = building:GetPlayerTempConsMax();
            ----print("tempMax:"..tempMax)
            if tempCount >= tempMax then 
                return true;
            else
                return false;
            end
        else
            return false;
        end
    else
        return false;
    end
end

--设置升级按钮是否可以点击（防止快速连续点击产生bug）
function UIFacilityProperty:SetUpBtnClicked(couldClick)
    self._buildingConfirm.interactable = couldClick;
end

--设置立即升级按钮是否可以点击（防止快速连续点击产生bug）
function UIFacilityProperty:SetImmediatelyUpBtnClicked(couldClick)
    self._buildingConfirm.interactable = couldClick;
    self._buildingComplete.interactable = couldClick;
end

function UIFacilityProperty:GoRechargeOk()   
     UIService:Instance():HideUI(UIType.CommonOkOrCancle);
     UIService:Instance():ShowUI(UIType.RechargeUI);
end

--立即升级
function UIFacilityProperty:OnClickCompleteFacility()
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue()<20 then
        CommonService:Instance():ShowOkOrCancle(
            self,
            function()  self:GoRechargeOk() end,
            nil,
            "玉符宝石不足",
            "没有足够的宝石,请前往充值界面",
            "确认",
            "取消");
    else
        local msg = require("MessageCommon/Msg/C2L/Facility/UpgradeImmediateRequest").new();
        msg:SetMessageId(C2L_Facility.UpgradeImmediateRequest);
        msg.buildingId = self.buildingId;
        msg.facilityId = FacilityService:Instance():GetFacilityByTableId(self.buildingId, self._tableId)._id;
        NetService:Instance():SendMessage(msg);
        self:SetImmediatelyUpBtnClicked(false);
    end
end

--取消
function UIFacilityProperty:OnClickCancelFacility()
    local param = {};
    param.type = self._type;
    param.id = self.buildingId;
    UIService:Instance():ShowUI(UIType.UIFacilityCancel, param);
end

function UIFacilityProperty:OnShow(param)
    self._type = param.type;
    self.buildingId = param.id;
    self:Refresh();
end

-- 刷新分城拆除中
function UIFacilityProperty:RefreshDeleteSubCityShow()
    local building = BuildingService:Instance():GetBuilding(self.buildingId);
    if building == nil then
        return;
    end
    if building._dataInfo.Type ~= BuildingType.SubCity then
        return;
    end
    self:Refresh();
end

--刷新
function UIFacilityProperty:Refresh()
    ------print("刷新")
    self._facility = FacilityService:Instance():GetFacility(self.buildingId, self._type);
    if self._facility == nil then 
        return;
    end
    self._level = self._facility:GetLevel();
    self._tableId = self._facility:GetTableId();
    self._facilitydata = Data[self._tableId];
    
    self._buildingIntroduce.text =  self._facilitydata.ConstructionExplain;
   -- ----print(self._level)
    if self._level == self._facilitydata.MaxLevel then
        
    else
        self._buildingDemand.gameObject:SetActive(true);
        self._buildingTimeText.gameObject:SetActive(true);
        if self._facilitydata.UpgradeCostTime[self._level + 1] / 1000 == nil then
            ------print("设施表无数据")
        else         
            self._buildingTimeText.text =" <color=#e2bd75>".."需要时间".."</color>".." <color=#FFFFFFFF>"..self:TimeFormat(self._facilitydata.UpgradeCostTime[self._level + 1] / 1000).."</color>";
        end
    end
    self:_Property();
    self:_Building();
    if self._facility:GetBuildingTime() / 1000 > PlayerService:Instance():GetLocalTime() / 1000 then
        ------print(self._level.."时间"..(self._facility:GetBuildingTime() / 1000) - PlayerService:Instance():GetLocalTime() / 1000);
      self:_LoadBuildingItem(((self._facility:GetBuildingTime() / 1000) - PlayerService:Instance():GetLocalTime() / 1000));
    else
      self:_LoadBuildingItem(0);
    end
    
    -- 拆除分城相关
    local building = BuildingService:Instance():GetBuilding(self.buildingId);
    if building ~= nil then
        if building._subCityDeleteTime ~= 0 and self._facilitydata.ID == 2 then
            if self._removeSubCityBtn.gameObject.activeSelf == true then
                self._removeSubCityBtn.gameObject:SetActive(false);
            end
            if self._removeCityTips.gameObject.activeSelf == false then
                self._removeCityTips.gameObject:SetActive(true);
            end
            if self._buildingLock.gameObject.activeSelf == true then
                self._buildingLock.gameObject:SetActive(false);
            end
            if self._buildingMoney.gameObject.activeSelf == true then
                self._buildingMoney.gameObject:SetActive(false);
            end
            if self._buildingConfirm.gameObject.activeSelf == true then
                self._buildingConfirm.gameObject:SetActive(false);
            end
            if self._buildingTimeText.gameObject.activeSelf == true then
                self._buildingTimeText.gameObject:SetActive(false);
            end
        else
            if self._facilitydata.ID == 2 then
                if self._removeSubCityBtn.gameObject.activeSelf == false then
                    self._removeSubCityBtn.gameObject:SetActive(true);
                end
            else
                if self._removeSubCityBtn.gameObject.activeSelf == true then
                    self._removeSubCityBtn.gameObject:SetActive(false);
                end
            end
            if self._removeCityTips.gameObject.activeSelf == true then
                self._removeCityTips.gameObject:SetActive(false);
            end
            if self._buildingMoney.gameObject.activeSelf == false then
                self._buildingMoney.gameObject:SetActive(true);
            end
        end
    end
end

function UIFacilityProperty:TimeFormat(mTime)
    local time = math.ceil(mTime);
    local h = math.floor(time / 3600);
    local m = math.floor(math.floor(time % 3600) / 60);
    local s = math.ceil(math.ceil(time % 3600) % 60);
    local timeText = string.format("%02d:%02d:%02d",h, m, s);
    return timeText;
end

function UIFacilityProperty:_ShowFacilityPanel(name)
  if name == 1 then
    self._facilitypanel.gameObject:SetActive(false);
    return;
  end
  self._facilitypanel.gameObject:SetActive(true);
  local bgimage = string.format("%s%02d", "backgroundlight", name);
  self._facilitypanel.sprite = GameResFactory.Instance():GetResSprite(bgimage);
end

function UIFacilityProperty:_ShowFacilityLevelImage(name)
  local bgimage = string.format("%s%s", "levelnagive", name);
  self._levelimage.sprite = GameResFactory.Instance():GetResSprite(bgimage);
end

function UIFacilityProperty:_ShowFacilityBack(name)
   local bgimage = string.format("%s_%02d", "citybackground", name);
   self._facilityback.sprite = GameResFactory.Instance():GetResSprite(bgimage);
end

function UIFacilityProperty:_ShowFacilityImage(name)
   self._facilityimage.image.sprite = GameResFactory.Instance():GetResSprite(name);
end

function UIFacilityProperty:_LoadBuildingItem(time)
    self._facilitypanel.gameObject:SetActive(false);
    --local bgimage = string.format("%s_%02d", "citybackground", self._facilitydata.ConstructionType);
    --self._facilityback.sprite = GameResFactory.Instance():GetResSprite(bgimage);
    --self._facilityimage.image.sprite = GameResFactory.Instance():GetResSprite(self._facilitydata.ConstructionPicture);
    --self._levelimage = level.."/"..Facilitydata[MaxLevel];
    --self._facilitylevel.text = self._level.."<color=#e2bd75>".."/"..self._facilitydata.MaxLevel.."</color>";
    self._facilityname.text = self._facilitydata.Name;
    self:_imageLock();
    if self._level == 0 then
        self._max.gameObject:SetActive(false);
        if time == 0  then
        self:_HideBuildingTime();
        self._building.gameObject:SetActive(false);
        self._buildingConfirmText.text = "建造";
        else
        self:_ShowBuildingTime(time, self._facilitydata.UpgradeCostTime[self._level + 1]);
        --self._building.sprite = GameResFactory.Instance():GetResSprite("MianCityBUilding");
        self._building.gameObject:SetActive(true);
        end
    else 
        --self:_imageUpgradeLock();
        if self._level == self._facilitydata.MaxLevel then
            self:_ShowFacilityPanel(self._facilitydata.ConstructionType);
            if self._facilitydata.MaxLevelEffectExplain == nil or self._facilitydata.MaxLevelEffectExplain == "无" then
                 self._max.gameObject:SetActive(false);
            else
                 self._max.gameObject:SetActive(true);
            end
            self._buildingConfirm.gameObject:SetActive(false);
            self._buildingTimeText.gameObject:SetActive(false);
            self._buildingLock.gameObject:SetActive(true);
            self._buildingLockImage.gameObject:SetActive(false);
            self._buildingLockText.text = "--  已经达到最高级  --";
        else
            self._facilitypanel.gameObject:SetActive(false);
            self._buildingConfirmText.text = "升级";
            self._max.gameObject:SetActive(false);
        --      self._buildingConfirm.gameObject:SetActive(true);
        end

        --self._facilitypanel.gameObject:SetActive(false);
        if time == 0  then
        self:_HideBuildingTime();
        self._building.gameObject:SetActive(false);
        else
        self:_ShowBuildingTime(time, self._facilitydata.UpgradeCostTime[self._level + 1]);
        --self._building.sprite = GameResFactory.Instance():GetResSprite("MianCityUpgrade");
        self._building.gameObject:SetActive(true);
        end
    end
end

--倒计时
function UIFacilityProperty:Time(time, timeMax)
    if time == 0 then
       if self.marchTimer ~= nil then
            self.marchTimer:Stop();
            self.marchTimer = nil;
        end
        self:_Complete();
    else
        if self.marchTimer == nil then
            self:_CountDown(time, 1);
            self.marchTimer = Timer.New(function()
            time = time > 0 and time - 1 or 0
            self:_CountDown(time, timeMax);
            if time == 0 then
                   self:_Complete();
                   self.marchTimer:Stop();
            end
            end, 1, -1, false)
            self.marchTimer:Start();
        else

        end
    end
end

function UIFacilityProperty:_CountDown(time, timeMax)
    self._time.text = self:TimeFormat(time);
    self._imagepanel.fillAmount = time / timeMax;
end

function UIFacilityProperty:_Complete()
    self._imagepanel.fillAmount = 0;
    self._time.text = "";
    self._imagepanel.gameObject:SetActive(false);
    self._time.gameObject:SetActive(false);
end

function UIFacilityProperty:_ShowBuildingTime(time, timeMax)
    CommonService:Instance():TimeDown(UIType.UIFacilityProperty, self._facility:GetBuildingTime(), self._time, 
    function() self:_Complete(); end, nil, timeMax, self._imagepanel);
    --self:Time(time, timeMax);
    self._imagepanel.gameObject:SetActive(true);
    self._time.gameObject:SetActive(true);
end

function UIFacilityProperty:_HideBuildingTime()
    self:_Complete();
    CommonService:Instance():RemoveTimeDownInfo(self._time.transform.gameObject);
    --self:Time(0, timeMax);
end

-- function UIFacilityProperty:_imageUpgradeLock()
--     self._facilitypanel.gameObject:SetActive(true);
--     local facility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, self._facilitydata.UpgradeCondition);
--     local level = facility:GetLevel();
--     if self._facility:GetLevel() + 1 <= self._facilitydata.MaxLevel and level < self._facilitydata.UpgradeParameter[self._facility:GetLevel() + 1] then
--          self._facilitypanel.color = Color.New(0,0,0,0.7);
--          return;
--     end
--     self._facilitypanel.color = Color.New(0,0,0,0);
-- end

function UIFacilityProperty:_imageLock()
     local locked = 0;
     --self._facilitypanel.gameObject:SetActive(true);
     --self._facilitypanel.color = Color.New(0,0,0,0.3);
     for i,v in ipairs(self._facilitydata.PreconditionName) do
        local facility =  FacilityService:Instance():GetFacilityByTableId(self.buildingId, v);
        local prolevel = facility:GetLevel();
        if prolevel < self._facilitydata.Precondition[i] then
             locked = locked + 1;
        else
        end
     end 
   if locked > 0 then
        self:_ShowFacilityImage(self._facilitydata.ConstructionPicture.."gray");
        --self._facilitypanel.color = Color.New(0,0,0,0.7);
        self:_ShowFacilityBack(5);
        self:_ShowFacilityLevelImage("gray");
        self._facilitylevel.text = "<color=#7f7f7f>"..self._level.."/"..self._facilitydata.MaxLevel.."</color>";
        --self._facilityname.text = self._facilitydata.Name;
   else
      --self._facilityname.text = "<color=#e2bd75>"..self._facilitydata.Name.."</color>";
      self:_ShowFacilityLevelImage("");
      self._facilitylevel.text = self._level.."<color=#e2bd75>".."/"..self._facilitydata.MaxLevel.."</color>";
      if self._facility:GetLevel() == 0 then
        self:_ShowFacilityBack(4);
        self:_ShowFacilityImage(self._facilitydata.ConstructionPicture.."gray");
      else
        self:_ShowFacilityImage(self._facilitydata.ConstructionPicture);
        self:_ShowFacilityBack(self._facilitydata.ConstructionType);
      end
   end
end

function UIFacilityProperty:_Lock()
     local locked = 0;
     local lockText = "";
     --local m_lockText = "";
     --local m_lockLevelText = "";
     for i,v in ipairs(self._facilitydata.PreconditionName) do
        local facility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, v);
        local prolevel = facility:GetLevel();
        if prolevel < self._facilitydata.Precondition[i] then
             lockText = lockText..Data[facility:GetTableId()].Name.." Lv"..self._facilitydata.Precondition[i].."  ";
             --m_lockText = m_lockText..Data[facility:GetTableId()].Name;
             --m_lockLevelText = m_lockLevelText.."Lv"..self._facilitydata.Precondition[i];
             locked = locked + 1;
        else
        end
     end 
     if locked > 0 then
        self._buildingConfirm.gameObject:SetActive(false);
        self._buildingLock.gameObject:SetActive(true);
        self._buildingLockImage.gameObject:SetActive(true);
        self._buildingLockText.text = "建造条件："..lockText;
        self._buildingLockImage:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = self:_LockImageTransform(self._buildingLockImage, self._buildingLockText);
     else
        if self:_UpgradeLock() then
            return;
        end
        self._buildingConfirm.gameObject:SetActive(true);
        self._buildingLock.gameObject:SetActive(false);
     end
end

function UIFacilityProperty:_UpgradeLock()
    local lockText = "";
    local facility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, self._facilitydata.UpgradeCondition);
    local level = facility:GetLevel();
    if self._facility:GetLevel() + 1 <= self._facilitydata.MaxLevel and level < self._facilitydata.UpgradeParameter[self._facility:GetLevel() + 1] then
        lockText = lockText..Data[facility:GetTableId()].Name.." Lv"..self._facilitydata.UpgradeParameter[self._facility:GetLevel() + 1];
        self._buildingConfirm.gameObject:SetActive(false);
        self._buildingLock.gameObject:SetActive(true);
        self._buildingLockImage.gameObject:SetActive(true);
        self._buildingLockText.text = "升级条件："..lockText;
        self._buildingLockImage:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = self:_LockImageTransform(self._buildingLockImage, self._buildingLockText);
         return true;
    end
    return false;
end

--计算解锁image位置
function UIFacilityProperty:_LockImageTransform(image, locktext)
    local width = locktext.preferredWidth / 2;
    local imageWidth = image:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
    return Vector3.New(-(width + imageWidth), self._buildingLockImage:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.y, 0);
end

--属性介绍
function UIFacilityProperty:_Property()
    if self._facilitydata.MaxLevelEffectExplain == nil or self._facilitydata.MaxLevelEffectExplain == "无" then

         self._textGrid:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = Vector3.New(146.37, 5, 0);
         self._buildingEffect.gameObject:SetActive(false);
    else
         self._textGrid:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = Vector3.New(146.37, 49.5, 0);
         self._buildingEffect.gameObject:SetActive(true);
         self._buildingEffectText.text = self._facilitydata.MaxLevelEffectExplain;
         if self._level == self._facilitydata.MaxLevel then
            self._buildingEffectPanel.color = Color.New(0,0,0,0);
         else
            self._buildingEffectPanel.color = Color.New(0,0,0,0.5);
         end
    end
    self:_PropertyPlus();
end

function UIFacilityProperty:_PropertyPlus()
    if self._level == self._facilitydata.MaxLevel then 
        for m,n in ipairs(self._facilitydata.ConstructionFunctionType) do
            local FunctionParameter = "ConstructionFunctionParameter"..m;
            if m == 3 then
            end
            if m == 1 then
                self._buildingPlusOne.gameObject:SetActive(false);
                self._buildingPlus.gameObject:SetActive(true);
                self._buildingPlusText.text = self._facilitydata.ConstructionFunctionExplain[m];
                self._buildingPlusFirst.text = self:NumberProcessing(FunctionParameter, self._level, n);
                self._buildingPlusLast.text = "--";
                -- self._buildingPlusLast.gameObject:SetActive(false);
                -- self._buildingPlusImage.gameObject:SetActive(false);
            end
            if m == 2 then
                if self._facilitydata[FunctionParameter][self._level] ~= self._facilitydata[FunctionParameter][self._level + 1] and n ~= FacilityProperty.BuildCount then
                self._buildingPlusOne.gameObject:SetActive(true);
                self._buildingPlusOneText.text = self._facilitydata.ConstructionFunctionExplain[m];
                self._buildingPlusOneFirst.text = self:NumberProcessing(FunctionParameter, self._level, n);
                self._buildingPlusOneLast.text = "--";
                end
            end
        end
    elseif self._level == 0 then
        for m,n in ipairs(self._facilitydata.ConstructionFunctionType) do
            local FunctionParameter = "ConstructionFunctionParameter"..m;
            if m == 3 then
            end
            if m == 1 then
                self._buildingPlusOne.gameObject:SetActive(false);
                self._buildingPlus.gameObject:SetActive(true);
                self._buildingPlusText.text = self._facilitydata.ConstructionFunctionExplain[m];
                self._buildingPlusFirst.text =  "--";
                self._buildingPlusLast.text = self:NumberProcessing(FunctionParameter, self._level + 1, n);
            end
            if m == 2 then
                if self._facilitydata[FunctionParameter][self._level] ~= self._facilitydata[FunctionParameter][self._level + 1] and n ~= FacilityProperty.BuildCount then
                self._buildingPlusOne.gameObject:SetActive(true);
                self._buildingPlusOneText.text = self._facilitydata.ConstructionFunctionExplain[m];
                self._buildingPlusOneFirst.text = "--";
                self._buildingPlusOneLast.text = self:NumberProcessing(FunctionParameter, self._level + 1, n);
                end
            end
        end
    else
        for m,n in ipairs(self._facilitydata.ConstructionFunctionType) do
            local FunctionParameter = "ConstructionFunctionParameter"..m;
            if m == 3 then
            end
            if m == 1 then
                self._buildingPlusOne.gameObject:SetActive(false);
                self._buildingPlus.gameObject:SetActive(true);
                self._buildingPlusText.text = self._facilitydata.ConstructionFunctionExplain[m];
                self._buildingPlusFirst.text = self:NumberProcessing(FunctionParameter, self._level, n);
                self._buildingPlusLast.text = self:NumberProcessing(FunctionParameter, self._level + 1, n);
            end
            if m == 2 then
                if self._facilitydata[FunctionParameter][self._level] ~= self._facilitydata[FunctionParameter][self._level + 1] and n ~= FacilityProperty.BuildCount then
                self._buildingPlusOne.gameObject:SetActive(true);
                self._buildingPlusOneText.text = self._facilitydata.ConstructionFunctionExplain[m];
                self._buildingPlusOneFirst.text = self:NumberProcessing(FunctionParameter, self._level, n);
                self._buildingPlusOneLast.text = self:NumberProcessing(FunctionParameter, self._level + 1, n);
                end
            end
        end
    end
end

function UIFacilityProperty:NumberProcessing(functionParameter, level, facilityType)
    local finalValue = 0;
    if facilityType == FacilityProperty.Cost or facilityType == FacilityProperty.Transaction then
        finalValue = self._facilitydata[functionParameter][level] / 10000;
        return self:FinalValueToString(finalValue);
    elseif facilityType == FacilityProperty.RecruitTime or
     facilityType == FacilityProperty.Qin or
     facilityType == FacilityProperty.Shi or
     facilityType == FacilityProperty.DuYi or
     facilityType == FacilityProperty.WeiJing or
     facilityType == FacilityProperty.RedifTime or
     facilityType == FacilityProperty.PhysicalInjury or
     facilityType == FacilityProperty.StrategyInjury then
        finalValue = self._facilitydata[functionParameter][level] / 10000 * 100;
        return self:FinalValueToString(finalValue) .. "%";
    else
        finalValue = self._facilitydata[functionParameter][level];
        return self:FinalValueToString(finalValue);
    end
end

function UIFacilityProperty:FinalValueToString(value)
    -- body
    if value>=0 then
        return "+"..value;
    else
        return ""..value;
    end
end

--建造过程中
function UIFacilityProperty:_Building()
    self:_Lock();
    if  self._facility:GetBuildingTime() == 0 then
        self:_ShowDemand();
    else
        self:_ShowDecree();
    end
end

function UIFacilityProperty:_ShowDecree()
    self._buildingDecree.gameObject:SetActive(true);
    self._buildingDemand.gameObject:SetActive(false);
    self._buildingDecreeFirst.text = "Lv"..self._level;
    self._buildingDecreeLast.text = "<color=#e2bd75>".."Lv"..(self._level+1).."</color>";
    self._buildingMoneyText.text ="<color=#e2bd75>".."花费"..DataGameConfig[308].OfficialData.."</color>";
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() > DataGameConfig[308].OfficialData then
        self._buildingDecree.interactable = false;
    else
        self._buildingDecree.interactable = true;
    end
end

function UIFacilityProperty:_ShowDemand()
    self._buildingDemand.gameObject:SetActive(true);
    self._buildingDecree.gameObject:SetActive(false);
    local Decree = PlayerService:Instance():GetDecreeSystem():GetCurValue();
    local Wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
    local Iron = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
    local Stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
    ------print(Decree..Wood..Iron..Stone)
    if self._level == self._facilitydata.MaxLevel then
        self._buildingDemand.gameObject:SetActive(false);
    else
        self._buildingDemandText.text = "政令: ".." <color=#FFFFFFFF>".."--".."</color>".."/".. Decree;
        self._buildingDemandWood.text = "木材: ".." <color=#FFFFFFFF>"..self:HandlerUpgradeCostText(self._facilitydata.UpgradeCostWood[self._level + 1], Wood).."</color>".."/"..Wood;
        self._buildingDemandIron.text = "铁矿: ".."<color=#FFFFFFFF>"..self:HandlerUpgradeCostText(self._facilitydata.UpgradeCostIron[self._level + 1], Iron).."</color>".."/"..Iron;
        self._buildingDemandStone.text = "石料: ".."<color=#FFFFFFFF>"..self:HandlerUpgradeCostText(self._facilitydata.UpgradeCostStone[self._level + 1], Stone).."</color>".."/"..Stone;
        if self._facilitydata.UpgradeCostCommand[self._level + 1] > Decree or
           self._facilitydata.UpgradeCostWood[self._level + 1] > Wood or
           self._facilitydata.UpgradeCostIron[self._level + 1] > Iron or
           self._facilitydata.UpgradeCostStone[self._level + 1] > Stone then
           self._buildingConfirm.interactable = false;
           self._buildingTimeText.text = "<color=#ff0000ff>资源不足</color>";
        else
            self._buildingConfirm.interactable = true;
        end
    end
end

function UIFacilityProperty:HandlerUpgradeCostText(value, mvalue)
    if tonumber(value) == 0 then
       return "--";
    else
        if tonumber(value) > tonumber(mvalue) then
           return "<color=#ff0000ff>"..value.."</color>";
        end
        return value;
    end
end

return UIFacilityProperty;