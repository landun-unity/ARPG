-- region *.lua
-- Date16/10/22


local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local ConfirmCancelUI = class("ConfirmCancelUI", UIBase);
local LeagueControlType = require("Game/League/LeagueControlType")
local GreyImage = "TonYonButtonNormal2Grey"
local NomalImage = "TonYonButtonNormal2"
function ConfirmCancelUI:ctor()

    ConfirmCancelUI.super.ctor(self)
    self.ConfirmBtn = nil;
    self.CancelBtn = nil;
    self.Content = nil;
    self._type = nil;
    self.time = nil;
    self.timeText = nil;
    self._target = nil;
    self.intro = nil
end

-- 注册控件
function ConfirmCancelUI:DoDataExchange()
    self.timeText = self:RegisterController(UnityEngine.UI.Text, "timeText")
    self.intro = self:RegisterController(UnityEngine.UI.Text, "Intro")
    self.ConfirmBtn = self:RegisterController(UnityEngine.UI.Button, "Confirm")
    self.ConfirmBtnImage = self:RegisterController(UnityEngine.UI.Image, "Confirm")
    self.CancelBtn = self:RegisterController(UnityEngine.UI.Button, "Cancel")
    self.Content = self:RegisterController(UnityEngine.UI.Text, "Text")
end

-- 监测控件
function ConfirmCancelUI:DoEventAdd()

    self:AddListener(self.ConfirmBtn, self.OnClickConfirmBtn)
    self:AddListener(self.CancelBtn, self.OnClickCancelBtn)


end


function ConfirmCancelUI:OnShow(param)

    if param[1] ~= nil then
        self._type = param[1];
    end
    if param[2] ~= nil then
        self._target = param[2];
    end
    if param[3] ~= nil then
        self.Content.text = param[3]
    end
    if param[4] ~= nil then
        self.time = param[4]
        self.timeText.gameObject:SetActive(true)
        self.intro.gameObject:SetActive(true)
        self.Content.gameObject:SetActive(false)
        self.ConfirmBtnImage.sprite = GameResFactory.Instance():GetResSprite(GreyImage);
        CommonService:Instance():TimeDown(UIType.ConfirmCancelUI, self.time, self.timeText, function()
            self.timeText.gameObject:SetActive(false)
            self.intro.gameObject:SetActive(false)
            self.Content.gameObject:SetActive(true)
            self.ConfirmBtnImage.sprite = GameResFactory.Instance():GetResSprite(NomalImage);
        end )
    else
        self.Content.gameObject:SetActive(true)
        self.intro.gameObject:SetActive(false)
        self.timeText.gameObject:SetActive(false)
        self.ConfirmBtnImage.sprite = GameResFactory.Instance():GetResSprite(NomalImage);
    end
end

-- 点击事件
function ConfirmCancelUI:OnClickConfirmBtn()

    if self.Content.gameObject.activeSelf == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
        return
    end


    if self._type == LeagueControlType.RecellOfficer then
        LeagueService:Instance():SendReCallOfficeMsg(PlayerService:Instance():GetPlayerId(), self._target)
    end

    if self._type == LeagueControlType.RemoveMember then
        LeagueService:Instance():SendKickMemberMsg(PlayerService:Instance():GetPlayerId(), self._target)
    end

    if self._type == LeagueControlType.Demise then
        if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
            LeagueService:Instance():SendCancelDemise(PlayerService:Instance():GetPlayerId(), self._target);
        else

            LeagueService:Instance():SendApplyDemiseMsg(PlayerService:Instance():GetPlayerId(), self._target);
        end

    end

    UIService:Instance():HideUI(UIType.ConfirmCancelUI)
end

function ConfirmCancelUI:OnClickCancelBtn()

    UIService:Instance():HideUI(UIType.ConfirmCancelUI)

end
-- endregion


return ConfirmCancelUI