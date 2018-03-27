--[[
	producer:ww
	date:16-12-29
	--扫荡
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIButton_Sweep = class("UIButton_Sweep",UIBase);
local SelfLand = require("Game/MapMenu/SelfLand");

function UIButton_Sweep:ctor()
	UIButton_Sweep.super.ctor(self);
	self.curTiledIndex = nil;
end

function UIButton_Sweep:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Sweep:ShowButton(tiled)
	self.curTiledIndex = tiled:GetIndex()
end


--按钮点击事件
function UIButton_Sweep:ButtonOnClick()
	MapService:Instance():HideTiled();
	local param = {};
    param.troopsNum = 1;
    param.troopType = SelfLand.loot;
    param.tiledIndex = self.curTiledIndex;
    self:ShowUISelfLand(SelfLand.loot);
    UIService:Instance():HideUI(UIType.UIGameMainView);
end

return UIButton_Sweep;