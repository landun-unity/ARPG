--[[
    建筑要塞界面
--]]

local UIBase = require("Game/UI/UIBase");
local UIFort = class("UIFort",UIBase);
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")
--构造函数
function UIFort:ctor()
    UIFort.super.ctor(self);
    self.closeBtn = nil;
    self.confirmBtn = nil;
    self.curTiledIndex = nil;
    self.timeText = nil;
    self.woodText = nil;
    self.ironText = nil;
    self.stoneText = nil;
    self.grainText = nil;
    self.copperText = nil;
    self.orderText = nil;
end


--注册控件
function UIFort:DoDataExchange()
  self.closeBtn = self:RegisterController(UnityEngine.UI.Button,"fortressDetailsImage/XButton");
  self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"fortressDetailsImage/buildButton");
  self.timeText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/build/timeText");

  self.woodText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/TimberImage/TimberText");
  self.ironText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/IronImage/IronText");
  self.stoneText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/StoneImage/StoneText");
  self.grainText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/GrainImage/GrainText");
  self.copperText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/CopperImage/CopperText");
  self.orderText = self:RegisterController(UnityEngine.UI.Text,"fortressDetailsImage/ChineseImage/TranslucenceImage/TranslucenceImage3/OrderImage/OrderText");

end

--注册点击事件
function UIFort:DoEventAdd()
  self:AddListener(self.closeBtn,self.OnClickCloseBtn);
  self:AddListener(self.confirmBtn,self.OnClickConfirmBtn);
end

function UIFort:OnShow(curTiledIndex)
  self.curTiledIndex = curTiledIndex;
  --print(self.curTiledIndex)
  self:Refresh();
end

--点击返回按钮
function UIFort:OnClickCloseBtn()
    UIService:Instance():HideUI(UIType.UIFort);
end

function UIFort:OnClickConfirmBtn()
	UIService:Instance():ShowUI(UIType.UIConfirmfortressBuild, self.curTiledIndex);
end

function UIFort:Refresh()
  local Wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
  local Iron = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
  local Stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
  local Grain = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue();
  local Money = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
  local Decree = PlayerService:Instance():GetDecreeSystem():GetCurValue();
  self.woodText.text = "木材  <color=#FFFFFFFF>"..DataBuilding[40001].UpgradeCostWood.."</color>/"..Wood;
  self.ironText.text = "铁矿  <color=#FFFFFFFF>"..DataBuilding[40001].UpgradeCostIron.."</color>/"..Iron;
  self.stoneText.text = "石料  <color=#FFFFFFFF>"..DataBuilding[40001].UpgradeCostStone.."</color>/"..Stone;
  self.grainText.text = "粮草  <color=#FFFFFFFF>"..DataBuilding[40001].UpgradeCostFood.."</color>/"..Grain;
  self.copperText.text = "铜钱  <color=#FFFFFFFF>".."0".."</color>/"..Money;
  self.orderText.text = "政令  <color=#FFFFFFFF>"..DataBuilding[40001].UpgradeCostCommand.."</color>/"..Decree;
  if DataBuilding[40001].UpgradeCostWood > Wood then
    self.woodText.text = "木材  <color=red>"..DataBuilding[40001].UpgradeCostWood.."</color>/"..Wood;
  end
  if DataBuilding[40001].UpgradeCostIron > Iron then
    self.ironText.text = "铁矿  <color=red>"..DataBuilding[40001].UpgradeCostIron.."</color>/"..Iron;
  end
  if DataBuilding[40001].UpgradeCostStone > Stone then
    self.stoneText.text = "石料  <color=red>"..DataBuilding[40001].UpgradeCostStone.."</color>/"..Stone;
  end
  if DataBuilding[40001].UpgradeCostFood > Grain then
    self.grainText.text = "粮草  <color=red>"..DataBuilding[40001].UpgradeCostFood.."</color>/"..Grain;
  end
  if DataBuilding[40001].UpgradeCostCommand > Decree then
    self.orderText.text = "政令  <color=red>"..DataBuilding[40001].UpgradeCostCommand.."</color>/"..Decree;
  end
  if DataBuilding[40001].UpgradeCostWood <= Wood and
    DataBuilding[40001].UpgradeCostIron <= Iron and
    DataBuilding[40001].UpgradeCostStone <= Stone and
    DataBuilding[40001].UpgradeCostFood <= Grain and
    DataBuilding[40001].UpgradeCostCommand <= Decree then
    self.timeText.text = "<color=#FFFF83FF>需要时间</color>  ".."04:30:00";
     self.confirmBtn.interactable = true;
  else
     self.timeText.text = "<color=red>建造条件不足</color>"
     self.confirmBtn.interactable = false;
  end
end
return UIFort;