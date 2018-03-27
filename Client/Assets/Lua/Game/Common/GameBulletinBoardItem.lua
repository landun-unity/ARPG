
local UIBase = require("Game/UI/UIBase")

local GameBulletinBoardItem = class("GameBulletinBoardItem",UIBase)
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")

function GameBulletinBoardItem:ctor()
	GameBulletinBoardItem.super.ctor(self);
    self.showText = nil;
end

--注册控件
function GameBulletinBoardItem:DoDataExchange()
    self.showText = self:RegisterController(UnityEngine.UI.Text,"ShowText");
end

function GameBulletinBoardItem:InitText(localPosition,content)
    self.showText.transform.parent.localPosition = localPosition;
    if content ~= nil then
         self.showText.text = content;
    end
end

return GameBulletinBoardItem;
