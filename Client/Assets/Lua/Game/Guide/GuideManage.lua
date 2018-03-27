--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local GuideUiType = require("Game/Guide/GuideUiType");
local GuideType = require("Game/Guide/GuideType");

local GamePart = require("FrameWork/Game/GamePart");
local GuideManage = class("GuideManage", GamePart);

require("Game/Table/model/DataGuide");

-- 构造函数
function GuideManage:ctor()
    GuideManage.super.ctor(self);
    -- 服务器进度 仅在刚进入游戏时更新获取 对应guide表save字段 用于中断重进
    self._totalStep = 0;
    -- 是已经进入游戏根据服务器进度初始化客户端进度
    self._isInitStep = false;
    -- 每一小步进度 对应guide表
    self._currentStep = 0;
    -- 最大服务器保存步骤
    self._MAX_SERVICE_STEP = 16;
    -- 新手引导是否完成
    self._isGuideComplete = false;
    -- 首次进入游戏特殊处理 不考虑当前步骤 直接进入下一步
    self._isFirstGuide = true;
end

-- 初始化
function GuideManage:_OnInit()
	
end

function GuideManage:SetTotalStep(step)
    self._totalStep = step;
end

function GuideManage:GetCurrentStep()
    return self._currentStep;
end

function GuideManage:SetCurrentStep(curStep)
    self._currentStep = curStep;
end

-- 获取新手引导是否结束
function GuideManage:GetIsFinishGuide()
    return self._isGuideComplete;
end

-- 判断新手引导是否结束
function GuideManage:JudgeIsFinishGuide()
    if self._currentStep == 0 then
        self._isGuideComplete = false;
        return false;
    end

    local curData = DataGuide[self._currentStep];
    if curData == nil then
        self._isGuideComplete = true;
        return true;
    end

    if curData.NextStep == 0 then
        self._isGuideComplete = true;
        return true;
    else
        self._isGuideComplete = false;
        return false;
    end
end

-- 同步新手引导进度
function GuideManage:SyncGuide(msg)
    self:GoToNextStep();
end

-- 当前步骤点击完的处理 特定步骤服务器回消息或打开固定页面开启下一步  其余点击即可开启下一步
function GuideManage:GoToNextStep(go)
    -- 登陆游戏初始化进度
    self:GetStartStep();

    if self:GetIsFinishGuide() == true then
        return;
    end

    -- 首次进入游戏 不是进入下一步骤 而是进入当前步骤 不需要+1处理 只需要加载当前步骤界面
    if self._isFirstGuide == true then
        self:HandleCurrentStep();
        self._isFirstGuide = false;
        return;
    end

    -- 断线重连界面出现时候的判定
    local oldData = DataGuide[self._currentStep];
    if oldData == nil  then
        return;
    end
    if oldData.Type == GuideUiType.OperateOneAreaToNext and oldData.ClickCanvas == 1 and oldData.ClickToNext == 1 then
        if UIService:Instance():GetOpenedUI(UIType.UIDisConnect) == true then
            return;
        end
    end

    --点击地图主城或地块的特殊处理（不包括点击地图出现的ui菜单）
    self:ClickMapPanelDone();
    -- 首次出征立即返回特殊处理
    self:FirstFightSpecial();
    -- 存服务器特殊步骤处理
    self:RequestServerStep();

    if self._currentStep > 0 then
        local oldData = DataGuide[self._currentStep];
        if oldData == nil  then
            return;
        end
        
        if oldData.JudgeClickGo == 1 then
            if go == nil or go.name ~= oldData.NeedClickGoName then
                return;
            end
        end
        
        local oldType = oldData.Type;
        if oldType == GuideUiType.ClickAllScreenToNext then
            UIService:Instance():HideUI(UIType.UIGuideAllScreenClick);
        elseif oldType == GuideUiType.WaitToNext then
            UIService:Instance():HideUI(UIType.UIGuideAllScreenNoClick);
        elseif oldType == GuideUiType.OperateOneAreaToNext then
            UIService:Instance():HideUI(UIType.UIGuideOneAreaClick);
        end
    end
    
    if self._currentStep > 0 then
        if self:JudgeIsFinishGuide() == true then
            LoginActService:Instance():InitRequest();
            return;
        else
            self._currentStep = DataGuide[self._currentStep].NextStep;
        end
    else
        self._currentStep = 1;
    end

    self:HandleCurrentStep();
end

-- 两次出征立即返回特殊处理
function GuideManage:FirstFightSpecial()
    if self._currentStep == 19 or self._currentStep == 55 then
        local mainCityTiledId = PlayerService:Instance():GetMainCityTiledId();
        local mainCityId = BuildingService:Instance():GetBuildingByTiledId(mainCityTiledId)._id;
        local firstArmyInfo = ArmyService:Instance():GetArmyInCity(mainCityId, 1);
        if firstArmyInfo ~= nil and firstArmyInfo:GetArmyState() == ArmyState.Back then
            local msg = require("MessageCommon/Msg/C2L/Army/ArmyRetreatingImmediately").new();
            msg:SetMessageId(C2L_Army.ArmyRetreatingImmediately);
            msg.buildingId = mainCityId;
            msg.index = 0;
            NetService:Instance():SendMessage(msg);
        end
    end
end

-- 存服务器特殊步骤处理
function GuideManage:RequestServerStep()
    local curStep = GuideType.None;

    if self._currentStep == 2 then
        curStep = GuideType.GetFirstCard;
    elseif self._currentStep == 26 then
        curStep = GuideType.GetSecondCard;
    elseif self._currentStep == 54 then
        curStep = GuideType.GetNewerCardPacket;
    end

    if curStep ~= GuideType.None then
        local msg = require("MessageCommon/Msg/C2L/Player/RequestSaveGuideStep").new();
        msg:SetMessageId(C2L_Player.RequestSaveGuideStep);
        msg.guideStep = curStep;
        NetService:Instance():SendMessage(msg, false);
    end
end

--点击地图主城或地块的特殊处理（不包括点击地图出现的ui菜单）
function GuideManage:ClickMapPanelDone()
    if self._currentStep == 4 or self._currentStep == 27 or self._currentStep == 34 or self._currentStep == 61 or self._currentStep == 67 or self._currentStep == 74 or self._currentStep == 82 then
        local tiledIndex = PlayerService:Instance():GetMainCityTiledId();
        local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
        local tiledPos = MapService:Instance():GetTiledPositionByIndex(tiledIndex);
        ClickService:Instance():ShowTiled(tiled, tiledPos);
    elseif self._currentStep == 14 then
        local mainTiledIndex = PlayerService:Instance():GetMainCityTiledId();
        local x, y = MapService:Instance():GetTiledCoordinate(mainTiledIndex);
        local tiledIndex = MapService:Instance():GetTiledIndex(x + 2, y);
        local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
        local tiledPos = MapService:Instance():GetTiledPositionByIndex(tiledIndex);
        ClickService:Instance():ShowTiled(tiled, tiledPos);
    elseif self._currentStep == 48 then
        local mainTiledIndex = PlayerService:Instance():GetMainCityTiledId();
        local x, y = MapService:Instance():GetTiledCoordinate(mainTiledIndex);
        local tiledIndex = MapService:Instance():GetTiledIndex(x + 2, y - 1);
        local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
        local tiledPos = MapService:Instance():GetTiledPositionByIndex(tiledIndex);
        ClickService:Instance():ShowTiled(tiled, tiledPos);
    end
end


-- 当前步骤处理
function GuideManage:HandleCurrentStep()
    local currentData = DataGuide[self._currentStep];
    if currentData == nil then
        return;
    end

    local currentType = currentData.Type;
    if currentType == GuideUiType.ClickAllScreenToNext then
        UIService:Instance():ShowUI(UIType.UIGuideAllScreenClick);
    elseif currentType == GuideUiType.WaitToNext then
        UIService:Instance():ShowUI(UIType.UIGuideAllScreenNoClick);
    elseif currentType == GuideUiType.OperateOneAreaToNext then
        UIService:Instance():ShowUI(UIType.UIGuideOneAreaClick);
    end
end

-- 刚进游戏初始化客户端当前步骤
function GuideManage:GetStartStep()
    if self._isInitStep == true then
        return;
    end
    self._isInitStep = true;
    LogManager:Instance():Log("新手引导进度为：" .. self._totalStep);
    if self._totalStep >= self._MAX_SERVICE_STEP then
        LoginActService:Instance():InitRequest();
        self._isGuideComplete = true;
        return;
    else
        self._isGuideComplete = false;
    end

    if self._totalStep == 0 then
        self._currentStep = 1;
    else
        for k,v in pairs(DataGuide) do
            if v.SaveNum == self._totalStep then
                self._currentStep = v.NextNum;
                return;
            end
        end
    end
end

function GuideManage:JumpGuide()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestJumpGuide").new();
    msg:SetMessageId(C2L_Player.RequestJumpGuide);
    NetService:Instance():SendMessage(msg);

    UIService:Instance():HideUI(UIType.UIGuideAllScreenClick);
    UIService:Instance():HideUI(UIType.UIGuideAllScreenNoClick);
    UIService:Instance():HideUI(UIType.UIGuideOneAreaClick);
    self._isGuideComplete = true;
    LoginActService:Instance():InitRequest();
end

return GuideManage;

--endregion
