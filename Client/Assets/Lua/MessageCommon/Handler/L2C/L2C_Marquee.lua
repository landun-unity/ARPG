require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Marquee * 256;

--
-- 逻辑服务器 --> 客户端
-- Marquee
-- @author czx
--
L2C_Marquee = 
{
    --
    -- 招募消息体
    --
    MarqueeRespond = Begin + 0, 
}

return L2C_Marquee;
