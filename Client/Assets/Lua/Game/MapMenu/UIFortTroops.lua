--[[
    要塞征兵界面
--]]
local UIBase= require("Game/UI/UIBase");
local UIFortTroops=class("UIFortTroops",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UIFortTroops:ctor()
    UIFortTroops.super.ctor(self);
    self.conscript = nil;    
    self.guardBtn = nil;
    self.CenterBtn = nil;
    self.forwardBtn = nil;
    self.backBtn = nil;
    self.interchangeBtn = nil;
    self.configurationBtn = nil;
end

--注册控件
function UIFortTroops:DoDataExchange()
  self.conscript=self:RegisterController(UnityEngine.UI.Button,"ArmyAllocation/conscript");
  self.backBtn=self:RegisterController(UnityEngine.UI.Button,"backBtn");
  self.guardBtn=self:RegisterController(UnityEngine.UI.Button,"CampBtn/Generalhanbook1");
  self.CenterBtn=self:RegisterController(UnityEngine.UI.Button,"CenterBtn/Generalhanbook2");
  self.forwardBtn=self:RegisterController(UnityEngine.UI.Button,"forwardBtn/Generalhanbook3");  
  self.interchangeBtn=self:RegisterController(UnityEngine.UI.Button,"ArmyAllocation/interchange");
  self.configurationBtn=self:RegisterController(UnityEngine.UI.Button,"ArmyAllocation/configuration");  
end

--注册点击事件
function UIFortTroops:DoEventAdd()
   self:AddListener(self.conscript,self.OnClickConscriptBtn);
   self:AddListener(self.backBtn,self.OnClickBackBtn);
   self:AddListener(self.guardBtn,self.OnClickGeneralBtn);
   self:AddListener(self.CenterBtn,self.OnClickCenterBtn);
   self:AddListener(self.forwardBtn,self.OnClickforwardBtn);
   self:AddListener(self.interchangeBtn,self.OnClickInterchangeBtn);
   self:AddListener(self.configurationBtn,self.OnClickConfigurationBtn);
end

--点击征兵按钮
function UIFortTroops:OnClickConscriptBtn()
    UIService:Instance():ShowUI(UIType.UIConscription);
end

--点击武将按钮
function UIFortTroops:OnClickGeneralBtn()
    UIService:Instance():ShowUI(UIType.CamyIntroduce);

end

function UIFortTroops:OnClickCenterBtn()
    UIService:Instance():ShowUI(UIType.CamyIntroduce);
end

function UIFortTroops:OnClickforwardBtn()
    UIService:Instance():ShowUI(UIType.CamyIntroduce);
end

--点击返回按钮
function UIFortTroops:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIFortTroops);
end

function UIFortTroops:OnClickInterchangeBtn()
    UIService:Instance():ShowUI(UIType.ArmySwap);
end

--点击队伍配置
function UIFortTroops:OnClickConfigurationBtn()
     UIService:Instance():ShowUI(UIType.ArmyConfigUI);
end
return UIFortTroops;
