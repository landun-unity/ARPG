--[[
    升级要塞界面
--]]
local UIBase= require("Game/UI/UIBase");
local UIUpgradeFort=class("UIUpgradeFort",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UIUpgradeFort:ctor()
    UIUpgradeFort.super.ctor(self);
    self.upgrade = nil;
    self.backBtn = nil;
    self.unseamBtn = nil;
end

--注册控件
function UIUpgradeFort:DoDataExchange()
    self.upgrade=self:RegisterController(UnityEngine.UI.Button,"upgrade");
    self.backBtn=self:RegisterController(UnityEngine.UI.Button,"backBtn");
    self.unseamBtn=self:RegisterController(UnityEngine.UI.Button,"unseamBtn");
end

--注册按钮点击事件
function UIUpgradeFort:DoEventAdd()
    self:AddListener(self.upgrade.gameObject,self.OnClickUpgradeBtn);
    self:AddListener(self.backBtn.gameObject,self.OnClickBackBtn);
    self:AddListener(self.unseamBtn.gameObject,self.OnClickUnseamBtn);
end

--升级点击事件
function UIUpgradeFort:OnClickUpgradeBtn()
    print("要塞升级了");
    UIService:Instance():HideUI(UIType.UIUpgradeFort);
    UIService:Instance():HideUI(UIType.UITheFort);
end

--返回按钮点击事件
function UIUpgradeFort:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIUpgradeFort);
end

--拆除点击事件
function UIUpgradeFort:OnClickUnseamBtn()
    UIService:Instance():ShowUI(UIType.UIAffirmUnseam);
end

return UIUpgradeFort;
