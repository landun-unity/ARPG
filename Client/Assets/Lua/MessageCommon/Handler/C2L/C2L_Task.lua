require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Client * 16777216 + Terminal.Logic * 65536 + MessageHandler.Task * 256;

--
-- 客户端 --> 逻辑服务器
-- Task
-- @author czx
--
C2L_Task = 
{
    --
    -- 申请领取任务奖励
    --
    AwardRequest = Begin + 0, 
    
    --
    -- 打开自己可进行任务
    --
    OpenTaskListRequest = Begin + 1, 
}

return C2L_Task;
