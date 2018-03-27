--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase");
local UIArmyDetail = class("UIArmyDetail", UIBase);
local UIType = require("Game/UI/UIType")
local UIService = require("Game/UI/UIService")
local MessageBox = require("Game/Common/MessageBox");
local DataHero = require("Game/Table/model/DataHero");

function UIArmyDetail:ctor()

    UIArmyDetail.super.ctor(self);

    -- 自己部队panel
    self._myArmyPanel = nil;
    -- 次数信息
    self._mCountInfo = nil;
    -- 时间信息
    self._mTimeInfo = nil;
    -- 小卡牌父物体
    self._smallCardParent = nil;
    -- 小卡牌缓存
    self._uiSmallHeroCard = nil;

    -- 头像按钮
    self._mBtnHeadIcon = nil;
    -- 开始坐标按钮
    self._mBtnStartCity = nil;
    -- 结束位置坐标按钮
    self._mBtnEndCity = nil;
    -- 撤退按钮
    self._mBtnRetreat = nil;

    -- 当前部队信息
    self.mCurArmyInfo = nil;
    -- 当前大营英雄卡信息
    self.mCurHeroCard = nil;
    -- 当前选择的格子
    self.mTiled = nil;
    
    -- 敌方部队panel
    self._enemyArmyPanel = nil;
    -- 敌方名字
    self._enemyName = nil;
    -- 敌方部队状态
    self._enemyState = nil;
    -- 结束位置坐标按钮 敌方
    self._enemyBtnEnd = nil;
    -- 敌方详情按钮
    self._enemyDetailBtn =nil;

    -- 当前玩家id
    self._playerId = 0;

    -- 倒计时文本框
    self._timeText = nil;

    self._countText = nil;
end

function UIArmyDetail:DoDataExchange()
    self._myArmyPanel = self:RegisterController(UnityEngine.Transform, "MyArmyPanel");
    self._mCountInfo = self:RegisterController(UnityEngine.Transform, "MyArmyPanel/CountInfo");
    self._countText = self:RegisterController(UnityEngine.UI.Text, "MyArmyPanel/CountInfo/CountText");
    self._mTimeInfo = self:RegisterController(UnityEngine.Transform, "MyArmyPanel/TimeInfo");
    self._timeText = self:RegisterController(UnityEngine.UI.Text, "MyArmyPanel/TimeInfo/TimeText");
    self._smallCardParent = self:RegisterController(UnityEngine.Transform, "MyArmyPanel/smallHeroCard");

    self._mBtnHeadIcon = self:RegisterController(UnityEngine.UI.Button, "MyArmyPanel/HeadButton");
    self._mBtnStartCity = self:RegisterController(UnityEngine.UI.Button, "MyArmyPanel/CityStartButton");
    self._mBtnEndCity = self:RegisterController(UnityEngine.UI.Button, "MyArmyPanel/CityEndButton");
    self._mBtnRetreat = self:RegisterController(UnityEngine.UI.Button, "MyArmyPanel/RetreatButton");

    self._enemyArmyPanel = self:RegisterController(UnityEngine.Transform, "EnemyArmyPanel");
    self._enemyName = self:RegisterController(UnityEngine.UI.Text, "EnemyArmyPanel/LvInfo/LvText");
    self._enemyState = self:RegisterController(UnityEngine.UI.Text, "EnemyArmyPanel/StateTextTip");
    self._enemyBtnEnd = self:RegisterController(UnityEngine.UI.Button, "EnemyArmyPanel/EnemyEndButton");
    self._enemyDetailBtn = self:RegisterController(UnityEngine.UI.Button, "EnemyArmyPanel/TopInfo/s5");
end

function UIArmyDetail:OnShow(param)
    -- self._mTimeInfo.gameObject:SetActive(false)
end

-- 当界面隐藏的时候调用
function UIArmyDetail:OnHide(param)
    
end

-- 注册控件事件
function UIArmyDetail:DoEventAdd()
    self:AddListener(self._mBtnHeadIcon, self.OnClickHeadBtn)
    self:AddListener(self._mBtnStartCity, self.OnClickStartBtn)
    self:AddListener(self._mBtnEndCity, self.OnClickEndBtn)
    self:AddListener(self._mBtnRetreat, self.OnClickRetreatBtn)

    self:AddListener(self._enemyBtnEnd, self.OnClickEnemyEndBtn)
    self:AddListener(self._enemyDetailBtn, self.OnClickEnemyDetail)
end

-- 注册所有的通知
function UIArmyDetail:RegisterAllNotice()
    
end

-- 初始化
function UIArmyDetail:InitInfo(tiled, playerId, armySpawnBuild, armySpawnSlot, armyState, name)
    self._playerId = playerId;
    if playerId == PlayerService:Instance():GetPlayerId() then
        self._myArmyPanel.gameObject:SetActive(true);
        self._enemyArmyPanel.gameObject:SetActive(false);
        self:SetCardDataInfo(armySpawnBuild, armySpawnSlot);
    else
        self._myArmyPanel.gameObject:SetActive(false);
        self._enemyArmyPanel.gameObject:SetActive(true);
        self:InitEnemyArmy(tiled, name, armyState);
    end
end

-- 设置我方部队相关信息
function UIArmyDetail:SetCardDataInfo(armySpawnBuild, armySpawnSlot)
    self.mCurArmyInfo = ArmyService:Instance():GetArmyInCity(armySpawnBuild, armySpawnSlot);
    if self.mCurArmyInfo==nil then 
        return;
    end 

    self.mCurHeroCard = self.mCurArmyInfo:GetCard(ArmySlotType.Back)
    if self.mCurArmyInfo ~= nil and self.mCurHeroCard ~= nil then
        self:RefreshUiSmallHeroCard();
        self:SetCountInfo();
        self:SetTimeInfo();
        self:SetStartAndEndPos();
    end
end

-- 小卡牌
function UIArmyDetail:RefreshUiSmallHeroCard()
    if self._uiSmallHeroCard == nil then
        local uiSmallHeroCard = require("Game/Hero/HeroCardPart/UISmallHeroCard").new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/GeneralSmallHeroCard", self._smallCardParent, uiSmallHeroCard, function(go)
            uiSmallHeroCard:Init();
            uiSmallHeroCard:SetUISmallHeroCardMessage(self.mCurHeroCard, false);
            local stateStr = self:GetArmyState();
            uiSmallHeroCard:SetArmyStateText(stateStr);
            uiSmallHeroCard:AllSoldierCount(self.mCurArmyInfo);
            self._uiSmallHeroCard = uiSmallHeroCard;
        end );
    else
        if self._uiSmallHeroCard.gameObject.activeSelf == false then
            self._uiSmallHeroCard.gameObject:SetActive(true);
        end
        self._uiSmallHeroCard:SetUISmallHeroCardMessage(self.mCurHeroCard, false);
        local stateStr = self:GetArmyState();
        self._uiSmallHeroCard:SetArmyStateText(stateStr);
        self._uiSmallHeroCard:AllSoldierCount(self.mCurArmyInfo);
    end
end

-- 设置次数信息 --问题不清楚什么次数
function UIArmyDetail:SetCountInfo()
    if self.mCurArmyInfo.armyState == ArmyState.Training then
        self._mCountInfo.gameObject:SetActive(true)
    else
        self._mCountInfo.gameObject:SetActive(false)
    end
    local totalTrainingTimes = self.mCurArmyInfo.totalTrainingTimes
    local curTrainingTimes = self.mCurArmyInfo.curTrainingTimes
    self._countText.text = "(" .. (totalTrainingTimes - curTrainingTimes) .. "/" .. totalTrainingTimes .. ")"
end

-- 设置计时恢复时间
function UIArmyDetail:SetTimeInfo()
    local endTime = 0;
    if self.mCurArmyInfo.armyState == ArmyState.BattleRoad or
       self.mCurArmyInfo.armyState == ArmyState.SweepRoad or
       self.mCurArmyInfo.armyState == ArmyState.GarrisonRoad or
       self.mCurArmyInfo.armyState == ArmyState.MitaRoad or
       self.mCurArmyInfo.armyState == ArmyState.TrainingRoad or
       self.mCurArmyInfo.armyState == ArmyState.RescueRoad or
       self.mCurArmyInfo.armyState == ArmyState.TransformRoad or
       self.mCurArmyInfo.armyState == ArmyState.Back then
        endTime = self.mCurArmyInfo.endTime
    elseif self.mCurArmyInfo.armyState == ArmyState.BattleIng or
           self.mCurArmyInfo.armyState == ArmyState.SweepIng then
        endTime = self.mCurArmyInfo.battleEndTime
    elseif self.mCurArmyInfo.armyState == ArmyState.MitaIng then
        endTime = self.mCurArmyInfo.farmmingEndTime
    elseif self.mCurArmyInfo.armyState == ArmyState.Training then
        endTime = self.mCurArmyInfo.trainingEndTime
    end
    self._mTimeInfo.gameObject:SetActive(false);
    if PlayerService:Instance():GetLocalTime() <= endTime then
        self._mTimeInfo.gameObject:SetActive(true);
    end
    self:ShowTime(endTime)
end


-- 显示时间
function UIArmyDetail:ShowTime(time)
    local localTime = PlayerService:Instance():GetLocalTime()
    local cdTime = math.floor((time - localTime)/1000);
    self._timeText.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(UIType.UIArmyDetailGrid,time,self._timeText,function() self:HideTimeInfo() end);
end

-- 隐藏时间信息
function UIArmyDetail:HideTimeInfo()
    self._mTimeInfo.gameObject:SetActive(false);
end


-- 设置开始结束坐标
function UIArmyDetail:SetStartAndEndPos()

    -- 根据格子id获取坐标
    local sx, sy = MapService:Instance():GetTiledCoordinate(self.mCurArmyInfo.startTiled);
    local ex, ey = MapService:Instance():GetTiledCoordinate(self.mCurArmyInfo.endTiled);
    local sXYTex = self._mBtnStartCity.transform:FindChild("XYText");
    sXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = sx .. "," .. sy;

    local eXYTex = self._mBtnEndCity.transform:FindChild("XYText");
    eXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = ex .. "," .. ey;
end

-- 获取部队状态
function UIArmyDetail:GetArmyState()
    local armyState = self.mCurArmyInfo:GetArmyState();
    if armyState == ArmyState.BattleRoad or
        armyState == ArmyState.SweepRoad or
        armyState == ArmyState.GarrisonRoad or
        armyState == ArmyState.MitaRoad or
        armyState == ArmyState.TrainingRoad or
        armyState == ArmyState.RescueRoad or
        armyState == ArmyState.TransformRoad or
        armyState == ArmyState.Back then
        return "<color=#00FF00>行军</color>";
    elseif armyState == ArmyState.BattleIng or
        armyState == ArmyState.SweepIng or
        armyState == ArmyState.RescueIng then
        return "<color=#00FF00>战斗</color>";
    elseif armyState == ArmyState.GarrisonIng then
        return "<color=#00FF00>驻守</color>";
    elseif armyState == ArmyState.MitaIng then
        return "<color=#00FF00>屯田</color>";
    elseif armyState == ArmyState.Training then
        return "<color=#00FF00>练兵</color>";
    elseif self.mCurArmyInfo:IsArmyInConscription() == true then
        return "<color=#C0C0C0>征兵</color>";
    elseif self.mCurArmyInfo:IsArmyIsBadlyHurt() == true then
        return "<color=#FF0000>重伤</color>";
    elseif self.mCurArmyInfo:IsArmyIsTired() == true then
        return "<color=#FF0000>疲劳</color>";
    elseif armyState == ArmyState.TransformArrive then
        return "<color=#00FF00>待命</color>";
    else
        return "";
    end
end

-- 头像点击事件
function UIArmyDetail:OnClickHeadBtn()
    -- MapService:Instance():HideTiled()
    local param = {};
    param.cityid = self.mCurArmyInfo.spawnBuildng;
    param.armyIndex = self.mCurArmyInfo.spawnSlotIndex;
    UIService:Instance():ShowUI(UIType.TroopsArrayPanel, param);
    -- 传递队伍索引
end

-- 点击开始坐标位置
function UIArmyDetail:OnClickStartBtn()
    --LineService:Instance():CancelArmyChoose();
    MapService:Instance():HideTiled()
    MapService:Instance():ScanTiled(self.mCurArmyInfo.startTiled);
end

-- 点击结束坐标位置
function UIArmyDetail:OnClickEndBtn()
    --LineService:Instance():CancelArmyChoose();
    MapService:Instance():HideTiled()
    MapService:Instance():ScanTiled(self.mCurArmyInfo.endTiled);
end

-- 点击撤退按钮
function UIArmyDetail:OnClickRetreatBtn()
    MapService:Instance():HideTiled()
    -- 征兵中不能撤退
    if self.mCurArmyInfo:IsArmyInConscription() == true then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.ArmyConscribe);
        return;
    end

    local paramT = { };

    paramT[1] = "是否确认撤退?";
    paramT[4] = true;
    UIService:Instance():ShowUI(UIType.MessageBox, paramT);
    MessageBox:Instance():RegisterOk( function()
        self:CallBackOK();
    end );
end

function UIArmyDetail:CallBackOK()
    local msg = require("MessageCommon/Msg/C2L/Map/ArmyRetreatingMsg").new();
    msg:SetMessageId(C2L_Army.ArmyRetreatingMsg);
    msg.buildingId = self.mCurArmyInfo.spawnBuildng;
    msg.index = self.mCurArmyInfo.spawnSlotIndex - 1;
    NetService:Instance():SendMessage(msg);
end

-- 初始化敌方部队信息
function UIArmyDetail:InitEnemyArmy(tiled, name, armyState)
    self.mTiled = tiled;
    self._enemyName.text = name;
    local eXYTex = self._enemyBtnEnd.transform:FindChild("XYText");
    eXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = tiled._x .. "," .. tiled._y;
    local stateStr = "";
    if armyState == ArmyState.BattleIng then
        stateStr = "<color=#00FF00>战斗</color>";
    elseif armyState == ArmyState.GarrisonIng then
        stateStr = "<color=#00FF00>驻守</color>";
    elseif armyState == ArmyState.MitaIng then
        stateStr = "<color=#00FF00>屯田</color>";
    elseif armyState == ArmyState.Training then
        stateStr = "<color=#00FF00>练兵</color>";
    elseif armyState == ArmyState.TransformArrive then
        stateStr = "<color=#00FF00>待命</color>";
    end
    self._enemyState.text = stateStr;
end

-- 点击敌方结束坐标位置
function UIArmyDetail:OnClickEnemyEndBtn()
    --MapService:Instance():HideTiled()
    --LineService:Instance():CancelArmyChoose();
    MapService:Instance():ScanTiledMark(self.mTiled._index);
end

-- 点击弹出敌方详情
function UIArmyDetail:OnClickEnemyDetail()
    CommonService:Instance():RequestPlayerInfo(self._playerId);
end

return UIArmyDetail;

--endregion
