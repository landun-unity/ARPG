-- region *.lua
-- Date16/10/22


local UIBase = require("Game/UI/UIBase")
local UIAllocMemberItem = class("UIAllocMemberItem", UIBase);

function UIAllocMemberItem:ctor()
    UIAllocMemberItem.super.ctor(self)
    self.nameText = nil;
    self.checkmark = nil;
    self.btn = nil;

    self.playerId = 0;
    self.name = "";

    self.chat = nil;
    self.chatPlayer = nil;
end

-- 注册控件
function UIAllocMemberItem:DoDataExchange()
    self.nameText = self:RegisterController(UnityEngine.UI.Text, "AllianceChaTwotBtn/Text");
    self.checkmark = self:RegisterController(UnityEngine.UI.Toggle, "Toggle");
    self.btn = self:RegisterController(UnityEngine.UI.Button, "AllianceChaTwotBtn");
end

-- 监测控件
function UIAllocMemberItem:DoEventAdd()
    self:AddListener(self.btn, self.OnClick)
    self:AddToggleOnValueChanged(self.checkmark, self.OnClickMark)
end

function UIAllocMemberItem:OnShow(param, chat)
   self.chat = chat;
   self.chatPlayer = param;
   self.nameText.text = param.name;
   self.name = param.name;
   self.playerId = param.playerId;
   self.checkmark.isOn = false;
end

function UIAllocMemberItem:Refresh()
   self.checkmark.isOn = false;
end

--添加
function UIAllocMemberItem:OnClickMark()
    if self.checkmark.isOn == true then
        if self.chat:FindAddChatMember(self.chatPlayer) then
            self.chat:RemoveAddChatMember(self.chatPlayer);
        else
            self.chat:AddChatMember(self.chatPlayer);
        end
    else
        self.chat:RemoveAddChatMember(self.chatPlayer);
    end
end

function UIAllocMemberItem:OnClick()
    if self.playerId == PlayerService:Instance():GetPlayerId() then
        return;
    end

    local params = {};
    params[1] = self.playerId;
    params[2] = self.name;
    UIService:Instance():ShowUI(UIType.OperationUI, params);
end

return UIAllocMemberItem;