--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local PlayerInformationUI = class("PlayerInformationUI",UIBase)
local MailWriteUI =  require("Game/Mail/MailWriteUI");

function PlayerInformationUI:ctor()
    
    PlayerInformationUI.super.ctor(self)

    self.exitBtn = nil;
    self.exitBgBtn = nil;
    self.addBlackPeopleBtn = nil;    
    self.addLinkPeopleBtn = nil;
    self.sendMailBtn = nil;
    self.backgroundImage = nil;
    self.playerNameText = nil;
    self.playerPowerValueText = nil;
    self.lastSeasonRanking = nil;
    self.leagueInformationObj = nil;
    self.leagueBtn = nil;
    self.leagueNameText = nil;
    self.leagueJobPositionText = nil;
    self.leagueGroupInfoObj = nil;
    self.leagueGroupText = nil;
    self.personalIntroduceText = nil;
    self.haveNoIntroduceText = nil;

    self.bgNormalPositionY = 118;
    self.bgAddOneNormalPositionY = 46;
    self.playerInfo = nil;

    self._personalIntroPanel = nil;

    -- 上级盟信息
    self._superLeaguePanel = nil;
    self._superLeagueName = nil;
    self.LeagueBtn1 = nil;

    self.superLeagueIds = nil;
end


function PlayerInformationUI:DoDataExchange()
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/BottomBlueImage/ExitButton");
    self.exitBgBtn = self:RegisterController(UnityEngine.UI.Button,"Panel");
    self.addBlackPeopleBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/AddBlackPeopleBtn");
    self.addLinkPeopleBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/AddLinkPeopleBtn");
    self.sendMailBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/SendMailBtn");
    self.backgroundImage = self:RegisterController(UnityEngine.RectTransform,"BackgroundImage");
    self.playerNameText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/PersonalInformation/PersonName");
    self.playerPowerValueText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/PersonalInformation/PersonPowerValue");
    self.lastSeasonRanking = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/PersonalInformation/LastSeasonRanking");
    self.leagueInformationObj = self:RegisterController(UnityEngine.RectTransform,"BackgroundImage/Grid/LeagueInformation");
    self.leagueBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/Grid/LeagueInformation/LeagueBtn");
    self.leagueNameText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/LeagueInformation/LeagueBtn/LeagueNameText");
    self.leagueJobPositionText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/LeagueInformation/LeagueJobPosition");
    self.leagueGroupInfoObj = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/LeagueGroupInfo");
    self.leagueGroupText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/LeagueGroupInfo/LeagueGroupText");
    self.personalIntroduceText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/Personal/PersonalIntroduce/PersonalIntroduceText");
    self.haveNoIntroduceText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/Personal/PersonalIntroduce/NoIntroduceText");
    self._superLeagueName = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/Grid/LeagueUp/LeagueBtn1/LeagueNameText1");
    self._superLeaguePanel = self:RegisterController(UnityEngine.RectTransform,"BackgroundImage/Grid/LeagueUp");
    self._personalIntroPanel = self:RegisterController(UnityEngine.RectTransform,"BackgroundImage/Grid/Personal/PersonalIntroduce");
    self.LeagueBtn1 = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/Grid/LeagueUp/LeagueBtn1")
end

function PlayerInformationUI:DoEventAdd()
    self:AddOnClick(self.exitBtn,self.OnCilckExitBtn);
    self:AddOnClick(self.exitBgBtn,self.OnCilckExitBtn);
    self:AddOnClick(self.addBlackPeopleBtn,self.OnCilckBlackPeopleBtn);
    self:AddOnClick(self.addLinkPeopleBtn,self.OnCilckLinkPeopleBtn);
    self:AddOnClick(self.sendMailBtn,self.OnCilckSendMailBtn);
    self:AddOnClick(self.leagueBtn,self.OnCilckLeagueBtn);
    self:AddOnClick(self.LeagueBtn1, self.OnClickLeagueBtn1)
end

-- info: ResponseOtherPlayerBaseInfo
function PlayerInformationUI:OnShow(info)
    self.playerInfo = info;
    self.playerNameText.text = info.playerName;
    self.playerPowerValueText.text = "势力值："..info.powerValue;
    if info.leagueId ~= 0 then
        self.leagueBtn.interactable = true;
        self.leagueNameText.text = info.leagueName;
        if info.leagueJobPosition ~= 5 then
            self.leagueJobPositionText.gameObject:SetActive(true);
            self.leagueJobPositionText.text = self:GetLeaguePositionString(info.leagueJobPosition);
        else
            self.leagueJobPositionText.gameObject:SetActive(false);
        end
    else
        self.leagueBtn.interactable = false;
        self.leagueNameText.text = "[在野]";
        self.leagueJobPositionText.gameObject:SetActive(false);
    end
    if info.playerIntroduce ~= "" then
        self.personalIntroduceText.gameObject:SetActive(true);
        self.haveNoIntroduceText.gameObject:SetActive(false);
         self.personalIntroduceText.text = info.playerIntroduce;
    else
        self.personalIntroduceText.gameObject:SetActive(false);
        self.haveNoIntroduceText.gameObject:SetActive(true);
    end
    -- 显示上级盟信息
    self:ShowSuperLeagueInformation(info.superiorLeagueId, info.superiorLeagueName)
    self.superLeagueIds = info.superiorLeagueId
end

-- 显示上级盟信息
function PlayerInformationUI:ShowSuperLeagueInformation(superLeagueId, superLeagueName)
    if superLeagueId > 0 then
        self._superLeaguePanel.gameObject:SetActive(true)
        self._personalIntroPanel.sizeDelta = Vector2.New(self._personalIntroPanel.sizeDelta.x,120)
        self._superLeagueName.text = superLeagueName
    else
        self._superLeaguePanel.gameObject:SetActive(false)
        self._personalIntroPanel.sizeDelta = Vector2.New(self._personalIntroPanel.sizeDelta.x,170)
    end
end

--点击玩家的同盟名字按钮
function PlayerInformationUI:OnCilckLeagueBtn()
    if self.playerInfo.leagueId ~= 0 then
        LeagueService:Instance():SendOpenAppiontLeague(0,self.playerInfo.leagueId);
        UIService:Instance():HideUI(UIType.PlayerInformationUI);
        UIService:Instance():HideUI(UIType.LeagueMemberUI);
    end
end

--点击加入黑名单
function PlayerInformationUI:OnCilckBlackPeopleBtn()
    
end

--点击加入联系人
function PlayerInformationUI:OnCilckLinkPeopleBtn()
    
end

function PlayerInformationUI:OnClickLeagueBtn1()
    LeagueService:Instance():SendOpenAppiontLeague(1,self.superLeagueIds)
    UIService:Instance():HideUI(UIType.PlayerInformationUI)
end


--点击发送邮件
function PlayerInformationUI:OnCilckSendMailBtn()    
    UIService:Instance():ShowUI(UIType.MailWriteUI,true);
    MailWriteUI:Instance():SetPersonalReceiveInfo(self.playerInfo.playerName);
end

--关闭界面
function PlayerInformationUI:OnCilckExitBtn()
    UIService:Instance():HideUI(UIType.PlayerInformationUI);
end

function PlayerInformationUI:GetLeaguePositionString(position)
    if position == LeagueTitleType.Leader then
        return "盟主";
    elseif position == LeagueTitleType.ViceLeader then
        return "副盟主";
    elseif position == LeagueTitleType.Command then
        return "指挥官";
    elseif position == LeagueTitleType.Officer then
        return "官员";
    elseif position == LeagueTitleType.Nomal then
        return "成员";
    end
    return "";
end

return PlayerInformationUI
