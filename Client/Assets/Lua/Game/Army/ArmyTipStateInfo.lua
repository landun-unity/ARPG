--[[
    出征提示状态显示
--]]

local UIBase = require("Game/UI/UIBase");
local ArmyTipStateInfo = class("ArmyTipStateInfo", UIBase);
local UIType = require("Game/UI/UIType")
local UIService = require("Game/UI/UIService")
local DataHero = require("Game/Table/model/DataHero");
local ArmyManage = require("Game/Army/ArmyManage");

function ArmyTipStateInfo:ctor()
    ArmyTipStateInfo.super.ctor(self);
    -- 自己的部队panel
    self._myArmyPanel = nil;
    -- 敌方的部队panel
    self._enemyArmyPanel = nil;
    -- 点击
    self._TipBtn = nil;
    -- 大营名称
    self._CardName = nil;
    -- 当前征兵状态
    -- 状态行军
    self._ImgMarch = nil;
    -- 战斗
    self._ImgFight = nil;
    -- 守
    self._Imggarrison = nil;
    -- 屯田
    self._ImgMita = nil;
    -- 驻太守
    self._ImgTS = nil;
    -- 待命
    self._ImgWalit = nil;
    -- 当前是否为敌方部队
    self._isEnemy = false;
    -- 我方部队的cityid
    self._armySpawnCityId = nil;
    -- 我方部队记录槽位 敌方部队记录line的id
    self._armyIndex = nil;
end

function ArmyTipStateInfo:OnInit()

end

function ArmyTipStateInfo:OnShow()

end 

-- 查找控件
function ArmyTipStateInfo:DoDataExchange()
    self._myArmyPanel = self:RegisterController(UnityEngine.Transform, "Panel");
    self._enemyArmyPanel = self:RegisterController(UnityEngine.Transform, "PanelEnemy");
    self._TipBtn = self:RegisterController(UnityEngine.UI.Button, "");
    self._CardName = self:RegisterController(UnityEngine.UI.Text, "Panel/CardName");
    self._ImgMarch = self:RegisterController(UnityEngine.Transform, "Panel/StateImage/Img1March");
    self._ImgFight = self:RegisterController(UnityEngine.Transform, "Panel/StateImage/Img2Fight");
    self._Imggarrison = self:RegisterController(UnityEngine.Transform, "Panel/StateImage/Img3garrison");
    self._ImgTS = self:RegisterController(UnityEngine.Transform, "Panel/StateImage/Img4TS");
    self._ImgMita = self:RegisterController(UnityEngine.Transform, "Panel/StateImage/Img5Mita");
    self._ImgWalit = self:RegisterController(UnityEngine.Transform, "Panel/StateImage/Img6Awailt");
end

-- 注册控件事件
function ArmyTipStateInfo:DoEventAdd()
    self:AddListener(self._TipBtn, self.OnClickTipBtn);
end

-- 实现点击提示事件
function ArmyTipStateInfo:OnClickTipBtn()
    if self._isEnemy == true then
        if self._armySpawnCityId == 0 then
            local enemyLine = LineService:Instance():GetEnemyTipsLine(self._armyIndex);
            if enemyLine ~= nil then
                self:EnterDetailUI();
            end
        elseif self._armySpawnCityId == 1 then
            local enemyTipsBattle = LineService:Instance():GetEnemyTipsBattle(self._armyIndex);
            if enemyTipsBattle ~= nil then
                self:EnterDetailUI();
            end
        end
    else
        local armyInfo = ArmyService:Instance():GetArmyInCity(self._armySpawnCityId, self._armyIndex);
        if armyInfo ~= nil then
            self:EnterDetailUI();
        end
    end
end

function ArmyTipStateInfo:EnterDetailUI()
    local param = {};
    param.isEnemy = 0;
    param.index = self._armyIndex;
    param.cityid = self._armySpawnCityId;
    if self._isEnemy == true then
        param.isEnemy = 1;
        -- 若为敌方部队详情 param.cityid参数为1时是点击大地图上部队进来的 为0时是点击左侧敌方线提示进来的 为2是点击左侧敌方战平提示进来
        if self._armySpawnCityId == 0 then
            param.cityid = 0;
        elseif self._armySpawnCityId == 1 then
            param.cityid = 2;
        end
    end
    UIService:Instance():HideUI(UIType.UIArmyDetailGrid);
    UIService:Instance():ShowUI(UIType.UIArmyBattleDetail, param);
    LineService:Instance():ChooseArmyLine(self._isEnemy, self._armyIndex, self._armySpawnCityId);
end

-- 自己队伍传进来的是cityid和槽位id
-- 敌方队伍若是基于线传进来的是line的id和0 若是基于战平部队传进来的是EnemyTipBattle的id和1
function ArmyTipStateInfo:UpdateStateInfo(isEnemy, armyIndex, cityid)
    self._isEnemy = isEnemy;
    self._armyIndex = armyIndex;
    self._armySpawnCityId = cityid;

    if isEnemy == true then
        self._myArmyPanel.gameObject:SetActive(false);
        self._enemyArmyPanel.gameObject:SetActive(true);
    else
        self._myArmyPanel.gameObject:SetActive(true);
        self._enemyArmyPanel.gameObject:SetActive(false);
        self:SetMyArmyInfo();
    end
end

function ArmyTipStateInfo:SetMyArmyInfo()
    local armyInfo = ArmyService:Instance():GetArmyInCity(self._armySpawnCityId, self._armyIndex);

    if armyInfo ~= nil then
        local backCard = armyInfo:GetCard(ArmySlotType.Back);
        if backCard ~= nil and DataHero[backCard.tableID] ~= nil then
            self._CardName.text = DataHero[backCard.tableID].Name;
        end
        --行军
        self._ImgMarch.gameObject:SetActive(false);
        --战斗
        self._ImgFight.gameObject:SetActive(false);
        --驻守
        self._Imggarrison.gameObject:SetActive(false);
        --屯田 练兵
        self._ImgMita.gameObject:SetActive(false);
        --驻太守
        self._ImgTS.gameObject:SetActive(false);
        --待命
        self._ImgWalit.gameObject:SetActive(false);

        local armyState = armyInfo:GetArmyState();
        -- 状态设置
        if armyState == ArmyState.BattleIng then
            --战平
            self._ImgFight.gameObject:SetActive(true);
        elseif armyState == ArmyState.SweepIng then
            --扫荡战平
            self._ImgFight.gameObject:SetActive(true);
        elseif armyState == ArmyState.RescueIng then
            --解救战平
            self._ImgFight.gameObject:SetActive(true);
        elseif armyState == ArmyState.GarrisonIng then
            --驻守中
            self._Imggarrison.gameObject:SetActive(true);
        elseif armyState == ArmyState.MitaIng then
            --屯田中
            self._ImgMita.gameObject:SetActive(true);
        elseif armyState == ArmyState.Training then
            --练兵中
            self._ImgMita.gameObject:SetActive(true);
        elseif armyState == ArmyState.TransformArrive then
            --调动到达
            self._ImgWalit.gameObject:SetActive(true);
        else
            self._ImgMarch.gameObject:SetActive(true);
        end
    end
end

return ArmyTipStateInfo;