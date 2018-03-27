--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local MailWriteUI = class("MailWriteUI",UIBase)
local List = require("common/List");

function MailWriteUI:ctor()
    
    MailWriteUI.super.ctor(self)
    MailWriteUI.instance = self;

    self.receiverInput = nil;
    self.titleInput = nil;
    self.contentInput = nil;
--    self.receiverText = nil;
--    self.titleText = nil;
--    self.contentText = nil;

    self.exitBtn = nil;
    self.sendBtn = nil;
    self.linkPeopleBtn = nil;               --联系人按钮
    self.channelBtn = nil;                  --频道按钮

    self.isGroupSend = false;               --是否群发
    self.groupIdList = List.new();          --选中要群发送的玩家id

    self.isReplay = false;                  --是否是回复某个邮件

end

-- 单例
function MailWriteUI:Instance()
    return MailWriteUI.instance;
end


function MailWriteUI:DoDataExchange()
    self.receiverInput = self:RegisterController(UnityEngine.UI.InputField,"BackgroundImage/TranslucenceImage/ReceiverInputField");
    self.titleInput = self:RegisterController(UnityEngine.UI.InputField,"BackgroundImage/TranslucenceImage/TitleInputField");
    self.contentInput = self:RegisterController(UnityEngine.UI.InputField,"BackgroundImage/TranslucenceImage1/ContentInputField");

--    self.receiverText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/TranslucenceImage/ReceiverInputField/Text");
--    self.titleText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/TranslucenceImage/TitleInputField/Text");
--    self.contentText = self:RegisterController(UnityEngine.UI.Text,"BackgroundImage/TranslucenceImage1/ContentInputField/Text");

    self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/XButton");
    self.sendBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/Buttonqd");
    self.linkPeopleBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/TranslucenceImage/Button");
    self.channelBtn = self:RegisterController(UnityEngine.UI.Button,"BackgroundImage/TranslucenceImage/Button1");
end

function MailWriteUI:DoEventAdd()
    self:AddListener(self.exitBtn,self.OnCilckExitBtn);
    self:AddListener(self.sendBtn,self.OnCilckSendMailBtn);
    self:AddListener(self.linkPeopleBtn,self.OnCilckLinkPeopleBtn);
    self:AddListener(self.channelBtn,self.OnCilckChannelBtn);
end


function MailWriteUI:OnShow(isReply)
    if self.groupIdList:Count()>0 then
        self.groupIdList:Clear();
    end
    if isReply~= nil then
        self.isReplay = isReply;
    end
    if self.isReplay == false then        
        self.linkPeopleBtn.gameObject:SetActive(true);
        self.channelBtn.gameObject:SetActive(true);
    else
        self.linkPeopleBtn.gameObject:SetActive(false);
        self.channelBtn.gameObject:SetActive(false);
    end
    
    self.receiverInput.enabled = true;
    self.receiverInput.text = "";
    self.titleInput.text = "";
    self.contentInput.text = "";

    self.leagueId = PlayerService:Instance():GetLeagueId();
    self.leagueTitleId = PlayerService:Instance():GetPlayerTitle();

    if self.leagueId ~= 0 and self.leagueTitleId < LeagueTitleType.Nomal then
       
       --频道等同盟分组有接口才可以开 
       --自己在某个频道
       -- self.channelBtn.gameObject:SetActive(false);

    else
       self.channelBtn.gameObject:SetActive(false);
    end
end

--确定给某个人写邮件时 调用
function MailWriteUI:SetPersonalReceiveInfo(receiverName)
     self.isGroupSend = false;
     if self.groupIdList:Count() >0 then 
        self.groupIdList:Clear();
     end
     self.receiverInput.text = receiverName;
     self.receiverInput.enabled = false;  
end

--群发时 调用
function MailWriteUI:SetGroupReceiveInfo(receiverIdList)   
    self.isGroupSend = true;       
    self.receiverInput.text = "发送给所有";
    self.receiverInput.enabled = false;   
    for i=1, receiverIdList:Count() do
        self.groupIdList:Push(receiverIdList:Get(i));
    end     
end

function MailWriteUI:OnCilckExitBtn()
    self.isGroupSend = false;
    self.groupIdList:Clear();
    UIService:Instance():HideUI(UIType.MailWriteUI);
end

--邮件发送
function MailWriteUI:OnCilckSendMailBtn()
    if self.receiverInput.text == "" then
        --LogManager:Instance().Log("收件人名字不能为空")
        UIService:Instance():ShowUI(UIType.UICueMessageBox,120);
        return;
--    elseif self.titleInput.text == "" then
--        --LogManager:Instance().Log("标题不能为空")
--        UIService:Instance():ShowUI(UIType.UICueMessageBox,121);
--        return;
    elseif self.contentInput.text == "" then
        --LogManager:Instance().Log("邮件内容不能为空")
        UIService:Instance():ShowUI(UIType.UICueMessageBox,122);
        return;
    end

     --非法字符检测
    if CommonService:Instance():LimitText(self.contentInput.text) == true then
        return;
    end 

    local msg = require("MessageCommon/Msg/C2L/Mail/RequestSendMail").new();    
    msg:SetMessageId(C2L_Mail.RequestSendMail);
    msg.mailTheme = self.titleInput.text;
    if self.isGroupSend == true then
        local idCount = self.groupIdList:Count();
        LogManager:Instance().Log("当前群发的数量:"..idCount)
        if idCount <=0 then 
            LogManager:Instance().Log("邪门了 ，发送的邮件类型哪里有不对的地方")
            return;
        end
        for i=1, idCount do
            msg.receiverIdList:Push(self.groupIdList:Get(i));
        end
    else
        local myName = PlayerService:Instance():GetName();
        if myName == self.receiverInput.text then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,129);
            return;
        end
        msg.receiverName =  self.receiverInput.text;
    end
    msg.mailContent = self.contentInput.text;
    NetService:Instance():SendMessage(msg)
    LogManager:Instance().Log("发送邮件消息 ".."  msg.mailTheme:"..msg.mailTheme.." msg.receiverName:"..msg.receiverName.." msg.mailContent:"..msg.mailContent);
end

--点击联系人
function MailWriteUI:OnCilckLinkPeopleBtn()    
    UIService:Instance():ShowUI(UIType.LinkManUI);    
end

--点击频道
function MailWriteUI:OnCilckChannelBtn()
    LogManager:Instance().Log("点击频道按钮,暂时没有聊天频道");

end

return MailWriteUI
