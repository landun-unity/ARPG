--[[
    查看部队界面
--]]

local UIBase = require("Game/UI/UIBase")
local TroopsArrayPanel = class("TroopsArrayPanel", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType")
local DataHero = require("Game/Table/model/DataHero");

-- 构造函数
function TroopsArrayPanel:ctor()
    TroopsArrayPanel.super.ctor(self)
    -- 背景
    self._mBackgroundBtn = nil;
    -- 总兵力
    self._mAllTroopsTex = nil;
    -- 攻城数
    self._mAttackNumbTex = nil;
    -- 部队移动速度
    self._mSpeedTex = nil;
    -- 部队当前状态 是否在主城
    self._mArmyStateTip = nil;

    -- 1前锋  2中军  3大营
    -- 小卡牌预设父物体
    self._uiSmallCardParent = {};
    -- 未开启状态ui
    self._uiNoOpen = {};
    -- 开启状态ui
    self._uiOpen = {};
    -- 卡牌状态ui
    self._uiCardState = {};
    -- 卡牌倒计时ui
    self._uiCardCountDown = {};

    -- 小卡牌预设
    self._uiSmallHeroCardMap = {};
    -- 卡牌计时器
    self._timerMap = {};

    -- 当前部队
    self.mCurArmyInfo = nil;
    -- 当前部队前锋是否开放
    self._armyFrontOpen = false;
end

-- 注册控件
function TroopsArrayPanel:DoDataExchange()
    self._mBackgroundBtn = self:RegisterController(UnityEngine.UI.Button, "ShadePanel");
    self._mAllTroopsTex = self:RegisterController(UnityEngine.UI.Text, "TroopsArrayImage/NumericalObj/TroopsText/sumTroopsText");
    self._mAttackNumbTex = self:RegisterController(UnityEngine.UI.Text, "TroopsArrayImage/NumericalObj/SiegeText/attackCityText");
    self._mSpeedTex = self:RegisterController(UnityEngine.UI.Text, "TroopsArrayImage/NumericalObj/SpeedText/speedText");
    self._mArmyStateTip = self:RegisterController(UnityEngine.Transform, "TroopsArrayImage/HintImage");

    for i = 1, 3 do
        self._uiSmallCardParent[i] = self:RegisterController(UnityEngine.Transform, "TroopsArrayImage/BottomFiveImage/GeneralSmallHeroCard" .. i .. "/Open/smallHeroCard");
        self._uiOpen[i] = self:RegisterController(UnityEngine.Transform, "TroopsArrayImage/BottomFiveImage/GeneralSmallHeroCard" .. i .. "/Open");
        self._uiNoOpen[i] = self:RegisterController(UnityEngine.Transform, "TroopsArrayImage/BottomFiveImage/GeneralSmallHeroCard" .. i .. "/NotOpenedImage");
        self._uiCardState[i] = self:RegisterController(UnityEngine.UI.Text, "TroopsArrayImage/BottomFiveImage/GeneralSmallHeroCard" .. i .. "/Open/StatusText/StateText");
        self._uiCardCountDown[i] = self:RegisterController(UnityEngine.UI.Text, "TroopsArrayImage/BottomFiveImage/GeneralSmallHeroCard" .. i .. "/Open/StatusText/TimeText");
    end
end

-- 注册控件点击事件
function TroopsArrayPanel:DoEventAdd()
    self:AddListener(self._mBackgroundBtn, self.OnClickBackGroundPanel)
end

-- 把当前部队索引传过来
function TroopsArrayPanel:OnShow(param)
    local curArmyInfo = ArmyService:Instance():GetArmyInCity(param.cityid, param.armyIndex);
    if curArmyInfo ~= nil then
        self.mCurArmyInfo = curArmyInfo;
        local building = BuildingService:Instance():GetBuilding(curArmyInfo.spawnBuildng);
        self._armyFrontOpen = building:CheckArmyFrontOpen(curArmyInfo.spawnSlotIndex);

        self:SetArmyBaseInfo();
        for index = 1, 3 do
            self:SetOpenInfo(index);
        end
    end
end

-- 当界面隐藏的时候调用
function TroopsArrayPanel:OnHide(param)
    
end

-- 设置下方部队基础信息
function TroopsArrayPanel:SetArmyBaseInfo()
    -- 兵力
    self._mAllTroopsTex.text = self.mCurArmyInfo:GetAllSoldierCount();
    -- 攻城数
    self._mAttackNumbTex.text = self.mCurArmyInfo:GetAllAttackCityValue();
    -- 行军速度
    self._mSpeedTex.text = self.mCurArmyInfo:GetSpeedContainFacility();
    -- 是否在主城
    if self.mCurArmyInfo.armyState == ArmyState.None then
        -- 在主城
        self._mArmyStateTip.gameObject:SetActive(false);
    else
        -- 不在
        self._mArmyStateTip.gameObject:SetActive(true);
    end
end

-- 设置卡牌开放状态
function TroopsArrayPanel:SetOpenInfo(index)
    -- 默认大营中军达到校场开放等级就可配置，如没配置就提示未配置
    -- 前锋卡与统帅厅的开放有关，未达到就提示开放需要条件
    local curHeroCard = self.mCurArmyInfo:GetCard(index);
    if curHeroCard == nil then
        self._uiOpen[index].gameObject:SetActive(false);
        self._uiNoOpen[index].gameObject:SetActive(true);
        local strDes = "";
        if index == ArmySlotType.Front then
            if self._armyFrontOpen == true then
                strDes = "未配置";
            else
                strDes = "未开放\n统帅厅Lv." .. self.mCurArmyInfo.spawnSlotIndex .. "开放";
            end
        else
            strDes = "未配置";
        end
        local tipTex = self._uiNoOpen[index].transform:FindChild("Text");
        tipTex.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = strDes;
    else
        self._uiOpen[index].gameObject:SetActive(true);
        self._uiNoOpen[index].gameObject:SetActive(false);
        self:CreateUiSmallHeroCard(index, curHeroCard);
        self:SetCardSateInfo(index, curHeroCard);
    end
end

-- 创建小卡牌
function TroopsArrayPanel:CreateUiSmallHeroCard(index, curHeroCard)
    if self._uiSmallHeroCardMap[index] == nil then
        local uiSmallHeroCard = require("Game/Hero/HeroCardPart/UISmallHeroCard").new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/GeneralSmallHeroCard", self._uiSmallCardParent[index], uiSmallHeroCard, function(go)
            uiSmallHeroCard:Init();
            uiSmallHeroCard:SetUISmallHeroCardMessage(curHeroCard, false);
            uiSmallHeroCard:SetArmyStateText("");
            uiSmallHeroCard:SetArmyCountFalse();
            self._uiSmallHeroCardMap[index] = uiSmallHeroCard;
        end );
    else
        if self._uiSmallHeroCardMap[index].gameObject.activeSelf == false then
            self._uiSmallHeroCardMap[index].gameObject:SetActive(true);
        end
        self._uiSmallHeroCardMap[index]:SetUISmallHeroCardMessage(curHeroCard, false);
        self._uiSmallHeroCardMap[index]:SetArmyStateText("");
        self._uiSmallHeroCardMap[index]:SetArmyCountFalse();
    end
end

-- 设置部队状态: 征兵 疲劳 重伤
function TroopsArrayPanel:SetCardSateInfo(index, curHeroCard)
    if self.mCurArmyInfo == nil then
        return;
    end

    local strState = "";
    if self.mCurArmyInfo:IsConscription(index) == true then
        strState = "<color=#C0C0C0>征兵</color>";
    elseif self.mCurArmyInfo:CheckArmyCardIsHurt(index) == true then
        strState = "<color=#FF0000>重伤</color>";
    elseif self.mCurArmyInfo:CheckArmyCardIsTired(index) == true then
        strState = "<color=#FF0000>疲劳</color>";
    end

    self._uiCardState[index].text = strState;

    self:SetTimeInfo(index, curHeroCard);
end

-- 设置恢复时间
function TroopsArrayPanel:SetTimeInfo(index, curHeroCard)
    local strState = "";
    --
    self._uiCardCountDown[index].text = strState;
end

-- 点击背景关闭当前界面
function TroopsArrayPanel:OnClickBackGroundPanel()
    UIService:Instance():HideUI(UIType.TroopsArrayPanel);
end

return TroopsArrayPanel
