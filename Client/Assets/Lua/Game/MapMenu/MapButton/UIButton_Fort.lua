--[[
	producer:ww
	date 16-12-29
	--要塞
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_Fort = class("UIButton_Fort",UIBase);

function UIButton_Fort:ctor()
	UIButton_Fort.super.ctor(self);
end

function UIButton_Fort:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Fort:ShowButton(tiled)
	
end

--按钮点击事件
function UIButton_Fort:ButtonOnClick()

end

return UIButton_Fort;