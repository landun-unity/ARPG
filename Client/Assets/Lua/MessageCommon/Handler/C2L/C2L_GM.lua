require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.GM * 256;

--
-- 客户端 --> 逻辑服务器
-- GM
-- @author czx
--
C2L_GM = 
{
    --
    -- GM
    --
    GMInfo = Begin + 0, 
}

return C2L_GM;
