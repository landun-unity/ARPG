--[[
	确定建要塞的界面
--]]

local UIBase = require("Game/UI/UIBase")
local UIFortOkBox = class("UIBase", UIBase)
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

function UIFortOkBox:ctor()
	UIFortOkBox.super.ctor(self);
	self.confirmBtn = nil;
	self.closeBtn = nil;
	self.InputField = nil;
	self.tiledIndex = nil;
end
--注册控件
function UIFortOkBox:DoDataExchange()
	self.confirmBtn = self:RegisterController(UnityEngine.UI.Button,"CommonOKOrCancle/BtnParent/OkBtn");
	self.closeBtn = self:RegisterController(UnityEngine.UI.Button,"CommonOKOrCancle/BtnParent/CancleBtn");
	self.InputField = self:RegisterController(UnityEngine.UI.InputField,"CommonOKOrCancle/TipsBg/More/InputField");

end
--注册点击事件
function UIFortOkBox:DoEventAdd()
	self:AddListener(self.confirmBtn,self.OnClickConfirmBtn)
	self:AddListener(self.closeBtn,self.OnClickCloseBtn)
end

function UIFortOkBox:OnShow(index)
	self.tiledIndex = index
	self.InputField.text = ""
end

function UIFortOkBox:OnClickConfirmBtn()
	if self.InputField.text == "要塞" then
		UIService:Instance():HideUI(UIType.UIFortOkBox);
    	UIService:Instance():ShowUI(UIType.UIFort, self.tiledIndex);
	else
		UIService:Instance():ShowUI(UIType.UICueMessageBox,8011)
	end
end
function UIFortOkBox:OnClickCloseBtn()
	UIService:Instance():HideUI(UIType.UIFortOkBox);  	
end
return UIFortOkBox