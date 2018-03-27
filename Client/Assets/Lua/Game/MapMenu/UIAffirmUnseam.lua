--[[
    确定放弃自建要塞界面
--]]
local UIBase= require("Game/UI/UIBase");
local UIAffirmUnseam=class("UIAffirmUnseam",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UIAffirmUnseam:ctor()
    UIAffirmUnseam.super.ctor(self);
    self.backBtn = nil;
    self.confirmBtn = nil;
end

--注册控件
function UIAffirmUnseam:DoDataExchange()
    self.confirmBtn=self:RegisterController(UnityEngine.UI.Button,"confirmBtn");
    self.backBtn=self:RegisterController(UnityEngine.UI.Button,"backBtn");    
end

--注册点击事件
function UIAffirmUnseam:DoEventAdd()
    self:AddListener(self.confirmBtn.gameObject,self.OnClickConfirmBtn);
    self:AddListener(self.backBtn.gameObject,self.OnClickBackBtn);    
end

--确定按钮点击事件
function UIAffirmUnseam:OnClickConfirmBtn()
    print("要塞已拆除");
    UIService:Instance():HideUI(UIType.UIAffirmUnseam);
    UIService:Instance():HideUI(UIType.UIUpgradeFort);
    UIService:Instance():HideUI(UIType.UITheFort);
end

--取消按钮点击事件
function UIAffirmUnseam:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIAffirmUnseam);
end

return UIAffirmUnseam;