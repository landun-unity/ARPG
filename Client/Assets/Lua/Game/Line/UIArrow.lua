--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local UIArrow = class("UIArrow",UIBase)

function UIArrow:ctor()
    
    UIArrow.super.ctor(self)
    
    self.perTime = 0.03;
    self.curAlpha = 1.0;
    self.arrowImage = nil;   
end

-- ÐÄÌø
function UIArrow:_OnHeartBeat()
    if self.gameObject.activeSelf == true then
        if self.curAlpha >= 1.0 or self.curAlpha <= 0 then
            self.perTime = -self. perTime;
        end
        self.curAlpha = self.curAlpha + self.perTime;
        self.arrowImage.color = Color.New(1,1,1,self.curAlpha);     
    end
end

function UIArrow:Init()
    self.arrowImage = self.gameObject:GetComponent(typeof(UnityEngine.UI.Image));
end

return UIArrow
