local UIBase = require("Game/UI/UIBase")

local RevenueStatisticsPanel = class("RevenueStatisticsPanel",UIBase)
local UIService=require("Game/UI/UIService")
local FacilityType = require("Game/Facility/FacilityType")
local UIType=require("Game/UI/UIType")


function RevenueStatisticsPanel:ctor()
	RevenueStatisticsPanel.super.ctor(self)
	self._button = nil;
	self.MuangNumberText = nil;
	self.XButton = nil;
	self.DefendersNumberText = nil;
end

function RevenueStatisticsPanel:DoDataExchange()  
 	self._button = self:RegisterController(UnityEngine.UI.Button,"RevenueStatisticsImage/Button");
 	self.MuangNumberText = self:RegisterController(UnityEngine.UI.Text,"RevenueStatisticsImage/MuangNumberText")
 	self.XButton = self:RegisterController(UnityEngine.UI.Button,"RevenueStatisticsImage/XButton")
 	self.DefendersNumberText = self:RegisterController(UnityEngine.UI.Text,"RevenueStatisticsImage/DefendersNumberText");
end

function RevenueStatisticsPanel:OnShow()
	local revenue = PlayerService:Instance():GetIntroductionsRevenueGold();
	local wildRevenue = PlayerService:Instance():GetWildCityRevenueGold();
	self.MuangNumberText.text = revenue
	self.DefendersNumberText.text = wildRevenue
end

--注册点击事件
function RevenueStatisticsPanel:DoEventAdd()    
	self:AddOnClick(self._button,self.OnCilckExitBtn);
	self:AddOnClick(self.XButton,self.OnClickXButton);
end

function RevenueStatisticsPanel:OnCilckExitBtn()
	UIService:Instance():HideUI(UIType.RevenueStatisticsPanel)
end

function RevenueStatisticsPanel:OnClickXButton()
	UIService:Instance():HideUI(UIType.RevenueStatisticsPanel)
end

-- --民居税收
-- function RevenueStatisticsPanel:SetResidence()
-- 	local ResidenceGold = 0;
-- 	local mainCityTitled = PlayerService:Instance():GetMainCityTiledId();
-- 	local buildingId = BuildingService:Instance():GetBuildingByTiledId(mainCityTitled)._id;
-- 	local Residence = FacilityService:Instance():GetFacilitylevelByIndex(buildingId,FacilityType.Residence);
-- 	for i=1, Residence do
-- 		ResidenceGold = ResidenceGold + 150
-- 	end
-- 	return ResidenceGold;
-- end
-- --仓库税收
-- function RevenueStatisticsPanel:SetWareHouse()
-- 	local mainCityTitled = PlayerService:Instance():GetMainCityTiledId();
-- 	local buildingId = BuildingService:Instance():GetBuildingByTiledId(mainCityTitled)._id;
-- 	local WareHouse = FacilityService:Instance():GetFacilitylevelByIndex(buildingId,FacilityType.WareHouse);
-- 	if WareHouse == 20 then
-- 		return 1000
-- 	end
-- 	return 0
-- end


return RevenueStatisticsPanel