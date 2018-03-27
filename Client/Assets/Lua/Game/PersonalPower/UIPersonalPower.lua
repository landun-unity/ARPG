--[[
	个人势力
	producer:ww
	date:16-12-16
--]]
local UIBase = require("Game/UI/UIBase");
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local UIPersonalPower = class("UIPersonalPower", UIBase);
local PlayerService = require("Game/Player/PlayerService");
local BuildingService = require("Game/Build/BuildingService");
local MapService = require("Game/Map/MapService");
local DataState = require("Game/Table/model/DataState");
local LeagueService = require("Game/League/LeagueService");
local HeroService = require("Game/Hero/HeroService");
local BuildingType = require("Game/Build/BuildingType");
local FacilityService = require("Game/Facility/FacilityService");
local FacilityType = require("Game/Facility/FacilityType");
local CurrencyType = require("Game/Player/CurrencyEnum");
local LigeanceType = require("Game/PersonalPower/LigeanceType");
local CurrencyEnum = require("Game/Player/CurrencyEnum");
local DataCharacterInitial = require("Game/Table/model/DataCharacterInitial");
local PersonalPowerOpenType = require("Game/PersonalPower/PersonalPowerOpenType");
require("Game/Table/model/DataBuilding");
require("Game/Table/model/DataCharacterFame");
require("Game/Facility/FacilityProperty");
require("Game/Table/model/DataAlliesLevel");
local OldRow = 0;
local NewRow = 0;

--[[
	构造函数	
--]]
function UIPersonalPower:ctor()
    -- body
    UIPersonalPower.instance = self;
    UIPersonalPower.super.ctor(self);

    self._TiledList = { };    --所有的土地
    self._TiledInfoTypeList = {}; --类型，土地字典
    self._TiledTypeList = {}      --类型列表
    self._NeedShowTiledList = {}; --需要显示的土地列表
    self._NeedShowTypeList = {};  --需要显示的类型列表

    self._MainCityList = {};
    self._SubCityList = { };
    self._TownList = { };
    self._FortessList = { }; 
    self._DefenseTownList = {};
    self._LigeanceLv9 = {};
    self._LigeanceLv8 = {};
    self._LigeanceLv7 = {};
    self._LigeanceLv6 = {};
    self._LigeanceLv5 = {};
    self._LigeanceLv4 = {};
    self._LigeanceLv3 = {};
    self._LigeanceLv2 = {};
    self._LigeanceLv1 = {};

    self._SubCityCount = 0;
    self._TownCount = 0;
    self._FortCount = 0;
    self._DefenseTownCount = 0;
    self._Lv1 = 0;
    self._Lv2 = 0;
    self._Lv3 = 0;
    self._Lv4 = 0;
    self._Lv5 = 0;
    self._Lv6 = 0;
    self._Lv7 = 0;
    self._Lv8 = 0;
    self._Lv9 = 0;

    self._UILigeanceToggleStatuList = {};  --Toggle状态列表

    self._Grid_ToggleGrid = nil;
    self._Grid_InfoGrid = nil;
    self._UILigeanceInfoList = { };         --土地信息预制列表
    self._UILigeanceToggleList = {};        --土地单选框预制列表

    self._WoodTiledProduction = 0;
    self._IronTiledProduction = 0;
    self._StoneTiledProduction = 0;
    self._FoodTiledProduction = 0;

    self._WoodFacilityProduction = 0;
    self._IronFacilityProduction = 0;
    self._StoneFacilityProduction = 0;
    self._FoodFacilityProduction = 0;

    self._WoodModifier = 0;
    self._IronModifier = 0;
    self._StoneModifier = 0;
    self._FoodModifier = 0;

    self._WildCityWood = 0;
    self._WildCityIron = 0;
    self._WildCityStone = 0;
    self._WildCityFood = 0;

    self._WoodTotal = 0;
    self._IronTotal = 0;
    self._StoneTotal = 0;
    self._FoodTotal = 0;

    self._WoodCost = 0;
    self._IronCost = 0;
    self._StoneCost = 0;
    self._FoodCost = 0;



    -- 父物体
    self._Obj_BaseInfo = nil;
    -- 基本信息
    self._Obj_TerritoryInfo = nil;
    -- 领地信息
    self._Obj_ResourceInfo = nil;
    -- 资源信息
    -- 按钮
    self._Button_BaseInfo = nil;
    -- 基本信息按钮
    self._Button_TerritoryInfo = nil;
    -- 领地信息按钮
    self._Button_ResourceInfo = nil;
    -- 资源信息按钮
    self._Button_Close = nil;
    -- 关闭按钮
    self._Button_League = nil;
    -- 同盟按钮
    self._Button_RankingList = nil;
    -- 排行榜按钮
    self._Button_ChangePlayerProfile = nil;
    -- 修改个人说明按钮
    self._Button_Share = nil;
    -- 分享按钮
    self._Button_AllSelect = nil;
    -- 全选按钮
    self._Button_AllCancel = nil;
    -- 全部取消按钮
    self._Button_TerritoryProduction = nil;
    -- 领地产量按钮
    self._Button_ProductionFacilities = nil;
    -- 设施产量按钮
    self._Button_AllianceAddition = nil;
    -- 同盟加成按钮
    self._Button_CityBonus = nil;
    -- 城池加成按钮
    self._Button_MaintainConsumption = nil;
    -- 维持消耗按钮
    -- 文本框
    self._Text_TerrutoryTimder = nil;
    self._Text_TerrutoryIron = nil;
    self._Text_TerrutoryStone = nil;
    self._Text_TerrutoryGrain = nil;

    self._Text_FacilityTimder = nil;
    self._Text_FacilityIron = nil;
    self._Text_FacilityStone = nil;
    self._Text_FacilityGrain = nil;

    self._Text_LeagueTimder = nil;
    self._Text_LeagueIron = nil;
    self._Text_LeagueStone = nil;
    self._Text_LeagueGrain = nil;

    self._Text_CityTimder = nil;
    self._Text_CityIron = nil;
    self._Text_CityStone = nil;
    self._Text_CityGrain = nil;

    self._Text_MaintainTimder = nil;
    self._Text_MaintainIron = nil;
    self._Text_MaintainStone = nil;
    self._Text_MaintainGrain = nil;

    self._Text_TotalTimder = nil;
    self._Text_TotalIron = nil;
    self._Text_TotalStone = nil;
    self._Text_TotalGrain = nil;

    self._Text_Name = nil;
    self._Text_ID = nil;
    self._Text_PowerValue = nil;
    self._Text_State = nil;
    self._Text_Leagua = nil;
    self._Text_General = nil;
    self._Text_ArmyCounts = nil;
    self._Text_AllTroops = nil;
    self._Text_Ligeance = nil;
    self._Text_SubCity = nil;
    self._Text_Fortress = nil;
    self._Text_TimderProduction = nil;
    self._Text_StoneProduction = nil;
    self._Text_IronProduction = nil;
    self._Text_GrainProduction = nil;
    self._Text_MoneyProduction = nil;
    self._Text_FeatProduction = nil;
    self._Text_PersonalInfo = nil;
    self._Grid_InfoGridBG = nil;

    self._ToggleNeedInitCount = 12;
    self._InfoNeedInitCount = 8;
    self._ImageHight = 100;
    self.ScorllPos =0;
end

-- 单例
function UIPersonalPower:Instance()
    return UIPersonalPower.instance;
end

function UIPersonalPower:OnInit()
    for i = 1 , self._ToggleNeedInitCount do
        self:InitCreatToggle();
    end
    for i = 1 ,self._InfoNeedInitCount do
        self:InitCreatInfo();
    end
end
--[[
	注册组件
]]
function UIPersonalPower:DoDataExchange()
    -- body
    -- 注册物体
    self._Obj_BaseInfo = self:RegisterController(UnityEngine.RectTransform, "background/LitBackGround/BaseInfoObj");
    self._Obj_TerritoryInfo = self:RegisterController(UnityEngine.RectTransform, "background/LitBackGround/LigeanceObj");
    self._Obj_ResourceInfo = self:RegisterController(UnityEngine.RectTransform, "background/LitBackGround/ResourceObj");
    -- 注册按钮
    self._Button_BaseInfo = self:RegisterController(UnityEngine.UI.Button, "background/BaseInfoButton");
    self._Button_ResourceInfo = self:RegisterController(UnityEngine.UI.Button, "background/ResourceInfoButton");
    self._Button_TerritoryInfo = self:RegisterController(UnityEngine.UI.Button, "background/TerritoryInfoButton");
    self._Button_League = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/BaseInfoObj/TranslucenceImage1/Image");
    self._Button_RankingList = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/RankingListButton");
    self._Button_Share = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/BaseInfoObj/ShareButton");
    self._Button_ChangePlayerProfile = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/BaseInfoObj/TranslucenceImage3/ChangePersonalInfoButton");
    self._Button_Close = self:RegisterController(UnityEngine.UI.Button, "background/Button_Back");
    self._Button_AllSelect = self:RegisterController(UnityEngine.UI.Button,"background/LitBackGround/LigeanceObj/TranslucenceImage/NotOpenedBorderImage/Image/Button");
    self._Button_AllCancel = self:RegisterController(UnityEngine.UI.Button,"background/LitBackGround/LigeanceObj/TranslucenceImage/NotOpenedBorderImage/Image/Button1");

    self._Button_TerritoryProduction = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/ResourceObj/TerritoryProductionImage/TerritoryProductionButton");
    self._Button_ProductionFacilities = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/ResourceObj/ProductionFacilitiesImage/ProductionFacilitiesButton");
    self._Button_AllianceAddition = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/ResourceObj/AllianceAdditionImage/AllianceAdditionButton/")
    self._Button_CityBonus = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/ResourceObj/CityBonusImage/CityBonusButton");
    self._Button_MaintainConsumption = self:RegisterController(UnityEngine.UI.Button, "background/LitBackGround/ResourceObj/MaintainConsumptionImage/MaintainConsumptionButton");


    -- 注册文本
    self._Text_Name = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage/NameObj/Text");
    self._Text_ID = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage/IDText/Text");
    self._Text_PowerValue = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage/PowerValueText/Text");
    self._Text_State = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage/StateText/Text");
    self._Text_Leagua = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage1/Image/Text");
    self._Text_General = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/GeneralText/Text");
    self._Text_ArmyCounts = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/TroopslText/Text");
    self._Text_AllTroops = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/AllMilitaryStrengthText/Text");
    self._Text_Ligeance = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/LigeanceText/Text");
    self._Text_SubCity = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/DivideCityText/Text");
    self._Text_Fortress = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/FortressText/Text");
    self._Text_Feat = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/WuXunText/WuXunImage/WuXunText/NumberText");
    self._Text_TimderProduction = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/YieldText/TimberImage/TimberText/NumberText");
    self._Text_StoneProduction = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/YieldText/IronImage/IronText/NumberText");
    self._Text_IronProduction = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/YieldText/StoneImage/StoneText/NumberText");
    self._Text_GrainProduction = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/YieldText/GrainImage/GrainText/NumberText");
    self._Text_MoneyProduction = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage2/YieldText/CopperImage/CopperText/NumberText");
    self._Text_PersonalInfoNotice = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage3/Text1");
    self._Text_PersonalInfo = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/BaseInfoObj/TranslucenceImage3/Text");

    self._Text_TerrutoryTimder = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/TerritoryProductionImage/TimberText");
    self._Text_TerrutoryIron = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/TerritoryProductionImage/IronText");
    self._Text_TerrutoryStone = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/TerritoryProductionImage/StoneText");
    self._Text_TerrutoryGrain = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/TerritoryProductionImage/GrainText");

    self._Text_FacilityTimder = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionFacilitiesImage/TimberText");
    self._Text_FacilityIron = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionFacilitiesImage/IronText");
    self._Text_FacilityStone = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionFacilitiesImage/StoneText");
    self._Text_FacilityGrain = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionFacilitiesImage/GrainText");

    self._Text_LeagueTimder = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/AllianceAdditionImage/TimberText/")
    self._Text_LeagueIron = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/AllianceAdditionImage/IronText/")
    self._Text_LeagueStone = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/AllianceAdditionImage/StoneText/")
    self._Text_LeagueGrain = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/AllianceAdditionImage/GrainText/")

    self._Text_CityTimder = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/CityBonusImage/TimberText");
    self._Text_CityIron = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/CityBonusImage/IronText");
    self._Text_CityStone = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/CityBonusImage/StoneText");
    self._Text_CityGrain = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/CityBonusImage/GrainText");

    self._Text_MaintainTimder = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/MaintainConsumptionImage/TimberText");
    self._Text_MaintainIron = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/MaintainConsumptionImage/IronText");
    self._Text_MaintainStone = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/MaintainConsumptionImage/StoneText");
    self._Text_MaintainGrain = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/MaintainConsumptionImage/GrainText");

    self._Text_TotalTimder = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionTotalImage/TimberText");
    self._Text_TotalIron = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionTotalImage/IronText");
    self._Text_TotalStone = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionTotalImage/StoneText");
    self._Text_TotalGrain = self:RegisterController(UnityEngine.UI.Text, "background/LitBackGround/ResourceObj/ProductionTotalImage/GrainText");

    self._Image_Mark = self:RegisterController(UnityEngine.UI.Image, "background/Image");

    self._Grid_ToggleGrid = self:RegisterController(UnityEngine.RectTransform, "background/LitBackGround/LigeanceObj/TranslucenceImage/NotOpenedBorderImage/ScrollView/Image/Viewport/Content");
    self._Grid_InfoGrid = self:RegisterController(UnityEngine.RectTransform, "background/LitBackGround/LigeanceObj/TranslucenceImage/ScrollView/Viewport/Content");
    self._ScorllView = self:RegisterController(UnityEngine.UI.ScrollRect, "background/LitBackGround/LigeanceObj/TranslucenceImage/ScrollView");
    self._Grid_InfoGrid.sizeDelta = Vector2.New(self._Grid_InfoGrid.rect.width,self._InfoNeedInitCount * self._ImageHight);
end

--[[
	显示
]]
function UIPersonalPower:OnShow(showType)
    -- body	

    
    self._SubCityCount = 0;
    self._TownCount = 0;
    self._FortCount = 0;
    self._DefenseTownCount = 0;
    self._Lv1 = 0;
    self._Lv2 = 0;
    self._Lv3 = 0;
    self._Lv4 = 0;
    self._Lv5 = 0;
    self._Lv6 = 0;
    self._Lv7 = 0;
    self._Lv8 = 0;
    self._Lv9 = 0;

    self._WoodTiledProduction = 0;
    self._IronTiledProduction = 0;
    self._StoneTiledProduction = 0;
    self._FoodTiledProduction = 0;

    self._WoodFacilityProduction = 0;
    self._IronFacilityProduction = 0;
    self._StoneFacilityProduction = 0;
    self._FoodFacilityProduction = 0;

    self._WoodModifier = 0;
    self._IronModifier = 0;
    self._StoneModifier = 0;
    self._FoodModifier = 0;

    self._WildCityWood = 0;
    self._WildCityIron = 0;
    self._WildCityStone = 0;
    self._WildCityFood = 0;

    self._WoodTotal = 0;
    self._IronTotal = 0;
    self._StoneTotal = 0;
    self._FoodTotal = 0;

    self._WoodCost = 0;
    self._IronCost = 0;
    self._StoneCost = 0;
    self._FoodCost = 0;

    self:GetAllTiled();
    self:GetCurrencyProductionByLeague();
    self:GetLeagueInfluence();
    self:GetAllTiledInfo();
    self:GetAllFacilityProduction();
    self:GetAllArmyResourceCost();
    self:GetTotalResource();

    self._Text_Name.text = PlayerService:Instance():GetName();
    self._Text_ID.text = tostring(PlayerService:Instance():GetPlayerId());
    self._Text_PowerValue.text = PlayerService:Instance():GetPlayerInfluence()

    self._Text_State.text = self:GetStateName();
    self._Text_Leagua.text = self:GetLeagueName();
    self._Text_General.text = self:GetGeneralCounts() .. "/".. HeroService:Instance():GetCardMaxLimit();
    self._Text_ArmyCounts.text = self:GetArmyCounts() .. "/" .. self:GetCityArmyCountsMax();
    self._Text_AllTroops.text = self:GetAllTroops();
    self._Text_Ligeance.text = #self._TiledList .. "/"..math.floor(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue()/DataGameConfig[516].OfficialData);
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue()>4500 then
        self._Text_SubCity.text = #self._SubCityList.."/"..math.floor((PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue()-4500)/1500);
    else
        self._Text_SubCity.text = #self._SubCityList.."/"..0;
    end
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue()>3500 then
        self._Text_Fortress.text = #self._FortessList.."/"..math.floor((PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue()-3500)/500);
    else
        self._Text_Fortress.text = #self._FortessList.."/"..0;
    end
    self._Text_TimderProduction.text = "" .. math.floor(self._WoodTotal);
    self._Text_StoneProduction.text = "" .. math.floor(self._StoneTotal);
    self._Text_IronProduction.text = "" .. math.floor(self._IronTotal);
    self._Text_GrainProduction.text = "" .. math.floor(self._FoodTotal);
    self._Text_MoneyProduction.text = ""..PlayerService:Instance():GetIntroductionsRevenueGold();
    self._Text_Feat.text = "--";
    self._Text_PersonalInfo.text = "";

    self._Text_TerrutoryTimder.text = "" .. self._WoodTiledProduction;
    self._Text_TerrutoryIron.text = "" .. self._IronTiledProduction;
    self._Text_TerrutoryStone.text = "" .. self._StoneTiledProduction;
    self._Text_TerrutoryGrain.text = "" .. self._FoodTiledProduction;

    self._Text_FacilityTimder.text = self._WoodFacilityProduction;
    self._Text_FacilityIron.text = self._IronFacilityProduction;
    self._Text_FacilityStone.text = self._StoneFacilityProduction;
    self._Text_FacilityGrain.text = self._FoodFacilityProduction;

    self._Text_LeagueTimder.text = "" .. self._WoodModifier * 100 .."%";
    self._Text_LeagueIron.text = "" .. self._IronModifier * 100 .."%";
    self._Text_LeagueStone.text = "" .. self._StoneModifier * 100 .."%";
    self._Text_LeagueGrain.text = "" .. self._FoodModifier * 100 .."%";

    self._Text_CityTimder.text = self._WildCityWood;
    self._Text_CityIron.text = self._WildCityIron;
    self._Text_CityStone.text = self._WildCityStone;
    self._Text_CityGrain.text = self._WildCityFood;

    self._Text_MaintainTimder.text = "" .. self._WoodCost;
    self._Text_MaintainIron.text = "" .. self._IronCost;
    self._Text_MaintainStone.text = "" .. self._StoneCost;
    self._Text_MaintainGrain.text = "" .. self._FoodCost;

    self._Text_TotalTimder.text = "" .. math.floor(self._WoodTotal);
    self._Text_TotalIron.text = "" .. math.floor(self._IronTotal);
    self._Text_TotalStone.text = "" .. math.floor(self._StoneTotal);
    self._Text_TotalGrain.text = "" .. math.floor(self._FoodTotal);
    self:ShowPlayerProfile();
    self:ShowToggle();    
    self:ShowAllSelectOrCancelButton();
    if showType == PersonalPowerOpenType.ResourceOpen then
        self:ResourceInfoButtonOnClick();
    elseif showType == PersonalPowerOpenType.ForceBtnOpen then
         self:BaseInfoButtonOnClick();
    end
    -- self:SubmitAllChangedToggle();
    self:AllSelectButtonOnClick();
   
end

--[[
    显示全部选中和全部取消按钮
]]
function UIPersonalPower:ShowAllSelectOrCancelButton()
    -- body
    for i = 1 ,#self._UILigeanceToggleList do
        if self._UILigeanceToggleList[i]._Toggle_Select.isOn == false and self._UILigeanceToggleList[i].gameObject.activeSelf == true then
            self._Button_AllSelect.gameObject:SetActive(true);
            self._Button_AllCancel.gameObject:SetActive(false);
            return;
        end
    end
    self._Button_AllSelect.gameObject:SetActive(false);
    self._Button_AllCancel.gameObject:SetActive(true);
end


--[[
	显示个人介绍
]]
function UIPersonalPower:ShowPlayerProfile()
    self._Text_PersonalInfo.text = PlayerService:Instance():GetProfile();
    if self._Text_PersonalInfo.text ~= "" then
        self._Text_PersonalInfo.gameObject:SetActive(true);
        self._Text_PersonalInfoNotice.gameObject:SetActive(false);
    else
        self._Text_PersonalInfo.gameObject:SetActive(false);
        self._Text_PersonalInfoNotice.gameObject:SetActive(true);
    end
end

--[[
	注册按钮
]]
function UIPersonalPower:DoEventAdd()
    self:AddListener(self._Button_BaseInfo, self.BaseInfoButtonOnClick);
    self:AddListener(self._Button_TerritoryInfo, self.TerritoryInfoButtonOnClick);
    self:AddListener(self._Button_ResourceInfo, self.ResourceInfoButtonOnClick);
    self:AddListener(self._Button_RankingList, self.RankingListButtonOnClick);
    self:AddListener(self._Button_League, self.LeagueButtonOnClick);
    self:AddListener(self._Button_Share, self.ShareButtonOnClick);
    self:AddListener(self._Button_Close, self.CloseButtonOnClick);
    self:AddListener(self._Button_ChangePlayerProfile, self.ChangePlayerProfileButtonOnClick);
    self:AddListener(self._Button_AllSelect,self.AllSelectButtonOnClick);
    self:AddListener(self._Button_AllCancel,self.AllCancelButtonOnClick);
    self:AddListener(self._Button_TerritoryProduction,self.TerritoryProductionButtonOnClick);
    self:AddListener(self._Button_ProductionFacilities,self.ProductionFacilitiesButtonOnClick);
    self:AddListener(self._Button_AllianceAddition,self.AllianceAdditionButtonOnClick);
    self:AddListener(self._Button_CityBonus,self.CityBonusButtonOnClick);
    self:AddListener(self._Button_MaintainConsumption,self.MaintainConsumptionButtonOnClick);
    self:AddOnValueChanged(self._ScorllView, self.OnChange);
end

function UIPersonalPower:TerritoryProductionButtonOnClick()
    -- body
    local param = {}
    param[1] = "说明";
    param[2] = "所有领地每小时的资源总产量"
    UIService:Instance():ShowUI(UIType.UICommonTipSmall,param)
    local UIBase = UIService:Instance():GetUIClass(UIType.UICommonTipSmall)
    if UIBase ~= nil then
        UIBase.Tips.alignment = 4;
    end
end

function UIPersonalPower:ProductionFacilitiesButtonOnClick()
    -- body
    local param = {}
    param[1] = "说明";
    param[2] = "所有城市设施每小时的资源总产量"
    UIService:Instance():ShowUI(UIType.UICommonTipSmall,param)
    local UIBase = UIService:Instance():GetUIClass(UIType.UICommonTipSmall)
    if UIBase ~= nil then
        UIBase.Tips.alignment = 4;
    end
end

function UIPersonalPower:AllianceAdditionButtonOnClick()
    -- body
    local param = {}
    param[1] = "说明";
    param[2] = "同盟等级提升而获得的资源产量加成"
    UIService:Instance():ShowUI(UIType.UICommonTipSmall,param)
    local UIBase = UIService:Instance():GetUIClass(UIType.UICommonTipSmall)
    if UIBase ~= nil then
        UIBase.Tips.alignment = 4;
    end
end

function UIPersonalPower:CityBonusButtonOnClick()
    -- body
    local param = {}
    param[1] = "说明";
    param[2] = "同盟占领城池而获得的资源产量加成"
    UIService:Instance():ShowUI(UIType.UICommonTipSmall,param)
    local UIBase = UIService:Instance():GetUIClass(UIType.UICommonTipSmall)
    if UIBase ~= nil then
        UIBase.Tips.alignment = 4;
    end
end

function UIPersonalPower:MaintainConsumptionButtonOnClick()
    -- body
    local param = {}
    param[1] = "说明";
    param[2] = "因武将卡所带兵力而引起的每小时产量消耗"
    UIService:Instance():ShowUI(UIType.UICommonTipSmall,param)
    local UIBase = UIService:Instance():GetUIClass(UIType.UICommonTipSmall)
    if UIBase ~= nil then
        UIBase.Tips.alignment = 4;
    end
end

function UIPersonalPower:ShowButtonMark(Button)
    -- body
    if Button.OnSubmit == true then
        self._Image_Mark.gameObject.transform.position = Button.gameObject.transform.position;
        self._Image_Mark.gameObject:SetActive(true);
    end
end



--[[
	点击基本信息按钮
]]
function UIPersonalPower:BaseInfoButtonOnClick()
    -- body
    self._Obj_BaseInfo.gameObject:SetActive(true);
    self._Obj_ResourceInfo.gameObject:SetActive(false);
    self._Obj_TerritoryInfo.gameObject:SetActive(false);
    self._Button_BaseInfo.OnSubmit = true;
    self:ShowButtonMark(self._Button_BaseInfo);
end

--[[
	点击领地信息按钮
]]
function UIPersonalPower:TerritoryInfoButtonOnClick()
    -- body
    self._Obj_BaseInfo.gameObject:SetActive(false);
    self._Obj_ResourceInfo.gameObject:SetActive(false);
    self._Obj_TerritoryInfo.gameObject:SetActive(true);
    self._Button_TerritoryInfo.OnSubmit = true;
    self:ShowButtonMark(self._Button_TerritoryInfo);
end

--[[
	点击资源信息按钮
]]
function UIPersonalPower:ResourceInfoButtonOnClick()
    -- body
    self._Obj_BaseInfo.gameObject:SetActive(false);
    self._Obj_ResourceInfo.gameObject:SetActive(true);
    self._Obj_TerritoryInfo.gameObject:SetActive(false);
    self._Button_ResourceInfo.OnSubmit = true;
    self:ShowButtonMark(self._Button_ResourceInfo);
end

--[[
    点击全部选中按钮
]]
function UIPersonalPower:AllSelectButtonOnClick()
    -- -- body
    for i = 1 ,#self._UILigeanceToggleList do
        self._UILigeanceToggleList[i]._Toggle_Select.isOn = true;
    end
end

--[[
    点击全部取消按钮
]]
function UIPersonalPower:AllCancelButtonOnClick()
    -- -- body
    for i = 1 ,#self._UILigeanceToggleList do
        self._UILigeanceToggleList[i]._Toggle_Select.isOn = false;
    end
end

--[[
	点击排行榜按钮
]]
function UIPersonalPower:RankingListButtonOnClick()
    -- body
    UIService:Instance():ShowUI(UIType.RankListUI);
end

--[[
	点击分享按钮
]]
function UIPersonalPower:ShareButtonOnClick()
    -- body
    print("打开分享界面");
end

--[[
	点击修改个人信息按钮
]]
function UIPersonalPower:ChangePlayerProfileButtonOnClick()
    -- body
    UIService:Instance():ShowUI(UIType.UIPlayerProfile);
end

--[[
	点击同盟名称按钮
]]
function UIPersonalPower:LeagueButtonOnClick()
    -- body
    LeagueService:Instance():SendLeagueMessage(PlayerService:Instance():GetPlayerId());
end

--[[
	点击关闭按钮
]]
function UIPersonalPower:CloseButtonOnClick()
    -- body
    UIService:Instance():HideUI(UIType.UIPersonalPower);
end

--[[
	获取所属州名字
]]
function UIPersonalPower:GetStateName()
    -- body
    local tiledId = PlayerService:Instance():GetMainCityTiledId();
    local stateId = PmapService:Instance():GetStateIDbyIndex(tiledId);
    local mystate = DataState[stateId];
    return mystate.Name;
end

--[[
	获取同盟名称
]]
function UIPersonalPower:GetLeagueName()
    -- body
    local LeagueId = PlayerService:Instance():GetLeagueId();
    local LeagueName = PlayerService:Instance():GetLeagueName();
    if LeagueId == 0 then
        self._Button_League.interactable = false;
        return "[在野]"
    else
        self._Button_League.interactable = true;
        return LeagueName;
    end
end

--[[
	获取武将数量
]]
function UIPersonalPower:GetGeneralCounts()
    -- body
    local counts = HeroService:Instance():GetOwnHeroCount();
    return counts;
end

--[[
	获取所有城市的部队数量上限
]]
function UIPersonalPower:GetCityArmyCountsMax()
    local AllArmyCountsMax = 0;
    for i = 1,#self._MainCityList do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._MainCityList[i].tiledId);
        local ArmyCountMax = FacilityService:Instance():GetCityPropertyByFacilityProperty(building._id, FacilityProperty.ArmyCount);
        AllArmyCountsMax = AllArmyCountsMax + ArmyCountMax;
    end
    for i=1,#self._SubCityList  do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._SubCityList[i].tiledId);
        local ArmyCountMax = FacilityService:Instance():GetCityPropertyByFacilityProperty(building._id, FacilityProperty.ArmyCount);
        AllArmyCountsMax = AllArmyCountsMax + ArmyCountMax;
    end
    return AllArmyCountsMax;
end

--[[
	获取玩家部队数量
]]
function UIPersonalPower:GetArmyCounts()
    -- body
    local AllArmyCounts = 0;
    for i = 1,#self._MainCityList do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._MainCityList[i].tiledId);        
        AllArmyCounts =AllArmyCounts + #ArmyService:Instance():GetHaveBackArmy(building._id);
    end
    for i=1,#self._SubCityList  do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._SubCityList[i].tiledId);        
        AllArmyCounts =AllArmyCounts + #ArmyService:Instance():GetHaveBackArmy(building._id);
    end
    return AllArmyCounts;
end

--[[
	获取所有部队的兵力总和	
]]
function UIPersonalPower:GetAllTroops()
    -- body
    local AllTroopsCounts = 0;

    for i = 1,#self._MainCityList do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._MainCityList[i].tiledId);
        AllTroopsCounts = AllTroopsCounts +building:GetAllArmySoldiers();
    end
    for i=1,#self._SubCityList  do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._SubCityList[i].tiledId);
        AllTroopsCounts = AllTroopsCounts +building:GetAllArmySoldiers();
    end


    return AllTroopsCounts;
end

--[[
	获取可建造分城的上限
]]
function UIPersonalPower:GetSubCityMaxCounts()
    -- body
    local playerFame = 0;
    playerFame = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();              --获取玩家声望
    for i = 1, #DataCharacterFame do
        if playerFame < DataCharacterFame[i].Fame then
            return DataCharacterFame[i-1].CanBuildCity;
        end
    end
end

--[[
	获取所有城池设施资源产量
]]
function UIPersonalPower:GetCurrencyProductionByCity(facilityProperty)
    -- body

    local allProduction = 0;
    for i = 1,#self._MainCityList do
        -- print(self._MainCityList[i].tiledId)
        local building = BuildingService:Instance():GetBuildingByTiledId(self._MainCityList[i].tiledId);
        local production = FacilityService:Instance():GetCityPropertyByFacilityProperty(building._id, facilityProperty);
        allProduction = allProduction + production;
    end
    for i=1,#self._SubCityList  do
        local building = BuildingService:Instance():GetBuildingByTiledId(self._SubCityList[i].tiledId);
        local production = FacilityService:Instance():GetCityPropertyByFacilityProperty(building._id, facilityProperty);
        allProduction = allProduction + production;
    end


    return allProduction;
end
--[[
	获取所有同盟加成
]]
function UIPersonalPower:GetCurrencyProductionByLeague()
    -- body
    local leagueLevel = PlayerService:Instance():GetLeagueLevel();
    if leagueLevel == 0 then
        return;
    end
    self._WoodModifier = DataAlliesLevel[leagueLevel].WoodModifier / 10000;
    self._IronModifier = DataAlliesLevel[leagueLevel].IronModifier / 10000;
    self._StoneModifier = DataAlliesLevel[leagueLevel].StoneModifier / 10000;
    self._FoodModifier = DataAlliesLevel[leagueLevel].FoodModifier / 10000;
end

--[[
	获取所有同盟城池加成
]]
function UIPersonalPower:GetLeagueInfluence()
    local leagueInfluenceList = BuildingService:Instance():GetBeOwnedWildCityList()
    for i = 1, leagueInfluenceList:Count() do
        if leagueInfluenceList:Get(i).occupyLeagueId == PlayerService:Instance():GetLeagueId() then
            local buildingId = leagueInfluenceList:Get(i).buildingId;
            local building = BuildingService:Instance():GetBuilding(buildingId);
            local buildingTableID = building._dataInfo.ID;
            self._WildCityWood = self._WildCityWood + DataBuilding[buildingTableID].Wood;
            self._WildCityIron = self._WildCityIron + DataBuilding[buildingTableID].Iron;
            self._WildCityStone = self._WildCityStone + DataBuilding[buildingTableID].Stone;
            self._WildCityFood = self._WildCityFood + DataBuilding[buildingTableID].Food;
        end
    end
end

--[[
	获取所有领地
]]
function UIPersonalPower:GetAllTiled()
    -- body
    -- end
    local tiledList = PlayerService:Instance():GetAllTiledList();
    for k,v in pairs(tiledList) do
        table.insert(self._TiledList,v);
    end
end

--[[
	获取领地信息
]]
function UIPersonalPower:GetAllTiledInfo()
    -- body
    for i = 1, #self._TiledList do
        local building = BuildingService:Instance():GetBuilding(self._TiledList[i].buildingId);
         
        if building ~= nil then
            -- print("CameIn")
            -- print(building._dataInfo.Type);
            if building._dataInfo.Type == BuildingType.MainCity then
                table.insert(self._MainCityList, self._TiledList[i]);                
            elseif building._dataInfo.Type == BuildingType.SubCity then
                table.insert(self._SubCityList, self._TiledList[i]);
                self._SubCityCount = self._SubCityCount + 1;
            elseif building._dataInfo.Type == BuildingType.PlayerFort then
                table.insert(self._FortessList, self._TiledList[i]);
                self._FortCount = self._FortCount + 1;
            end
        elseif self._TiledList[i].buildingIdForTown ~= 0 or nil then
            local buildingForTown = BuildingService:Instance():GetBuilding(self._TiledList[i].buildingIdForTown);
            if buildingForTown._name ~= nil then
                table.insert(self._TownList, self._TiledList[i]);
                self._TownCount = self._TownCount + 1;
            else
                table.insert(self._DefenseTownList,self._TiledList[i]);
                self._DefenseTownCount = self._DefenseTownCount + 1;
            end
        elseif DataTile[self._TiledList[i].tiledTableId] ~= nil then
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 9 and self._TiledList[i].isHaveTown == 0 then
                self._Lv9 = self._Lv9 + 1;
                table.insert(self._LigeanceLv9,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 8 and self._TiledList[i].isHaveTown == 0 then
                self._Lv8 = self._Lv8 + 1;
                table.insert(self._LigeanceLv8,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 7 and self._TiledList[i].isHaveTown == 0 then
                self._Lv7 = self._Lv7 + 1;
                table.insert(self._LigeanceLv7,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 6 and self._TiledList[i].isHaveTown == 0 then
                self._Lv6 = self._Lv6 + 1;
                table.insert(self._LigeanceLv6,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 5 and self._TiledList[i].isHaveTown == 0 then
                self._Lv5 = self._Lv5 + 1;
                table.insert(self._LigeanceLv5,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 4 and self._TiledList[i].isHaveTown == 0 then
                self._Lv4 = self._Lv4 + 1;
                table.insert(self._LigeanceLv4,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 3 and self._TiledList[i].isHaveTown == 0 then
                self._Lv3 = self._Lv3 + 1;
                table.insert(self._LigeanceLv3,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 2 and self._TiledList[i].isHaveTown == 0 then
                self._Lv2 = self._Lv2 + 1;
                table.insert(self._LigeanceLv2,self._TiledList[i]);
            end
            if DataTile[self._TiledList[i].tiledTableId].TileLv == 1 and self._TiledList[i].isHaveTown == 0 then
                self._Lv1 = self._Lv1 + 1;
                table.insert(self._LigeanceLv1,self._TiledList[i]);
            end
            self:GetTiledResourceProduction(self._TiledList[i]);
        end
    end
    table.insert(self._TiledTypeList,LigeanceType.MainCity)
    self._TiledInfoTypeList[LigeanceType.MainCity] = self._MainCityList;

    if self._SubCityCount > 0 then
        table.insert(self._TiledTypeList,LigeanceType.SubCity)
        self._TiledInfoTypeList[LigeanceType.SubCity] = self._SubCityList;
    end
    if self._TownCount > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Town)
        self._TiledInfoTypeList[LigeanceType.Town] = self._TownList;
    end
    if self._FortCount > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Fort)
        self._TiledInfoTypeList[LigeanceType.Fort] = self._FortessList;
    end
    if self._DefenseTownCount > 0 then
        table.insert(self._TiledTypeList,LigeanceType.DefenseTown);
        self._TiledInfoTypeList[LigeanceType.DefenseTown] = self._DefenseTownList;
    end
    if self._Lv9 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv9)
        self._TiledInfoTypeList[LigeanceType.Lv9] = self._LigeanceLv9;
    end
    if self._Lv8 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv8)
        self._TiledInfoTypeList[LigeanceType.Lv8] = self._LigeanceLv8;
    end
    if self._Lv7 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv7)
        self._TiledInfoTypeList[LigeanceType.Lv7] = self._LigeanceLv7;
    end
    if self._Lv6 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv6)
        self._TiledInfoTypeList[LigeanceType.Lv6] = self._LigeanceLv6;
    end
    if self._Lv5 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv5)
        self._TiledInfoTypeList[LigeanceType.Lv5] = self._LigeanceLv5;
    end
    if self._Lv4 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv4)
        self._TiledInfoTypeList[LigeanceType.Lv4] = self._LigeanceLv4;
    end
    if self._Lv3 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv3)
        self._TiledInfoTypeList[LigeanceType.Lv3] = self._LigeanceLv3;
    end
    if self._Lv2 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv2)
        self._TiledInfoTypeList[LigeanceType.Lv2] = self._LigeanceLv2;
    end
    if self._Lv1 > 0 then
        table.insert(self._TiledTypeList,LigeanceType.Lv1)
        self._TiledInfoTypeList[LigeanceType.Lv1] = self._LigeanceLv1;
    end
end

--[[
	获取所有土地的资源产量
]]
function UIPersonalPower:GetTiledResourceProduction(tiled)
    -- body
    self._WoodTiledProduction = self._WoodTiledProduction + DataTile[tiled.tiledTableId].Wood;
    self._IronTiledProduction = self._IronTiledProduction + DataTile[tiled.tiledTableId].Iron;
    self._StoneTiledProduction = self._StoneTiledProduction + DataTile[tiled.tiledTableId].Stone;
    self._FoodTiledProduction = self._FoodTiledProduction + DataTile[tiled.tiledTableId].Food;
end

--[[
	获取所有产量之和的总产量
]]
function UIPersonalPower:GetTotalResource()
    -- body
    self._WoodTotal = (self._WoodTiledProduction + self._WoodFacilityProduction) * (1 + self._WoodModifier) + self._WildCityWood - self._WoodCost;
    self._IronTotal = (self._IronTiledProduction + self._IronFacilityProduction) * (1 + self._IronModifier) + self._WildCityIron - self._IronCost;
    self._StoneTotal = (self._StoneTiledProduction + self._StoneFacilityProduction) * (1 + self._StoneModifier) + self._WildCityStone - self._StoneCost;
    self._FoodTotal = (self._FoodTiledProduction + self._FoodFacilityProduction) * (1 + self._FoodModifier) + self._WildCityFood - self._FoodCost;
end

--[[
	获取设施产量
]]
function UIPersonalPower:GetAllFacilityProduction()
    -- body
    self._WoodFacilityProduction = self:GetCurrencyProductionByCity(FacilityProperty.Wood)+DataCharacterInitial[1].Yield;
    self._IronFacilityProduction = self:GetCurrencyProductionByCity(FacilityProperty.Iron)+DataCharacterInitial[1].Yield;
    self._StoneFacilityProduction = self:GetCurrencyProductionByCity(FacilityProperty.Stone)+DataCharacterInitial[1].Yield;
    self._FoodFacilityProduction = self:GetCurrencyProductionByCity(FacilityProperty.Food)+DataCharacterInitial[1].Yield;
end

--[[
    获取部队消耗
]]
function UIPersonalPower:GetAllArmyResourceCost()
    -- body
    -- print(#self._TiledList)
    for i=1,#self._TiledList do
        -- print(BuildingService:Instance():GetBuilding(self._TiledList[i].buildingId))
        if BuildingService:Instance():GetBuilding(self._TiledList[i].buildingId) ~= nil then
            if BuildingService:Instance():GetBuilding(self._TiledList[i].buildingId)._dataInfo.Type == BuildingType.MainCity or BuildingService:Instance():GetBuilding(self._TiledList[i].buildingId)._dataInfo.Type == BuildingType.SubCity then
                local building = BuildingService:Instance():GetBuilding(self._TiledList[i].buildingId);
                -- print(building:GetAllKeepArmyCost(CurrencyEnum.Wood))
                -- print(building:GetAllKeepArmyCost(CurrencyEnum.Iron))
                -- print(building:GetAllKeepArmyCost(CurrencyEnum.Stone))
                -- print(building:GetAllKeepArmyCost(CurrencyEnum.Grain))
                self._WoodCost = self._WoodCost + building:GetAllKeepArmyCost(CurrencyEnum.Wood);
                self._IronCost = self._IronCost + building:GetAllKeepArmyCost(CurrencyEnum.Iron);
                self._StoneCost = self._StoneCost + building:GetAllKeepArmyCost(CurrencyEnum.Stone);
                self._FoodCost = self._FoodCost + building:GetAllKeepArmyCost(CurrencyEnum.Grain);
            end
        end
    end    
end

--[[
	动态创建Toggle
]]
function UIPersonalPower:DynamicCreatToggle(str, count, type)
    -- body
    local UILigeanceToggleAdd = require("Game/PersonalPower/UILigeanceToggleAdd").new();
    local dataConfig = DataUIConfig[UIType.UILigeanceToggleAdd];
    GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self._Grid_ToggleGrid, UILigeanceToggleAdd, function(go)
        UILigeanceToggleAdd:Init();        
    end );
    UILigeanceToggleAdd:ShowText(str, count);
    UILigeanceToggleAdd:SetTiledType(type);
    self._UILigeanceToggleList[type] = UILigeanceToggleAdd
    UILigeanceToggleAdd._Toggle_Select.isOn = self._UILigeanceToggleStatuList[type];
end

-- function UIPersonalPower:SubmitAllChangedToggle()
--     -- body
--     for k,v in pairs(self._UILigeanceToggleList) do
--         print(self._UILigeanceToggleStatuList[k]);
--     end
-- end


function UIPersonalPower:InitCreatToggle()
    -- body
    local UILigeanceToggleAdd = require("Game/PersonalPower/UILigeanceToggleAdd").new();
    local dataConfig = DataUIConfig[UIType.UILigeanceToggleAdd];
    GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self._Grid_ToggleGrid, UILigeanceToggleAdd, function(go)
        UILigeanceToggleAdd:Init();        
    end );
    table.insert(self._UILigeanceToggleList,UILigeanceToggleAdd);
end
--[[
	显示Toggle
]]
function UIPersonalPower:ShowToggle()
    -- body    
    for i = 1 , #self._UILigeanceToggleList do
        self._UILigeanceToggleList[i].gameObject:SetActive(false)
    end
    if self._SubCityCount ~= 0 then
        self._UILigeanceToggleList[1].gameObject:SetActive(true);
        self._UILigeanceToggleList[1]:ShowText("分城", self._SubCityCount);
        self._UILigeanceToggleList[1]:SetTiledType(LigeanceType.SubCity);
        self._UILigeanceToggleList[1]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.SubCity];        
    end
    if self._TownCount ~= 0 then
        self._UILigeanceToggleList[2].gameObject:SetActive(true);
        self._UILigeanceToggleList[2]:ShowText("个人城区", self._TownCount);
        self._UILigeanceToggleList[2]:SetTiledType(LigeanceType.Town);
        self._UILigeanceToggleList[2]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Town];
    end
    if self._FortCount ~= 0 then
        self._UILigeanceToggleList[3].gameObject:SetActive(true);
        self._UILigeanceToggleList[3]:ShowText("要塞", self._FortCount);
        self._UILigeanceToggleList[3]:SetTiledType(LigeanceType.Fort);
        self._UILigeanceToggleList[3]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Fort];
    end
    if self._DefenseTownCount ~= 0 then
        self._UILigeanceToggleList[4].gameObject:SetActive(true);
        self._UILigeanceToggleList[4]:ShowText("守军城区", self._DefenseTownCount);
        self._UILigeanceToggleList[4]:SetTiledType(LigeanceType.DefenseTown);
        self._UILigeanceToggleList[4]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.DefenseTown];
    end
    if self._Lv9 ~= 0 then
        self._UILigeanceToggleList[5].gameObject:SetActive(true);
        self._UILigeanceToggleList[5]:ShowText("Lv.9", self._Lv9);
        self._UILigeanceToggleList[5]:SetTiledType(LigeanceType.Lv9);
        self._UILigeanceToggleList[5]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv9];
    end
    if self._Lv8 ~= 0 then
        self._UILigeanceToggleList[6].gameObject:SetActive(true);
        self._UILigeanceToggleList[6]:ShowText("Lv.8", self._Lv8);
        self._UILigeanceToggleList[6]:SetTiledType(LigeanceType.Lv8);
        self._UILigeanceToggleList[6]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv8];
    end
    if self._Lv7 ~= 0 then
        self._UILigeanceToggleList[7].gameObject:SetActive(true);
        self._UILigeanceToggleList[7]:ShowText("Lv.7", self._Lv7);
        self._UILigeanceToggleList[7]:SetTiledType(LigeanceType.Lv7);
        self._UILigeanceToggleList[7]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv7];
    end
    if self._Lv6 ~= 0 then
        self._UILigeanceToggleList[8].gameObject:SetActive(true);
        self._UILigeanceToggleList[8]:ShowText("Lv.6", self._Lv6);
        self._UILigeanceToggleList[8]:SetTiledType(LigeanceType.Lv6);
        self._UILigeanceToggleList[8]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv6];
    end
    if self._Lv5 ~= 0 then
        self._UILigeanceToggleList[9].gameObject:SetActive(true);
        self._UILigeanceToggleList[9]:ShowText("Lv.5", self._Lv5);
        self._UILigeanceToggleList[9]:SetTiledType(LigeanceType.Lv5);
        self._UILigeanceToggleList[9]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv5];
    end
    if self._Lv4 ~= 0 then
        self._UILigeanceToggleList[10].gameObject:SetActive(true);
        self._UILigeanceToggleList[10]:ShowText("Lv.4", self._Lv4);
        self._UILigeanceToggleList[10]:SetTiledType(LigeanceType.Lv4);
        self._UILigeanceToggleList[10]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv4];
    end
    if self._Lv3 ~= 0 then
        self._UILigeanceToggleList[11].gameObject:SetActive(true);
        self._UILigeanceToggleList[11]:ShowText("Lv.3", self._Lv3);
        self._UILigeanceToggleList[11]:SetTiledType(LigeanceType.Lv3);
        self._UILigeanceToggleList[11]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv3];
    end
    if self._Lv2 ~= 0 then
        self._UILigeanceToggleList[12].gameObject:SetActive(true);
        self._UILigeanceToggleList[12]:ShowText("Lv.2", self._Lv2);
        self._UILigeanceToggleList[12]:SetTiledType(LigeanceType.Lv2);
        self._UILigeanceToggleList[12]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv2];
    end
    if self._Lv1 ~= 0 then
        self._UILigeanceToggleList[13].gameObject:SetActive(true);
        self._UILigeanceToggleList[13]:ShowText("Lv.1", self._Lv1);
        self._UILigeanceToggleList[13]:SetTiledType(LigeanceType.Lv1);
        self._UILigeanceToggleList[13]._Toggle_Select.isOn = self._UILigeanceToggleStatuList[LigeanceType.Lv1];
    end


end

--[[
	隐藏该界面
]]
function UIPersonalPower:OnHide()
    -- body
    self._TiledList = { };    --所有的土地
    self._TiledInfoTypeList = {}; --类型，土地字典
    self._TiledTypeList = {}      --类型列表
    -- self._NeedShowTiledList = {}; --需要显示的土地列表
    -- self._NeedShowTypeList = {};  --需要显示的类型列表
    self._MainCityList = {};
    self._SubCityList = {};
    self._FortessList = {};
    self._TownList = {};
    self._DefenseTownList = {};
    self._LigeanceLv9 = {};
    self._LigeanceLv8 = {};
    self._LigeanceLv7 = {};
    self._LigeanceLv6 = {};
    self._LigeanceLv5 = {};
    self._LigeanceLv4 = {};
    self._LigeanceLv3 = {};
    self._LigeanceLv2 = {};
    self._LigeanceLv1 = {};
end

--[[
	动态创建信息预制
]]
function UIPersonalPower:DynamicCreatInfo(ligeanceType, Tiled)
    -- bod
    local UILigeanceAdd = require("Game/PersonalPower/UILigeanceAdd").new();
    local dataConfig = DataUIConfig[UIType.UILigeanceAdd];
    GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self._Grid_InfoGrid, UILigeanceAdd, function(go)
        UILigeanceAdd:Init();
    end );
        UILigeanceAdd:SetTiledType(ligeanceType);
        UILigeanceAdd:ShowText(Tiled);
        UILigeanceAdd:SetTypeIcon(Tiled);
    if ligeanceType == LigeanceType.MainCity then
        return
    end
    table.insert(self._UILigeanceInfoList, UILigeanceAdd);
end

function UIPersonalPower:InitCreatInfo()
    -- body
    local UILigeanceAdd = require("Game/PersonalPower/UILigeanceAdd").new();
    local dataConfig = DataUIConfig[UIType.UILigeanceAdd];
    GameResFactory.Instance():GetUIPrefab(dataConfig.ResourcePath, self._Grid_InfoGrid, UILigeanceAdd, function(go)
        UILigeanceAdd:Init();
    end );
    table.insert(self._UILigeanceInfoList , UILigeanceAdd);
    return UILigeanceAdd;
end

--[[
	显示土地预制信息
]]
function UIPersonalPower:RefreshShowInfo()
    -- body
    self._NeedShowTiledList = {};
    for i = 1 , #self._MainCityList do
        local tiledTable = {}
        tiledTable.type = LigeanceType.MainCity;
        tiledTable.info = self._MainCityList[i];
        table.insert(self._NeedShowTiledList ,tiledTable);
    end
    
    for i = 1, #self._TiledTypeList do
        if self._NeedShowTypeList[self._TiledTypeList[i]] ~= nil then
            local list = self._TiledInfoTypeList[self._NeedShowTypeList[self._TiledTypeList[i]]]; 
            if list ~= nil then
                for j = 1 ,#list do
                    local tiledTable = {}
                    tiledTable.type = self._NeedShowTypeList[self._TiledTypeList[i]];
                    tiledTable.info = list[j];
                    table.insert(self._NeedShowTiledList,tiledTable);
                end
            end
        end
    end

    -- print(#self._NeedShowTiledList)
    for i = 1 , #self._UILigeanceInfoList do
        local item = self._UILigeanceInfoList[i];
        self:SetPos(item,i);
        item.gameObject:SetActive(false);
    end
    if #self._NeedShowTiledList < #self._UILigeanceInfoList then
        for i = 1,#self._NeedShowTiledList do
            local item = self._UILigeanceInfoList[i];
            item.gameObject:SetActive(true);
            item:SetTiledType(self._NeedShowTiledList[i].type);
            item:ShowText(self._NeedShowTiledList[i].info);
            item:SetTypeIcon(self._NeedShowTiledList[i].info);
            self:SetPos(item.gameObject,i);
        end        
    else
        for i = 1,#self._UILigeanceInfoList do
            local item = self._UILigeanceInfoList[i];
            item.gameObject:SetActive(true);
            item:SetTiledType(self._NeedShowTiledList[i].type);
            item:ShowText(self._NeedShowTiledList[i].info);
            item:SetTypeIcon(self._NeedShowTiledList[i].info);
            self:SetPos(item.gameObject,i);
        end
    end
    self._Grid_InfoGrid.sizeDelta = Vector2.New(self._Grid_InfoGrid.rect.width,#self._NeedShowTiledList * self._ImageHight);
    self._Grid_InfoGrid.transform.localPosition = Vector3.zero;
        
end

function UIPersonalPower:OnChange()
    -- body
    self.ScorllPos = math.floor(self._Grid_InfoGrid.localPosition.y + self._ImageHight)
    NewRow = math.floor(self.ScorllPos / self._ImageHight)
    if OldRow == NewRow then
    else
        OldRow = NewRow
        self:ReShow()        
    end
end


function UIPersonalPower:AddNeedShowTypeList(type)
    -- body
    self._NeedShowTypeList[type] = type;
end

function UIPersonalPower:RemoveNeedShowTypeList(type)
    -- body
    self._NeedShowTypeList[type] = nil;
end

function UIPersonalPower:SetPos(obj, i)
    local y = (i-1) * -self._ImageHight;
    obj.transform.localPosition = Vector3.New(0, y, 0)
end

function UIPersonalPower:ReShow()
    -- body
    for index = 1, self._InfoNeedInitCount do
        -- print(self._NeedShowTiledList ~= nil)
        -- print(self._NeedShowTiledList[index])
        -- print(NewRow)
        if self._NeedShowTiledList ~= nil and self._NeedShowTiledList[index + NewRow -1] ~= nil and NewRow >0 and NewRow <#self._NeedShowTiledList  then
            -- print("CameIn")
            local tiledInfo = self._NeedShowTiledList[index + NewRow - 1]
            local mitem = self._UILigeanceInfoList[index];
            self:SetPos(mitem.gameObject, index + NewRow - 1)
            mitem:SetTiledType(tiledInfo.type);
            mitem:ShowText(tiledInfo.info);
            mitem:SetTypeIcon(tiledInfo.info);
        else
            return
        end
    end
end



return UIPersonalPower;