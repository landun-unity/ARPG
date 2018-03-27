--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

local UIBase = require("Game/UI/UIBase");
local UINewerPeriod = class("UINewerPeriod", UIBase);

require("Game/Table/model/DataText")

-- 构造函数
function UINewerPeriod:ctor()
    UINewerPeriod.super.ctor(self);
    self._backBg = nil;
    self._closeBtn = nil;
    self._mitaText = nil;
    self._mitaNeedText = nil;
    self._trainText = nil;
    self._trainNeedText = nil;
    self._garrisonText = nil;
    self._garrisonNeedText = nil;
    self._timeText = nil;
    self._openExplaneBtn = nil;
    self._explanePanel = nil;
    self._closeExplaneBtn = nil;
end

-- 控件查找
function UINewerPeriod:DoDataExchange(args)
    self._backBg = self:RegisterController(UnityEngine.UI.Image, "blackBG");
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "Content/closeBtn");
    self._mitaText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/MitaText");
    self._mitaNeedText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/MitaTextNeed");
    self._trainText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/TrainText");
    self._trainNeedText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/TrainTextNeed");
    self._garrisonText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/GarrisonText");
    self._garrisonNeedText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/GarrisonTextNeed");
    self._timeText = self:RegisterController(UnityEngine.UI.Text, "Content/DetailContent/TimeText");
    self._openExplaneBtn = self:RegisterController(UnityEngine.UI.Button, "Content/ExplainBtn");
    self._explanePanel = self:RegisterController(UnityEngine.UI.Button, "ExplainPanel");
    self._closeExplaneBtn = self:RegisterController(UnityEngine.UI.Button, "ExplainPanel/bg/ConfirmBtn");
end

-- 控件事件添加
function UINewerPeriod:DoEventAdd()
    self:AddOnClick(self._backBg, self.OnCloseBtn);
    self:AddListener(self._closeBtn, self.OnCloseBtn);
    self:AddListener(self._openExplaneBtn, self.OnOpenExplanePanel);
    self:AddListener(self._explanePanel, self.OnCloseExplanePanel);
    self:AddListener(self._closeExplaneBtn, self.OnCloseExplanePanel);
end

-- 注册所有的通知
function UINewerPeriod:RegisterAllNotice()
    self:RegisterNotice(L2C_Player.SyncNewerPeriod, self.RefreshUI);
end

-- 当界面显示的时候调用
function UINewerPeriod:OnShow(param)
    self:RefreshUI();
    self:RefreshTime();
    self:OnCloseExplanePanel();
end

-- 心跳
function UINewerPeriod:_OnHeartBeat()
    self:RefreshTime();
end

function UINewerPeriod:RefreshUI()
    if self.gameObject.activeSelf == false then
        return;
    end

    if NewerPeriodService:Instance():IsNewerPeriodEnd() == true then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 7103);
        self:OnCloseBtn();
    end

    if NewerPeriodService:Instance():CanMita() == true then
        self._mitaText.text = "<color=#ffffff>" .. DataText[7100].TextContent .. "</color>";
        if self._mitaNeedText.gameObject.activeSelf == true then
            self._mitaNeedText.gameObject:SetActive(false);
        end
    else
        self._mitaText.text = "<color=#7f7f7f>" .. DataText[7100].TextContent .. "</color>";
        if self._mitaNeedText.gameObject.activeSelf == false then
            self._mitaNeedText.gameObject:SetActive(true);
        end
    end
    if NewerPeriodService:Instance():CanTrain() == true then
        self._trainText.text = "<color=#ffffff>" .. DataText[7101].TextContent .. "</color>";
        if self._trainNeedText.gameObject.activeSelf == true then
            self._trainNeedText.gameObject:SetActive(false);
        end
    else
        self._trainText.text = "<color=#7f7f7f>" .. DataText[7101].TextContent .. "</color>";
        if self._trainNeedText.gameObject.activeSelf == false then
            self._trainNeedText.gameObject:SetActive(true);
        end
    end
    if NewerPeriodService:Instance():CanGarrison() == true then
        self._garrisonText.text = "<color=#ffffff>" .. DataText[7102].TextContent .. "</color>";
        if self._garrisonNeedText.gameObject.activeSelf == true then
            self._garrisonNeedText.gameObject:SetActive(false);
        end
    else
        self._garrisonText.text = "<color=#7f7f7f>" .. DataText[7102].TextContent .. "</color>";
        if self._garrisonNeedText.gameObject.activeSelf == false then
            self._garrisonNeedText.gameObject:SetActive(true);
        end
    end
end

function UINewerPeriod:RefreshTime()
    if self.gameObject.activeSelf == false then
        return;
    end

    if NewerPeriodService:Instance():IsInNewerPeriod() == true then
        if self._timeText.gameObject.activeSelf == false then
            self._timeText.gameObject:SetActive(true);
        end
        local curTime = PlayerService:Instance():GetLocalTime();
        local endTime = NewerPeriodService:Instance():GetEndTime();
        local cdTime = endTime - curTime;
        if cdTime < 0 then
            if self._timeText.gameObject.activeSelf == true then
                self._timeText.gameObject:SetActive(false);
            end
        else
            self._timeText.text = "<color=#AA5252>" .. CommonService:Instance():GetDateString(math.floor(cdTime / 1000)) .. "后效果消失" .. "</color>";
        end
    else
        if self._timeText.gameObject.activeSelf == true then
            self._timeText.gameObject:SetActive(false);
        end
    end
end

function UINewerPeriod:OnOpenExplanePanel()
    if self._explanePanel.gameObject.activeSelf == false then
        self._explanePanel.gameObject:SetActive(true);
    end
end

function UINewerPeriod:OnCloseExplanePanel()
    if self._explanePanel.gameObject.activeSelf == true then
        self._explanePanel.gameObject:SetActive(false);
    end
end

-- 关闭界面
function UINewerPeriod:OnCloseBtn()
    UIService:Instance():HideUI(UIType.UINewerPeriod);
end

return UINewerPeriod;

--endregion
