--[[
	producer:ww
	date 16-12-29
	--解救
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_Save = class("UIButton_Save",UIBase);

function UIButton_Save:ctor()
	UIButton_Save.super.ctor(self);
end

function UIButton_Save:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Save:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_Save:ButtonOnClick()

end

return UIButton_Save;