-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成


local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")
local LeagueControlType = require("Game/League/LeagueControlType")
local SLeaderRecallOtherPower = class("SLeaderRecallOtherPower", UIBase)

function SLeaderRecallOtherPower:ctor()

    SLeaderRecallOtherPower.super.ctor(self)
    self.LeagueBackBtn = nil;
    self.AppiontBtn = nil;
    self.AppiontChifeBtn = nil;
    self.DissolveBtn = nil;
    self.GiveUpBtn = nil;
    self.targetId = nil;
    self.chiefId = nil;
    self.nextTime = nil;
    self.AppiontChifeImage = nil;
    self.time = nil;
    self.state = nil;
end


-- 注册控件
function SLeaderRecallOtherPower:DoDataExchange()
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.AppiontBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontOffice")
    self.AppiontChifeBtn = self:RegisterController(UnityEngine.UI.Button, "AppiontCityLeader")
    self.AppiontChifeImage = self:RegisterController(UnityEngine.UI.Image, "AppiontCityLeader")
    self.DissolveBtn = self:RegisterController(UnityEngine.UI.Button, "DissolveMember")
end

-- 注册点击事件
function SLeaderRecallOtherPower:DoEventAdd()
    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.AppiontBtn, self.OnClickAppiontBtn)
    self:AddListener(self.AppiontChifeBtn, self.OnClickAppiontChifeBtn)
    self:AddListener(self.DissolveBtn, self.OnClickDissolveBtn)
end


function SLeaderRecallOtherPower:OnShow(Param)
    if Param ~= nil then
        self.targetId = Param[1];
        self.name = Param[2]
        self.nextTime = Param[3];
    end
    GameResFactory.Instance():LoadMaterial(self.AppiontChifeImage, "Shader/HeroCardGray")
end

-- 点击按钮逻辑
function SLeaderRecallOtherPower:OnClickLeagueBackBtn()
    UIService:Instance():HideUI(UIType.SLeaderRecallOtherPower)
end

function SLeaderRecallOtherPower:OnClickAppiontBtn()
    UIService:Instance():HideUI(UIType.SLeaderRecallOtherPower)
    local str = "是否罢免" .. self.name .. "的职位"
    local data = { LeagueControlType.RecellOfficer, self.targetId, str, self.nextTime }
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)
end

function SLeaderRecallOtherPower:OnClickAppiontChifeBtn()
    UIService:Instance():HideUI(UIType.SLeaderRecallOtherPower)
end

function SLeaderRecallOtherPower:OnClickDissolveBtn()
    UIService:Instance():HideUI(UIType.SLeaderRecallOtherPower)
    local str = "是否将" .. self.name .. "移出同盟"
    local data = { LeagueControlType.RemoveMember, self.targetId, str }
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI, data)
end


return SLeaderRecallOtherPower
-- endregion

