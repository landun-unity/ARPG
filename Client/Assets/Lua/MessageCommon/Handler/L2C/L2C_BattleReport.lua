require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.BattleReport * 256;

--
-- 逻辑服务器 --> 客户端
-- BattleReport
-- @author czx
--
L2C_BattleReport = 
{
    --
    -- 所有的战报列表
    --
    AllBattleReport = Begin + 0, 
    
    --
    -- 战报消息结构
    --
    BattleReportMemblock = Begin + 1, 
    
    --
    -- 个人战报未读消息个数
    --
    BattleReportUnReadCount = Begin + 2, 
    
    --
    -- 战报
    --
    OneBattleReport = Begin + 3, 
}

return L2C_BattleReport;
