require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.SourceEvent * 256;

--
-- 客户端 --> 逻辑服务器
-- SourceEvent
-- @author czx
--
C2L_SourceEvent = 
{
    --
    -- 删除资源地消息
    --
    DeleteSourceEvent = Begin + 0, 
    
    --
    -- 请求资源地消息
    --
    GetSourceEvent = Begin + 1, 
}

return C2L_SourceEvent;
