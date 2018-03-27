-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")
local LeagueControlType = require("Game/League/LeagueControlType")
local SLeaderOtherPower = class("SLeaderOtherPower", UIBase)

function SLeaderOtherPower:ctor()
    
    SLeaderOtherPower.super.ctor(self)
    self.LeagueBackBtn =nil;
    self.AppiontBtn = nil;
    self.AppiontChifeBtn =nil;
    self.DissolveBtn =nil;
    self.GiveUpBtn =nil;
    self.targetId = nil;
    self.chiefId =nil;
    self.time = nil;
    self.state=nil;
    self.AppiontChifeImage =nil;
    self.name = nil;
end


--注册控件
function SLeaderOtherPower:DoDataExchange()

    self.LeagueBackBtn=self:RegisterController(UnityEngine.UI.Button,"Back")
    self.AppiontBtn = self:RegisterController(UnityEngine.UI.Button,"AppiontOffice")
    self.AppiontChifeBtn =self:RegisterController(UnityEngine.UI.Button,"AppiontCityLeader")
    self.DissolveBtn =self:RegisterController(UnityEngine.UI.Button,"DissolveMember")
    self.AppiontChifeImage =self:RegisterController(UnityEngine.UI.Image, "AppiontCityLeader")

end

--注册点击事件
function SLeaderOtherPower:DoEventAdd()

    self:AddListener(self.LeagueBackBtn,self.OnClickLeagueBackBtn)
    self:AddListener(self.AppiontBtn,self.OnClickAppiontBtn)
    self:AddListener(self.AppiontChifeBtn,self.OnClickAppiontChifeBtn)
    self:AddListener(self.DissolveBtn,self.OnClickDissolveBtn)
end



function SLeaderOtherPower:OnShow(Param)
    if Param~=nil then
        self.targetId = Param[1];  
        self.name= Param[2];  
     end
    GameResFactory.Instance():LoadMaterial(self.AppiontChifeImage, "Shader/HeroCardGray")
end


--点击按钮逻辑
function SLeaderOtherPower:OnClickLeagueBackBtn()
    UIService:Instance():HideUI(UIType.SLeaderOtherPower)
end

function SLeaderOtherPower:OnClickAppiontBtn()
     UIService:Instance():HideUI(UIType.SLeaderOtherPower)
     UIService:Instance():ShowUI(UIType.LeagueOfficePosUI,self.targetId)
end

function SLeaderOtherPower:OnClickAppiontChifeBtn()
    UIService:Instance():HideUI(UIType.SLeaderOtherPower)
end

function SLeaderOtherPower:OnClickDissolveBtn()
    UIService:Instance():HideUI(UIType.SLeaderOtherPower)
    local str = "是否将" .. self.name .. "移出同盟"
    local data={LeagueControlType.RemoveMember,self.targetId,str}
    UIService:Instance():ShowUI(UIType.ConfirmCancelUI,data)
end


return SLeaderOtherPower
--endregion



--endregion
