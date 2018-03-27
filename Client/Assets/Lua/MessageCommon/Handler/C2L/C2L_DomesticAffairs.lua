require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.DomesticAffairs * 256;

--
-- 客户端 --> 逻辑服务器
-- DomesticAffairs
-- @author czx
--
C2L_DomesticAffairs = 
{
    --
    -- 交易信息
    --
    TransactionInfo = Begin + 0, 
}

return C2L_DomesticAffairs;
