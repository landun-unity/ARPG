--[[
	producer:ww
	date 16-12-29
	--调动
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_Transfer = class("UIButton_Transfer",UIBase);

function UIButton_Transfer:ctor()
	UIButton_Transfer.super.ctor(self);
end

function UIButton_Transfer:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Transfer:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_Transfer:ButtonOnClick()

end

return UIButton_Transfer;