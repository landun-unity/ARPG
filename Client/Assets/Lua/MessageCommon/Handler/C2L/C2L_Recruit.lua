require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Recruit * 256;

--
-- 客户端 --> 逻辑服务器
-- Recruit
-- @author czx
--
C2L_Recruit = 
{
    --
    -- 请求所有招募列表
    --
    GetAllRecruitList = Begin + 0, 
    
    --
    -- 招募卡牌
    --
    RecruitCards = Begin + 1, 
}

return C2L_Recruit;
