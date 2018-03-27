--[[
	producer:ww
	date 16-12-29
	--驻守
]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local SelfLand = require("Game/MapMenu/SelfLand");
local UIService = require("Game/UI/UIService");
local UIButton_Garrison = class("UIButton_Garrison",UIBase);

function UIButton_Garrison:ctor()
	UIButton_Garrison.super.ctor(self);
	self.curTiledIndex = nil
end

function UIButton_Garrison:DoEventAdd()
	self:AddListener(self.gameObject:GetComponent(typeof(UnityEngine.UI.Button)),self.ButtonOnClick);
end

function UIButton_Garrison:ShowButton(tiled)
	self.curTiledIndex = tiled:GetIndex()
end

--按钮点击事件
function UIButton_Garrison:ButtonOnClick()
    if NewerPeriodService:Instance():CanGarrison() == false then
        return;
    end

    if PlayerService:Instance():IsHaveCanSendArmy() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 144);
        return;
    end

	MapService:Instance():HideTiled()
    UIService:Instance():HideUI(UIType.UIGameMainView)
    local param = {}
    param.troopsNum = 1
    param.troopType = SelfLand.garrison
    param.tiledIndex = self.curTiledIndex
    UIService:Instance():ShowUI(UIType.UISelfLandFunction,param);
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid)
end

return UIButton_Garrison;