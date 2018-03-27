-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local ConfirmQuitLeague = class("ConfirmQuitLeague", UIBase)

function ConfirmQuitLeague:ctor()

    ConfirmQuitLeague.super.ctor(self)
    self.InputQuit = nil;
    self.button = nil;
    self.back = nil;
    self.title = nil;
    self.funcBack = nil;
    self.go = nil;
    self.commondType = nil;
    self.content = nil;
    self.helpContent = nil;
end


function ConfirmQuitLeague:DoDataExchange()

    self.InputQuit = self:RegisterController(UnityEngine.UI.InputField, "InputField")
    self.button = self:RegisterController(UnityEngine.UI.Button, "Button")
    self.back = self:RegisterController(UnityEngine.UI.Button, "back")
    self.helpContent = self:RegisterController(UnityEngine.UI.Text, "helpContent")
    self.title = self:RegisterController(UnityEngine.UI.Text, "Image/Title")
    self.content = self:RegisterController(UnityEngine.UI.Text, "Text")
end

function ConfirmQuitLeague:DoEventAdd()
    self:AddListener(self.button, self.OnClickbuttonBtn)
    self:AddListener(self.back, self.OnClickbackBtn)
end


function ConfirmQuitLeague:OnShow(data)

    self.go = data[1]
    self.funcBack = data[2]
    self.commondType = data[3]
    self.content.text = data[4]
    self.helpContent.text = data[6]
    self.title.text = data[5]
end

function ConfirmQuitLeague:OnClickbuttonBtn()

    if self.commondType == 1 then
        if self.InputQuit.text == "退出" then
            self.funcBack(self.go)
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.quitleague)
        end
    end
    if self.commondType == 2 then
        if self.InputQuit.text == "解散" then
            self.funcBack(self.go)
            UIService:Instance():HideUI(UIType.ConfirmQuitLeague)
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 1007)
        end
    end

end

function ConfirmQuitLeague:OnClickbackBtn()

    UIService:Instance():HideUI(UIType.ConfirmQuitLeague)

end

return ConfirmQuitLeague