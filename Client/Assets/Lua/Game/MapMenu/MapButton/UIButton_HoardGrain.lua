--[[
	producer:ww
	date 16-12-29
	--屯田
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_HoardGrain = class("UIButton_HoardGrain",UIBase);

function UIButton_HoardGrain:ctor()
	UIButton_HoardGrain.super.ctor(self);
end

function UIButton_HoardGrain:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_HoardGrain:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_HoardGrain:ButtonOnClick()

end

return UIButton_HoardGrain;