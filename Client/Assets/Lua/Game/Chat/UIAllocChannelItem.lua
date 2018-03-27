-- region *.lua
-- Date16/10/22


local UIBase = require("Game/UI/UIBase")
local UIAllocChannelItem = class("UIAllocChannelItem", UIBase);

function UIAllocChannelItem:ctor()
    UIAllocChannelItem.super.ctor(self)
    self.nameText = nil;
    self.Button = nil;
    self.btn = nil;

    self.name = "";
    self.playerId = 0;

    self.chat = nil;
    self.chatPlayer = nil;
end

-- 注册控件
function UIAllocChannelItem:DoDataExchange()
    self.nameText = self:RegisterController(UnityEngine.UI.Text, "AllianceChatOneBtn/Text");
    self.Button = self:RegisterController(UnityEngine.UI.Button, "Button");
    self.btn = self:RegisterController(UnityEngine.UI.Button, "AllianceChatOneBtn");
end

-- 监测控件
function UIAllocChannelItem:DoEventAdd()
    self:AddListener(self.btn, self.OnClick)
    self:AddListener(self.Button, self.OnClickRemove)
end

function UIAllocChannelItem:OnShow(param, chat)
    self.chatPlayer = param;
    self.nameText.text = param.name;
    self.name = param.name;
    self.playerId = param.playerId;
    if chat ~= nil then
        self.chat = chat;
        if self.playerId == PlayerService:Instance():GetPlayerId() then
           self.Button.gameObject:SetActive(false);
        else
           self.Button.gameObject:SetActive(true);
        end
    else
       self.Button.gameObject:SetActive(false);
    end
end

function UIAllocChannelItem:OnClick()
    if self.playerId == PlayerService:Instance():GetPlayerId() then
        return;
    end

    local params = {};
    params[1] = self.playerId;
    params[2] = self.name;
    UIService:Instance():ShowUI(UIType.OperationUI, params);
end

--删除
function UIAllocChannelItem:OnClickRemove()
    if LeagueService:Instance():FindLeagueChatTeam(PlayerService:Instance():GetPlayerId()) == nil then
        self.chat:RemoveChatMember(self.chatPlayer);
    else
        local msg = require("MessageCommon/Msg/C2L/League/KickOneMemberOutChatTeam").new();
        msg:SetMessageId(C2L_League.KickOneMemberOutChatTeam);
        print(self.playerId)
        msg.targetid = self.playerId;
        NetService:Instance():SendMessage(msg);
    end
end

return UIAllocChannelItem;