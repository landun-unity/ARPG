require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.WorldTendency * 256;

--
-- 客户端 --> 逻辑服务器
-- WorldTendency
-- @author czx
--
C2L_WorldTendency = 
{
    --
    -- 请求天下大势领取奖励
    --
    RequestGetAward = Begin + 0, 
    
    --
    -- 请求天下大势信息
    --
    RequestWordTendencyInfo = Begin + 1, 
}

return C2L_WorldTendency;
