-- region *.lua
-- Date16/10/22


local UIBase = require("Game/UI/UIBase")
require("Game/Chat/ChatType");
local UIChannelItem = class("UIChannelItem", UIBase);

function UIChannelItem:ctor()
    UIChannelItem.super.ctor(self);
    self.Btn = nil;
    self.redImage = nil;
    self.text = nil;
    self.imageBtnImage = nil;

    self.chat = nil;
    self.chatTeam = nil;

    self._chatType = 0;
end

-- 注册控件
function UIChannelItem:DoDataExchange()
    self.Btn = self:RegisterController(UnityEngine.UI.Button, "");
    self.redImage = self:RegisterController(UnityEngine.Transform, "Image");
    self.text = self:RegisterController(UnityEngine.UI.Text, "Text");
    self.imageBtnImage = self:RegisterController(UnityEngine.Transform, "PAddLeagueChannelButton");
end

-- 监测控件
function UIChannelItem:DoEventAdd()
    self:AddListener(self.Btn, self.OnClickBtn)
end

function UIChannelItem:OnShow(chatTeam, chat)
    if chatTeam.leaderId == PlayerService:Instance():GetPlayerId() then
        self.text.text = chatTeam.name;
    else
        self.text.text = chatTeam.name.."\n"..chatTeam.leaderName;
    end
    self.chat = chat;
    self.chatTeam = chatTeam;
    self._chatType = ChatType.GroupingChat * 10000 + self.chatTeam.leaderId;
    self:RefreshRedImage();
    chat:SetChannelBtn(self.imageBtnImage, self._chatType, self.redImage);
end

function UIChannelItem:ShowRedImage()
    self.redImage.gameObject:SetActive(true);
end

function UIChannelItem:RefreshRedImage() 
    local count = ChatService:Instance():GetUnread(self._chatType, ChatType.GroupingChat);
    
    if count ~= 0 then
      if self.redImage.gameObject.activeSelf == false then
         self.redImage.gameObject:SetActive(true);
      end
    end
end

function UIChannelItem:ClickRedImage()
    if self.redImage.gameObject.activeSelf == true then
       self.redImage.gameObject:SetActive(false);
    end
end

function UIChannelItem:OnClickBtn()
    self.chat._chatInputText.text = "";
    self.chat:_LoadChatListByType(self._chatType, ChatType.GroupingChat, self);
end

return UIChannelItem