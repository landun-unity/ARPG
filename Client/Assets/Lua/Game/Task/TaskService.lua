--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameService = require("FrameWork/Game/GameService")
local TaskManage = require("Game/Task/TaskManage")
local TaskHandler = require("Game/Task/TaskHandler")

TaskService = class("TaskService", GameService)

function TaskService:ctor()
    TaskService._instance = self;
    TaskService.super.ctor(self, TaskManage.new(), TaskHandler.new());
end

function TaskService:Instance()
    return TaskService._instance;
end

--清空数据
function TaskService:Clear()
    self._logic:ctor()
end


function TaskService:GetOverCount()
    return self._logic:GetOverCount();
end

function TaskService:GetAllDataCount()
    return self._logic:GetAllDataCount();
end

function TaskService:GetTaskByIndex(index)
    return self._logic:GetTaskByIndex(index);
end

function TaskService:GetFirstOverTask()
    return self._logic:GetFirstOverTask();
end

function TaskService:GetTaskByTableId(tableid)
    return self._logic:GetTaskByTableId(tableid);
end

-- 任务列表请求
function TaskService:OpenTaskListRequest()
    self._logic:OpenTaskListRequest();
end

-- 领取任务请求
function TaskService:AwardRequest(requestId)
    self._logic:AwardRequest(requestId);
end

return TaskService;

--endregion
