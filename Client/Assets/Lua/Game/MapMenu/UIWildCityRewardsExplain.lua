local UIBase = require("Game/UI/UIBase");
local UIWildCityRewardsExplain = class("UIWildCityRewardsExplain", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
-- 构造函数
function UIWildCityRewardsExplain:ctor()
	UIWildCityRewardsExplain.super.ctor(self);
	self.Button = nil;
	self.buttons = nil;
end

function UIWildCityRewardsExplain:DoDataExchange()
	self.Button = self:RegisterController(UnityEngine.UI.Button,"Negative/Button");
	self.buttons = self:RegisterController(UnityEngine.UI.Button,"Panel");
end

function UIWildCityRewardsExplain:DoEventAdd()
    self:AddListener(self.Button, self.OnClickButton);
    self:AddListener(self.buttons, self.OnClickButtons)
end

function UIWildCityRewardsExplain:OnClickButton()
	UIService:Instance():HideUI(UIType.UIWildCityRewardsExplain);
end

function UIWildCityRewardsExplain:OnClickButtons()
	UIService:Instance():HideUI(UIType.UIWildCityRewardsExplain);
end


return UIWildCityRewardsExplain