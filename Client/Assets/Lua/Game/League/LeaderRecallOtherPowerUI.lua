-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成


local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")
local LeagueControlType = require("Game/League/LeagueControlType")
local LeaderRecallOtherPowerUI = class("LeaderRecallOtherPowerUI", UIBase)

function LeaderRecallOtherPowerUI:ctor()

    LeaderRecallOtherPowerUI.super.ctor(self)
    self.LeagueBackBtn = nil;
    self.AppiontBtn = nil;
    self.AppiontChifeBtn = nil;
    self.DissolveBtn = nil;
    self.GiveUpBtn = nil;
    self.targetId = nil;
    self.chiefId = nil;
    self.state = nil;
    self.quitimer = nil;
    self.AppiontChifeImage =nil;
    self.name = nil;
    self.nexttime = nil;
end


-- 注册控件
function LeaderRecallOtherPowerUI:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.AppiontBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontOffice")
    self.AppiontChifeBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontCityLeader")
    self.DissolveBtn = self:RegisterController(UnityEngine.UI.Button, "DissolveMember")
    self.GiveUpBtn = self:RegisterController(UnityEngine.UI.Button, "GiveUpLeader")
    self.state = self:RegisterController(UnityEngine.UI.Text, "GiveUpLeader/Text")
    self.AppiontChifeImage =self:RegisterController(UnityEngine.UI.Image, "AppiontCityLeader")

end

-- 注册点击事件
function LeaderRecallOtherPowerUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.AppiontBtn, self.OnClickAppiontBtn)
    self:AddListener(self.AppiontChifeBtn, self.OnClickAppiontChifeBtn)
    self:AddListener(self.DissolveBtn, self.OnClickDissolveBtn)
    self:AddListener(self.GiveUpBtn, self.OnClickGiveUpBtn)

end



function LeaderRecallOtherPowerUI:OnShow(Param)

    if Param ~= nil then
        self.targetId = Param[1];
        self.name = Param[2]
        self.nexttime = Param[3]
    end

    if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
        if LeagueService:Instance():getBeDimsePlayerID() == self.targetId then
            self.state.text = "取消禅让"
        else
            self.GiveUpBtn.gameObject:SetActive(false)
        end
    else
        self.state.text = "禅让盟主"
    end

    if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
        local quitime = LeagueService:Instance():GetNextDemiseTime() - PlayerService:Instance():GetLocalTime()
        CommonService:Instance():TimeDown(UIType.LeaderRecallOtherPowerUI, LeagueService:Instance():GetNextDemiseTime(), self.time, function() self:TimeOver() end);
    end
    GameResFactory.Instance():LoadMaterial(self.AppiontChifeImage, "Shader/HeroCardGray")
end

-- 计时结束
function LeaderRecallOtherPowerUI:TimeOver()
    LeagueService:Instance():SendLeagueMemberMessage()
end


-- 点击按钮逻辑
function LeaderRecallOtherPowerUI:OnClickLeagueBackBtn()
    UIService:Instance():HideUI(UIType.LeaderRecallOtherPowerUI)
end

function LeaderRecallOtherPowerUI:OnClickAppiontBtn()
    UIService:Instance():HideUI(UIType.LeaderRecallOtherPowerUI)
    local str = "是否罢免" .. self.name .. "的职位"
    local data = { LeagueControlType.RecellOfficer, self.targetId, str, self.nexttime }
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)
end

function LeaderRecallOtherPowerUI:OnClickAppiontChifeBtn()
    UIService:Instance():HideUI(UIType.LeaderRecallOtherPowerUI)
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI);
end

function LeaderRecallOtherPowerUI:OnClickDissolveBtn()
    UIService:Instance():HideUI(UIType.LeaderRecallOtherPowerUI)
    local str = "是否将" .. self.name .. "移出同盟"
    local data = { LeagueControlType.RemoveMember, self.targetId, str }
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)
end

function LeaderRecallOtherPowerUI:OnClickGiveUpBtn()
    UIService:Instance():HideUI(UIType.LeaderRecallOtherPowerUI)
    if LeagueService:Instance():GetNextDemiseTime() ~= 0 then
        LeagueService:Instance():SendCancelDemise(PlayerService:Instance():GetPlayerId(), self.targetId);
        UIService:Instance():HideUI(UIType.LeaderOtherPowerUI)
        return
    else
        local str = "是否将盟主禅让于" .. self.name .. ""
        local data = { LeagueControlType.Demise, self.targetId, str }
        UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)
    end

end

return LeaderRecallOtherPowerUI
-- endregion

-- endregion
