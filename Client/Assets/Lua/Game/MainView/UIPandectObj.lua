--[[
	主城总览
	ww
	2016.11.23
--]]

local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIPandectObj = class("UIPandectObj",UIBase);
require("Game/Table/InitTable");
local BuildingType = require("Game/Build/BuildingType");
local List = require("Common/List");
local FacilityService = require("Game/Facility/FacilityService");
require("Game/Facility/FacilityProperty");
local FacilityType = require("Game/Facility/FacilityType");
local BuildingService = require("Game/Build/BuildingService");
local City = require("Game/Build/Subject/City");
require("Game/Player/CurrencyEnum");
--require("")
--[[
	构造函数
--]]
function UIPandectObj:ctor()
	-- body
	UIPandectObj.super.ctor(self);
	self._returnBtn = nil; --返回按钮
	self._buildingType = 0;	--建筑类型
	self._troopsTable = nil;

--[[
	背景图片
--]]
	self._castellanMansionImage = nil; 	--城主府信息背景图片
	self._economyImage = nil;          	--经济信息背景图片
	self._pointGeneralImage = nil;	  	--点将信息背景图片
	self._troopsImage = nil;			--部队信息背景图片
	self._cityDefenseImage = nil;		--城防信息背景图片
	self._sajikImage = nil;				--社稷坛信息背景图片
	self._heavenPalaceImage = nil;		--封禅台信息背景图片


--[[
	信息table
--]]
	self._castellanMansionInfoList = {}	--城主府信息
	self._economyInfoList = {}			--经济信息
	self._pointGeneralInfoList = {}		--点将信息
	self._troopsInfoList = {}			--部队信息
	self._cityDefenseInfoList = {}		--城防信息
	self._sajikInfoList = {}			--社稷坛信息
	self._heavenPalaceInfoList = {}		--封禅台信息

--[[
	信息grid
--]]
	self._castellanMansionGrid = nil;
	self._troopsGrid = nil;
	self._economyGrid = nil;
	self._cityDefenseGrid = nil;
	self._pointGeneralGrid = nil;
	self._heavenPalaceGrid = nil;
	self._sajikGrid = nil;

	self._tiled = nil;
	self._building = nil;
	self._buildingId = 0;
	self._level = 0;
end

--[[
	注册组件
--]]
function UIPandectObj:DoDataExchange()
	-- body
	self._returnBtn = self:RegisterController(UnityEngine.UI.Button,"ReturnBtn");
		-- 获取背景图片
	self._troopsImage = self:RegisterController(UnityEngine.RectTransform,"TroopsImage"); --部队
	self._economyImage = self:RegisterController(UnityEngine.RectTransform,"EconomyImage");--经济
	self._cityDefenseImage = self:RegisterController(UnityEngine.RectTransform,"CityDefenseImage");--城防
	self._pointGeneralImage = self:RegisterController(UnityEngine.RectTransform,"PointGeneralImage");--点将
	self._castellanMansionImage = self:RegisterController(UnityEngine.RectTransform,"CastellanMansionImage");--城主府
	self._heavenPalaceImage = self:RegisterController(UnityEngine.RectTransform,"HeavenPalaceImage");--封禅台
	self._sajikImage = self:RegisterController(UnityEngine.RectTransform,"SajikImage");	--社稷坛
		--获取标题text组件(只需要修改城主府的标题)
	self._castellanMansionTip = self:RegisterController(UnityEngine.UI.Text,"CastellanMansionImage/HeadlineImage/HeadlineText");

	self._castellanMansionGrid = self:RegisterController(UnityEngine.Transform,"CastellanMansionImage/Grid");
	self._troopsGrid = self:RegisterController(UnityEngine.Transform,"TroopsImage/Grid");
	self._economyGrid = self:RegisterController(UnityEngine.Transform,"EconomyImage/Grid");
	self._cityDefenseGrid = self:RegisterController(UnityEngine.Transform,"CityDefenseImage/Grid");
	self._pointGeneralGrid = self:RegisterController(UnityEngine.Transform,"PointGeneralImage/Grid");
	self._heavenPalaceGrid = self:RegisterController(UnityEngine.Transform,"HeavenPalaceImage/Grid");
	self._sajikGrid = self:RegisterController(UnityEngine.Transform,"SajikImage/Grid");
end

--[[
	查找是否存在该设施
--]]
function UIPandectObj:FindFacitily(Type)
	-- body
	self._level = FacilityService:Instance():GetFacilitylevelByIndex(self._buildingId,Type);
	if self._level == 0 or nil then	
		return false;
	else
		return true;
	end 
	
end


--[[
	动态创建Text
--]]
function UIPandectObj:DynamicCreatUIText(parentObj,str)
	--body
	local UITextBox = require("Game/MainView/UITextBox").new();
	GameResFactory.Instance():GetUIPrefab("UIPrefab/TextBox",parentObj,UITextBox,function (go)
			UITextBox:Init();
            UITextBox:ShowText(str);
        end);
end

--[[
	根据设施存在与否显示总览信息
--]]
function UIPandectObj:ShowInfoAccordingFacility(UIFacilityImage,Type)
	-- body	
	if self:FindFacitily(Type) == false then
		UIFacilityImage.gameObject:SetActive(false);
	else
		UIFacilityImage.gameObject:SetActive(true);
	end
end

--[[
	根据信息显示的多少设置背景图片高度
--]]

function UIPandectObj:SetImageHeight(Image,InfoListCount)
	-- body
	--print(50 + InfoListCount * 20); 
	Image.sizeDelta =Vector2.New(250,50 + InfoListCount * 20);
	
end
--[[
	将主城信息保存到声明的table中
--]]
function UIPandectObj:SaveCastellanMansionInfo()	
	local tiledid = self._building:GetIndex();
	local tiled = MapService:Instance():GetTiledByIndex(tiledid);
	self._castellanMansionInfoList.Durable = "耐久度 "..tiled:GetDurable().."/"..tiled.tiledInfo.maxDurableVal;
			--self._building:GetCityPropertyByFacilityProperty(FacilityProperty.DurableMax)-self._building._durabilityCost.."/"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.DurableMax);
	--self._castellanMansionInfoList.ExpandTime = "已扩建 "..self._building:GetCityExpandTimes().."/"..8;
	self:DynamicCreatUIText(self._castellanMansionGrid,self._castellanMansionInfoList.Durable);
	-- self:DynamicCreatUIText(self._castellanMansionGrid,self._castellanMansionInfoList.ExpandTime);
end

--[[
	将经济信息保存到声明的Table中
--]]
function UIPandectObj:SaveEconomyInfo()
	-- body
	self._economyInfoList.resourcesMax = "仓库上限 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.ResourcesMax);
	self._economyInfoList.wood = "木材产量 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Wood);
	self._economyInfoList.iron = "铁矿产量 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Iron);
	self._economyInfoList.stone = "石料产量 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Stone);
	self._economyInfoList.food = "粮草产量 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Food);
	if self:FindFacitily(FacilityType.MarketHouse) then
		self._economyInfoList.ratio = "交易比率 +"..(self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Transaction)/100).."%";
		self:DynamicCreatUIText(self._economyGrid,self._economyInfoList.ratio);
	end	
	self:DynamicCreatUIText(self._economyGrid,self._economyInfoList.resourcesMax);
	self:DynamicCreatUIText(self._economyGrid,self._economyInfoList.wood);
	self:DynamicCreatUIText(self._economyGrid,self._economyInfoList.iron);
	self:DynamicCreatUIText(self._economyGrid,self._economyInfoList.stone);
	self:DynamicCreatUIText(self._economyGrid,self._economyInfoList.food);
end


--[[
	将部队信息保存到声明的Table中
--]]
function UIPandectObj:SaveTroopsInfo()
	-- body
	self._troopsInfoList.armyCount = "本城部队数 "..#ArmyService:Instance():GetHaveBackArmy(self._building._id).."/"..FacilityService:Instance():GetCityPropertyByFacilityProperty(self._building._id, FacilityProperty.ArmyCount);
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.armyCount);
	self._troopsInfoList.troops = "兵力 "..self._building:GetAllArmySoldiers();
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.troops);
	self._troopsInfoList.maintainWood = "维持木材 "..self._building:GetAllKeepArmyCost(CurrencyEnum.Wood);
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.maintainWood);
	self._troopsInfoList.maintainIron = "维持铁矿 "..self._building:GetAllKeepArmyCost(CurrencyEnum.Iron);
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.maintainIron);
	self._troopsInfoList.maintainStone = "维持石料 "..self._building:GetAllKeepArmyCost(CurrencyEnum.Stone);
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.maintainStone);
	self._troopsInfoList.maintainFood = "维持粮草 "..self._building:GetAllKeepArmyCost(CurrencyEnum.Grain);
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.maintainFood);
	self._troopsInfoList.ArmyConscritionCount = "征兵队列数 "..self._building:GetArmyConscritionCount().."/"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.RecruitQueue);
	self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.ArmyConscritionCount);
	if  self:FindFacitily(FacilityType.WarriorHouse) == true or
		self:FindFacitily(FacilityType.DefenseHouse) == true or 
		self:FindFacitily(FacilityType.WindHouse) ==true or 
		self:FindFacitily(FacilityType.MilitaryHouse) == true then
			self._troopsInfoList.litTip = "本城部队属性加成"; 
			self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.litTip);
			if self:FindFacitily(FacilityType.WindHouse) then
				self._troopsInfoList.armySpeed = "  速度 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.ArmySpeed);
				self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.armySpeed);
			end
			if self:FindFacitily(FacilityType.WarriorHouse) then
				self._troopsInfoList.armyStrategy = "  谋略 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.ArmyStrategy);
				self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.armyStrategy);
			end
			if self:FindFacitily(FacilityType.WarriorHouse) then
				self._troopsInfoList.armyAttack = "  攻击 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.ArmyAttack);
				self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.armyAttack);
			end
			if self:FindFacitily(FacilityType.DefenseHouse) then
				self._troopsInfoList.armyDefense = "  防御 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.ArmyDefense);
				self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.armyDefense);
			end
	end
	if self:FindFacitily(FacilityType.CasernHouse) == true then
		self._troopsInfoList.heroArmy = "武将带兵数量 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.NumberTroops);
		self:DynamicCreatUIText(self._troopsGrid,self._troopsInfoList.heroArmy);
	end
end


--[[
	将点将信息存储到列表中
--]]
function UIPandectObj:SavePointGeneralInfo()
	-- body
	self._pointGeneralInfoList.count ="前锋编制 "..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Striker);
	self:DynamicCreatUIText(self._pointGeneralGrid,self._pointGeneralInfoList.count);
	if self:FindFacitily(FacilityType.PointWeiHouse) then
		self._pointGeneralInfoList.pointWei= "【秦】 LV"..FacilityService:Instance():GetFacilitylevelByIndex(self._buildingId,FacilityType.PointWeiHouse);
		self:DynamicCreatUIText(self._pointGeneralGrid,self._pointGeneralInfoList.pointWei);
	end
	if self:FindFacitily(FacilityType.PointShuHouse) then
		self._pointGeneralInfoList.pointShu= "【侍】 LV"..FacilityService:Instance():GetFacilitylevelByIndex(self._buildingId,FacilityType.PointShuHouse);
		self:DynamicCreatUIText(self._pointGeneralGrid,self._pointGeneralInfoList.pointShu);
	end
	if self:FindFacitily(FacilityType.PointWuHouse) then
		self._pointGeneralInfoList.pointWu= "【都铎】 LV"..FacilityService:Instance():GetFacilitylevelByIndex(self._buildingId,FacilityType.PointWuHouse);
		self:DynamicCreatUIText(self._pointGeneralGrid,self._pointGeneralInfoList.pointWu);
	end
	if self:FindFacitily(FacilityType.PointQunHouse) then
		self._pointGeneralInfoList.pointQun= "【维京】 LV"..FacilityService:Instance():GetFacilitylevelByIndex(self._buildingId,FacilityType.PointQunHouse);
		self:DynamicCreatUIText(self._pointGeneralGrid,self._pointGeneralInfoList.pointQun);
	end
end

--[[
	将城防信息存储到列表中
--]]
function  UIPandectObj:SaveCityDefenseInfo()
	-- body
	if self:FindFacitily(FacilityType.WallHouse) then
		self._cityDefenseInfoList.DurableMaxUp = "城区耐久上限 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.TownDurableMax);
		self:DynamicCreatUIText(self._cityDefenseGrid,self._cityDefenseInfoList.DurableMaxUp);
	end
	if self:FindFacitily(FacilityType.AlertHouse) then
		self._cityDefenseInfoList.DefenseArmyCounts = "守城武将兵力 "..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.GarrisonTroops);
		self:DynamicCreatUIText(self._cityDefenseGrid,self._cityDefenseInfoList.DefenseArmyCounts);
	end
	if self:FindFacitily(FacilityType.BeaconHouse) then
		self._cityDefenseInfoList.AlertTime = "预警时间 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.WarningTime).."秒";
		self:DynamicCreatUIText(self._cityDefenseGrid,self._cityDefenseInfoList.AlertTime);
	end
	if self:FindFacitily(FacilityType.ColossusHouse) or self:FindFacitily(FacilityType.SandHouse) then
		self._cityDefenseInfoList.litTip = "防御部队强化 ";
		self:DynamicCreatUIText(self._cityDefenseGrid,self._cityDefenseInfoList.litTip);
		if self:FindFacitily(FacilityType.ColossusHouse) then
			self._cityDefenseInfoList.OnAttackDown = " 受攻击伤害 "..(self._building:GetCityPropertyByFacilityProperty(FacilityProperty.PhysicalInjury)/100).."%";
			self:DynamicCreatUIText(self._cityDefenseGrid,self._cityDefenseInfoList.OnAttackDown);
		end
		if self:FindFacitily(FacilityType.SandHouse) then
			self._cityDefenseInfoList.OnStrategyDown = " 受谋略攻击伤害 "..(self._building:GetCityPropertyByFacilityProperty(FacilityProperty.StrategyInjury)/100).."%";
			self:DynamicCreatUIText(self._cityDefenseGrid,self._cityDefenseInfoList.OnStrategyDown);
		end
	end
end

--[[
	将社稷坛信息存储到列表中
--]]
function UIPandectObj:SaveSajikInfo()
	-- body
	if self:FindFacitily(FacilityType.SajikHouse) then
		self._sajikInfoList.fameMax = "名望上限 +"..self._building:GetCityPropertyByFacilityProperty(FacilityProperty.PrestigeMax);
		self:DynamicCreatUIText(self._sajikGrid,self._sajikInfoList.fameMax);
	end
end


--[[
	将封禅台信息存储到列表中
--]]
function  UIPandectObj:SaveHeavenPalaceInfo()
	-- body
	local cost = self._building:GetCityPropertyByFacilityProperty(FacilityProperty.Cost)-6.5;
	if self:FindFacitily(FacilityType.FengshanHouse) then
		self._heavenPalaceInfoList.captainMax = "统帅上限 +"..cost;
		self:DynamicCreatUIText(self._heavenPalaceGrid,self._heavenPalaceInfoList.captainMax);
	end

end

--[[
	获取信息数量
--]]
function  UIPandectObj:GetListCount(list)
	-- body
	local count = 0;
	for k,v in pairs(list) do
		count = count + 1;
	end
	return count;
end

--[[
	注册事件
--]]
function UIPandectObj:DoEventAdd()
	-- body
	self:AddListener(self._returnBtn,self.OnClickReturnBtn);
end

--[[
	点击返回
--]]
function UIPandectObj:OnClickReturnBtn()
	local param = {};
	param[0] = self._building
	UIService:Instance():HideUI(UIType.UIPandectObj);
	UIService:Instance():ShowUI(UIType.UIMainCity,param);
end

--[[
	显示
--]]
function UIPandectObj:OnShow(param)
	-- body
	if param == nil then
		--print ("param == nil;");
		return 
	end
	self._tiled = param.tiled;
	self._buildingType = param.buildingType;

	if self._tiled:GetBuilding() == nil then
        self._building = self._tiled:GetTown()._building;
        --print(self._building);
    else
        self._building = self._tiled:GetBuilding();
        --print(self._building);
    end

	if self._buildingType == BuildingType.MainCity then
		self._castellanMansionTip.text = "城主府";
		-- self._buildingId = self._tiled:GetId();
		-- self._building = BuildingService:Instance():GetBuilding(self._buildingId);
		self._buildingId = self._building._id;
	elseif self._buildingType == BuildingType.SubCity then
		self._castellanMansionTip.text = "都督府";
		-- self._buildingId = self._tiled:GetId();
		-- self._building = BuildingService:Instance():GetBuilding(self._buildingId);		
		self._buildingId = self._building._id;
	elseif self._buildingType == BuildingType.PlayerFort then
		self._castellanMansionTip.text = "要塞";	
		self:ShowFortInfo(self._tiled);
		return;
	end	

	self:ShowInfoAccordingFacility(self._castellanMansionImage, FacilityType.MainHouse);
	self._economyImage.gameObject:SetActive(false);

	if self:FindFacitily(FacilityType.WoodHouse) or self:FindFacitily(FacilityType.IronHouse) or
		self:FindFacitily(FacilityType.StoneHouse) or self:FindFacitily(FacilityType.FoodHouse) or self:FindFacitily(FacilityType.WareHouse) then
		self:ShowInfoAccordingFacility(self._economyImage, FacilityType.MainHouse);
	end	 
	self:ShowInfoAccordingFacility(self._troopsImage, FacilityType.DrillHouse);
	self:ShowInfoAccordingFacility(self._cityDefenseImage, FacilityType.WallHouse);
	self:ShowInfoAccordingFacility(self._pointGeneralImage, FacilityType.CommanderHouse);
	self:ShowInfoAccordingFacility(self._sajikImage, FacilityType.SajikHouse);
	self:ShowInfoAccordingFacility(self._heavenPalaceImage, FacilityType.FengshanHouse);
	self:ShowInfoAccordingFacility(self._cityDefenseImage, FacilityType.SandHouse);
	self:ShowInfoAccordingFacility(self._cityDefenseImage, FacilityType.ColossusHouse);
	self:SaveCastellanMansionInfo();
	self:SaveEconomyInfo();
	self:SaveTroopsInfo();
	self:SavePointGeneralInfo();
	self:SaveCityDefenseInfo();
	self:SaveSajikInfo();
	self:SaveHeavenPalaceInfo();
	----print (self:GetListCount(self._castellanMansionInfoList));
	self:SetImageHeight(self._castellanMansionImage,self:GetListCount(self._castellanMansionInfoList));
	self:SetImageHeight(self._economyImage,self:GetListCount(self._economyInfoList));
	self:SetImageHeight(self._troopsImage,self:GetListCount(self._troopsInfoList));
	self:SetImageHeight(self._pointGeneralImage,self:GetListCount(self._pointGeneralInfoList));
	self:SetImageHeight(self._cityDefenseImage,self:GetListCount(self._cityDefenseInfoList));
	self:SetImageHeight(self._sajikImage,self:GetListCount(self._sajikInfoList));
	self:SetImageHeight(self._heavenPalaceImage,self:GetListCount(self._heavenPalaceInfoList));
end


--[[
	隐藏
--]]
function UIPandectObj:OnHide()
	-- body
	--[[
	self._castellanMansionGrid:DestroyOldChid();
	self._troopsGrid:DestroyOldChid();
	self._economyGrid:DestroyOldChid();
	self._cityDefenseGrid:DestroyOldChid();
	self._pointGeneralGrid:DestroyOldChid();
	self._heavenPalaceGrid:DestroyOldChid();
	self._sajikGrid:DestroyOldChid();
--]]
	GameResFactory.Instance():DestroyOldChid(self._castellanMansionGrid.gameObject);
	GameResFactory.Instance():DestroyOldChid(self._troopsGrid.gameObject);
	GameResFactory.Instance():DestroyOldChid(self._economyGrid.gameObject);
	GameResFactory.Instance():DestroyOldChid(self._cityDefenseGrid.gameObject);
	GameResFactory.Instance():DestroyOldChid(self._pointGeneralGrid.gameObject);
	GameResFactory.Instance():DestroyOldChid(self._heavenPalaceGrid.gameObject);
	GameResFactory.Instance():DestroyOldChid(self._sajikGrid.gameObject);

	--[[
	local TextObj = nil;
	TextObj = UnityEngine.GameObject.Find("UIPrefab/TextBox");
	print(TextObj);	
	--]]
	
end

function  UIPandectObj:ShowFortInfo(tiled)
	-- body
	self._castellanMansionInfoList = {};
	self._castellanMansionInfoList.Durable = "耐久度 "..tiled:GetDurable().."/"..tiled.tiledInfo.maxDurableVal;
	self:DynamicCreatUIText(self._castellanMansionGrid,self._castellanMansionInfoList.Durable);
	self._castellanMansionImage.gameObject:SetActive(true);
	self._castellanMansionImage.gameObject:SetActive(false);
	self._castellanMansionImage.gameObject:SetActive(true);
	self._economyImage.gameObject:SetActive(false);
	self._pointGeneralImage.gameObject:SetActive(false); 
	self._troopsImage.gameObject:SetActive(false); 
	self._cityDefenseImage.gameObject:SetActive(false); 
	self._sajikImage.gameObject:SetActive(false); 
	self._heavenPalaceImage.gameObject:SetActive(false);
	self:SetImageHeight(self._castellanMansionImage,self:GetListCount(self._castellanMansionInfoList));
	
end


return UIPandectObj;