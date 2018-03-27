--[[
    Name:设施类
--]]
local UIBase = require("Game/UI/UIBase");
local Facility = require("Game/Facility/Facility")
local FacilityService = require("Game/Facility/FacilityService")
local PlayerService = require("Game/Player/PlayerService")
local Data = require("Game/Table/model/DataConstruction")
local UIFacilityItem = class("UIFacilityItem", UIBase);

--构造函数
function UIFacilityItem:ctor()
	UIFacilityItem.super.ctor(self);
    self._type = 0;
    self._level = 0;
    self._facilitydata = nil;
    self._facility = nil;


    self._facilityback = nil;
    self._facilityimage = nil;
    self._namepanel = nil;
    self._levelimage = nil;
    self._facilitylevel = nil;
    self._facilityname = nil;
    self._max = nil;
    self._building = nil;
    --建造遮罩
    self._imagepanel = nil;
    self._time = nil;
    --解锁遮罩
    self._facilitypanel = nil;

    self.marchTimer = nil;

    self.buildingId = nil;

    self._selfObj = nil;
end

--初始化
function UIFacilityItem:OnInit(prefab, i, Facility, buildingId)
  self._selfObj = prefab;
  self.buildingId = buildingId;
  prefab:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = Vector3.New(0, 0, 0);
  self._type = i;
  if i==1 then
      prefab:GetComponent(typeof(UnityEngine.RectTransform)).localScale = Vector3.New(1.4, 1.4, 0);
  end
  if Facility == nil then
    return;
  end
  self._facility = Facility;
  self._level = Facility:GetLevel();
  self._tableId = Facility:GetTableId();
  self._facilitydata = Data[self._tableId];
  if Facility:GetBuildingTime() / 1000 > PlayerService:Instance():GetLocalTime() / 1000 then
      self:OnShow((Facility:GetBuildingTime() / 1000) - PlayerService:Instance():GetLocalTime() / 1000);
  else
      self:OnShow(0);
  end
end

function UIFacilityItem:Load(i, Facility, buildingId)
  self._facility = Facility;
  self._selfObj.gameObject:SetActive(true);
  self._level = Facility:GetLevel();
  self.buildingId = buildingId;
  self._tableId = Facility:GetTableId();
  self._facilitydata = Data[self._tableId];
  self._type = i;
  if Facility:GetBuildingTime() / 1000 > PlayerService:Instance():GetLocalTime() / 1000 then
      self:OnShow(((Facility:GetBuildingTime() / 1000) - PlayerService:Instance():GetLocalTime() / 1000));
  else
      self:OnShow(0);
  end
end

function UIFacilityItem:Hide()
  -- if self.marchTimer ~= nil then
  --     self.marchTimer:Stop();
  -- end
  self._selfObj.gameObject:SetActive(false);
end

--刷新
function UIFacilityItem:OnShow(time)
	self._facilitypanel.gameObject:SetActive(false);
	--self._facilitylevel.text = self._level.."<color=#e2bd75>".."/"..self._facilitydata.MaxLevel.."</color>";
  self:_Lock();
	if self._level == 0 then
        --self:_Lock();
        self._max.gameObject:SetActive(false);
        if time == 0 then
          self:_HideBuildingTime();
          self._building.gameObject:SetActive(false);
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
      else
        self._facilitypanel.gameObject:SetActive(false);
        self._max.gameObject:SetActive(false);
      end

    	--self._facilitypanel.gameObject:SetActive(false);
    	if time == 0 then
    	  self:_HideBuildingTime();
        self._building.gameObject:SetActive(false);
	    else
	    self:_ShowBuildingTime(time, self._facilitydata.UpgradeCostTime[self._level + 1]);
	  	--self._building.sprite = GameResFactory.Instance():GetResSprite("MianCityUpgrade");
      self._building.gameObject:SetActive(true);
	    end
    end
    self:NameLock();
end

function UIFacilityItem:_Lock()
	 local locked = 0;
	 --self._facilitypanel.gameObject:SetActive(true);
   --self:_ShowFacilityImage(self._facilityimage.image.sprite, self._facilitydata.ConstructionPicture);
	 --self._facilitypanel.color = Color.New(0,0,0,0.3);
      for i,v in ipairs(self._facilitydata.PreconditionName) do
       	local facility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, v);
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
      self._facilityname.text = self._facilitydata.Name;
      self:_ShowFacilityLevelImage("gray");
      self._facilitylevel.text = "<color=#7f7f7f>"..self._level.."/"..self._facilitydata.MaxLevel.."</color>";
   else
      self._facilityname.text = "<color=#e2bd75>"..self._facilitydata.Name.."</color>";
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

-- function UIFacilityItem:_imageUpgradeLock()
--     self._facilitypanel.gameObject:SetActive(true);
--     local facility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, self._facilitydata.UpgradeCondition);
--     local level = facility:GetLevel();
--     if self._facility:GetLevel() + 1 <= self._facilitydata.MaxLevel and level < self._facilitydata.UpgradeParameter[self._facility:GetLevel() + 1] then
--         self:_ShowFacilityImage(self._facilitydata.ConstructionPicture.."gray");
--         self:_ShowFacilityBack(5);
--         --self._facilitypanel.color = Color.New(0,0,0,0.7);
--         return;
--     end
--     self:_ShowFacilityBack(self._facilitydata.ConstructionType);
--     self:_ShowFacilityImage(self._facilitydata.ConstructionPicture);
--     --self._facilitypanel.color = Color.New(0,0,0,0);
-- end
--local bgimage = string.format("%s_%02d", "citybackground", self._facilitydata.ConstructionType);
--self._facilityback.sprite = GameResFactory.Instance():GetResSprite(bgimage);
--self._facilityimage.image.sprite = GameResFactory.Instance():GetResSprite(self._facilitydata.ConstructionPicture);
function UIFacilityItem:_ShowFacilityLevelImage(name)
  local bgimage = string.format("%s%s", "levelnagive", name);
  self._levelimage.sprite = GameResFactory.Instance():GetResSprite(bgimage);
end

function UIFacilityItem:_ShowFacilityPanel(name)
  if name == 1 then
    self._facilitypanel.gameObject:SetActive(false);
    return;
  end
  self._facilitypanel.gameObject:SetActive(true);
  local bgimage = string.format("%s%02d", "backgroundlight", name);
  self._facilitypanel.sprite = GameResFactory.Instance():GetResSprite(bgimage);
end

function UIFacilityItem:_ShowFacilityBack(name)
   local bgimage = string.format("%s_%02d", "citybackground", name);
   self._facilityback.sprite = GameResFactory.Instance():GetResSprite(bgimage);
end

function UIFacilityItem:_ShowFacilityImage(name)
   self._facilityimage.image.sprite = GameResFactory.Instance():GetResSprite(name);
end

function UIFacilityItem:_ShowBuildingTime(time, maxtime)
	--self:Time(time, maxtime);
  CommonService:Instance():TimeDown(UIType.UIFacility, self._facility:GetBuildingTime(), self._time, 
    function() self:_Complete(); end, nil, maxtime, self._imagepanel);
  self._imagepanel.gameObject:SetActive(true);
  self._time.gameObject:SetActive(true);
end

function UIFacilityItem:_HideBuildingTime()
  self:_Complete();
  CommonService:Instance():RemoveTimeDownInfo(self._time.transform.gameObject);
	--self:Time(0, timeMax)
end

--倒计时
function UIFacilityItem:Time(time, timeMax)
    local cdTime = time;
    if cdTime == 0 then
        if self.marchTimer ~= nil then
            self.marchTimer:Stop();
            self.marchTimer = nil;
        end
        self:_Complete();
    else
        if self.marchTimer == nil then
          self._time.gameObject:SetActive(true);
          self._imagepanel.gameObject:SetActive(true);
          self.marchTimer = Timer.New(function()
          cdTime = cdTime > 0 and cdTime - 1 or 0
          self:_CountDown(cdTime, timeMax);
          if cdTime == 0 then
               self:_Complete();
               self.marchTimer:Stop();
          end
          end, 1, -1, false)
          self.marchTimer:Start();
        else
        end
    end
end

function UIFacilityItem:_CountDown(time, timeMax)
    self._time.text = self:TimeFormat(time);
    self._imagepanel.fillAmount = time / timeMax;
end

function UIFacilityItem:_Complete()
    self._imagepanel.gameObject:SetActive(false);
    self._time.gameObject:SetActive(false);
end

function UIFacilityItem:TimeFormat(mtime)
    local time = math.ceil(mtime);
    local h = math.floor(time / 3600);
    local m = math.floor(math.floor(time % 3600) / 60);
    local s = math.ceil(math.ceil(time % 3600) % 60);
    local timeText = string.format("%02d:%02d:%02d",h, m, s);
    return timeText;
end

--注册控件
function UIFacilityItem:DoDataExchange()
   self._facilityback = self:RegisterController(UnityEngine.UI.Image,"facilityback");
   self._facilityimage = self:RegisterController(UnityEngine.UI.Button, "facilityimage");
   self._levelimage = self:RegisterController(UnityEngine.UI.Image, "levelimage");
   self._namepanel = self:RegisterController(UnityEngine.UI.Image, "namepanel");
   self._facilitylevel = self:RegisterController(UnityEngine.UI.Text, "facilitylevel");
   self._facilityname = self:RegisterController(UnityEngine.UI.Text, "facilityname");
   self._max = self:RegisterController(UnityEngine.UI.Image, "max");
   self._building = self:RegisterController(UnityEngine.UI.Image, "building");
   self._imagepanel = self:RegisterController(UnityEngine.UI.Image, "imagepanel");
   self._time = self:RegisterController(UnityEngine.UI.Text, "time");
   self._facilitypanel = self:RegisterController(UnityEngine.UI.Image, "facilitypanel");
end

--注册控件点击事件
function UIFacilityItem:DoEventAdd()
   self:AddListener(self._facilityimage,self.OnClickUpgradeFacility);
end

function UIFacilityItem:NameLock()
    local Decree = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Decree):GetValue();
    local Wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
    local Iron = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
    local Stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
    if self._level + 1 > self._facilitydata.MaxLevel then
       self._namepanel.sprite = GameResFactory.Instance():GetResSprite("namepanel1");
       return;
    end
    if self._facilitydata.UpgradeCostCommand[self._level + 1] > Decree or
    self._facilitydata.UpgradeCostWood[self._level + 1] > Wood or
    self._facilitydata.UpgradeCostIron[self._level + 1] > Iron or
    self._facilitydata.UpgradeCostStone[self._level + 1] > Stone then
      self._namepanel.sprite = GameResFactory.Instance():GetResSprite("namepanel");
      --self._namepanel.gameObject:SetActive(true);
    else
      self._namepanel.sprite = GameResFactory.Instance():GetResSprite("namepanel2");
      --self._namepanel.gameObject:SetActive(false);
    end
end

function UIFacilityItem:OnClickUpgradeFacility()
  --print(self._type)
  local param = {};
  param.type = self._type;
  param.id = self.buildingId;
	UIService:Instance():ShowUI(UIType.UIFacilityProperty, param);
end

return UIFacilityItem;