--[[ 游戏主界面 ]]

local UIBase = require("Game/UI/UIBase");
local UIGameMainView = class("UIGameMainView", UIBase);
local EventType = require("Game/Util/EventType");
local EventService = require("Game/Util/EventService");
local ClickType = require("Game/Map/ClickMenu/ClickType")
local List = require("common/List")
local Quaternion = Quaternion.Euler(0, 0, 180)
local Client = require("Game/Client")
local Quaternions = Quaternion.Euler(0, 0, 360)
require("Game/Table/model/DataGameConfig");
function UIGameMainView:ctor()
    UIGameMainView.super.ctor(self);
    self.marchTimer = nil;
    -- 武将卡按钮
    self._Button_Announcement = nil;
    self._heroCardBtn = nil;
    self._skillBtn = nil;
    self._armyConfig = nil;
    self._exitBtn = nil;
    self._recruitBtn = nil;
    self._firstOnClickHeroCard = 0;
    self.showMinMap = true
    self.orderBtn = nil;
    self.orderImage = nil;
    self.BehaviourParent = nil;
    self.LeagueBtn = nil;
    self.RankListBtn = nil;
    -- 内政按钮
    self.internalBtn = nil;
    self.RetreatBtn = nil;
    self.ResourceBtn = nil;
    self.ArrowBtn = nil;
    self.HeadPortraitBtn = nil;
    self.roleId = nil;
    self.HeavenBtn = nil;
    self.BattleRePortBtn = nil;
    self.PMapBtn = nil;
    self._goldText = nil;
    self._SymbolText = nil;

    self._TextCount = nil;
    self._Renown = nil;
    self._Force = nil;
    self._ForceBtn = nil;
    self._TimeText = nil;
    self._OrderTimeText = nil;
    self._requestTimer = nil;
    self._internalBtn = nil;
    self.rechargeBtn = nil;
    -- 充值按钮
    self.addJadeBtn = nil;
    -- 增加符玉按钮
    self.monthCardBtn = nil;
    -- 月卡按钮
    self.mailBtn = nil;
    -- 滑动菜单里的邮箱按钮
    self.messageMailBtn = nil;
    -- 通知消息里的邮箱按钮
    self.messageMailCountText = nil;
    self.activityBtn = nil;
    -- 左上角活动按钮
    self.activityBtnDown = nil;
    -- 左下活动按钮

    -- 新手保护期期按钮
    self.newerPeriodBtn = nil;

    -- 顶部资源按钮
    self._Button_PersonalPower = nil;
    self._wood = nil;
    self._IronOre = nil;
    self._Stone = nil;
    self._Provisions = nil;
    self.WoodText = nil;
    self.IronOreText = nil;
    self.StoneText = nil;
    self.ProvisionsText = nil;

    -- 左侧已出征队伍ui类列表（自己的队伍）
    self._allMyArmyUiClassList = { };
    -- 左侧已出征队伍ui类列表（敌方的队伍）
    self._allEnemyArmyUiClassList = { };
    -- 左侧已战平队伍ui类列表（敌方的队伍）
    self._allEnemyTipsBattleUiClassList = { };

    self._MapSign = nil;
    -- 标记
    self.RecruitNewCount = nil;
    -- 招募消息未读数量
    self._Image_RedPoint = nil;
    -- self._MapSign1 = nil;
    self._sign = nil;
    self.MarkerList = { };
    self.allClickClass = { };
    self._Score = nil;
    self._UnReadLabel = nil;
    self.SignLocate = { };
    self._chatFramesBtn = nil;
    self._chatFramesImage = nil;
    self._chatFramesText = nil;
    -- Map按钮
    self.MinMapBtn = nil
    self._taskBtn = nil;
    self._taskBtnCountParent = nil;
    self._taskBtnCount = nil;
    -- 叛变
    self.rebellBtn = nil;

    self.buildingSign = { }
    self.mainCitySign = { }
    self.ButtonConversion = false;

    self._CityInfoList = { };
    self._fortSignList = { }
    self.signObject = nil;
    self.MapSign = nil;

    self.marchTimers = nil;
    self.MovePosition = nil;
    self.SignPosition = nil;
    self.isOpen = false
    self.minMapState = 0;
    self.sign = nil;
    self.isShowAllFunctions = false;
    -- 默认false,不显示全部功能界面
    self.signBox = nil;

    self.WildFort = { }

    self.isFirstOpen = true;
    self.width = 0;
    self.height = 0;
    self.worldPoint = nil;
    self.foreignFedDot = nil;
    -- 小地图
    self.minMapObj = nil

    self.questEffect = nil;

    self.leagueRedIamge = nil;

    self.PersonalPowerOpenType = nil;

end 

-- 控件查找
function UIGameMainView:DoDataExchange()
    self.newerPeriodBtn = self:RegisterController(UnityEngine.UI.Button, "Activity/NewerBtn");
    self.rebellBtn = self:RegisterController(UnityEngine.UI.Button, "Activity/Button");
    self._heroCardBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Package/Image/HeroBtn");
    self._skillBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Package/Image1/SkillBtn");
    self._armyConfig = self:RegisterController(UnityEngine.UI.Button, "Panel/Package/Image3/internalBtn");
    self._exitBtn = self:RegisterController(UnityEngine.UI.Button, "ExitBtn");
    self._recruitBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Package/RecruitBtn");
    self.orderBtn = self:RegisterController(UnityEngine.UI.Button, "Activity/OrderBtn");
    self.orderImage = self:RegisterController(UnityEngine.RectTransform, "Activity/OrderBtn/OrderBtn1");
    self.orderImageBtn = self:RegisterController(UnityEngine.UI.Button, "Activity/OrderBtn/OrderBtn1");
    self.BehaviourParent = self:RegisterController(UnityEngine.Transform, "Panel/Behavior");
    self.LeagueBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image3/Alliance");
    self.RankListBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image1/Cropped");
    self.InternalBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Package/Image2/ArmyConfigBtn");
    -- self.RetreatBtn = self:RegisterController(UnityEngine.UI.Button,"Start/ArmyState/Button");
    self.StartGrid = self:RegisterController(UnityEngine.Transform, "Start/ViewPoint/Content");
    self.ResourceBtn = self:RegisterController(UnityEngine.UI.Button, "ConvertBtn");

    self.ArrowBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/ArrowButtonParent/ArrowButton");
    -- self.HeadPortraitBtn = self:RegisterController(UnityEngine.UI.Button,"Retreat/OneTeamImage/HeadPortraitButton");
    self.HeavenBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image4/Heaven");
    self.worldPoint = self:RegisterController(UnityEngine.UI.Image, "Panel/Behavior/Image4/Heaven/Image");
    -- self.WorldTendencyRedIcon = self:RegisterController(UnityEngine.UI.Text, "Panel/Behavior/Heaven/Image");

    self.BattleRePortBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image5/Despatches");
    self.PMapBtn = self:RegisterController(UnityEngine.UI.Button, "Map/Image1");
    self._goldText = self:RegisterController(UnityEngine.UI.Text, "Panel/Image/Gold");
    self._SymbolText = self:RegisterController(UnityEngine.UI.Text, "Panel/Image/Symbol")

    self._TextCount = self:RegisterController(UnityEngine.UI.Text, "Activity/OrderBtn/TextCount");
    self._Renown = self:RegisterController(UnityEngine.UI.Text, "ManorData/Renown/Image/Text");
    self._Force = self:RegisterController(UnityEngine.UI.Text, "ManorData/Force/Image/Text");
    self._ForceBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image2/Force");
    self._TimeText = self:RegisterController(UnityEngine.UI.Text, "ManorData/Time/Image/Text");
    self._OrderTimeText = self:RegisterController(UnityEngine.UI.Text, "Activity/OrderBtn/TimeText");
    -- self._internalBtn = self:RegisterController(UnityEngine.UI.Button,"Panel/Package/internalBtn");
    self.rechargeBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image12/Recharge");
    self.addJadeBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Image/AddJadeButton");
    self._MapSign = self:RegisterController(UnityEngine.UI.Button, "Map/MapSign");
    -- self._MapSign1 = self:RegisterController(UnityEngine.UI.Button, "Map/MapSign1");
    self._sign = self:RegisterController(UnityEngine.Transform, "Map/signObject/Image/signPanel/sign");
    self.activityBtn = self:RegisterController(UnityEngine.UI.Button, "Activity/ActivityImage");
    self._signPanel = self:RegisterController(UnityEngine.Transform, "Map/signObject/Image/signPanel");
    self.mailBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image6/Mail");
    self.messageMailBtn = self:RegisterController(UnityEngine.UI.Button, "Msg/Mail");
    self.messageMailCountText = self:RegisterController(UnityEngine.UI.Text, "Msg/Mail/Image/Text");
    self.monthCardBtn = self:RegisterController(UnityEngine.UI.Button, "Activity/ActivityImage1");
    self.activityBtnDown = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image7/Activity");
    self._Score = self:RegisterController(UnityEngine.UI.Button, "Msg/Score");
    self._UnReadLabel = self:RegisterController(UnityEngine.UI.Text, "Msg/Score/unreadbg/Text");
    self._GMBtn = self:RegisterController(UnityEngine.UI.Button, "GMBtn");
    self._chatFramesBtn = self:RegisterController(UnityEngine.UI.Button, "Panel/Package/ChatFramesBtn");
    self._chatFramesImage = self:RegisterController(UnityEngine.UI.Image, "Panel/Package/ChatFramesBtn/Image");
    self._chatFramesText = self:RegisterController(UnityEngine.UI.Text, "Panel/Package/ChatFramesBtn/Image/Text");

    self.MinMapBtn = self:RegisterController(UnityEngine.UI.Button, "Map/Image");
    self.MinMapChangeImage = self:RegisterController(UnityEngine.UI.Image, "Map/Image/Image");
    self._taskBtn = self:RegisterController(UnityEngine.UI.Button, "MissionBtn");
    self._taskBtnCountParent = self:RegisterController(UnityEngine.Transform, "MissionBtn/Image");
    self._taskBtnCount = self:RegisterController(UnityEngine.UI.Text, "MissionBtn/Image/Text");

    self.RecruitNewCount = self:RegisterController(UnityEngine.UI.Text, "Panel/Package/RecruitBtn/Image/Text");
    self._Button_Announcement = self:RegisterController(UnityEngine.UI.Button, "Panel/Behavior/Image11/Announcement");

    self.signObject = self:RegisterController(UnityEngine.RectTransform, "Map/signObject");
    -- self.MapSign = self:RegisterController(UnityEngine.UI.Button, "Map/MapSign1")
    self._Button_PersonalPower = self:RegisterController(UnityEngine.UI.Button, "Resource");
    self._wood = self:RegisterController(UnityEngine.UI.Text, "Resource/WoodImage/Text1")
    -- print(self._wood)
    self._IronOre = self:RegisterController(UnityEngine.UI.Text, "Resource/IronOreImage/Text1");
    self._Stone = self:RegisterController(UnityEngine.UI.Text, "Resource/StoneImage/Text1");
    self._Provisions = self:RegisterController(UnityEngine.UI.Text, "Resource/ProvisionsImage/Text1")
    self.WoodText = self:RegisterController(UnityEngine.UI.Text, "Resource/WoodImage/Text/Text");
    self.IronOreText = self:RegisterController(UnityEngine.UI.Text, "Resource/IronOreImage/Text/Text");
    self.StoneText = self:RegisterController(UnityEngine.UI.Text, "Resource/StoneImage/Text/Text")
    self.ProvisionsText = self:RegisterController(UnityEngine.UI.Text, "Resource/ProvisionsImage/Text/Text")
    self._Text_LigenceCount = self:RegisterController(UnityEngine.UI.Text, "ManorData/Land/Image/Text");
    self.SignPosition = self:RegisterController(UnityEngine.RectTransform, "Map/SignPosition");
    self.MovePosition = self:RegisterController(UnityEngine.RectTransform, "Map/MovePosition")
    self.sign = self:RegisterController(UnityEngine.Transform, "Map/signObject/Image/signPanel/sign")
    self.signBox = self:RegisterController(UnityEngine.Transform, "Map/signObject");
    self.foreignFedDot = self:RegisterController(UnityEngine.UI.Image, "Panel/Package/Image2/ArmyConfigBtn/Image1")

    self.leagueRedIamge = self:RegisterController(UnityEngine.UI.Image, "Panel/Behavior/Image3/leagueRed")

end

-- 控件事件添加
function UIGameMainView:DoEventAdd()
    -- body
    self:AddListener(self.newerPeriodBtn, self.OnClickNewerBtn);

    self:AddListener(self.rebellBtn, self.OnClickrebellBtn)

    self:AddListener(self._heroCardBtn, self.OnClickHeroCardBtn)

    self:AddListener(self._skillBtn, self.OnClickSkillBtn)

    self:AddListener(self._armyConfig, self.OnClickArmyBtn)

    self:AddListener(self._exitBtn, self.OnClickExitBtn)

    self:AddListener(self._recruitBtn, self.OnClickRecruitBtn)

    self:AddListener(self.orderBtn, self.OnClickOrderBtn);
    self:AddListener(self.orderImageBtn, self.OnClickOrderBtn);

    self:AddListener(self.LeagueBtn, self.OnClickLeagueBtn);
    self:AddListener(self.RankListBtn, self.OnClickRankListBtn);
    self:AddListener(self.InternalBtn, self.OnClickInternalBtn);

    -- self:AddListener(self.RetreatBtn,self.OnClickRetreatBtn);

    self:AddListener(self.ResourceBtn, self.OnClickResourceBtn);

    -- self:AddListener(self.HeadPortraitBtn,self.OnClickHeadPortraitBtn);

    self:AddListener(self.HeavenBtn, self.OnClickheavenBtn);

    self:AddListener(self.BattleRePortBtn, self.OnClickBattleRePortBtn);
    self:AddListener(self.ArrowBtn, self.OnClickFunctionArrow);
    self:AddListener(self.PMapBtn, self.OnClickPMapBtn);
    self:AddListener(self.rechargeBtn, self.OnClickRechargeBtn);
    self:AddListener(self.addJadeBtn, self.OnClickRechargeBtn);
    self:AddListener(self.mailBtn, self.OnClickMailBtn);
    self:AddOnClick(self.messageMailBtn, self.OnClickMailBtn);

    self:AddListener(self._MapSign, self.OnClickMapSign);
    -- self:AddListener(self._MapSign1, self.OnClickMapSign1);

    self:AddListener(self.activityBtn, self.OnClickActivityBtn);
    self:AddListener(self.activityBtnDown, self.OnClickActivityBtn);
    self:AddListener(self.monthCardBtn, self.OnClickMonthCardBtn);

    self:AddListener(self._Score, self.OnClickBattleRePortBtn);

    self:AddListener(self._GMBtn, self.ShowGMUI);

    self:AddListener(self.MinMapBtn, self.ClickMinMapBtn);

    self:AddListener(self._taskBtn, self.OnClickTaskBtn);
    self:AddListener(self._chatFramesBtn, self.ClickChatBtn);
    self:AddListener(self._ForceBtn, self.ForceBtnOnClick);
    self:AddListener(self._Button_PersonalPower, self._Button_PersonalPowerOnClick);
    self:AddListener(self._Button_Announcement, self._Button_AnnouncementOnClick);
end



function UIGameMainView:OnInit()
    LogManager:Instance():Log("友盟统计玩家登录游戏");
    GA.ProfileSignIn("" .. PlayerService:Instance():GetAccountId());
    self:SetCurrencyEnum();
    self:FlushMainCityInfo();
    self:_ArmyStateRequest();
end

function UIGameMainView:Update()
    GameResFactory.Instance():QiutGame( function()
        self:OnClickExitBtn()
    end )
end


-- 同盟红点
function UIGameMainView:CanShoweLeagueRedImage(args)
    self.leagueRedIamge.gameObject:SetActive(args)
end


-- 注册所有的通知
function UIGameMainView:RegisterAllNotice()
    self:RegisterNotice(L2C_Army.SyncAllArmy, self.CreateMyArmyTip);
    self:RegisterNotice(L2C_Army.ArmyBaseInfo, self.CreateMyArmyTip);
    self:RegisterNotice(L2C_Map.AddEnemyTipLine, self.CreateEnemyArmyTip);
    self:RegisterNotice(L2C_Map.RemoveEnemyTipsLine, self.CreateEnemyArmyTip);
    self:RegisterNotice(L2C_Map.AddEnemyTipBattle, self.CreateEnemyArmyTipBattle);
    self:RegisterNotice(L2C_Map.RemoveEnemyTipsBattle, self.CreateEnemyArmyTipBattle);

    self:RegisterNotice(L2C_BattleReport.BattleReportUnReadCount, self.BattleReportUnReadCount);
    self:RegisterNotice(L2C_Player.RefreshCurrencyInfo, self:SetCurrencyEnum(self));
    self:RegisterNotice(L2C_Player.RefreshCurrencyInfo, self.UpdateMoney);
    self:RegisterNotice(L2C_Player.ReturnUnmarkResult, self.AllSign);
    self:RegisterNotice(L2C_Player.SyncGold, self.UpdateMoney);

    self:RegisterNotice(L2C_Mail.ReturnMailInfo, self.RefreshMailTips);
    self:RegisterNotice(L2C_Mail.SyncMailInfo, self.RefreshMailTips);
    self:RegisterNotice(L2C_Mail.ReturnIsRead, self.RefreshMailTips);
    self:RegisterNotice(L2C_Recruit.SyncRecruitPackage, self.UpdateNewRecruitCount);
    self:RegisterNotice(L2C_Recruit.ReturnRecruitPackageList, self.UpdateNewRecruitCount);

    self:RegisterNotice(L2C_Task.OpenTaskListRespond, self.UpdateTaskCanCount);
    self:RegisterNotice(L2C_Task.SyncSingleTask, self.UpdateTaskCanCount);
    self:RegisterNotice(L2C_Task.TaskAwardRespond, self.UpdateTaskCanCount);
    self:RegisterNotice(L2C_Building.RemoveBuilding, self.AllSign)


    self:RegisterNotice(L2C_Player.SyncResource, self.SetResource)
    self:RegisterNotice(L2C_Map.SyncTiled, self.SetResource)
    self:RegisterNotice(L2C_Facility.UpgradeFacilityRespond, self.SetResource)
    self:RegisterNotice(L2C_League.CreateLeagueSuccess, self.SetResource)
    self:RegisterNotice(L2C_League.LeagueAgreePlayerJoin, self.SetResource)
    self:RegisterNotice(L2C_Player.PlayerGainNewTiled, self.SetResource)
    self:RegisterNotice(L2C_Player.PlayerLostOldTiled, self.SetResource)

    -- self:RegisterNotice(Chat2C_Chat.BroadcastChat, self.ChatRedImage)
    self:RegisterNotice(L2C_Player.SyncNewerPeriod, self.RefreshNewerBtn);
    self:RegisterNotice(L2C_Player.SyncRevenueAllInfo, self.IsCanReceiveTax)
    self:RegisterNotice(L2C_Player.RevenueCountInfo, self.SetReceiveIsTrue)
    -- self:RegisterNotice(L2C_Player.RevenueCountInfo, self.IsCanReceiveTax)
    self:RegisterNotice(L2C_Facility.OpenCityFacilityRespond, self.IsCanReceiveTax)
    self:RegisterNotice(L2C_Player.ReturnIntroductions, self.PersonalPower)

end


function UIGameMainView:OnShow(args)
    self:SetCurrencyEnum();
    self:NewerPeriodListener();
    self:SetResource();
    MapService:Instance():HideTiled();
    self.RecruitNewCount.transform.parent.gameObject:SetActive(false);
    self:UpdateNewRecruitCount();

    self:SetMonthCardInfo();
    PmapService:Instance():SetNPCity()

    self:ChangeRebellState()
    self:UpdateTaskCanCount();

    self.marchTimer = Timer.New(
    function()
        self:SetCurrencyEnum();
        self:NewerPeriodListener();
    end , 60, -1, false);
    self.marchTimer:Start();
    self:CreateMyArmyTip();
    self:CreateEnemyArmyTip();
    self:CreateEnemyArmyTipBattle();
    -- 显示小地图
    if self.minMapState == 0 then
        UIService:Instance():ShowUI(UIType.UIMinMap, nil, function()
            local bassClass = UIService:Instance():GetUIClass(UIType.UIMinMap)
            if bassClass ~= nil then
                bassClass:RefreashWildCity();
            end
        end )
    end

    self.isFirstOpen = false;
    self:ChatRedImage();
    self:RefreshNewerBtn();
    self:CanShowWorldPoint();
    self:BattleReportUnReadCount();
    self:SetOrderTimer();
    self:IsCanReceiveTax()
    self:HideOrShowUIminMap()
end

-- /是否显示小地图
function UIGameMainView:HideOrShowUIminMap()
    local baseMinMapClass = UIService:Instance():GetUIClass(UIType.UIMinMap);
    if self.showMinMap then
        if baseMinMapClass ~= nil then
            UIService:Instance():GetUIClass(UIType.UIMinMap).gameObject:SetActive(true)
        end
    else
        if baseMinMapClass ~= nil then
            UIService:Instance():GetUIClass(UIType.UIMinMap).gameObject:SetActive(false)
        end
    end
end



-- 是否可领取税收
function UIGameMainView:IsCanReceiveTax()
    if FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(), FacilityType.Residence) ~= nil and FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(), FacilityType.Residence) >= 1 then
        if PlayerService:Instance():GetSurplusReceiveCount() == 0 or(PlayerService:Instance():GetIsCanReceive() == true and PlayerService:Instance():GetRevenueCount() < 3) then
            self.foreignFedDot.gameObject:SetActive(true);
        else
            self.foreignFedDot.gameObject:SetActive(false);
        end
    end
end

function UIGameMainView:SetReceiveIsTrue()
    PlayerService:Instance():SetIsCanReceive()
    self:IsCanReceiveTax()
end

function UIGameMainView:ChangeRebellState()
    if PlayerService:Instance():GetsuperiorLeagueId() == 0 then
        self.rebellBtn.gameObject:SetActive(false)
    else
        self.rebellBtn.gameObject:SetActive(true)
    end
end

function UIGameMainView:ChatRedImage()
    local count = 0;
    count = ChatService:Instance():GetUnread(ChatType.AllianceChat);

    local chatTream = LeagueService:Instance():GetLeagueChatTeam();
    for k, v in pairs(chatTream) do
        count = count + ChatService:Instance():GetUnread(ChatType.GroupingChat * 10000 + v.leaderId, ChatType.GroupingChat);
    end

    if count ~= 0 then
        if self._chatFramesImage.gameObject.activeSelf == false then
            self._chatFramesImage.gameObject:SetActive(true);
        end
        if count > 99 then
            self._chatFramesText.text = "99+";
        else
            self._chatFramesText.text = count;
        end
    elseif count == 0 then
        if self._chatFramesImage.gameObject.activeSelf == true then
            self._chatFramesImage.gameObject:SetActive(false);
        end
        self._chatFramesText.text = "";
    end
end

-- 更新金币和玉
function UIGameMainView:UpdateMoney()
    local havaGold = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();
    self._goldText.text = CommonService:Instance():GetResourceCount(havaGold);

    self._SymbolText.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();
end

-- 更新可领取任务数量
function UIGameMainView:UpdateTaskCanCount()
    local count = TaskService:Instance():GetOverCount();
    if count > 0 then
        self._taskBtnCountParent.gameObject:SetActive(true);
        self._taskBtnCount.text = count;
    else
        self._taskBtnCountParent.gameObject:SetActive(false);
    end
    self:QuestEffect(count)
end

-- 任务特效
function UIGameMainView:QuestEffect(count)
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

-- 监听资源刷新
function UIGameMainView:FlushMainCityInfo()
    EventService:Instance():AddEventListener(EventType.Resource, function(...)
    end )
end

-- 监听资源刷新
function UIGameMainView:FlushMainCityInfo()
    EventService:Instance():AddEventListener(EventType.ResourceJadeGold, function(...)
    end )
end

-- 邮箱提示刷新
function UIGameMainView:RefreshMailTips()
    local allCouldOperationCounts = MailService:Instance():GetAllUnReadedMailCounts();
    if allCouldOperationCounts > 0 then
        self.messageMailBtn.gameObject:SetActive(true);
        self.messageMailCountText.text = allCouldOperationCounts;
    else
        self.messageMailBtn.gameObject:SetActive(false);
    end
end

function UIGameMainView:UpdateNewRecruitCount()
    local count = RecruitService:Instance():GetNewRecruitListCount();
    if (count > 0 and GuideServcice:Instance():GetIsFinishGuide() == true) then
        self.RecruitNewCount.transform.parent.gameObject:SetActive(true);
    else
        self.RecruitNewCount.transform.parent.gameObject:SetActive(false);
    end
    self.RecruitNewCount.text = count;
end

-- 月卡信息图标设置
function UIGameMainView:SetMonthCardInfo()
    local monthCardIsOpen = RechargeService:Instance():CheckMonthCardOpen();
    self.monthCardBtn.gameObject:SetActive(monthCardIsOpen);
end

function UIGameMainView:OnClickMonthCardBtn()
    MapService:Instance():HideTiled()
    self:HidePanel();
    UIService:Instance():ShowUI(UIType.RechargeGetMonthCardUI);

end

-- 隐藏ClickManageUI
function UIGameMainView:HideLandInfo()
    local count = UIService:Instance():GetClickUICount();
    for i = 1, count do
        local tempClickUI = UIService:Instance():GetClickUI(i)
        tempClickUI.transform.gameObject:SetActive(false);
    end
end

function UIGameMainView:SetCurrencyEnum()

    local ResourcesMax = PlayerService:Instance():GetInitResourceMax();
    local FrameMax = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetMaxValue();
    local InitFrameMax = DataCharacterInitial[1].FameLimit;
    local cityList = PlayerService:Instance():GetPlayerCityList();
    for i = 1, #cityList do
        local city = BuildingService:Instance():GetBuildingByTiledId(cityList[i].tiledId);
        if city ~= nil then
            ResourcesMax = ResourcesMax + city:GetCityPropertyByFacilityProperty(FacilityProperty.ResourcesMax);
            addLimit = city:GetCityPropertyByFacilityProperty(FacilityProperty.PrestigeMax);
            InitFrameMax = InitFrameMax + addLimit;
        end
    end
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):SetMaxValue(InitFrameMax);

    local havaGold = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue();

    self._goldText.text = CommonService:Instance():GetResourceCount(havaGold);
    self._SymbolText.text = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue();

    local wood = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):GetValue();

    self._wood.text = self:ChangeColor(wood, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local ironore = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):GetValue();
    self._IronOre.text = self:ChangeColor(ironore, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local stone = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):GetValue();
    self._Stone.text = self:ChangeColor(stone, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local provision = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):GetValue();
    self._Provisions.text = self:ChangeColor(provision, ResourcesMax) .. "/" .. CommonService:Instance():GetResourceCount(ResourcesMax);

    local renown = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();
    self._Renown.text = "<color=#EEE1CDFF>  " .. renown .. "/" .. PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetMaxValue() .. "</color>";

    local playerName = PlayerService:Instance():GetName();
    self._Force.text = "<color=#EEE1CDFF>  " .. playerName .. "</color>";
    self._Text_LigenceCount.text = "<color=#EEE1CDFF>  " .. PlayerService:Instance():GetTiledIdListCount() .. "/" .. math.floor(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue() / DataGameConfig[516].OfficialData) .. "</color>"

    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Wood):SetMaxValue(ResourcesMax);
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Iron):SetMaxValue(ResourcesMax);
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Stone):SetMaxValue(ResourcesMax);
    PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Grain):SetMaxValue(ResourcesMax);
end

-- 新手保护期声望值进度监听
function UIGameMainView:NewerPeriodListener()
    if NewerPeriodService:Instance():IsInNewerPeriod() == false then
        return;
    end

    local renownValue = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue();
    if NewerPeriodService:Instance():GetCurPeriod() < NewerPeriodType.OpenMitaFunc then
        if renownValue >= DataGameConfig[907].OfficialData then
            NewerPeriodService:Instance():RequestOpenPeriod(NewerPeriodType.OpenMitaFunc);
        end
    end
    if NewerPeriodService:Instance():GetCurPeriod() < NewerPeriodType.OpenTrainFunc then
        if renownValue >= DataGameConfig[908].OfficialData then
            NewerPeriodService:Instance():RequestOpenPeriod(NewerPeriodType.OpenTrainFunc);
        end
    end
    if NewerPeriodService:Instance():GetCurPeriod() < NewerPeriodType.OpenGarrisonFunc then
        if renownValue >= DataGameConfig[909].OfficialData then
            NewerPeriodService:Instance():RequestOpenPeriod(NewerPeriodType.OpenGarrisonFunc);
        end
    end
end

-- 刷新所有的资源产量及显示
function UIGameMainView:SetResource()
    if self.isFirstOpen == true then
        local waitTime = 2.0;
        local _coroutine = StartCoroutine( function()
            WaitForSeconds(waitTime, function() end)
            _coroutine = nil;
            self:RefreshShowResource();
            self:UpdateNewRecruitCount();
        end );
    else
        self:RefreshShowResource();
        self:UpdateNewRecruitCount();
    end
end

function UIGameMainView:RefreshShowResource()
    PlayerService:Instance():GetTotalResourceYield();
    local woodAddValue = PlayerService:Instance():GetWoodYield();
    local ironAddValue = PlayerService:Instance():GetIronYield();
    local stoneAddValue = PlayerService:Instance():GetStoneYield();
    local grainAddValue = PlayerService:Instance():GetFoodYield();
    self.WoodText.text = woodAddValue >= 0 and "+" .. woodAddValue or woodAddValue;
    self.IronOreText.text = ironAddValue >= 0 and "+" .. ironAddValue or ironAddValue;
    self.StoneText.text = stoneAddValue >= 0 and "+" .. stoneAddValue or stoneAddValue;
    self.ProvisionsText.text = grainAddValue >= 0 and "+" .. grainAddValue or grainAddValue;
    self:SetCurrencyEnum();
end

-- 点击内政
function UIGameMainView:OnClickInternalBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIInternalAffairsImage);
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    self:CheckFunctionOff();
    self:HidePanel()
end

function UIGameMainView:ChangeColor(value, ResourcesMax)
    -- body
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

-- 点击城池
function UIGameMainView:OnClickArmyBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.CityObj);
    UIService:Instance():HideUI(UIType.UIGameMainView);
    self:CheckFunctionOff();
    self:HideLandInfo();
    self:HidePanel()
end

function UIGameMainView:OnClickOrderBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIToken, self._OrderTimeText.text);
    self:HidePanel()
end

-- 点击任务按钮
function UIGameMainView:OnClickTaskBtn()
    MapService:Instance():HideTiled()
    self:CheckFunctionOff()
    UIService:Instance():ShowUI(UIType.UITask);
    self:HidePanel()
end

-- 点击打开英雄卡
function UIGameMainView:OnClickHeroCardBtn()
    MapService:Instance():HideTiled()
    self:CheckFunctionOff()
    UIService:Instance():ShowUI(UIType.UIHeroCardPackage)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    local baseClass = UIService:Instance():GetUIClass(UIType.UIHeroCardPackage)
    if baseClass then
        baseClass:ResetPackagePos()
    end
    self:HidePanel()
end

-- 充值
function UIGameMainView:OnClickRechargeBtn(args)
    MapService:Instance():HideTiled()
    -- UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():ShowUI(UIType.RechargeUI);
    self:CheckFunctionOff();
    self:HidePanel()
end

-- 邮箱
function UIGameMainView:OnClickMailBtn(args)
    MapService:Instance():HideTiled()
    UIService:Instance():HideUI(UIType.UIGameMainView)
    local showMailType = MailService:Instance():GetLatestUnReadedMailType();
    UIService:Instance():ShowUI(UIType.MailUI, showMailType);
    self:CheckFunctionOff();
    self:HidePanel()
end

-- 排行榜
function UIGameMainView:OnClickRankListBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():ShowUI(UIType.RankListUI);
    self:CheckFunctionOff();
    self:HidePanel();
end

-- 点击活动按钮
function UIGameMainView:OnClickActivityBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIActivity, ActivityType.LoginAct);
    self:HidePanel()
    self:CheckFunctionOff();
end

-- 点击战法按钮
function UIGameMainView:OnClickSkillBtn()
    MapService:Instance():HideTiled()
    --[[if (self.roleId == nil) then
        self.roleId = PlayerService:Instance():GetPlayerId()
        --print("roleId: " .. self.roleId);
        SkillService:Instance():RequestPlayerSkillList(self.roleId)
    end]]
    UIService:Instance():ShowUI(UIType.UITactis)
    self:CheckFunctionOff();
    self:HidePanel()
end

-- 点击退出游戏按钮
function UIGameMainView:OnClickExitBtn()
    CommonService:Instance():ShowOkOrCancle(self, self.GameQuit, self.cancle, "确认", "是否要退出游戏？");
end

function UIGameMainView:cancle()
    -- 空方法保留
end


--- 切换账号退出游戏+++++++++++++++
function UIGameMainView:GameExit()
    PlayerService:Instance():StopAllTimers()
    NetService:Instance():CloseTcpServer()
    PlayerService:Instance():SetOutofGame()
    LoginService:Instance():SetExit(true)
    UIService:Instance():ClearcommonBlackBg()
    Client:Instance():ClearData()
    UIService:Instance():ClearClickUI()
    MessageService:Instance():RemoveAllNotice()
    GameResFactory.Instance():LoadLevel("Login");
end

function UIGameMainView:GameQuit()
    GameResFactory.Instance():ApplicationQiut();
    -- LoginService:Instance():ExitGame()
end



-- 时间转换
function UIGameMainView:TimeFormat(time)
    local h = math.floor(time / 3600);
    local m = 0;
    local s = 0;
    local timeText = nil;
    if time <= 0 then
        timeText = "00:00:00";
    else
        if time > 3600 then
            m = math.floor((time % 3600) / 60);
        else
            m = math.floor(time / 60);
        end
        if time > 3600 then
            s = time % 3600 % 60;
        elseif time > 60 then
            s = time % 60;
        else
            s = time;
        end
        timeText = string.format("%02d:%02d:%02d", h, m, s);
    end
    return timeText;
end
-- 时间
function UIGameMainView:SetTimer()
    local times = PlayerService:Instance():GetLocalTime() / 1000;
    self._TimeText.text = "<color=#EEE1CDFF>  " .. self:TimeFormat(times % 86400 + 28800) .. "</color>";
    -- self._Text_LigenceCount.text = "<color=#EEE1CDFF>  " .. PlayerService:Instance():GetTiledIdListCount() .. "/" .. math.floor(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue() / DataGameConfig[516].OfficialData) .. "</color>"
end

function UIGameMainView:SetOrderTimer()
    -- local times = PlayerService:Instance():GetLocalTime();
    -- self._TextCount.text = PlayerService:Instance():GetDecreeSystem():GetCurValue() .. "/" .. PlayerService:Instance():GetDecreeSystem():GetMaxValue();
    -- local lastUpdateTime = PlayerService:Instance():GetDecreeSystem():GetLastUpdateTime();
    -- if PlayerService:Instance():GetDecreeSystem():GetCurValue() < PlayerService:Instance():GetDecreeSystem():GetMaxValue() then
    --     self._OrderTimeText.text = self:TimeFormat(lastUpdateTime + DataGameConfig[514].OfficialData / 1000 - times / 1000);
    --     self._TextCount.text = PlayerService:Instance():GetDecreeSystem():GetCurValue() .. "/" .. PlayerService:Instance():GetDecreeSystem():GetMaxValue();
    --     self._OrderTimeText.gameObject:SetActive(true);
    --     self.orderImage.sizeDelta = Vector2.New(250, 35);
    -- elseif PlayerService:Instance():GetDecreeSystem():GetCurValue() >= PlayerService:Instance():GetDecreeSystem():GetMaxValue() then
    --     self._OrderTimeText.gameObject:SetActive(false);
    --     self.orderImage.sizeDelta = Vector2.New(130, 35);
    -- end
    -- self._Text_LigenceCount.text = "<color=#EEE1CDFF>  " .. PlayerService:Instance():GetTiledIdListCount() .. "/" .. math.floor(PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue() / DataGameConfig[516].OfficialData) .. "</color>"

    -- print("CAMEIN");

    local curValue = PlayerService:Instance():GetDecreeSystem():GetCurValue();
    local maxValue = PlayerService:Instance():GetDecreeSystem():GetMaxValue();
    local times = PlayerService:Instance():GetLocalTime();
    self._TextCount.text = curValue .. "/" .. maxValue;
    local lastUpdateTime = PlayerService:Instance():GetDecreeSystem():GetLastUpdateTime();
    local needTime =(lastUpdateTime + DataGameConfig[514].OfficialData / 1000 - times / 1000) * 1000;
    if curValue < maxValue then
        CommonService:Instance():TimeDown(UIType.UIGameMainView, times + needTime, self._OrderTimeText, function() self:SetOrderTimer() end);
        self._OrderTimeText.gameObject:SetActive(true);
        self.orderImage.sizeDelta = Vector2.New(250, 35);
    else
        self._OrderTimeText.gameObject:SetActive(false);
        self.orderImage.sizeDelta = Vector2.New(130, 35);
    end

end


-- 计时器
function UIGameMainView:_ArmyStateRequest()
    self._requestTimer = Timer.New( function()
        self:SetTimer();
        -- self:SetOrderTimer();
    end , 1, -1, false)
    self._requestTimer:Start()
end

-- 点击同盟
function UIGameMainView:OnClickLeagueBtn()
    MapService:Instance():HideTiled()
    self:CheckFunctionOff()
    LeagueService:Instance():SendLeagueMessage(PlayerService:Instance():GetPlayerId());
    self:HidePanel()
    self:CanShoweLeagueRedImage(false)
end

-- 点击招募游戏按钮
function UIGameMainView:OnClickRecruitBtn()
    -- local msg = require("MessageCommon/Msg/C2L/Recruit/GetAllRecruitList").new()
    -- msg:SetMessageId(C2L_Recruit.GetAllRecruitList)
    -- NetService:Instance():SendMessage(msg)

    UIService:Instance():ShowUI(UIType.UIRecruitUI);
    MapService:Instance():HideTiled()
    UIService:Instance():HideUI(UIType.UIGameMainView)
    self:HidePanel()
    self:CheckFunctionOff()
end

-- 点击状态显示撤退预制
function UIGameMainView:OnClickRetreatBtn()
    MapService:Instance():HideTiled()
    local retreat = self.gameObject.transform:FindChild("Retreat");
    retreat.gameObject:SetActive(true);
    self:HidePanel()
end

-- 任务栏切换
function UIGameMainView:OnClickResourceBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    self.ResourceBtn.interactable = false;
    CommonService:Instance():WaitClickButton(self.ResourceBtn);
    if self.ButtonConversion == false then
        local rot = Vector3.forward * -180;
        self.ResourceBtn.gameObject.transform:DORotate(rot, 0.2)
        local resource = self.gameObject.transform:FindChild("Resource");
        resource.gameObject:SetActive(false);
        local manorData = self.gameObject.transform:FindChild("ManorData");
        manorData.gameObject:SetActive(true);
        self.ButtonConversion = true;
        -- self.ResourceBtn.transform.rotation = Quaternion
    else
        local rot = Vector3.back * 360;
        self.ResourceBtn.gameObject.transform:DORotate(rot, 0.2)
        local resource = self.gameObject.transform:FindChild("Resource");
        resource.gameObject:SetActive(true);
        local manorData = self.gameObject.transform:FindChild("ManorData");
        manorData.gameObject:SetActive(false);
        self.ButtonConversion = false;
        -- self.ResourceBtn.transform.rotation = Quaternions
    end
    self:HidePanel()
end

-- 主界面显示功能箭头点击
function UIGameMainView:OnClickFunctionArrow()
    -- print("OnClickFunctionArrow")
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    self.ArrowBtn.interactable = false;
    CommonService:Instance():WaitClickButton(self.ArrowBtn);
    MapService:Instance():HideTiled();
    self:HideLandInfo();
    self:HidePanel();
    if self.isShowAllFunctions == false then
        self.isShowAllFunctions = true;
        local rot = Vector3.back * -270;
        self.ArrowBtn.gameObject.transform:DORotate(rot, 0.2)
        CommonService:Instance():SetTweenAlphaGameObject(self.BehaviourParent.gameObject, true, nil, false, 0, 0, 0, function() end);
    else
        self.isShowAllFunctions = false;
        local rot = Vector3.forward * 90;
        self.ArrowBtn.gameObject.transform:DORotate(rot, 0.2)
        CommonService:Instance():SetTweenAlphaGameObject(self.BehaviourParent.gameObject, false, nil, false, 0, 0, 0, function() end);
    end
end

-- 检测全部功能界面是否打开，打开就关闭
function UIGameMainView:CheckFunctionOff()
    if self.isShowAllFunctions == true then
        self.isShowAllFunctions = false;
        local rot = Vector3.forward * 90;
        self.ArrowBtn.gameObject.transform:DORotate(rot, 0.2)
        CommonService:Instance():SetTweenAlphaGameObject(self.BehaviourParent.gameObject, false, nil, false, 0, 0, 0, function() end);
    end
end

function UIGameMainView:OnClickHeadPortraitBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.TroopsArrayPanel)
    self:HidePanel()
end

function UIGameMainView:OnClickheavenBtn()
    MapService:Instance():HideTiled()
    WorldTendencyService:Instance():SendWorldTendencyMessage()
    self:HidePanel();
    self:CheckFunctionOff();
end

-- 是否显示天下大事的小红点
function UIGameMainView:CanShowWorldPoint()
    for k, v in pairs(WorldTendencyService:Instance():GetWorldEventList()._list) do
        if v.couldGetAward == 1 and v.isGetAward == 0 then
            self.worldPoint.gameObject:SetActive(true)
            return
        else
            self.worldPoint.gameObject:SetActive(false)
        end
    end
end

function UIGameMainView:ShowWorldRedPoint()
    self.worldPoint.gameObject:SetActive(true)
end


function UIGameMainView:OnClickPMapBtn()
    LeagueService:Instance():SendLeagueMarkMessage()
    LeagueService:Instance():SendLeagueMemberMessage()
    BuildingService:Instance():SendGetOccWildBuildingMessage()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIPmap)
    self:HidePanel()
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
end

function UIGameMainView:OnClickBattleRePortBtn()
    MapService:Instance():HideTiled()
    UIService:Instance():ShowUI(UIType.UIBattleReport)
    UIService:Instance():HideUI(UIType.UIGameMainView)
    self:CheckFunctionOff();
    self:HidePanel()
end

function UIGameMainView:BattleReportUnReadCount()
    local unread = BattleReportService:Instance():GetUnReadCount();
    LogManager:Instance():Log("未读战报的消息个数为：", unread)
    self._UnReadLabel.text = tostring(unread);
    if (unread == 0) then
        self._Score.gameObject:SetActive(false);
    else
        self._Score.gameObject:SetActive(true);
    end
end

-- 敌方队伍传进去的是line的id 自己队伍传进去的是cityid和槽位id
-- 创建自己队伍左侧提示
function UIGameMainView:CreateMyArmyTip()
    local allNotNoneArmyList = PlayerService:Instance():GetAllNotNoneArmyInfos();
    if allNotNoneArmyList == nil then
        return;
    end
    local armyCount = #allNotNoneArmyList;
    if armyCount < #self._allMyArmyUiClassList then
        for i = armyCount + 1, #self._allMyArmyUiClassList do
            if self._allMyArmyUiClassList[i].gameObject.activeSelf == true then
                self._allMyArmyUiClassList[i].gameObject:SetActive(false);
            end
        end
    end

    if armyCount > 0 then
        for i = 1, armyCount do
            local armyInfo = allNotNoneArmyList[i];
            if self._allMyArmyUiClassList[i] == nil then
                self:CreateArmyTipUI(false, i, armyInfo.spawnSlotIndex, armyInfo.spawnBuildng, armyInfo.spawnBuildng, armyInfo.spawnSlotIndex);
            else
                if self._allMyArmyUiClassList[i].gameObject.activeSelf == false then
                    self._allMyArmyUiClassList[i].gameObject:SetActive(true);
                end
                self._allMyArmyUiClassList[i]:UpdateStateInfo(false, armyInfo.spawnSlotIndex, armyInfo.spawnBuildng)
            end
        end
    end
end

-- 创建敌方队伍左侧提示（基于线）
function UIGameMainView:CreateEnemyArmyTip()
    local enemyList = LineService:Instance():GetAllEnemyTipsLine();
    local armyCount = enemyList:Count();
    if armyCount < #self._allEnemyArmyUiClassList then
        for i = armyCount + 1, #self._allEnemyArmyUiClassList do
            if self._allEnemyArmyUiClassList[i].gameObject.activeSelf == true then
                self._allEnemyArmyUiClassList[i].gameObject:SetActive(false);
            end
        end
    end

    if armyCount > 0 then
        CommonService:Instance():Play("Audio/Enemy03")
        for i = 1, armyCount do
            if self._allEnemyArmyUiClassList[i] == nil then
                self:CreateArmyTipUI(true, i, enemyList:Get(i).id, 0, enemyList:Get(i).buildingId, enemyList:Get(i).armySlotIndex);
            else
                if self._allEnemyArmyUiClassList[i].gameObject.activeSelf == false then
                    self._allEnemyArmyUiClassList[i].gameObject:SetActive(true);
                end
                self._allEnemyArmyUiClassList[i]:UpdateStateInfo(true, enemyList:Get(i).id, 0)
            end
        end
    end
end

-- 创建敌方队伍左侧提示（基于战平部队）
function UIGameMainView:CreateEnemyArmyTipBattle()
    local enemyList = LineService:Instance():GetAllEnemyTipsBattle();
    local armyCount = enemyList:Count();
    if armyCount < #self._allEnemyTipsBattleUiClassList then
        for i = armyCount + 1, #self._allEnemyTipsBattleUiClassList do
            if self._allEnemyTipsBattleUiClassList[i].gameObject.activeSelf == true then
                self._allEnemyTipsBattleUiClassList[i].gameObject:SetActive(false);
            end
        end
    end

    if armyCount > 0 then
        CommonService:Instance():Play("Audio/Enemy03")
        for i = 1, armyCount do
            if self._allEnemyTipsBattleUiClassList[i] == nil then
                self:CreateArmyTipUI(true, i, enemyList:Get(i):GetId(), 1, enemyList:Get(i).buildingId, enemyList:Get(i).armySlotIndex);
            else
                if self._allEnemyTipsBattleUiClassList[i].gameObject.activeSelf == false then
                    self._allEnemyTipsBattleUiClassList[i].gameObject:SetActive(true);
                end
                self._allEnemyTipsBattleUiClassList[i]:UpdateStateInfo(true, enemyList:Get(i):GetId(), 1)
            end
        end
    end
end

function UIGameMainView:CreateArmyTipUI(isEnemy, index, para1, para2, spawnBuild, spawnSlot)
    local armyTipStateInfo = require("Game/Army/ArmyTipStateInfo").new();
    GameResFactory.Instance():GetUIPrefabByIdentification("UIPrefab/ArmyState", self.StartGrid, armyTipStateInfo, function(go)
        if isEnemy == true then
            if para2 == 0 then
                armyTipStateInfo.gameObject.name = "EnemyTipLine" .. index;
                self._allEnemyArmyUiClassList[index] = armyTipStateInfo;
                armyTipStateInfo:Init();
                armyTipStateInfo:UpdateStateInfo(true, para1, para2);
            elseif para2 == 1 then
                armyTipStateInfo.gameObject.name = "EnemyTipBattle" .. index;
                self._allEnemyTipsBattleUiClassList[index] = armyTipStateInfo;
                armyTipStateInfo:Init();
                armyTipStateInfo:UpdateStateInfo(true, para1, para2);
            end
        else
            armyTipStateInfo.gameObject.name = "MyArmy" .. index;
            self._allMyArmyUiClassList[index] = armyTipStateInfo;
            armyTipStateInfo:Init();
            armyTipStateInfo:UpdateStateInfo(false, para1, para2);
        end
    end , "ArmyTipStateInfo" .. spawnBuild .. spawnSlot);
end

-- function UIGameMainView:GetPanel()
--     local signBox = self.gameObject.transform:Find("Map/signObject");
--     local mapSign1 = self.gameObject.transform:Find("Map/MapSign1");
--     UIService:Instance():AddMainUI(signBox);
--     UIService:Instance():AddMainUI(mapSign1);
-- end

-- 隐藏标记板
function UIGameMainView:HidePanel()
    -- print("HidePanel")
    -- MapService:Instance():HideTiled();
    self.signBox:DOLocalMoveX(self.MovePosition.position.x, 0.5);
    self.isOpen = false;
    -- local mapSign1 = self.gameObject.transform:Find("Map/MapSign1");
    -- mapSign1.gameObject:SetActive(false);
end

-- 标记
function UIGameMainView:OnClickMapSign()
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
    CommonService:Instance():WaitClickButton(self._MapSign);
    MapService:Instance():HideTiled();
    self:CheckFunctionOff()
    for index = 1, #self.SignLocate do
        if self.SignLocate[index] ~= nil then
            GameResFactory.Instance():DestroyUIPrefab(self.SignLocate[index].gameObject)
            self.SignLocate[index] = nil
        end
    end
    self:MainCitySign()
    self:LoadBuildingSign();
    self:LoadFortSign();
    self:LoadWildFortSign();
    self:LoadLabelInfo();

    if self.isOpen == false then
        self.signBox.gameObject:SetActive(true);
        self.sign.localPosition = Vector3.zero;
        -- self.signBox:DOMoveX(self.SignPosition.position.x, 0.2);
        CommonService:Instance():MoveX(self.signBox.gameObject, self.MovePosition.localPosition.x, self.SignPosition.localPosition.x, 0.2);
        self.isOpen = true
    else
        -- self.signBox:DOMoveX(self.MovePosition.position.x, 0.2);
        CommonService:Instance():MoveX(self.signBox.gameObject, self.SignPosition.localPosition.x, self.MovePosition.localPosition.x, 0.2);
        self.isOpen = false;
    end


    -- local contentWidth = self._taskParent.rect.width;
    -- local contentHeight = self._titleHeight + self._targetHeight + (oneItemHeight * (self._normalTaskCount + self._targetTaskCount)) + (self._taskItemGap * (self._normalTaskCount + self._targetTaskCount + 3));
    -- self._taskParent.sizeDelta = Vector2.New(contentWidth, contentHeight);
end

function UIGameMainView:AllSign()
    self:MainCitySign()
    self:LoadBuildingSign();
    self:LoadFortSign();
    self:LoadWildFortSign();
    self:LoadLabelInfo();
end

-- function UIGameMainView:OnClickMapSign1()
--     MapService:Instance():HideTiled();
--     local signBox = self.gameObject.transform:Find("Map/signObject");
--     signBox:DOLocalMoveX(self.MovePosition.position.x, 0.5, true);
--     local mapSign1 = self.gameObject.transform:Find("Map/MapSign1");
--     mapSign1.gameObject:SetActive(false);
-- end

-- 加载标记信息预制
function UIGameMainView:LoadLabelUI(tiledIndex, index)
    -- print(tiledIndex)
    local mdata = DataUIConfig[UIType.UISignLocate];
    local UISignLocate = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._sign, UISignLocate, function(go)
        UISignLocate:DoDataExchange();
        UISignLocate:DoEventAdd();
        UISignLocate:Init(tiledIndex);
    end );
    self.SignLocate[index] = UISignLocate
end

-- 标记信息加载
function UIGameMainView:LoadLabelInfo()
    local markerCt = PlayerService:Instance():GetMarkerCt();
    for k, v in pairs(self.SignLocate) do
        v.gameObject:SetActive(false);
    end

    local anteSignBuildingSort = { }
    local endSignBuildingSort = { }
    for index = 1, markerCt do
        local tiledIndex = PlayerService:Instance():GetMarkerListByIndex(index);
        local marker = PlayerService:Instance():GetMarker(index);
        anteSignBuildingSort[index] = marker.tiledIndex;
        -- print(marker.tiledIndex)
    end
    table.sort(anteSignBuildingSort, function(a, b) return self:SortMaskRule(a, b) end);
    for k, v in pairs(anteSignBuildingSort) do
        table.insert(endSignBuildingSort, v)
    end

    for index = 1, #endSignBuildingSort do
        -- print(endSignBuildingSort[index])
        local UISignLocate = self.SignLocate[index];
        if UISignLocate == nil then
            self:LoadLabelUI(endSignBuildingSort[index], index);
        else
            self.SignLocate[index].gameObject:SetActive(true);
            UISignLocate:DoDataExchange();
            UISignLocate:DoEventAdd();
            UISignLocate:Init(endSignBuildingSort[index]);
            self.SignLocate[index] = UISignLocate;
        end
    end
    endSignBuildingSort = { };
    anteSignBuildingSort = { };
end

function UIGameMainView:SortMaskRule(a, b)
    local mainCityId = PlayerService:Instance():GetMainCityTiledId();
    local MainCityX, MainCityY = MapService:Instance():GetTiledCoordinate(mainCityId);
    local xA, yA = MapService:Instance():GetTiledCoordinate(a);
    local xB, yB = MapService:Instance():GetTiledCoordinate(b);
    local distancesA = math.sqrt((xA - MainCityX) *(xA - MainCityX) * 12960000 +(yA - MainCityY) *(yA - MainCityY) * 12960000) / 3600;
    local distancesB = math.sqrt((xB - MainCityX) *(xB - MainCityX) * 12960000 +(yB - MainCityY) *(yB - MainCityY) * 12960000) / 3600;
    return distancesA < distancesB;
end

-- 加载分城标记预制
function UIGameMainView:LoadPlayerBuildingSign(tiledIndex, index)
    local mdata = DataUIConfig[UIType.UISignLocate];
    local UISignBuilding = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._sign, UISignBuilding, function(go)
        UISignBuilding:DoDataExchange();
        UISignBuilding:DoEventAdd();
        UISignBuilding:SetBuildSign(tiledIndex);
    end );
    self.buildingSign[index] = UISignBuilding
end

function UIGameMainView:SetSignSize()
    local buildingCount = PlayerService:Instance():GetAllSubCityCount();
    local fortCount = PlayerService:Instance():GetFortCount();
    local wildFortCount = PlayerService:Instance():GetOccupyWildFortCount()
    local markerCt = PlayerService:Instance():GetMarkerCt();
    local count = buildingCount + fortCount + wildFortCount + markerCt + 1;
    if count > 5 then
        count = 5
    end
    local signPanelHight = self.height * count
    self._signPanel.sizeDelta = Vector2.New(self.width, signPanelHight);
end


-- 加载分城标记
function UIGameMainView:LoadBuildingSign()
    local buildingCount = PlayerService:Instance():GetAllSubCityCount();
    for k, v in pairs(self.buildingSign) do
        v.gameObject:SetActive(false);
    end

    -------------- 排序  有无部队  建造时间
    local anteSignBuildingSort = { }
    local count = 1;
    for i = 1, buildingCount do
        local buildingId = PlayerService:Instance():GetFromSubCityList(i);
        local building = BuildingService:Instance():GetBuilding(buildingId)
        if building == nil then
            return;
        end
        if building:CheckCityHaveArmy() == true then
            anteSignBuildingSort[count] = building
            count = count + 1;
        end
    end
    for i = 1, buildingCount do
        local buildingId = PlayerService:Instance():GetFromSubCityList(i);
        local building = BuildingService:Instance():GetBuilding(buildingId)
        if building == nil then
            return;
        end

        if building:CheckCityHaveArmy() == false then
            anteSignBuildingSort[count] = building
            count = count + 1;
        end
    end
    ----------------排序完毕

    for i = 1, #anteSignBuildingSort do
        local building = anteSignBuildingSort[i]
        if building == nil then
            return;
        end
        local tiledIndex = building._tiledId;
        local UISignBuilding = self.buildingSign[i];
        if UISignBuilding == nil then
            self:LoadPlayerBuildingSign(tiledIndex, i);
        else
            self.buildingSign[i].gameObject:SetActive(true);
            UISignBuilding:DoDataExchange();
            UISignBuilding:DoEventAdd();
            UISignBuilding:SetBuildSign(tiledIndex);
            self.buildingSign[i] = UISignBuilding;
            self:SetSignSize();
        end
    end
end

-- 主城标记
function UIGameMainView:LoadMainCitySign(tiledIndex, index)
    local mdata = DataUIConfig[UIType.UISignLocate];
    local UISignBuilding = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._sign, UISignBuilding, function(go)
        UISignBuilding:DoDataExchange();
        UISignBuilding:DoEventAdd();
        UISignBuilding:SetBuildSign(tiledIndex);
        if self.width == 0 then
            self.width = self._signPanel:GetChild(0):GetComponent(typeof(UnityEngine.UI.LayoutGroup)).minWidth;
        end
        if self.height == 0 then
            self.height = 62
        end
        self:SetSignSize();

    end );
    self.mainCitySign[index] = UISignBuilding
end

-- 主城
function UIGameMainView:MainCitySign()
    for i = 1, 1 do
        local index = PlayerService:Instance():GetMainCityTiledId()
        local mainCitySign = self.mainCitySign[i]
        if mainCitySign == nil then
            self:LoadMainCitySign(index, i)
        else
            self.mainCitySign[i].gameObject:SetActive(true)
            mainCitySign:DoDataExchange();
            mainCitySign:DoEventAdd();
            mainCitySign:SetBuildSign(index);
            self.mainCitySign[i] = mainCitySign;
            self:SetSignSize();
        end
    end
end


-- 加载要塞标记预制
function UIGameMainView:LoadPlayerFortSign(tiledIndex, index)
    local mdata = DataUIConfig[UIType.UISignLocate];
    local UISignBuilding = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._sign, UISignBuilding, function(go)
        UISignBuilding:DoDataExchange();
        UISignBuilding:DoEventAdd();
        UISignBuilding:SetBuildSign(tiledIndex);



    end );
    self._fortSignList[index] = UISignBuilding
end

-- 加载要塞
function UIGameMainView:LoadFortSign()
    local fortCount = PlayerService:Instance():GetFortCount();
    for k, v in pairs(self._fortSignList) do
        v.gameObject:SetActive(false);
    end
    -------------- 排序  有无部队  建造时间
    local anteSignBuildingSort = { }
    local count = 1;
    for i = 1, fortCount do
        local fort = PlayerService:Instance():GetFort(i);
        if fort == nil then
            return;
        end
        local armyCount = fort:GetArmyInfoCounts()
        if armyCount > 0 then
            anteSignBuildingSort[count] = fort
            count = count + 1;
        end
    end
    for i = 1, fortCount do
        local fort = PlayerService:Instance():GetFort(i);
        if fort == nil then
            return;
        end
        local armyCount = fort:GetArmyInfoCounts()
        if armyCount == 0 then
            anteSignBuildingSort[count] = fort
            count = count + 1;
        end
    end
    ---------------排完

    for i = 1, #anteSignBuildingSort do
        local fort = anteSignBuildingSort[i]
        if fort == nil then
            return
        end
        local tiledIndex = fort._tiledId;
        local UISignBuilding = self._fortSignList[i];
        if UISignBuilding == nil then
            self:LoadPlayerFortSign(tiledIndex, i);
        else
            self._fortSignList[i].gameObject:SetActive(true);
            UISignBuilding:DoDataExchange();
            UISignBuilding:DoEventAdd();
            UISignBuilding:SetBuildSign(tiledIndex);
            self._fortSignList[i] = UISignBuilding;
        end
    end
end
-- 野外要塞
function UIGameMainView:LoadWildFortSign()
    local wildFortCount = PlayerService:Instance():GetOccupyWildFortCount()
    for k, v in pairs(self.WildFort) do
        v.gameObject:SetActive(false);
    end

    local anteSignBuildingSort = { }
    local count = 1;
    for i = 1, wildFortCount do
        local fort = PlayerService:Instance():GetOccupyWildFort(i);
        if fort == nil then
            return;
        end
        local armyCount = fort:GetWildFortArmyInfoCounts()
        if armyCount > 0 then
            anteSignBuildingSort[count] = fort
            count = count + 1;
        end
    end
    for i = 1, wildFortCount do
        local fort = PlayerService:Instance():GetOccupyWildFort(i);
        if fort == nil then
            return;
        end
        local armyCount = fort:GetWildFortArmyInfoCounts()
        if armyCount == 0 then
            anteSignBuildingSort[count] = fort
            count = count + 1;
        end
    end


    for i = 1, wildFortCount do
        local fort = anteSignBuildingSort[i]
        if fort == nil then
            return
        end
        local tiledIndex = fort._tiledId
        local UISignBuilding = self.WildFort[i]
        if UISignBuilding == nil then
            self:LoadPlayerWildFortSign(tiledIndex, i)
        else
            self.WildFort[i].gameObject:SetActive(true)
            UISignBuilding:DoDataExchange();
            UISignBuilding:DoEventAdd();
            UISignBuilding:SetBuildSign(tiledIndex);
            self.WildFort[i] = UISignBuilding;
        end
    end
end

-- 加载要塞标记预制
function UIGameMainView:LoadPlayerWildFortSign(tiledIndex, index)
    local mdata = DataUIConfig[UIType.UISignLocate];
    local UISignBuilding = require(mdata.ClassName).new();
    GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self._sign, UISignBuilding, function(go)
        UISignBuilding:DoDataExchange();
        UISignBuilding:DoEventAdd();
        UISignBuilding:SetBuildSign(tiledIndex);
    end );
    self.WildFort[index] = UISignBuilding
end



function UIGameMainView:SetRevenueGold()
    -- local msg = require("MessageCommon/Msg/C2L/Player/RequestTaexs").new();
    -- msg:SetMessageId(C2L_Player.RequestTaexs);
    -- NetService:Instance():SendMessage(msg);
end

-- 显示GM界面
function UIGameMainView:ShowGMUI()
    UIService:Instance():ShowUI(UIType.GMCommand)
    self:HidePanel()
end


-- 小地图
function UIGameMainView:ClickMinMapBtn()
    MapService:Instance():HideTiled()
    local baseClass = UIService:Instance():GetUIClass(UIType.UIMinMap);
    if baseClass.gameObject.activeInHierarchy then
        baseClass.gameObject:SetActive(false)
        local rot = Vector3.back * 0;
        self.MinMapBtn.gameObject.transform:DORotate(rot, 0.2)
    else
        baseClass.gameObject:SetActive(true)
        local rot = Vector3.back * 180;
        self.MinMapBtn.gameObject.transform:DORotate(rot, 0.2)
    end

    self.minMapState = 1;
    self:HidePanel()
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
end

-- 聊天内容游戏开始同步
function UIGameMainView:ClickChatBtn()
    -- 发消息
    self:OpenChat();
    self:HidePanel()
    self:CheckFunctionOff()
end

function UIGameMainView:OpenChat()
    UIService:Instance():HideUI(UIType.UIGameMainView)
    UIService:Instance():ShowUI(UIType.UIChat, nil, function()
        local baseClass = UIService:Instance():GetUIClass(UIType.UIChat);

        if baseClass ~= nil then
            baseClass:RefreshContent();
        end
    end )
end


function UIGameMainView:HideRebellBtn()
    self.rebellBtn.gameObject:SetActive(false)
end

-- 新手保护期按钮点击
function UIGameMainView:OnClickNewerBtn()
    MapService:Instance():HideTiled();
    UIService:Instance():ShowUI(UIType.UINewerPeriod);
end

-- 新手保护期按钮显隐
function UIGameMainView:RefreshNewerBtn()
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

function UIGameMainView:OnClickrebellBtn()
    MapService:Instance():HideTiled()
    LeagueService:Instance():SendOpenRebellMsg()
    self:HidePanel()
end

function UIGameMainView:ForceBtnOnClick()
    -- body
    local msg = require("MessageCommon/Msg/C2L/Player/RevenueIntroductions").new();
    msg:SetMessageId(C2L_Player.RevenueIntroductions);
    NetService:Instance():SendMessage(msg);
    self.PersonalPowerOpenType = PersonalPowerOpenType.ForceBtnOpen;
end


function UIGameMainView:_Button_PersonalPowerOnClick()

    local msg = require("MessageCommon/Msg/C2L/Player/RevenueIntroductions").new();
    msg:SetMessageId(C2L_Player.RevenueIntroductions);
    NetService:Instance():SendMessage(msg);
    self.PersonalPowerOpenType = PersonalPowerOpenType.ResourceOpen;
end

function UIGameMainView:PersonalPower()
    -- 打开个人势力界面
    if UIService:Instance():GetOpenedUI(UIType.UIGameMainView) then
        MapService:Instance():HideTiled()
        UIService:Instance():ShowUI(UIType.UIPersonalPower, self.PersonalPowerOpenType);
        self:CheckFunctionOff();
        self:SendRequestTiledDurable();
        self:HidePanel();
    end
end

function UIGameMainView:SendRequestTiledDurable()
    local msg = require("MessageCommon/Msg/C2L/PersonalPower/RequestTiledDurable").new();
    msg:SetMessageId(C2L_PersonalPower.RequestTiledDurable);
    if msg == nil then
        return;
    end
    NetService:Instance():SendMessage(msg);
end

function UIGameMainView:_Button_AnnouncementOnClick()
    -- self:HidePanel()
    UIService:Instance():ShowUI(UIType.UINotice, 1);

end


function UIGameMainView:OnHide(...)
    -- body
    self.marchTimer:Stop();
    if UIService:Instance():GetUIClass(UIType.UIMinMap).gameObject.activeInHierarchy then
        self.showMinMap = true
    else
        self.showMinMap = false
    end
    UIService:Instance():GetUIClass(UIType.UIMinMap).gameObject:SetActive(false)
end

return UIGameMainView

