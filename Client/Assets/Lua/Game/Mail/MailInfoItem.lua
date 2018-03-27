--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local MailInfoItem = class("MailInfoItem",UIBase)
local MailUI =  require("Game/Mail/MailUI")

function MailInfoItem:ctor()
    
    MailInfoItem.super.ctor(self)
    self.senderText = nil;
    self.titleText = nil;
    self.timeText = nil;
    self.receiverNameText = nil;
    self.notReadImage = nil;
    self.clickBtn = nil;
    self.selectImage = nil;
    --self.readedBgMask = nil;
    self.awardImage = nil;

    self.mailType = MailType.PersonalMailType;
end

function MailInfoItem:DoDataExchange()
    -- self.senderText = self:RegisterController(UnityEngine.UI.Text, "SenderText");
    self.titleText = self:RegisterController(UnityEngine.UI.Text, "TitleText");
    self.timeText = self:RegisterController(UnityEngine.UI.Text, "TimeText");
    self.receiverNameText = self:RegisterController(UnityEngine.UI.Text, "ReceiverNameText");
    self.notReadImage = self:RegisterController(UnityEngine.UI.Image, "MailNotReadImage");
    self.selectImage = self:RegisterController(UnityEngine.UI.Image, "SelectImage");
    --self.readedBgMask = self:RegisterController(UnityEngine.UI.Image, "ReadedBgMask");
    self.clickBtn = self:RegisterController(UnityEngine.UI.Button, "ClickButton");
    self.awardImage = self:RegisterController(UnityEngine.RectTransform, "Image");
end

function MailInfoItem:DoEventAdd()
    self:AddListener(self.clickBtn, self.OnCilckItem);
end

function MailInfoItem:OnShow()
   
   
end

function MailInfoItem:SetSelectState(isSelect)
   self.selectImage.gameObject:SetActive(isSelect);
end

--邮件显示设置
function MailInfoItem:SetMailInfo(mailInfo,mailType)
    self:SetSelectState(false);

    local myPlayerId =  PlayerService:Instance():GetPlayerId();
    if mailInfo~= nil then
        self.mailType = mailType;
        --LogManager:Instance().Log("myPlayerId:"..myPlayerId.."   mailInfo.receiverId:"..mailInfo.receiverId.." mailInfo.senderId:"..mailInfo.senderId.." mailInfo.SenderName:"..mailInfo.senderName.." mailInfo.receiverName"..mailInfo.receiverName); 
        
        if  mailType == MailType.SystemMailType then
            self.titleText.text = MailService:Instance():GetSystemMailTitle(mailInfo);
        else
            if mailInfo.mailTheme ~= "" then
                self.titleText.text = mailInfo.mailTheme;
            else
                if mailType == MailType.GroupMailType then
                    self.titleText.text = "来自【"..mailInfo.senderName.."】的邮件(对全体)";
                elseif mailType == MailType.PersonalMailType then
                    self.titleText.text = "";
                end
            end
        end
        local showText = "";
        if mailInfo.receiverId == myPlayerId then                
            showText =  mailInfo.senderName;
        else
            showText =  mailInfo.receiverName;
        end 
        if mailType == MailType.PersonalMailType then
            self.receiverNameText.text = "<color=#EAD890>"..showText.."</color>";
        else
            self.receiverNameText.text = "<color=#EAD890>发件人: </color>".."<color=#FF612A>"..mailInfo.senderName.."</color>";
        end

        if mailInfo.annexCounts>0 then
            self.awardImage.gameObject:SetActive(true);
        else
            self.awardImage.gameObject:SetActive(false);
        end
        if mailInfo.isRead == 0 then 
            --self.readedBgMask.gameObject:SetActive(false);
            self.notReadImage.gameObject:SetActive(true);
        else
            --self.readedBgMask.gameObject:SetActive(true);
            self.notReadImage.gameObject:SetActive(false);
        end

        --邮件时间显示
        --LogManager:Instance().Log("邮件发送时间  mailInfo.time: "..mailInfo.time);
        local curTimeStamp = PlayerService:Instance():GetLocalTime();
        local allSenondTime = (curTimeStamp - mailInfo.time)/1000;
        self.timeText.text = CommonService:Instance():GetShowBrforeTimeString(allSenondTime);
    else
        LogManager:Instance().Log("mailInfo is nil")
    end 
end

--点击邮件 显示右侧内容
function MailInfoItem:OnCilckItem()
    MailUI:Instance():ShowRight(true,true,self.mailType,self.gameObject);
end

return MailInfoItem
