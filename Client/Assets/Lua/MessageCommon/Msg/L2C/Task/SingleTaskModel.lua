--
-- 逻辑服务器 --> 客户端
-- 任务model
-- @author czx
--
local List = require("common/List");

local SingleTaskModel = class("SingleTaskModel");

function SingleTaskModel:ctor()
    --
    -- 任务id
    --
    self.taskId = 0;
    
    --
    -- 任务tableid
    --
    self.taskTableId = 0;
    
    --
    -- 任务状态
    --
    self.taskState = 0;
    
    --
    -- 任务参数列表
    --
    self.paramterlist = List.new();
end

return SingleTaskModel;
