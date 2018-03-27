--[[
    Name:登录界面
    anchor:Dr
    Data:16/9/7
    注意:本类是demo类型，仅用于测试，正式版看LoginGame
--]]

 local UIBase= require("Game/UI/UIBase");

local UILogin=class("UILogin",UIBase);
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

function UILogin:ctor()
	UILogin.super.ctor(self);
    self._btn=nil;
end

function UILogin:OnInit()
   print("UILogin OnInit");
end

function UILogin:DoDataExchange()
         --self._btn=self:RegisterController(UnityEngine.UI.Button,"txt");
end


function UILogin:DoEventAdd()

    --self:AddListener(self._btn,self.OnClickBtn);
end



function UILogin.OnClickBtn(self)
  print("UILoginOnclick");
      --UIManager:Instance():ShowUI(UIType.UILogin);

end


return UILogin;
--endregion
