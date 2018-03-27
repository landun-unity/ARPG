--region *.lua
--Date
local IOHandler = require("FrameWork/Game/IOHandler")
local MailHandler = class("MailHandler",IOHandler)

function MailHandler:ctor()    
    MailHandler.super.ctor(self)
end

function MailHandler:RegisterAllMessage()    
    self:RegisterMessage(L2C_Mail.ReturnMailInfo, self.GetMailAllInfoResponse, require("MessageCommon/Msg/L2C/Mail/ReturnMailInfo"));
    self:RegisterMessage(L2C_Mail.ReturnSendSuccess, self.GetSendMailResponse, require("MessageCommon/Msg/L2C/Mail/ReturnSendSuccess"));
    self:RegisterMessage(L2C_Mail.ReturnIsRead, self.GetReadMailResponse, require("MessageCommon/Msg/L2C/Mail/ReturnIsRead"));
    self:RegisterMessage(L2C_Mail.ReturnIsReceive, self.GetAwardResponse, require("MessageCommon/Msg/L2C/Mail/ReturnIsReceive"));

    self:RegisterMessage(L2C_Mail.SyncMailInfo, self.GetRefreshOneMail, require("MessageCommon/Msg/L2C/Mail/SyncMailInfo"));
    
end

--更新一条邮件（服务器主动发）
function MailHandler:GetRefreshOneMail(msg)
    --print("更新一条邮件 回复");
    self._logicManage:SaveOneMailInfo(msg.mailId,msg.mailTheme,msg.senderId,msg.senderName,msg.receiverId,msg.receiverName,msg.content,msg.time,msg.isReceiveAnnex,msg.annexCounts,msg.annexInfoList,msg.isRead,msg.mailType,msg.canCut);
    self:RefreshMailUI();
end

--邮箱所有信息返回
function MailHandler:GetMailAllInfoResponse(msg)
            LoginService:Instance():EnterState(LoginStateType.SyncMarkerInfos);
    --print("邮箱所有信息返回   ");
    local personalMail = msg.singleMailInfo;

    local groupMailTable = {};
        for i=1,msg.groupMailInfo:Count() do
            groupMailTable[i] = msg.groupMailInfo:Get(i);
    end
    local systemMailTable = {};
        for i=1,msg.systemMailInfo:Count() do
            systemMailTable[i] = msg.systemMailInfo:Get(i);
    end

    --print("msg.singleMailInfo； "..msg.singleMailInfo:Count().."msg.groupMailInfo； "..msg.groupMailInfo:Count().."msg.systemMailInfo； "..msg.systemMailInfo:Count())
    self._logicManage:SaveAllMailInfo(personalMail,groupMailTable,systemMailTable);
    self:RefreshMailUI();
end

--发送邮件回复
function MailHandler:GetSendMailResponse(msg)
    --print("发送邮件回复!!!!!!!!!!!!!!!!!!!!!   ".."  msg.isSuccess:"..msg.isSuccess);
    local isSuccess = msg.isSuccess;
    if isSuccess == 0 then        
        UIService:Instance():ShowUI(UIType.UICueMessageBox,117); 
    else
--        local baseClass = UIService:Instance():GetUIClass(UIType.OperationUI);
--        local isOpen =  UIService:Instance():GetOpenedUI(UIType.OperationUI);
--        if baseClass ~= nil and isOpen == true then
--            UIService:Instance():HideUI(UIType.OperationUI);
--        end
        UIService:Instance():HideUI(UIType.OperationUI);
        UIService:Instance():HideUI(UIType.PlayerInformationUI);
        UIService:Instance():HideUI(UIType.MailWriteUI);
        UIService:Instance():ShowUI(UIType.UICueMessageBox,118);        
        return;  
    end
end   

--读取邮件回复
function MailHandler:GetReadMailResponse(msg)
    --print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!读取邮件回复   ".."   count:"..msg.mailId:Count().."   msg.mailType:"..msg.mailType);
--    for i=1, msg.mailId:Count() do
--        print(msg.mailId:Get(i));
--    end
    self._logicManage:RefreshMailReadState(msg.mailId,msg.mailType);
    self:RefreshMailUI();
end

--领取附件回复
function MailHandler:GetAwardResponse(msg)  
    --print("领取附件回复   ");
    self._logicManage:RefreshMailAwardState(msg.mailId,msg.mailType);
    self:RefreshMailUI(true);
end

--邮件界面刷新
function MailHandler:RefreshMailUI(isGetAward)    
    local baseClass = UIService:Instance():GetUIClass(UIType.MailUI);
    local isOpen =  UIService:Instance():GetOpenedUI(UIType.MailUI);
    if baseClass ~= nil and isOpen == true then
        if isGetAward~= nil and isGetAward == true then
            baseClass:ShowGetAwardInfo();
        end
        baseClass:ShowCurMailInfo();
    else
        return;  
    end
end

return MailHandler
