--[[
    要塞介绍界面
--]]
local UIBase= require("Game/UI/UIBase");
local UIFortExplain=class("UIFortExplain",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UIFortExplain:ctor()
    UIFortExplain.super.ctor(self);
    self.confirmBtn = nil;
end

--注册控件
function UIFortExplain:DoDataExchange()
  self.confirmBtn=self:RegisterController(UnityEngine.UI.Button,"confirmBtn");  
end

--注册按钮点击事件
function UIFortExplain:DoEventAdd()
  self:AddListener(self.confirmBtn.gameObject,self.OnClickConfirmBtn);  
end

--按钮点击事件
function UIFortExplain:OnClickConfirmBtn()
    UIService:Instance():HideUI(UIType.UIFortExplain);
end

return UIFortExplain;
