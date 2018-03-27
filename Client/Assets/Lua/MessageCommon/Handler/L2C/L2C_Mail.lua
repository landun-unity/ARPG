require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Mail * 256;

--
-- 逻辑服务器 --> 客户端
-- Mail
-- @author czx
--
L2C_Mail = 
{
    --
    -- 已读
    --
    ReturnIsRead = Begin + 0, 
    
    --
    -- 领取成功
    --
    ReturnIsReceive = Begin + 1, 
    
    --
    -- 邮件信息
    --
    ReturnMailInfo = Begin + 2, 
    
    --
    -- 发送邮件是否成功
    --
    ReturnSendSuccess = Begin + 3, 
    
    --
    -- 邮件信息
    --
    SyncMailInfo = Begin + 4, 
}

return L2C_Mail;
