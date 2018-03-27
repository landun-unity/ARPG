--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local List = require("common/List");
local Task = class("Task");

require("Game/Table/model/DataQuest")

function Task:ctor()
    -- 对应任务表里的id
    self._tableId = 0;
    -- 唯一id（请求使用）
    self._requestId = 0;
    -- 是否是战略目标
    self._isTarget = false;
    -- 是否可领奖励
    self._canReward = false;
    -- 完成进度
    self._completeSchedule = List.new();
end

function Task:InitData(tableId, requestId, canReward, list)
    self._tableId = tableId;
    self._requestId = requestId;
    self._canReward = (canReward == 1);
    self._isTarget = (DataQuest[tableId].Type == 1);
    self._completeSchedule:Clear();
    for i = 1, list:Count() do
        self._completeSchedule:Push(list:Get(i));
    end
end

function Task:RefreshData(canReward, list)
    self._canReward = (canReward == 1);
    self._completeSchedule:Clear();
    for i = 1, list:Count() do
        self._completeSchedule:Push(list:Get(i));
    end
end

function Task:GetTableId()
    return self._tableId;
end

function Task:GetRequestId()
    return self._requestId;
end

function Task:GetIsTarget()
    return self._isTarget;
end 

function Task:GetRewardState()
    return self._canReward;
end

function Task:GetSchedule()
    return self._completeSchedule;
end

return Task;

--endregion
