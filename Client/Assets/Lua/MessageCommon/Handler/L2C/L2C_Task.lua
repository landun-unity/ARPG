require("MessageCommon/Util/Terminal")
require("MessageCommon/Util/MessageHandler")

local Begin = Terminal.Logic * 16777216 + Terminal.Client * 65536 + MessageHandler.Task * 256;

--
-- 逻辑服务器 --> 客户端
-- Task
-- @author czx
--
L2C_Task = 
{
    --
    -- 打开可执行任务回复
    --
    OpenTaskListRespond = Begin + 0, 
    
    --
    -- 任务model
    --
    SyncSingleTask = Begin + 1, 
    
    --
    -- 任务领奖回复
    --
    TaskAwardRespond = Begin + 2, 
    
    --
    -- 操作类型
    --
    TaskOperateType = Begin + 3, 
}

return L2C_Task;
