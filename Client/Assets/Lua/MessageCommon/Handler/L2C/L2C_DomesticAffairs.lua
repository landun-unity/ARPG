require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.DomesticAffairs * 256;

--
-- 逻辑服务器 --> 客户端
-- DomesticAffairs
-- @author czx
--
L2C_DomesticAffairs = 
{
    --
    -- 交易信息
    --
    TransactionInfoPrompt = Begin + 0, 
}

return L2C_DomesticAffairs;
