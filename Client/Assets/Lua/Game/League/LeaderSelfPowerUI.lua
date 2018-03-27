-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")

local LeaderSelfPowerUI = class("LeaderSelfPowerUI", UIBase)

function LeaderSelfPowerUI:ctor()

    LeaderSelfPowerUI.super.ctor(self)
    self.learDissolveLeague = 2
end


function LeaderSelfPowerUI:ctor()

    LeaderSelfPowerUI.super.ctor(self);
    self.title = nil;
    self.targetId = nil;
    self.chiefId = 1;
    self.LeagueBackBtn = nil;
    self.AppiontChiefBtn = nil;
    self.AppiontChifeImage = nil;
    self.DissolveLeagueBtn = nil; 
    self.DissolveLeagueImage =nil
end



-- ע���ؼ�
function LeaderSelfPowerUI:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.AppiontChiefBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontCityLeader")
    self.AppiontChifeImage = self:RegisterController(UnityEngine.UI.Image, "AppiontCityLeader")
    self.DissolveLeagueBtn = self:RegisterController(UnityEngine.UI.Button, "DissolveLeague")
    self.DissolveLeagueImage = self:RegisterController(UnityEngine.UI.Image, "DissolveLeague")
end

-- ע�������¼�
function LeaderSelfPowerUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.AppiontChiefBtn, self.OnClickAppiontChiefBtn)
    self:AddListener(self.DissolveLeagueBtn, self.OnClickDissolveLeagueBtn)

end


function LeaderSelfPowerUI:OnShow()
    GameResFactory.Instance():LoadMaterial(self.AppiontChifeImage, "Shader/HeroCardGray")
    if LeagueService:Instance():GetLeagueMemberList():Count() > 1 then
        GameResFactory.Instance():LoadMaterial(self.DissolveLeagueImage, "Shader/HeroCardGray")
        else
        self.DissolveLeagueImage.material = nil;
    end
end


function LeaderSelfPowerUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeaderSelfPowerUI)

end

function LeaderSelfPowerUI:OnClickAppiontChiefBtn()

    UIService:Instance():HideUI(UIType.LeaderSelfPowerUI)

end

function LeaderSelfPowerUI:OnClickDissolveLeagueBtn()

    if LeagueService:Instance():GetLeagueMemberList():Count() > 1 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.RemoveLeagueMembers);
        return
    end
    local data = { self, self.DissolveLeague, 2, "1.解散同盟需要先将所有成员移除\n2.解散同盟将清除同盟所有相关数据\n3.解散同盟将是同盟已占领的城池变为未占领状态\n4.解散后，盟主将处于在野状态，24小时后可以加入其他同盟", "解散同盟", "请在下方输入“解散”来确认本次操作" }
    UIService:Instance():ShowUI(UIType.ConfirmQuitLeague, data)
end

function LeaderSelfPowerUI:DissolveLeague()
    LeagueService:Instance():SendDissloveLeague(PlayerService:Instance():GetPlayerId());
    UIService:Instance():HideUI(UIType.LeaderSelfPowerUI)
end

return LeaderSelfPowerUI


-- endregion
