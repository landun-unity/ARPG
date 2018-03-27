--[[
    内政界面
--]]

local UIBase= require("Game/UI/UIBase");
local UIInternal=class("UIInternal",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
    
--构造函数
function UIInternal:ctor()
    UIInternal.super.ctor(self);
    self.backBtn = nil;
end

--注册控件
function UIInternal:DoDataExchange()
  self.backBtn=self:RegisterController(UnityEngine.UI.Button,"XImage");  
end

--注册控件点击事件
function UIInternal:DoEventAdd()
  self:AddListener(self.backBtn,self.OnClickBackBtn);  
end

--点击返回按钮
function UIInternal:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIInternal);
end

return UIInternal;