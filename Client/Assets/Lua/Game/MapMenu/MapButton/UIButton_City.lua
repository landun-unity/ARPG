--[[
	producer:ww
	date 16-12-29
	--城市
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_City = class("UIButton_City",UIBase);

function UIButton_City:ctor()
	UIButton_City.super.ctor(self);
end

function UIButton_City:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_City:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_City:ButtonOnClick()

end

return UIButton_City;