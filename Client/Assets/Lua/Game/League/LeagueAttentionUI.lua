--region *.lua
--Date 16/10/16
--LeagueAttentionUI
--同盟功能介绍   快来加入同盟界面

local UIBase= require("Game/UI/UIBase")
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")

local LeagueAttentionUI=class("LeagueAttentionUI",UIBase);

function LeagueAttentionUI:ctor()

LeagueAttentionUI.super.ctor(self);
self.ConfirmBtn=nil;

end

--注册控件
function LeagueAttentionUI:DoDataExchange()

self.ConfirmBtn=self:RegisterController(UnityEngine.UI.Button,"Confirm");

end

--注册控件点击事件

function LeagueAttentionUI:DoEventAdd()

self:AddListener(self.ConfirmBtn,self.OnClickConfirmBtn)

end

--点击按钮响应事件
function LeagueAttentionUI:OnClickConfirmBtn()

UIService:Instance():HideUI(UIType.LeagueAttentionUI)

end

return LeagueAttentionUI
--endregion
