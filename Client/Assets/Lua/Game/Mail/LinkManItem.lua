--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local LinkManItem = class("LinkManItem",UIBase)
local LinkManUI = require("Game/Mail/LinkManUI");

function LinkManItem:ctor()
    
    LinkManItem.super.ctor(self)

    self.nameText = nil;

    self.selectImage = nil;
    self.name = nil;
end

function LinkManItem:DoDataExchange()
    self.nameText = self:RegisterController(UnityEngine.UI.Text, "PeopleName");
    self.selectImage = self:RegisterController(UnityEngine.RectTransform, "SelectImage");
end

function LinkManItem:DoEventAdd()
    self:AddListener(self.clickBtn, self.OnCilckPeopleItem);
end

function LinkManItem:SetName(name)
    self.name = name;
    self.nameText.text = name;
    --默认进来没有选中任何人
    self:SetSelectState(false)
end

function LinkManItem:SetSelectState(isSelect)
    self.selectImage.gameObject:SetActive(isSelect);
end

return LinkManItem
