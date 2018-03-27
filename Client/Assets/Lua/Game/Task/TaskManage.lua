--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GamePart = require("FrameWork/Game/GamePart")
local TaskManage = class("TaskManage", GamePart)
local Task = require("Game/Task/Task")

local List = require("common/List");
require("Game/Table/model/DataQuest")

-- 构造函数
function TaskManage:ctor()
    TaskManage.super.ctor(self);
    self._allTaskList = List.new();
end

-- 初始化
function TaskManage:_OnInit()
	
end

-- 所有任务列表 0 未完成 1 完成
function TaskManage:OpenTaskListRespond(msg)
    self._allTaskList:Clear();
    for i = 1, msg.list:Count() do
        local task = Task.new();
        task:InitData(msg.list:Get(i).taskTableId, msg.list:Get(i).taskId, msg.list:Get(i).taskState, msg.list:Get(i).paramterlist);
        self._allTaskList:Push(task);
    end
    self:SortAllTasks();
end

-- 单个任务同步 0 未完成 1 完成
function TaskManage:SyncSingleTask(msg)
    local taskData = self:GetTaskByTableId(msg.taskTableId);
    if taskData ~= nil then
        taskData:RefreshData(msg.taskState, msg.list);
    else
        local task = Task.new();
        task:InitData(msg.taskTableId, msg.taskId, msg.taskState, msg.list);
        self._allTaskList:Push(task);
    end
    self:SortAllTasks();
end

-- 领取完的任务
function TaskManage:TaskAwardRespond(msg)
    local taskData = self:GetTaskByTableId(msg.taskTableId);
    if taskData ~= nil then
        self._allTaskList:Remove(taskData);
    end
    self:SortAllTasks();

    --领取物品
    local tableData = DataQuest[msg.taskTableId];
    if tableData ~= nil then
        for i = 1, 6 do
            if tableData.AwardParameter1[i] ~= nil and tableData.AwardParameter2[i] ~= nil then
                local itemData = DataItem[tableData.AwardParameter1[i]];
                if itemData ~= nil then
                    local param = {};
                    param.name = itemData.Name;
                    param.count = tableData.AwardParameter2[i];
                    UIService:Instance():ShowUI(UIType.UIGetItemManage, param);
                end
            end
        end
    end
end

-- 领取操作错误码
function TaskManage:TaskOperateType(msg)
    
end

-- 排序
function TaskManage:SortAllTasks()
    local queue = Queue.new();
    for i = 1, self._allTaskList:Count() do
        queue:Push(self._allTaskList:Get(i));
    end
    self._allTaskList:Clear();

    local count = queue:Count();
    if count <= 0 then
        return;
    end

    for i = 1, count do
        local task = queue:Pop();
        if task:GetIsTarget() == false and task:GetRewardState() == true then
            self._allTaskList:Push(task);
        else
            queue:Push(task);
        end
    end

    count = queue:Count();
    if count <= 0 then
        return;
    end

    for i = 1, count do
        local task = queue:Pop();
        if task:GetIsTarget() == false and task:GetRewardState() == false then
            self._allTaskList:Push(task);
        else
            queue:Push(task);
        end
    end

    count = queue:Count();
    if count <= 0 then
        return;
    end

    for i = 1, count do
        local task = queue:Pop();
        if task:GetIsTarget() == true and task:GetRewardState() == true then
            self._allTaskList:Push(task);
        else
            queue:Push(task);
        end
    end

    count = queue:Count();
    if count <= 0 then
        return;
    end

    for i = 1, count do
        local task = queue:Pop();
        self._allTaskList:Push(task);
    end
end

-- 获取当前可领取的任务的数量
function TaskManage:GetOverCount()
    local count = 0;
    if self._allTaskList:Count() == 0 then
        return count;
    end
    for i = 1, self._allTaskList:Count() do
        if self._allTaskList:Get(i):GetRewardState() == true then
            count = count + 1;
        end
    end
    return count;
end

-- 获取当前所有任务以及所有战略目标的数量
function TaskManage:GetAllDataCount()
    local count = 0;
    local tCount = 0;
    for i = 1, self._allTaskList:Count() do
        if self._allTaskList:Get(i):GetIsTarget() == false then
            count = count + 1;
        else
            tCount = tCount + 1;
        end
    end
    return count, tCount;
end

-- 获取对应tableid的task
function TaskManage:GetTaskByTableId(tableid)
    for i = 1, self._allTaskList:Count() do
        if self._allTaskList:Get(i):GetTableId() == tableid then
            return self._allTaskList:Get(i);
        end
    end
    return nil;
end

function TaskManage:GetTaskByIndex(index)
    return self._allTaskList:Get(index);
end

-- 从上到下 获取第一个已经完成的任务
function TaskManage:GetFirstOverTask()
    for i = 1, self._allTaskList:Count() do
        if self._allTaskList:Get(i):GetRewardState() == true then
            return self._allTaskList:Get(i);
        end
    end

    return nil;
end

function TaskManage:UpdateCurrencyTaskState()
    local list = self:GetAllCurrencyTask();
    if list:Count() <= 0 then
        return;
    end

    for i = 1, list:Count() do
        if list:Get(i):GetRewardState() == true then
            
        else
            
        end
    end
end

function TaskManage:GetAllCurrencyTask()
    local list = List.new();
    for i = 1, self._allTaskList:Count() do
        local tableId = self._allTaskList:Get(i):GetTableId();
        local tableData = DataQuest[tableId];
        if tableData ~= nil and tableData.QuestType == 24 then
            list:Push(self._allTaskList:Get(i));
        end
    end
    return list;
end

-- 任务列表请求
function TaskManage:OpenTaskListRequest()
    local msg = require("MessageCommon/Msg/C2L/Task/OpenTaskListRequest").new();
    msg:SetMessageId(C2L_Task.OpenTaskListRequest);
    NetService:Instance():SendMessage(msg);
end

-- 领取任务请求
function TaskManage:AwardRequest(requestId)
    local msg = require("MessageCommon/Msg/C2L/Task/AwardRequest").new();
    msg:SetMessageId(C2L_Task.AwardRequest);
    msg.taskId = requestId;
    NetService:Instance():SendMessage(msg);
end

return TaskManage;

--endregion
