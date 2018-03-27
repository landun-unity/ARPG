-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")
local LeagueControlType = require("Game/League/LeagueControlType")
local LeaderOtherPowerUI = class("LeaderOtherPowerUI", UIBase)

function LeaderOtherPowerUI:ctor()

    LeaderOtherPowerUI.super.ctor(self)
    self.LeagueBackBtn = nil;
    self.AppiontBtn = nil;
    self.AppiontChifeBtn = nil;
    self.DissolveBtn = nil;
    self.GiveUpBtn = nil;
    self.targetId = nil;
    self.chiefId = nil;
    self.time = nil;
    self.state = nil;
    self.targetName = nil;
    self.AppiontChifeImage =nil;
end


-- ע���ؼ�
function LeaderOtherPowerUI:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.AppiontBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontOffice")
    self.AppiontChifeBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontCityLeader")
    self.DissolveBtn = self:RegisterController(UnityEngine.UI.Button, "DissolveMember")
    self.GiveUpBtn = self:RegisterController(UnityEngine.UI.Button, "GiveUpLeader")
    self.time = self:RegisterController(UnityEngine.UI.Text, "GiveUptime")
    self.state = self:RegisterController(UnityEngine.UI.Text, "GiveUpLeader/Text")
    self.AppiontChifeImage =self:RegisterController(UnityEngine.UI.Image, "AppiontCityLeader")
end

-- ע�������¼�
function LeaderOtherPowerUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.AppiontBtn, self.OnClickAppiontBtn)
    self:AddListener(self.AppiontChifeBtn, self.OnClickAppiontChifeBtn)
    self:AddListener(self.DissolveBtn, self.OnClickDissolveBtn)
    self:AddListener(self.GiveUpBtn, self.OnClickGiveUpBtn)

end



function LeaderOtherPowerUI:OnShow(Param)
    if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
        self.time.gameObject:SetActive(true)
        local quitime = LeagueService:Instance():GetNextDemiseTime() - PlayerService:Instance():GetLocalTime()
        CommonService:Instance():TimeDown(UIType.LeaderOtherPowerUI, LeagueService:Instance():GetNextDemiseTime(), self.time, function() self:TimeOver() end);
    else
        self.time.gameObject:SetActive(false)
    end
    if Param[1] ~= nil then
        self.targetId = Param[1];
    end
    if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
        if LeagueService:Instance():getBeDimsePlayerID() == self.targetId then
            self.time.gameObject:SetActive(true)
            self.state.text = "取消禅让"
        else
            self.time.gameObject:SetActive(false)
            self.GiveUpBtn.gameObject:SetActive(false)
        end
    else
        self.state.text = "禅让盟主"
    end
    if Param[2] ~= nil then
        self.targetName = Param[2];
    end

    GameResFactory.Instance():LoadMaterial(self.AppiontChifeImage, "Shader/HeroCardGray")
end


function LeaderOtherPowerUI:TimeOver()
    LeagueService:Instance():SendLeagueMemberMessage()
end


function LeaderOtherPowerUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
end

function LeaderOtherPowerUI:OnClickAppiontBtn()

    UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
    UIService:Instance():ShowUI(UIType.LeagueOfficePosUI, self.targetId)

end

function LeaderOtherPowerUI:OnClickAppiontChifeBtn()
    UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
end

function LeaderOtherPowerUI:OnClickDissolveBtn()
    UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
    local str = "是否将" .. self.targetName .. "移出同盟"
    local data = { LeagueControlType.RemoveMember, self.targetId, str }
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)
end

function LeaderOtherPowerUI:OnClickGiveUpBtn()
    if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
        LeagueService:Instance():SendCancelDemise(PlayerService:Instance():GetPlayerId(), self.targetId);
        UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
        return
    end
    UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
    local str = "是否将盟主禅让于" .. self.targetName .. ""
    local data = { LeagueControlType.Demise, self.targetId, str }
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)

end


return LeaderOtherPowerUI
-- endregion
