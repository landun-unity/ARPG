--[[
	producer:ww
	date 16-12-29
	--练兵
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_Train = class("UIButton_Train",UIBase);

function UIButton_Train:ctor()
	UIButton_Train.super.ctor(self);
end

function UIButton_Train:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Train:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_Train:ButtonOnClick()

end

return UIButton_Train;