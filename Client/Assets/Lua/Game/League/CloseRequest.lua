--region *.lua




local UIBase= require("Game/UI/UIBase")

local UIType=require("Game/UI/UIType")

local CloseRequest=class("CloseRequest",UIBase);

function CloseRequest:ctor()

    CloseRequest.super.ctor(self);
    self.LeagueBackBtn = nil;
    self.OpenBtn = nil; 

    --print("CloseRequest")
end


--注册控件
function CloseRequest:DoDataExchange()

    self.LeagueBackBtn=self:RegisterController(UnityEngine.UI.Button,"Back")
    self.OpenBtn =self:RegisterController(UnityEngine.UI.Button,"Button")
  
end

--注册点击事件

function CloseRequest:DoEventAdd()

   self:AddListener(self.LeagueBackBtn,self.OnClickLeagueBackBtn)
   self:AddListener(self.OpenBtn,self.OnClickOpenBtn)

end



--点击逻辑

function CloseRequest:OnClickLeagueBackBtn()

   UIService:Instance():HideUI(UIType.CloseRequest)
  UIService:Instance():HideUI(UIType.LeagueRequireInUI)
end

function CloseRequest:OnClickOpenBtn()

print("heroaaaaaaaaaaaa")
     LeagueService:Instance():SendShutMsg(PlayerService:Instance():GetPlayerId(),false)

end

return CloseRequest





--endregion
