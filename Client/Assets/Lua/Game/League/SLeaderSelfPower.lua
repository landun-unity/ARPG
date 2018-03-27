-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成

local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")

local SLeaderSelfPower = class("SLeaderSelfPower", UIBase)

function SLeaderSelfPower:ctor()

    SLeaderSelfPower.super.ctor(self)

end


function SLeaderSelfPower:ctor()

    SLeaderSelfPower.super.ctor(self);
    self.title = nil;
    self.targetId = nil;
    self.chiefId = 1;
    self.LeagueBackBtn = nil;
    self.AppiontChiefBtn = nil;
    self.AppiontChifeImage = nil;
    self.DissolveLeagueBtn = nil;
end



-- 注册控件
function SLeaderSelfPower:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.AppiontChiefBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontCityLeader")
    self.DissolveLeagueBtn = self:RegisterController(UnityEngine.UI.Button, "QuitLeague")
    self.AppiontChifeImage = self:RegisterController(UnityEngine.UI.Image, "AppiontCityLeader")
end

-- 注册点击事件
function SLeaderSelfPower:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.AppiontChiefBtn, self.OnClickAppiontChiefBtn)
    self:AddListener(self.DissolveLeagueBtn, self.OnClickDissolveLeagueBtn)

end

function SLeaderSelfPower:OnShow()
    GameResFactory.Instance():LoadMaterial(self.AppiontChifeImage, "Shader/HeroCardGray")

end


function SLeaderSelfPower:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.SLeaderSelfPower)

end

function SLeaderSelfPower:OnClickAppiontChiefBtn()

    UIService:Instance():HideUI(UIType.SLeaderSelfPower)

end

function SLeaderSelfPower:OnClickDissolveLeagueBtn()

    local data = { self, self.QuitLeague }
    UIService:Instance():ShowUI(UIType.ConfirmQuitLeague, data)

end

function SLeaderSelfPower:QuitLeague()

    LeagueService:Instance():SendQuitLeague(PlayerService:Instance():GetPlayerId());
    UIService:Instance():HideUI(UIType.SLeaderSelfPower)

end


return SLeaderSelfPower


-- endregion


-- endregion
