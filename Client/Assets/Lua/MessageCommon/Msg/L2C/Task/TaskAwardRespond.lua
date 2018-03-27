--
-- 逻辑服务器 --> 客户端
-- 任务领奖回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local TaskAwardRespond = class("TaskAwardRespond", GameMessage);

--
-- 构造函数
--
function TaskAwardRespond:ctor()
    TaskAwardRespond.super.ctor(self);
    --
    -- 完成任务tableid
    --
    self.taskTableId = 0;
end

--@Override
function TaskAwardRespond:_OnSerial() 
    self:WriteInt32(self.taskTableId);
end

--@Override
function TaskAwardRespond:_OnDeserialize() 
    self.taskTableId = self:ReadInt32();
end

return TaskAwardRespond;
