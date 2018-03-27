--[[
    分城界面
--]]

local UIBase = require("Game/UI/UIBase");
local UIPointsCityPanel = class("UIPointsCityPanel",UIBase);
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")
local DataBuilding = require("Game/Table/model/DataBuilding")

--构造函数
function UIPointsCityPanel:ctor()
    UIPointsCityPanel.super.ctor(self);
    
    self.curTiledIndex = nil;

    self.closeBtn = nil;
    self.confirmBtn = nil;

    self.timeText = nil;

    self.woodText = nil;
    self.ironText = nil;
    self.stoneText = nil;
    self.grainText = nil;
    self.copperText = nil;
    self.orderText = nil;
    self.SubCityImage = nil;
    self.time = nil;
end

function UIPointsCityPanel:RegisterAllNotice()
    --self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.BuildingSubCity);
end

--注册控件
function UIPointsCityPanel:DoDataExchange()
    self.closeBtn = self:RegisterController(UnityEngine.UI.Button,"fortressDetailsImage/XButton");
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"fortressDetailsImage/buildButton");
    self.timeText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/buildButton/timeText");

    self.woodText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/TimberImage/TimberText");
    self.ironText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/IronImage/IronText");
    self.stoneText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/StoneImage/StoneText");
    self.grainText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/GrainImage/GrainText");
    self.copperText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/CopperImage/CopperText");
    self.orderText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/OrderImage/OrderText");
end

--注册点击事件
function UIPointsCityPanel:DoEventAdd()
  self:AddListener(self.closeBtn,self.OnClickCloseBtn);
  self:AddListener(self.confirmBtn,self.OnClickConfirmBtn);
end

function UIPointsCityPanel:OnShow(curTiledIndex)
   self.curTiledIndex = curTiledIndex;
   self:Refresh();
end

function UIPointsCityPanel:Refresh()
  local Wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
  local Iron = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
  local Stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
  local Grain = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue();
  local Money = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
  local Decree = PlayerService:Instance():GetDecreeSystem():GetCurValue();
  self.woodText.text = "木材  <color=#FFFFFFFF>"..DataBuilding[20001].UpgradeCostWood.."</color>/"..Wood;
  self.ironText.text = "铁矿  <color=#FFFFFFFF>"..DataBuilding[20001].UpgradeCostIron.."</color>/"..Iron;
  self.stoneText.text = "石料  <color=#FFFFFFFF>"..DataBuilding[20001].UpgradeCostStone.."</color>/"..Stone;
  self.grainText.text = "粮草  <color=#FFFFFFFF>"..DataBuilding[20001].UpgradeCostFood.."</color>/"..Grain;
  self.copperText.text = "铜钱  <color=#FFFFFFFF>".."0".."</color>/"..Money;
  self.orderText.text = "政令  <color=#FFFFFFFF>".."--".."</color>/"..Decree;
  
  if DataBuilding[20001].UpgradeCostWood > Wood then
    self.woodText.text = "木材  <color=red>"..DataBuilding[20001].UpgradeCostWood.."</color>/"..Wood;
  elseif DataBuilding[20001].UpgradeCostIron > Iron then
    self.ironText.text = "铁矿  <color=red>"..DataBuilding[20001].UpgradeCostIron.."</color>/"..Iron;
  elseif DataBuilding[20001].UpgradeCostStone > Stone then
    self.stoneText.text = "石料  <color=red>"..DataBuilding[20001].UpgradeCostStone.."</color>/"..Stone;
  elseif DataBuilding[20001].UpgradeCostFood > Grain then
    self.grainText.text = "粮草  <color=red>"..DataBuilding[20001].UpgradeCostFood.."</color>/"..Grain;
  elseif DataBuilding[20001].UpgradeCostCommand > Decree then
    self.orderText.text = "政令  <color=red>".."--".."</color>/"..Decree;
  end
  if DataBuilding[20001].UpgradeCostWood <= Wood and
    DataBuilding[20001].UpgradeCostIron <= Iron and
    DataBuilding[20001].UpgradeCostStone <= Stone and
    DataBuilding[20001].UpgradeCostFood <= Grain and
    DataBuilding[20001].UpgradeCostCommand <= Decree then
     self.confirmBtn.interactable = true;
  else
     self.confirmBtn.interactable = false;
  end
  self.timeText.text = "<color=#e2bd75>".."需要时间".."</color>" .."  04:30:00";

end

-- 是否拥有郡
function UIPointsCityPanel:IsBootPrefecture()
  
end

--
function UIPointsCityPanel:OnClickCloseBtn()
    UIService:Instance():HideUI(UIType.UIPointsCityPanel);
end

--
function UIPointsCityPanel:OnClickConfirmBtn()
      UIService:Instance():HideUI(UIType.UIPointsCityPanel);
      UIService:Instance():ShowUI(UIType.UIConfirmBuild,self.curTiledIndex);
end



return UIPointsCityPanel;