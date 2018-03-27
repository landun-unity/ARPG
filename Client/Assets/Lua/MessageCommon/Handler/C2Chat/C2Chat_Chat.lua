require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Chat * 65536 + MessageHandler.Chat * 256;

--
-- 客户端 --> 聊天服务器
-- Chat
-- @author czx
--
C2Chat_Chat = 
{
    --
    -- 加入频道
    --
    CreatLeagueChannel = Begin + 0, 
    
    --
    -- 加入频道
    --
    JoinChannel = Begin + 1, 
    
    --
    -- 离开频道
    --
    LeaveChannel = Begin + 2, 
    
    --
    -- 注册聊天服务器
    --
    RegisterChat = Begin + 3, 
    
    --
    -- 在一个频道中发送聊天
    --
    SendChat = Begin + 4, 
}

return C2Chat_Chat;
