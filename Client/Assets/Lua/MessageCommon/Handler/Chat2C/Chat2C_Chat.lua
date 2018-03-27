require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Chat * 16777216 + Terminal.Client * 65536 + MessageHandler.Chat * 256;

--
-- 聊天服务器 --> 客户端
-- Chat
-- @author czx
--
Chat2C_Chat = 
{
    --
    -- 一条聊天信息
    --
    BroadcastChat = Begin + 0, 
    
    --
    -- 注册聊天成功
    --
    RegisterChatSuccess = Begin + 1, 
    
    --
    -- 同步聊天信息
    --
    SyncChat = Begin + 2, 
    
    --
    -- 同步离开频道
    --
    SyncLeaveChannel = Begin + 3, 
}

return Chat2C_Chat;
