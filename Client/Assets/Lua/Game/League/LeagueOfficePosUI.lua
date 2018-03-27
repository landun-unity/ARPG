-- region *.lua
-- Date

local UIBase = require("Game/UI/UIBase")
local LeagueTitleType = require("Game/League/LeagueTitleType")
local UIService = require("Game/UI/UIService")
local LeagueOfficePosUI = class("LeagueOfficePosUI", UIBase)
local DataAlliesLevel = require("Game/Table/model/DataAlliesLevel")
function LeagueOfficePosUI:ctor()

    LeagueOfficePosUI.super.ctor(self);
    self.title = nil;
    self.targetId = nil;
    self.officerBtn = nil;
    self.commderBtn = nil;
    self.SleaderBtn = nil;
    self.LeagueBackBtn = nil;
    self.appiontTitle = 0;
    self.confirm = nil;
    self.vicerNum = nil;
    self.commderNum = nil;
    self.officerNum = nil;
    self.vicer = 0;
    self.commder = 0;
    self.officer = 0;
    self.Image1 = nil;
    self.Image2 = nil;
    self.Image3 = nil;

end



-- 注册控件
function LeagueOfficePosUI:DoDataExchange()
    self.vicerNum = self:RegisterController(UnityEngine.UI.Text, "Button/Text1")
    self.commderNum = self:RegisterController(UnityEngine.UI.Text, "Button2/Text1")
    self.officerNum = self:RegisterController(UnityEngine.UI.Text, "Button3/Text1")
    self.confirm = self:RegisterController(UnityEngine.UI.Button, "BackImage/BackgroundImage/confirm")
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.officerBtn = self:RegisterController(UnityEngine.UI.Button, "Button3")
    self.commderBtn = self:RegisterController(UnityEngine.UI.Button, "Button2")
    self.SleaderBtn = self:RegisterController(UnityEngine.UI.Button, "Button")
    self.intro = self:RegisterController(UnityEngine.UI.Button, "BackImage/Image5")
    self.Image1 = self:RegisterController(UnityEngine.UI.Image, "Button/Image")
    self.Image2 = self:RegisterController(UnityEngine.UI.Image, "Button2/Image")
    self.Image3 = self:RegisterController(UnityEngine.UI.Image, "Button3/Image")
end

-- 注册点击事件
function LeagueOfficePosUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.officerBtn, self.OnClickofficerBtn)
    self:AddListener(self.commderBtn, self.OnClickcommderBtn)
    self:AddListener(self.SleaderBtn, self.OnClickSleaderBtn)
    self:AddListener(self.confirm, self.OnClickconfirmBtn)
    self:AddListener(self.intro, self.OnClickintroBtn)
end

function LeagueOfficePosUI:OnShow(param)
    self:SetTitleNum()
    self.targetId = param;
    self.appiontTitle = LeagueTitleType.ViceLeader;
    self.vicerNum.text = self.vicer .. "/" .. DataAlliesLevel[LeagueService:Instance():GetLeagueInfo().level].VPLimit
    self.commderNum.text = self.commder .. "/" .. DataAlliesLevel[LeagueService:Instance():GetLeagueInfo().level].CommanderLimit
    self.officerNum.text = self.officer .. "/" .. DataAlliesLevel[LeagueService:Instance():GetLeagueInfo().level].OfficeHolderLimit
end


function LeagueOfficePosUI:SetTitleNum()
    self.vicer = 0;
    self.commder = 0;
    self.officer = 0;
    for k, v in pairs(LeagueService:Instance():GetLeagueMemberList()._list) do
        if v.title == LeagueTitleType.ViceLeader then
            self.vicer = self.vicer + 1
        end
        if v.title == LeagueTitleType.Command then
            self.commder = self.commder + 1
        end
        if v.title == LeagueTitleType.Officer then
            self.officer = self.officer + 1
        end
    end

end


function LeagueOfficePosUI:OnClickintroBtn()
    self.temp = { };
    self.temp[1] = "说明"
    self.temp[2] = "ssssssssssssssssssssssssssssssssssssssssssssssssss。";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall, self.temp)
end

function LeagueOfficePosUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeagueOfficePosUI)

end

function LeagueOfficePosUI:OnClickofficerBtn()

    self.appiontTitle = LeagueTitleType.Officer;
    self.Image1.gameObject:SetActive(false)
    self.Image2.gameObject:SetActive(false)
    self.Image3.gameObject:SetActive(true)
end

function LeagueOfficePosUI:OnClickcommderBtn()

    self.appiontTitle = LeagueTitleType.Command;
    self.Image1.gameObject:SetActive(false)
    self.Image2.gameObject:SetActive(true)
    self.Image3.gameObject:SetActive(false)
end

function LeagueOfficePosUI:OnClickSleaderBtn()

    self.appiontTitle = LeagueTitleType.ViceLeader;
    self.Image1.gameObject:SetActive(true)
    self.Image2.gameObject:SetActive(false)
    self.Image3.gameObject:SetActive(false)
end

function LeagueOfficePosUI:OnClickconfirmBtn()
    if self.appiontTitle == LeagueTitleType.Officer then
        if self.officer == DataAlliesLevel[LeagueService:Instance():GetLeagueInfo().level].OfficeHolderLimit then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1006)
            return
        end
    end
    if self.appiontTitle == LeagueTitleType.Command then
        if self.commder == DataAlliesLevel[LeagueService:Instance():GetLeagueInfo().level].CommanderLimit then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1006)
            return
        end
    end
    if self.appiontTitle == LeagueTitleType.ViceLeader then
        if self.vicer == DataAlliesLevel[LeagueService:Instance():GetLeagueInfo().level].VPLimit then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1006)
            return
        end
    end
    LeagueService:Instance():SendAppiontOfficerMsg(PlayerService:Instance():GetPlayerId(), self.targetId, self.appiontTitle)
    UIService:Instance():HideUI(UIType.LeagueOfficePosUI)
end


return LeagueOfficePosUI
-- endregion
