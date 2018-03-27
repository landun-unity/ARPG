require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Ranklist * 256;

--
-- 客户端 --> 逻辑服务器
-- Ranklist
-- @author czx
--
C2L_Ranklist = 
{
    --
    -- 请求打开排行榜
    --
    OpenLeagueRanklistRequest = Begin + 0, 
    
    --
    -- 请求打开排行榜
    --
    OpenPlayerRanklistRequest = Begin + 1, 
}

return C2L_Ranklist;
