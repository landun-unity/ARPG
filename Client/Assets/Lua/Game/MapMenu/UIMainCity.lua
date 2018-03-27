--[[
  主城进入
--]]
local UIBase = require("Game/UI/UIBase");
local UIMainCity = class("UIMainCity", UIBase);
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local PlayerService = require("Game/Player/PlayerService")
local MapService = require("Game/Map/MapService")
require("Game/Map/Operator/OperatorType")
local C2L_Facility = require("MessageCommon/Handler/C2L/C2L_Facility");
local DataGameConfig = require("Game/Table/model/DataGameConfig")
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService");
local UISmallHeroCard = require("Game/Hero/HeroCardPart/UISmallHeroCard");
local BuildingType = require("Game/Build/BuildingType");
local FacilityType = require("Game/Facility/FacilityType");
local ArmyState = require("Game/Army/ArmyState")
local EnterType = require("Game/Hero/HeroCardPart/UIEnterType")

-- 构造函数
function UIMainCity:ctor()
    UIMainCity.super.ctor(self);

    -- 返回按钮
    self.returnBtn = nil;
    -- 说明按钮
    self.ExplainBtn = nil;
    -- 扩建按钮 次数
    -- self.extendBtn = nil;
    -- self.extendBtnText = nil;
    -- 总览按钮
    self.pandectBtn = nil;
    -- 设施按钮
    self.facilityBtn = nil;
    -- 要塞属性按钮
    self.playerFort = nil;
    -- 任务按钮 数量
    self._taskBtn = nil;
    self._taskBtnCountParent = nil;
    self._taskBtnCount = nil;
    -- 木石铁粮数量
    self._wood = nil;
    self._IronOre = nil;
    self._Stone = nil;
    self._Provisions = nil;

    self._Button_PersonalPower = nil;
    self._wood = nil;
    self._IronOre = nil;
    self._Stone = nil;
    self._Provisions = nil;

    -- 铜币 玉符数量
    self._goldText = nil;
    self._SymbolText = nil;
    -- 充值按钮
    self._FillingBtn = nil;
    -- 建筑名字
    self._playerName = nil;
    -- 耐久
    self.durableText = nil;
    -- 总兵力
    self.TroopsText = nil;
    -- 预备兵
    self.RedifText = nil;
    self.RedifTextObj = nil;
    -- 左右切换按钮
    self.leftSwitchBtn = nil;
    self.rightSwitchBtn = nil;

    -- 部队卡牌父物体transform
    self.troopsListPanel = { };
    -- 部队卡牌ui脚本uismallherocard
    self.troopList = { };
    -- 部队的点击按钮uibutton
    self.EmptyTroops = { };
    -- 未开放部队的提示transform
    self.NoOpenTroops = { };
    -- 未配置部队提示transform
    self.NoBackCardTroops = { };
    -- 未配置部队提示Text
    self.NoBackCardTroopsText = { };

    -- 当前建筑
    self.curBuilding = nil;
    -- 当前建筑类型
    self.buildingType = nil;

    -- 建造队列相关
    self.baseQueueGridObj = nil;
    self.tempQueueGridObj = nil;
    self.baseQueueTitleValue = nil;
    self.temporaryQueueTitleValue = nil;
    self.baseQueueObjList = { };
    self.tempQueueObjList = { };

    self.WoodText = nil;
    self.IronOreText = nil;
    self.StoneText = nil;
    self.ProvisionsText = nil;

    self.newerPeriodBtn = nil;
    self.ResourceBtn = nil;

    self.questEffect = nil;
end

-- 注册控件
function UIMainCity:DoDataExchange()
    self.returnBtn = self:RegisterController(UnityEngine.UI.Button, "ReturnImage/ReturnBtn");
    self.ExplainBtn = self:RegisterController(UnityEngine.UI.Button, "ReturnImage/ExplainBtn");
    -- self.extendBtn = self:RegisterController(UnityEngine.UI.Button,"facility/extendBtn");
    -- self.extendBtnText = self:RegisterController(UnityEngine.UI.Text,"facility/extendBtn/Text");
    self.pandectBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/pandectBtn");
    self.facilityBtn = self:RegisterController(UnityEngine.UI.Button, "facility/facilityBtn");
    self.playerFort = self:RegisterController(UnityEngine.UI.Button, "facility/playerFort");

    self._taskBtn = self:RegisterController(UnityEngine.UI.Button, "Resource/MissionBtn");
    self._taskBtnCountParent = self:RegisterController(UnityEngine.Transform, "Resource/MissionBtn/Image");
    self._taskBtnCount = self:RegisterController(UnityEngine.UI.Text, "Resource/MissionBtn/Image/Text");
    self._wood = self:RegisterController(UnityEngine.UI.Text, "Resource/WoodImage/Text1");
    self._IronOre = self:RegisterController(UnityEngine.UI.Text, "Resource/IronOreImage/Text1");
    self._Stone = self:RegisterController(UnityEngine.UI.Text, "Resource/StoneImage/Text1");
    self._Provisions = self:RegisterController(UnityEngine.UI.Text, "Resource/ProvisionsImage/Text1");
    self.WoodText = self:RegisterController(UnityEngine.UI.Text, "Resource/WoodImage/Text/Text");
    self.IronOreText = self:RegisterController(UnityEngine.UI.Text, "Resource/IronOreImage/Text/Text");
    self.StoneText = self:RegisterController(UnityEngine.UI.Text, "Resource/StoneImage/Text/Text")
    self.ProvisionsText = self:RegisterController(UnityEngine.UI.Text, "Resource/ProvisionsImage/Text/Text")
    self.ResourceBtn = self:RegisterController(UnityEngine.UI.Button,"Resource");
    self._goldText = self:RegisterController(UnityEngine.UI.Text, "Panel/GoldCalifornite/Gold/goldText");
    self._SymbolText = self:RegisterController(UnityEngine.UI.Text, "Panel/GoldCalifornite/Symbol/SymbolText");
    self._playerName = self:RegisterController(UnityEngine.UI.Text, "PlayerName/playText");
    self.durableText = self:RegisterController(UnityEngine.UI.Text, "Panel/GameObject/durableImage/durableText");
    self.TroopsText = self:RegisterController(UnityEngine.UI.Text, "Panel/GameObject/Troops/TroopsText");
    self.RedifText = self:RegisterController(UnityEngine.UI.Text, "Panel/GameObject/RedifImage/RedifText");
    self.RedifTextObj = self:RegisterController(UnityEngine.Transform, "Panel/GameObject/RedifImage");
    self.leftSwitchBtn = self:RegisterController(UnityEngine.UI.Button, "LeftSwitchBtn");
    self.rightSwitchBtn = self:RegisterController(UnityEngine.UI.Button, "RightSwitchBtn");
    self._FillingBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/GoldCalifornite/FillingBtn");

    for i = 1, 5 do
        self.troopsListPanel[i] = self:RegisterController(UnityEngine.Transform, "OneselfLandTroopsImage/EmptyTroops" .. i);
        self.EmptyTroops[i] = self:RegisterController(UnityEngine.UI.Button, "OneselfLandTroopsImage/EmptyTroops" .. i .. "/clickBtnPanel" .. i);
        self.NoOpenTroops[i] = self:RegisterController(UnityEngine.UI.Image, "OneselfLandTroopsImage/EmptyTroops" .. i .. "/noOpenPanel");
        self.NoBackCardTroops[i] = self:RegisterController(UnityEngine.Transform, "OneselfLandTroopsImage/EmptyTroops" .. i .. "/BottomImage/NotOpenedImage");
        self.NoBackCardTroopsText[i] = self:RegisterController(UnityEngine.UI.Text, "OneselfLandTroopsImage/EmptyTroops" .. i .. "/BottomImage/NotOpenedImage/Text");
    end

    self.baseQueueGridObj = self:RegisterController(UnityEngine.Transform, "BuildQueues/QueueGrid/BaseBuildingGrid");
    self.tempQueueGridObj = self:RegisterController(UnityEngine.Transform, "BuildQueues/QueueGrid/TemporaryGrid");
    self.baseQueueTitleValue = self:RegisterController(UnityEngine.UI.Text, "BuildQueues/QueueGrid/BaseBuildingGrid/BuildingQueueTitle/ValueText");
    self.temporaryQueueTitleValue = self:RegisterController(UnityEngine.UI.Text, "BuildQueues/QueueGrid/TemporaryGrid/TemporaryQueueTitle/ValueText");

    self.newerPeriodBtn = self:RegisterController(UnityEngine.UI.Button, "NewerBtn");
end

-- 注册控件点击事件
function UIMainCity:DoEventAdd()
    self:AddListener(self.returnBtn, self.OnClickReturnBtn);
    self:AddListener(self.ExplainBtn, self.OnClickExplainBtn);
    -- self:AddListener(self.extendBtn,self.OnClickExtendBtn);
    self:AddListener(self.pandectBtn, self.OnClickPandectBtn);
    self:AddListener(self.facilityBtn, self.OnClickFacilityBtn);
    self:AddListener(self.playerFort, self.OnClickPlayerFort);
    self:AddListener(self._taskBtn, self.OnClickTaskBtn);
    self:AddListener(self.leftSwitchBtn, self.SwitchToLeft);
    self:AddListener(self.rightSwitchBtn, self.SwitchToRight);
    self:AddListener(self._FillingBtn, self.OnClickRechargeBtn);
    self:AddListener(self.ResourceBtn, self.OnClickResourceBtn)
    for i = 1, 5 do
        self.lua_behaviour:AddClick(self.EmptyTroops[i].gameObject, function(...)
            return self.OnClickEmptyTroops(self, i, ...);
        end );
    end
        self:AddListener(self.newerPeriodBtn, self.OnClickNewerBtn);
end

-- 注册所有的事件
function UIMainCity:RegisterAllNotice()
    -- self:RegisterNotice(L2C_Facility.CityExpandRespond, self.ShowExplainBtn);
    self:RegisterNotice(L2C_Task.OpenTaskListRespond, self.UpdateTaskCanCount);
    self:RegisterNotice(L2C_Task.SyncSingleTask, self.UpdateTaskCanCount);
    self:RegisterNotice(L2C_Task.TaskAwardRespond, self.UpdateTaskCanCount);
    self:RegisterNotice(L2C_Army.SyncPlayerFortArmy, self.ShowFortTroop)
    self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.SetCurrencyEnum);
    self:RegisterNotice(L2C_Recharge.RechargeOnceResponse, self.SetCurrencyEnum);
    self:RegisterNotice(L2C_Building.SyncUpdatePlayerFort,self.RefreshBuildQueues)
    self:RegisterNotice(L2C_Building.SyncUpdatePlayerFort,self.SetOpenAndBackCard)
    self:RegisterNotice(L2C_Building.ReplyUpdateFort,self.RefreshBuildQueues)
    self:RegisterNotice(L2C_Player.SyncNewerPeriod, self.RefreshNewerBtn);
    self:RegisterNotice(L2C_Player.PlayerGainNewTiled, self.SetResource)
    self:RegisterNotice(L2C_Player.PlayerLostOldTiled, self.SetResource)
    self:RegisterNotice(L2C_Map.SyncTiled, self.SetResource)
    self:RegisterNotice(L2C_Player.SyncBuildingInfo, self.SetDuration)

end

-- 初始化的时候
function UIMainCity:OnInit()
    self:ListenerReturn();
    self:FlushFortInfo();
    self:FlushCurrencyInfo();
    self:FlushMainCityInfos();
end

function UIMainCity:OnShow(param)
    -- print("+++++++++++++++++++++++++++++++++++++++")
    ClickService:Instance():HideUIBreathingFrame()
    --UIService:Instance():HideFortImage();
    LineService:Instance():CancelArmyChoose();
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    -- local tiled = param[0];
    -- if tiled ~= nil then
    --     if tiled._building == nil then
    --         if tiled._town ~= nil then
    --             if tiled._town._building ~= nil then
    --                 self.curBuilding = tiled._town._building;
    --             else
    --                 -- print("进入maincity格子获取不到主城building1111")
    --             end
    --         else
    --             -- print("进入maincity格子获取不到主城building22222")
    --         end
    --     else
    --         self.curBuilding = tiled._building;
    --     end
    -- end
    self.curBuilding = param[0]
    if self.curBuilding ~= nil and self.curBuilding._dataInfo ~= nil then
        self.buildingType = self.curBuilding._dataInfo.Type;
    end
    self:CardTroopsText();
    self:SetBuildingName();
    self:SetCurrencyEnum();
    self:SetTroops();
    self:SetRedif();
    self:SetDuration();
    self:RefreshBuildQueues();
    self:UpdateTaskCanCount();
    self:UpdateSwitchBtnState();
    self:ShowOrHideLine(false);
    self:SetOpenAndBackCard();
    self:ShowAllCards();
    self:RefreshNewerBtn();
    -- 城市耐久的显示一分钟刷新一次
    self.marchTimer = Timer.New(
    function()
        self:SetCurrencyEnum();
    end , 60, -1, false);
    self.marchTimer:Start();

    self:SetResource();

    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        self.facilityBtn.gameObject:SetActive(true);
        self.playerFort.gameObject:SetActive(false);
        self.RedifTextObj.gameObject:SetActive(true);
        self.pandectBtn.gameObject:SetActive(true);
        -- self:ShowExplainBtn();
    elseif self.buildingType == BuildingType.PlayerFort then
        self.facilityBtn.gameObject:SetActive(false);
        self.playerFort.gameObject:SetActive(true);
        self.RedifTextObj.gameObject:SetActive(false);
        self.pandectBtn.gameObject:SetActive(true);
    elseif self.buildingType == BuildingType.WildFort then
        self.facilityBtn.gameObject:SetActive(false);
        self.playerFort.gameObject:SetActive(false);
        self.RedifTextObj.gameObject:SetActive(false);
        self.pandectBtn.gameObject:SetActive(false);
    elseif self.buildingType == BuildingType.WildGarrisonBuilding then
        self.facilityBtn.gameObject:SetActive(false);
        self.playerFort.gameObject:SetActive(false);
        self.RedifTextObj.gameObject:SetActive(true);
        self.pandectBtn.gameObject:SetActive(false);
    else
        return;
    end
end

-- 新手保护期按钮点击
function UIMainCity:OnClickNewerBtn()
    UIService:Instance():ShowUI(UIType.UINewerPeriod);
end

-- 新手保护期按钮显隐
function UIMainCity:RefreshNewerBtn()
    if NewerPeriodService:Instance():IsInNewerPeriod() == true then
        if self.newerPeriodBtn.gameObject.activeSelf == false then
            self.newerPeriodBtn.gameObject:SetActive(true);
        end
    else
        if self.newerPeriodBtn.gameObject.activeSelf == true then
            self.newerPeriodBtn.gameObject:SetActive(false);
        end
    end
end

-- 刷新所有的资源产量及显示
function UIMainCity:SetResource()
    PlayerService:Instance():GetTotalResourceYield();
    local woodAddValue = PlayerService:Instance():GetWoodYield();
    local ironAddValue = PlayerService:Instance():GetIronYield();
    local stoneAddValue = PlayerService:Instance():GetStoneYield();
    local grainAddValue = PlayerService:Instance():GetFoodYield();
    self.WoodText.text = woodAddValue >=0 and "+"..woodAddValue or woodAddValue;
    self.IronOreText.text = ironAddValue >=0 and "+"..ironAddValue or ironAddValue;
    self.StoneText.text = stoneAddValue >=0 and "+"..stoneAddValue or stoneAddValue;
    self.ProvisionsText.text = grainAddValue >=0 and "+"..grainAddValue or grainAddValue;
    self:SetCurrencyEnum();
end

function UIMainCity:CardTroopsText()
    local name = "";
    if self.buildingType == BuildingType.PlayerFort or self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        name = "无部队"
    elseif self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        name = "未配置"
    end

    for i = 1, 5 do
        self.NoBackCardTroopsText[i].text = name;
    end
end

function UIMainCity:OnHide(param)
    MapService:Instance():EnterOperator(OperatorType.Empty);
end


function UIMainCity:OnClickResourceBtn()
    UIService:Instance():ShowUI(UIType.UIPersonalPower,PersonalPowerOpenType.ResourceOpen);
end

------------------------------- 创建卡牌部队相关 -------------------------------
function UIMainCity:ShowAllCards()
    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        self:ShowMainCityTroop();
    elseif self.buildingType == BuildingType.PlayerFort then
        self:ShowFortTroop();
    elseif self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        self:ShowWildFortTroop()
    else
        return;
    end
end

-- 配置主城分城部队卡牌
function UIMainCity:ShowMainCityTroop()
    for i = 1, #self.troopList do
        if self.troopList[i] ~= nil and self.troopList[i].gameObject ~= nil then
            self.troopList[i].gameObject:SetActive(false);
        end
    end

    local armyInfoList = ArmyService:Instance():GetHaveBackArmy(self.curBuilding._id);
    for index = 1, #armyInfoList do
        local armyInfo = armyInfoList[index]
        local spawnSlotIndex = armyInfo.spawnSlotIndex;
        local uiSmallHeroCard = self.troopList[spawnSlotIndex];
        if uiSmallHeroCard == nil then
            self:CreateAndAddHeroCard(armyInfo, index, spawnSlotIndex);
        else
            uiSmallHeroCard.gameObject:SetActive(true);
            local back = armyInfo:GetCard(ArmySlotType.Back);
            local isGray = false;
            if armyInfo.curBuildingId ~= self.curBuilding._id then
                isGray = true;
            end
            uiSmallHeroCard:SetUISmallHeroCardMessage(back, isGray);
            self:SetSmallCardInfo(uiSmallHeroCard, armyInfo, index, spawnSlotIndex);
        end
    end
end

-- 新建一张部队卡片并添加（主城分城）
function UIMainCity:CreateAndAddHeroCard(armyInfo, index, spawnSlotIndex)
    local back = armyInfo:GetCard(ArmySlotType.Back);
    local mdata = DataUIConfig[UIType.UISmallHeroCard];
    local uiSmallHeroCard = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.troopsListPanel[spawnSlotIndex]:Find("smallCardParent"), uiSmallHeroCard, function(go)
        uiSmallHeroCard:Init();
        local isGray = false;
        if armyInfo.curBuildingId ~= self.curBuilding._id then
            isGray = true;
        end
        uiSmallHeroCard:SetUISmallHeroCardMessage(back, isGray);
        self:SetSmallCardInfo(uiSmallHeroCard, armyInfo, index, spawnSlotIndex);
        self.troopList[spawnSlotIndex] = uiSmallHeroCard;
    end );
end

-- 刷新卡牌数据（主城分城）
function UIMainCity:SetSmallCardInfo(uiSmallHeroCard, armyInfo, index, spawnSlotIndex)
    local stateStr = self:GetArmyStateStr(armyInfo);
    uiSmallHeroCard:SetArmyStateText(stateStr);
    uiSmallHeroCard:SetTroopUIType("City", spawnSlotIndex - 1);
    uiSmallHeroCard:AllSoldierCount(armyInfo);
end

-- 配置要塞部队卡牌
function UIMainCity:ShowFortTroop()
    local fort = BuildingService:Instance():GetBuilding(self.curBuilding._id);
    for index = 1, 5 do
        local armyInfo = fort:GetArmyInfos(index);
        if armyInfo ~= nil then
            local spawnSlotIndex = armyInfo.spawnSlotIndex;
            local back = armyInfo:GetCard(ArmySlotType.Back);
            local uiSmallHeroCard = self.troopList[index];
            if uiSmallHeroCard == nil then
                self:CreateAndAddFortHeroCard(armyInfo, index, spawnSlotIndex, armyInfo.spawnBuildng, back);
            else
                uiSmallHeroCard.gameObject:SetActive(true);
                uiSmallHeroCard:SetUISmallHeroCardMessage(back, self:GetFortArmyGrayState(armyInfo));
                local stateStr = self:GetArmyStateStr(armyInfo);
                uiSmallHeroCard:SetArmyStateText(stateStr);
                uiSmallHeroCard:SetTroopUIType("fort", spawnSlotIndex - 1, armyInfo.spawnBuildng);
                uiSmallHeroCard:AllSoldierCount(armyInfo);
            end
        else
            if self.troopList[index] ~= nil and self.troopList[index].gameObject ~= nil and self.troopList[index].gameObject.activeSelf == true then
                self.troopList[index].gameObject:SetActive(false);
            end
        end
    end
end

-- 新建一张部队卡片并添加（要塞）
function UIMainCity:CreateAndAddFortHeroCard(armyInfo, index, spawnSlotIndex, buildingId, back)
    local mdata = DataUIConfig[UIType.UISmallHeroCard];
    local uiSmallHeroCard = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.troopsListPanel[index]:Find("smallCardParent"), uiSmallHeroCard, function(go)
        uiSmallHeroCard:Init();
        uiSmallHeroCard:SetUISmallHeroCardMessage(back, self:GetFortArmyGrayState(armyInfo));
        local stateStr = self:GetArmyStateStr(armyInfo);
        uiSmallHeroCard:SetArmyStateText(stateStr);
        uiSmallHeroCard:SetTroopUIType("fort", spawnSlotIndex - 1, buildingId);
        uiSmallHeroCard:AllSoldierCount(armyInfo);
        self.troopList[index] = uiSmallHeroCard;
    end );
end

-- 配置野外要塞部队卡牌
function UIMainCity:ShowWildFortTroop()
    local wildFort = BuildingService:Instance():GetBuilding(self.curBuilding._id);
    --    print(" uimaincity   ".. wildFort)
    for index = 1, 5 do
        local armyInfo = wildFort:GetWildFortArmyInfos(index)
        if armyInfo ~= nil then
            local spawnSlotIndex = armyInfo.spawnSlotIndex;
            local back = armyInfo:GetCard(ArmySlotType.Back);
            local uiSmallHeroCard = self.troopList[index];
            if uiSmallHeroCard == nil then
                self:CreateAndAddWildFortHeroCard(armyInfo, index, spawnSlotIndex, armyInfo.spawnBuildng, back);
            else
                uiSmallHeroCard.gameObject:SetActive(true);
                uiSmallHeroCard:SetUISmallHeroCardMessage(back, self:GetFortArmyGrayState(armyInfo));
                local stateStr = self:GetArmyStateStr(armyInfo);
                uiSmallHeroCard:SetArmyStateText(stateStr);
                uiSmallHeroCard:SetTroopUIType("fort", spawnSlotIndex - 1, armyInfo.spawnBuildng);
                uiSmallHeroCard:AllSoldierCount(armyInfo);
            end
        else
            if self.troopList[index] ~= nil and self.troopList[index].gameObject ~= nil and self.troopList[index].gameObject.activeSelf == true then
                self.troopList[index].gameObject:SetActive(false);
            end
        end
    end
end

-- 新建一张部队卡片并添加（野外要塞）
function UIMainCity:CreateAndAddWildFortHeroCard(armyInfo, index, spawnSlotIndex, buildingId, back)
    local mdata = DataUIConfig[UIType.UISmallHeroCard];
    local uiSmallHeroCard = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.troopsListPanel[index]:Find("smallCardParent"), uiSmallHeroCard, function(go)
        uiSmallHeroCard:Init();
        uiSmallHeroCard:SetUISmallHeroCardMessage(back, self:GetFortArmyGrayState(armyInfo));
        local stateStr = self:GetArmyStateStr(armyInfo);
        uiSmallHeroCard:SetArmyStateText(stateStr);
        uiSmallHeroCard:SetTroopUIType("fort", spawnSlotIndex - 1, buildingId);
        uiSmallHeroCard:AllSoldierCount(armyInfo);
        self.troopList[index] = uiSmallHeroCard;
    end );
end

-- 判断野外要塞或要塞中小卡牌是否显示灰色
function UIMainCity:GetFortArmyGrayState(armyInfo)
    if armyInfo == nil then
        return false;
    end
    if (armyInfo:GetArmyState() ~= ArmyState.None and armyInfo:GetArmyState() ~= ArmyState.TransformArrive)
        or(armyInfo:GetArmyState() == ArmyState.TransformArrive and(armyInfo:IsArmyInConscription() or
        armyInfo:IsArmyIsBadlyHurt() or armyInfo:IsArmyIsTired())) then
        return true;
    else
        return false;
    end
end

-- 设置部队开启配置显示
function UIMainCity:SetOpenAndBackCard()
    local armyCount = self:GetArmyCount();
    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        for i = 1, 5 do
            if self.troopsListPanel[i].gameObject.activeSelf == false then
                self.troopsListPanel[i].gameObject:SetActive(true);
            end
            if i <= armyCount then
                self.NoOpenTroops[i].gameObject:SetActive(false);
                self.NoBackCardTroops[i].gameObject:SetActive(true);
            else
                self.NoOpenTroops[i].gameObject:SetActive(true);
                self.NoBackCardTroops[i].gameObject:SetActive(false);
            end
        end
    elseif self.buildingType == BuildingType.PlayerFort then
        for i = 1, 5 do
            if i <= armyCount then
                if self.troopsListPanel[i].gameObject.activeSelf == false then
                    self.troopsListPanel[i].gameObject:SetActive(true);
                end
                if self.NoOpenTroops[i].gameObject.activeSelf == true then
                    self.NoOpenTroops[i].gameObject:SetActive(false);
                end
                if self.NoBackCardTroops[i].gameObject.activeSelf == false then
                    self.NoBackCardTroops[i].gameObject:SetActive(true);
                end
            else
                if self.troopsListPanel[i].gameObject.activeSelf == true then
                    self.troopsListPanel[i].gameObject:SetActive(false);
                end
            end
        end
    elseif self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        for i = 1, 5 do
            if self.troopsListPanel[i].gameObject.activeSelf == false then
                self.troopsListPanel[i].gameObject:SetActive(true);
            end
            if self.NoOpenTroops[i].gameObject.activeSelf == true then
                self.NoOpenTroops[i].gameObject:SetActive(false);
            end
            if self.NoBackCardTroops[i].gameObject.activeSelf == false then
                self.NoBackCardTroops[i].gameObject:SetActive(true);
            end
        end
    else
        return;
    end
end

-- 获取可配置部队数量
function UIMainCity:GetArmyCount()
    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        local ArmyCount = FacilityService:Instance():GetCityPropertyByFacilityProperty(self.curBuilding._id, FacilityProperty.ArmyCount);
        if ArmyCount == nil then
            return 0
        end
        return ArmyCount;
    elseif self.buildingType == BuildingType.PlayerFort then
        return BuildingService:Instance():GetBuilding(self.curBuilding._id)._fortGrade;
    elseif self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        return 5;
    else
        return 0;
    end
end

-- 获取部队显示状态字符串
function UIMainCity:GetArmyStateStr(armyInfo)
    --print(armyInfo:GetArmyState())
    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        if armyInfo.curBuildingId ~= self.curBuilding._id then
            return "<color=#808A87>调动</color>";
            -- 二次保护
        elseif armyInfo:GetArmyState() == ArmyState.TransformRoad or armyInfo:GetArmyState() == ArmyState.TransformArrive then
            return "<color=#808A87>调动</color>";
        elseif armyInfo:GetArmyState() == ArmyState.BattleRoad or
            armyInfo:GetArmyState() == ArmyState.BattleIng or
            armyInfo:GetArmyState() == ArmyState.SweepRoad or
            armyInfo:GetArmyState() == ArmyState.SweepIng or
            armyInfo:GetArmyState() == ArmyState.GarrisonRoad or
            armyInfo:GetArmyState() == ArmyState.MitaRoad or
            armyInfo:GetArmyState() == ArmyState.MitaIng or
            armyInfo:GetArmyState() == ArmyState.TrainingRoad or
            armyInfo:GetArmyState() == ArmyState.Training or
            armyInfo:GetArmyState() == ArmyState.RescueRoad or
            armyInfo:GetArmyState() == ArmyState.RescueIng then
            return "<color=#00FF00>行军</color>";
        elseif armyInfo:GetArmyState() == ArmyState.Back then
            return "<color=#4169E1>返回</color>";
        elseif armyInfo:GetArmyState() == ArmyState.GarrisonIng then
            return "<color=#00FF00>驻守</color>";
        elseif armyInfo:IsArmyInConscription() == true then
            return "<color=#C0C0C0>征兵</color>";
        elseif armyInfo:IsArmyIsBadlyHurt() == true then
            return "<color=#FF0000>重伤</color>";
        elseif armyInfo:IsArmyIsTired() == true then
            return "<color=#FF0000>疲劳</color>";
        else
            return "";
        end
    elseif self.buildingType == BuildingType.PlayerFort or self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        if armyInfo:GetArmyState() == ArmyState.BattleRoad or
            armyInfo:GetArmyState() == ArmyState.BattleIng or
            armyInfo:GetArmyState() == ArmyState.SweepRoad or
            armyInfo:GetArmyState() == ArmyState.SweepIng or
            armyInfo:GetArmyState() == ArmyState.GarrisonRoad or
            armyInfo:GetArmyState() == ArmyState.MitaRoad or
            armyInfo:GetArmyState() == ArmyState.MitaIng or
            armyInfo:GetArmyState() == ArmyState.TrainingRoad or
            armyInfo:GetArmyState() == ArmyState.Training or
            armyInfo:GetArmyState() == ArmyState.RescueRoad or
            armyInfo:GetArmyState() == ArmyState.RescueIng or
            armyInfo:GetArmyState() == ArmyState.TransformRoad then
            return "<color=#00FF00>行军</color>";
        elseif armyInfo:GetArmyState() == ArmyState.Back then
            return "<color=#4169E1>返回</color>";
        elseif armyInfo:GetArmyState() == ArmyState.GarrisonIng then
            return "<color=#00FF00>驻守</color>";
        elseif armyInfo:IsArmyInConscription() == true then
            return "<color=#C0C0C0>征兵</color>";
        elseif armyInfo:IsArmyIsBadlyHurt() == true then
            return "<color=#FF0000>重伤</color>";
        elseif armyInfo:IsArmyIsTired() == true then
            return "<color=#FF0000>疲劳</color>";
        elseif armyInfo:GetArmyState() == ArmyState.TransformArrive then
            return "<color=#00FF00>待命</color>";
        else
            return "";
        end
    end
end

------------------------------- 回调刷新数据相关 -------------------------------
-- 点击设施返回刷新部队板
function UIMainCity:ListenerReturn()
    EventService:Instance():AddEventListener(EventType.ListenerSetPanels, function(...)
        self:SetOpenAndBackCard();
        self:SetDuration();
    end )
end

-- 要塞部队信息回调
function UIMainCity:FlushFortInfo()
    EventService:Instance():AddEventListener(EventType.fortRenovation, function(...)
        self:SetOpenAndBackCard();
    end )
end

-- 点击部队配置返回按钮刷新部队
function UIMainCity:FlushMainCityInfos()
    EventService:Instance():AddEventListener(EventType.MainCityArmy, function(...)

        self:ShowAllCards();
        self:SetTroops();
        self:SetRedif();
        self:SetDuration();
    end )
end

-- 资源回调
function UIMainCity:FlushCurrencyInfo()
    EventService:Instance():AddEventListener(EventType.Resources, function(...)
        self:SetCurrencyEnum();
    end )
end

------------------------------- 点击按钮相关 -------------------------------
-- 返回按钮点击
function UIMainCity:OnClickReturnBtn()
    MapService:Instance():EnterOperator(OperatorType.ZoomOut);
    MapService:Instance():EnterOperator(OperatorType.Empty);
    MapService:Instance():OutCityCallBack()
    self:ShowOrHideLine(true);
  --  UIService:Instance():ShowFortImage();
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    UIService:Instance():HideUI(UIType.UIMainCity);
    local tiled = MapService:Instance():GetTiledByIndex(self.curBuilding._tiledId);
    ClickService:Instance():ShowUIBreathingFrameByIndex(tiled, self.curBuilding._tiledId);
end

-- 说明按钮点击
function UIMainCity:OnClickExplainBtn()

    UIService:Instance():ShowUI(UIType.ExplainPanel, self.buildingType);
end

-- 扩建按钮点击
-- function UIMainCity:OnClickExtendBtn()
--     MapService:Instance():EnterOperator(OperatorType.Extension);
--     local tiled = MapService:Instance():GetTiledByIndex(self.curBuilding._tiledId);
--     UIService:Instance():ShowUI(UIType.Extension, tiled);
--     UIService:Instance():HideUI(UIType.UIMainCity);
-- end

-- 总览按钮点击
function UIMainCity:OnClickPandectBtn()
    local tiled = MapService:Instance():GetTiledByIndex(self.curBuilding._tiledId);
    local param = { };
    param.tiled = tiled;
    param.buildingType = self.curBuilding._dataInfo.Type;
    UIService:Instance():HideUI(UIType.UIMainCity);    
    UIService:Instance():ShowUI(UIType.UIPandectObj, param);
end

-- 设施按钮点击
function UIMainCity:OnClickFacilityBtn()
    local param = { };
    param.id = self.curBuilding._id;
    UIService:Instance():ShowUI(UIType.UIFacility, param);
end

-- 要塞按钮点击
function UIMainCity:OnClickPlayerFort()
    -- local msg = require("MessageCommon/Msg/C2L/Building/UpgradeRequest").new();
    -- msg:SetMessageId(C2L_Building.UpgradeRequest);
    -- msg.buildingId = self.curBuilding._id
    -- NetService:Instance():SendMessage(msg);
    local tiled = MapService:Instance():GetTiledByIndex(self.curBuilding._tiledId)
    if tiled == nil then
        return
    end
    if self.curBuilding._buildDeleteTime - PlayerService:Instance():GetLocalTime() > 0 or tiled.tiledInfo.giveUpLandTime - PlayerService:Instance():GetLocalTime() > 0 then
        UIService:Instance():ShowUI(UIType.UIDeleteFort, self.curBuilding._tiledId);
    else
        UIService:Instance():ShowUI(UIType.UIUpgradeBuilding, self.curBuilding._tiledId);
    end
end

-- 任务按钮点击
function UIMainCity:OnClickTaskBtn()
    UIService:Instance():ShowUI(UIType.UITask);
end

-- 向左切换
function UIMainCity:SwitchToLeft()
    local leftCity = PlayerService:Instance():GetLeftCity(self.curBuilding._id);
    if leftCity ~= nil then
        MapService:Instance():ChangeSmallerViewNoTween();
        local pos = MapService:Instance():GetTiledPositionByIndex(leftCity._tiledId);
        MapService:Instance():ScanTiledByUGUIPositionNotDelay(pos.x, pos.y - 120);
        local tiled = MapService:Instance()._logic._tiledManage:GetTiledByIndex(leftCity._tiledId);
        MapService:Instance():ChangeBiggerView();
        local param = { };
        param[0] = leftCity;
        self:OnShow(param);
    else
        -- print("找不到上一个建筑")
    end
end

-- 向右切换
function UIMainCity:SwitchToRight()
    local rigthCity = PlayerService:Instance():GetRightCity(self.curBuilding._id);
    if rigthCity ~= nil then
        MapService:Instance():ChangeSmallerViewNoTween();
        local pos = MapService:Instance():GetTiledPositionByIndex(rigthCity._tiledId);
        MapService:Instance():ScanTiledByUGUIPositionNotDelay(pos.x, pos.y - 120);
        local tiled = MapService:Instance()._logic._tiledManage:GetTiledByIndex(rigthCity._tiledId);
        MapService:Instance():ChangeBiggerView();
        local param = { };
        param[0] = rigthCity;
        self:OnShow(param);
    else
        -- print("找不到下一个建筑")
    end
end

-- 部队点击
function UIMainCity:OnClickEmptyTroops(index)
    if index < 1 or index > 5 then
        return;
    end

    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        local armyCount = self:GetArmyCount();
        if index > armyCount then
            return;
        end

        local armyInfo = ArmyService:Instance():GetArmyInCity(self.curBuilding._id, index);
        if armyInfo.curBuildingId == 0 or armyInfo.curBuildingId == self.curBuilding._id then
            -- print("在一个城市" .. armyInfo.curBuildingId .. "  " .. self.curBuilding._id);

            local param = { };
            param[0] = true;
            param[1] = self.curBuilding._id;
            param[2] = index - 1;
            UIService:Instance():ShowUI(UIType.ArmyFunctionUI, param);
        else
            -- print("不在一个城市" .. armyInfo.curBuildingId .. "  " .. self.curBuilding._id);

            local toCity = BuildingService:Instance():GetBuilding(armyInfo.curBuildingId);
            if toCity ~= nil then
                MapService:Instance():ChangeSmallerViewNoTween();
                local pos = MapService:Instance():GetTiledPositionByIndex(toCity._tiledId);
                MapService:Instance():ScanTiledByUGUIPositionNotDelay(pos.x, pos.y - 120);
                MapService:Instance():ChangeBiggerView( function()
                    local param = { };
                    param[0] = false;
                    param[1] = armyInfo.spawnBuildng;
                    param[2] = armyInfo.spawnSlotIndex - 1;
                    UIService:Instance():ShowUI(UIType.ArmyFunctionUI, param);
                end );
                local tiled = MapService:Instance()._logic._tiledManage:GetTiledByIndex(toCity._tiledId);
                local param = { };
                param[0] = toCity
                self:OnShow(param);
            else
                -- print("找不到部队当前所在建筑")
            end
        end
    elseif self.buildingType == BuildingType.PlayerFort then
        local armyCount = self:GetArmyCount();
        if index > armyCount then
            return;
        end

        local fort = BuildingService:Instance():GetBuilding(self.curBuilding._id);
        local haveArmyCount = fort:GetArmyInfoCounts();
        if index > haveArmyCount then
            return;
        end

        local armyInfo = fort:GetArmyInfos(index);
        if armyInfo == nil then
            return;
        end

        local param = { }
        param[0] = false;
        param[1] = armyInfo.spawnBuildng;
        param[2] = armyInfo.spawnSlotIndex - 1;
        UIService:Instance():ShowUI(UIType.ArmyFunctionUI, param);
    elseif self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        local armyCount = self:GetArmyCount()
        if index > armyCount then
            return;
        end
        local wildFort = BuildingService:Instance():GetBuilding(self.curBuilding._id)
        local havaArmyCount = wildFort:GetWildFortArmyInfoCounts()
        if index > havaArmyCount then
            return;
        end

        local armyInfo = wildFort:GetWildFortArmyInfos(index)
        if armyInfo == nil then
            return
        end

        local param = { }
        param[0] = false;
        param[1] = armyInfo.spawnBuildng;
        param[2] = armyInfo.spawnSlotIndex - 1;
        UIService:Instance():ShowUI(UIType.ArmyFunctionUI, param);
    end
end

-- 充值
function UIMainCity:OnClickRechargeBtn(args)
    UIService:Instance():ShowUI(UIType.RechargeUI);
end

------------------------------- 刷新界面数据相关 -------------------------------
-- 大地图部队行军路线
function UIMainCity:ShowOrHideLine(isTrue)
    local LineParent = MapService:Instance():GetLayerParent(LayerType.Line);
    local UIParent = MapService:Instance():GetLayerParent(LayerType.UI);
    local ArmyParent = MapService:Instance():GetLayerParent(LayerType.Army);
    local flagParent = MapService:Instance():GetLayerParent(LayerType.Flag);
    local sliderParent = MapService:Instance():GetLayerParent(LayerType.ArmyWalkSlider);
    local powerParent = MapService:Instance():GetLayerParent(LayerType.Power);
    local SourceEvent = MapService:Instance():GetLayerParent(LayerType.SourceEvent);
    local behaviour = MapService:Instance():GetLayerParent(LayerType.Sign);
    local ArmyBehaviourTwo = MapService:Instance():GetLayerParent(LayerType.ArmyBehaviourTwo)
    LineParent.gameObject:SetActive(isTrue);
    ArmyParent.gameObject:SetActive(isTrue);
    flagParent.gameObject:SetActive(isTrue);
    sliderParent.gameObject:SetActive(isTrue);
    powerParent.gameObject:SetActive(isTrue);
    UIParent.gameObject:SetActive(isTrue);
    SourceEvent.gameObject:SetActive(isTrue);
    behaviour.gameObject:SetActive(isTrue);
    ArmyBehaviourTwo.gameObject:SetActive(isTrue)
    ClickService:Instance():HideCityName();
end

-- 扩建次数刷新
-- function UIMainCity:ShowExplainBtn()
--     if  self.curBuilding == nil then
--         return;
--     end
--     if self.curBuilding._canExpandTimes == 0 then
--         self.extendBtn.gameObject:SetActive(false);
--     else
--         self.extendBtn.gameObject:SetActive(true);
--         self.extendBtnText.text = self.curBuilding._canExpandTimes;
--     end
-- end

-- 总兵力
function UIMainCity:SetTroops()
    local curCity = BuildingService:Instance():GetBuilding(self.curBuilding._id)
    -- print("self.curBuilding._id ========="..self.curBuilding._id);
    if self.buildingType == BuildingType.MainCity or self.buildingType == BuildingType.SubCity then
        local numTroops = curCity:GetAllInCityArmySoldiers();
        self.TroopsText.text = numTroops;
    elseif self.buildingType == BuildingType.PlayerFort then
        local sumNum = 0;
        local armyCount = curCity:GetArmyInfoCounts();
        for i = 1, armyCount do
            local armyInfo = curCity:GetArmyInfos(i);
            if armyInfo ~= nil then
                local troopNum = armyInfo:GetAllSoldierCount();
                sumNum = sumNum + troopNum;
            end
        end
        self.TroopsText.text = sumNum;

    elseif self.buildingType == BuildingType.WildFort or self.buildingType == BuildingType.WildGarrisonBuilding then
        local sumNum = 0;
        local armyCount = curCity:GetWildFortArmyInfoCounts()
        for i = 1, armyCount do
            local armyInfo = curCity:GetWildFortArmyInfos(i)
            if armyInfo ~= nil then
                local troopNum = armyInfo:GetAllSoldierCount();
                sumNum = sumNum + troopNum;
            end
        end
        self.TroopsText.text = sumNum;
    else
        self.TroopsText.text = "0";
    end
end

-- 预备兵
function UIMainCity:SetRedif()
    if self.gameObject.activeSelf == false then
        return;
    end
    if self.curBuilding ~= nil then
        if self.curBuilding._dataInfo.Type == BuildingType.PlayerFort then
            self.RedifTextObj.gameObject:SetActive(false);
        elseif self.curBuilding._dataInfo.Type == BuildingType.WildFort then
            self.RedifTextObj.gameObject:SetActive(false);
        elseif self.curBuilding._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            self.RedifTextObj.gameObject:SetActive(true)
            self.RedifText.text = self.curBuilding:GetBuildingRedif() .. "/" .. DataGameConfig[504].OfficialData;
        else
            self.RedifTextObj.gameObject:SetActive(true);
            local maxRedif = FacilityService:Instance():GetCityPropertyByFacilityProperty(self.curBuilding._id, FacilityProperty.RedifMax);
            self.RedifText.text = self.curBuilding:GetBuildingRedif() .. "/" .. maxRedif + DataGameConfig[315].OfficialData;
        end
    end
end

-- 耐久
function UIMainCity:SetDuration()
--    local curDura = 0;
--    local maxDura = 0;
--    local tiledDurable = PlayerService:Instance():GetTiledDurableByIndex(self.curBuilding._tiledId);
--    if tiledDurable ~= nil then
--        curDura = tiledDurable.tiledCurDurable;
--        maxDura = tiledDurable.tiledMaxDurable;
--    end
--    local maxDurableVal = 0
--    local tiled = MapService:Instance():GetTiledByIndex(self.curBuilding._tiledId)
--    if tiled ~= nil and tiled.tiledInfo ~= nil then
--      maxDurableVal = tiled.tiledInfo.maxDurableVal
--      curDurableVal = tiled:GetDurable()
--    end
--    if maxDurableVal == 0 then
--      self.durableText.text = string.format("%d/%d", curDura, maxDura)
--    else
--      self.durableText.text = string.format("%d/%d", curDurableVal, maxDurableVal)
--    end
    local curDura = MapService:Instance():GetMyTiledDura(self.curBuilding._tiledId);
    local maxDura = MapService:Instance():GetMyTiledMaxDura(self.curBuilding._tiledId);
    self.durableText.text = string.format("%d/%d", curDura, maxDura);
end

-- 建筑物名字
function UIMainCity:SetBuildingName()
    if self.curBuilding ~= nil then
        self._playerName.text = self.curBuilding._name;
    end
end

-- 资源产量数据刷新
function UIMainCity:SetCurrencyEnum()
    local ResourcesMax = PlayerService:Instance():GetInitResourceMax();
    local cityList = PlayerService:Instance():GetPlayerCityList();
    for i = 1, #cityList do
        local city = BuildingService:Instance():GetBuildingByTiledId(cityList[i].tiledId);
        if city ~= nil then
            ResourcesMax = ResourcesMax + city:GetCityPropertyByFacilityProperty(FacilityProperty.ResourcesMax);
        end
    end

    local haveGold = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    self._goldText.text = CommonService:Instance():GetResourceCount(haveGold);

    self._SymbolText.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();

    local wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();
    self._wood.text = self:ChangeColor(wood, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local ironore = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
    self._IronOre.text = self:ChangeColor(ironore, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
    self._Stone.text = self:ChangeColor(stone, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local provision = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue();
    self._Provisions.text = self:ChangeColor(provision, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);
end

function UIMainCity:ChangeColor(value, ResourcesMax)
    if value == nil then
        return;
    end
    if ResourcesMax == nil then
        return;
    end

    if value > ResourcesMax then
        return "<color=#EE5050FF>" .. CommonService:Instance():GetResourceCount(value) .. "</color>";
    else
        return CommonService:Instance():GetResourceCount(value);
    end
end

-- 更新可领取任务数量
function UIMainCity:UpdateTaskCanCount()
    local count = TaskService:Instance():GetOverCount();
    if count > 0 then
        self._taskBtnCountParent.gameObject:SetActive(true);
        self._taskBtnCount.text = count;
    else
        self._taskBtnCountParent.gameObject:SetActive(false);
    end
    self:QuestEffect(count)
end

--任务特效
function UIMainCity:QuestEffect(count)
    if count > 0 then
        if self.questEffect == nil then
            local parent = self._taskBtn
            local effect = EffectsService:Instance():AddEffect(parent, EffectsType.QuestEffect, 2, nil, nil)
            self.questEffect = effect
        end
    else
        if self.questEffect ~= nil then
            EffectsService:Instance():RemoveEffect(self.questEffect)
            self.questEffect = nil;
        end
    end
end

-- 更新左右切换按钮显示
function UIMainCity:UpdateSwitchBtnState()
    -- 按钮呼吸效果
    local leftImage = self.leftSwitchBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image));
    local rightImage = self.rightSwitchBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image));
    local perTime = 0.05;
    local curAlpha = 1.0;
    if self.btnTimer == nil then
        self.btnTimer = Timer.New( function()
            if curAlpha >= 1.0 then
                perTime = - perTime;
            elseif curAlpha <= 0 then
                perTime = - perTime;
            end
            curAlpha = curAlpha + perTime;
            if UIService:Instance():GetUIClass(UIType.UIGameMainView) ~= nil then
                    leftImage.color = Color.New(1, 1, 1, curAlpha);
                    rightImage.color = Color.New(1, 1, 1, curAlpha);
            end
        end , 0.01, -1, true);
        self.btnTimer:Start();
    end

    local index = PlayerService:Instance():GetAllCityIndexByBuildingId(self.curBuilding._id);
    local allCount = PlayerService:Instance():GetAllCityListCount();
    if index <= 1 then
        if self.leftSwitchBtn.gameObject.activeSelf == true then
            self.leftSwitchBtn.gameObject:SetActive(false);
        end
    else
        if self.leftSwitchBtn.gameObject.activeSelf == false then
            self.leftSwitchBtn.gameObject:SetActive(true);
        end
    end
    if index >= allCount then
        if self.rightSwitchBtn.gameObject.activeSelf == true then
            self.rightSwitchBtn.gameObject:SetActive(false);
        end
    else
        if self.rightSwitchBtn.gameObject.activeSelf == false then
            self.rightSwitchBtn.gameObject:SetActive(true);
        end
    end
end

------------------------------- 建造队列相关 -------------------------------
-- 刷新建造队列
function UIMainCity:RefreshBuildQueues()
    if self.curBuilding ~= nil then
        if self.curBuilding._dataInfo.Type == BuildingType.PlayerFort or self.curBuilding._dataInfo.Type == BuildingType.WildFort or self.curBuilding._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            if self.curBuilding._upgradeFortTime ~= 0 then
                self.baseQueueGridObj.gameObject:SetActive(true);
                self.baseQueueTitleValue.text = "1/2";
                if self.baseQueueObjList[1] == nil then
                    local mdata = DataUIConfig[UIType.CityBuildQueueItem];
                    local uiBase = require(mdata.ClassName).new();
                    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.baseQueueGridObj.transform, uiBase, function(go)
                        uiBase:Init();
                        if uiBase.gameObject then
                            self.baseQueueObjList[1] = uiBase;
                            self:CheckShowBuildItem(nil, 1, self.baseQueueObjList);
                        end
                    end );
                else
                   self:CheckShowBuildItem(nil, 1, self.baseQueueObjList);
                end
            else
                self.baseQueueGridObj.gameObject:SetActive(false);
                if self.baseQueueObjList[1] ~= nil then
                    self.baseQueueObjList[1]:SetItemInfo(self.curBuilding._id);
                end
            end
            self.tempQueueGridObj.gameObject:SetActive(false);
        else
            local baseList = self.curBuilding:GetBaseConstructionQueue();
            local tempList = self.curBuilding:GetTempConstructionQueue();

            ----print(baseList:Count().."    "..tempList:Count());

            if baseList == nil or baseList:Count() == 0 then
                self.baseQueueGridObj.gameObject:SetActive(false);
            else
                self.baseQueueGridObj.gameObject:SetActive(true);
                local baseMax = self.curBuilding:GetPlayerBaseConsMax();
                self.baseQueueTitleValue.text = baseList:Count() .. "/" .. baseMax;
            end
            if tempList == nil or tempList:Count() == 0 then
                self.tempQueueGridObj.gameObject:SetActive(false);
            else
                self.tempQueueGridObj.gameObject:SetActive(true);
                local tempMax = self.curBuilding:GetPlayerTempConsMax();
                self.temporaryQueueTitleValue.text = tempList:Count() .. "/" .. tempMax;
            end
            for index = 1, 2 do
                if self.baseQueueObjList[index] == nil then
                    local mdata = DataUIConfig[UIType.CityBuildQueueItem];
                    local uiBase = require(mdata.ClassName).new();
                    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.baseQueueGridObj.transform, uiBase, function(go)
                        uiBase:Init();
                        if uiBase.gameObject then
                            self.baseQueueObjList[index] = uiBase;
                            self:CheckShowBuildItem(baseList, index, self.baseQueueObjList);
                        end
                    end );
                else
                    self:CheckShowBuildItem(baseList, index, self.baseQueueObjList);
                end
            end
            for index = 1, 3 do
                if self.tempQueueObjList[index] == nil then
                    local mdata = DataUIConfig[UIType.CityBuildQueueItem];
                    local uiBase = require(mdata.ClassName).new();
                    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.tempQueueGridObj.transform, uiBase, function(go)
                        uiBase:Init();
                        if uiBase.gameObject then
                            self.tempQueueObjList[index] = uiBase;
                            self:CheckShowBuildItem(tempList, index, self.tempQueueObjList);
                        end
                    end );
                else
                    self:CheckShowBuildItem(tempList, index, self.tempQueueObjList);
                end
            end
        end
    end
end

function UIMainCity:CheckShowBuildItem(buildList, index, uiBaseList)
    if buildList ~= nil then
        if index - 1 < buildList:Count() then
            uiBaseList[index].gameObject:SetActive(true);
            local facility = FacilityService:Instance():GetFacilityByTableId(self.curBuilding._id, buildList:Get(index));
            uiBaseList[index]:SetItemInfo(self.curBuilding._id, facility);
        else
            uiBaseList[index].gameObject:SetActive(false);
        end
    else
        for i =1,#uiBaseList do
            if i > index then
                uiBaseList[i].gameObject:SetActive(fasle);
            else
                uiBaseList[index].gameObject:SetActive(true);
                uiBaseList[index]:SetItemInfo(self.curBuilding._id);
            end
        end
    end

end

return UIMainCity

