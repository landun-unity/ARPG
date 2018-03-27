local UIBase = require("Game/UI/UIBase")

local CamyIntroduce = class("CamyIntroduce",UIBase)
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")


function CamyIntroduce:ctor()
	CamyIntroduce.super.ctor(self)
	self.Exit = nil;
end

function CamyIntroduce:DoDataExchange()  
 	self.Exit = self:RegisterController(UnityEngine.UI.Button,"ExitBtn");
end

--注册点击事件
function CamyIntroduce:DoEventAdd()    
	self:AddOnClick(self.Exit,self.OnCilckExitBtn);

end

function CamyIntroduce:OnCilckExitBtn()
	UIService:Instance():HideUI(UIType.CamyIntroduce);
end

return CamyIntroduce