require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.WorldTendency * 256;

--
-- 逻辑服务器 --> 客户端
-- WorldTendency
-- @author czx
--
L2C_WorldTendency = 
{
    --
    -- 天下大势领取奖励回复
    --
    ReponseGetAward = Begin + 0, 
    
    --
    -- 请求天下大势信息回复
    --
    ResponseWordTendencyInfo = Begin + 1, 
    
    --
    -- 天下大势达成返回通知
    --
    WorldTendencyDoneResponse = Begin + 2, 
}

return L2C_WorldTendency;
