--[[
    Name:城设施界面
--]]

local UIBase= require("Game/UI/UIBase")

local UIFacilityUpgrade=class("UIFacility",UIBase)

-- local UIService=require("Game/UI/UIService")
-- local UIType=require("Game/UI/UIType")

--构造函数
function UIBegin:ctor()
	UIFacility.super.ctor(self);
	--设施按钮
	self._upgrade = nil;
end

--注册控件
function UIBegin:DoDataExchange()
   self._upgrade = self:RegisterController(UnityEngine.UI.Button,"Upgrade")
end

--注册控件点击事件
function UIBegin:DoEventAdd()
   self:AddListener(self._upgrade,self.OnClickUpgradeFacility)
end


--点击升级建筑按钮逻辑
function UIBegin.OnClickUpgradeFacility(self)
     UIService:Instance():ShowUI(UIType.UIInternal);
end

return UIFacilityUpgrade;