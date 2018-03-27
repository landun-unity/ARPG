--
-- 客户端 --> 逻辑服务器
-- 发送邮件
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local RequestSendMail = class("RequestSendMail", GameMessage);

--
-- 构造函数
--
function RequestSendMail:ctor()
    RequestSendMail.super.ctor(self);
    --
    -- 邮件标题
    --
    self.mailTheme = "";
    
    --
    -- 收件人名字
    --
    self.receiverName = "";
    
    --
    -- 收件人ID列表
    --
    self.receiverIdList = List.new();
    
    --
    -- 邮件正文
    --
    self.mailContent = "";
end

--@Override
function RequestSendMail:_OnSerial() 
    self:WriteString(self.mailTheme);
    self:WriteString(self.receiverName);
    
    local receiverIdListCount = self.receiverIdList:Count();
    self:WriteInt32(receiverIdListCount);
    for receiverIdListIndex = 1, receiverIdListCount, 1 do 
        self:WriteInt64(self.receiverIdList:Get(receiverIdListIndex));
    end
    self:WriteString(self.mailContent);
end

--@Override
function RequestSendMail:_OnDeserialize() 
    self.mailTheme = self:ReadString();
    self.receiverName = self:ReadString();
    
    local receiverIdListCount = self:ReadInt32();
    for i = 1, receiverIdListCount, 1 do 
        self.receiverIdList:Push(self:ReadInt64());
    end
    self.mailContent = self:ReadString();
end

return RequestSendMail;
