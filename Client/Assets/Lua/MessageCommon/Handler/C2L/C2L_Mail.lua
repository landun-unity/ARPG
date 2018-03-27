require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Mail * 256;

--
-- 客户端 --> 逻辑服务器
-- Mail
-- @author czx
--
C2L_Mail = 
{
    --
    -- 已读
    --
    RequestIsRead = Begin + 0, 
    
    --
    -- 请求邮件信息
    --
    RequestMailInfo = Begin + 1, 
    
    --
    -- 领取奖励
    --
    RequestReceive = Begin + 2, 
    
    --
    -- 发送邮件
    --
    RequestSendMail = Begin + 3, 
}

return C2L_Mail;
