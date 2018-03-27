-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local UIGetJade = class("UIGetJade", UIBase)

function UIGetJade:ctor()

    UIGetJade.super.ctor(self)
    self.JadeText = nil;
    self.JadeImage = nil;
    self.JadeBtn = nil;
end


function UIGetJade:DoDataExchange()
    self.JadeBtn = self:RegisterController(UnityEngine.UI.Button, "Bg")
    self.JadeImage = self:RegisterController(UnityEngine.UI.Image, "Bg/Image")
    self.JadeText = self:RegisterController(UnityEngine.UI.Text, "Bg/Image/Text")
end
function UIGetJade:DoEventAdd()

    self:AddListener(self.JadeBtn, self.OnClickJadeBtn)
end

function UIGetJade:OnShow(data)
    if data then
        self.JadeImage.sprite = GameResFactory.Instance():GetSprite(data[2])
        self.JadeText.text = data[1];
    end
end


function UIGetJade:OnClickJadeBtn()
    UIService:Instance():HideUI(UIType.UIGetJade)
end


return UIGetJade
-- endregion
