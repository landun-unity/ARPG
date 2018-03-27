require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.BattleReport * 256;

--
-- 客户端 --> 逻辑服务器
-- BattleReport
-- @author czx
--
C2L_BattleReport = 
{
    --
    -- 获取战报
    --
    GetBattleReport = Begin + 0, 
    
    --
    -- 通过ID和下标获取战报
    --
    GetBattleReportByID = Begin + 1, 
    
    --
    -- 获取战报详情
    --
    GetBattleReportDetail = Begin + 2, 
    
    --
    -- 把此类型所有的战报设为已读
    --
    SetBattleReportRead = Begin + 3, 
    
    --
    -- 分享到聊天
    --
    ShareBattleReport = Begin + 4, 
}

return C2L_BattleReport;
