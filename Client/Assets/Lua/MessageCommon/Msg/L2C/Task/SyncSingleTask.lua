--
-- 逻辑服务器 --> 客户端
-- 任务model
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local SyncSingleTask = class("SyncSingleTask", GameMessage);

--
-- 构造函数
--
function SyncSingleTask:ctor()
    SyncSingleTask.super.ctor(self);
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
    self.list = List.new();
end

--@Override
function SyncSingleTask:_OnSerial() 
    self:WriteInt64(self.taskId);
    self:WriteInt32(self.taskTableId);
    self:WriteInt32(self.taskState);
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        self:WriteInt32(self.list:Get(listIndex));
    end
end

--@Override
function SyncSingleTask:_OnDeserialize() 
    self.taskId = self:ReadInt64();
    self.taskTableId = self:ReadInt32();
    self.taskState = self:ReadInt32();
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        self.list:Push(self:ReadInt32());
    end
end

return SyncSingleTask;
