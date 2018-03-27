-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");

local ArmyFunctionUI = class("ArmyFunctionUI", UIBase);
require("Game/Hero/HeroService");
local List = require("common/List");
local UIType = require("Game/UI/UIType");
local DataUIConfig = require("Game/Table/model/DataUIConfig");
local HeroCard = require("Game/Hero/HeroCardPart/UIHeroCard");
local ArmyRemoveCardTipUI = require("Game/Army/Model/ArmyRemoveCardTipUI");
local CurrencyEnum = require("Game/Player/CurrencyEnum");
require("Game/UI/UIMix");
require("Game/Hero/HeroService");
require("Game/Army/ArmySlotType");

-- 构造函数
function ArmyFunctionUI:ctor()
    ArmyFunctionUI.super.ctor(self)

    self.curArmyIndexInforText = nil;
    -- 左上角信息
    self.armyAdditionBtn = nil;
    self.soliderAddImage = nil;
    self.campAddImage = nil;
    self.titleAddImage = nil;
    self.campLines = nil;
    -- 阵营加成线
    self.commanderText = nil;
    -- 部队策略值
    self.armyAttributeObj = nil;
    self.soliderCountText = nil;
    -- 总兵力
    self.speedText = nil;
    -- 总速度
    self.attackCityText = nil;
    -- 总攻城
    self.leftBottomObj = nil;
    self.costText = nil;
    -- 部队维持消耗
    self.armyStateObj = nil;
    -- 部队状态
    self.armyStateText = nil;
    self.middleWarningText = nil;
    self.frontWarningText = nil;
    self.backTransform = nil;
    self.middleTransform = nil;
    self.backInitTransform = nil;
    self.backTransformImage = nil;
    self.middleTransformImage = nil;
    self.frontTransformImage = nil;
    self.middleInitTransform = nil;

    self.leftCardInitPosition = nil;
    self.middleCardInitPosition = nil;

    self.frontTransform = nil;
    self.middleMovePosition = nil;
    self.backMovePosition = nil;
    self.backParent = nil;
    self.middleParent = nil;
    self.frontParent = nil;
    self.armyFunctionBtnsObj = nil;
    self.armyIndexPointObj = nil;
    self.armyIndexPoint0 = nil;
    self.armyIndexPoint1 = nil;
    self.armyIndexPoint2 = nil;
    self.armyIndexPoint3 = nil;
    self.armyIndexPoint4 = nil;
    self.conscriptionStateText = nil;
    -- 征兵队列状态
    self.pageLeftBtn = nil;
    -- 左翻页按钮
    self.pageRightBtn = nil;
    -- 右翻页按钮
    self.hideDownPartBtn = nil;
    -- 隐藏downpart按钮
    self.exitBtn = nil;
    -- 退出界面按钮
    self.armyConfigBtn = nil;
    -- 部队配置按钮
    self.armyConscriptionBtn = nil;
    -- 部队征兵按钮
    self.armyChangeBtn = nil;
    -- 部队互换按钮

    self.couldConfigArmy = true;
    -- 是否可以配置（要塞中是不可以配置队伍的）
    ------------------------------------------部队配置DownPart---------------------------------
    self.cardCountText = nil;
    self.closeArmyConfigBtn = nil;
    self.closeSortBgBtn = nil;
    self.sortArmyBtn = nil;
    self.sortListObj = nil;
    self.rarityButton = nil;
    self.classSystemButton = nil;
    self.campButton = nil;
    self.gradeButton = nil;
    self.efficiencyButton = nil;
    self.generalCardButton = nil;

    self.downPartParentObj = nil;
    self.guideAnimParentObj = nil;
    self.downPartBottomY = -540;
    self.downPartUpY = 0;

    self.armyConfigIsShow = false;
    -- 是否处于配置队伍界面
    self.armySortIsShow = false;
    ------------------------------------------ 部队配置功能---------------------------------
    self._curDragObj = nil;
    -- 用来移动的物体
    self._curDragBase = nil;
    -- 移动物体的uibase脚本

    self._curDragSingleDic = { };
    -- 设置被拖动的物体
    self._parentObj = nil;
    -- grid
    self._heroCardResouce = nil;
    self._curDragHeroCardObj = nil;
    self._BeDragObj = nil;
    -- 当前拖拽的物体的父物体
    self._BeDragData = nil;
    self._localPointerPosition = nil;
    self._localScrollPosition = nil;
    self._armyObjList = nil;
    self._quitBtn = nil;


    self.armyIndexPointTable = { };
    self._BgParentList = { };
    self._BgList = { };
    -- 3个位置的父物体
    self._allArmyCampDic = { };
    -- 三军对应框 键:拖拽框物体，值: uibase脚本 （用于检测是否拖到这里）
    self.armyCardObjDic = { };
    -- 键：军队某个位置卡牌obj   值: 卡牌obj上的UIHeroCard脚本
    self._allArmyObjTypeDic = { };
    -- 键: 军队某个位置卡牌obj上的UIHeroCard脚本, 值: armySlotType
    self._allArmyObjSlotTypeDic = { };
    -- 键: 军队某个位置卡牌obj,  值: armySlotType

    self._HeroCardObjList = List.new();

    self._allHaveHeroCardIndexDic = { };
    -- 拥有英雄键值对英雄键值对,键物体，值:GameObject的index
    self._allHaveHeroCardDic = { };
    -- 拥有英雄键值对英雄键值对,键物体，值脚本

    ------------------------------------------ 滑动部分---------------------------------------------

    self._myMIx = nil;

    self.isFirstUIOpen = true;
    -- 界面是否是第一次打开
    self.curBuilding = nil;
    -- 当前城市
    self._curArmyInfo = nil;
    -- 当前部队信息
    self.curArmyIndex = 1;
    -- 当前显示界面的部队Index 1-5
    self.armyCoutnMax = 5;
    -- 当前可以显示的部队数,根据校场的等级，最大5

    self.sortType = HeroSortType.default;
    -- 当前英雄列表的排序类型
    -- 部队中排序的list
    self.cardDefaultList = nil;
    self.isDownPartDrogEnd = false;
    -- 是不是DownPart部分的拖拽
    self.downPartObj = nil;
    self.previousOpenedUi = nil;
    -- 之前打开的界面

    self.perTime = 0.03;
    self.curAlpha = 1.0;
end

-- 注册控件
function ArmyFunctionUI:DoDataExchange()

    self.curArmyIndexInforText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/LeftUp/ArmyIndexInformation");
    self.armyAdditionBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/LeftMiddle/Image");
    self.soliderAddImage = self:RegisterController(UnityEngine.UI.Image, "FunctionBaseUI/LeftMiddle/Image/SoliderAddImage");
    self.campAddImage = self:RegisterController(UnityEngine.UI.Image, "FunctionBaseUI/LeftMiddle/Image/CampAddImage");
    self.titleAddImage = self:RegisterController(UnityEngine.UI.Image, "FunctionBaseUI/LeftMiddle/Image/TitleAddImage");
    self.campLines = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/LeftMiddle/Image/HighLightLines");
    self.commanderText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/LeftMiddle/Image/CommanderText");
    self.armyAttributeObj = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/LeftMiddle/Bottom");
    self.soliderCountText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/LeftMiddle/Bottom/SoliderCount/Value");
    self.speedText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/LeftMiddle/Bottom/Speed/Value");
    self.attackCityText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/LeftMiddle/Bottom/AttackCity/Value");
    self.backTransform = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/Back");
    self.middleTransform = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/Middle");
    self.frontTransform = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/Front");
    self.backTransformImage = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ArmyCards/Back");
    self.middleTransformImage = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ArmyCards/Middle");
    self.frontTransformImage = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ArmyCards/Front");
    self.leftCardInitPosition = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/LeftCardInitPosition");
    self.middleCardInitPosition = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/MiddleCardInitPosition");
    -- self.backInitTransform = self.backTransform.position;
    -- self.middleInitTransform = self.middleTransform.position;
    self.middleMovePosition = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/MiddleMovePosition");
    self.backMovePosition = self:RegisterController(UnityEngine.RectTransform, "FunctionBaseUI/ArmyCards/BackMovePosition");
    self.backParent = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyCards/Back/BackParent");
    self.middleParent = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyCards/Middle/MiddleParent");
    self.frontParent = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyCards/Front/FrontParent");
    self.armyFunctionBtnsObj = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyFunctionBtns");
    self.armyIndexPointObj = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyIndexPoint");
    self.armyIndexPoint0 = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyIndexPoint/Image0");
    self.armyIndexPoint1 = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyIndexPoint/Image1");
    self.armyIndexPoint2 = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyIndexPoint/Image2");
    self.armyIndexPoint3 = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyIndexPoint/Image3");
    self.armyIndexPoint4 = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyIndexPoint/Image4");

    self.leftBottomObj = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/LeftBottom");
    self.costText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/LeftBottom/CostText");

    self.armyStateObj = self:RegisterController(UnityEngine.Transform, "FunctionBaseUI/ArmyState");
    self.armyStateText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/ArmyState/StateText");

    self.middleWarningText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/ArmyCards/Middle/WarningText");
    self.frontWarningText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/ArmyCards/Front/WarningText");
    self.conscriptionStateText = self:RegisterController(UnityEngine.UI.Text, "FunctionBaseUI/ArmyFunctionBtns/ArmyConscriptionBtn/ConscriptionStateText");

    self.pageLeftBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/PageLeftBtn");
    self.pageRightBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/PageRightBtn");
    self.leftImage = self.pageLeftBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image));
    self.rightImage = self.pageRightBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image));
    self.hideDownPartBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ExitBtn1");
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ExitBtn2");
    self.armyConfigBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ArmyFunctionBtns/ArmyConfigBtn");
    self.armyConscriptionBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ArmyFunctionBtns/ArmyConscriptionBtn");
    self.armyChangeBtn = self:RegisterController(UnityEngine.UI.Button, "FunctionBaseUI/ArmyFunctionBtns/ArmyChangeBtn");
    self.downPartParentObj = self:RegisterController(UnityEngine.Transform, "DownPartParent");
    self.guideAnimParentObj = self:RegisterController(UnityEngine.Transform, "GuideAnimParent");

    self._BgList[3] = self.backTransform;
    self._BgList[2] = self.middleTransform;
    self._BgList[1] = self.frontTransform;
    self._BgParentList[3] = self.backParent;
    self._BgParentList[2] = self.middleParent;
    self._BgParentList[1] = self.frontParent;

    self.armyIndexPointTable[1] = self.armyIndexPoint0.gameObject;
    self.armyIndexPointTable[2] = self.armyIndexPoint1.gameObject;
    self.armyIndexPointTable[3] = self.armyIndexPoint2.gameObject;
    self.armyIndexPointTable[4] = self.armyIndexPoint3.gameObject;
    self.armyIndexPointTable[5] = self.armyIndexPoint4.gameObject;
end

-- 注册点击事件
function ArmyFunctionUI:DoEventAdd()
    self:AddListener(self.hideDownPartBtn, self.OnClickExitBtn);
    self:AddListener(self.exitBtn, self.OnClickExitBtn);
    self:AddListener(self.armyAdditionBtn, self.OnClickAdditionBtn);
    self:AddListener(self.armyConfigBtn, self.OnClickConfigBtn);
    self:AddListener(self.armyConscriptionBtn, self.OnClickConscriptionBtn);
    self:AddListener(self.armyChangeBtn, self.OnClickChangeBtn);
    self:AddListener(self.pageLeftBtn, self.OnClickPageLeftBtn);
    self:AddListener(self.pageRightBtn, self.OnClickPageRightBtn);

    self:AddListener(self.backTransformImage, self.OnClickConfigBtn);
    self:AddListener(self.middleTransformImage, self.OnClickConfigBtn);
    self:AddListener(self.frontTransformImage, self.OnClickFrontCardBgBtn);
end

function ArmyFunctionUI:_OnHeartBeat()
    -- 切换按钮呼吸效果
    if self.pageLeftBtn ~= nil then
        if self.pageLeftBtn.gameObject.activeSelf == true then
            if self.curAlpha >= 1.0 or self.curAlpha <= 0 then
                self.perTime = -self. perTime;
            end
            self.curAlpha = self.curAlpha + self.perTime;
            self.leftImage.color = Color.New(1,1,1,self.curAlpha);     
        end
    end
    if self.pageRightBtn ~= nil then
        if self.pageRightBtn.gameObject.activeSelf == true then
            if self.curAlpha >= 1.0 or self.curAlpha <= 0 then
                self.perTime = -self. perTime;
            end
            self.curAlpha = self.curAlpha + self.perTime;
            self.rightImage.color = Color.New(1,1,1,self.curAlpha);     
        end
    end
end

function ArmyFunctionUI:OnHide(param)
    if self.previousOpenedUi ~= nil then
        UIService:Instance():ShowUI(self.previousOpenedUi);
    end
    self.previousOpenedUi = nil;
    self.couldConfigArmy = true;
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
    if baseClass ~= nil then
        baseClass:SetResource();
    end
end

function ArmyFunctionUI:OnBeforeDestroy()
    if self then
        self.pageLeftBtn = nil;
        self.pageRightBtn = nil;
        CommonService:Instance():RemoveAllTimeDownInfoInUI(UIType.ArmyFunctionUI);
    end
end

function ArmyFunctionUI:OnDestroy()
end

-- 默认打开第一个部队
function ArmyFunctionUI:OnShow(param)
    local isShow = param[0];
    local cityId = param[1];
    if param[3] ~= nil then
        self.previousOpenedUi = param[3];
    end
    -- 刷新3个位置的卡牌信息 传过来的index是0开始
    self.curArmyIndex = param[2] + 1;
    --LogManager:Instance():Log("cityId: " .. cityId .. "  showIndex: " .. self.curArmyIndex);
    self.curBuilding = BuildingService:Instance():GetBuilding(cityId);

    self.couldConfigArmy = isShow;
    self:SetConfigChangeUI(isShow);
    self:RefreshArmyPart();

    -- 加载 刷新卡牌列表 DownPart 改为点击配置按钮后才开始加载
--    if self.couldConfigArmy == true then
--        self.sortType = HeroSortType.default;
--        self:RefreshUIShow();
--    end

    self.isFirstUIOpen = false;

    if GuideServcice:Instance():GetIsFinishGuide() == false then
        local uiGuide = UIService:Instance():GetUIClass(UIType.UIGuideOneAreaClick);
        if uiGuide ~= nil then
            uiGuide:ChangeAnimParent(self.guideAnimParentObj);
        end
    end
end

-- 滑动部分注册、监听
function ArmyFunctionUI:AddArmyConfigLister(obj)
    self.downPartObj = obj;
    local parentPath = DataUIConfig[UIType.UIScorll].ResourcePath;

    self.sortListObj = obj.transform:Find("SortListObj"):GetComponent(typeof(UnityEngine.Transform));
    self.closeArmyConfigBtn = obj.transform:Find("CloseArmyConfigBtn"):GetComponent(typeof(UnityEngine.UI.Button));
    self.closeSortBgBtn = obj.transform:Find("SortListObj/BackgroundBgBtn"):GetComponent(typeof(UnityEngine.UI.Button));
    self.sortArmyBtn = obj.transform:Find("SortArmyBtn"):GetComponent(typeof(UnityEngine.UI.Button));
    self.rarityButton = obj.transform:Find("SortListObj/RarityButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.classSystemButton = obj.transform:Find("SortListObj/ClassSystemButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.campButton = obj.transform:Find("SortListObj/CampButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.gradeButton = obj.transform:Find("SortListObj/GradeButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.efficiencyButton = obj.transform:Find("SortListObj/EfficiencyButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.generalCardButton = obj.transform:Find("SortListObj/GeneralCardButton"):GetComponent(typeof(UnityEngine.UI.Button));
    self.cardCountText = obj.transform:Find("CardCountText"):GetComponent(typeof(UnityEngine.UI.Text));

    self:AddListener(self.closeArmyConfigBtn, self.OnClickCloseArmyConfigBtn);
    self:AddListener(self.closeSortBgBtn, self.OnClickSortArmyBtn);
    self:AddListener(self.sortArmyBtn, self.OnClickSortArmyBtn);
    self:AddListener(self.rarityButton, self.OnClickRarityButton);
    self:AddListener(self.classSystemButton, self.OnClickClassSystemButton);
    self:AddListener(self.campButton, self.OnClickCampButton);
    self:AddListener(self.gradeButton, self.OnClickGradeButton);
    self:AddListener(self.efficiencyButton, self.OnClickEfficiencyButton);
    self:AddListener(self.generalCardButton, self.OnClickGeneralCardButton);

    self:SetSortListObj(false);
end

-- 注册 部队更新的通知
function ArmyFunctionUI:RegisterAllNotice()
--    self:RegisterNotice(L2C_Army.ArmyBaseInfo, self.ArmyBaseCallBack)
--    self:RegisterNotice(L2C_Army.SyncPlayerTroopInfo, self.ArmyBaseCallBack)
--    self:RegisterNotice(L2C_Army.HeroRemoveCardResponse, self.ArmyBaseCallBack)
end

-- 部队更新回调
function ArmyFunctionUI:ArmyBaseCallBack()
    if self then
        if self.gameObject.activeSelf == true then
            if self._curDragObj then
                self._curDragObj.gameObject:SetActive(false);
            end
            -- 刷新部队信息
            self:RefreshArmyPart();
            -- 刷新卡牌列表状态
            self:RefreshUIShow(false);
        end
    end
end

-- 部队配置按钮、部队互换按钮状态(要塞中是不打开的)
function ArmyFunctionUI:SetConfigChangeUI(isShow)
    self.armyConfigBtn.gameObject:SetActive(isShow);
    self.armyChangeBtn.gameObject:SetActive(isShow);
end

function ArmyFunctionUI:GetMyHeroList()
    local size = HeroService:Instance():GetOwnHeroCount();
    local herolist = List:new();
    for i = 1, size do
        herolist:Push(HeroService:Instance():GetOwnHeroes(i))
    end
    return herolist;
end

-- 刷新加载DownPart UI  isRefreshDownMove 是否重置DownPart的滑动
function ArmyFunctionUI:RefreshUIShow(isRefreshDownMove)
    local sameHeroList = self:GetMyHeroList()
    sameHeroList = HeroService:Instance():sortingInPackage(self.sortType, sameHeroList);
    self.cardDefaultList = sameHeroList;

    -- 排序物体
    if self._myMIx == nil then
        local mMix = UIMix.new();
        mMix:SetLoadCallBack( function(obj)
            self:AddArmyConfigLister(obj);
            -- 第一次加载是点击了配置按钮，移动到上方
            self:ShowArmyConfigUI(self.armyConfigIsShow);
            self:SetAllCardCount();

            mMix:ScrollOnUpCB( function(...) self:OnMouseUp(...) end);
            mMix:ScrollOnDownCB( function(...) self:OnMouseDown(...) end);
            mMix:ScrollOnClickCB( function(go, eventData) self:OnMouseClick(go, eventData) end);
            self._myMIx = mMix;
            mMix:SetPostionObj(self.gameObject);
            obj:SetActive(true);

        end );
        mMix:MakeScrollDrag(self.cardDefaultList, self.downPartParentObj.transform);
    else
        -- 如果有了
        if isRefreshDownMove ~= nil and isRefreshDownMove == false then
            self._myMIx:SortingCardList(sameHeroList);
            return;
        end
        self._myMIx:MakeScrollDrag(self.cardDefaultList, self.downPartParentObj.transform);
        self:SetAllCardCount();
    end
end

-- 设置显示卡牌的数量
function ArmyFunctionUI:SetAllCardCount()
    if self.cardCountText ~= nil then
        self.cardCountText.gameObject:SetActive(true);

        local maxCount = HeroService:Instance():GetCardMaxLimit()
        local curCount = 0;
        if self.cardDefaultList ~= nil then
            curCount = self.cardDefaultList:Count();
        end
        self.cardCountText.text = curCount .. "/" .. maxCount;
    end
end

-- 滑动列表中卡牌点击
function ArmyFunctionUI:OnMouseClick(go, eventData)
    print("滑动列表中卡牌点击")
    if self._BeDragData then
        HeroService:Instance():ShowHeroInfoUI(self._BeDragData.id,false);
    end
end

-- 设置单个武将卡的信息 mHeroCard：UIHeroCard    heroCard：HeroCard
function ArmyFunctionUI:SetSingleHeroCardData(mHeroCard, heroCard)
    mHeroCard:Init();
    mHeroCard:SetClickModel(true)
    mHeroCard:SetHeroCardMessage(heroCard, true);
    mHeroCard:SetHeroInArmy(heroCard);
    -- 加入键值对
    if self._allHaveHeroCardDic[mHeroCard.gameObject] == nil then
        self._HeroCardObjList:Push(mHeroCard.gameObject);
        self:AddOnUp(mHeroCard, self.OnUpStartBtn);
    end
    self._allHaveHeroCardDic[mHeroCard.gameObject] = heroCard;
end

function ArmyFunctionUI:OnArmyCardMouseUp()
    -- LogManager:Instance():Log(" ArmyFunctionUI:OnArmyCardMouseUp");
    self._BeDragObj.gameObject:SetActive(false);
end

function ArmyFunctionUI:OnClickHeroBtn(obj, eventData)
    --LogManager:Instance():Log("You Have Clicked 队伍中的卡牌");
    HeroService:Instance():ShowHeroInfoUI(self._allHaveHeroCardDic[obj].id,false);
end

-- 刷新部队信息
function ArmyFunctionUI:RefreshArmyPart()
    self._curArmyInfo = self.curBuilding:GetArmyInfo(self.curArmyIndex);
    if self._curArmyInfo == nil then
        LogManager:Instance():Log("self._curArmyInfo is nil ");
        return;
    end
    -- LogManager:Instance():Log("tiledId:"..self._curArmyInfo.tiledId.."  self._curArmyInfo.spawnBuildng:  "..self._curArmyInfo.spawnBuildng);
    if self.couldConfigArmy == true then
        -- 主城分城
        self.armyCoutnMax = self.curBuilding:GetCityPropertyByFacilityProperty(FacilityProperty.ArmyCount);
    else
        -- 要塞
        local curBuilding = BuildingService:Instance():GetBuilding(self._curArmyInfo.curBuildingId);
        if curBuilding._dataInfo.Type == BuildingType.PlayerFort then
            if curBuilding ~= nil then
                self.armyCoutnMax = curBuilding:GetArmyInfoCounts();
            end
        elseif curBuilding._dataInfo.Type == BuildingType.WildFort or curBuilding._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            if curBuilding ~= nil then
                self.armyCoutnMax = curBuilding:GetWildFortArmyInfoCounts();
            end
        end
    end

    if self.couldConfigArmy == false then
        self.frontWarningText.text = "";
        self.middleWarningText.text = "";
    elseif self.curBuilding:CheckArmyFrontOpen(self.curArmyIndex) == true then
        self.frontWarningText.text = "<color=#C0C0C0>未配置卡牌</color>";
        self.middleWarningText.text = "<color=#C0C0C0>未配置卡牌</color>";
    else
        self.frontWarningText.text = "<color=#E3170D>统帅厅Lv." .. self.curArmyIndex .. "开放</color>";
        self.middleWarningText.text = "<color=#C0C0C0>未配置卡牌</color>";
    end

    if self._curDragObj then
        self._curDragObj.gameObject:SetActive(false);
    end

    -- 左右按钮状态
    self:SetPageBtnState();

    -- 设置部队的基本信息
    self:RefreshArmyBaseInfo(self._curArmyInfo);

    -- 设置部队的卡牌信息
    self:SetSingCardInfo(ArmySlotType.Front);
    self:SetSingCardInfo(ArmySlotType.Center);
    self:SetSingCardInfo(ArmySlotType.Back);
end

function ArmyFunctionUI:SetBackClicked(armyAlotType,couldClick)
    if armyAlotType == ArmySlotType.Back then
        self.backTransformImage.interactable = couldClick;
    elseif armyAlotType == ArmySlotType.Center then
        self.middleTransformImage.interactable = couldClick;
    elseif armyAlotType == ArmySlotType.Front then
        self.frontTransformImage.interactable = couldClick;
    end
end

function ArmyFunctionUI:SetSingCardInfo(armyAlotType)
    if self._curArmyInfo == nil then
        return;
    end
    local uiBase = self:GetArmyBase(armyAlotType);
    local heroCardInfo = self._curArmyInfo:GetCard(armyAlotType);
    if heroCardInfo == nil or heroCardInfo.id == 0 then
        self:SetBackClicked(armyAlotType,true);
        if uiBase ~= nil then
            uiBase.gameObject:SetActive(false);
            self._allHaveHeroCardDic[uiBase.gameObject] = nil;
        else
            self:LoadOneCard(armyAlotType,false)
        end
    else
        self:SetBackClicked(armyAlotType,false);
        if uiBase ~= nil then
            uiBase.gameObject:SetActive(true);
            --uiBase:SetClickModel(true);
            uiBase:SetHeroCardMessage(heroCardInfo);
            self:SetArmyState(armyAlotType,uiBase);
            self._allHaveHeroCardDic[uiBase.gameObject] = heroCardInfo;
        else
            local camp = self._BgList[armyAlotType].gameObject;
            self:LoadOneCard(armyAlotType,true,heroCardInfo);
        end
    end
end

function ArmyFunctionUI:LoadOneCard(armyAlotType,isShow,heroCardInfo)
    local camp = self._BgList[armyAlotType].gameObject;
    if self._allArmyCampDic[camp] == nil then
        local mdata = DataUIConfig[UIType.UIHeroCard];
        local uiBase = require(mdata.ClassName).new();
        local campParent = self._BgParentList[armyAlotType].gameObject;
        -- 加载预制
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, campParent.transform, uiBase, function(go)
            uiBase:Init();
            if uiBase then
                --uiBase:SetClickModel(true);
                uiBase:SetHeroCardMessage();
                self:SetArmyState(armyAlotType,uiBase);
                self:AddOnClick(uiBase, self.OnClickHeroBtn);
                self:AddOnDown(uiBase, self.OnDownStartBtn);
                self:AddOnUp(uiBase, self.OnUpStartBtn);
                -- 没有滑动
                self:AddOnDrag(uiBase, self.OnDragStartBtn);

                self._allArmyCampDic[camp] = uiBase;
                self.armyCardObjDic[uiBase.gameObject] = uiBase;
                self._allArmyObjTypeDic[uiBase] = armyAlotType;
                self._allArmyObjSlotTypeDic[uiBase.gameObject] = armyAlotType;
                uiBase.gameObject:SetActive(isShow);
                if isShow then
                    --uiBase:SetClickModel(true);
                    uiBase:SetHeroCardMessage(heroCardInfo);
                    self:SetArmyState(armyAlotType,uiBase);
                    self._allHaveHeroCardDic[uiBase.gameObject] = heroCardInfo;
                end
            end
        end );
    end
end

-- 返回3个位置卡牌 枚举对应的脚本
function ArmyFunctionUI:GetArmyBase(mArmySlotType)
    for k, v in pairs(self._allArmyObjTypeDic) do
        if mArmySlotType == v then
            return k;
        end
    end
    return nil;
end

function ArmyFunctionUI:SetArmyState(armyAlotType,uibase)
    -- 状态优先级： 征兵＞重伤＞疲劳
    -- 设置征兵状态
    local isconscripting = self._curArmyInfo:IsConscription(armyAlotType);
    if isconscripting == true then
        local timeDown = self._curArmyInfo:GetConscriptionEndTime(armyAlotType);
        uibase:SetConscrtptionState(self._curArmyInfo, armyAlotType, isconscripting, timeDown);
        uibase:HeroHurt(self._curArmyInfo.spawnSlotIndex, false);
        uibase:HeroTired(self._curArmyInfo.spawnSlotIndex, false);
    else
        uibase:SetConscrtptionState(self._curArmyInfo, armyAlotType, false, 0);
        -- 设置重伤状态
        if self._curArmyInfo:CheckArmyCardIsHurt(armyAlotType) == true then
            uibase:HeroHurt(self._curArmyInfo.spawnSlotIndex, true);
            uibase:HeroTired(self._curArmyInfo.spawnSlotIndex, false);
        else
            -- 设置疲劳状态
            uibase:HeroHurt(self._curArmyInfo.spawnSlotIndex, false);
            if self._curArmyInfo:CheckArmyCardIsTired(armyAlotType) == true then
                uibase:HeroTired(self._curArmyInfo.spawnSlotIndex, true);
            else
                uibase:HeroTired(self._curArmyInfo.spawnSlotIndex, false);
            end
        end
    end
end

function ArmyFunctionUI:RefreshArmyBaseInfo(armyInfo)
    local armyInBuildingId = 0;
    if armyInfo.curBuildingId == 0 then
        armyInBuildingId = armyInfo.spawnBuildng;
    else
        armyInBuildingId = armyInfo.curBuildingId;
    end
    local armyInBuilding = BuildingService:Instance():GetBuilding(armyInBuildingId);
    if armyInBuilding ~= nil then
        local cityName = armyInBuilding._name;
        local typeName = "";
        local armyInBuildIndex = 0;
        if armyInBuilding._dataInfo.Type == BuildingType.MainCity then
            typeName = "主城";
            armyInBuildIndex = self.curArmyIndex;
        elseif armyInBuilding._dataInfo.Type == BuildingType.SubCity then
            typeName = "分城";
            armyInBuildIndex = self.curArmyIndex;
        elseif armyInBuilding._dataInfo.Type == BuildingType.PlayerFort then
            typeName = "要塞";
            armyInBuildIndex = armyInBuilding:GetArmyIndex(armyInfo.spawnBuildng, armyInfo.spawnSlotIndex);
        elseif armyInBuilding._dataInfo.Type == BuildingType.WildFort then
            typeName = "野外要塞"
            armyInBuildIndex = armyInBuilding:GetWildFortArmyIndex(armyInfo.spawnBuildng, armyInfo.spawnSlotIndex);
        elseif armyInBuilding._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            typeName = "野外军营"
            armyInBuildIndex = armyInBuilding:GetWildFortArmyIndex(armyInfo.spawnBuildng, armyInfo.spawnSlotIndex);
        end
        self:SetArmyIndexPointState(armyInBuildIndex);
        self.curArmyIndexInforText.text = "<color=#B39156>" .. cityName .. "-" .. typeName .. "</color>部队 " .. armyInBuildIndex;
    end

    -- 统帅值
    self.commanderText.text = armyInfo:GetArmyAllCost() .. "/" .. self.curBuilding:GetCityPropertyByFacilityProperty(FacilityProperty.Cost);

    -- 设置加成显示
    self:SetArmyAdditions(armyInfo);
    local curArmyCardCounts = armyInfo:GetCardCount();
    -- LogManager:Instance():Log("curArmyCardCounts:"..curArmyCardCounts)
    if curArmyCardCounts <= 0 then
        self.armyAttributeObj.gameObject:SetActive(false);
        self.leftBottomObj.gameObject:SetActive(false);
        self.conscriptionStateText.gameObject:SetActive(false);
        self.armyStateObj.gameObject:SetActive(false);
    else
        if armyInfo:GetArmyState() == ArmyState.None then
            self.armyStateObj.gameObject:SetActive(false);
        else
            if self.armyConfigIsShow == true then
                self.armyStateObj.gameObject:SetActive(false);
            else
                self.armyStateObj.gameObject:SetActive(true);
            end
            self.armyStateText.text = CommonService:Instance():FormatArmyState(armyInfo:GetArmyState(),self.couldConfigArmy);
        end
        self.armyAttributeObj.gameObject:SetActive(true);
        if self.armyConfigIsShow == false then
            self.leftBottomObj.gameObject:SetActive(true);
        else
            self.leftBottomObj.gameObject:SetActive(false);
        end
        self.conscriptionStateText.gameObject:SetActive(true);

        -- 总兵力
        self.soliderCountText.text = armyInfo.allSoldierCount;
        -- 速度
        local speedAdd = FacilityService:Instance():GetCityPropertyByFacilityProperty(self._curArmyInfo.spawnBuildng, FacilityProperty.ArmySpeed);
        if speedAdd > 0 then
            self.speedText.text = armyInfo:GetSpeed() .. "+<color=#FFFF00>" .. speedAdd .. "</color>";
        else
            self.speedText.text = armyInfo:GetSpeed();
        end
        -- 攻城值
        self.attackCityText.text = armyInfo:GetAllAttackCityValue();
        -- 部队维持粮草消耗
        local costTest = armyInfo:GetKeepArmyCost(CurrencyEnum.Grain);
        self.costText.text = costTest .. "/小时";

        -- 征兵队列信息显示
        local maxConscriptionCount = 0;
        local curConsCount = 0;
        if self.couldConfigArmy == true then
            -- 主城分城
            local building = BuildingService:Instance():GetBuilding(self._curArmyInfo.spawnBuildng);
            maxConscriptionCount = building:GetCityPropertyByFacilityProperty(FacilityProperty.RecruitQueue);
            curConsCount = building:GetArmyConscritionCount();
        else
            -- 要塞
            local fort = BuildingService:Instance():GetBuilding(self._curArmyInfo.curBuildingId);
            if fort._dataInfo.Type == BuildingType.PlayerFort then
                maxConscriptionCount = 1;
                curConsCount = fort:GetFortArmyConscritionCount();
            elseif fort._dataInfo.Type == BuildingType.WildFort or fort._dataInfo.Type == BuildingType.WildGarrisonBuilding then
                maxConscriptionCount = 1;
                curConsCount = fort:GetWildFortArmyConscritionCount();
            end
        end
        if self._curArmyInfo:IsArmyInConscription() == true then
            self.conscriptionStateText.text = "<color=#FFFF00>征兵中</color>";
        else
            if curConsCount < maxConscriptionCount then
                self.conscriptionStateText.text = "<color=#FFFF00>" .. curConsCount .. "/" .. maxConscriptionCount .. "</color>";
            else
                self.conscriptionStateText.text = "<color=#FF0000>" .. curConsCount .. "/" .. maxConscriptionCount .. "</color>";
            end
        end
    end
end

-- 部队位置小圆点显示
function ArmyFunctionUI:SetArmyIndexPointState(armyInBuildIndex)
    for i = 1, #self.armyIndexPointTable do
        if i <= self.armyCoutnMax then
            self.armyIndexPointTable[i]:SetActive(true);
            if i == armyInBuildIndex then
                self.armyIndexPointTable[i].transform:GetChild(0).gameObject:SetActive(true);
            else
                self.armyIndexPointTable[i].transform:GetChild(0).gameObject:SetActive(false);
            end
        else
            self.armyIndexPointTable[i]:SetActive(false);
        end
    end

    if self.armyConfigIsShow == false then
        self.armyIndexPointObj.gameObject:SetActive(true);
    else
        self.armyIndexPointObj.gameObject:SetActive(false);
    end
end

-- 设置部队加成图片显示（兵种、阵营、称号）
function ArmyFunctionUI:SetArmyAdditions(armyInfo)
    if armyInfo == nil then
        LogManager:Instance():Log("armyInfo is nil !")
        return;
    end
    -- 兵种加成
    local soldierAdd = armyInfo:CheckSoldierAddition();
    self.soliderAddImage.sprite =(soldierAdd == true and GameResFactory.Instance():GetResSprite("Soldiers") or GameResFactory.Instance():GetResSprite("SoldiersGrey"));
    -- 阵营加成
    local campAdd = armyInfo:CheckCampAddition();
    self.campAddImage.sprite =(campAdd == true and GameResFactory.Instance():GetResSprite("Position") or GameResFactory.Instance():GetResSprite("PositionGrey"));
    local addedCamp = -1;
    if campAdd == true then
        addedCamp = armyInfo:GetAddedCamp();
    end
    for i = 1, self.campAddImage.transform.childCount do
        local item = self.campAddImage.transform:GetChild(i - 1);
        if i == addedCamp then
            item.gameObject:SetActive(true);
        else
            item.gameObject:SetActive(false);
        end
    end
    -- 阵营加成线
    self.campLines.gameObject:SetActive(campAdd);
    if campAdd == true then
        for i = 1, self.campLines.childCount do
            local item = self.campLines:GetChild(i - 1);
            if i == addedCamp then
                item.gameObject:SetActive(true);
            else
                item.gameObject:SetActive(false);
            end
        end
    end
    -- 称号加成
    local titleAdd = armyInfo:CheckTitleAddition();
    self.titleAddImage.sprite =(titleAdd == true and GameResFactory.Instance():GetResSprite("Number") or GameResFactory.Instance():GetResSprite("NumberGre"));
end

-- 松开
-- @parem obj:物体，eventData:事件回调
function ArmyFunctionUI:OnUpStartBtn(obj, eventData)
    if self.armyCardObjDic[obj] ~= nil then
        self.armyCardObjDic[obj]:SetTransparentBg(false);
    end
    LogManager:Instance():Log("松开！！！！！！！！！！！！！");
    if self.armyConfigIsShow == false then
        return;
    end
    if self._curDragObj ~= nil then
        self._curDragObj.gameObject:SetActive(false);
    end
    -- 如果没有拖拽
    if self._localPointerPosition == nil then
         LogManager:Instance():Log("self._localPointerPosition is nil");
        if self._curDragObj.gameObject then
            self._curDragObj.gameObject:SetActive(false);
        end
        return;
    end
    local isInArmy = self:CheckInArmy();
    local nChangeIndex = -1;
    -- 是否在框中
    local mInArmyKuang = false;
    -- LogManager:Instance():Log("开始检查是否拖到框中   _allArmyCampDic.size:"..#self._allArmyCampDic);
    for k, v in pairs(self._allArmyCampDic) do
        -- LogManager:Instance():Log("111");
        local vecTemp = k.transform.localPosition;
        local fWidth = k.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.width / 2;
        local fHeight = k.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).rect.height / 2;
        -- 如果在框内
        if ((vecTemp.x - self._localPointerPosition.x <= fWidth) and(vecTemp.x - self._localPointerPosition.x >=(0 - fWidth)) and(vecTemp.y - self._localPointerPosition.y <= fHeight) and(vecTemp.y - self._localPointerPosition.y >=(0 - fHeight))) then
            if GuideServcice:Instance():GetIsFinishGuide() == true then
                mInArmyKuang = true;
                -- LogManager:Instance():Log("!!!!!!!!!!!!!!拖拽结束后in 框中，位置： "..self._allArmyObjSlotTypeDic[v.gameObject]);
                if self._allArmyObjSlotTypeDic[v.gameObject] == ArmySlotType.Front then
                    if self.curBuilding:CheckArmyFrontOpen(self.curArmyIndex) == true then
                        self:ArmyDragLogic(v, isInArmy);
                    else
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 83);
                    end
                else
                    self:ArmyDragLogic(v, isInArmy);
                end
            else
                if GuideServcice:Instance():GetCurrentStep() == 9 or GuideServcice:Instance():GetCurrentStep() == 80 then
                    if self._allArmyObjSlotTypeDic[v.gameObject] == ArmySlotType.Back then
                        mInArmyKuang = true;
                        self:ArmyDragLogic(v, isInArmy);
                    end
                elseif GuideServcice:Instance():GetCurrentStep() == 32 or GuideServcice:Instance():GetCurrentStep() == 86 then
                    if self._allArmyObjSlotTypeDic[v.gameObject] == ArmySlotType.Center then
                        mInArmyKuang = true;
                        self:ArmyDragLogic(v, isInArmy);
                    end
                end
            end
        end
    end
    -- 如果没在框内
    if mInArmyKuang == false then
        -- LogManager:Instance():Log("!!!!!!!!!!!!!!拖拽结束 is not in army 框中");
        self:HandleHeroNotIn(isInArmy);
    end
end

-- 处理没在框内的逻辑
function ArmyFunctionUI:HandleHeroNotIn(isInArmy, v)
    if self.isDownPartDrogEnd == true then
        return;
    end
    self._curDragObj.gameObject:SetActive(false);
    if isInArmy == true then
        if self:CheckArmyOperationState(self._curArmyInfo) == false then
            return;
        end
        local drogedIndex = self._curArmyInfo:GetCardArmySlotType(self._BeDragData.id);
        if self:CheckCardState(self._curArmyInfo, drogedIndex) == false then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 72);
            return;
        end
        -- LogManager:Instance():Log("被拖拽到的卡牌id:"..self._BeDragData.id.."   拥有的兵力:"..self._BeDragData.troop);
        if self._BeDragData.troop <= 100 then
            self:SendRemoveMsg();
        else
            ArmyRemoveCardTipUI:RegistConfirmEvnet( function() self:SendRemoveMsg() end);
            UIService:Instance():ShowUI(UIType.ArmyRemoveCardTipUI, self._BeDragData);
        end
    end
end

function ArmyFunctionUI:ArmyDragLogic(v, mmisInArmy)

    -- 队伍和卡牌状态检测
    -- 拖拽的卡牌在队伍中的位置

    local drogArmyBuilding = BuildingService:Instance():GetBuilding(self._curArmyInfo.spawnBuildng);
    local drogArmyInfo = drogArmyBuilding:GetArmyInfoByCardId(self._BeDragData.id);
    -- drogedIndex有可能为nil
    local drogedIndex = nil;
    if drogArmyInfo ~= nil then
        drogedIndex = drogArmyInfo:GetCardArmySlotType(self._BeDragData.id);
    end
    -- LogManager:Instance():Log("拖拽的卡牌的id ："..self._BeDragData.id);

    -- 如果框內沒有英雄
    if self._allHaveHeroCardDic[v.gameObject] == nil then
        -- LogManager:Instance():Log("!!!!!!!!!!!!!!!!!!!!!!!!!框內沒有英雄");
        -- LogManager:Instance():Log("当前要配置的部队位置 ： "..self._curArmyInfo.spawnSlotIndex.."   "..self.curArmyIndex);
        -- 只检测拖拽的卡牌征兵状态
        if self:CheckCardState(drogArmyInfo, drogedIndex) == false then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 72);
            return;
        end
        -- 队伍状态检测
        if self:CheckArmyOperationState(drogArmyInfo) == false or self:CheckArmyOperationState(self._curArmyInfo) == false then
            return;
        end

        if mmisInArmy == true then
            -- 如果被拖动的物体在军中，且同一队伍互换
            local belongBuilding = PlayerService:Instance():GetCardBuilding(self._BeDragData.id);
            if self.curBuilding._id ~= belongBuilding._id then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 69);
                return;
            end

            local drogToArmyIndex = self._curArmyInfo.spawnSlotIndex;
            local drogArmyIndex = drogArmyInfo.spawnSlotIndex;
            -- LogManager:Instance():Log("+++++++++++++++++++++++++++++++++++ drogToArmyIndex"..drogToArmyIndex.."   drogArmyIndex:"..drogArmyIndex);
            if drogToArmyIndex == drogArmyIndex then
                -- LogManager:Instance():Log("同队伍之间的互换")
                self:SendExchangeMsg(v);
            else
                if self:CheckCostValueMaxWithNone(false, true, self._curArmyInfo) == true then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox, 70);
                    return;
                else
                    self:SendExchangeMsg(v);
                end
            end
        else
            -- 拖拽的卡牌不在部队，又检测到同tableId的卡牌存在在部队中,属于操作违法返回
            if self:CheckSameCardInInCityArmy() == true then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 82);
                return;
            end
            if self:CheckCostValueMaxWithNone(false, true, self._curArmyInfo) == true then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 70);
                return;
            else
                -- LogManager:Instance():Log("!!!!!!!!!!!!!!!!!!!!!!!!!发送配置部队信息");
                self:SendConfigArmy(v);
            end
        end
    else
        -- LogManager:Instance():Log("!!!!!!!!!!!!!!!!!!!!!!!!!框內有英雄");
        -- 拖拽到的位置
        local drogArmyBuilding = BuildingService:Instance():GetBuilding(self._curArmyInfo.spawnBuildng);
        -- local drogToArmyInfo = drogArmyBuilding:GetArmyInfoByCardId(v.heroCard.id);
        local drogToArmyInfo = self._curArmyInfo;
        if self:CheckCardState(drogArmyInfo, drogedIndex) == false then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 72);
            return;
        end

        if self:CheckCardState(drogToArmyInfo, self._allArmyObjSlotTypeDic[v.gameObject]) == false then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 71);
            return;
        end
        -- 队伍状态检测
        if self:CheckArmyOperationState(drogArmyInfo) == false or self:CheckArmyOperationState(drogToArmyInfo) == false then
            return;
        end
        self:HandleHaveHero(v, mmisInArmy);
    end
end

-- 如果拖拽到位置的框内有英雄  mmisInArmy:被拖拽的卡牌是否在部队中
function ArmyFunctionUI:HandleHaveHero(v, mmisInArmy)
    -- LogManager:Instance():Log("拖拽到的位置有卡牌，卡牌id:"..v.heroCard.id);
    -- LogManager:Instance():Log("被拖拽到的卡牌id:"..self._curDragBase.heroCard.id);
    if mmisInArmy == true then
        -- 拖拽到的地方不是自身就交换
        if v.heroCard.id ~= self._curDragBase.heroCard.id then
            -- LogManager:Instance():Log("框内有卡牌，拖得卡牌在队伍中，并且拖得不是自己，发送交换部队信息")
            local drogArmyBuilding = BuildingService:Instance():GetBuilding(self._curArmyInfo.spawnBuildng);
            local drogToArmyIndex = self._curArmyInfo.spawnSlotIndex;
            local drogArmyInfo = drogArmyBuilding:GetArmyInfoByCardId(self._curDragBase.heroCard.id);
            local drogArmyIndex = drogArmyInfo.spawnSlotIndex;
            -- LogManager:Instance():Log("+++++++++++++++++++++++++++++++++++ drogToArmyIndex"..drogToArmyIndex.."   drogArmyIndex:"..drogArmyIndex);
            if drogToArmyIndex == drogArmyIndex then
                self:SendExchangeMsg(v);
            else
                if self:CheckCostValueMaxWithNone(false, false, self._curArmyInfo, v) == true or self:CheckCostValueMaxWithNone(true, false, drogArmyInfo, v) == true then
                    UIService:Instance():ShowUI(UIType.UICueMessageBox, 70);
                    return;
                else
                    self:SendExchangeMsg(v);
                end
            end

            --        else
            --            LogManager:Instance():Log("拖拽到自身！！！！！！！！！！返回")
        end
    else
        if self:CheckSameCardInInCityArmy() == true then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 82);
        else
            local card = v.heroCard;
            if self:CheckCostValueMaxWithNone(false, false, self._curArmyInfo, v) == true then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 70);
                return;
            end

            if card.troop > 100 then
                ArmyRemoveCardTipUI:RegistConfirmEvnet( function() self:SendMoveAndConfigMsg(v) end);
                UIService:Instance():ShowUI(UIType.ArmyRemoveCardTipUI, v.heroCard);
            else
                self:SendMoveAndConfigMsg(v);
            end
        end
    end
end

-- 发送移除和配置卡牌的消息
function ArmyFunctionUI:SendMoveAndConfigMsg(v)
    local msg = require("MessageCommon/Msg/C2L/Army/RemoveArmyCard").new();
    msg:SetMessageId(C2L_Army.RemoveArmyCard);
    msg.BuildingId = self.curBuilding._id;
    msg.BuildingSlotIndex = self.curArmyIndex - 1;
    msg.ArmySlotIndex = self._allArmyObjSlotTypeDic[v.gameObject];
    NetService:Instance():SendMessage(msg);
    self:SendConfigArmy(v);
end

-- 发送移除卡牌消息
function ArmyFunctionUI:SendRemoveMsg()
    local msg = require("MessageCommon/Msg/C2L/Army/RemoveArmyCard").new();
    msg:SetMessageId(C2L_Army.RemoveArmyCard);
    msg.BuildingId = self.curBuilding._id;
    msg.BuildingSlotIndex = self.curArmyIndex - 1;
    local drogCardArmy = self.curBuilding:GetArmyInfoByCardId(self._BeDragData.id);
    msg.ArmySlotIndex = drogCardArmy:GetCardArmySlotType(self._BeDragData.id);
    -- LogManager:Instance():Log("发送部队配置移除卡牌信息：  "..msg.BuildingId.." msg.BuildingSlotIndex:  "..msg.BuildingSlotIndex.." msg.ArmySlotIndex:  ".. msg.ArmySlotIndex);
    NetService:Instance():SendMessage(msg);
end

-- 发送配置部队消息
function ArmyFunctionUI:SendConfigArmy(v)
    local msg = require("MessageCommon/Msg/C2L/Army/ConfigArmy").new();
    msg:SetMessageId(C2L_Army.ConfigArmy);

    msg.BuildingId = self.curBuilding._id;
    msg.BuildingSlotIndex = self.curArmyIndex - 1;
    msg.ArmySlotIndex = self._allArmyObjSlotTypeDic[v.gameObject];
    msg.CardId = self._BeDragData.id;
    -- LogManager:Instance():Log("发送的部队配置信息：  "..buildingId..msg.ArmySlotIndex.." msg.BuildingSlotIndex"..msg.BuildingSlotIndex.." msg.ArmySlotIndex:".. msg.ArmySlotIndex);
    NetService:Instance():SendMessage(msg);
end

-- 发送队伍交换消息
function ArmyFunctionUI:SendExchangeMsg(v)
    local msg = require("MessageCommon/Msg/C2L/Army/ExchangeArmyCard").new();
    msg:SetMessageId(C2L_Army.ExchangeArmyCard);
    msg.BuildingId = self._curArmyInfo.spawnBuildng;
    msg.LeftBuildingSlotIndex = self.curArmyIndex - 1;
    local drogArmyBuilding = BuildingService:Instance():GetBuilding(self._curArmyInfo.spawnBuildng);
    local drogArmyInfo = drogArmyBuilding:GetArmyInfoByCardId(self._curDragBase.heroCard.id);
    msg.LeftBuildingSlotIndex = drogArmyInfo.spawnSlotIndex - 1;
    msg.LeftArmySlotIndex = drogArmyInfo:GetCardArmySlotType(self._curDragBase.heroCard.id);
    msg.RightBuildingSlotIndex = self.curArmyIndex - 1;
    msg.RightArmySlotIndex = self._allArmyObjSlotTypeDic[v.gameObject];
    -- LogManager:Instance():Log("发送的部队交换信息：  "..msg.BuildingId.."  "..msg.LeftBuildingSlotIndex.."   "..msg.LeftArmySlotIndex.."   "..msg.RightBuildingSlotIndex.."   "..msg.RightArmySlotIndex);
    NetService:Instance():SendMessage(msg);
end

-- 检测部队中卡牌的征兵状态
function ArmyFunctionUI:CheckCardState(armyInfo, armySlotType)
    if armyInfo == nil or armySlotType == nil then
        return true;
    else
        if armyInfo:IsConscription(armySlotType) == true then
            -- UIService:Instance():ShowUI(UIType.UICueMessageBox,72);
            return false;
        end
    end
    return true;
end

-- 部队配置时检测状态  不再城市中不可以配置
function ArmyFunctionUI:CheckArmyOperationState(armyInfo)
    if armyInfo == nil then
        return true;
    else
        if armyInfo.armyState ~= ArmyState.None then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 66);
            return false;
        end
    end
    return true;
end

-- 检测cost值上限是否超出   isNilIndex = true空位置的情况   isNilIndex = false拖拽到的位置有卡牌的情况
function ArmyFunctionUI:CheckCostValueMaxWithNone(isDrogArmy, isNilIndex, armyInfo, v)
    local maxCost = self.curBuilding:GetCityPropertyByFacilityProperty(FacilityProperty.Cost);
    if armyInfo == nil then
        armyInfo = self._curArmyInfo;
    end
    local armyCostAll = armyInfo:GetArmyAllCost();

    local beDragObj = self._BeDragData;
    -- LogManager:Instance():Log("被拖拽到的卡牌id:"..beDragObj.id.."   拥有的兵力:"..beDragObj.troop.."  COST:"..beDragObj:GetHeroCostValue());
    local drogCost = beDragObj:GetHeroCostValue();

    if isNilIndex == true then
        if armyCostAll + drogCost > maxCost then
            return true;
        end
    else
        -- 拖到的位置的卡牌的cost
        local endIndexCost = v.heroCard:GetHeroCostValue();
        -- LogManager:Instance():Log("拖拽到的位置的卡牌id:"..v.heroCard.id.."   拥有的兵力:"..v.heroCard.troop.."  COST:"..v.heroCard:GetHeroCostValue());
        if isDrogArmy == false then
            if armyCostAll + drogCost - endIndexCost > maxCost then
                return true;
            end
        else
            if armyCostAll - drogCost + endIndexCost > maxCost then
                return true;
            end
        end
    end
    return false;
end

-- 通过数据一样找到在军队里的物体
function ArmyFunctionUI:FindSameDateObj()
    for k, v in pairs(self._allArmyCampDic) do
        -- if self._allHaveHeroCardDic[v.gameObject] == self._BeDragData then
        if self._allHaveHeroCardDic[v.gameObject].id == self._curDragBase.heroCard.id then
            return v.gameObject;
        end
    end
    return nil;
end

-- 检查与拖拽卡牌同tableid的卡牌是否已经配置到某个队伍
function ArmyFunctionUI:CheckSameCardInInCityArmy()
    if self._BeDragData == nil then
        return false
    end
    -- return ArmyService:Instance():CheckSameCardInInCityArmy(self._BeDragData.tableID,self._curArmyInfo.spawnBuildng);
    return PlayerService:Instance():CheckSameCardInInCityArmy(self._BeDragData.tableID);
end

-- 检查互斥
-- 检查被拖的物体是否在军队里
-- 检查数据是否一致
function ArmyFunctionUI:CheckInArmy()
    --    if self._curDragBase ~= nil  then
    --        LogManager:Instance():Log("当前拖动的卡牌的id：    "..self._curDragBase._heroId);
    --    end
    if self._BeDragData == nil then
        return false
    else
        return PlayerService:Instance():CheckCardInArmy(self._BeDragData.id);
        -- return ArmyService:Instance():CheckCardInCityArmy(self._BeDragData.id,self._curArmyInfo.spawnBuildng);
    end
end 

-- DownPart 按下
function ArmyFunctionUI:OnMouseDown(go, eventData)
    -- LogManager:Instance():Log(" ArmyFunctionUI:OnMouseDown DownPart 按下！！！！！！！！！！！！！！！！！！！");
    self.isDownPartDrogEnd = true;
    if self._myMIx then
        self._BeDragObj = self._myMIx:GetBeDragObj();
        self._BeDragData = self._myMIx:GetBeDragObjData();
        if self._BeDragObj == nil or self._BeDragObj.gameObject.activeInHierarchy == false then
            self._myMIx:SetCurDragObj(nil);
            return;
        end

        if self._curDragObj == nil then
            -- LogManager:Instance():Log("按下加载要拖拽的GameObject");
            -- 找到界面的类
            local mdata = DataUIConfig[UIType.UIHeroCard];
            local uiBase = require(mdata.ClassName).new();
            -- 加载预制
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.transform, uiBase, function(go)
                uiBase:Init();
                uiBase:SetHeroCardMessage(self._BeDragData);
                self._curDragObj = uiBase.gameObject;
                self._curDragBase = uiBase;
                self._curDragObj.transform.localPosition = Vector3.zero;
                self._curDragObj.gameObject:SetActive(false);
                self._myMIx:SetCurDragObj(self._curDragObj);
                self._myMIx:SetBeDragData(self._BeDragData);
            end );
        else
            -- LogManager:Instance():Log("按下,要拖拽的GameObject已加载");
            self._curDragObj.gameObject:SetActive(false);
            if self._curDragBase then
                self._curDragBase:SetHeroCardMessage(self._BeDragData);
            end
            self._myMIx:SetCurDragObj(self._curDragObj);
            self._curDragObj.transform.localPosition = Vector3.zero;
        end
        self._localPointerPosition = nil;
        if self._curDragObj ~= nil then
            self._curDragSingleDic[self._curDragObj] = self._BeDragData;
        end
        self._myMIx:SetBeDragData(self._BeDragData);
    end
end

-- DownPart 松开
function ArmyFunctionUI:OnMouseUp(go, eventData)
    -- LogManager:Instance():Log("ArmyFunctionUI:OnMouseUp       DownPart   松开！！！！！！！！！！！！！！！！！");
    if self._curDragObj ~= nil then
        self._curDragObj.gameObject:SetActive(false);
    end
    self._BeDragObj = self._myMIx:GetBeDragObj();
    if self._BeDragObj == nil then
        return;
    end
    -- LogManager:Instance():Log(self._BeDragObj.name);
    self._localPointerPosition = self._myMIx:Get_localPointerPosition();
    if self._curDragObj then
        self:OnUpStartBtn(self._curDragObj.gameObject, eventData);
    end
end

-- 3个位置卡牌的按下
-- @parem obj:物体，eventData:事件回调
function ArmyFunctionUI:OnDownStartBtn(obj, eventData)
    LogManager:Instance():Log("ArmyFunctionUI:OnDownStartBtn  3个位置卡牌的按下！！！！！！！！！！！");
    self.isDownPartDrogEnd = false;
    if self.armyConfigIsShow == false then
        return;
    end
    -- self._BeDragObj = obj;
    if self._BeDragObj == nil then
        -- 找到界面的类
        local mdata = DataUIConfig[UIType.UIHeroCard];
        local uiBase = require(mdata.ClassName).new();
        -- 加载预制
        GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.transform, uiBase, function(go)
            uiBase:Init();
            uiBase:SetHeroCardMessage(self._allHaveHeroCardDic[obj]);
            uiBase.gameObject:SetActive(false);
            self._curDragObj = uiBase.gameObject;

            self._curDragBase = uiBase;
            self._curDragObj.transform.position = eventData.position;
            self._BeDragData = self._allHaveHeroCardDic[obj];
        end );
    else
        if self._curDragBase then
            self._curDragBase:SetHeroCardMessage(self._allHaveHeroCardDic[obj]);
            self._BeDragData = self._allHaveHeroCardDic[obj];
        end
    end
    self._localPointerPosition = nil;
    if self._curDragObj ~= nil then
        self._curDragSingleDic[self._curDragObj] = self._allHaveHeroCardDic[obj];
    end
end

-- 3个位置卡牌的拖拽
-- @parem obj:物体，eventData:事件回调
function ArmyFunctionUI:OnDragStartBtn(obj, eventData)
    LogManager:Instance():Log("ArmyFunctionUI.OnDragStartBtn    3个位置卡牌的拖拽中!!!!!!!!!!!!!!!!");
    if self.armyConfigIsShow == false then
        return;
    end
    if self._curDragObj == nil then
        LogManager:Instance():Log("self._curDragObj is nil");
        return;
    end
    self.armyCardObjDic[obj]:SetTransparentBg(true);
    local localPositonVec3 = UnityEngine.Vector3.zero;
    if self._curDragObj.transform == nil then
        -- LogManager:Instance():Log("self._curDragObj.transform ==nil");
        return;
    end
    localPositonVec3.z = self._curDragObj.transform.localPosition.z;
    local _localPosition = nil;
    local isBoolPositon, _localPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self.gameObject:GetComponent(typeof(UnityEngine.RectTransform)), eventData.position, eventData.pressEventCamera);
    self._localPointerPosition = _localPosition;
    if isBoolPositon then
        localPositonVec3.x = _localPosition.x;
        localPositonVec3.y = _localPosition.y;
        self._curDragObj.gameObject:SetActive(true);
        self._curDragObj.gameObject.transform.localPosition = localPositonVec3;
    end
end

-- 左翻页按钮点击
function ArmyFunctionUI:OnClickPageLeftBtn()
    self.curArmyIndex, self.curBuilding = self:GetShowIndex(self.curArmyIndex, true);
    --LogManager:Instance():Log("self.curArmyIndex:" .. self.curArmyIndex);
    self:RefreshArmyPart();
end

-- 右翻页按钮点击
function ArmyFunctionUI:OnClickPageRightBtn()
    self.curArmyIndex, self.curBuilding = self:GetShowIndex(self.curArmyIndex, false);
    --LogManager:Instance():Log("self.curArmyIndex:" .. self.curArmyIndex);
    self:RefreshArmyPart();
end

-- 获取下一个该显示的部队的index（1-5）以及出生城市
function ArmyFunctionUI:GetShowIndex(curIndex, toLeft)
    if self.couldConfigArmy == true then
        -- 主城分城
        if toLeft == true then
            if curIndex > 1 then
                for i = curIndex - 1, 1, -1 do
                    local leftArmyInfo = self.curBuilding:GetArmyInfo(i);
                    if leftArmyInfo ~= nil then
                        if leftArmyInfo.curBuildingId == 0 or leftArmyInfo.curBuildingId == leftArmyInfo.spawnBuildng then
                            return i, self.curBuilding;
                        end
                    end
                end
            end
            return 1, self.curBuilding;
        else
            if curIndex < self.armyCoutnMax then
                for i = curIndex + 1, self.armyCoutnMax do
                    local rightArmyInfo = self.curBuilding:GetArmyInfo(i);
                    if rightArmyInfo ~= nil then
                        if rightArmyInfo.curBuildingId == 0 or rightArmyInfo.curBuildingId == rightArmyInfo.spawnBuildng then
                            return i, self.curBuilding;
                        end
                    end
                end
            end
            return 1, self.curBuilding;
        end
    else
        -- 要塞 与 野外要塞
        local fort = BuildingService:Instance():GetBuilding(self._curArmyInfo.curBuildingId);
        if fort._dataInfo.Type == BuildingType.PlayerFort then
            local armyInFortIndex = fort:GetArmyIndex(self._curArmyInfo.spawnBuildng, self._curArmyInfo.spawnSlotIndex);
            local fortLevel = fort:GetFortGrade();
            if toLeft == true then
                if armyInFortIndex > 1 then
                    local leftArmyInfo = fort:GetArmyInfos(armyInFortIndex - 1);
                    if leftArmyInfo ~= nil then
                        local leftArmySpawnBuilding = BuildingService:Instance():GetBuilding(leftArmyInfo.spawnBuildng);
                        return leftArmyInfo.spawnSlotIndex, leftArmySpawnBuilding;
                    else
                        return 1, self.curBuilding;
                    end
                else
                    return 1, self.curBuilding;
                end
            else
                if armyInFortIndex < fortLevel then
                    local rightArmyInfo = fort:GetArmyInfos(armyInFortIndex + 1);
                    if rightArmyInfo ~= nil then
                        local rightArmySpawnBuilding = BuildingService:Instance():GetBuilding(rightArmyInfo.spawnBuildng);
                        return rightArmyInfo.spawnSlotIndex, rightArmySpawnBuilding;
                    else
                        return 1, self.curBuilding;
                    end
                else
                    return 1, self.curBuilding;
                end
            end
        elseif fort._dataInfo.Type == BuildingType.WildFort or fort._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            local armyInFortIndex = fort:GetWildFortArmyIndex(self._curArmyInfo.spawnBuildng, self._curArmyInfo.spawnSlotIndex);
            local fortLevel = 5;
            if toLeft == true then
                if armyInFortIndex > 1 then
                    local leftArmyInfo = fort:GetWildFortArmyInfos(armyInFortIndex - 1);
                    if leftArmyInfo ~= nil then
                        local leftArmySpawnBuilding = BuildingService:Instance():GetBuilding(leftArmyInfo.spawnBuildng);
                        return leftArmyInfo.spawnSlotIndex, leftArmySpawnBuilding;
                    else
                        return 1, self.curBuilding;
                    end
                else
                    return 1, self.curBuilding;
                end
            else
                if armyInFortIndex < fortLevel then
                    local rightArmyInfo = fort:GetWildFortArmyInfos(armyInFortIndex + 1);
                    if rightArmyInfo ~= nil then
                        local rightArmySpawnBuilding = BuildingService:Instance():GetBuilding(rightArmyInfo.spawnBuildng);
                        return rightArmyInfo.spawnSlotIndex, rightArmySpawnBuilding;
                    else
                        return 1, self.curBuilding;
                    end
                else
                    return 1, self.curBuilding;
                end
            end

        end
    end
end

-- 检测是否有可显示的部队
function ArmyFunctionUI:CheckHaveShowedArmy(curIndex, toLeft)
    if self.couldConfigArmy == true then
        -- 主城分城
        if toLeft == true then
            if curIndex > 1 then
                for i = 1, curIndex - 1 do
                    local leftArmyInfo = self.curBuilding:GetArmyInfo(i);
                    if leftArmyInfo ~= nil then
                        if leftArmyInfo.curBuildingId == 0 or leftArmyInfo.curBuildingId == leftArmyInfo.spawnBuildng then
                            return true;
                        end
                    end
                end
            end
            return false;
        else
            if curIndex < self.armyCoutnMax then
                for i = curIndex + 1, self.armyCoutnMax do
                    local rightArmyInfo = self.curBuilding:GetArmyInfo(i);
                    if rightArmyInfo ~= nil then
                        if rightArmyInfo.curBuildingId == 0 or rightArmyInfo.curBuildingId == rightArmyInfo.spawnBuildng then
                            return true;
                        end
                    end
                end
            end
            return false;
        end
    else
        -- 要塞 与 野外要塞
        local fort = BuildingService:Instance():GetBuilding(self._curArmyInfo.curBuildingId);
        if fort._dataInfo.Type == BuildingType.PlayerFort then
            local armyInFortIndex = fort:GetArmyIndex(self._curArmyInfo.spawnBuildng, self._curArmyInfo.spawnSlotIndex);
            local fortLevel = fort:GetFortGrade();
            if toLeft == true then
                if armyInFortIndex > 1 then
                    return true;
                else
                    return false;
                end
            else
                if armyInFortIndex < fortLevel then
                    if fort:GetArmyInfos(armyInFortIndex + 1) ~= nil then
                        return true;
                    else
                        return false;
                    end
                else
                    return false;
                end
            end
        elseif fort._dataInfo.Type == BuildingType.WildFort or fort._dataInfo.Type == BuildingType.WildGarrisonBuilding then
            local armyInFortIndex = fort:GetWildFortArmyIndex(self._curArmyInfo.spawnBuildng, self._curArmyInfo.spawnSlotIndex);
            local fortLevel = 5
            if toLeft == true then
                if armyInFortIndex > 1 then
                    return true;
                else
                    return false;
                end
            else
                if armyInFortIndex < fortLevel then
                    if fort:GetWildFortArmyInfos(armyInFortIndex + 1) ~= nil then
                        return true;
                    else
                        return false;
                    end
                else
                    return false;
                end
            end

        end
    end
end

-- 设置左右按钮状态（进入界面时的设置）
function ArmyFunctionUI:SetPageBtnState()
    local leftShow = self:CheckHaveShowedArmy(self.curArmyIndex, true);
    local rightShow = self:CheckHaveShowedArmy(self.curArmyIndex, false)
    if self.pageLeftBtn then
        self.pageLeftBtn.gameObject:SetActive(leftShow);
    end
    if self.pageRightBtn then
        self.pageRightBtn.gameObject:SetActive(rightShow);
    end
end

-- 点击征兵按钮,打开征兵界面
function ArmyFunctionUI:OnClickConscriptionBtn()
    --LogManager:Instance():Log("友盟测试点击征兵按钮事件")
    GA.Event("1");

    -- 配置大营后,且返回城市(或者在要塞中征兵队列没有满),才能进行征兵
    if self._curArmyInfo:GetCard(ArmySlotType.Back) ~= nil then
        local armyState = self._curArmyInfo:GetArmyState();
        if armyState ~= ArmyState.None and armyState ~= ArmyState.TransformArrive then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 65);
            return;
        else

            if self.couldConfigArmy == false then
                if self._curArmyInfo:IsArmyInConscription() == false then
                    if self:CheckConscriptionQueueState() == true then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 68);
                        return;
                    end
                end
            end
            local parms = { };
            parms[1] = self._curArmyInfo;
            parms[2] = self.couldConfigArmy;
            UIService:Instance():ShowUI(UIType.UIConscription, parms);
        end
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 143);
    end
end

-- 要塞征兵队列上限检测检测
function ArmyFunctionUI:CheckConscriptionQueueState()
    local curConsCount = 0;
    local maxConscriptionCount = 1;
    local fort = BuildingService:Instance():GetBuilding(self._curArmyInfo.curBuildingId);
    if fort._dataInfo.Type == BuildingType.PlayerFort then
        if fort ~= nil then
            curConsCount = fort:GetFortArmyConscritionCount();
        end
        if curConsCount < maxConscriptionCount then
            return false;
        else
            return true;
        end
    elseif fort._dataInfo.Type == BuildingType.WildFort or fort._dataInfo.Type == BuildingType.WildGarrisonBuilding then
        if fort ~= nil then
            curConsCount = fort:GetWildFortArmyConscritionCount();
        end
        if curConsCount < maxConscriptionCount then
            return false;
        else
            return true;
        end
    end
end

-- 点击队伍互换按钮
function ArmyFunctionUI:OnClickChangeBtn()
    UIService:Instance():ShowUI(UIType.ArmySwapUI, self._curArmyInfo);
end

--点击前锋
function ArmyFunctionUI:OnClickFrontCardBgBtn()
    if self.curBuilding:CheckArmyFrontOpen(self.curArmyIndex) == true then
        self:OnClickConfigBtn();
    end
end

-- 点击队伍配置
function ArmyFunctionUI:OnClickConfigBtn()
    -- LogManager:Instance():Log(self._curArmyInfo:GetArmyState());
--    if self._curArmyInfo == nil then
--        return;
--    end
    if self.couldConfigArmy == true then
        if self._curArmyInfo:GetArmyState() ~= ArmyState.None then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 66);
            return;
        else
            if self.armyConfigIsShow == false then
                self.armyConfigIsShow = true;
                --第一次点击部队配置按钮才开始加载DownPart
                if self.couldConfigArmy == true then
                    self.sortType = HeroSortType.default;
                    self:RefreshUIShow();
                end
                self:ShowArmyConfigUI(self.armyConfigIsShow);
            end
        end
    end
end

function ArmyFunctionUI:OnClickAdditionBtn()
    UIService:Instance():ShowUI(UIType.ArmyAdditionUI, self._curArmyInfo);
end

-- 点击关闭界面按钮
function ArmyFunctionUI:OnClickExitBtn()
    if self._curDragObj ~= nil then
        self._curDragObj.gameObject:SetActive(false);
    end
    if self.couldConfigArmy == true then
        if self.armyConfigIsShow == false then
            --UIService:Instance():HideUI(UIType.ArmyFunctionUI,nil,function()self:OnBeforeDestroy();end);
            UIService:Instance():HideUI(UIType.ArmyFunctionUI);

            EventService:Instance():TriggerEvent(EventType.MainCityArmy);
        else
            self.armyConfigIsShow = false;
            self.armySortIsShow = false;
            self:SetSortListObj(false);
            self:ShowArmyConfigUI(self.armyConfigIsShow);
        end
    else
        --UIService:Instance():HideUI(UIType.ArmyFunctionUI,nil,function()self:OnBeforeDestroy();end);
        UIService:Instance():HideUI(UIType.ArmyFunctionUI);
        -- UIMainCity界面若打开要更新
        local baseCityClass = UIService:Instance():GetUIClass(UIType.UIMainCity);
        local isOpen = UIService:Instance():GetOpenedUI(UIType.UIMainCity);
        if baseCityClass ~= nil and isOpen then
            baseCityClass:ShowAllCards();
            baseCityClass:SetTroops();
            baseCityClass:SetRedif();
            baseCityClass:SetDuration();
        end
    end
    if GuideServcice:Instance():GetIsFinishGuide() == false then
        local uiGuide = UIService:Instance():GetUIClass(UIType.UIGuideOneAreaClick);
        if uiGuide ~= nil then
            uiGuide:RevertAnimParent();
        end
    end
end

function ArmyFunctionUI:ShowArmyConfigUI(isShow)
    self.hideDownPartBtn.gameObject:SetActive(isShow);
    self.exitBtn.gameObject:SetActive(isShow == false);

    if isShow == true then
        self.armyFunctionBtnsObj.gameObject:SetActive(false)
        self.leftBottomObj.gameObject:SetActive(false);
        self:MovePosition(isShow);
    else
        self.armyFunctionBtnsObj.gameObject:SetActive(true)
        self.leftBottomObj.gameObject:SetActive(true);
        if self.downPartObj ~= nil then
            self.downPartObj.transform.localPosition.y = downPartBottomY;
        end
        self:MovePosition(isShow);
        -- 配置大营后才能进行征兵
        if self.isFirstUIOpen ~= true then
            if self._curArmyInfo:GetCard(ArmySlotType.Back) == nil then
                UIService:Instance():ShowUI(UIType.UICueMessageBox, 67);
            end
        end
        self:ResetCardListSlider();
    end
    -- 部队基本信息也要刷新显示
    self:RefreshArmyBaseInfo(self._curArmyInfo);
end

function ArmyFunctionUI:ResetCardListSlider(heroSortType)
    if self._myMIx ~= nil then
        self._myMIx:MakeScrollDrag(self.cardDefaultList, self.downPartParentObj.transform);
        self:SetAllCardCount();
    end
end

-- 卡牌和配置界面移动效果
function ArmyFunctionUI:MovePosition(isShowArmyConfig)
    if self.downPartObj ~= nil then
        if isShowArmyConfig == true then
--            self.middleTransform:DOMoveY(self.middleMovePosition.position.y, 0.2);
--            self.backTransform:DOMoveY(self.backMovePosition.position.y, 0.2);
--            self.downPartObj.transform:DOMoveY(self.downPartParentObj.position.y, 0.2);
--            -- self.downpartobj.transform:dolocalmovey(self.downpartupy, 0.2, false);

            CommonService:Instance():MoveY(self.middleTransform.gameObject,self.middleCardInitPosition.localPosition.y,self.middleMovePosition.localPosition.y,0.2);
            CommonService:Instance():MoveY(self.backTransform.gameObject,self.leftCardInitPosition.localPosition.y,self.backMovePosition.localPosition.y,0.2);
            CommonService:Instance():MoveY(self.downPartObj.gameObject,self.downPartBottomY,0,0.2);
        else
--            self.middleTransform:DOMoveY(self.middleCardInitPosition.position.y, 0.2);
--            self.backTransform:DOMoveY(self.leftCardInitPosition.position.y, 0.2);
--            --            self.middleTransform:DOLocalMoveY(self.middleInitTransform.y, 0.2, true);
--            --            self.backTransform:DOLocalMoveY(self.backInitTransform.y, 0.2, false);
--            self.downPartObj.transform:DOMoveY(self.downPartBottomY, 0.2);

            CommonService:Instance():MoveY(self.middleTransform.gameObject,self.middleMovePosition.localPosition.y,self.middleCardInitPosition.localPosition.y,0.2);
            CommonService:Instance():MoveY(self.backTransform.gameObject,self.backMovePosition.localPosition.y,self.leftCardInitPosition.localPosition.y,0.2);
            CommonService:Instance():MoveY(self.downPartObj.gameObject,0,self.downPartBottomY,0.2);
        end
    end
end

-- 点击关闭部队配置按钮
function ArmyFunctionUI:OnClickCloseArmyConfigBtn()
    self.armyConfigIsShow = false;
    self:ShowArmyConfigUI(self.armyConfigIsShow);
end

-- 点击开、关排序按钮
function ArmyFunctionUI:OnClickSortArmyBtn()
    if self.armySortIsShow == false then
        self.armySortIsShow = true;
    else
        self.armySortIsShow = false;
    end
    self:SetSortListObj(self.armySortIsShow);
end

function ArmyFunctionUI:OnClickRarityButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.rarity;
    self:RefreshUIShow()
end

function ArmyFunctionUI:OnClickClassSystemButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.armTtpe;
    self:RefreshUIShow()
end

function ArmyFunctionUI:OnClickCampButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.camp;
    self:RefreshUIShow()
end

function ArmyFunctionUI:OnClickGradeButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.level;
    self:RefreshUIShow()
end

function ArmyFunctionUI:OnClickEfficiencyButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.cost;
    self:RefreshUIShow()
end

function ArmyFunctionUI:OnClickGeneralCardButton()
    self:OnClickSortArmyBtn();
    self.sortType = HeroSortType.default;
    self:RefreshUIShow()
end

function ArmyFunctionUI:SetSortListObj(isShow)
    if self.sortListObj ~= nil then
        self.sortListObj.gameObject:SetActive(isShow);
    end
end

return ArmyFunctionUI;
