require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.SourceEvent * 256;

--
-- 逻辑服务器 --> 客户端
-- SourceEvent
-- @author czx
--
L2C_SourceEvent = 
{
    --
    -- 删除资源地消息
    --
    DeleteSourceEvent = Begin + 0, 
    
    --
    -- 资源地消息
    --
    SourceEvent = Begin + 1, 
    
    --
    -- 资源地消息列表
    --
    SourceEventList = Begin + 2, 
}

return L2C_SourceEvent;
