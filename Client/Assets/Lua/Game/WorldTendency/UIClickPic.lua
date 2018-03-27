----region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local UIClickPic = class("UIClickPic", UIBase)

function UIClickPic:ctor()

    UIClickPic.super.ctor(self)
    self.back = nil;
    self.pic = nil;
    self.pi = nil;
    self.myText = nil;

end


function UIClickPic:DoDataExchange()

    self.back = self:RegisterController(UnityEngine.UI.Button, "Btn")
    self.pic = self:RegisterController(UnityEngine.UI.Image, "Image")
    self.myText = self:RegisterController(UnityEngine.UI.Text, "Text")


end

function UIClickPic:DoEventAdd()

    self:AddListener(self.back, self.OnClickbutton)

end


function UIClickPic:OnShow(args)
    self.pi = args[1];
    if self.pi ~= nil then
        self.pic.sprite = GameResFactory.Instance():GetResSprite(self.pi);
    end
    self.myText.text = args[2]
end

function UIClickPic:OnClickbutton()

    UIService:Instance():HideUI(UIType.UIClickPic)

end

return UIClickPic