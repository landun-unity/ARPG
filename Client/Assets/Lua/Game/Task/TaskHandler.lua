--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local IOHandler = require("FrameWork/Game/IOHandler")
local TaskHandler = class("TaskHandler", IOHandler)

-- 构造函数
function TaskHandler:ctor()
    TaskHandler.super.ctor(self);
end

-- 注册所有消息
function TaskHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Task.OpenTaskListRespond, self.OpenTaskListRespond, require("MessageCommon/Msg/L2C/Task/OpenTaskListRespond"));
    self:RegisterMessage(L2C_Task.SyncSingleTask, self.SyncSingleTask, require("MessageCommon/Msg/L2C/Task/SyncSingleTask"));
    self:RegisterMessage(L2C_Task.TaskAwardRespond, self.TaskAwardRespond, require("MessageCommon/Msg/L2C/Task/TaskAwardRespond"));
    self:RegisterMessage(L2C_Task.TaskOperateType, self.TaskOperateType, require("MessageCommon/Msg/L2C/Task/TaskOperateType"));
end

-- 所有任务列表
function TaskHandler:OpenTaskListRespond(msg)
    self._logicManage:OpenTaskListRespond(msg);
end

-- 单个任务同步
function TaskHandler:SyncSingleTask(msg)
    self._logicManage:SyncSingleTask(msg);
end

-- 领取完的任务
function TaskHandler:TaskAwardRespond(msg)
    self._logicManage:TaskAwardRespond(msg);
end

-- 领取操作错误码
function TaskHandler:TaskOperateType(msg)
    self._logicManage:TaskOperateType(msg);
end

return TaskHandler;

--endregion
