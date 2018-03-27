--region *.lua
--Date16/10/17
--盟主信息界面
local UIBase= require("Game/UI/UIBase")
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")

local LeagueLeaderInfoUI=class("LeagueLeaderInfoUI",UIBase);

function LeagueLeaderInfoUI:ctor()

LeagueLeaderInfoUI.super.ctor(self)
self.AddBlackListBtn = nil;
self.DeleteContactBtn =nil;
self.SendEmailBtn=nil;
self.BackBtn=nil;
end

--注册控件
function LeagueLeaderInfoUI:DoDataExchange()

self.Name = self:RegisterController(UnityEngine.UI.text,"Name")
self.Power = self:RegisterController(UnityEngine.UI.text,"Power")
self.LeagueName = self:RegisterController(UnityEngine.UI.text,"LeagueNameButton/Text")
self.OfficePos = self:RegisterController(UnityEngine.UI.text,"OfficePos")
self.AddBlackListBtn=self:RegisterController(UnityEngine.UI.Button,"AddBlackList")
self.DeleteContactBtn=self:RegisterController(UnityEngine.UI.Button,"DeleteContact")
self.SendEmailBtn=self:RegisterController(UnityEngine.UI.Button,"SendEmail")
self.BackBtn=self:RegisterController(UnityEngine.UI.Button,"Back")

end


--注册控件点击事件
function LeagueLeaderInfoUI:DoEventAdd()
--读取界面文本信息

self:AddListener(self.AddBlackListBtn,self.OnClickAddBlackListBtn)
self:AddListener(self.SendEmailBtn,self.OnClickSendEmailBtn)
self:AddListener(self.DeleteContactBtn,self.OnClickDeleteContactBtn)
self:AddListener(self.BackBtn,self.OnClickBackBtn)

end



--点击控件运行事件

function LeagueLeaderInfoUI:OnClickAddBlackListBtn()

end

function LeagueLeaderInfoUI:OnClickSendEmailBtn()

end

function LeagueLeaderInfoUI:OnClickDeleteContactBtn()

end

function LeagueLeaderInfoUI:OnClickBackBtn()

UIService:Instance():HideUI(UIType.LeagueLeaderInfoUI)

end

return LeagueLeaderInfoUI 
--endregion
