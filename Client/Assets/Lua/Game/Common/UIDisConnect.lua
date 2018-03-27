local UIBase = require("Game/UI/UIBase");
local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");

UIDisConnect = class("UIDisConnect", UIBase);

function UIDisConnect:ctor()
	UIDisConnect._instance = self;
    UIDisConnect.super.ctor(self);

    self.disImage = nil;
end
-- 心跳
function UIDisConnect:_OnHeartBeat()
	self.disImage.transform:Rotate(Vector3.New(0,0,30),1); 
end

function UIDisConnect:Instance()
    return UIDisConnect._instance;
end

function UIDisConnect:DoDataExchange()
	self.disImage = self:RegisterController(UnityEngine.Transform, "Image");
end

return UIDisConnect;