--[[
    Name:城设施界面
--]]

local UIBase= require("Game/UI/UIBase")
local FacilityType = require("Game/Facility/FacilityType")
local FacilityService = require("Game/Facility/FacilityService")
local Data = require("Game/Table/model/DataConstruction")
local KindItem = require("Game/Facility/UIFacilityItem")
local List = require("common/List");
local MapService = require("Game/Map/MapService")
require("Game/Map/Operator/OperatorType")
local PlayerService = require("Game/Player/PlayerService")
local UIFacility=class("UIFacility",UIBase)
-- local UIService=require("Game/UI/UIService")
-- local UIType=require("Game/UI/UIType")

--构造函数
function UIFacility:ctor()
    UIFacility.super.ctor(self);
    --设施table
    self._facilityList = {};
    --设施按钮
    self._closeBtn = nil;
    --
    self._facilityItem = "FacilityItem";
    --父亲
    self._ParentObj = nil;

    self._scrollRect = nil;

    self._FirstText = nil;
    self._SecondText = nil;
    self._ThirdText = nil;
    self._FiourthText = nil;
    self._FifthText = nil;
    self._SixthText = nil;
    self._SevenText = nil
    self._EighthText = nil;
    self._NinthText = nil;
    self._TenText = nil;
    self._EleText = nil;
    self._backGroundBtn = nil;
    self._BuildingObj = nil;

    self._BuildingTable = {};
     
    self.buildingId = 0;

    self._firstimage = nil;
    self._secondimage = nil;
    self._thirdimage = nil;
    self._fiourthimage = nil;
    self._fifthimage = nil;
    self._sixthimage = nil;
    self._sevenimage = nil;
    self._eighthimage = nil;
    self._ninthimage = nil;
    self._tenimage = nil;
    self._eleimage = nil;

    self._itemImage = {};
end

--初始化界面
function UIFacility:OnInit()
    --self.buildingId = PlayerService:Instance():GetmainCityId();
    local childCount = self._BuildingObj.childCount;
    for n = 1 ,childCount do
      local buildingObj = self._BuildingObj:GetChild(n - 1);
      self._BuildingTable[n] =  buildingObj;
      local mFacilityItem = KindItem.new();
      GameResFactory.Instance():GetUIPrefab("UIPrefab/"..self._facilityItem, self._BuildingTable[n], mFacilityItem, function (go)
        mFacilityItem:DoDataExchange();
        mFacilityItem:OnInit(go, n);
        mFacilityItem:DoEventAdd();
        self._facilityList[n] = mFacilityItem;
        mFacilityItem:Hide();
        end);
    end
    --self:Refresh();
end

--刷新
function UIFacility:RegisterAllNotice()
    self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.Refresh);
end


-- function UIFacility:UpgradeFacility()
--     self:OnShow();
-- end

--注册控件
function UIFacility:DoDataExchange()
   self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "BackBtn");
   self._backGroundBtn = self:RegisterController(UnityEngine.UI.Button, "backGroundBtn");
   --线
   self._scrollRect = self:RegisterController(UnityEngine.UI.ScrollRect,"ScrollView");
   self._BuildingObj = self:RegisterController(UnityEngine.Transform,"ScrollView/Viewport/Content/BuildingObj")
   self._ParentObj = self:RegisterController(UnityEngine.Transform, "ScrollView/Viewport/Content");
   self._FirstText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/FirstImage/Text");
   self._SecondText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/SecondImage/Text");
   self._ThirdText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/ThirdImage/Text");
   self._FiourthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/FiourthImage/Text");
   self._FifthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/FifthImage/Text");
   self._SixthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/SixthImage/Text");
   self._SevenText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/SevenImage/Text");
   self._EighthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/EighthImage/Text");
   self._NinthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/NinthImage/Text");
   self._TenText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/TenImage/Text");
   self._EleText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/EleImage/Text");

   self._firstimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/FirstImage");
   self._secondimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/SecondImage");
   self._thirdimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/ThirdImage");
   self._fiourthimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/FiourthImage");
   self._fifthimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/FifthImage");
   self._sixthimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/SixthImage");
   self._sevenimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/SevenImage");
   self._eighthimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/EighthImage");
   self._ninthimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/NinthImage");
   self._tenimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/TenImage");
   self._eleimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/EleImage");
   --前面
   for i = 1, 8 do
     self._itemImage[i] = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/Item"..i.."/NumImg");
   end
   -- self._firstim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/SecondBI/NumImg");
   -- self._secondim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/ThirdBI/NumImg");
   -- self._thirdim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/FiourthBI/NumImg");
   -- self._fiourthim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/FifthBI/NumImg");
   -- self._fifthim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/SixthBI/NumImg");
   -- self._sixthim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/SeventhBI/NumImg");
   -- self._sevenim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/EighthBI/NumImg");
   -- self._eighthim = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/NinthBI/NumImg");
   -- -- self._ninthimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/NinthImage");
   -- -- self._tenimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/TenImage");
   -- -- self._eleimage = self:RegisterController(UnityEngine.UI.Image, "ScrollView/Viewport/Content/EleImage");

   -- self._firstText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/SecondBI/NumImg/Text");
   -- self._secondText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/ThirdBI/NumImg/Text");
   -- self._thirdText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/FiourthBI/NumImg/Text");
   -- self._fiourthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/FifthBI/NumImg/Text");
   -- self._fifthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/SixthBI/NumImg/Text");
   -- self._sixthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/SeventhBI/NumImg/Text");
   -- self._sevenText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/EighthBI/NumImg/Text");
   -- self._eighthText = self:RegisterController(UnityEngine.UI.Text, "ScrollView/Viewport/Content/NinthBI/NumImg/Text");
end

--注册控件点击事件
function UIFacility:DoEventAdd()
   self:AddListener(self._closeBtn,self.OnClickClose);
   self:AddListener(self._backGroundBtn,self.OnClickClose);
end

function UIFacility:OnClickClose()
	  UIService:Instance():HideUI(UIType.UIFacility);
    EventService:Instance():TriggerEvent(EventType.ListenerSetPanels);
    UIService:Instance():HideFortImage();
end

function UIFacility:GetFacilityByType(type)
     return self._facilityList[type];
end

function UIFacility:GetFacilityCount()
     return self._facilityList:Count();
end

function UIFacility:OnShow(param)
    local yStandard = 1.001358e-05;
    local locateFacility = 1;
    if param.facilityType ~= nil and param.facilityType ~= 0 then
        locateFacility = param.facilityType;
    end
    if self._BuildingTable[locateFacility] == nil then
        locateFacility = 1;
    end
    local offset = self._BuildingTable[1].localPosition.y - self._BuildingTable[locateFacility].localPosition.y;
    self._ParentObj.anchoredPosition3D = Vector3.New(0, yStandard + offset, 0);
    self.buildingId = param.id;
    self:Refresh();
    self:ShowText();

    if GuideServcice:Instance():GetIsFinishGuide() == true then
        self._scrollRect.vertical = true;
    else
        self._scrollRect.vertical = false;
    end
end

function UIFacility:OnHide()
    self:ClearFacility();
    --self._BuildingTable = {};
end

function UIFacility:ClearFacility()
   for k,v in pairs(self._facilityList) do
       v:Hide();
   end
end

function UIFacility:Refresh()
    if self.gameObject.activeSelf == false then
        return;
    end
    local count = FacilityService:Instance():GetAllFacilityCount(self.buildingId);
    for i=1,count do
        if i ~= FacilityType.PointHanHouse then
          if self:GetFacilityByType(i) == nil then
              local mFacilityItem = KindItem.new();
              local Facility = FacilityService:Instance():GetFacility(self.buildingId, i);
              GameResFactory.Instance():GetUIPrefab("UIPrefab/"..self._facilityItem, self._BuildingTable[Data[Facility._tableId].Type], mFacilityItem, function (go)
              mFacilityItem:DoDataExchange();
              mFacilityItem:OnInit(go, i, Facility, self.buildingId);
              mFacilityItem:DoEventAdd();
              self._facilityList[i] = mFacilityItem;
              end);
          else
              local Facility = FacilityService:Instance():GetFacility(self.buildingId, i);
              local mFacilityItem = self._facilityList[i];
              --mFacilityItem:DoDataExchange();
              mFacilityItem:Load(i, Facility, self.buildingId);
              --mFacilityItem:DoEventAdd();
          end
        end
    end
    self:ShowText();
    self:ShowImage();
end

function UIFacility:ShowImage()
     local level = FacilityService:Instance():GetFacilitylevelByIndex(self.buildingId, FacilityType.MainHouse);
     for i = 1, level do
        self._itemImage[i].sprite = GameResFactory.Instance():GetResSprite("Negative6");
     end

     for i = level + 1, 8 do
        self._itemImage[i].sprite = GameResFactory.Instance():GetResSprite("Negative6Gray");
     end
end

function UIFacility:LockText(FacilityType)
    local Facility = FacilityService:Instance():GetFacility(self.buildingId, FacilityType);
    local tableId = Facility:GetTableId();
    local count = #(Data[tableId].PreconditionName);
    local proFacility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, Data[tableId].PreconditionName[count]);
    if proFacility:GetLevel() < Data[tableId].Precondition[count] then
      return "<color=#a2341f>"..Data[tableId].Precondition[count].."</color>";
    else
      return Data[tableId].Precondition[count];
    end
end

function UIFacility:LockTextByIndex(FacilityType ,index)
    local tableId = FacilityService:Instance():GetFacility(self.buildingId, FacilityType):GetTableId();
    local count = #(Data[tableId].PreconditionName);
    local proFacility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, Data[tableId].PreconditionName[count]);
    if proFacility:GetLevel() < Data[tableId].Precondition[count] then
      return "<color=#a2341f>"..Data[tableId].Precondition[count].."</color>";
    else
      return Data[tableId].Precondition[count];
    end
end

function UIFacility:LockLine(FacilityType)
  local Facility = FacilityService:Instance():GetFacility(self.buildingId, FacilityType);
  local tableId = Facility:GetTableId();
  local count = #(Data[tableId].PreconditionName);
  local proFacility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, Data[tableId].PreconditionName[count]);
  if proFacility:GetLevel() < Data[tableId].Precondition[count] then
      return "GreyCircle";
  else
      if Data[tableId].ConstructionType == 2 then
         return "BlueCircle";
      else
         return "LSCircle";
      end
  end
end

function UIFacility:LockLineByIndex(FacilityType, index)
  local Facility = FacilityService:Instance():GetFacility(self.buildingId, FacilityType);
  local tableId = Facility:GetTableId();
  local proFacility = FacilityService:Instance():GetFacilityByTableId(self.buildingId, Data[tableId].PreconditionName[index]);
  if proFacility:GetLevel() < Data[tableId].Precondition[index] then
      return "GreyCircle";
  else
      if Data[tableId].ConstructionType == 2 then
         return "BlueCircle";
      else
         return "LSCircle";
      end
  end
end

function UIFacility:ShowText()
     self._FirstText.text = self:LockText(FacilityType.RecruitingHouse);
     self._SecondText.text = self:LockText(FacilityType.WareHouse);
     self._ThirdText.text = self:LockText(FacilityType.CommanderHouse);
     self._FiourthText.text = self:LockText(FacilityType.AlertHouse);
     self._FifthText.text = self:LockText(FacilityType.BeaconHouse);
     self._SixthText.text = self:LockTextByIndex(FacilityType.PointQunHouse, 4);
     self._SevenText.text = self:LockTextByIndex(FacilityType.PointQunHouse, 3);
     self._EighthText.text = self:LockTextByIndex(FacilityType.PointQunHouse, 2);
     self._NinthText.text = self:LockText(FacilityType.FengshanHouse);
     self._TenText.text = self:LockTextByIndex(FacilityType.SajikHouse, 2);
     self._EleText.text = self:LockTextByIndex(FacilityType.SajikHouse, 3);
     
     self._firstimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLine(FacilityType.RecruitingHouse));
     self._secondimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLine(FacilityType.WareHouse));
     self._thirdimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLine(FacilityType.CommanderHouse));
     self._fiourthimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLine(FacilityType.AlertHouse));
     self._fifthimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLine(FacilityType.BeaconHouse));
     self._sixthimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLineByIndex(FacilityType.PointQunHouse, 4));
     self._sevenimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLineByIndex(FacilityType.PointQunHouse, 3));
     self._eighthimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLineByIndex(FacilityType.PointQunHouse, 2));
     self._ninthimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLine(FacilityType.FengshanHouse));
     self._tenimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLineByIndex(FacilityType.SajikHouse, 2));
     self._eleimage.sprite = GameResFactory.Instance():GetResSprite(self:LockLineByIndex(FacilityType.SajikHouse, 3));
end

return UIFacility;