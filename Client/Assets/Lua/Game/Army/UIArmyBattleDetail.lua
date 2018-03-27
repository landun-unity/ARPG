--[[
实现已出征右边简示信息
--]]

local UIBase = require("Game/UI/UIBase");
local UIArmyBattleDetail = class("UIArmyBattleDetail", UIBase);
local UIType = require("Game/UI/UIType")
local UIService = require("Game/UI/UIService")
local MessageBox = require("Game/Common/MessageBox");
local DataHero = require("Game/Table/model/DataHero");
local ArmyManage = require("Game/Army/ArmyManage");

function UIArmyBattleDetail:ctor()

    UIArmyBattleDetail.super.ctor(self);

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
    -- 立即完成按钮
    self._mOnceBtn = nil;

    -- 当前部队信息
    self.mCurArmyInfo = nil;
    -- 当前大营英雄卡信息
    self.mCurHeroCard = nil;

    -- 规定行军多长时间后不能撤退的具体时间（秒）
    self.roadingCannotBackTime = 180;
    -- 行军时间计时器
    self.roadingTimer = nil;
    -- 是否行军已经到达指定不能撤退时间
    self.isRoadingCannotBack = false;
    -- 已经行军的时间
    self.haveRoadingTime = 0;
    
    -- 敌方部队panel
    self._enemyArmyPanel = nil;
    -- 敌方名字
    self._enemyName = nil;
    -- 开始坐标按钮 敌方
    self._enemyBtnStart = nil;
    -- 结束位置坐标按钮 敌方
    self._enemyBtnEnd = nil;
    -- 敌方详情按钮
    self._enemyDetailBtn =nil;
    -- 敌方状态
    self._enemyStateText = nil;

    -- 敌方部队的line
    self._enemyLine = nil;
    -- 当前显示的是否为敌方部队
    self._isEnemyArmy = false;
    -- 若为敌方部队详情 param.cityid参数为1时是点击大地图上部队进来的 为0时是点击左侧敌方提示进来的 为2是点击左侧敌方战平提示进来
    self._enemyEnterType = 0;
    -- 敌方战平tip
    self._enemyTipBattle = nil;

    -- 倒计时文本框
    self._timeText = nil;

    self._countText = nil;

end

function UIArmyBattleDetail:DoDataExchange()
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
    self._mOnceBtn = self:RegisterController(UnityEngine.UI.Button, "MyArmyPanel/OnceButton");

    self._enemyArmyPanel = self:RegisterController(UnityEngine.Transform, "EnemyArmyPanel");
    self._enemyName = self:RegisterController(UnityEngine.UI.Text, "EnemyArmyPanel/LvInfo/LvText");
    self._enemyBtnStart = self:RegisterController(UnityEngine.UI.Button, "EnemyArmyPanel/EnemyStartButton");
    self._enemyBtnEnd = self:RegisterController(UnityEngine.UI.Button, "EnemyArmyPanel/EnemyEndButton");
    self._enemyDetailBtn = self:RegisterController(UnityEngine.UI.Button, "EnemyArmyPanel/TopInfo/s5");
    self._enemyStateText = self:RegisterController(UnityEngine.UI.Text, "EnemyArmyPanel/StateTextTip");
end

function UIArmyBattleDetail:OnInit()

end 

-- 若为敌方部队详情 param.cityid参数为1时是点击大地图上部队进来的 为0时是点击左侧敌方提示进来的 为2是点击左侧敌方战平提示进来
function UIArmyBattleDetail:OnShow(param)
    self._isEnemyArmy = (param.isEnemy == 1);
    if self._isEnemyArmy == true then
        self._myArmyPanel.gameObject:SetActive(false);
        self._enemyArmyPanel.gameObject:SetActive(true);
        self:InitEnemyArmy(param.index, param.cityid);
    else
        self._myArmyPanel.gameObject:SetActive(true);
        self._enemyArmyPanel.gameObject:SetActive(false);
        self:SetCardDataInfo(param.index, param.cityid);
        self:JudgeRoadingTimer();
    end
end

-- 当界面隐藏的时候调用
function UIArmyBattleDetail:OnHide(param)
	self:StopRoadingTimer();
end

-- 注册控件事件
function UIArmyBattleDetail:DoEventAdd()
    self:AddListener(self._mBtnHeadIcon, self.OnClickHeadBtn)
    self:AddListener(self._mBtnStartCity, self.OnClickStartBtn)
    self:AddListener(self._mBtnEndCity, self.OnClickEndBtn)
    self:AddListener(self._mBtnRetreat, self.OnClickRetreatBtn)
    self:AddListener(self._mOnceBtn, self.OnClickOnceBtn)

    self:AddListener(self._enemyBtnStart, self.OnClickEnemyStartBtn)
    self:AddListener(self._enemyBtnEnd, self.OnClickEnemyEndBtn)
    self:AddListener(self._enemyDetailBtn, self.OnClickEnemyDetail)
end

-- 注册所有的通知
function UIArmyBattleDetail:RegisterAllNotice()
    self:RegisterNotice(L2C_Army.ArmyBaseInfo, self.ArmyBaseCallBack);
    self:RegisterNotice(L2C_Map.RemoveLine, self.EnemyArmyCallBack);
    self:RegisterNotice(L2C_Map.RemoveEnemyTipsLine, self.EnemyArmyCallBack);
    self:RegisterNotice(L2C_Map.RemoveEnemyTipsBattle, self.EnemyArmyCallBack);
end

--军队信息回调
function UIArmyBattleDetail:ArmyBaseCallBack()
    if self.gameObject.activeSelf == false then
        return;
    end
    
    if self._isEnemyArmy == true then
        return;
    end

    if self.mCurArmyInfo == nil or self.mCurArmyInfo:GetArmyState() == ArmyState.None then
        UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
        return;
    end

    self:RefreshUiSmallHeroCard();
    self:SetCountInfo();
    self:SetTimeInfo();
    self:SetStartAndEndPos();
    self:SetBtnEnable();

    self:JudgeRoadingTimer();
end

-- 敌方部队回调
function UIArmyBattleDetail:EnemyArmyCallBack()
    if self.gameObject.activeSelf == false then
        return;
    end

    if self._isEnemyArmy == false then
        return;
    end

    if self._enemyEnterType == 2 then
        if self._enemyTipBattle == nil or self._enemyTipBattle.id == nil or LineService:Instance():GetEnemyTipsBattle(self._enemyTipBattle.id) == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end
    else
        if self._enemyLine == nil or self._enemyLine.id == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end

        if self._enemyEnterType == 0 and LineService:Instance():GetEnemyTipsLine(self._enemyLine.id) == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end

        if self._enemyEnterType == 1 and LineService:Instance():GetLine(self._enemyLine.id) == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end
    end
end

-- 初始化敌方部队信息
-- 若为敌方部队详情 param.cityid参数为1时是点击大地图上部队进来的 为0时是点击左侧敌方线提示进来的 为2是点击左侧敌方战平提示进来
function UIArmyBattleDetail:InitEnemyArmy(lineId, enterType)
    self._enemyEnterType = enterType;

    if self._enemyEnterType == 0 then
        self._enemyLine = LineService:Instance():GetEnemyTipsLine(lineId);
        if self._enemyLine == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end
        self._enemyName.text = self._enemyLine:GetPlayerName();
        self._enemyStateText.text = "<color=#00FF00>行军</color>";
        local sx, sy = MapService:Instance():GetTiledCoordinate(self._enemyLine:GetStartTiledId());
        local ex, ey = MapService:Instance():GetTiledCoordinate(self._enemyLine:GetEndTiledId());
        local sXYTex = self._enemyBtnStart.transform:FindChild("XYText");
        sXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = sx .. "," .. sy;
        local eXYTex = self._enemyBtnEnd.transform:FindChild("XYText");
        eXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = ex .. "," .. ey;
    elseif self._enemyEnterType == 1 then
        self._enemyLine = LineService:Instance():GetLine(lineId);
        if self._enemyLine == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end
        self._enemyName.text = self._enemyLine:GetPlayerName();
        self._enemyStateText.text = "<color=#00FF00>行军</color>";
        local sx, sy = MapService:Instance():GetTiledCoordinate(self._enemyLine:GetStartTiledId());
        local ex, ey = MapService:Instance():GetTiledCoordinate(self._enemyLine:GetEndTiledId());
        local sXYTex = self._enemyBtnStart.transform:FindChild("XYText");
        sXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = sx .. "," .. sy;
        local eXYTex = self._enemyBtnEnd.transform:FindChild("XYText");
        eXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = ex .. "," .. ey;
    elseif self._enemyEnterType == 2 then
        self._enemyTipBattle = LineService:Instance():GetEnemyTipsBattle(lineId);
        if self._enemyTipBattle == nil then
            UIService:Instance():HideUI(UIType.UIArmyBattleDetail);
            return;
        end
        self._enemyName.text = self._enemyTipBattle.playerName;
        self._enemyStateText.text = "<color=#00FF00>战斗</color>";
        local sx, sy = MapService:Instance():GetTiledCoordinate(self._enemyTipBattle.tiledId);
        local ex, ey = MapService:Instance():GetTiledCoordinate(self._enemyTipBattle.tiledId);
        local sXYTex = self._enemyBtnStart.transform:FindChild("XYText");
        sXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = sx .. "," .. sy;
        local eXYTex = self._enemyBtnEnd.transform:FindChild("XYText");
        eXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = ex .. "," .. ey;
    end
end

-- 设置我方部队相关信息
function UIArmyBattleDetail:SetCardDataInfo(armyIndex, cityid)
    self.mCurArmyInfo = ArmyService:Instance():GetArmyInCity(cityid, armyIndex);
    self.mCurHeroCard = self.mCurArmyInfo:GetCard(ArmySlotType.Back)
    if self.mCurArmyInfo ~= nil and self.mCurHeroCard ~= nil then
        self:RefreshUiSmallHeroCard();
        self:SetCountInfo();
        self:SetTimeInfo();
        self:SetStartAndEndPos();
        self:SetBtnEnable();
    end
end

-- 小卡牌
function UIArmyBattleDetail:RefreshUiSmallHeroCard()
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

-- 获取部队状态
function UIArmyBattleDetail:GetArmyState()
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

-- 设置次数信息
function UIArmyBattleDetail:SetCountInfo()
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
function UIArmyBattleDetail:SetTimeInfo()
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
function UIArmyBattleDetail:ShowTime(time)
    local localTime = PlayerService:Instance():GetLocalTime()
    local cdTime = math.floor((time - localTime)/1000);
    self._timeText.text = CommonService:Instance():GetDateString(cdTime);
    CommonService:Instance():TimeDown(UIType.UIArmyBattleDetail, time,self._timeText,function() self:HideTimeInfo() end);
end

-- 隐藏时间信息
function UIArmyBattleDetail:HideTimeInfo()
    self._mTimeInfo.gameObject:SetActive(false);
end

-- 设置开始结束坐标
function UIArmyBattleDetail:SetStartAndEndPos()

    -- 根据格子id获取坐标
    local sx, sy = MapService:Instance():GetTiledCoordinate(self.mCurArmyInfo.startTiled);
    local ex, ey = MapService:Instance():GetTiledCoordinate(self.mCurArmyInfo.endTiled);
    local sXYTex = self._mBtnStartCity.transform:FindChild("XYText");
    sXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = sx .. "," .. sy;

    local eXYTex = self._mBtnEndCity.transform:FindChild("XYText");
    eXYTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = ex .. "," .. ey;
end

-- 设置撤退按钮与立即完成按钮显示状态
function UIArmyBattleDetail:SetBtnEnable()
    local armyState = self.mCurArmyInfo:GetArmyState();
    -- 状态设置
    if armyState == ArmyState.Back then
        self._mBtnRetreat.gameObject:SetActive(false);
        self._mOnceBtn.gameObject:SetActive(true);
        self:SetOnceBtnInfo();
    else
        self._mBtnRetreat.gameObject:SetActive(true);
        self._mOnceBtn.gameObject:SetActive(false);
    end
end

--设置撤退按钮的颜色
function UIArmyBattleDetail:SetBackBtnColor(isBlack)
    self._mBtnRetreat.transform:FindChild("black").gameObject:SetActive(isBlack);
end

-- 设置  立即完成按钮信息
function UIArmyBattleDetail:SetOnceBtnInfo()
    -- 获取消耗货币的类型
    local currType = self._mOnceBtn.transform:FindChild("currencyType");
    currType.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("Diamond");
    --local numbTex = self._mOnceBtn.transform:FindChild("Numb");
    --numbTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = "20";

end

-- 头像点击事件
function UIArmyBattleDetail:OnClickHeadBtn()
    --MapService:Instance():HideTiled()
    local param = {};
    param.cityid = self.mCurArmyInfo.spawnBuildng;
    param.armyIndex = self.mCurArmyInfo.spawnSlotIndex;
    UIService:Instance():ShowUI(UIType.TroopsArrayPanel, param);
end

-- 点击开始坐标位置
function UIArmyBattleDetail:OnClickStartBtn()
    --MapService:Instance():HideTiled()
    LineService:Instance():CancelArmyChoose();
    MapService:Instance():ScanTiledMark(self.mCurArmyInfo.startTiled);
end

-- 点击结束坐标位置
function UIArmyBattleDetail:OnClickEndBtn()
   -- MapService:Instance():HideTiled()
    LineService:Instance():CancelArmyChoose();
    MapService:Instance():ScanTiledMark(self.mCurArmyInfo.endTiled);
end

-- 点击撤退按钮
function UIArmyBattleDetail:OnClickRetreatBtn()
    MapService:Instance():HideTiled()
    -- 征兵中不能撤退
    if self.mCurArmyInfo:IsArmyInConscription() == true then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,UICueMessageType.armyConscribe);
        return;
    end

    if self.isRoadingCannotBack == true then
        --print("点击撤退按钮")
        --print("!!!!已行军到达指定时间  不能撤退");
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 38);
        return;
    end

    -- 测试撤退提示功能ok
    local paramT = { };
    -- 行军前3分钟掉用
    --    paramT[2] = "取消行军后部队原路返回,并退还<color=yellow>10</color>点体力";
    --    paramT[3] = true;

    -- 已经到达目的地调用

    paramT[1] = "是否确认取消行军?";
    paramT[4] = true;
    UIService:Instance():ShowUI(UIType.MessageBox, paramT);
    MessageBox:Instance():RegisterOk( function()
        self:CallBackOK();
    end );
end

function UIArmyBattleDetail:CallBackOK()
    --print("111")
    if self.isRoadingCannotBack == true then
        --print("!!!!已行军到达指定时间  不能撤退");
        --print("无法撤退按钮点击")
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 38);
        return;
    end

    -- 确定撤退
    local msg = require("MessageCommon/Msg/C2L/Army/ArmyRetreatingMsg").new();
    msg:SetMessageId(C2L_Army.ArmyRetreatingMsg);
    msg.buildingId = self.mCurArmyInfo.spawnBuildng;
    msg.index = self.mCurArmyInfo.spawnSlotIndex - 1;
    --    msg.tiledIndex = 675;
    NetService:Instance():SendMessage(msg);

end

-- 点击立即完成
function UIArmyBattleDetail:OnClickOnceBtn()
    if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() < 20 then
        param = {}
        param[1] = ""
        param[2] = "没有足够的宝石.请前往充值界面";
        param[3] = "宝石不足";
        UIService:Instance():ShowUI(UIType.UICommonTipSmall, param)
        return;
    end
    MapService:Instance():HideTiled()
    -- 立即撤退
    local msg = require("MessageCommon/Msg/C2L/Army/ArmyRetreatingImmediately").new();
    msg:SetMessageId(C2L_Army.ArmyRetreatingImmediately);
    msg.buildingId = self.mCurArmyInfo.spawnBuildng;
    msg.index = self.mCurArmyInfo.spawnSlotIndex - 1;
    NetService:Instance():SendMessage(msg);

end

-- 判断行军是否计时
function UIArmyBattleDetail:JudgeRoadingTimer()
    if self.mCurArmyInfo:GetArmyState() ~= ArmyState.BattleRoad and
    self.mCurArmyInfo:GetArmyState() ~= ArmyState.SweepRoad and
    self.mCurArmyInfo:GetArmyState() ~= ArmyState.GarrisonRoad and
    self.mCurArmyInfo:GetArmyState() ~= ArmyState.MitaRoad and
    self.mCurArmyInfo:GetArmyState() ~= ArmyState.TrainingRoad and
    self.mCurArmyInfo:GetArmyState() ~= ArmyState.RescueRoad and
    self.mCurArmyInfo:GetArmyState() ~= ArmyState.TransformRoad then
        self:StopRoadingTimer();
        self.haveRoadingTime = 0;
        self.isRoadingCannotBack = false;
        self:SetBackBtnColor(false);
        --self._mBtnRetreat.interactable = true;
        return;
    end

    self.haveRoadingTime = (PlayerService:Instance():GetLocalTime() - self.mCurArmyInfo.startTime) / 1000;
    if self.haveRoadingTime >= self.roadingCannotBackTime then
        self:StopRoadingTimer();
        self.isRoadingCannotBack = true;
        self.haveRoadingTime = 0;
        self:SetBackBtnColor(true);
        --self._mBtnRetreat.interactable = false;
    else
        self:StopRoadingTimer();
        self:SetBackBtnColor(false);
       -- self._mBtnRetreat.interactable = true;
        self.isRoadingCannotBack = false;
        self.roadingTimer = Timer.New(
            function()
                self.haveRoadingTime = self.haveRoadingTime + 1;
                if self.haveRoadingTime >= self.roadingCannotBackTime then
                    self:StopRoadingTimer();
                    self.isRoadingCannotBack = true;
                    self.haveRoadingTime = 0;
                    self:SetBackBtnColor(true);
                   -- self._mBtnRetreat.interactable = false;
                end
            end, 1, -1, false);
        self.roadingTimer:Start();
    end
end

-- 停止计时器
function UIArmyBattleDetail:StopRoadingTimer()
    if self.roadingTimer == nil then
        return;
    end

    self.roadingTimer:Stop();
    self.roadingTimer = nil;
end

-- 点击敌方开始坐标位置
function UIArmyBattleDetail:OnClickEnemyStartBtn()
    MapService:Instance():HideTiled()
    LineService:Instance():CancelArmyChoose();
    if self._enemyEnterType == 2 then
        MapService:Instance():ScanTiled(self._enemyTipBattle.tiledId);
    else
        MapService:Instance():ScanTiled(self._enemyLine:GetStartTiledId());
    end
end
-- 点击敌方结束坐标位置
function UIArmyBattleDetail:OnClickEnemyEndBtn()
    MapService:Instance():HideTiled()
    LineService:Instance():CancelArmyChoose();
    if self._enemyEnterType == 2 then
        MapService:Instance():ScanTiled(self._enemyTipBattle.tiledId);
    else
        MapService:Instance():ScanTiled(self._enemyLine:GetEndTiledId());
    end
end

-- 点击弹出敌方详情
function UIArmyBattleDetail:OnClickEnemyDetail()
    if self._enemyEnterType == 2 then
        CommonService:Instance():RequestPlayerInfo(self._enemyTipBattle.playerId);
    else
        CommonService:Instance():RequestPlayerInfo(self._enemyLine.playerId);
    end
end

return UIArmyBattleDetail;