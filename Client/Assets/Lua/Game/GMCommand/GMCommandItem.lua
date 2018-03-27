--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local GMCommandItem=class("GMCommandItem",UIBase);

function GMCommandItem:ctor()
    GMCommandItem.super.ctor(self)
end

--注册控件
function GMCommandItem:DoDataExchange()
    self.des = self:RegisterController(UnityEngine.UI.Text,"des")
end

--点击发送按钮
function GMCommandItem:SetText(text)
    self.des.text = text
end

return GMCommandItem
