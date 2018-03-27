require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Ranklist * 256;

--
-- 逻辑服务器 --> 客户端
-- Ranklist
-- @author czx
--
L2C_Ranklist = 
{
    --
    -- 玩家打开被同盟邀请列表
    --
    OpenLeagueRanklistRespond = Begin + 0, 
    
    --
    -- 玩家打开被同盟邀请列表
    --
    OpenPlayerRanklistRespond = Begin + 1, 
}

return L2C_Ranklist;
