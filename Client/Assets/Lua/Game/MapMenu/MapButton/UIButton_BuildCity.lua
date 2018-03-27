--[[
	producer:ww
	date 16-12-29
	--筑城
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_BuildCity = class("UIButton_BuildCity",UIBase);

function UIButton_BuildCity:ctor()
	UIButton_BuildCity.super.ctor(self);
end

function UIButton_BuildCity:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_BuildCity:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_BuildCity:ButtonOnClick()

end

return UIButton_BuildCity;