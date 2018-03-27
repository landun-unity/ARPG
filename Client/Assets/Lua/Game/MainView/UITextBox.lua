--[[
	ww
	2016-11-26
--]]


local UIBase = require("Game/UI/UIBase");
local UITextBox = class("UITextBox",UIBase);


--[[
	构造函数
--]]
function UITextBox:ctor()
	-- body
	UITextBox.super.ctor(self);
	self._contentBox = nil;
end


--[[
	注册控件
--]]
function UITextBox:DoDataExchange()
	-- body
	self._contentBox = self:RegisterController(UnityEngine.UI.Text,"Text");
end

--[[
	显示文本
--]]
function UITextBox:ShowText(str)
	-- body
	self._contentBox.text = str;
end

return UITextBox