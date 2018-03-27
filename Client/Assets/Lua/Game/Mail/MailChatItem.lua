--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local MailChatItem = class("MailChatItem",UIBase)
local MailUI =  require("Game/Mail/MailUI")

function MailChatItem:ctor()
    
    MailChatItem.super.ctor(self)

    self.senderText = nil;
    self.titleText = nil;
    self.contentText = nil;
    self.timeText = nil;
    self.clickBtn = nil;

    self.curMailInfo = nil;
    self.myPlayerId = 0;
end


function MailChatItem:DoDataExchange()
    self.senderText = self:RegisterController(UnityEngine.UI.Text, "SenderText");
    self.titleText = self:RegisterController(UnityEngine.UI.Text, "TitleText");
    self.contentText = self:RegisterController(UnityEngine.UI.Text, "ContentText");
    self.timeText = self:RegisterController(UnityEngine.UI.Text, "TimeText");
    self.clickBtn = self:RegisterController(UnityEngine.UI.Button, "ClickButton");
end

function MailChatItem:DoEventAdd()
    self:AddListener(self.clickBtn, self.OnCilckItem);
end

function MailChatItem:SetMailInfo(mailInfo)
    if mailInfo~= nil then
        self.curMailInfo =  mailInfo;
        self.myPlayerId = PlayerService:Instance():GetPlayerId();
        if mailInfo.mailTheme ~= "" then 
            self.titleText.gameObject:SetActive(true);
            self.titleText.text = mailInfo.mailTheme;
        else
            self.titleText.gameObject:SetActive(false);
        end 
        if self.myPlayerId == mailInfo.senderId then 
            self.senderText.text = "我";
        else
            self.senderText.text = mailInfo.senderName;
        end
        
        self.contentText.text = mailInfo.content;
        --时间显示
        local curTimeStamp = PlayerService:Instance():GetLocalTime();
        local allSenondTime = (curTimeStamp - mailInfo.time )/1000;
        self.timeText.text = CommonService:Instance():GetShowBrforeTimeString(allSenondTime);
    end 
end

function MailChatItem:OnShow()

end

function MailChatItem:OnCilckItem()    
    --print("点击了item"..self.gameObject.name.."     self.curMailInfo.content"..self.curMailInfo.content);
    if  self.myPlayerId ~= self.curMailInfo.senderId then
        MailUI:Instance():OnClickChatItem(self.gameObject);
    end
end


return MailChatItem