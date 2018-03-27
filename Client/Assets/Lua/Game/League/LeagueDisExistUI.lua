-- region *.lua
-- Date 16/10/13


local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local FacilityType = require("Game/Facility/FacilityType");
local LeagueDisExistUI = class("LeagueDisExistUI", UIBase)
local dataState = require("Game/Table/model/DataState");
local DataBannedWord = require("Game/Table/model/DataBannedWord")
function LeagueDisExistUI:ctor()

    LeagueDisExistUI.super.ctor(self);
    self.startBtn = nil;
    self.LeagueAddBtn = nil;
    self.LeagueInviteBtn = nil;
    self.testText = nil;
    self.LeagueBackBtn = nil;
    self.IntroLeagueBtn = nil;
    self.LeagueNameInputField = nil;
    self.level = nil;
    self.money = nil;
    self._Name = nil;
    self.joincoolingtime = nil;
    self.time = nil;
    self.LeagueAddBtnImage = nil
    self.LeagueInviteBtnImage = nil;
    self.downTimer = nil;
end

----ע���ؼ�
function LeagueDisExistUI:DoDataExchange()
    self.startBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueBackgroundImage/Image/Button")
    self.LeagueAddBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueAdd")
    self.LeagueAddBtnImage = self:RegisterController(UnityEngine.UI.Image, "LeagueAdd/Image")
    self.LeagueInviteBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueInvite")
    self.LeaguePlace = self:RegisterController(UnityEngine.UI.Text, "LeagueBackgroundImage/Image/Text2")
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.LeagueInviteBtnImage = self:RegisterController(UnityEngine.UI.Image, "LeagueInvite/Image")
    self.IntroLeagueBtn = self:RegisterController(UnityEngine.UI.Button, "LeagueBackgroundImage/Image/IntroButton")
    self.LeagueNameInputField = self:RegisterController(UnityEngine.UI.InputField, "LeagueBackgroundImage/Image/InputField")
    self.joincoolingtime = self:RegisterController(UnityEngine.UI.Text, "Time")
    self.TimeIntro = self:RegisterController(UnityEngine.UI.Text, "TimeIntro")
end

-- ע���ؼ������¼�
function LeagueDisExistUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.startBtn, self.OnClickStartBtn)
    self:AddListener(self.LeagueAddBtn, self.OnClickLeagueAddBtn)
    self:AddListener(self.LeagueInviteBtn, self.OnClickLeagueInviteBtn)
    self:AddListener(self.IntroLeagueBtn, self.OnClickIntroLeagueBtn)
    self:AddOnDown(self.LeagueAddBtn, self.AddOnDownLeagueAddBtn)
    self:AddOnUp(self.LeagueAddBtn, self.OnClickUpLeagueAddBtn)
    self:AddOnDown(self.LeagueInviteBtn, self.AddOnDownLeagueInviteBtn)
    self:AddOnUp(self.LeagueInviteBtn, self.OnClickUpLeagueInviteBtn)
end


-- 按钮的亮片
function LeagueDisExistUI:AddOnDownLeagueAddBtn()
    self.LeagueAddBtnImage.gameObject:SetActive(true)
end
function LeagueDisExistUI:OnClickUpLeagueAddBtn()
    self.LeagueAddBtnImage.gameObject:SetActive(false)
end
-- 按钮的亮片
function LeagueDisExistUI:AddOnDownLeagueInviteBtn()
    self.LeagueInviteBtnImage.gameObject:SetActive(true)
end
function LeagueDisExistUI:OnClickUpLeagueInviteBtn()
    self.LeagueInviteBtnImage.gameObject:SetActive(false)
end




function LeagueDisExistUI:OnClickStartBtn()

    self._Name = self.LeagueNameInputField.text;
    self.money = PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Money):GetValue()
    self.level = FacilityService:Instance():GetFacilitylevelByIndex(PlayerService:Instance():GetmainCityId(), FacilityType.MainHouse)

    if CommonService:Instance():LimitText(self._Name) then
        return;
    end
    local _Name = string.gsub(self._Name, "^%s*(.-)%s*$", "%1");

    -- //判断是否有限制字符
    local isRight = true
    GameResFactory.Instance():ChecKkName(_Name, function() end, function()
        isRight = false
    end )
    if isRight == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1208);
        return
    end
    if self._Name == "" then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1008)
        return
    end
    if string.len(self._Name) > 12 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CorrectName)
        return
    end
    if (self.money < 5000) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoMoney)
        return
    end
    if self.time > 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
        return
    end
    if PlayerService:Instance():GetsuperiorLeagueId() ~= 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1004)
        return
    end
    if (self.level < 3) then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 1003)
        return
    end

    LeagueService:Instance():SendCreatLeagueMessage(PlayerService:Instance():GetPlayerId(), self._Name)
end

function LeagueDisExistUI:IsContainSensitiveWords(name)
    for i = 1, 3540 do
        if DataBannedWord[i].ShieldingWords == name then
            return true
        end
    end
    return false
end

function LeagueDisExistUI:OnBeforeDestory()
    if self then
        CommonService:Instance():RemoveAllTimeDownInfoInUI(UIType.LeagueDisExistUI);
    end
end


function LeagueDisExistUI:OnShow(msg)
    self.LeagueNameInputField.text = ""
    self.LeaguePlace.text = dataState[PmapService:Instance():GetStateIDbyIndex(PlayerService:Instance():GetMainCityTiledId())].Name
    if msg ~= nil then

        local localtime = PlayerService:Instance():GetLocalTime()
        local TimeAnt = msg.joinCoolingTime - localtime;
        self.time = TimeAnt
        if TimeAnt > 0 then
            self.joincoolingtime.gameObject:SetActive(true)
            self.TimeIntro.gameObject:SetActive(true)
        else
            self.TimeIntro.gameObject:SetActive(false)
            self.joincoolingtime.gameObject:SetActive(false)
        end
        CommonService:Instance():TimeDown(UIType.LeagueDisExistUI, msg.joinCoolingTime, self.joincoolingtime, function() self:HideText() end)
        self.joincoolingtime.text = self.joincoolingtime.text .. "后可加入同盟"
    end
end

function LeagueDisExistUI:HideText()

    self.joincoolingtime.gameObject:SetActive(false)
    self.TimeIntro.gameObject:SetActive(false)
end


function LeagueDisExistUI:OnClickLeagueBackBtn()
    if UIService:Instance():GetOpenedUI(UIType.UIMainCity) == true then
        UIService:Instance():HideUI(UIType.LeagueDisExistUI)
    else
        UIService:Instance():ShowUI(UIType.UIGameMainView)
        UIService:Instance():HideUI(UIType.LeagueDisExistUI)
    end


end

function LeagueDisExistUI:OnClickLeagueAddBtn()


    LeagueService:Instance():SendAroundLeagueList(PlayerService:Instance():GetPlayerId())

end

function LeagueDisExistUI:OnClickLeagueInviteBtn()

    LeagueService:Instance():SendBeInviteLeague(PlayerService:Instance():GetPlayerId())

end

function LeagueDisExistUI:OnClickIntroLeagueBtn()

    UIService:Instance():ShowUI(UIType.LeagueAttentionUI)

end




return LeagueDisExistUI


-- endregion
