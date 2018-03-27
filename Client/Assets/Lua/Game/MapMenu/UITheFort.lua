--[[
    要塞界面
--]]
local UIBase= require("Game/UI/UIBase");
local UITheFort=class("UITheFort",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UITheFort:ctor()
    UITheFort.super.ctor(self);
    self.fortress = nil;
    self.backBtn = nil;
    self.problem = nil;
    self.fangxiang1 = nil;
    self.fangxiang2 = nil;
    self.firstTroops = nil;
    self.secondTroops = nil;
    self.thirdTroops = nil;
    self.fourTroops = nil;
    self.fivTroops = nil;
    self.pandect = nil;

    self._Jade = nil;
    self._Gold = nil;
    self._Arms = nil;
    self._Durable = nil;

end

--注册控件
function UITheFort:DoDataExchange()
  self.fortress=self:RegisterController(UnityEngine.UI.Button,"fortress");
  self.backBtn=self:RegisterController(UnityEngine.UI.Button,"backBtn");  
  self.problem = self:RegisterController(UnityEngine.UI.Button,"problem")
  self.fangxiang1 = self:RegisterController(UnityEngine.UI.Button,"fangxiang1")
  self.fangxiang2 = self:RegisterController(UnityEngine.UI.Button,"fangxiang2")
  self.firstTroops = self:RegisterController(UnityEngine.UI.Button,"firstTroops")
  self.secondTroops = self:RegisterController(UnityEngine.UI.Button,"secondTroops")
  self.thirdTroops = self:RegisterController(UnityEngine.UI.Button,"thirdTroops")
  self.fourTroops = self:RegisterController(UnityEngine.UI.Button,"fourTroops")
  self.fivTroops = self:RegisterController(UnityEngine.UI.Button,"fivTroops")
  self.pandect = self:RegisterController(UnityEngine.UI.Button,"pandect")

  self._Jade = self:RegisterController(UnityEngine.UI.Text,"message/Jade/Text")
  self._Gold = self:RegisterController(UnityEngine.UI.Text,"message/Coins/Text")
  self._Arms = self:RegisterController(UnityEngine.UI.Text,"message/Arms/Text")
  self._Durable = self:RegisterController(UnityEngine.UI.Text,"message/Durable/Text");
  

end

--注册按钮点击事件
function UITheFort:DoEventAdd()
  self:AddListener(self.fortress,self.OnClickFortressBtn);
  self:AddListener(self.backBtn,self.OnClickBackBtnBtn);
  self:AddListener(self.problem,self.OnClickProblemBtn);
  self:AddListener(self.fangxiang1,self.OnClickFirstBtn);
  self:AddListener(self.fangxiang2,self.OnClickSecondBtn);
  -- self:AddListener(self.firstTroops.gameObject,self.OnClickTroopsBtn);
  -- self:AddListener(self.secondTroops.gameObject,self.OnClickTroopsBtn);
  -- self:AddListener(self.thirdTroops.gameObject,self.OnClickTroopsBtn);
  -- self:AddListener(self.fourTroops.gameObject,self.OnClickTroopsBtn);
  -- self:AddListener(self.fivTroops.gameObject,self.OnClickTroopsBtn);

end

function UITheFort:OnShow()
    self:Setdata();
end

--返回按钮
function UITheFort:OnClickBackBtnBtn()
    UIService:Instance():HideUI(UIType.UITheFort);    
end

--堡垒按钮
function UITheFort:OnClickFortressBtn()
    UIService:Instance():ShowUI(UIType.UIUpgradeBuilding);
end

--帮助按钮
function UITheFort:OnClickProblemBtn()    
    UIService:Instance():ShowUI(UIType.UIFortExplain);
end

-- --点击部队按钮
-- function UITheFort:OnClickTroopsBtn()
--     UIService:Instance():ShowUI(UIType.UIFortTroops);
-- end

function UITheFort:Setdata()
    self._Gold.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    self._Jade.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
end

return UITheFort;
